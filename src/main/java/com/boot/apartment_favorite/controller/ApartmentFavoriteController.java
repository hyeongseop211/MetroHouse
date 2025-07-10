package com.boot.apartment_favorite.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.boot.apartment_favorite.dto.ApartmentFavoriteDTO;
import com.boot.apartment_favorite.service.ApartmentFavoriteService;
import com.boot.user.dto.BasicUserDTO;
import com.boot.z_page.PageDTO;
import com.boot.z_page.criteria.ApartmentFavoriteCriteriaDTO;

@Controller
public class ApartmentFavoriteController {
	@Autowired
	private ApartmentFavoriteService apartmentFavoriteService;

	// 관심목록 삭제
	@PostMapping("/apartment_favorite_remove")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> removeFavorite(@RequestParam("favoriteId") int favoriteId,
			HttpServletRequest request) {

		Map<String, Object> response = new HashMap<>();

		try {
			BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");

			if (user == null) {
				response.put("success", false);
				response.put("message", "로그인이 필요합니다.");
				return ResponseEntity.status(401).body(response);
			}

			int result = apartmentFavoriteService.removeFavoriteList(user.getUserNumber(), favoriteId);

			if (result > 0) {
				response.put("success", true);
				response.put("message", "관심목록에서 삭제되었습니다.");
			} else {
				response.put("success", false);
				response.put("message", "삭제에 실패했습니다.");
			}

			return ResponseEntity.ok(response);
		} catch (Exception e) {
			e.printStackTrace();
			response.put("success", false);
			response.put("message", "서버 오류가 발생했습니다.");
			return ResponseEntity.status(500).body(response);
		}
	}

	@RequestMapping("/favorite_apartment")
	public String getFavorites(Model model, HttpServletRequest request,
			ApartmentFavoriteCriteriaDTO apartmentFavoriteCriteriaDTO, @RequestParam(required = false) String region,
			@RequestParam(required = false) String district, @RequestParam(required = false) String priceRange,
			@RequestParam(defaultValue = "recent") String sort) {
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		System.out.println("user.getUserNumber() : " + user.getUserNumber());
		// 파라미터 맵 생성
		Map<String, Object> params = new HashMap<>();
		params.put("userNumber", user.getUserNumber());
		params.put("criteria", apartmentFavoriteCriteriaDTO);
		// 필터링 조건 추가
		if (region != null && !region.isEmpty()) {
			params.put("region", region);
		}
		if (district != null && !district.isEmpty()) {
			params.put("district", district);
		}
		if (priceRange != null && !priceRange.isEmpty()) {
			params.put("priceRange", priceRange);
		}
		params.put("sort", sort);

		// 데이터 조회 (Map을 사용하는 새로운 메서드 호출)
		List<ApartmentFavoriteDTO> favorites = apartmentFavoriteService.getFavoriteListByUserNumber(params);
		int total = apartmentFavoriteService.getFavoriteListCount(params);
		model.addAttribute("pageMaker", new PageDTO(total, apartmentFavoriteCriteriaDTO));
		model.addAttribute("favorites", favorites);
		model.addAttribute("region", region);
		model.addAttribute("district", district);
		model.addAttribute("priceRange", priceRange);
		model.addAttribute("sort", sort);
		return "apartment/apartment_favorite";
	}

	// 관심등록 insert
	@PostMapping("/favorite/insert")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> insertFavorite(@RequestBody HashMap<String, Object> param,
															  HttpServletRequest request) {
//		System.out.println("param 전체 => " + param);// 전체 파라미터 로그찍어보기
		BasicUserDTO user = (BasicUserDTO) request.getAttribute("user");
		Map<String, Object> response = new HashMap<>();
		if (user == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요합니다.");
			return ResponseEntity.status(401).body(response);
		}
		try {
			// lat, lng 파라미터 체크
//            System.out.println("여기왓소.2");
//            double lat = Double.parseDouble(latStr);
//            double lng = Double.parseDouble(lngStr);

//            System.out.println("여기왓소.3");
			System.out.println("test asdf");
			param.put("userNumber", user.getUserNumber());
//            System.out.println("여기왓당.");
			System.out.println("param 전체 => " + param);// 전체 파라미터 로그찍어보기
			int result = apartmentFavoriteService.addFavoriteList(param);
			System.out.println("param 전체 => " + param);// 전체 파라미터 로그찍어보기
//            System.out.println("여기왓당.2");

			if (result > 0) {
// insert 후 새로 생성된 favoriteId 응답에 포함 (insert 로직에서 반드시 favoriteId 반환)
				response.put("success", true);
				response.put("favoriteId", param.get("favoriteId"));
				return ResponseEntity.ok(response);
			} else {
//                System.out.println("여기왓당.4");
				response.put("success", false);
				response.put("message", "등록 실패");
				return ResponseEntity.status(500).body(response);
			}

		} catch (NumberFormatException e) {
			response.put("success", false);
			response.put("message", "위도/경도 값이 유효하지 않습니다.");
			return ResponseEntity.badRequest().body(response);
		} catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "서버 오류 발생");
            return ResponseEntity.status(500).body(response);
		}
	}
}
