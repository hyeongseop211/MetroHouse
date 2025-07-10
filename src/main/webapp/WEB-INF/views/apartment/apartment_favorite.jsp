<%@page import="com.boot.user.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관심 아파트 - 메트로하우스</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/favorite_apartment.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title"><i class="fas fa-heart"></i> 관심 아파트</h1>
            <p class="page-subtitle">회원님이 관심 등록한 아파트 목록입니다. 가격 변동 및 상세 정보를 확인하고 비교해보세요.</p>
            <div class="bubble-animation">
                <div class="bubble"></div>
                <div class="bubble"></div>
                <div class="bubble"></div>
            </div>
        </div>

        <div class="filter-section">
            <div class="filter-header">
                <h2 class="filter-title"><i class="fas fa-filter"></i> 필터</h2>
                <div class="filter-controls">
                    <button class="filter-reset"><i class="fas fa-undo"></i> 초기화</button>
                    <button class="filter-button"><i class="fas fa-search"></i> 검색</button>
                </div>
            </div>
            <div class="filter-row">
                <div class="filter-group">
                    <label class="filter-label">지역</label>
                    <select class="filter-select" id="regionSelect">
                        <option value="">전체</option>
                        <option value="서울">서울특별시</option>
                        <option value="경기">경기도</option>
                        <option value="인천">인천광역시</option>
                        <option value="부산">부산광역시</option>
                        <option value="대전">대전광역시</option>
                        <option value="대구">대구광역시</option>
                        <option value="광주">광주광역시</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">구/군</label>
                    <select class="filter-select" id="districtSelect">
                        <option value="">전체</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">가격 범위</label>
                    <select class="filter-select" id="priceRangeSelect">
                        <option value="">전체</option>
                        <option value="0-50000">5억 이하</option>
                        <option value="50000-100000">5억-10억</option>
                        <option value="100000-150000">10억-15억</option>
                        <option value="150000+">15억 이상</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">정렬</label>
                    <select class="filter-select" id="sortSelect">
                        <option value="recent">최근 등록순</option>
                        <option value="price-asc">가격 낮은순</option>
                        <option value="price-desc">가격 높은순</option>
                        <option value="size-asc">면적 작은순</option>
                        <option value="size-desc">면적 큰순</option>
                    </select>
                </div>
            </div>
        </div>

        <% 
        // 관심 아파트가 있는지 확인
        Object favoriteListObj = request.getAttribute("favorites");
        boolean hasFavorites = favoriteListObj != null && !((java.util.List<?>)favoriteListObj).isEmpty();
        
        if (hasFavorites) {
        %>
        <div class="apartment-grid">
            <c:forEach var="favorite" items="${favorites}" varStatus="status">
                <div class="apartment-card">
                    <div class="apartment-image">
                        <div class="apartment-icon">
                            <i class="fas fa-building"></i>
                        </div>
						<div class="apartment-favorite" onclick="removeFavorite('${favorite.favoriteId}')" data-favorite-id="${favorite.favoriteId}">
						    <i class="fas fa-heart"></i>
						</div>
                        <div class="apartment-badge">관심 등록</div>
                    </div>
                    <div class="apartment-content">
                        <h3 class="apartment-title">${favorite.aptNm}</h3>
                        <div class="apartment-location">
                            <i class="fas fa-map-marker-alt"></i>
                            ${favorite.estateAgentSggNm}
                        </div>
                        <div class="apartment-details">
                            <div class="detail-item">
                                <span class="detail-label">면적</span>
                                <span class="detail-value">${favorite.excluUseAr}㎡</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">층수</span>
                                <span class="detail-value">${not empty favorite.floor ? favorite.floor : '-'}층</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">건축년도</span>
                                <span class="detail-value">${favorite.buildYear}년</span>
                            </div>
                            <div class="detail-item">
                                <span class="detail-label">가까운 역</span>
                                <span class="detail-value">${favorite.subwayStation} (${favorite.subwayDistance}m)</span>
                            </div>
                        </div>
                        <div class="apartment-price">
                            <div>
                                <span class="price-value">
                                    ${favorite.dealAmount}
                                </span>
                                <span class="price-unit">만원</span>
                            </div>
                            <a href="/apartment_detail?apartmentId=${favorite.apartmentId}" class="apartment-button">
                                <i class="fas fa-info-circle"></i> 상세보기
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">
                <i class="fas fa-heart"></i>
            </div>
            <div class="emoji-box">
<!--                <span class="emoji">test</span>-->
                <span class="emoji-text">관심 등록한 아파트가 없어요!</span>
            </div>
            <p class="empty-description">
<!--                관심있는 아파트를 등록하면 이곳에서 한눈에 확인하고-->
<!--				<br> 가격 변동 알림을 받을 수 있습니다.-->
<!--                지금 마음에 드는 아파트를 찾아볼까요?-->
				
            </p>
            <a href="/search_map?majorRegion=서울&district=강남구&station=강남역" class="empty-button">
                <i class="fas fa-search"></i> 아파트 검색하기
            </a>
        </div>
        <% } %>
		<div class="div_page">
		    <ul>
		        <c:if test="${pageMaker.prev}">
		            <li class="paginate_button">
		                <a href="${pageMaker.startPage - 1}">
		                    <i class="fas fa-caret-left"></i>
		                </a>
		            </li>
		        </c:if>

		        <c:forEach var="num" begin="${pageMaker.startPage}"
		            end="${pageMaker.endPage}">
		            <li
		                class="paginate_button ${pageMaker.apartmentFavoriteCriteriaDTO.pageNum==num ? 'active' : ''}">
		                <a href="${num}">
		                    ${num}
		                </a>
		            </li>
		        </c:forEach>

		        <c:if test="${pageMaker.next}">
		            <li class="paginate_button">
		                <a href="${pageMaker.endPage+1}">
		                    <i class="fas fa-caret-right"></i>
		                </a>
		            </li>
		        </c:if>
		    </ul>
		</div>
		<form id="actionForm" action="favorite_apartment" method="get">
		    <input type="hidden" name="pageNum" value="${pageMaker.apartmentFavoriteCriteriaDTO.pageNum}">
		    <input type="hidden" name="amount" value="${pageMaker.apartmentFavoriteCriteriaDTO.amount}">
		    <c:if test="${not empty pageMaker.apartmentFavoriteCriteriaDTO.type}">
		        <input type="hidden" name="type" value="${pageMaker.apartmentFavoriteCriteriaDTO.type}">
		    </c:if>
		    <c:if test="${not empty pageMaker.apartmentFavoriteCriteriaDTO.keyword}">
		        <input type="hidden" name="keyword" value="${pageMaker.apartmentFavoriteCriteriaDTO.keyword}">
		    </c:if>
		    <c:if test="${not empty region}">
		        <input type="hidden" name="region" value="${region}">
		    </c:if>
		    <c:if test="${not empty district}">
		        <input type="hidden" name="district" value="${district}">
		    </c:if>
		    <c:if test="${not empty priceRange}">
		        <input type="hidden" name="priceRange" value="${priceRange}">
		    </c:if>
		    <c:if test="${not empty sort}">
		        <input type="hidden" name="sort" value="${sort}">
		    </c:if>
		</form>
    </div>

    <script>
        // 페이지 로드 시 URL 파라미터에 따라 필터 값 설정
        document.addEventListener('DOMContentLoaded', function() {
			
			const favoriteButtons = document.querySelectorAll('.apartment-favorite');

			favoriteButtons.forEach(button => {
			    button.addEventListener('mouseenter', function() {
			        const icon = this.querySelector('i');
			        icon.classList.remove('fa-heart');
			        icon.classList.add('fa-heart-broken');
			    });
			    
			    button.addEventListener('mouseleave', function() {
			        const icon = this.querySelector('i');
			        icon.classList.remove('fa-heart-broken');
			        icon.classList.add('fa-heart');
			    });
			});
			
            // URL 파라미터 가져오기
            const urlParams = new URLSearchParams(window.location.search);
            
            // 지역 설정
            const regionParam = urlParams.get('region');
            if (regionParam) {
                document.getElementById('regionSelect').value = regionParam;
                
                // 구/군 옵션 업데이트
                const districtSelect = document.getElementById('districtSelect');
                if (districtData[regionParam]) {
                    districtData[regionParam].forEach(district => {
                        const option = document.createElement('option');
                        option.value = district;
                        option.textContent = district;
                        districtSelect.appendChild(option);
                    });
                    
                    // 구/군 값 설정
                    const districtParam = urlParams.get('district');
                    if (districtParam) {
                        districtSelect.value = districtParam;
                    }
                }
            }
            
            // 가격 범위 설정
            const priceRangeParam = urlParams.get('priceRange');
            if (priceRangeParam) {
                document.getElementById('priceRangeSelect').value = priceRangeParam;
            }
            
            // 정렬 설정
            const sortParam = urlParams.get('sort');
            if (sortParam) {
                document.getElementById('sortSelect').value = sortParam;
            }
        });
		
		// 페이징처리
		var actionForm = $("#actionForm");

		// 페이지번호 처리
		$(".paginate_button a").on("click", function (e) {
		    e.preventDefault();
		    console.log("click했음");
		    console.log("@# href => " + $(this).attr("href"));

		    // 페이지 번호 설정
		    actionForm.find("input[name='pageNum']").val($(this).attr("href"));

		    // URL 파라미터 가져오기
		    const urlParams = new URLSearchParams(window.location.search);
		    
		    // 필터 파라미터 추가
		    const region = urlParams.get('region');
		    if (region) {
		        actionForm.find("input[name='region']").remove();
		        actionForm.append("<input type='hidden' name='region' value='" + region + "'>");
		    }
		    
		    const district = urlParams.get('district');
		    if (district) {
		        actionForm.find("input[name='district']").remove();
		        actionForm.append("<input type='hidden' name='district' value='" + district + "'>");
		    }
		    
		    const priceRange = urlParams.get('priceRange');
		    if (priceRange) {
		        actionForm.find("input[name='priceRange']").remove();
		        actionForm.append("<input type='hidden' name='priceRange' value='" + priceRange + "'>");
		    }
		    
		    const sort = urlParams.get('sort');
		    if (sort) {
		        actionForm.find("input[name='sort']").remove();
		        actionForm.append("<input type='hidden' name='sort' value='" + sort + "'>");
		    }

		    // 폼 제출
		    actionForm.attr("action", "favorite_apartment").submit();
		});

		// 게시글 처리
		$(".move_link").on("click", function (e) {
		    e.preventDefault();
		    console.log("move_link click");
		    console.log("@# click => " + $(this).attr("href"));

		    var targetBno = $(this).attr("href");

		    // 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 게시글 클릭 할 때 &boardNo=번호 게속 누적되는 거 방지)
		    var bno = actionForm.find("input[name='boardNo']").val();
		    if (bno != "") {
		        actionForm.find("input[name='boardNo']").remove();
		    }

		    // "content_view?boardNo=${dto.boardNo}"를 actionForm로 처리
		    actionForm.append("<input type='hidden' name='boardNo' value='" + targetBno + "'>");
		    // actionForm.submit();
		    // 컨트롤러에 content_view로 찾아감
		    actionForm.attr("action", "board_detail_view").submit();
		});

		// 검색처리
		var searchForm = $("#searchForm");

		$("#searchForm button").on("click", function () {
		    // alert("검색");

		    // 키워드 입력 받을 조건
		    if (searchForm.find("option:selected").val() != "" && !searchForm.find("input[name='keyword']").val()) {
		        alert("키워드를 입력하세요.");
		        return false;
		    }

		    // searchForm.find("input[name='pageNum']").val("1"); // 검색 시 1페이지로 이동
		    searchForm.attr("action", "favorite_apartment").submit();
		}); // end of searchForm click

		// type 콤보박스 변경
		$("#searchForm select").on("change", function () {
		    if (searchForm.find("option:selected").val() == "") {
		        // 키워드를 널값으로 변경
		        searchForm.find("input[name='keyword']").val("");
		    }
		}); // end of searchForm click 2
		
		
		
        // 지역별 구/군 데이터
        const districtData = {
            '서울': ['강남구', '서초구', '송파구', '강동구', '강북구', '강서구', '관악구', '광진구', '구로구', '금천구', '노원구', '도봉구', '동대문구', '동작구', '마포구', '서대문구', '성동구', '성북구', '양천구', '영등포구', '용산구', '은평구', '종로구', '중구', '중랑구'],
            '경기': ['수원시', '성남시', '고양시', '용인시', '부천시', '안산시', '안양시', '남양주시', '화성시', '평택시', '의정부시', '시흥시', '파주시', '광명시', '김포시', '군포시', '광주시', '이천시', '양주시', '오산시', '구리시', '안성시', '포천시', '의왕시', '하남시', '여주시', '양평군', '동두천시', '과천시', '가평군', '연천군'],
            '인천': ['중구', '동구', '미추홀구', '연수구', '남동구', '부평구', '계양구', '서구', '강화군', '옹진군'],
            '부산': ['강서구','북구','사상구','사하구','동래구','연제구','금정구','부산진구','중구','영도구','동구','서구','해운대구','수영구','남구','기장군'],
            '대전': ['동구','중구','서구','유성구','대덕구'],
            '대구': ['동구','중구','서구','남구','북구','수성구','달서구','달성군'],
            '광주': ['동구','서구','남구','북구','광산구']
        };

        // 지역 선택 시 구/군 목록 업데이트
        document.getElementById('regionSelect').addEventListener('change', function() {
            const districtSelect = document.getElementById('districtSelect');
            const selectedRegion = this.value;
            
            // 구/군 select 초기화
            districtSelect.innerHTML = '<option value="">전체</option>';
            
            // 선택된 지역에 해당하는 구/군 추가
            if (selectedRegion && districtData[selectedRegion]) {
                districtData[selectedRegion].forEach(district => {
                    const option = document.createElement('option');
                    option.value = district;
                    option.textContent = district;
                    districtSelect.appendChild(option);
                });
            }
        });

		function removeFavorite(favoriteId) {
		    console.log("@#asdf => " + favoriteId);
		    if (confirm('정말로 이 아파트를 관심 목록에서 삭제하시겠습니까?')) {
		        $.ajax({
		            type: "post",
		            data: { favoriteId: favoriteId },  // 객체 형태로 전달
		            url: "apartment_favorite_remove",
		            success: function(data) {
		                alert("관심 목록에서 삭제되었습니다.");
		                location.reload(); // 페이지 새로고침
		            },
		            error: function() {
		                alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		            }
		        });
		    }
		}
        
        // 필터 초기화 버튼
        document.querySelector('.filter-reset').addEventListener('click', function() {
            document.querySelectorAll('.filter-select').forEach(select => {
                select.selectedIndex = 0;
            });
            // 구/군 선택지 초기화
            const districtSelect = document.getElementById('districtSelect');
            districtSelect.innerHTML = '<option value="">전체</option>';
        });
        
		// 필터 검색 버튼
		document.querySelector('.filter-button').addEventListener('click', function() {
		    // 현재 URL 가져오기
		    const url = new URL(window.location.href);
		    
		    // 페이지 파라미터 초기화 (첫 페이지로)
		    url.searchParams.set('pageNum', '1');
		    
		    // 필터 값 가져오기
		    const region = document.getElementById('regionSelect').value;
		    const district = document.getElementById('districtSelect').value;
		    const priceRange = document.getElementById('priceRangeSelect').value;
		    const sort = document.getElementById('sortSelect').value;
		    
		    // URL 파라미터 설정
		    if (region) url.searchParams.set('region', region);
		    else url.searchParams.delete('region');
		    
		    if (district) url.searchParams.set('district', district);
		    else url.searchParams.delete('district');
		    
		    if (priceRange) url.searchParams.set('priceRange', priceRange);
		    else url.searchParams.delete('priceRange');
		    
		    if (sort) url.searchParams.set('sort', sort);
		    else url.searchParams.delete('sort');
		    
		    // 페이지 이동
		    window.location.href = url.toString();
		});
		
    </script>
</body>
</html>