package com.boot.apartment_review.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReviewDTO {
    private int reviewId;              // 리뷰 ID
    private int apartmentId;           // 아파트 ID
    private int userNumber;            // 사용자 번호
    private String reviewTitle;         // 리뷰 제목
    private String reviewContent;       // 리뷰 내용
    private Integer reviewRating;       // 리뷰 평점 (1-5)
    private Date reviewDate;            // 리뷰 작성일
    private Date reviewModifiedDate;    // 리뷰 수정일
    private String reviewStatus;        // 리뷰 상태 (ACTIVE, DELETED)
    private String userName;            // 작성자 이름
    private Integer helpfulCount;       // 도움됨 개수
    private Boolean helpfulByCurrentUser; // 현재 사용자의 도움됨 여부
}
