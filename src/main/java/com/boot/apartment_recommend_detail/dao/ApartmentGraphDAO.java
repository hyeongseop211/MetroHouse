package com.boot.apartment_recommend_detail.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ApartmentGraphDAO {
    // 특정 아파트의 연도별 가격 데이터 조회 (APTSEQ 기준)
    List<Map<String, Object>> getYearlyPriceDataByAptSeq(String aptSeq);
}