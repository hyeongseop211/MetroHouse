package com.boot.apartment_favorite.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.boot.apartment_favorite.dto.ApartmentFavoriteDTO;

public interface ApartmentFavoriteDAO {
	public int addFavoriteList(HashMap<String, Object> param); // 추가(맵에서 관심등록 눌렀을 때) insert

	public int checkFavoriteList(int userNumber, int boardNumber); // 검증(이미 눌렀으면) select

//	public int getFavoriteListCount(int userNumber, ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteria); // 관심목록 전체 카운트(갯수) select
	public int getFavoriteListCount(Map<String, Object> params); // 관심목록 전체 카운트(갯수) select

//	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(int userNumber, ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteriaDTO); // 유저 전체 관심목록 리스트 사이드바 + 관심아파트 jsp select
	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(Map<String, Object> params); // 유저 전체 관심목록 리스트 사이드바 +
																								// 관심아파트 jsp select

	public int removeFavoriteList(@Param("userNumber")int userNumber, @Param("favoriteId")int favoriteId); // 삭제(관심아파트 페이지에서 하트눌렀을 때) userNumber, favoriteId

//	public int getFavoriteListCountByBoardNumber(int boardNumber); // ??

//	public List<Integer> getFavoriteListByBoardNumber(int boardNumber); //

//	public List<ApartmentTradeDTO> getFavoriteListSortedByPrice(int userNumber, boolean ascending);

//	public List<ApartmentTradeDTO> getFavoriteListSortedByDate(int userNumber, boolean ascending);

}
