package com.boot.apartment_recommend_detail.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.apartment_recommend_detail.dao.ApartmentDetailDAO;
import com.boot.apartment_recommend_detail.dto.ApartmentDTO;

@Service
public class ApartmentDetailServiceImpl implements ApartmentDetailService{
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ApartmentDTO getApartmentInfo(int apartmentId) {
		ApartmentDetailDAO dao = sqlSession.getMapper(ApartmentDetailDAO.class);
		ApartmentDTO dto = dao.getApartmentInfo(apartmentId);
		return dto;
	}

}
