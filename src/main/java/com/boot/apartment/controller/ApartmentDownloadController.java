package com.boot.apartment.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.boot.apartment.service.ApartmentDownloadService;

@RestController
@RequestMapping("/api/apartment")
public class ApartmentDownloadController {

    @Autowired
    private ApartmentDownloadService apartmentDownloadService;

    /**
     * 최신 아파트 거래 데이터 다운로드 (APARTMENTINFO 테이블에 저장)
     */
    @GetMapping("/download")
    public ResponseEntity<?> downloadApartmentData(
            @RequestParam(value = "yearMonth", required = false) String yearMonth) {
        try {
            // 현재 년월 데이터 다운로드 (기본값)
            int count = apartmentDownloadService.downloadApartmentinfo(yearMonth);
            return ResponseEntity.ok(Map.of(
                "status", "success", 
                "message", "최신 아파트 거래 데이터 다운로드 완료", 
                "count", count
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    /**
     * 과거 10년치 아파트 거래 데이터 다운로드 (APARTMENTINFO_QUEUE 테이블에 저장)
     */
    @PostMapping("/download-historical")
    public ResponseEntity<?> downloadHistoricalData(@RequestBody Map<String, Object> request) {
        try {
            int years = (Integer) request.getOrDefault("years", 10);
//            System.out.println("years => " + years);
            
            int count = apartmentDownloadService.downloadHistoricalApartmentinfo(years);
            return ResponseEntity.ok(Map.of(
                "status", "success", 
                "message", "과거 " + years + "년치 아파트 거래 데이터 다운로드 완료", 
                "count", count
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    /**
     * 프로시저 실행 후 처리된 큐 데이터 삭제
     */
    @GetMapping("/clean-queue")
    public ResponseEntity<?> cleanProcessedQueueData() {
        try {
            int count = apartmentDownloadService.deleteProcessedQueueData();
            return ResponseEntity.ok(Map.of(
                "status", "success", 
                "message", "처리된 큐 데이터 삭제 완료", 
                "count", count
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    /**
     * 큐 테이블의 처리 상태 초기화
     */
    @GetMapping("/reset-queue")
    public ResponseEntity<?> resetQueueStatus() {
        try {
            int count = apartmentDownloadService.resetQueueProcessedStatus();
            return ResponseEntity.ok(Map.of(
                "status", "success", 
                "message", "큐 처리 상태 초기화 완료", 
                "count", count
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    /**
     * 큐 데이터 개수 조회
     */
    @GetMapping("/queue-count")
    public ResponseEntity<?> getQueueCount() {
        try {
            int count = apartmentDownloadService.countQueueData();
            return ResponseEntity.ok(Map.of(
                "status", "success", 
                "count", count
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }

    /**
     * 데이터 수집 상태 조회
     */
    @GetMapping("/status")
    public ResponseEntity<?> getCollectionStatus() {
        try {
            Map<String, Object> status = apartmentDownloadService.getCollectionStatus();
            return ResponseEntity.ok(status);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }
    
    /**
     * 프로시저 실행 (데이터 동기화)
     */
    @PostMapping("/execute-procedure")
    public ResponseEntity<?> executeProcedure(@RequestBody Map<String, String> requestBody) {
        try {
            String procedureName = requestBody.get("procedure");
            if (procedureName == null || procedureName.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(Map.of("status", "error", "message", "프로시저 이름이 필요합니다"));
            }
            
            // 프로시저 실행 결과
            Map<String, Object> result = apartmentDownloadService.executeProcedure(procedureName);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("status", "error", "message", e.getMessage()));
        }
    }
}