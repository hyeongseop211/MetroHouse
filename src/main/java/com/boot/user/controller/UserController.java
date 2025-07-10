package com.boot.user.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.boot.board.service.BoardCommentServiceImpl;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.user.service.UserService;
import com.boot.z_config.security.UserUtils;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class UserController {

    private final BoardCommentServiceImpl boardCommentServiceImpl;
	@Autowired
	private UserService service;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;
//	@Autowired
//	private UserUtils userUtils;

    UserController(BoardCommentServiceImpl boardCommentServiceImpl) {
        this.boardCommentServiceImpl = boardCommentServiceImpl;
    }
//	@RequestMapping("/login_ok")
//	public String login(HttpServletRequest request, @RequestParam HashMap<String, String> param) {
//		ArrayList<UserDTO> dtos = service.userLogin(param);
//
//		if (dtos.isEmpty()) {
//			// 사용자가 존재하지 않는 경우
//			return "redirect:loginView?error=invalid";
//		} else {
////	        if (param.get("userPw").equals(dtos.get(0).getUserPw())) {
//			if (passwordEncoder.matches(param.get("userPw"), dtos.get(0).getUserPw())) {
//				UserDTO dto = service.getUserInfo(param);
//
//				// 사용자 ID 가져오기
//				String userId = dto.getUserId();
//
//				// 새 세션 생성
//				HttpSession session = request.getSession(true);
//				session.setAttribute("loginUser", dto);
//
//				// 세션 정보 저장
//				HashMap<String, String> sessionParam = new HashMap<>();
//				sessionParam.put("userId", userId);
//				sessionParam.put("sessionId", session.getId());
//
//				return "redirect:";
//			}
//			// 비밀번호가 일치하지 않는 경우
//			return "redirect:loginView?error=invalid";
//		}
//	}

	@RequestMapping("/joinProc")
	public ResponseEntity<String> join(HttpServletRequest request, @RequestParam HashMap<String, String> param) {

		System.out.println("@#param => " + param);
		if (service.checkId(param) != null) {

		} else {
			int re = service.userJoin(param);
			if (re == 1) {
				return ResponseEntity.ok("available");
			}
		}
		return ResponseEntity.status(HttpStatus.CONFLICT).body("duplicate");
	}

	@RequestMapping("/user_info")
	public String getUserInfo(int u_number) {
		return "user/user_info";
	}

	@RequestMapping("/mypage")
	public String myPage(HttpServletRequest request, Model model) {
	    // request에서 사용자 정보 추출 (SafeUserDTO 또는 UserDTO)
	    Object userObj = request.getAttribute("user");
	    
	    // 사용자 정보가 없으면 로그인 페이지로 리다이렉트
	    if (userObj == null) {
	        return "redirect:/loginForm";
	    }
	    
	    // 사용자 ID 추출
	    String userId = null;
	    if (userObj instanceof BasicUserDTO) {
	        userId = ((BasicUserDTO) userObj).getUserId();
	    } else if (userObj instanceof UserDTO) {
	        userId = ((UserDTO) userObj).getUserId();
	    } else {
	        return "redirect:/loginForm";
	    }
	    
	    // 사용자 ID로 데이터베이스에서 전체 사용자 정보 조회
	    HashMap<String, String> param = new HashMap<>();
	    param.put("userId", userId);
	    UserDTO user = service.getUserInfo(param);
	    
	    if (user == null) {
	        return "redirect:/loginForm";
	    }
	    
	    // 사용자 정보를 모델에 추가
	    model.addAttribute("user", user);
	    
	    // 사용자 통계 정보 조회
//	    int userFavoriteCount = service.getUserFavoriteCount(user.getUserNumber());
//	    int userViewCount = service.getUserViewCount(user.getUserNumber());
//	    int userSearchCount = service.getUserSearchCount(user.getUserNumber());
	    
//	    model.addAttribute("userFavoriteCount", userFavoriteCount);
//	    model.addAttribute("userViewCount", userViewCount);
//	    model.addAttribute("userSearchCount", userSearchCount);
	    
	    System.out.println("userObj : " + userObj);
	    System.out.println("user : " + user);
	    return "user/mypage";
	}

	@RequestMapping("/user_update_view")
	public String updateUserInfo(UserDTO user) {
		return "user/user_update";
	}

//	@RequestMapping("/userUpdate")
//	public String updateUserInfo(@RequestParam HashMap<String, String> param, HttpSession session) {
//		int result = service.updateUserInfo(param);
//		if (result > 0) {
//			session.invalidate(); // 세션 초기화 → 자동 로그아웃
//			return "redirect:/loginView"; // 로그인 페이지로
//		} else {
//			return "redirect:/mypage"; // 실패 시 다시 수정 화면
//		}
//
//	}
	@RequestMapping("/userUpdate")
	@ResponseBody
	public Map<String, Object> updateUserInfo(@RequestParam HashMap<String, String> param, HttpSession session) {
		Map<String, Object> response = new HashMap<>();

		int result = service.updateUserInfo(param);
		if (result > 0) {
			response.put("success", true);
			response.put("message", "회원 정보가 성공적으로 수정되었습니다.");
			session.invalidate(); // 세션 초기화 → 자동 로그아웃
		} else {
			response.put("success", false);
			response.put("message", "회원 정보 수정에 실패했습니다.");
		}

		return response;
	}

	@RequestMapping("/userPwUpdate")
	@ResponseBody // JSON 응답을 반환하기 위해 추가
	public Map<String, Object> updateUserPwInfo(@RequestParam HashMap<String, String> param, HttpSession session) {
		Map<String, Object> response = new HashMap<>();
		UserDTO user = (UserDTO) session.getAttribute("loginUser");
		int result = -1;

		String inputPw = param.get("userPw");
		String newPw = param.get("userNewPw");

		// 사용자 ID 추가
		param.put("userId", user.getUserId());

		// BCryptPasswordEncoder를 사용하여 비밀번호 검증
		if (service.verifyPassword(param)) {
			// 비밀번호가 일치하면 새 비밀번호로 암호화하여 업데이트
			param.put("userNumber", String.valueOf(user.getUserNumber())); // 사용자 번호 추가

			// 새 비밀번호 암호화 - 명시적으로 추가
			String encodedPassword = passwordEncoder.encode(newPw);
			param.put("encodedPassword", encodedPassword);

			result = service.updateUserPwInfo(param);
		}

		if (result > 0) {
			response.put("success", true);
			response.put("message", "비밀번호가 성공적으로 변경되었습니다. 다시 로그인해주세요.");
			session.invalidate(); // 세션 초기화 → 자동 로그아웃
		} else {
			response.put("success", false);
			response.put("message", "현재 비밀번호가 일치하지 않습니다.");
		}

		return response;
	}

	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
//		HttpSession session = request.getSession(false);
//
//		if (session != null) {
//			// 세션에서 사용자 정보 가져오기
//			UserDTO user = (UserDTO) session.getAttribute("loginUser");
//
////	        if (user != null) {
////	            // 데이터베이스에서 세션 정보 삭제
////	            String userId = user.getUserId();
////	            HashMap<String, String> param = new HashMap<>();
////	            param.put("userId", userId);
////	            
////	            try {
////	                // 세션 정보 삭제
////	                System.out.println("로그아웃: 사용자 " + userId + "의 세션 정보가 데이터베이스에서 삭제됨");
////	            } catch (Exception e) {
////	                System.out.println("세션 정보 삭제 중 오류 발생: " + e.getMessage());
////	                e.printStackTrace();
////	            }
////	        }
//
//			// 세션 무효화
//			session.invalidate();
////	        System.out.println("로그아웃: 세션이 무효화됨");
//		}

		return "redirect:loginForm";
	}

	@RequestMapping(value = "/checkExistingSession", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> checkExistingSession(@RequestParam("userId") String userId) {
		Map<String, Object> response = new HashMap<>();

		try {
//	        log.info("세션 확인 요청: userId={}", userId);

			// 간단한 구현: 항상 세션이 없다고 응답
			response.put("exists", false);

			return ResponseEntity.ok(response);
		} catch (Exception e) {
			log.error("세션 확인 중 오류 발생: " + e.getMessage(), e);
			response.put("error", "세션 확인 중 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}

	// 사용자 비밀번호 검증위한것
	@RequestMapping("/verifyPassword")
	@ResponseBody
	public Map<String, Object> verifyPassword(@RequestParam HashMap<String, String> param) {
		Map<String, Object> response = new HashMap<>();

		// 사용자 ID와 비밀번호로 검증
		boolean isValid = service.verifyPassword(param);
		log.info("@#test=>" + param);
		response.put("success", isValid);
		if (!isValid) {
			response.put("message", "비밀번호가 일치하지 않습니다.");
		}

		return response;
	}
}