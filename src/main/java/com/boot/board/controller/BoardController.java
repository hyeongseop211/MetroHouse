package com.boot.board.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.board.dto.BoardCommentDTO;
import com.boot.board.dto.BoardDTO;
import com.boot.board.service.BoardCommentService;
import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.board.service.BoardService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.z_config.security.UserUtils;
import com.boot.z_page.CommentPageDTO;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.CriteriaDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {

	private final BoardCommentServiceImpl boardCommentServiceImpl;
	@Autowired
	private BoardService service;

	@Autowired
	private BoardCommentService bcService;
//	@Autowired
//	private UserUtils userUtils;

	BoardController(BoardCommentServiceImpl boardCommentServiceImpl) {
		this.boardCommentServiceImpl = boardCommentServiceImpl;
	}

//	@RequestMapping("/board_view")
//	public String boardView(CriteriaDTO criteriaDTO, Model model) {
//		ArrayList<BoardDTO> list = service.boardView(criteriaDTO);
//		int total = service.getTotalCount(criteriaDTO);
//
//		model.addAttribute("currentPage", "board_view"); // 헤더 식별용
//		model.addAttribute("boardList", list);
//		model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));
//
//		return "board_view";
//	}

	@RequestMapping("/board_view")
	public String boardList(Model model, CriteriaDTO criteriaDTO, HttpServletRequest request) {
//		UserDTO user = userUtils.extractUserFromRequest(request);

//		model.addAttribute("user", user);
		// 게시글 목록 조회
		ArrayList<BoardDTO> list = service.boardView(criteriaDTO);

		// 각 게시글의 댓글 수 조회
		Map<Integer, Integer> commentCounts = new HashMap<>();
		for (BoardDTO board : list) {
			int boardNumber = board.getBoardNumber();
			int commentCount = service.getCommentCountByBoardNumber(boardNumber);
			commentCounts.put(boardNumber, commentCount);
		}

		// 모델에 추가
		model.addAttribute("commentCounts", commentCounts);
		model.addAttribute("boardList", list);

		// 페이징 처리
		int total = service.getTotalCount(criteriaDTO);
		model.addAttribute("pageMaker", new PageDTO(total, criteriaDTO));

		return "board/board_view";
	}

	@RequestMapping("/board_write")
	public String boardViewWrite(HttpServletRequest request, Model model) {
//		UserDTO user = userUtils.extractUserFromRequest(request);
//		model.addAttribute("user", user);

		return "board/board_write";
	}

	@RequestMapping("/board_write_ok")
	public String boardViewWrite(@RequestParam HashMap<String, String> param) {

		service.boardWrite(param);

		return "board/board_view";
	}

	@RequestMapping("/delete_post")
	public String boardViewDelete(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		service.boardDelete(param);
		rttr.addAttribute("pageNum", param.get("pageNum"));
		rttr.addAttribute("amount", param.get("amount"));
		return "board/board_view";
	}

	@RequestMapping("/board_update_ok")
	public String boardViewUpdate(@RequestParam HashMap<String, String> param, RedirectAttributes rttr) {
		service.boardModify(param);
		rttr.addAttribute("boardNumber", param.get("boardNumber"));
		rttr.addAttribute("pageNum", param.get("pageNum"));
		rttr.addAttribute("amount", param.get("amount"));
		return "redirect:/board_detail_view";
	}

	@RequestMapping("/board_update")
	public String boardViewUpdate(@RequestParam HashMap<String, String> param, Model model,
			HttpServletRequest request) {
//		UserDTO user = userUtils.extractUserFromRequest(request);

//		model.addAttribute("user", user);
		BoardDTO dto = service.boardDetailView(param);
		model.addAttribute("board", dto);
		return "board/board_update";
	}

	@RequestMapping("/board_detail_view")
	public String boardViewDetail(@RequestParam HashMap<String, String> param, Model model, CriteriaDTO criteriaDTO,
			@RequestParam(value = "skipViewCount", required = false) Boolean skipViewCount,
			@RequestParam(value = "commentPageNum", required = false, defaultValue = "1") int commentPageNum,
			HttpServletRequest request) {
//		UserDTO user = userUtils.extractUserFromRequest(request);

//		model.addAttribute("user", user);
		// 댓글 페이지 번호 설정
		criteriaDTO.setCommentPageNum(commentPageNum);

		if (skipViewCount == null || !skipViewCount) {
			// 조회수 증가 로직
			service.boardHit(param);
		}

		BoardDTO dto = service.boardDetailView(param);
		ArrayList<BoardCommentDTO> commentList = bcService.bcView(param, criteriaDTO);
		int total = bcService.getTotalCount(param);
		int allTotal = bcService.getAllCount(param);

		model.addAttribute("allCount", allTotal);
		model.addAttribute("board", dto);
		model.addAttribute("commentList", commentList);
		model.addAttribute("pageMaker", new CommentPageDTO(total, criteriaDTO));

		return "board/board_detail";
	}

	// 추천 확인(버튼색반전용)
	@GetMapping("/checkLikeStatus")
	@ResponseBody
	public boolean checkLikeStatus(@RequestParam("boardNumber") int boardNumber, HttpServletRequest request) {
		// 타입 체크를 통한 안전한 처리
		Object userObj = request.getAttribute("user");
		if (userObj == null) {
			return false;
		}

		int userNumber;
		if (userObj instanceof UserDTO) {
			userNumber = ((UserDTO) userObj).getUserNumber();
		} else if (userObj instanceof BasicUserDTO) {
			userNumber = ((BasicUserDTO) userObj).getUserNumber();
		} else {
			return false;
		}

		HashMap<String, String> param = new HashMap<>();
		param.put("boardNumber", String.valueOf(boardNumber));
		param.put("userNumber", String.valueOf(userNumber));

		return service.boardHasLiked(param);
	}

	@RequestMapping("/boardLikes")
	public ResponseEntity<String> boardLikes(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
	    // 타입 체크를 통한 안전한 처리
	    Object userObj = request.getAttribute("user");
	    if (userObj == null) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("로그인필요");
	    }
	    
	    int userNumber;
	    if (userObj instanceof UserDTO) {
	        userNumber = ((UserDTO) userObj).getUserNumber();
	    } else if (userObj instanceof BasicUserDTO) {
	        userNumber = ((BasicUserDTO) userObj).getUserNumber();
	    } else {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("사용자 정보를 찾을 수 없습니다");
	    }
	    
	    int boardNumber = Integer.parseInt(param.get("boardNumber"));
	    param.put("userNumber", String.valueOf(userNumber));

	    try {
	        // 이미 좋아요를 눌렀는지 확인
	        if (service.boardHasLiked(param)) {
	            // 좋아요 취소 처리
	            service.boardRemoveLike(param);
	            return ResponseEntity.ok("추천 취소 완료");
	        } else {
	            // 좋아요 추가 처리
	            service.boardAddLike(param);
	            return ResponseEntity.ok("추천 완료");
	        }
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
	    }
	}

	@RequestMapping("/comment_write_ok")
	public String commentWriteOk(@RequestParam HashMap<String, String> param) {
		String boardNumber = param.get("boardNumber");
		if (param.get("commentContent") == "") {
			// 빈 댓글일 경우에도 skipViewCount=true 파라미터 추가
			return "redirect:/board_detail_view?boardNumber=" + boardNumber + "&skipViewCount=true";
		}
		bcService.bcWrite(param);

		return "redirect:/board_detail_view?boardNumber=" + boardNumber + "&skipViewCount=true";
	}

}