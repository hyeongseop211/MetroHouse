package com.boot.apartment_comparison.dto;

import com.boot.apartment_favorite.dto.ApartmentFavoriteDTO;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ApartmentComparisonDTO {
	private int favoriteId; // LISTID (NUMBER, auto-increment)
	private int userNumber; // USERID
	private String createdAt; // 생성날짜
	private String dealAmount; // DEALAMOUNT
	private Double lat; // LAT
	private Double lng; // LNG
	private int favoriteApartmentId;

	// 아파트 고유번호(디비에만 있는 거 api에 없음)
	private int apartmentId;
	// 쿼리에 없는 컬럼 그냥 불러오기용
	private String aptNm; // 아파트이름
	private String estateAgentSggNm; // 지역명
	private String excluUseAr; // 면적
	private String floor; // 층수
	private String buildYear; // 건축년도
	private String subwayStation; // 지하철역 이름
	private String subwayDistance; // 거리
}
