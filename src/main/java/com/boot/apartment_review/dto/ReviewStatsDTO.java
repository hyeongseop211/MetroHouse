package com.boot.apartment_review.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewStatsDTO {
    private Integer totalReviews;           // 총 리뷰 개수
    private Double averageRating;           // 평균 평점
    private Double fiveStarPercentage;      // 5점 비율
    private Double fourStarPercentage;      // 4점 비율
    private Double threeStarPercentage;     // 3점 비율
    private Double twoStarPercentage;       // 2점 비율
    private Double oneStarPercentage;       // 1점 비율
}
