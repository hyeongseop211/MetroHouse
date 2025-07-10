package com.boot.apartment.service;

import com.boot.apartment.dto.ApartmentTradeDTO;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;

import java.util.List;

public interface ApartmentTradeService {


	public List<ApartmentTradeDTO> getTradeData(String sigunguCode, String yearMonth);

	public List<ApartmentTradeDTO> getTradeData(String sigunguCode, String yearMonth, String numOfRows);

	// public String getSigunguCodeFromAddress(String address);
//    public String recommend(UserDTO loginUser);
//	List<ApartmentTradeDTO> recommend(BasicUserDTO loginUser);
}
