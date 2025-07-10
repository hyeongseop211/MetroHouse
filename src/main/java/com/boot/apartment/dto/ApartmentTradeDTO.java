package com.boot.apartment.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApartmentTradeDTO {
	private int apartmentId;
    private String sggCd;
    private String umdNm;
    private String aptNm;
    private String jibun;
    private String excluUseAr;
    private String dealYear;
    private String dealMonth;
    private String dealDay;
    private String dealAmount;
    private String floor;
    private String buildYear;
    private String cdealType;
    private String cdealDay;
    private String dealingGbn;
    private String estateAgentSggNm;
    private String rgstDate;
    private String aptDong;
    private String slerGbn;
    private String buyerGbn;
    private String landLeaseHoldGbn;
    private String aptSeq;
    private String bonbun;
    private String bubun;
    private String landCd;
    private String roadNm;
    private String roadNmBonbun;
    private String roadNmBubun;
    private String roadNmCd;
    private String roadNmSeq;
    private String roadNmSggCd;
    private String roadNmBCd;
    private String umdCd;

    // 카카오 api를 통해 받을 위도 경도
    private Double lat;  // 위도
    private Double lng;  // 경도

    // 근처 지하철역 & 거리
    private String subwayStation; // 지하철역 이름
    private String subwayDistance; // 거리


}
