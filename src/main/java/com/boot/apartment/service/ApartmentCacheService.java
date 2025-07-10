package com.boot.apartment.service;

import com.boot.apartment.dao.ApartmentDatabaseDAO;
import com.boot.apartment.dto.ApartmentTradeDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

@Service
@Slf4j
@RequiredArgsConstructor // final 필드를 주입받기 위해 사용
public class ApartmentCacheService {

    private final ApartmentDatabaseDAO apartmentDatabaseDAO;

    // 캐시 데이터를 저장할 리스트. 데이터 변경이 거의 없으므로 불변 리스트로 만드는 것이 안전합니다.
    // volatile 또는 AtomicReference를 사용하여 캐시 갱신 시 동시성 문제 방지
    private volatile List<ApartmentTradeDTO> allApartmentsCache = Collections.emptyList();
    private AtomicBoolean cacheLoaded = new AtomicBoolean(false); // 캐시 로딩 완료 상태 플래그

    // 애플리케이션 시작 시 자동으로 호출되는 메소드
    @PostConstruct
    public void loadAllApartmentsOnStartup() {
        log.info("Cache Service - Starting initial apartment data load...");
        cacheLoaded.set(false); // 로딩 시작 시 false로 설정
        try {
            // DAO를 통해 모든 아파트 데이터를 가져옵니다.
            List<ApartmentTradeDTO> allData = apartmentDatabaseDAO.selectAllApartmentTradeInfo();

            // 가져온 데이터를 불변 리스트로 만들어 캐시에 저장
            this.allApartmentsCache = Collections.unmodifiableList(new ArrayList<>(allData));
            cacheLoaded.set(true); // 로딩 완료 시 true로 설정
            log.info("Cache Service - Initial apartment data load complete. Loaded {} items.", this.allApartmentsCache.size());

        } catch (Exception e) {
            log.error("Cache Service - Failed to load apartment data on startup", e);
            // TODO: 캐시 로딩 실패 시 처리 로직 추가 (예: 애플리케이션 종료 또는 주기적 재시도)
        }
    }

    // 캐시된 전체 아파트 데이터 목록을 반환하는 메소드
    // 외부에서 캐시 데이터를 직접 수정하지 못하도록 불변 리스트를 반환합니다.
    public List<ApartmentTradeDTO> getAllApartments() {
        // 캐시가 로딩되지 않았다면 빈 리스트 반환 또는 예외 처리
        if (!cacheLoaded.get()) {
            log.warn("Cache Service - Cache not yet loaded, returning empty list.");
            // 또는 throw new CacheNotLoadedException();
            return Collections.emptyList();
        }
        return this.allApartmentsCache;
    }

    // 캐시된 데이터에서 페이징된 데이터를 가져오는 메소드
    public List<ApartmentTradeDTO> getApartmentsPaged(int offset, int limit) {
        if (!cacheLoaded.get()) {
            log.warn("Cache Service - Cache not yet loaded, returning empty list for paged request.");
            return Collections.emptyList();
        }

        int fromIndex = Math.max(0, offset);
        int toIndex = Math.min(offset + limit, allApartmentsCache.size());

        if (fromIndex >= toIndex) {
            return Collections.emptyList();
        }

        try {
            // 캐시된 리스트에서 subList를 사용하여 페이징된 데이터 추출
            // subList는 원본 리스트의 뷰이므로, 새로운 ArrayList로 복사하여 반환하는 것이 안전합니다.
            return new ArrayList<>(allApartmentsCache.subList(fromIndex, toIndex));
        } catch (IndexOutOfBoundsException e) {
            log.error("Cache Service - Index out of bounds for pagination: offset={}, limit={}, cacheSize={}", offset, limit, allApartmentsCache.size(), e);
            return Collections.emptyList(); // 오류 발생 시 빈 리스트 반환
        }
    }

    // 캐시된 전체 데이터의 개수를 반환하는 메소드
    public int getTotalApartmentCount() {
        return allApartmentsCache.size();
    }

    // TODO: 데이터 변경이 발생했을 때 캐시를 갱신하는 로직 추가 (필요시)
    // 예: public void refreshCache() { loadAllApartmentsOnStartup(); }
}