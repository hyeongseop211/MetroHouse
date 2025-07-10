package com.boot.apartment_review.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReviewHelpfulDTO {
    private int helpfulId;     // 도움됨 ID
    private int reviewId;      // 리뷰 ID
    private int userNumber;    // 사용자 번호
    private Date helpfulDate;   // 도움됨 등록일
}