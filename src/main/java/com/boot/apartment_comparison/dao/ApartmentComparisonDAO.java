package com.boot.apartment_comparison.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.apartment_comparison.dto.ApartmentComparisonDTO;

@Mapper
public interface ApartmentComparisonDAO {
	public List<ApartmentComparisonDTO> getFavoriteListByUserNumber(int userNumber);
}
