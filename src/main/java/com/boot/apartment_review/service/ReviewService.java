package com.boot.apartment_review.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.boot.apartment_review.dto.ReviewDTO;
import com.boot.apartment_review.dto.ReviewStatsDTO;
import com.boot.z_page.criteria.ReviewCriteriaDTO;

public interface ReviewService {
    
    // 리뷰 개수 조회
    int getReviewCount(Map<String, Object> param);
    
    // 리뷰 목록 조회 (페이징)
    List<ReviewDTO> getReviews(Map<String, Object> param);
    
    // 모든 리뷰 조회
    List<ReviewDTO> getAllReviewsByApartmentId(@Param("params")Map<String, Object> params, @Param("criteria") ReviewCriteriaDTO reviewCriteriaDTO);
    
    // 리뷰 상세 조회
    ReviewDTO getReviewById(int reviewId);
    
    // 리뷰 등록
    boolean insertReview(ReviewDTO review);
    
    // 리뷰 수정
    boolean updateReview(ReviewDTO review);
    
    // 리뷰 삭제
    boolean deleteReview(ReviewDTO review);
    
    // 리뷰 작성 여부 확인
    boolean checkReview(int userNumber, int apartmentId);
    
    // 리뷰 도움됨 추가
    boolean addReviewHelpful(int reviewId, int userNumber);
    
    // 리뷰 도움됨 취소
    boolean removeReviewHelpful(int reviewId, int userNumber);
    
    // 리뷰 도움됨 여부 확인
    boolean checkReviewHelpful(int reviewId, int userNumber);
    
    // 리뷰 도움됨 개수 조회
    int getReviewHelpfulCount(int reviewId);
    
    // 리뷰 통계 조회
    ReviewStatsDTO getReviewStats(int apartmentId);
}
