package com.boot.apartment_recommend_detail.dao;

import org.apache.ibatis.annotations.Mapper;

import com.boot.apartment_recommend_detail.dto.ApartmentDTO;

@Mapper
public interface ApartmentDetailDAO {
	public ApartmentDTO getApartmentInfo(int apartmentId);
}
