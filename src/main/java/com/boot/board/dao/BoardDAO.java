package com.boot.board.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.board.dto.BoardDTO;
import com.boot.z_page.criteria.CriteriaDTO;

public interface BoardDAO {
	public void boardWrite(HashMap<String, String> param);

	public ArrayList<BoardDTO> boardView(CriteriaDTO criteriaDTO);

	public BoardDTO boardDetailView(HashMap<String, String> param);

	public void boardModify(HashMap<String, String> param);

	public void boardDelete(HashMap<String, String> param);

	public void boardHit(HashMap<String, String> param);

	public int boardCheckLiked(HashMap<String, String> param);

	public void boardAddLike(HashMap<String, String> param);

	public void boardIncrementLike(HashMap<String, String> param);

	public void boardRemoveLike(HashMap<String, String> param);

	public void boardDecrementLike(HashMap<String, String> param);

	public int boardgetLike(HashMap<String, String> param);

	public int getTotalCount(CriteriaDTO criteriaDTO);

	public int getCommentCountByBoardNumber(int boardNumber);

}
