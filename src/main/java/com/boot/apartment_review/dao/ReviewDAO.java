package com.boot.apartment_review.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.apartment_review.dto.ReviewDTO;
import com.boot.apartment_review.dto.ReviewHelpfulDTO;
import com.boot.apartment_review.dto.ReviewStatsDTO;
import com.boot.z_page.criteria.ReviewCriteriaDTO;

@Mapper
public interface ReviewDAO {
    
    // 아파트 리뷰 개수 조회
    int getReviewCount(Map<String, Object> param);
    
    // 아파트 리뷰 등록
    int insertReview(ReviewDTO review);
    
    // 사용자가 해당 아파트에 리뷰를 작성했는지 확인
    int checkReview(@Param("userNumber") int userNumber, @Param("apartmentId") int apartmentId);
    
    // 리뷰 ID로 리뷰 상세 정보 조회
    ReviewDTO getReviewById(@Param("reviewId") int reviewId);
    
    // 리뷰 업데이트
    int updateReview(ReviewDTO review);
    
    // 리뷰 삭제 (소프트 삭제)
    int deleteReview(ReviewDTO review);
    
    // 리뷰 도움됨 추가
    int addReviewHelpful(ReviewHelpfulDTO helpful);
    
    // 리뷰 도움됨 취소
    int removeReviewHelpful(ReviewHelpfulDTO helpful);
    
    // 리뷰 도움됨 여부 확인
    int checkReviewHelpful(ReviewHelpfulDTO helpful);
    
    // 리뷰별 도움됨 개수 조회
    int getReviewHelpfulCount(@Param("reviewId") int reviewId);
    
    // 아파트 리뷰 목록 조회 (페이징)
    List<ReviewDTO> getReview(Map<String, Object> params);
    
    // 특정 아파트의 모든 리뷰 조회
    List<ReviewDTO> getAllReviewsByApartmentId(@Param("params")Map<String, Object> params, @Param("criteria") ReviewCriteriaDTO reviewCriteriaDTO);
    
    // 아파트 리뷰 통계 조회
    ReviewStatsDTO getReviewStats(@Param("apartmentId") int apartmentId);

}
