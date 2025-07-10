package com.boot.apartment_recommend_detail.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.apartment_recommend_detail.dao.ApartmentGraphDAO;

@Service
public class ApartmentGraphServiceImpl implements ApartmentGraphService {
    
    @Autowired
    private ApartmentGraphDAO apartmentGraphDAO;
    
    @Override
    public List<Map<String, Object>> getYearlyPriceDataByAptSeq(String aptSeq) {
        return apartmentGraphDAO.getYearlyPriceDataByAptSeq(aptSeq);
    }
}