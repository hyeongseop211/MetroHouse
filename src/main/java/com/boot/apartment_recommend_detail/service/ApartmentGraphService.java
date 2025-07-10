package com.boot.apartment_recommend_detail.service;

import java.util.List;
import java.util.Map;

public interface ApartmentGraphService {
    // 특정 아파트의 연도별 가격 데이터 조회 (APTSEQ 기준)
    List<Map<String, Object>> getYearlyPriceDataByAptSeq(String aptSeq);
}