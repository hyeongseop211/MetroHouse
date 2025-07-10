package com.boot.apartment_review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.apartment_review.dao.ReviewDAO;
import com.boot.apartment_review.dto.ReviewDTO;
import com.boot.apartment_review.dto.ReviewHelpfulDTO;
import com.boot.apartment_review.dto.ReviewStatsDTO;
import com.boot.z_page.criteria.ReviewCriteriaDTO;



@Service
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewDAO reviewDAO;

    @Override
    public int getReviewCount(Map<String, Object> params) {
        return reviewDAO.getReviewCount(params);
    }

    @Override
    public List<ReviewDTO> getReviews(Map<String, Object> params) {
        return reviewDAO.getReview(params);
    }

    @Override
    public List<ReviewDTO> getAllReviewsByApartmentId(@Param("params")Map<String, Object> params, @Param("criteria") ReviewCriteriaDTO reviewCriteriaDTO) {
        params = new HashMap<>();
//        params.put("apartmentId", apartmentId);
//        params.put("userNumber", userNumber);
        return reviewDAO.getAllReviewsByApartmentId(params, reviewCriteriaDTO);
    }

    @Override
    public ReviewDTO getReviewById(int reviewId) {
        return reviewDAO.getReviewById(reviewId);
    }

    @Override
    @Transactional
    public boolean insertReview(ReviewDTO review) {
        return reviewDAO.insertReview(review) > 0;
    }

    @Override
    @Transactional
    public boolean updateReview(ReviewDTO review) {
        return reviewDAO.updateReview(review) > 0;
    }

    @Override
    @Transactional
    public boolean deleteReview(ReviewDTO review) {
        return reviewDAO.deleteReview(review) > 0;
    }

    @Override
    public boolean checkReview(int userNumber, int apartmentId) {
        return reviewDAO.checkReview(userNumber, apartmentId) > 0;
    }

    @Override
    @Transactional
    public boolean addReviewHelpful(int reviewId, int userNumber) {
        // 이미 도움됨으로 표시했는지 확인
        ReviewHelpfulDTO helpful = new ReviewHelpfulDTO();
        helpful.setReviewId(reviewId);
        helpful.setUserNumber(userNumber);
        
        if (reviewDAO.checkReviewHelpful(helpful) > 0) {
            return false;
        }
        
        return reviewDAO.addReviewHelpful(helpful) > 0;
    }

    @Override
    @Transactional
    public boolean removeReviewHelpful(int reviewId, int userNumber) {
        ReviewHelpfulDTO helpful = new ReviewHelpfulDTO();
        helpful.setReviewId(reviewId);
        helpful.setUserNumber(userNumber);
        
        return reviewDAO.removeReviewHelpful(helpful) > 0;
    }

    @Override
    public boolean checkReviewHelpful(int reviewId, int userNumber) {
        ReviewHelpfulDTO helpful = new ReviewHelpfulDTO();
        helpful.setReviewId(reviewId);
        helpful.setUserNumber(userNumber);
        
        return reviewDAO.checkReviewHelpful(helpful) > 0;
    }

    @Override
    public int getReviewHelpfulCount(int reviewId) {
        return reviewDAO.getReviewHelpfulCount(reviewId);
    }

    @Override
    public ReviewStatsDTO getReviewStats(int apartmentId) {
        return reviewDAO.getReviewStats(apartmentId);
    }
}
