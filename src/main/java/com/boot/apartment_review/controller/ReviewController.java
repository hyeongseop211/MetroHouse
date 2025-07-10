package com.boot.apartment_review.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.apartment_review.dto.ReviewDTO;
import com.boot.apartment_review.service.ReviewService;
import com.boot.user.dto.BasicUserDTO;

@Controller
public class ReviewController {
    @Autowired
    private ReviewService reviewService;
    @Autowired
    private HttpServletRequest request;
    
    private BasicUserDTO getCurrentUser() {
        return (BasicUserDTO) request.getAttribute("user");
    }

    // 리뷰 등록 - @RequestParam으로 개별 파라미터 받기
    @PostMapping("/insertReview")
    @ResponseBody
    public Map<String, Object> insertReview(
            @RequestParam("apartmentId") int apartmentId,
            @RequestParam("reviewTitle") String reviewTitle,
            @RequestParam("reviewContent") String reviewContent,
            @RequestParam("reviewRating") int reviewRating) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            // ReviewDTO 수동 생성
            ReviewDTO review = new ReviewDTO();
            review.setApartmentId(apartmentId);
            review.setUserNumber(userNumber);
            review.setReviewTitle(reviewTitle);
            review.setReviewContent(reviewContent);
            review.setReviewRating(reviewRating);
            
            // 이미 리뷰를 작성했는지 확인
            boolean hasReview = reviewService.checkReview(userNumber, apartmentId);
            if (hasReview) {
                result.put("success", false);
                result.put("message", "이미 이 아파트에 리뷰를 작성하셨습니다.");
                return result;
            }
            
            // 리뷰 등록
            boolean success = reviewService.insertReview(review);
            
            result.put("success", success);
            result.put("message", success ? "리뷰가 성공적으로 등록되었습니다." : "리뷰 등록에 실패했습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
    
    // 리뷰 수정 - @RequestParam으로 개별 파라미터 받기
    @PostMapping("/updateReview")
    @ResponseBody
    public Map<String, Object> updateReview(
            @RequestParam("reviewId") int reviewId,
            @RequestParam("reviewTitle") String reviewTitle,
            @RequestParam("reviewContent") String reviewContent,
            @RequestParam("reviewRating") int reviewRating) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            // ReviewDTO 수동 생성
            ReviewDTO review = new ReviewDTO();
            review.setReviewId(reviewId);
            review.setUserNumber(userNumber);
            review.setReviewTitle(reviewTitle);
            review.setReviewContent(reviewContent);
            review.setReviewRating(reviewRating);
            
            // 리뷰 수정
            boolean success = reviewService.updateReview(review);
            
            result.put("success", success);
            result.put("message", success ? "리뷰가 성공적으로 수정되었습니다." : "리뷰 수정에 실패했습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
    
    // 나머지 메서드들은 그대로 유지
    @PostMapping("/deleteReview")
    @ResponseBody
    public Map<String, Object> deleteReview(@RequestParam("reviewId") int reviewId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            ReviewDTO review = new ReviewDTO();
            review.setReviewId(reviewId);
            review.setUserNumber(userNumber);
            
            boolean success = reviewService.deleteReview(review);
            
            result.put("success", success);
            result.put("message", success ? "리뷰가 성공적으로 삭제되었습니다." : "리뷰 삭제에 실패했습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
    
    @PostMapping("/review_helpful")
    @ResponseBody
    public Map<String, Object> addReviewHelpful(@RequestParam("reviewId") int reviewId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            boolean success = reviewService.addReviewHelpful(reviewId, userNumber);
            int helpfulCount = reviewService.getReviewHelpfulCount(reviewId);
            
            result.put("success", success);
            result.put("helpfulCount", helpfulCount);
            result.put("message", success ? "도움됨으로 표시되었습니다." : "이미 도움됨으로 표시하셨습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
    
    @PostMapping("/review_unhelpful")
    @ResponseBody
    public Map<String, Object> removeReviewHelpful(@RequestParam("reviewId") int reviewId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            boolean success = reviewService.removeReviewHelpful(reviewId, userNumber);
            int helpfulCount = reviewService.getReviewHelpfulCount(reviewId);
            
            result.put("success", success);
            result.put("helpfulCount", helpfulCount);
            result.put("message", success ? "도움됨이 취소되었습니다." : "도움됨 취소에 실패했습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
    
    @PostMapping("/apartment_inquiry")
    @ResponseBody
    public Map<String, Object> inquireApartment(@RequestParam("apartmentId") int apartmentId) {
        Map<String, Object> result = new HashMap<>();
        
        try {
            int userNumber = getCurrentUser().getUserNumber();
            
            result.put("success", true);
            result.put("message", "문의가 성공적으로 접수되었습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "오류가 발생했습니다: " + e.getMessage());
        }
        
        return result;
    }
}
