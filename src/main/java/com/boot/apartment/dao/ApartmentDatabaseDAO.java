package com.boot.apartment.dao;

import com.boot.apartment.dto.ApartmentTradeDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ApartmentDatabaseDAO {
    // 아파트 거래 정보 조회
    public ApartmentTradeDTO selectApartmentTradeInfo(int apartmentId);

    // 아파트 거래 정보 전체 조회
    public List<ApartmentTradeDTO> selectAllApartmentTradeInfo();

    // 아파트 거래 정보 조회 (시군구 코드)
    public List<ApartmentTradeDTO> selectApartmentTradeInfoBySggCd(String sggCd);
}
