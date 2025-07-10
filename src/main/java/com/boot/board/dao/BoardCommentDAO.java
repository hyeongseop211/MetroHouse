package com.boot.board.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.boot.board.dto.BoardCommentDTO;
import com.boot.z_page.criteria.CriteriaDTO;

public interface BoardCommentDAO {
//	public ArrayList<BoardCommentDTO> bcView(HashMap<String, String> param, CriteriaDTO criteriaDTO);
	public ArrayList<BoardCommentDTO> bcView(@Param("param") HashMap<String, String> param,
			@Param("criteria") CriteriaDTO criteriaDTO);

	public int getTotalCount(HashMap<String, String> param);

	public int getAllCount(HashMap<String, String> param);

	public void bcWrite(HashMap<String, String> param);

	public void bcModify(HashMap<String, String> param);

	public void bcDelete(HashMap<String, String> param);
}
