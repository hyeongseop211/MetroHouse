package com.boot.apartment.service;

import java.util.List;
import java.util.Map;

import com.boot.apartment.dto.ApartmentTradeDTO;

public interface ApartmentDownloadService {
    // 최신 데이터 다운로드 (APARTMENTINFO 테이블에 저장)
    int downloadApartmentinfo(String yearMonth);
    
    // 과거 데이터 다운로드 (APARTMENTINFO_QUEUE 테이블에 저장)
    int downloadHistoricalApartmentinfo(int years);
    
    // 특정 지역의 아파트 거래 데이터 조회
    List<ApartmentTradeDTO> getRegionTradeData(String sigunguCode, String yearMonth);
    
    // 특정 지역의 아파트 거래 데이터를 페이지 단위로 조회
    List<ApartmentTradeDTO> getRegionTradeDataPaged(String sigunguCode, String yearMonth, int pageNo, int numOfRows);
    
    // 데이터베이스에 저장된 아파트 정보 조회
    List<ApartmentTradeDTO> getStoredApartmentData(String yearMonth);
    
    // 특정 연월의 아파트 데이터 수집 상태 확인
    boolean isDataCollectionCompleted(String yearMonth);
    
    // 아파트 데이터 수집 작업 상태 조회
    Map<String, Object> getCollectionStatus();
    
    // 특정 연월의 아파트 데이터 삭제
    int deleteApartmentData(String yearMonth);
    
    // 큐 데이터 관련 메서드
    List<ApartmentTradeDTO> getQueueData();
    int countQueueData();
    int resetQueueProcessedStatus();
    int deleteProcessedQueueData();
    Map<String, Object> executeProcedure(String procedureName);
}