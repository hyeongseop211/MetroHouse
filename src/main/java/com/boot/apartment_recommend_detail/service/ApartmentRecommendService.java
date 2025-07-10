package com.boot.apartment_recommend_detail.service;

import java.util.List;

import com.boot.apartment_recommend_detail.dto.ApartmentDTO;
import com.boot.user.dto.BasicUserDTO;

public interface ApartmentRecommendService {
	List<ApartmentDTO> recommend(BasicUserDTO user);
}
