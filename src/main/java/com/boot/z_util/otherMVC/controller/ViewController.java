package com.boot.z_util.otherMVC.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.boot.apartment.dto.ApartmentTradeDTO;
import com.boot.apartment_recommend_detail.dto.ApartmentDTO;
import com.boot.apartment_recommend_detail.service.ApartmentRecommendService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.user.dto.UserDTO;
import com.boot.z_config.security.OAuth2AuthenticationSuccessHandler;
import com.boot.z_config.security.PrincipalDetails;
import com.boot.z_config.security.UserUtils;
import com.boot.z_util.otherMVC.service.UtilService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ViewController {

    private final OAuth2AuthenticationSuccessHandler OAuth2AuthenticationSuccessHandler;
	private int todayViews = 0;
	@Autowired
	private ApartmentRecommendService apartmentRecommendService;
	@Autowired
	private UtilService utilService;

    ViewController(OAuth2AuthenticationSuccessHandler OAuth2AuthenticationSuccessHandler) {
        this.OAuth2AuthenticationSuccessHandler = OAuth2AuthenticationSuccessHandler;
    }
//	@Autowired
//	private UserUtils userUtils;

	@RequestMapping("/")
	public String getMainBookInfo(Model model, HttpServletRequest request, HttpServletResponse response) {
		// 사용자 정보는 UserAttributeInterceptor에 의해 자동으로 모델에 추가됨
		// 따라서 다음 코드는 제거할 수 있음
		// UserDTO user = userUtils.extractUserFromRequest(request);
		// model.addAttribute("user", user);

		// 쿠키를 사용하여 방문 여부 확인
		boolean hasVisited = false;
		String todayDate = LocalDate.now().toString();

		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if (cookie.getName().equals("lastVisit") && cookie.getValue().equals(todayDate)) {
					hasVisited = true;
					break;
				}
			}
		}

		// 방문 기록이 없는 경우에만 카운트 증가
		if (!hasVisited) {
			todayViews += 1;
			// 방문 기록을 쿠키에 저장 (하루 동안 유효)
			Cookie visitCookie = new Cookie("lastVisit", todayDate);
			visitCookie.setPath("/");
			visitCookie.setMaxAge(24 * 60 * 60); // 24시간
			response.addCookie(visitCookie);
		}
		
//		model.addAttribute("currentPage", "main"); // 헤더 식별용
		model.addAttribute("todayViews", todayViews);

		// 사용자 정보가 필요한 경우 request(토큰)에서 가져옴
		
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		
//		System.out.println("user :" + user);
		if (user != null) {
//			System.out.println("user != null");
			List<ApartmentDTO> apartmentList = apartmentRecommendService.recommend(user);
			System.out.println("apartmentList => " + apartmentList);
			model.addAttribute("apartmentList", apartmentList);
		}
		
		int allApartmentCount = utilService.getAllApartmentCount();
		model.addAttribute("totalApartments", allApartmentCount);
		int avgPrice = utilService.getAvgPrice();
		model.addAttribute("averagePrice", avgPrice);

		return "main";
	}
//	@RequestMapping("/")
//	public String getMainBookInfo(Model model, HttpServletRequest request, HttpServletResponse response) {
//
//		UserDTO user = userUtils.extractUserFromRequest(request);
//
//		model.addAttribute("user", user);
//
//		System.out.println("user: " + user);
//
//		// 쿠키를 사용하여 방문 여부 확인
//		boolean hasVisited = false;
//		String todayDate = LocalDate.now().toString();
//
//		Cookie[] cookies = request.getCookies();
//		if (cookies != null) {
//			for (Cookie cookie : cookies) {
//				if (cookie.getName().equals("lastVisit") && cookie.getValue().equals(todayDate)) {
//					hasVisited = true;
//					break;
//				}
//			}
//		}
//
//		// 방문 기록이 없는 경우에만 카운트 증가
//		if (!hasVisited) {
//			todayViews += 1;
//			// 방문 기록을 쿠키에 저장 (하루 동안 유효)
//			Cookie visitCookie = new Cookie("lastVisit", todayDate);
//			visitCookie.setPath("/");
//			visitCookie.setMaxAge(24 * 60 * 60); // 24시간
//			response.addCookie(visitCookie);
//		}
//
//		model.addAttribute("currentPage", "main"); // 헤더 식별용
//		model.addAttribute("todayViews", todayViews);
//		if (user != null) {
//			List<ApartmentTradeDTO> apartmentList = apartmentTradeService.recommend(user);
//			model.addAttribute("apartmentList", apartmentList);
//		}
//
//		return "main";
//	}

	@RequestMapping("/loginForm")
	public String loginPage(HttpServletRequest request, Model model) {
		// 로그인 페이지에도 사용자 정보 추가 (이미 로그인한 경우를 위해)
//		UserDTO user = userUtils.extractUserFromRequest(request);
//		model.addAttribute("user", user);

		return "user/login";
	}

	@RequestMapping("/joinForm")
	public String join(HttpServletRequest request, Model model) {
		// 회원가입 페이지에도 사용자 정보 추가 (이미 로그인한 경우를 위해)
//		UserDTO user = userUtils.extractUserFromRequest(request);
//		model.addAttribute("user", user);

		return "user/join";
	}



	@RequestMapping("/privacy")
	public String privacy(HttpServletRequest request, Model model) {
//		UserDTO user = userUtils.extractUserFromRequest(request);
//		model.addAttribute("user", user);

		return "privacy";
	}

}
