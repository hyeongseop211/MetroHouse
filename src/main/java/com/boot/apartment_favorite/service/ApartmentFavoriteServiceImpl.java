package com.boot.apartment_favorite.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.apartment_favorite.dao.ApartmentFavoriteDAO;
import com.boot.apartment_favorite.dto.ApartmentFavoriteDTO;
import com.boot.board.dao.BoardDAO;
import com.boot.z_page.criteria.ApartmentFavoriteCriteriaDTO;

@Service
public class ApartmentFavoriteServiceImpl implements ApartmentFavoriteService {

	@Autowired
	private SqlSession sqlSession;


	//관심등록 메소드 구현
	@Override
	public int addFavoriteList(HashMap<String, Object> param)
	{
		ApartmentFavoriteDAO dao = sqlSession.getMapper(ApartmentFavoriteDAO.class);
		return dao.addFavoriteList(param);
	}

	@Override
	public int checkFavoriteList(int userNumber, int boardNumber) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
//	public int getFavoriteListCount(int userNumber, ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteria) {
	public int getFavoriteListCount(Map<String, Object> params) {
		ApartmentFavoriteDAO dao = sqlSession.getMapper(ApartmentFavoriteDAO.class);
		return dao.getFavoriteListCount(params);
	}

	@Override
//	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(int userNumber,
//			ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteriaDTO) {
	public List<ApartmentFavoriteDTO> getFavoriteListByUserNumber(Map<String, Object> params) {
		ApartmentFavoriteDAO dao = sqlSession.getMapper(ApartmentFavoriteDAO.class);
		return dao.getFavoriteListByUserNumber(params);
	}

	@Override
	public int removeFavoriteList(int userNumber, int favoriteId) {
		ApartmentFavoriteDAO dao = sqlSession.getMapper(ApartmentFavoriteDAO.class);
		return dao.removeFavoriteList(userNumber, favoriteId);

	}

}
