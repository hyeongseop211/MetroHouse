package com.boot.apartment.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.boot.apartment.dto.ApartmentTradeDTO;

@Mapper
public interface ApartmentDownloadDAO {
    // 기존 메서드
    void insertApartmentInfo(ApartmentTradeDTO apartmentTradeDTO);
    List<ApartmentTradeDTO> getApartmentDataByYearMonth(Map<String, Object> params);
    Integer countApartmentDataByYearMonth(Map<String, Object> params);
    int deleteApartmentDataByYearMonth(Map<String, Object> params);
    
    // 새로 추가된 메서드
    void insertToQueue(ApartmentTradeDTO apartmentTradeDTO);
    int deleteProcessedQueueData();
    int resetQueueProcessedStatus();
    List<ApartmentTradeDTO> getQueueData();
    Integer countQueueData();
    void executeProcedure(Map<String, Object> params);
}