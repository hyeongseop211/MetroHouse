package com.boot.board.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDTO {
	private int boardNumber;
	private int userNumber;
	private String userName;
	private String boardTitle;
	private String boardContent;
	private String boardWriteDate;
	private String boardViews;
	private String boardLikes;
	private String boardHit;
	private int commentCount;
}
