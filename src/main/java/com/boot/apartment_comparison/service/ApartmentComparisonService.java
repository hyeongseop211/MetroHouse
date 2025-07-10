package com.boot.apartment_comparison.service;

import java.util.List;

import com.boot.apartment_comparison.dto.ApartmentComparisonDTO;


public interface ApartmentComparisonService {
	public List<ApartmentComparisonDTO> getFavoriteListByUserNumber(int userNumber);
}
