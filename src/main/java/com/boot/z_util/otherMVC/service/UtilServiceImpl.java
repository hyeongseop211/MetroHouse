package com.boot.z_util.otherMVC.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.z_util.otherMVC.dao.UtilDAO;

import ch.qos.logback.classic.pattern.Util;

@Service
public class UtilServiceImpl implements UtilService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public int getAllApartmentCount() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		return dao.getAllApartmentCount();
	}

	@Override
	public int getAvgPrice() {
		UtilDAO dao = sqlSession.getMapper(UtilDAO.class);
		Integer result = dao.getAvgPrice();
//		return dao.getAvgPrice();
		return result != null ? result : 0;  // null 방어 처리
	}

}
