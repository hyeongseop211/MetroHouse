package com.boot.apartment.controller;

import com.boot.apartment.dto.ApartmentTradeDTO;
import com.boot.apartment.service.ApartmentTradeService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/apartments")
@RequiredArgsConstructor
public class ApiController {
	private final ApartmentTradeService apartmentTradeService;

	@GetMapping("/trade")
	public ResponseEntity<List<ApartmentTradeDTO>> getApartmentTrades(@RequestParam String sigunguCode,
			@RequestParam String yearMonth) {
		log.info("Controller API 호출 - sigunguCode: {}, yearMonth: {}", sigunguCode, yearMonth);

		try {
			List<ApartmentTradeDTO> trades = apartmentTradeService.getTradeData(sigunguCode, yearMonth);
			log.info("C - s조회된 거래 데이터 수: {}", trades.size());

			return ResponseEntity.ok(trades);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.internalServerError().build();
		}
	}
}
