package com.boot.apartment_favorite.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.boot.apartment_favorite.dto.ApartmentFavoriteDTO;
import com.boot.z_page.criteria.ApartmentFavoriteCriteriaDTO;

public interface ApartmentFavoriteService {
	public int addFavoriteList(HashMap<String, Object> param); // 추가(맵에서 관심등록 눌렀을 때) insert

	public int checkFavoriteList(int userNumber, int boardNumber); // 검증(이미 눌렀으면) select

//	public int getFavoriteListCount(int userNumber, ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteria); // 관심목록 전체 카운트(갯수) select
	public int getFavoriteListCount(Map<String, Object> params); // 관심목록 전체 카운트(갯수) select

//	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(int userNumber, ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteriaDTO); // 유저 전체 관심목록 리스트 사이드바 + 관심아파트 jsp select
	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(Map<String, Object> params); // 유저 전체 관심목록 리스트 사이드바 + 관심아파트 jsp select

	public int removeFavoriteList(int userNumber, int favoriteId); // 삭제(관심아파트 페이지에서 하트눌렀을 때) delete
}
