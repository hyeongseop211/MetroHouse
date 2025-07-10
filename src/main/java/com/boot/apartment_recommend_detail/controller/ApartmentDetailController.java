package com.boot.apartment_recommend_detail.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.boot.apartment_comparison.dto.ApartmentComparisonDTO;
import com.boot.apartment_comparison.service.ApartmentComparisonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.apartment_recommend_detail.dto.ApartmentDTO;
import com.boot.apartment_recommend_detail.service.ApartmentDetailService;
import com.boot.apartment_recommend_detail.service.ApartmentGraphService;
import com.boot.apartment_recommend_detail.service.ApartmentRecommendService;
import com.boot.apartment_review.dto.ReviewDTO;
import com.boot.apartment_review.dto.ReviewStatsDTO;
import com.boot.apartment_review.service.ReviewService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.ReviewCriteriaDTO;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class ApartmentDetailController {
    @Autowired
    private ApartmentComparisonService apartmentComparisonService; // 새로 추가 관심목록 서비스

    @Autowired
    private ApartmentDetailService apartmentDetailService;
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private ApartmentGraphService apartmentGraphService;

    @GetMapping("/apartment_detail")
    public String apartmentDetail(
            @RequestParam("apartmentId") int apartmentId, 
            ReviewCriteriaDTO reviewCriteriaDTO,
            Model model,
            HttpServletRequest request) {
        //새로추가 로그인 사용자 정보 넘김
        BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

        // 아파트 상세 정보 조회
        ApartmentDTO apartment = apartmentDetailService.getApartmentInfo(apartmentId);
        model.addAttribute("apartment", apartment);
        
        // 페이징 파라미터 설정
        Map<String, Object> param = new HashMap<>();
        param.put("apartmentId", apartmentId);
        param.put("pageNum", reviewCriteriaDTO.getPageNum());
        param.put("amount", reviewCriteriaDTO.getAmount());
        
        // 리뷰 목록 조회
        List<ReviewDTO> reviewList = reviewService.getReviews(param);
        model.addAttribute("reviewList", reviewList);
        
        // 리뷰 통계 조회
        ReviewStatsDTO reviewStats = reviewService.getReviewStats(apartmentId);
        model.addAttribute("reviewStats", reviewStats);
        
        // 페이징 정보 설정
        int total = reviewService.getReviewCount(param);
        PageDTO pageDTO = new PageDTO(total, reviewCriteriaDTO);
        model.addAttribute("pageMaker", pageDTO);
        
        // 연도별 가격 데이터 조회 (APTSEQ 기준)
        // apartment 객체에서 APTSEQ 값을 가져옵니다.
        String aptSeq = apartment.getAptSeq(); // ApartmentDTO에 getAptSeq() 메서드가 있다고 가정
        
        List<Map<String, Object>> priceData = apartmentGraphService.getYearlyPriceDataByAptSeq(aptSeq);
        
//        System.out.println("test => " + priceData);
//        System.out.println("aptSeq => " + aptSeq);
        // JSON으로 변환하여 모델에 추가
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String priceDataJson = objectMapper.writeValueAsString(priceData);
            model.addAttribute("priceDataJson", priceDataJson);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("priceDataJson", "[]"); // 오류 시 빈 배열
        }



        // 새로추가 관심목록 정보 추가
        if (user != null) {
            List<ApartmentComparisonDTO> favorites = apartmentComparisonService
                    .getFavoriteListByUserNumber(user.getUserNumber());

            try {
                ObjectMapper mapper = new ObjectMapper();
                String json = mapper.writeValueAsString(favorites);
                model.addAttribute("favoriteListJson", json);
                model.addAttribute("currentUserNumber", user.getUserNumber());
            } catch (Exception e)
            {
                e.printStackTrace();
                model.addAttribute("favoriteListJson", "[]");
            }
        }
        else
        {
            model.addAttribute("favoriteListJson", "[]");
        }
        
        return "apartment/apartment_detail";
    }
}