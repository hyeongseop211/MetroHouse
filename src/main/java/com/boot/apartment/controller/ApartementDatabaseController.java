package com.boot.apartment.controller;

import com.boot.apartment.dto.ApartmentTradeDTO;
import com.boot.apartment.service.ApartmentCacheService;
import com.boot.apartment.service.ApartmentDatabaseService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;

@RestController
@Slf4j
public class ApartementDatabaseController {
    @Autowired
    private ApartmentDatabaseService apartmentDatabaseService;

    // 캐시 서비스
    @Autowired
    private ApartmentCacheService apartmentCacheService;


    @GetMapping("/AllApartmentTradeInfo")
     public ResponseEntity<List<ApartmentTradeDTO>> getApartmentTrades(Model model, HttpServletRequest request, @RequestParam HashMap<String, String> param) {
        log.info("C - getAllApartmentTradesFromCache 호출 (Cache 사용 - 전체 데이터)");

        try {
            // 캐시 서비스에서 모든 아파트 데이터를 가져옵니다.
            List<ApartmentTradeDTO> trades = apartmentCacheService.getAllApartments();
            int totalCountInCache = apartmentCacheService.getTotalApartmentCount(); // 캐시에 로드된 전체 개수 확인

            // 로그: 캐시에서 가져온 데이터 수와 캐시에 저장된 총 데이터 수
            log.info("C - 캐시에서 조회된 거래 데이터 수: {}", trades.size());
            log.info("C - 캐시에 저장된 전체 거래 데이터 수: {}", totalCountInCache);

            // 캐시된 전체 데이터를 반환합니다.
            return ResponseEntity.ok(trades);
        } catch (Exception e) {
            // e.printStackTrace(); // 개발 중에는 유용하지만, 운영 환경에서는 아래 로깅으로 대체하는 것이 좋습니다.
            log.error("C - getAllApartmentTradesFromCache 오류 발생", e);
            return ResponseEntity.internalServerError().build(); // 500 Internal Server Error
        }
    }
}


