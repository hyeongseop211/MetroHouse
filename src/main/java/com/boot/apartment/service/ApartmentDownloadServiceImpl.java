package com.boot.apartment.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.apartment.dao.ApartmentDownloadDAO;
import com.boot.apartment.dto.ApartmentTradeDTO;

@Service
public class ApartmentDownloadServiceImpl implements ApartmentDownloadService {
	private static final Logger logger = LoggerFactory.getLogger(ApartmentDownloadServiceImpl.class);

	@Autowired
	private ApartmentDownloadDAO apartmentDownloadDAO;

	@Autowired
	private ApartmentTradeService apartmentTradeService;

	// 수집 작업 상태 추적을 위한 맵
	private Map<String, Object> collectionStatus = new ConcurrentHashMap<>();

	/**
	 * 전국 아파트 데이터를 수집하여 APARTMENTINFO 테이블에 저장 (최신 데이터용)
	 * 
	 * @param yearMonth 수집할 연월 (YYYYMM 형식)
	 * @return 처리된 아파트 정보 수
	 */
	@Override
	@Transactional
	public int downloadApartmentinfo(String yearMonth) {
		if (yearMonth == null || yearMonth.isEmpty()) {
			// 기본값으로 현재 월 설정 (최신 데이터)
			LocalDate currentMonth = LocalDate.now();
			yearMonth = currentMonth.format(DateTimeFormatter.ofPattern("yyyyMM"));
		}

		final String finalYearMonth = yearMonth;

		logger.info("전국 아파트 거래 정보 수집 시작: {}년 {}월", yearMonth.substring(0, 4), yearMonth.substring(4));

		// 수집 상태 초기화
		collectionStatus.clear();
		collectionStatus.put("status", "running");
		collectionStatus.put("startTime", System.currentTimeMillis());
		collectionStatus.put("yearMonth", yearMonth);

		// 전국 시군구 코드 목록 가져오기
		Map<String, String> regionCodes = getAllRegionCodes();

		// 처리 상태 추적
		AtomicInteger processedCount = new AtomicInteger(0);
		AtomicInteger totalRegions = new AtomicInteger(regionCodes.size());
		AtomicInteger successCount = new AtomicInteger(0);
		AtomicInteger failCount = new AtomicInteger(0);
		AtomicInteger totalSavedCount = new AtomicInteger(0);

		collectionStatus.put("totalRegions", totalRegions.get());
		collectionStatus.put("processedRegions", processedCount.get());
		collectionStatus.put("successRegions", successCount.get());
		collectionStatus.put("failRegions", failCount.get());
		collectionStatus.put("totalSaved", totalSavedCount.get());

		// 병렬 처리를 위한 스레드 풀 (API 호출 제한 고려하여 스레드 수 제한)
		ExecutorService executor = Executors.newFixedThreadPool(1);

		try {
			// 각 지역별로 데이터 수집 작업 제출
			for (Map.Entry<String, String> region : regionCodes.entrySet()) {
				String regionCode = region.getKey();
				String regionName = region.getValue();

				executor.submit(() -> {
					try {
						logger.info("[{}/{}] {} ({}) 아파트 정보 수집 시작", processedCount.incrementAndGet(),
								totalRegions.get(), regionName, regionCode);

						collectionStatus.put("currentRegion", regionName);
						collectionStatus.put("processedRegions", processedCount.get());

						// API에서 데이터 가져오기
						List<ApartmentTradeDTO> apartments = apartmentTradeService.getTradeData(regionCode,
								finalYearMonth, "50");

						if (apartments != null && !apartments.isEmpty()) {
							// 연월 정보 설정
							for (ApartmentTradeDTO apt : apartments) {
								apt.setDealYear(finalYearMonth.substring(0, 4));
								apt.setDealMonth(finalYearMonth.substring(4));
							}

							// APARTMENTINFO 테이블에 직접 저장 (최신 데이터)
							int savedCount = saveApartmentsOneByOne(apartments);
							totalSavedCount.addAndGet(savedCount);

							logger.info("[{}/{}] {} ({}) 아파트 정보 {}개 저장 완료", processedCount.get(), totalRegions.get(),
									regionName, regionCode, savedCount);
							successCount.incrementAndGet();

							collectionStatus.put("successRegions", successCount.get());
							collectionStatus.put("totalSaved", totalSavedCount.get());
						} else {
							logger.info("[{}/{}] {} ({}) 아파트 정보 없음", processedCount.get(), totalRegions.get(),
									regionName, regionCode);
							successCount.incrementAndGet();

							collectionStatus.put("successRegions", successCount.get());
						}
					} catch (Exception e) {
						logger.error("[{}/{}] {} ({}) 아파트 정보 수집 실패: {}", processedCount.get(), totalRegions.get(),
								regionName, regionCode, e.getMessage());
						failCount.incrementAndGet();

						collectionStatus.put("failRegions", failCount.get());
					}

					// API 호출 제한 고려하여 딜레이 추가
					try {
						Thread.sleep(2000);
					} catch (InterruptedException e) {
						Thread.currentThread().interrupt();
					}
				});
			}

			// 모든 작업이 완료될 때까지 대기
			executor.shutdown();
			executor.awaitTermination(3, TimeUnit.HOURS);

			logger.info("전국 아파트 거래 정보 수집 완료. 총 {}개 지역 중 성공: {}개, 실패: {}개, 수집된 아파트 정보: {}개", totalRegions.get(),
					successCount.get(), failCount.get(), totalSavedCount.get());

			// 수집 상태 업데이트
			collectionStatus.put("status", "completed");
			collectionStatus.put("endTime", System.currentTimeMillis());
			collectionStatus.put("totalSaved", totalSavedCount.get());

			return totalSavedCount.get();

		} catch (Exception e) {
			logger.error("아파트 정보 수집 중 오류 발생: {}", e.getMessage());
			e.printStackTrace();

			// 수집 상태 업데이트
			collectionStatus.put("status", "failed");
			collectionStatus.put("endTime", System.currentTimeMillis());
			collectionStatus.put("errorMessage", e.getMessage());

			throw new RuntimeException("아파트 정보 수집 실패", e);
		} finally {
			if (!executor.isTerminated()) {
				executor.shutdownNow();
			}
		}
	}

	/**
	 * 과거 N년치 아파트 데이터를 수집하여 APARTMENTINFO_QUEUE 테이블에 저장
	 * 
	 * @param years 과거 몇 년치 데이터를 수집할지 지정 (기본값 10년)
	 * @return 처리된 아파트 정보 수
	 */
	@Override
	@Transactional
	public int downloadHistoricalApartmentinfo(int years) {
		if (years <= 0) {
			years = 10; // 기본값 10년
		}
		
		// 현재 날짜 기준으로 N년 전부터 현재까지의 연월 목록 생성
		List<String> yearMonths = generateYearMonthList(years);
		
		logger.info("과거 {}년치 아파트 거래 정보 수집 시작 (각 년도 1월 데이터만): {} ~ {}", 
		        years, yearMonths.get(yearMonths.size()-1), yearMonths.get(0));
		// 수집 상태 초기화
		collectionStatus.clear();
		collectionStatus.put("status", "running");
		collectionStatus.put("startTime", System.currentTimeMillis());
		collectionStatus.put("mode", "historical");
		collectionStatus.put("yearMonths", yearMonths);

		// 전국 시군구 코드 목록 가져오기 (서울만 처리하도록 제한 가능)
		Map<String, String> regionCodes = getSeoulRegionCodes(); // 서울만 처리하는 예시

		// 처리 상태 추적
		AtomicInteger processedCount = new AtomicInteger(0);
		AtomicInteger totalRegions = new AtomicInteger(regionCodes.size() * yearMonths.size());
		AtomicInteger successCount = new AtomicInteger(0);
		AtomicInteger failCount = new AtomicInteger(0);
		AtomicInteger totalSavedCount = new AtomicInteger(0);

		collectionStatus.put("totalRegions", totalRegions.get());
		collectionStatus.put("processedRegions", processedCount.get());
		collectionStatus.put("successRegions", successCount.get());
		collectionStatus.put("failRegions", failCount.get());
		collectionStatus.put("totalSaved", totalSavedCount.get());

		// 병렬 처리를 위한 스레드 풀 (API 호출 제한 고려하여 스레드 수 제한)
		ExecutorService executor = Executors.newFixedThreadPool(1);

		try {
			// 각 연월별, 지역별로 데이터 수집 작업 제출
			for (String yearMonth : yearMonths) {
				for (Map.Entry<String, String> region : regionCodes.entrySet()) {
					String regionCode = region.getKey();
					String regionName = region.getValue();

					executor.submit(() -> {
						try {
							logger.info("[{}/{}] {} ({}) {}년 {}월 아파트 정보 수집 시작", 
									processedCount.incrementAndGet(),
									totalRegions.get(), regionName, regionCode, 
									yearMonth.substring(0, 4), yearMonth.substring(4));

							collectionStatus.put("currentRegion", regionName);
							collectionStatus.put("currentYearMonth", yearMonth);
							collectionStatus.put("processedRegions", processedCount.get());

							// API에서 데이터 가져오기
							List<ApartmentTradeDTO> apartments = apartmentTradeService.getTradeData(regionCode,
									yearMonth, "50");

							if (apartments != null && !apartments.isEmpty()) {
								// 연월 정보 설정
								for (ApartmentTradeDTO apt : apartments) {
									apt.setDealYear(yearMonth.substring(0, 4));
									apt.setDealMonth(yearMonth.substring(4));
								}

								// APARTMENTINFO_QUEUE 테이블에 저장 (과거 데이터)
								int savedCount = saveApartmentsToQueue(apartments);
								totalSavedCount.addAndGet(savedCount);

								logger.info("[{}/{}] {} ({}) {}년 {}월 아파트 정보 {}개 큐에 저장 완료", 
										processedCount.get(), totalRegions.get(),
										regionName, regionCode, yearMonth.substring(0, 4), yearMonth.substring(4), 
										savedCount);
								successCount.incrementAndGet();

								collectionStatus.put("successRegions", successCount.get());
								collectionStatus.put("totalSaved", totalSavedCount.get());
							} else {
								logger.info("[{}/{}] {} ({}) {}년 {}월 아파트 정보 없음", 
										processedCount.get(), totalRegions.get(),
										regionName, regionCode, yearMonth.substring(0, 4), yearMonth.substring(4));
								successCount.incrementAndGet();

								collectionStatus.put("successRegions", successCount.get());
							}
						} catch (Exception e) {
							logger.error("[{}/{}] {} ({}) {}년 {}월 아파트 정보 수집 실패: {}", 
									processedCount.get(), totalRegions.get(),
									regionName, regionCode, yearMonth.substring(0, 4), yearMonth.substring(4), 
									e.getMessage());
							failCount.incrementAndGet();

							collectionStatus.put("failRegions", failCount.get());
						}

						// API 호출 제한 고려하여 딜레이 추가
						try {
							Thread.sleep(2000);
						} catch (InterruptedException e) {
							Thread.currentThread().interrupt();
						}
					});
				}
			}

			// 모든 작업이 완료될 때까지 대기
			executor.shutdown();
			executor.awaitTermination(24, TimeUnit.HOURS); // 과거 데이터는 시간이 더 오래 걸릴 수 있음

			logger.info("과거 {}년치 아파트 거래 정보 수집 완료. 총 {}개 지역-연월 중 성공: {}개, 실패: {}개, 수집된 아파트 정보: {}개", 
					years, totalRegions.get(), successCount.get(), failCount.get(), totalSavedCount.get());

			// 수집 상태 업데이트
			collectionStatus.put("status", "completed");
			collectionStatus.put("endTime", System.currentTimeMillis());
			collectionStatus.put("totalSaved", totalSavedCount.get());

			return totalSavedCount.get();

		} catch (Exception e) {
			logger.error("과거 아파트 정보 수집 중 오류 발생: {}", e.getMessage());
			e.printStackTrace();

			// 수집 상태 업데이트
			collectionStatus.put("status", "failed");
			collectionStatus.put("endTime", System.currentTimeMillis());
			collectionStatus.put("errorMessage", e.getMessage());

			throw new RuntimeException("과거 아파트 정보 수집 실패", e);
		} finally {
			if (!executor.isTerminated()) {
				executor.shutdownNow();
			}
		}
	}

	/**
	 * 현재 날짜로부터 지정된 년수만큼 이전까지의 연월 목록 생성 (각 년도의 1월만)
	 * 
	 * @param years 과거 몇 년치 데이터를 가져올지 지정
	 * @return 연월 목록 (YYYYMM 형식)
	 */
	private List<String> generateYearMonthList(int years) {
	    List<String> yearMonths = new ArrayList<>();
	    LocalDate now = LocalDate.now();
	    int currentYear = now.getYear();
	    
	    // 현재 년도부터 지정된 년수만큼 이전까지 각 년도의 1월만 추가
	    for (int i = 0; i < years; i++) {
	        int year = currentYear - i;
	        yearMonths.add(String.format("%d01", year)); // YYYY01 형식 (1월)
	    }
	    
	    return yearMonths;
	}

	/**
	 * 부산 시군구 코드만 반환 (과거 데이터 처리 시 부하 감소를 위해)
	 */
	private Map<String, String> getSeoulRegionCodes() {
		Map<String, String> regionCodes = new LinkedHashMap<>();

		// 부산광역시
		regionCodes.put("26440", "부산광역시 강서구");
		regionCodes.put("26410", "부산광역시 금정구");
		regionCodes.put("26710", "부산광역시 기장군");
		regionCodes.put("26290", "부산광역시 남구");
		regionCodes.put("26170", "부산광역시 동구");
		regionCodes.put("26260", "부산광역시 동래구");
		regionCodes.put("26230", "부산광역시 부산진구");
		regionCodes.put("26320", "부산광역시 북구");
		regionCodes.put("26530", "부산광역시 사상구");
		regionCodes.put("26380", "부산광역시 사하구");
		regionCodes.put("26140", "부산광역시 서구");
		regionCodes.put("26500", "부산광역시 수영구");
		regionCodes.put("26470", "부산광역시 연제구");
		regionCodes.put("26200", "부산광역시 영도구");
		regionCodes.put("26110", "부산광역시 중구");
		regionCodes.put("26350", "부산광역시 해운대구");
		
		return regionCodes;
	}

	/**
	 * 특정 지역의 아파트 거래 데이터 조회
	 */
	@Override
	public List<ApartmentTradeDTO> getRegionTradeData(String sigunguCode, String yearMonth) {
		try {
			return apartmentTradeService.getTradeData(sigunguCode, yearMonth);
		} catch (Exception e) {
			logger.error("지역 거래 데이터 조회 중 오류 발생: {}", e.getMessage());
			return Collections.emptyList();
		}
	}

	/**
	 * 특정 지역의 아파트 거래 데이터를 페이지 단위로 조회
	 */
	@Override
	public List<ApartmentTradeDTO> getRegionTradeDataPaged(String sigunguCode, String yearMonth, int pageNo,
			int numOfRows) {
		try {
			return apartmentTradeService.getTradeData(sigunguCode, yearMonth, String.valueOf(numOfRows));
		} catch (Exception e) {
			logger.error("페이지 단위 거래 데이터 조회 중 오류 발생: {}", e.getMessage());
			return Collections.emptyList();
		}
	}

	/**
	 * 데이터베이스에 저장된 아파트 정보 조회
	 */
	@Override
	public List<ApartmentTradeDTO> getStoredApartmentData(String yearMonth) {
		try {
			Map<String, Object> params = new HashMap<>();
			params.put("yearMonth", yearMonth);
			return apartmentDownloadDAO.getApartmentDataByYearMonth(params);
		} catch (Exception e) {
			logger.error("저장된 아파트 데이터 조회 중 오류 발생: {}", e.getMessage());
			return Collections.emptyList();
		}
	}

	/**
	 * 특정 연월의 아파트 데이터 수집 상태 확인
	 */
	@Override
	public boolean isDataCollectionCompleted(String yearMonth) {
		try {
			Map<String, Object> params = new HashMap<>();
			params.put("yearMonth", yearMonth);
			Integer count = apartmentDownloadDAO.countApartmentDataByYearMonth(params);
			return count != null && count > 0;
		} catch (Exception e) {
			logger.error("데이터 수집 상태 확인 중 오류 발생: {}", e.getMessage());
			return false;
		}
	}

	/**
	 * 아파트 데이터 수집 작업 상태 조회
	 */
	@Override
	public Map<String, Object> getCollectionStatus() {
		return new HashMap<>(collectionStatus);
	}

	/**
	 * 특정 연월의 아파트 데이터 삭제
	 */
	@Override
	@Transactional
	public int deleteApartmentData(String yearMonth) {
		try {
			Map<String, Object> params = new HashMap<>();
			params.put("yearMonth", yearMonth);
			return apartmentDownloadDAO.deleteApartmentDataByYearMonth(params);
		} catch (Exception e) {
			logger.error("아파트 데이터 삭제 중 오류 발생: {}", e.getMessage());
			return 0;
		}
	}

	/**
	 * 큐 테이블의 데이터 조회
	 */
	@Override
	public List<ApartmentTradeDTO> getQueueData() {
		try {
			return apartmentDownloadDAO.getQueueData();
		} catch (Exception e) {
			logger.error("큐 데이터 조회 중 오류 발생: {}", e.getMessage());
			return Collections.emptyList();
		}
	}

	/**
	 * 큐 테이블의 데이터 개수 조회
	 */
	@Override
	public int countQueueData() {
		try {
			Integer count = apartmentDownloadDAO.countQueueData();
			return count != null ? count : 0;
		} catch (Exception e) {
			logger.error("큐 데이터 개수 조회 중 오류 발생: {}", e.getMessage());
			return 0;
		}
	}

	/**
	 * 큐 테이블의 처리 상태 초기화
	 */
	@Override
	@Transactional
	public int resetQueueProcessedStatus() {
		try {
			return apartmentDownloadDAO.resetQueueProcessedStatus();
		} catch (Exception e) {
			logger.error("큐 처리 상태 초기화 중 오류 발생: {}", e.getMessage());
			return 0;
		}
	}

	/**
	 * 프로시저 실행 후 처리된 큐 데이터 삭제
	 */
	@Override
	@Transactional
	public int deleteProcessedQueueData() {
		try {
			return apartmentDownloadDAO.deleteProcessedQueueData();
		} catch (Exception e) {
			logger.error("처리된 큐 데이터 삭제 중 오류 발생: {}", e.getMessage());
			return 0;
		}
	}

	/**
	 * 아파트 정보를 APARTMENTINFO 테이블에 저장 (최신 데이터용)
	 * 
	 * @param apartments 저장할 아파트 정보 목록
	 * @return 저장된 데이터 수
	 */
	private int saveApartmentsOneByOne(List<ApartmentTradeDTO> apartments) {
		int successCount = 0;
		int totalCount = apartments.size();

		// 트랜잭션 관리를 위한 배치 크기
		final int BATCH_SIZE = 50;
		int currentBatchCount = 0;

		try {
			for (ApartmentTradeDTO apt : apartments) {
				try {
					// null 값 처리
					preprocessApartmentData(apt);

					// 단일 레코드 삽입
					apartmentDownloadDAO.insertApartmentInfo(apt);
					successCount++;
					currentBatchCount++;

					// 일정 개수마다 로깅
					if (successCount % 100 == 0) {
						logger.info("아파트 정보 저장 진행 중: {}/{} ({}%)", successCount, totalCount,
								(successCount * 100 / totalCount));
					}

					// 배치 크기에 도달하면 잠시 대기 (DB 부하 분산)
					if (currentBatchCount >= BATCH_SIZE) {
						currentBatchCount = 0;
						Thread.sleep(1000); // 1초 대기
					}
				} catch (Exception e) {
					logger.error("아파트 정보 저장 중 오류 발생: {} - {}", e.getMessage(), apt.toString());
				}
			}

			logger.info("아파트 정보 저장 완료: 총 {}개 중 {}개 성공", totalCount, successCount);
			return successCount;
		} catch (Exception e) {
			logger.error("데이터베이스 저장 중 오류 발생: {}", e.getMessage());
			throw new RuntimeException("데이터베이스 저장 실패", e);
		}
	}

	/**
	 * 아파트 정보를 APARTMENTINFO_QUEUE 테이블에 저장 (과거 데이터용)
	 * 
	 * @param apartments 저장할 아파트 정보 목록
	 * @return 저장된 데이터 수
	 */
	private int saveApartmentsToQueue(List<ApartmentTradeDTO> apartments) {
		int successCount = 0;
		int totalCount = apartments.size();

		// 트랜잭션 관리를 위한 배치 크기
		final int BATCH_SIZE = 50;
		int currentBatchCount = 0;

		try {
			for (ApartmentTradeDTO apt : apartments) {
				try {
					// null 값 처리
					preprocessApartmentData(apt);

					// APARTMENTINFO_QUEUE 테이블에 삽입
					apartmentDownloadDAO.insertToQueue(apt);
					successCount++;
					currentBatchCount++;

					// 일정 개수마다 로깅
					if (successCount % 100 == 0) {
						logger.info("아파트 정보 큐 저장 진행 중: {}/{} ({}%)", successCount, totalCount,
								(successCount * 100 / totalCount));
					}

					// 배치 크기에 도달하면 잠시 대기 (DB 부하 분산)
					if (currentBatchCount >= BATCH_SIZE) {
						currentBatchCount = 0;
						Thread.sleep(1000); // 1초 대기
					}
				} catch (Exception e) {
					logger.error("아파트 정보 큐 저장 중 오류 발생: {} - {}", e.getMessage(), apt.toString());
				}
			}

			logger.info("아파트 정보 큐 저장 완료: 총 {}개 중 {}개 성공", totalCount, successCount);
			return successCount;
		} catch (Exception e) {
			logger.error("데이터베이스 큐 저장 중 오류 발생: {}", e.getMessage());
			throw new RuntimeException("데이터베이스 큐 저장 실패", e);
		}
	}

	/**
	 * 아파트 데이터의 null 값을 처리
	 * 
	 * @param apt 처리할 아파트 정보
	 */
	private void preprocessApartmentData(ApartmentTradeDTO apt) {
		// 필수 필드 null 체크 및 빈 문자열로 변환
		if (apt.getSggCd() == null) apt.setSggCd("");
		if (apt.getUmdNm() == null) apt.setUmdNm("");
		if (apt.getAptNm() == null) apt.setAptNm("");
		if (apt.getJibun() == null) apt.setJibun("");
		if (apt.getDealYear() == null) apt.setDealYear("");
		if (apt.getDealMonth() == null) apt.setDealMonth("");
		if (apt.getDealDay() == null) apt.setDealDay("");
		if (apt.getDealAmount() == null) apt.setDealAmount("");
		if (apt.getFloor() == null) apt.setFloor("");
		if (apt.getBuildYear() == null) apt.setBuildYear("");
		if (apt.getExcluUseAr() == null) apt.setExcluUseAr("");

		// 추가 필드 null 체크
		if (apt.getCdealType() == null) apt.setCdealType("");
		if (apt.getCdealDay() == null) apt.setCdealDay("");
		if (apt.getDealingGbn() == null) apt.setDealingGbn("");
		if (apt.getEstateAgentSggNm() == null) apt.setEstateAgentSggNm("");
		if (apt.getRgstDate() == null) apt.setRgstDate("");
		if (apt.getAptDong() == null) apt.setAptDong("");
		if (apt.getSlerGbn() == null) apt.setSlerGbn("");
		if (apt.getBuyerGbn() == null) apt.setBuyerGbn("");
		if (apt.getLandLeaseHoldGbn() == null) apt.setLandLeaseHoldGbn("");
		if (apt.getAptSeq() == null) apt.setAptSeq("");
		if (apt.getBonbun() == null) apt.setBonbun("");
		if (apt.getBubun() == null) apt.setBubun("");
		if (apt.getLandCd() == null) apt.setLandCd("");
		if (apt.getRoadNm() == null) apt.setRoadNm("");
		if (apt.getRoadNmBonbun() == null) apt.setRoadNmBonbun("");
		if (apt.getRoadNmBubun() == null) apt.setRoadNmBubun("");
		if (apt.getRoadNmCd() == null) apt.setRoadNmCd("");
		if (apt.getRoadNmSeq() == null) apt.setRoadNmSeq("");
		if (apt.getRoadNmSggCd() == null) apt.setRoadNmSggCd("");
		if (apt.getRoadNmBCd() == null) apt.setRoadNmBCd("");
		if (apt.getUmdCd() == null) apt.setUmdCd("");
		if (apt.getSubwayStation() == null) apt.setSubwayStation("");
		if (apt.getSubwayDistance() == null) apt.setSubwayDistance("");
	}

	private Map<String, String> getAllRegionCodes() {
		Map<String, String> regionCodes = new LinkedHashMap<>();

		// 서울특별시
		regionCodes.put("11680", "서울특별시 강남구");
		regionCodes.put("11740", "서울특별시 강동구");
		regionCodes.put("11305", "서울특별시 강북구");
		regionCodes.put("11500", "서울특별시 강서구");
		regionCodes.put("11620", "서울특별시 관악구");
		regionCodes.put("11215", "서울특별시 광진구");
		regionCodes.put("11530", "서울특별시 구로구");
		regionCodes.put("11545", "서울특별시 금천구");
		regionCodes.put("11350", "서울특별시 노원구");
		regionCodes.put("11320", "서울특별시 도봉구");
		regionCodes.put("11230", "서울특별시 동대문구");
		regionCodes.put("11590", "서울특별시 동작구");
		regionCodes.put("11440", "서울특별시 마포구");
		regionCodes.put("11410", "서울특별시 서대문구");
		regionCodes.put("11650", "서울특별시 서초구");
		regionCodes.put("11200", "서울특별시 성동구");
		regionCodes.put("11290", "서울특별시 성북구");
		regionCodes.put("11710", "서울특별시 송파구");
		regionCodes.put("11470", "서울특별시 양천구");
		regionCodes.put("11560", "서울특별시 영등포구");
		regionCodes.put("11170", "서울특별시 용산구");
		regionCodes.put("11380", "서울특별시 은평구");
		regionCodes.put("11110", "서울특별시 종로구");
		regionCodes.put("11140", "서울특별시 중구");
		regionCodes.put("11260", "서울특별시 중랑구");
//
//		// 부산광역시
		regionCodes.put("26440", "부산광역시 강서구");
		regionCodes.put("26410", "부산광역시 금정구");
		regionCodes.put("26710", "부산광역시 기장군");
		regionCodes.put("26290", "부산광역시 남구");
		regionCodes.put("26170", "부산광역시 동구");
		regionCodes.put("26260", "부산광역시 동래구");
		regionCodes.put("26230", "부산광역시 부산진구");
		regionCodes.put("26320", "부산광역시 북구");
		regionCodes.put("26530", "부산광역시 사상구");
		regionCodes.put("26380", "부산광역시 사하구");
		regionCodes.put("26140", "부산광역시 서구");
		regionCodes.put("26500", "부산광역시 수영구");
		regionCodes.put("26470", "부산광역시 연제구");
		regionCodes.put("26200", "부산광역시 영도구");
		regionCodes.put("26110", "부산광역시 중구");
		regionCodes.put("26350", "부산광역시 해운대구");
//
//		// 대구광역시
//		regionCodes.put("27200", "대구광역시 남구");
//		regionCodes.put("27290", "대구광역시 달서구");
//		regionCodes.put("27710", "대구광역시 달성군");
//		regionCodes.put("27140", "대구광역시 동구");
//		regionCodes.put("27230", "대구광역시 북구");
//		regionCodes.put("27170", "대구광역시 서구");
//		regionCodes.put("27260", "대구광역시 수성구");
//		regionCodes.put("27110", "대구광역시 중구");
//
//		// 인천광역시
//		regionCodes.put("28710", "인천광역시 강화군");
//		regionCodes.put("28245", "인천광역시 계양구");
//		regionCodes.put("28200", "인천광역시 남동구");
//		regionCodes.put("28140", "인천광역시 동구");
//		regionCodes.put("28177", "인천광역시 미추홀구");
//		regionCodes.put("28237", "인천광역시 부평구");
//		regionCodes.put("28260", "인천광역시 서구");
//		regionCodes.put("28185", "인천광역시 연수구");
//		regionCodes.put("28720", "인천광역시 옹진군");
//		regionCodes.put("28110", "인천광역시 중구");
//
//		// 광주광역시
//		regionCodes.put("29200", "광주광역시 광산구");
//		regionCodes.put("29155", "광주광역시 남구");
//		regionCodes.put("29110", "광주광역시 동구");
//		regionCodes.put("29170", "광주광역시 북구");
//		regionCodes.put("29140", "광주광역시 서구");
//
//		// 대전광역시
//		regionCodes.put("30230", "대전광역시 대덕구");
//		regionCodes.put("30110", "대전광역시 동구");
//		regionCodes.put("30170", "대전광역시 서구");
//		regionCodes.put("30200", "대전광역시 유성구");
//		regionCodes.put("30140", "대전광역시 중구");
//
//		// 울산광역시
//		regionCodes.put("31140", "울산광역시 남구");
//		regionCodes.put("31170", "울산광역시 동구");
//		regionCodes.put("31200", "울산광역시 북구");
//		regionCodes.put("31710", "울산광역시 울주군");
//		regionCodes.put("31110", "울산광역시 중구");
//
//		// 세종특별자치시
//		regionCodes.put("36110", "세종특별자치시");
//
//		// 경기도
//		regionCodes.put("41820", "경기도 가평군");
//		regionCodes.put("41280", "경기도 고양시");
//		regionCodes.put("41281", "경기도 고양시 덕양구");
//		regionCodes.put("41285", "경기도 고양시 일산동구");
//		regionCodes.put("41287", "경기도 고양시 일산서구");
//		regionCodes.put("41290", "경기도 과천시");
//		regionCodes.put("41210", "경기도 광명시");
//		regionCodes.put("41610", "경기도 광주시");
//		regionCodes.put("41310", "경기도 구리시");
//		regionCodes.put("41410", "경기도 군포시");
//		regionCodes.put("41570", "경기도 김포시");
//		regionCodes.put("41360", "경기도 남양주시");
//		regionCodes.put("41250", "경기도 동두천시");
//		regionCodes.put("41190", "경기도 부천시");
//		regionCodes.put("41130", "경기도 성남시");
//		regionCodes.put("41131", "경기도 성남시 수정구");
//		regionCodes.put("41133", "경기도 성남시 분당구");
//		regionCodes.put("41135", "경기도 성남시 중원구");
//		regionCodes.put("41110", "경기도 수원시");
//		regionCodes.put("41111", "경기도 수원시 장안구");
//		regionCodes.put("41113", "경기도 수원시 팔달구");
//		regionCodes.put("41115", "경기도 수원시 영통구");
//		regionCodes.put("41117", "경기도 수원시 권선구");
//		regionCodes.put("41390", "경기도 시흥시");
//		regionCodes.put("41270", "경기도 안산시");
//		regionCodes.put("41273", "경기도 안산시 단원구");
//		regionCodes.put("41271", "경기도 안산시 상록구");
//		regionCodes.put("41550", "경기도 안성시");
//		regionCodes.put("41170", "경기도 안양시");
//		regionCodes.put("41173", "경기도 안양시 만안구");
//		regionCodes.put("41171", "경기도 안양시 동안구");
//		regionCodes.put("41630", "경기도 양주시");
//		regionCodes.put("41830", "경기도 양평군");
//		regionCodes.put("41670", "경기도 여주시");
//		regionCodes.put("41800", "경기도 연천군");
//		regionCodes.put("41370", "경기도 오산시");
//		regionCodes.put("41460", "경기도 용인시");
//		regionCodes.put("41461", "경기도 용인시 처인구");
//		regionCodes.put("41463", "경기도 용인시 기흥구");
//		regionCodes.put("41465", "경기도 용인시 수지구");
//		regionCodes.put("41430", "경기도 의왕시");
//		regionCodes.put("41150", "경기도 의정부시");
//		regionCodes.put("41500", "경기도 이천시");
//		regionCodes.put("41480", "경기도 파주시");
//		regionCodes.put("41220", "경기도 평택시");
//		regionCodes.put("41650", "경기도 포천시");
//		regionCodes.put("41450", "경기도 하남시");
//		regionCodes.put("41590", "경기도 화성시");
//
//		// 강원도
//		regionCodes.put("42150", "강원도 강릉시");
//		regionCodes.put("42820", "강원도 고성군");
//		regionCodes.put("42170", "강원도 동해시");
//		regionCodes.put("42230", "강원도 삼척시");
//		regionCodes.put("42210", "강원도 속초시");
//		regionCodes.put("42800", "강원도 양구군");
//		regionCodes.put("42830", "강원도 양양군");
//		regionCodes.put("42750", "강원도 영월군");
//		regionCodes.put("42130", "강원도 원주시");
//		regionCodes.put("42810", "강원도 인제군");
//		regionCodes.put("42770", "강원도 정선군");
//		regionCodes.put("42780", "강원도 철원군");
//		regionCodes.put("42110", "강원도 춘천시");
//		regionCodes.put("42190", "강원도 태백시");
//		regionCodes.put("42760", "강원도 평창군");
//		regionCodes.put("42720", "강원도 홍천군");
//		regionCodes.put("42730", "강원도 화천군");
//		regionCodes.put("42790", "강원도 횡성군");
//
//		// 충청북도
//		regionCodes.put("43760", "충청북도 괴산군");
//		regionCodes.put("43800", "충청북도 단양군");
//		regionCodes.put("43720", "충청북도 보은군");
//		regionCodes.put("43740", "충청북도 영동군");
//		regionCodes.put("43730", "충청북도 옥천군");
//		regionCodes.put("43770", "충청북도 음성군");
//		regionCodes.put("43150", "충청북도 제천시");
//		regionCodes.put("43745", "충청북도 증평군");
//		regionCodes.put("43110", "충청북도 청주시");
//		regionCodes.put("43111", "충청북도 청주시 상당구");
//		regionCodes.put("43112", "충청북도 청주시 서원구");
//		regionCodes.put("43113", "충청북도 청주시 흥덕구");
//		regionCodes.put("43114", "충청북도 청주시 청원구");
//		regionCodes.put("43750", "충청북도 진천군");
//		regionCodes.put("43130", "충청북도 충주시");
//
//		// 충청남도
//		regionCodes.put("44250", "충청남도 계룡시");
//		regionCodes.put("44150", "충청남도 공주시");
//		regionCodes.put("44710", "충청남도 금산군");
//		regionCodes.put("44230", "충청남도 논산시");
//		regionCodes.put("44270", "충청남도 당진시");
//		regionCodes.put("44180", "충청남도 보령시");
//		regionCodes.put("44760", "충청남도 부여군");
//		regionCodes.put("44210", "충청남도 서산시");
//		regionCodes.put("44770", "충청남도 서천군");
//		regionCodes.put("44200", "충청남도 아산시");
//		regionCodes.put("44810", "충청남도 예산군");
//		regionCodes.put("44130", "충청남도 천안시");
//		regionCodes.put("44131", "충청남도 천안시 동남구");
//		regionCodes.put("44133", "충청남도 천안시 서북구");
//		regionCodes.put("44790", "충청남도 청양군");
//		regionCodes.put("44825", "충청남도 태안군");
//		regionCodes.put("44800", "충청남도 홍성군");
//
//		// 전라북도
//		regionCodes.put("45790", "전라북도 고창군");
//		regionCodes.put("45130", "전라북도 군산시");
//		regionCodes.put("45210", "전라북도 김제시");
//		regionCodes.put("45190", "전라북도 남원시");
//		regionCodes.put("45730", "전라북도 무주군");
//		regionCodes.put("45800", "전라북도 부안군");
//		regionCodes.put("45770", "전라북도 순창군");
//		regionCodes.put("45710", "전라북도 완주군");
//		regionCodes.put("45140", "전라북도 익산시");
//		regionCodes.put("45750", "전라북도 임실군");
//		regionCodes.put("45740", "전라북도 장수군");
//		regionCodes.put("45110", "전라북도 전주시");
//		regionCodes.put("45111", "전라북도 전주시 완산구");
//		regionCodes.put("45113", "전라북도 전주시 덕진구");
//		regionCodes.put("45180", "전라북도 정읍시");
//		regionCodes.put("45720", "전라북도 진안군");
//
//		// 전라남도
//		regionCodes.put("46810", "전라남도 강진군");
//		regionCodes.put("46770", "전라남도 고흥군");
//		regionCodes.put("46720", "전라남도 곡성군");
//		regionCodes.put("46230", "전라남도 광양시");
//		regionCodes.put("46730", "전라남도 구례군");
//		regionCodes.put("46170", "전라남도 나주시");
//		regionCodes.put("46710", "전라남도 담양군");
//		regionCodes.put("46110", "전라남도 목포시");
//		regionCodes.put("46840", "전라남도 무안군");
//		regionCodes.put("46780", "전라남도 보성군");
//		regionCodes.put("46910", "전라남도 신안군");
//		regionCodes.put("46130", "전라남도 순천시");
//		regionCodes.put("46870", "전라남도 영광군");
//		regionCodes.put("46830", "전라남도 영암군");
//		regionCodes.put("46890", "전라남도 완도군");
//		regionCodes.put("46880", "전라남도 장성군");
//		regionCodes.put("46800", "전라남도 장흥군");
//		regionCodes.put("46900", "전라남도 진도군");
//		regionCodes.put("46860", "전라남도 함평군");
//		regionCodes.put("46820", "전라남도 해남군");
//		regionCodes.put("46790", "전라남도 화순군");
//
//		// 경상북도
//		regionCodes.put("47290", "경상북도 경산시");
//		regionCodes.put("47130", "경상북도 경주시");
//		regionCodes.put("47830", "경상북도 고령군");
//		regionCodes.put("47190", "경상북도 구미시");
//		regionCodes.put("47720", "경상북도 군위군");
//		regionCodes.put("47150", "경상북도 김천시");
//		regionCodes.put("47280", "경상북도 문경시");
//		regionCodes.put("47250", "경상북도 봉화군");
//		regionCodes.put("47170", "경상북도 상주시");
//		regionCodes.put("47840", "경상북도 성주군");
//		regionCodes.put("47210", "경상북도 안동시");
//		regionCodes.put("47770", "경상북도 영덕군");
//		regionCodes.put("47760", "경상북도 영양군");
//		regionCodes.put("47750", "경상북도 영주시");
//		regionCodes.put("47230", "경상북도 영천시");
//		regionCodes.put("47900", "경상북도 예천군");
//		regionCodes.put("47940", "경상북도 울릉군");
//		regionCodes.put("47930", "경상북도 울진군");
//		regionCodes.put("47730", "경상북도 의성군");
//		regionCodes.put("47110", "경상북도 포항시");
//		regionCodes.put("47111", "경상북도 포항시 남구");
//		regionCodes.put("47113", "경상북도 포항시 북구");
//		regionCodes.put("47850", "경상북도 청도군");
//		regionCodes.put("47820", "경상북도 청송군");
//		regionCodes.put("47790", "경상북도 칠곡군");
//
//		// 경상남도
//		regionCodes.put("48310", "경상남도 거제시");
//		regionCodes.put("48880", "경상남도 거창군");
//		regionCodes.put("48820", "경상남도 고성군");
//		regionCodes.put("48250", "경상남도 김해시");
//		regionCodes.put("48840", "경상남도 남해군");
//		regionCodes.put("48270", "경상남도 밀양시");
//		regionCodes.put("48240", "경상남도 사천시");
//		regionCodes.put("48860", "경상남도 산청군");
//		regionCodes.put("48330", "경상남도 양산시");
//		regionCodes.put("48720", "경상남도 의령군");
//		regionCodes.put("48170", "경상남도 진주시");
//		regionCodes.put("48740", "경상남도 창녕군");
//		regionCodes.put("48120", "경상남도 창원시");
//		regionCodes.put("48121", "경상남도 창원시 의창구");
//		regionCodes.put("48123", "경상남도 창원시 성산구");
//		regionCodes.put("48125", "경상남도 창원시 마산합포구");
//		regionCodes.put("48127", "경상남도 창원시 마산회원구");
//		regionCodes.put("48129", "경상남도 창원시 진해구");
//		regionCodes.put("48850", "경상남도 하동군");
//		regionCodes.put("48730", "경상남도 함안군");
//		regionCodes.put("48870", "경상남도 함양군");
//		regionCodes.put("48890", "경상남도 합천군");
//
//		// 제주특별자치도
//		regionCodes.put("50130", "제주특별자치도 서귀포시");
//		regionCodes.put("50110", "제주특별자치도 제주시");
		return regionCodes;
	}
	
	@Override
	@Transactional
	public Map<String, Object> executeProcedure(String procedureName) {
	    Map<String, Object> result = new HashMap<>();
	    
	    try {
	        // 큐에 처리할 데이터가 있는지 확인
	        int queueCount = countQueueData();
	        if (queueCount <= 0) {
	            result.put("success", false);
	            result.put("message", "처리할 데이터가 없습니다. 먼저 과거 데이터를 다운로드해주세요.");
	            return result;
	        }
	        
	        logger.info("프로시저 실행 시작: {}", procedureName);
	        
	        // 프로시저 실행 (매개변수 없음 또는 프로시저 정의에 맞게 수정)
	        Map<String, Object> params = new HashMap<>();
	        // 필요한 경우 IN 매개변수 추가
	        // params.put("someParam", "value");
	        
	        // 프로시저 실행
	        apartmentDownloadDAO.executeProcedure(params);
	        
	        // 결과 처리 (프로시저가 OUT 매개변수를 반환하지 않는 경우 수정 필요)
	        logger.info("프로시저 실행 완료: {}", procedureName);
	        
	        // 프로시저 실행 후 처리된 데이터 수와 생성된 테이블 수를 직접 조회
	        int processedCount = countQueueData(); // 또는 다른 방법으로 처리된 데이터 수 조회
	        int tableCount = 0; // 생성된 테이블 수 조회 로직 추가 필요
	        
	        result.put("success", true);
	        result.put("message", "프로시저 실행 완료");
	        result.put("processedCount", processedCount);
	        result.put("tableCount", tableCount);
	        
	        return result;
	    } catch (Exception e) {
	        logger.error("프로시저 실행 중 오류 발생: {}", e.getMessage());
	        e.printStackTrace();
	        
	        result.put("success", false);
	        result.put("message", "프로시저 실행 중 오류 발생: " + e.getMessage());
	        
	        return result;
	    }
	}
}