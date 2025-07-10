package com.boot.apartment.service;

import com.boot.apartment.dto.ApartmentTradeDTO;

import java.util.List;

public interface ApartmentDatabaseService {
    // 아파트 거래 정보 조회
    public ApartmentTradeDTO selectApartmentTradeInfo(int apartmentId);

    // 아파트 거래 정보 전체 조회
    public List<ApartmentTradeDTO> selectAllApartmentTradeInfo();

    // 아파트 거래 정보 조회 (시군구 코드)
    public List<ApartmentTradeDTO> selectApartmentTradeInfoBySggCd(String sggCd);

}
