<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아파트 상세</title>
    
    <!-- 폰트 및 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
    <link rel="stylesheet" type="text/css" href="/resources/css/apartment_detail.css">
	
	<!-- Chart.js -->
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


    <!--새로추가  JSP 데이터 바인딩용 전역 변수 선언 json 으로 넘기기 -->
    <script>
        const favoriteList = JSON.parse('<c:out value="${empty favoriteListJson ? '[]' : favoriteListJson}" escapeXml="false" />');
        const currentUserNumber = ${user.userNumber};
        const currentApartmentId = ${apartment.apartmentId}; // 현재 아파트 ID
    </script>
<%--새로추가 favorite 상태판단 초기세팅--%>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const $btn = $("#favoriteBtn");
            const apartmentId = $btn.data("apartment-id");

            const matched = favoriteList.find(item =>
                String(item.apartmentId).trim() === String(apartmentId).trim() &&
                String(item.userNumber).trim() === String(currentUserNumber).trim()
            );

            if (matched) {
                // 이미 등록된 경우
                $btn.data("favorite", true);
                $btn.data("favorite-id", matched.favoriteId);
                $btn.html('<i class="fas fa-heart-broken"></i> 관심 해제');
                $btn.css("background-color", "#e74c3c");
            } else {
                // 미등록 상태
                $btn.data("favorite", false);
                $btn.data("favorite-id", "");
                $btn.html('<i class="fas fa-heart"></i> 관심 등록');
                $btn.css("background-color", "#3498db");
            }
        });

        //  클릭 이벤트 처리 로직

        $(document).on("click", "#favoriteBtn", function () {
            const $btn = $(this);
            const apartmentId = $btn.data("apartment-id");
            const isFavorite = $btn.data("favorite") === true || $btn.data("favorite") === "true";
            const favoriteId = $btn.data("favorite-id");

            $btn.prop("disabled", true);

            if (isFavorite) {
                $.ajax({
                    url: "/apartment_favorite_remove",
                    type: "POST",
                    data: { favoriteId: favoriteId },
                    success: () => {
                        alert("관심 목록에서 삭제되었습니다.");
                        $btn.data("favorite", false);
                        $btn.data("favorite-id", "");
                        $btn.html('<i class="fas fa-heart"></i> 관심 등록');
                        $btn.css("background-color", "#3498db");
                        $btn.prop("disabled", false);
                    },
                    error: () => {
                        alert("관심 해제 실패");
                        $btn.prop("disabled", false);
                    },
                });
            } else {
                $.ajax({
                    url: "/favorite/insert",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ apartmentId: apartmentId }),
                    success: (res) => {
                        if (res.success) {
                            alert("관심 목록에 등록되었습니다.");
                            $btn.data("favorite", true);
                            $btn.data("favorite-id", res.favoriteId);
                            $btn.html('<i class="fas fa-heart-broken"></i> 관심 해제');
                            $btn.css("background-color", "#e74c3c");
                        } else {
                            alert(res.message || "관심 등록 실패");
                        }
                        $btn.prop("disabled", false);
                    },
                    error: () => {
                        alert("관심 등록 실패");
                        $btn.prop("disabled", false);
                    },
                });
            }
        });
    </script>
</head>

<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="apartment-detail fade-in">
            <!-- 좌측 사이드바 -->
            <div class="apartment-sidebar">
                <div class="apartment-title-container">
                    <h2 class="apartment-title">${apartment.aptNm}</h2>
                </div>
                
                <p class="apartment-location">${apartment.estateAgentSggNm}</p>
                
                <div class="apartment-categories">
                    <span class="apartment-category">매매</span>
                    <c:if test="${not empty apartment.dealAmount}">
                        <span class="apartment-price">${apartment.dealAmount}만원</span>
                    </c:if>
                </div>
                
                <div class="apartment-image-section">
                    <div class="apartment-cover">
                        <div class="apartment-cover-placeholder" id="placeholder-${apartment.apartmentId}">
                            <i class="fas fa-building"></i>
                        </div>
                    </div>

                    <div class="apartment-status">
                        <div class="status-badge available">
                            <i class="fas fa-check-circle"></i> 매매 가능
                        </div>
                        <div class="status-badge count-badge">
                            <i class="fas fa-home"></i> 면적: ${apartment.excluUseAr}㎡
                        </div>
                    </div>

                    <div class="apartment-info-grid">
                        <div class="apartment-meta-item">
                            <span class="meta-label">건축년도</span>
                            <span class="meta-value">${apartment.buildYear}년</span>
                        </div>
                        <div class="apartment-meta-item">
                            <span class="meta-label">층수</span>
                            <span class="meta-value">${apartment.floor}층</span>
                        </div>
                        <div class="apartment-meta-item">
                            <span class="meta-label">지하철역</span>
                            <span class="meta-value">${apartment.subwayStation}</span>
                        </div>
                        <div class="apartment-meta-item">
                            <span class="meta-label">거리</span>
                            <span class="meta-value">${apartment.subwayDistance}m</span>
                        </div>
                    </div>

                    <div class="apartment-actions">
<%--                        <button class="action-button secondary-button" onclick="addToFavorites('${apartment.apartmentId}')">--%>
<%--                            <i class="fas fa-heart"></i> 관심목록에 추가--%>
<%--                        </button>--%>
    <!-- 관심 등록/해제 버튼 (초기 상태는 JS에서 판단해서 교체됨) -->
    <button id="favoriteBtn"
            class="overlay-button favorite"
            data-apartment-id="${apartment.apartmentId}"
            data-favorite-id=""
            data-favorite="false"
            style="width: 100%; padding: 10px; font-size: 14px; font-weight: bold; border: none; border-radius: 6px; background-color: #3498db; color: white; cursor: pointer;">
        <i class="fas fa-heart"></i> 관심 등록
    </button>
                    </div>
                </div>
            </div>

            <!-- 우측 콘텐츠 영역 -->
            <div class="apartment-content">
                <div class="tabs">
                    <ul class="tab-list" role="tablist">
                        <li class="tab-item active" role="tab" aria-selected="true" data-tab="description">아파트 정보</li>
                        <li class="tab-item" role="tab" aria-selected="false" data-tab="reviews">리뷰 및 평점</li>
                    </ul>

                    <div class="tab-content">
<!--                        <div id="description" class="tab-panel active" role="tabpanel">-->
<!--                            그래프넣을예정-->
<!--                        </div>-->
						<div id="description" class="tab-panel active" role="tabpanel">
						    <div class="price-graph-container">
						        <h3 class="graph-title">실제 거래 데이터</h3>
						        <div class="price-graph">
						            <canvas id="priceChart"></canvas>
						        </div>
						    </div>
						</div>

                        <div id="reviews" class="tab-panel" role="tabpanel">
                            <div class="reviews-section">
                                <div class="review-stats">
                                    <div class="average-rating">
                                        <div class="rating-value">${reviewStats.averageRating}</div>
                                        <div class="rating-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= Math.floor(reviewStats.averageRating)}">
                                                        <i class="fas fa-star"></i>
                                                    </c:when>
                                                    <c:when test="${i == Math.ceil(reviewStats.averageRating) && reviewStats.averageRating % 1 != 0}">
                                                        <i class="fas fa-star-half-alt"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="far fa-star"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                        <div class="rating-count">총 ${reviewStats.totalReviews}개 리뷰</div>
                                    </div>
                                    <div class="rating-distribution">
                                        <div class="rating-bar">
                                            <span class="rating-label">5</span>
                                            <div class="rating-progress">
                                                <div class="rating-progress-fill" style="width: ${reviewStats.fiveStarPercentage}%"></div>
                                            </div>
                                            <span class="rating-percent">${reviewStats.fiveStarPercentage}%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-label">4</span>
                                            <div class="rating-progress">
                                                <div class="rating-progress-fill" style="width: ${reviewStats.fourStarPercentage}%"></div>
                                            </div>
                                            <span class="rating-percent">${reviewStats.fourStarPercentage}%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-label">3</span>
                                            <div class="rating-progress">
                                                <div class="rating-progress-fill" style="width: ${reviewStats.threeStarPercentage}%"></div>
                                            </div>
                                            <span class="rating-percent">${reviewStats.threeStarPercentage}%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-label">2</span>
                                            <div class="rating-progress">
                                                <div class="rating-progress-fill" style="width: ${reviewStats.twoStarPercentage}%"></div>
                                            </div>
                                            <span class="rating-percent">${reviewStats.twoStarPercentage}%</span>
                                        </div>
                                        <div class="rating-bar">
                                            <span class="rating-label">1</span>
                                            <div class="rating-progress">
                                                <div class="rating-progress-fill" style="width: ${reviewStats.oneStarPercentage}%"></div>
                                            </div>
                                            <span class="rating-percent">${reviewStats.oneStarPercentage}%</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="review-form">
                                    <h3 class="form-title">리뷰 작성하기</h3>
                                    <form id="reviewForm">
                                        <input type="hidden" name="reviewId" id="reviewId" value="">
                                        <input type="hidden" name="apartmentId" id="apartmentIdInput" value="${apartment.apartmentId}">
                                        <div class="form-group">
                                            <div class="rating-input">
                                                <i class="far fa-star" data-rating="1"></i>
                                                <i class="far fa-star" data-rating="2"></i>
                                                <i class="far fa-star" data-rating="3"></i>
                                                <i class="far fa-star" data-rating="4"></i>
                                                <i class="far fa-star" data-rating="5"></i>
                                            </div>
                                            <input type="hidden" name="rating" id="ratingInput" value="0">
                                        </div>
                                        <div class="form-group">
                                            <input type="text" class="form-control" id="reviewTitle" name="title" placeholder="리뷰 제목을 입력하세요" required>
                                        </div>
                                        <div class="form-group">
                                            <textarea class="form-control" id="reviewContent" name="content" placeholder="리뷰 내용을 입력하세요" required></textarea>
                                        </div>
                                        <div class="form-actions">
                                            <button type="button" class="action-button secondary-button" onclick="resetReviewForm()">초기화</button>
                                            <button type="button" class="action-button primary-button" onclick="submitReview()">리뷰 등록</button>
                                        </div>
                                    </form>
                                </div>

                                <div class="reviews-list">
                                    <!-- 리뷰 목록 반복 -->
                                    <c:forEach var="review" items="${reviewList}">
                                        <div class="review-card">
                                            <input type="hidden" class="review-id-hidden" value="${review.reviewId}">
                                            <div class="review-header">
                                                <div class="reviewer-info">
                                                    <div class="reviewer-name-date">
                                                        <span class="reviewer-name">${review.userName}</span>
                                                        <span class="review-date"><fmt:formatDate value="${review.reviewDate}" pattern="yyyy-MM-dd" /></span>
                                                    </div>
                                                </div>
                                                <div class="review-actions-top">
                                                    <span class="helpful-container">
                                                        <i class="${review.helpfulByCurrentUser ? 'fas' : 'far'} fa-thumbs-up review-action-icon like ${review.helpfulByCurrentUser ? 'active' : ''}" 
                                                           onclick="markHelpful(${review.reviewId}, this)" 
                                                           title="도움됨"></i>
                                                        <span class="helpful-count">${review.helpfulCount}</span>
                                                    </span>
                                                    
                                                    <c:choose>
                                                        <c:when test="${user != null && user.userNumber == review.userNumber}">
                                                            <div class="review-edit-delete" data-user-number="${review.userNumber}">
                                                                <i class="fas fa-edit review-action-icon edit" title="수정"></i>
                                                                <i class="fas fa-trash-alt review-action-icon delete" 
                                                                   onclick="confirmDeleteReview(${review.reviewId})" 
                                                                   title="삭제"></i>
                                                            </div>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="review-rating">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= review.reviewRating}">
                                                            <i class="fas fa-star"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="far fa-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                            
                                            <div class="review-title-rating">
                                                <h4 class="review-title">${review.reviewTitle}</h4>
                                            </div>
                                            
                                            <div class="review-content">
                                                <p>${review.reviewContent}</p>
                                            </div>
                                        </div>
                                    </c:forEach>

                                    <!-- 페이징 부분 -->
                                    <div class="div_page">
                                        <ul>
                                            <c:if test="${pageMaker.prev}">
                                                <li class="paginate_button">
                                                    <a href="${pageMaker.startPage - 1}">
                                                        <i class="fas fa-caret-left"></i>
                                                    </a>
                                                </li>
                                            </c:if>

                                            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                                                <li class="paginate_button ${pageMaker.reviewCriteriaDTO.pageNum==num ? 'active' : ''}">
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

                                    <!-- 폼 부분 -->
                                    <form id="actionForm" action="apartment_detail" method="get">
                                        <input type="hidden" name="apartmentId" value="${apartment.apartmentId}">
                                        <input type="hidden" name="pageNum" value="${pageMaker.reviewCriteriaDTO.pageNum}">
                                        <input type="hidden" name="amount" value="${pageMaker.reviewCriteriaDTO.amount}">
                                    </form>
                                    
                                    <!-- 리뷰가 없는 경우 메시지 표시 -->
                                    <c:if test="${empty reviewList}">
                                        <div class="no-reviews">
                                            <div class="no-reviews-content">
                                                <div class="no-reviews-icon">
                                                    <i class="fas fa-comment-slash"></i>
                                                </div>
                                                <h3 class="no-reviews-title">아직 등록된 리뷰가 없습니다</h3>
                                                <p class="no-reviews-message">이 아파트에 대한 첫 번째 리뷰를 작성해보세요!</p>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
	<script>
	    // 페이징처리
	    var actionForm = $("#actionForm");

	    // 페이지번호 처리
	    $(".paginate_button a").on("click", function (e) {
	        e.preventDefault();
	        console.log("click했음");
	        console.log("@# href => " + $(this).attr("href"));

	        // 현재 활성화된 탭 확인 및 저장
	        const activeTab = document.querySelector('.tab-item.active');
	        if (activeTab && activeTab.dataset.tab === 'reviews') {
	            sessionStorage.setItem("activeTab", "reviews");
	        }

	        // 페이지 번호 설정
	        actionForm.find("input[name='pageNum']").val($(this).attr("href"));

	        // 폼 제출
	        actionForm.submit();
	    });

	    // JWT 토큰 관리 함수들
	    function getJwtToken() {
	        return localStorage.getItem('jwtToken');
	    }

	    function setJwtToken(token) {
	        localStorage.setItem('jwtToken', token);
	    }

	    function removeJwtToken() {
	        localStorage.removeItem('jwtToken');
	    }

	    function getCurrentUser() {
	        // 테스트를 위해 임시로 사용자 정보 하드코딩
	        return {
	            userNumber: 1,
	            userName: "테스트사용자",
	            userAdmin: 0
	        };
	    }

	    // AJAX 요청에 JWT 토큰 헤더 추가
	    function setupAjaxWithJWT() {
	        $.ajaxSetup({
	            beforeSend: function(xhr) {
	                const token = getJwtToken();
	                if (token) {
	                    xhr.setRequestHeader('Authorization', 'Bearer ' + token);
	                }
	            }
	        });
	    }

	    function checkUserPermissions() {
	        const user = getCurrentUser();
	        if (user && user.userAdmin === 1) {
	            $('#adminMenuContainer').show();
	        }
	    }

	    function updateReviewActionButtons() {
	        const currentUser = getCurrentUser();
	        if (!currentUser) return;

	        $('.review-edit-delete').each(function() {
	            const reviewUserNumber = parseInt($(this).data('user-number'));
	            if (currentUser.userNumber === reviewUserNumber || currentUser.userAdmin === 1) {
	                $(this).show();
	            }
	        });
	    }

	    function updateHelpfulButtonsUI() {
	        $('.review-card').each(function() {
	            const likeButton = $(this).find('.review-action-icon.like');
	            
	            if (likeButton.hasClass('active')) {
	                likeButton.removeClass('far').addClass('fas');
	            } else {
	                likeButton.removeClass('fas').addClass('far');
	            }
	        });
	    }

	    function markHelpful(reviewId, element) {
	        const isActive = $(element).hasClass('active');
	        
	        $.ajax({
	            type: "post",
	            url: isActive ? "review_unhelpful" : "review_helpful",
	            data: { reviewId: reviewId },
	            success: function(response) {
	                if (response.success) {
	                    if (isActive) {
	                        $(element).removeClass('active fas').addClass('far');
	                    } else {
	                        $(element).removeClass('far').addClass('fas active');
	                    }
	                    
	                    const helpfulCountElement = $(element).closest('.helpful-container').find('.helpful-count');
	                    if (helpfulCountElement.length > 0) {
	                        helpfulCountElement.text(response.helpfulCount);
	                    }
	                    
	                    saveHelpfulState(reviewId, !isActive);
	                } else {
	                    alert(response.message || '도움됨 처리 중 오류가 발생했습니다.');
	                }
	            },
	            error: function(xhr) {
	                let errorMessage = '서버 통신 중 오류가 발생했습니다.';
	                try {
	                    const response = JSON.parse(xhr.responseText);
	                    if (response.message) {
	                        errorMessage = response.message;
	                    }
	                } catch (e) {
	                    console.error('JSON 파싱 오류:', e);
	                }
	                alert(errorMessage);
	            }
	        });
	    }

	    function saveHelpfulState(reviewId, isHelpful) {
	        const currentUser = getCurrentUser();
	        if (!currentUser) return;
	        
	        const userNumber = currentUser.userNumber;
	        const storageKey = `helpful_${userNumber}`;
	        
	        let helpfulData = JSON.parse(localStorage.getItem(storageKey) || '{}');
	        helpfulData[reviewId] = isHelpful;
	        
	        localStorage.setItem(storageKey, JSON.stringify(helpfulData));
	    }

	    function restoreHelpfulState() {
	        const currentUser = getCurrentUser();
	        if (!currentUser) return;
	        
	        const userNumber = currentUser.userNumber;
	        const storageKey = `helpful_${userNumber}`;
	        
	        const helpfulData = JSON.parse(localStorage.getItem(storageKey) || '{}');
	        
	        $('.review-card').each(function() {
	            const reviewId = $(this).find('.review-id-hidden').val();
	            const likeButton = $(this).find('.review-action-icon.like');
	            
	            if (likeButton.hasClass('active')) {
	                likeButton.removeClass('far').addClass('fas');
	            } else if (helpfulData[reviewId]) {
	                likeButton.addClass('active');
	                likeButton.removeClass('far').addClass('fas');
	            }
	        });
	    }

	    // 리뷰 폼 초기화
	    function resetReviewForm() {
	        document.getElementById('reviewForm').reset();
	        document.getElementById('ratingInput').value = 0;
	        document.getElementById('reviewId').value = '';
	        document.querySelectorAll('.rating-input i').forEach(star => {
	            star.className = 'far fa-star';
	        });
	        document.querySelector('.form-title').textContent = '리뷰 작성하기';
	        document.querySelector('.form-actions button.primary-button').textContent = '리뷰 등록';
	    }

	    // 리뷰 제출
	    function submitReview() {
	        const reviewId = document.getElementById('reviewId').value;
	        const apartmentId = document.getElementById('apartmentIdInput').value;
	        const rating = document.getElementById('ratingInput').value;
	        const title = document.getElementById('reviewTitle').value;
	        const content = document.getElementById('reviewContent').value;
	        
	        if (rating === '0') {
	            alert('리뷰를 등록하려면 평점을 선택해주세요.');
	            return;
	        }
	        
	        if (!title || !title.trim()) {
	            alert('리뷰 제목을 입력해주세요.');
	            return;
	        }
	        
	        if (!content || !content.trim()) {
	            alert('리뷰 내용을 입력해주세요.');
	            return;
	        }
	        
	        const url = reviewId ? "updateReview" : "insertReview";
	        
	        const requestData = {
	            apartmentId: apartmentId,
	            reviewRating: rating,
	            reviewTitle: title,
	            reviewContent: content
	        };
	        
	        if (reviewId) {
	            requestData.reviewId = reviewId;
	        }
	        
	        $.ajax({
	            type: "post",
	            url: url,
	            data: requestData,
	            success: function(response) {
	                if (response.success) {
	                    alert(response.message);
	                    resetReviewForm();
	                    
	                    setTimeout(function() {
	                        sessionStorage.setItem("activeTab", "reviews");
	                        location.reload();
	                    }, 1000);
	                } else {
	                    alert(response.message || '처리 중 오류가 발생했습니다.');
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error("AJAX 오류:", status, error);
	                console.error("응답 텍스트:", xhr.responseText);
	                
	                let errorMessage = '서버 통신 중 오류가 발생했습니다.';
	                
	                try {
	                    if (xhr.responseJSON && xhr.responseJSON.message) {
	                        errorMessage = xhr.responseJSON.message;
	                    } else if (xhr.responseText) {
	                        try {
	                            const response = JSON.parse(xhr.responseText);
	                            if (response.message) {
	                                errorMessage = response.message;
	                            }
	                        } catch (e) {
	                            console.error("JSON 파싱 오류:", e);
	                            errorMessage = xhr.responseText;
	                        }
	                    }
	                } catch (e) {
	                    console.error("응답 처리 오류:", e);
	                }
	                
	                alert(errorMessage);
	            }
	        });
	    }

	    // 리뷰 삭제 확인
	    function confirmDeleteReview(reviewId) {
	        if (confirm('정말로 이 리뷰를 삭제하시겠습니까?')) {
	            deleteReview(reviewId);
	        }
	    }

	    // 리뷰 삭제 실행
	    function deleteReview(reviewId) {
	        $.ajax({
	            type: "post",
	            url: "deleteReview",
	            data: { reviewId: reviewId },
	            success: function(response) {
	                if (response.success) {
	                    alert('리뷰가 성공적으로 삭제되었습니다.');
	                    setTimeout(() => {
	                        sessionStorage.setItem("activeTab", "reviews");
	                        location.reload();
	                    }, 1000);
	                } else {
	                    alert(response.message || '리뷰 삭제에 실패했습니다.');
	                }
	            },
	            error: function() {
	                alert('서버 통신 중 오류가 발생했습니다.');
	            }
	        });
	    }

	    // 관심목록에 추가
	    function addToFavorites(apartmentId) {
			const apartmentIdInt = parseInt(apartmentId);
	        $.ajax({
	            url: '/favorite/insert',
	            type: 'POST',
	            contentType: 'application/json',
	            data: JSON.stringify({
	                apartmentId: apartmentIdInt
	            }),
	            xhrFields: {
	                withCredentials: true
	            },
	            success: function () {
	                alert('관심목록에 등록되었습니다.');
	                location.reload();
	            },
	            error: function () {
	                alert('관심등록 실패!');
	            }
	        });
	    }

		// 가격 데이터 그래프 생성 함수
		function createPriceChart() {
		    // 서버에서 전달받은 가격 데이터
		    const priceData = ${priceDataJson};
		    
		    // 디버깅: 실제 데이터 구조 확인
		    console.log('Price Data:', priceData);
		    
		    if (priceData && priceData.length > 0) {
		        // 첫 번째 항목의 키 확인
		        const firstItem = priceData[0];
		        console.log('First item keys:', Object.keys(firstItem));
		        
		        // 연도별로 그룹화하고 평균 계산 (JavaScript에서 처리)
		        const yearlyData = {};
		        
		        priceData.forEach(item => {
		            // 대문자 키로 접근 (YEAR, PRICE)
		            const year = item.YEAR || item.year;
		            const priceStr = String(item.PRICE || item.price || '0');
		            
		            // 데이터 유효성 검사 추가
		            if (!year || !priceStr) {
		                console.warn('Invalid data item:', item);
		                return; // 이 항목은 건너뜀
		            }
		            
		            // 안전하게 숫자로 변환 (쉼표 제거 후)
		            const price = parseFloat(priceStr.replace(/,/g, ''));
		            
		            if (isNaN(price)) {
		                console.warn('Invalid price value:', priceStr);
		                return; // 유효하지 않은 가격은 건너뜀
		            }
		            
		            if (!yearlyData[year]) {
		                yearlyData[year] = {
		                    total: 0,
		                    count: 0
		                };
		            }
		            
		            yearlyData[year].total += price;
		            yearlyData[year].count += 1;
		        });
		        
		        // 연도별 평균 계산
		        const years = Object.keys(yearlyData).sort();
		        const avgPrices = years.map(year => {
		            return Math.round(yearlyData[year].total / yearlyData[year].count);
		        });
		        
		        // 데이터가 있는지 확인
		        if (years.length === 0) {
		            $('#priceChart').parent().html('<div class="no-data-message">거래 데이터가 없습니다.</div>');
		            return;
		        }
		        
		        console.log('Processed years:', years);
		        console.log('Processed prices:', avgPrices);
		        
		        const ctx = document.getElementById('priceChart').getContext('2d');
		        new Chart(ctx, {
		            type: 'line',
		            data: {
		                labels: years,
		                datasets: [{
		                    label: '평균 거래가격 (만원)',
		                    data: avgPrices,
		                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
		                    borderColor: 'rgba(75, 192, 192, 1)',
		                    borderWidth: 2,
		                    tension: 0.1,
		                    pointBackgroundColor: 'rgba(75, 192, 192, 1)',
		                    pointRadius: 5,
		                    pointHoverRadius: 7
		                }]
		            },
		            options: {
		                responsive: true,
		                maintainAspectRatio: false,
		                scales: {
		                    y: {
		                        beginAtZero: false,
		                        title: {
		                            display: true,
		                            text: '가격 (만원)'
		                        },
		                        ticks: {
		                            callback: function(value) {
		                                return value.toLocaleString() + '만원';
		                            }
		                        }
		                    },
		                    x: {
		                        title: {
		                            display: true,
		                            text: '연도'
		                        }
		                    }
		                },
		                plugins: {
		                    title: {
		                        display: true,
		                        text: '${apartment.aptNm} 연도별 평균 거래가격',
		                        font: {
		                            size: 16
		                        }
		                    },
		                    tooltip: {
		                        callbacks: {
		                            label: function(context) {
		                                return context.dataset.label + ': ' + context.parsed.y.toLocaleString() + '만원';
		                            }
		                        }
		                    }
		                }
		            }
		        });
		    } else {
		        $('#priceChart').parent().html('<div class="no-data-message">거래 데이터가 없습니다.</div>');
		    }
		}

	    // 페이지 로드 시 초기화
	    $(document).ready(function() {
	        setupAjaxWithJWT();
	        checkUserPermissions();
	        updateReviewActionButtons();
	        restoreHelpfulState();
	        
	        // 가격 그래프 생성
	        createPriceChart();
	        
	        // 페이지 로드 시 탭 상태 복원
	        const activeTab = sessionStorage.getItem("activeTab");
	        if (activeTab === "reviews") {
	            document.querySelectorAll('.tab-item').forEach(tab => {
	                tab.classList.remove('active');
	                if (tab.dataset.tab === 'reviews') {
	                    tab.classList.add('active');
	                }
	            });
	            
	            document.querySelectorAll('.tab-panel').forEach(panel => {
	                panel.classList.remove('active');
	                if (panel.id === 'reviews') {
	                    panel.classList.add('active');
	                }
	            });
	            
	            sessionStorage.removeItem("activeTab");
	        }
	        
	        // 탭 기능
	        document.querySelectorAll('.tab-item').forEach(tab => {
	            tab.addEventListener('click', () => {
	                document.querySelectorAll('.tab-item').forEach(t => t.classList.remove('active'));
	                tab.classList.add('active');
	                
	                document.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));
	                document.getElementById(tab.dataset.tab).classList.add('active');
	                
	                sessionStorage.removeItem("activeTab");
	            });
	        });

	        // 별점 선택 기능
	        document.querySelectorAll('.rating-input i').forEach(star => {
	            star.addEventListener('click', () => {
	                const rating = parseInt(star.dataset.rating);
	                document.getElementById('ratingInput').value = rating;
	                
	                document.querySelectorAll('.rating-input i').forEach((s, index) => {
	                    if (index < rating) {
	                        s.className = 'fas fa-star';
	                    } else {
	                        s.className = 'far fa-star';
	                    }
	                });
	            });
	            
	            star.addEventListener('mouseenter', () => {
	                const rating = parseInt(star.dataset.rating);
	                
	                document.querySelectorAll('.rating-input i').forEach((s, index) => {
	                    if (index < rating) {
	                        s.className = 'fas fa-star';
	                    } else {
	                        s.className = 'far fa-star';
	                    }
	                });
	            });
	            
	            star.addEventListener('mouseleave', () => {
	                const currentRating = parseInt(document.getElementById('ratingInput').value);
	                
	                document.querySelectorAll('.rating-input i').forEach((s, index) => {
	                    if (index < currentRating) {
	                        s.className = 'fas fa-star';
	                    } else {
	                        s.className = 'far fa-star';
	                    }
	                });
	            });
	        });

	        // 리뷰 수정 버튼 클릭 이벤트
	        $(document).on('click', '.review-action-icon.edit', function(e) {
	            e.preventDefault();
	            
	            var reviewCard = $(this).closest('.review-card');
	            var reviewId = reviewCard.find('.review-id-hidden').val();
	            
	            var reviewTitle = reviewCard.find('.review-title').text().trim();
	            var reviewContent = reviewCard.find('.review-content p').text().trim();
	            var reviewRating = reviewCard.find('.review-rating .fas.fa-star').length;
	            
	            reviewCard.data('originalTitle', reviewTitle);
	            reviewCard.data('originalContent', reviewContent);
	            reviewCard.data('originalRating', reviewRating);
	            
	            var titleInput = $('<input>').attr({
	                'type': 'text',
	                'class': 'edit-review-title',
	                'value': reviewTitle,
	                'placeholder': '리뷰 제목'
	            });
	            reviewCard.find('.review-title').empty().append(titleInput);
	            
	            var contentTextarea = $('<textarea>').attr({
	                'class': 'edit-review-content',
	                'placeholder': '리뷰 내용'
	            }).text(reviewContent);
	            reviewCard.find('.review-content').empty().append(contentTextarea);
	            
	            var ratingDiv = $('<div>').attr('class', 'edit-rating');
	            var ratingInput = $('<input>').attr({
	                'type': 'hidden',
	                'id': 'edit-rating-value',
	                'value': reviewRating
	            });
	            
	            for (var i = 1; i <= 5; i++) {
	                var starClass = (i <= reviewRating) ? 'fas fa-star' : 'far fa-star';
	                var star = $('<i>').attr({
	                    'class': starClass + ' edit-star',
	                    'data-value': i
	                });
	                ratingDiv.append(star);
	            }
	            
	            reviewCard.find('.review-rating').empty().append(ratingDiv).append(ratingInput);
	            
	            reviewCard.find('.edit-star').on('click', function() {
	                var value = $(this).data('value');
	                
	                reviewCard.find('.edit-star').each(function(index) {
	                    if (index < value) {
	                        $(this).removeClass('far').addClass('fas');
	                    } else {
	                        $(this).removeClass('fas').addClass('far');
	                    }
	                });
	                
	                reviewCard.find('#edit-rating-value').val(value);
	            });
	            
	            var cancelButton = $('<button>').attr({
	                'type': 'button',
	                'class': 'action-button secondary-button cancel-edit'
	            }).text('취소');
	            
	            var saveButton = $('<button>').attr({
	                'type': 'button',
	                'class': 'action-button primary-button save-edit',
	                'data-review-id': reviewId
	            }).text('저장');
	            
	            var actionsDiv = $('<div>').attr('class', 'edit-actions')
	                .append(cancelButton)
	                .append(saveButton);
	            
	            reviewCard.find('.review-content').append(actionsDiv);
	            reviewCard.addClass('editing');
	        });
	        
	        // 취소 버튼 클릭 이벤트
	        $(document).on('click', '.cancel-edit', function() {
	            var reviewCard = $(this).closest('.review-card');
	            
	            var originalTitle = reviewCard.data('originalTitle');
	            var originalContent = reviewCard.data('originalContent');
	            var originalRating = reviewCard.data('originalRating');
	            
	            reviewCard.find('.review-title').html(originalTitle);
	            reviewCard.find('.review-content').html('<p>' + originalContent + '</p>');
	            
	            var ratingHtml = '';
	            for (var i = 1; i <= 5; i++) {
	                if (i <= originalRating) {
	                    ratingHtml += '<i class="fas fa-star"></i>';
	                } else {
	                    ratingHtml += '<i class="far fa-star"></i>';
	                }
	            }
	            reviewCard.find('.review-rating').html(ratingHtml);
	            reviewCard.removeClass('editing');
	        });
	        
	        // 저장 버튼 클릭 이벤트
	        $(document).on('click', '.save-edit', function() {
	            var reviewCard = $(this).closest('.review-card');
	            var reviewId = $(this).data('review-id');
	            
	            var editedTitle = reviewCard.find('.edit-review-title').val();
	            var editedContent = reviewCard.find('.edit-review-content').val();
	            var editedRating = parseInt(reviewCard.find('#edit-rating-value').val());
	            
	            if (!editedTitle || !editedTitle.trim()) {
	                alert('리뷰 제목을 입력해주세요.');
	                return;
	            }
	            
	            if (!editedContent || !editedContent.trim()) {
	                alert('리뷰 내용을 입력해주세요.');
	                return;
	            }
	            
	            if (isNaN(editedRating) || editedRating < 1 || editedRating > 5) {
	                alert('유효한 별점을 선택해주세요.');
	                return;
	            }
	            
	            $.ajax({
	                type: "post",
	                url: "updateReview",
	                data: {
	                    reviewId: reviewId,
	                    reviewTitle: editedTitle,
	                    reviewContent: editedContent,
	                    reviewRating: editedRating
	                },
	                success: function(response) {
	                    if (response.success) {
	                        reviewCard.find('.review-title').html(editedTitle);
	                        reviewCard.find('.review-content').html('<p>' + editedContent + '</p>');
	                        
	                        var ratingHtml = '';
	                        for (var i = 1; i <= 5; i++) {
	                            if (i <= editedRating) {
	                                ratingHtml += '<i class="fas fa-star"></i>';
	                            } else {
	                                ratingHtml += '<i class="far fa-star"></i>';
	                            }
	                        }
	                        reviewCard.find('.review-rating').html(ratingHtml);
	                        reviewCard.removeClass('editing');
	                        
	                        alert('리뷰가 성공적으로 수정되었습니다.');
	                    } else {
	                        alert(response.message || '리뷰 수정에 실패했습니다.');
	                    }
	                },
	                error: function(xhr, status, error) {
	                    console.error("AJAX 오류:", status, error);
	                    console.error("응답 텍스트:", xhr.responseText);
	                    
	                    var errorMessage = '리뷰 수정 중 오류가 발생했습니다.';
	                    try {
	                        var response = JSON.parse(xhr.responseText);
	                        if (response.message) {
	                            errorMessage = response.message;
	                        }
	                    } catch (e) {
	                        console.error('JSON 파싱 오류:', e);
	                        errorMessage = xhr.responseText;
	                    }
	                    
	                    alert(errorMessage);
	                }
	            });
	        });

	        // 페이지 로드 시 알림 처리
	        const urlParams = new URLSearchParams(window.location.search);
	        const errorMsg = urlParams.get('errorMsg');
	        const successMsg = urlParams.get('successMsg');
	        
	        if (errorMsg) {
	            alert(errorMsg);
	        }
	        
	        if (successMsg) {
	            alert(successMsg);
	        }
	    });
	</script>
</body>
</html>