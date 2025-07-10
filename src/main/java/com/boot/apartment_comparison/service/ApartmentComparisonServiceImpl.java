package com.boot.apartment_comparison.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.apartment_comparison.dao.ApartmentComparisonDAO;
import com.boot.apartment_comparison.dto.ApartmentComparisonDTO;


@Service
public class ApartmentComparisonServiceImpl implements ApartmentComparisonService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<ApartmentComparisonDTO> getFavoriteListByUserNumber(int userNumber) {
		ApartmentComparisonDAO dao = sqlSession.getMapper(ApartmentComparisonDAO.class);
		return dao.getFavoriteListByUserNumber(userNumber);
	}

}
