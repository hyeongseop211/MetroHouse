package com.boot.apartment_recommend_detail.service;

import com.boot.apartment_recommend_detail.dto.ApartmentDTO;

public interface ApartmentDetailService {
	public ApartmentDTO getApartmentInfo(int apartmentId);
}
