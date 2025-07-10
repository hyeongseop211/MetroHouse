<%@page import="com.boot.user.dto.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메트로하우스 - 지하철역 주변 아파트 시세</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/resources/css/main.css">
	<script src="/resources/js/subway_section.js"></script>
	<script src="/resources/js/main.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
    <jsp:include page="header.jsp" />
    <div class="container">
	<c:choose>
	    <c:when test="${not empty user}">
            <div class="slider-container">
                <div class="image-slider">
                    <div class="slide active">
                        <img src="/resources/images/main1.png" alt="슬라이드 1">
                        <div class="slide-content">
                            <h2>지하철역 주변 아파트 시세를 한눈에</h2>
                            <p>메트로하우스와 함께 지하철역 주변 아파트 시세를 쉽고 빠르게 확인하세요.</p>
                            <a href="/search_map?majorRegion=서울&district=강남구&station=강남역" class="slide-button">지도에서 보기</a>
                        </div>
                    </div>
                    <div class="slide">
                        <img src="/resources/images/main2.png" alt="슬라이드 2">
                        <div class="slide-content">
                            <h2>관심 아파트 등록하고 시세 변동 확인</h2>
                            <p>관심있는 아파트를 등록하고 시세 변동을 실시간으로 확인하세요.</p>
                            <a href="/favorite_apartment" class="slide-button">관심 아파트 보기</a>
                        </div>
                    </div>
                    <div class="slide">
                        <img src="/resources/images/main3.png" alt="슬라이드 3">
                        <div class="slide-content">
                            <h2>지역별 아파트 시세 비교</h2>
                            <p>다양한 지역의 아파트 시세를 비교하고 최적의 선택을 하세요.</p>
                            <a href="/search_map?majorRegion=서울&district=강남구&station=강남역" class="slide-button">시세 비교하기</a>
                        </div>
                    </div>
                    <div class="slide">
                        <img src="/resources/images/main4.png" alt="슬라이드 4">
                        <div class="slide-content">
                            <h2>맞춤형 아파트 추천 서비스</h2>
                            <p>회원님의 관심사에 맞는 아파트를 추천해 드립니다.</p>
                            <a href="/user_apartment_recommend" class="slide-button">추천 받기</a>
                        </div>
                    </div>
                    <div class="slide">
                        <img src="/resources/images/main5.png" alt="슬라이드 5">
                        <div class="slide-content">
                            <h2>최신 부동산 트렌드 정보</h2>
                            <p>최신 부동산 시장 동향과 트렌드 정보를 확인하세요.</p>
                            <a href="/board_view" class="slide-button">게시판 보기</a>
                        </div>
                    </div>
                </div>
                <!-- 슬라이더 인디케이터 -->
                <div class="slider-indicators">
                    <div class="indicator active" data-index="0"></div>
                    <div class="indicator" data-index="1"></div>
                    <div class="indicator" data-index="2"></div>
                    <div class="indicator" data-index="3"></div>
                    <div class="indicator" data-index="4"></div>
                </div>
            </div>

            <div class="welcome-banner">
                <div class="welcome-text">
					<h1>안녕하세요, <span>${user.userName}</span>님!</h1>
                    <p>메트로하우스 서비스에 오신 것을 환영합니다. 오늘도 좋은 하루 되세요.</p>
                </div>
                <div class="date-display">
                    <i class="fas fa-calendar-alt"></i> <span id="current-date">
						<jsp:useBean id="now" class="java.util.Date" />
						    <fmt:formatDate value="${now}" pattern="yyyy년 MM월 dd일 EEEE" />
                    </span>
                </div>
            </div>

            <div class="search-header">
                <h1 class="search-title">
                    <i class="fas fa-subway"></i> 지하철역 검색
                </h1>

                <form class="search-form" id="search-form">
                    <!-- 필터 옵션 -->
                    <div class="search-filters">
                        <div class="search-filter">
                            <label class="filter-label" for="majorRegion">지역</label>
                            <select class="filter-select" id="majorRegion" name="majorRegion">
                                <option value="">선택하세요</option>
                                <option value="서울" ${param.majorRegion == '서울' ? 'selected' : ''}>서울특별시</option>
                                <option value="부산" ${param.majorRegion == '부산' ? 'selected' : ''}>부산광역시</option>
                                <option value="대구" ${param.majorRegion == '대구' ? 'selected' : ''}>대구광역시</option>
                                <option value="인천" ${param.majorRegion == '인천' ? 'selected' : ''}>인천광역시</option>
                                <option value="광주" ${param.majorRegion == '광주' ? 'selected' : ''}>광주광역시</option>
                                <option value="대전" ${param.majorRegion == '대전' ? 'selected' : ''}>대전광역시</option>
                                <option value="울산" ${param.majorRegion == '울산' ? 'selected' : ''}>울산광역시</option>
                                <option value="경기" ${param.majorRegion == '경기' ? 'selected' : ''}>경기도</option>
                            </select>
                        </div>
                    
                        <div class="search-filter">
                            <label class="filter-label" for="district">구/군</label>
                            <select class="filter-select" id="district" name="district">
                                <option value="">구/군 선택</option>
                                <!-- 대분류에 따라 동적으로 변경됩니다 -->
                            </select>
                        </div>
                    
                        <div class="search-filter">
                            <label class="filter-label" for="station">지하철역</label>
                            <select class="filter-select" id="station" name="station">
                                <option value="">지하철역 선택</option>
                                <!-- 구/군에 따라 동적으로 변경됩니다 -->
                            </select>
                        </div>
                        
                        <div class="search-button-container">
                            <button type="button" class="search-icon-button" onclick="fn_submit()">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Statistics Dashboard -->
            <div class="stats-dashboard">
                <div class="stat-card">
                    <div class="stat-icon books">
                        <i class="fas fa-building"></i>
                    </div>
                    <div class="stat-info">
                        <h3>전체 아파트</h3>
                        <div class="number">
                            ${totalApartments}
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon users">
                        <i class="fas fa-subway"></i>
                    </div>
                    <div class="stat-info">
                        <h3>등록된 지하철역</h3>
                        <div class="number">
                            <fmt:formatNumber value="713" type="number" />
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon borrowed">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="stat-info">
                        <h3>평균 매매가</h3>
                        <div class="number">
                            <fmt:formatNumber value="${averagePrice}" type="number" />만원
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon overdue">
                        <i class="fas fa-search-location"></i>
                    </div>
                    <div class="stat-info">
                        <h3>오늘 방문자 수</h3>
                        <div class="number">
                            <fmt:formatNumber value="${todayViews}" type="number" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Feature Cards -->
<!--            <div class="feature-section">-->
<!--                <div class="feature-card">-->
<!--                    <div class="feature-icon">-->
<!--                        <i class="fas fa-heart"></i>-->
<!--                    </div>-->
<!--                    <div class="feature-content">-->
<!--                        <h3>관심 아파트</h3>-->
<!--                        <p>관심 있는 아파트의 시세 변동을 확인하고 실시간 알림을 받아보세요.</p>-->
<!--						<a href="favorite_apartment" class="btn-sm">바로가기</a>-->
<!--                    </div>-->
<!--                </div>-->

<!--                <div class="feature-card">-->
<!--                    <div class="feature-icon">-->
<!--                        <i class="fas fa-map-marked-alt"></i>-->
<!--                    </div>-->
<!--                    <div class="feature-content">-->
<!--                        <h3>지도 검색</h3>-->
<!--                        <p>지도에서 원하는 지역의 아파트 시세를 확인하고 주변 시설도 함께 살펴보세요.</p>-->
<!--                        <a href="map_search_view" class="btn-sm">바로가기</a>-->
<!--                    </div>-->
<!--                </div>-->

<!--                <div class="feature-card">-->
<!--                    <div class="feature-icon">-->
<!--                        <i class="fas fa-star"></i>-->
<!--                    </div>-->
<!--                    <div class="feature-content">-->
<!--                        <h3>추천 아파트</h3>-->
<!--                        <p>회원님의 관심사와 검색 패턴에 맞는 맞춤형 아파트를 추천해 드립니다.</p>-->
<!--                        <a href="user_apartment_recommend" class="btn-sm">바로가기</a>-->
<!--                    </div>-->
<!--                </div>-->
<!--            </div>-->

        <!-- Recommended Apartments -->
        <div class="recommended-books">
            <div class="section-header">
                <h2 class="section-title">
                    <i class="fas fa-thumbs-up"></i> 추천 아파트
                </h2>
<!--                <a href="/recommended_apartments" class="action-link"> 더보기-->
<!--                    <i class="fas fa-chevron-right"></i>-->
<!--                </a>-->
            </div>

            <div class="books-grid">
                <c:forEach var="apartment" items="${apartmentList}" varStatus="status">
                    <c:if test="${status.index <3}">
                        <div class="book-card">
                            <div class="book-cover">
                                <div class="book-cover-placeholder">
                                    <i class="fas fa-building"></i>
                                </div>
                            </div>
                            <div class="book-info">
                                    <%--                                    <h3 class="book-title">${apartment.apartmentName}</h3>--%>
                                <h3 class="book-title">${apartment.aptNm}</h3>
                                    <%--                                    <div class="book-author">지역: ${apartment.district} ${apartment.dong}--%>
                                <div class="book-author">지역: ${apartment.estateAgentSggNm}
                                </div>
                                    <%--                                    <div class="book-publisher">가까운 역: ${apartment.nearestStation}</div>--%>
                                <div class="book-date">
                                    건축년도:${apartment.buildYear}
                                        <%--                                        <fmt:formatDate value="${apartment.builtDate}"--%>
                                </div>

                                <div class="book-categories">
                                        <%--                                        <span class="book-category">${apartment.size}㎡</span>--%>
                                    <span class="book-category">${apartment.excluUseAr}㎡</span>
                                    <c:if test="${not empty apartment.floor}">
                                        <span class="book-category">${apartment.floor}층</span>
                                    </c:if>
                                </div>

                                <div class="book-status">
                                    <div class="book-availability available">
                                        <i class="fas fa-won-sign"></i>
                                            <%--                                            <fmt:formatNumber value="${apartment.price}"--%>
                                            ${apartment.dealAmount}만원
                                    </div>
                                    <a href="/apartment_detail?apartmentId=${apartment.apartmentId}"
                                       class="book-detail-button">상세보기</a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

	</c:when>
	    <c:otherwise>
                <div class="login-section">
                    <h2>메트로하우스에 오신 것을 환영합니다</h2>
                    <p>
                        메트로하우스는 지하철역 주변 아파트 시세를 확인할 수 있는 서비스를 제공합니다.<br>서비스를
                        이용하시려면 로그인이 필요합니다.
                    </p>
                    <a href="loginForm" class="btn"> <i class="fas fa-sign-in-alt"></i> 로그인 하러 가기
                    </a>
                    <p style="margin-top: 20px;">
                        계정이 없으신가요? <a href="joinForm">회원가입</a>
                    </p>
                </div>
</c:otherwise>
</c:choose>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Animate statistics numbers
            const statNumbers = document.querySelectorAll('.number');

            statNumbers.forEach(number => {
                const finalValue = number.textContent.trim();
                let startValue = 0;
                const duration = 1500;
                const increment = parseInt(finalValue.replace(/,/g, '')) / (duration / 20);

                const animateValue = () => {
                    startValue += increment;
                    if (startValue < parseInt(finalValue.replace(/,/g, ''))) {
                        number.textContent = Math.floor(startValue).toLocaleString();
                        requestAnimationFrame(animateValue);
                    } else {
                        number.textContent = finalValue;
                    }
                };

                requestAnimationFrame(animateValue);
            });

            // 슬라이더 인디케이터 기능
            const indicators = document.querySelectorAll('.indicator');
            const slides = document.querySelectorAll('.slide');

            indicators.forEach(indicator => {
                indicator.addEventListener('click', function () {
                    const index = this.getAttribute('data-index');

                    // 모든 슬라이드와 인디케이터에서 active 클래스 제거
                    slides.forEach(slide => slide.classList.remove('active'));
                    indicators.forEach(ind => ind.classList.remove('active'));

                    // 선택한 슬라이드와 인디케이터에 active 클래스 추가
                    slides[index].classList.add('active');
                    this.classList.add('active');
                });
            });

            // 슬라이드 자동 전환 함수
            function nextSlide() {
                var currentSlide = $('.slide.active');
                var nextSlide = currentSlide.next('.slide').length ? currentSlide.next('.slide') : $('.slide:first-child');

                // 인디케이터도 함께 업데이트
                var currentIndex = $('.slide').index(currentSlide);
                var nextIndex = $('.slide').index(nextSlide);

                $('.indicator').removeClass('active');
                $('.indicator[data-index="' + nextIndex + '"]').addClass('active');

                currentSlide.removeClass('active');
                nextSlide.addClass('active');
            }

            // 5초마다 슬라이드 전환
            setInterval(nextSlide, 5000);
        });
    </script>
</body>
</html>