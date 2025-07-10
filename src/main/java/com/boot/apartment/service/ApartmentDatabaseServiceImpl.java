package com.boot.apartment.service;

import com.boot.apartment.dao.ApartmentDatabaseDAO;
import com.boot.apartment.dto.ApartmentTradeDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class ApartmentDatabaseServiceImpl implements ApartmentDatabaseService{
    @Autowired
    private final ApartmentDatabaseDAO apartmentDatabaseDAO;




    @Override
    public ApartmentTradeDTO selectApartmentTradeInfo(int apartmentId) {
        log.info("C - selectApartmentTradeInfo({}) 호출", apartmentId);
        return apartmentDatabaseDAO.selectApartmentTradeInfo(apartmentId);
    }

    @Override
    public List<ApartmentTradeDTO> selectAllApartmentTradeInfo() {
        log.info("C - selectAllApartmentTradeInfo() 호출");

        return apartmentDatabaseDAO.selectAllApartmentTradeInfo();
    }

    @Override
    public List<ApartmentTradeDTO> selectApartmentTradeInfoBySggCd(String sggCd) {
        log.info("C - selectApartmentTradeInfoBySggCd({}) 호출", sggCd);
        return apartmentDatabaseDAO.selectApartmentTradeInfoBySggCd(sggCd);
    }

}
