package com.boot.board.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.board.dao.BoardCommentDAO;
import com.boot.board.dao.BoardDAO;
import com.boot.board.dto.BoardCommentDTO;
import com.boot.z_page.criteria.CriteriaDTO;

@Service
public class BoardCommentServiceImpl implements BoardCommentService {
	@Autowired
	private SqlSession sqlSession;

	@Override
	public ArrayList<BoardCommentDTO> bcView(HashMap<String, String> param, CriteriaDTO criteriaDTO) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);

		ArrayList<BoardCommentDTO> list = dao.bcView(param, criteriaDTO);
		return list;
	}

	@Override
	public void bcWrite(HashMap<String, String> param) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);
		dao.bcWrite(param);
	}

	@Override
	public void bcModify(HashMap<String, String> param) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);
		dao.bcModify(param);
	}

	@Override
	public void bcDelete(HashMap<String, String> param) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);
		dao.bcDelete(param);
	}

	@Override
	public int getTotalCount(HashMap<String, String> param) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);
		int total = dao.getTotalCount(param);
		return total;
	}

	@Override
	public int getAllCount(HashMap<String, String> param) {
		BoardCommentDAO dao = sqlSession.getMapper(BoardCommentDAO.class);
		int total = dao.getAllCount(param);
		return total;
	}
}
