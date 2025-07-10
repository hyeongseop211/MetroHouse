<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 - 메트로하우스</title>
<link rel="stylesheet" type="text/css" href="/resources/css/mypage.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="/resources/js/mypage.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 페이지 로드 시 성공 메시지 표시
    window.onload = function() {
        <c:if test="${not empty successMsg}">
            alert("${successMsg}");
        </c:if>
    };
</script>
</head>
<body>
    <jsp:include page="../header.jsp" />

    <!-- JWT 인증 방식으로 변경: 세션 체크 대신 모델에서 user 객체 확인 -->
    <c:if test="${empty user}">
        <c:redirect url="/loginForm" />
    </c:if>

    <div class="mypage-container">
        <div class="mypage-header">
            <h1 class="mypage-title">마이페이지</h1>
            <p class="mypage-subtitle">회원 정보 및 아파트 관심 목록을 확인하실 수 있습니다.</p>
        </div>

        <div class="mypage-content">
            <div class="profile-sidebar">
                <div class="profile-header">
                    <div class="profile-avatar">${fn:substring(user.userName, 0, 1)}</div>
                    <div class="profile-name">${user.userName} 님</div>
                    <div class="profile-id">${user.userId}</div>
                </div>

                <div class="profile-menu">
                    <div class="menu-item" onclick="showTab('profile', event)">
                        <i class="fas fa-user"></i> <span>내 정보</span>
                    </div>
                    <div class="menu-item" onclick="showTab('update', event)">
                        <i class="fas fa-pen-to-square"></i> <span>정보 수정</span>
                    </div>
                    <div class="menu-item" onclick="showTab('password', event)">
                        <i class="fas fa-lock"></i> <span>비밀번호 변경</span>
                    </div>
                </div>
            </div>

            <div class="content-section">
                <div id="profile-tab" class="tab-content">
                    <div class="section-header">
                        <h2 class="section-title">내 정보</h2>
                    </div>

                    <div class="stats-container">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-heart"></i>
                            </div>
                            <div class="stat-value">${userFavoriteCount}</div>
                            <div class="stat-label">관심 아파트</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-eye"></i>
                            </div>
                            <div class="stat-value">${userViewCount}</div>
                            <div class="stat-label">조회한 아파트</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-search"></i>
                            </div>
                            <div class="stat-value">${userSearchCount}</div>
                            <div class="stat-label">검색 횟수</div>
                        </div>
                    </div>

                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">이름</div>
                            <div class="info-value">${user.userName}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">아이디</div>
                            <div class="info-value">${user.userId}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">이메일</div>
                            <div class="info-value">${user.userEmail}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">전화번호</div>
                            <div class="info-value">${user.userTel}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">생년월일</div>
                            <div class="info-value">${user.userBirth}</div>
                        </div>

                        <div class="info-item">
                            <div class="info-label">가입일</div>
                            <div class="info-value">${user.userRegdate}</div>
                        </div>
                    </div>

					<div class="info-item">
					    <div class="info-label">주소</div>
					    <div class="info-value">
					        ${user.userZipCode} ${user.userAddress}
					        <c:if test="${not empty userDetailAddress}">
					            ${userDetailAddress}
					        </c:if>
					    </div>
					</div>
                </div>

                <div id="favorites-tab" class="tab-content">
                    <div class="section-header">
                        <h2 class="section-title">관심 아파트</h2>
                    </div>

                    <div class="tab-container">
                        <div class="tab-buttons">
                            <button class="tab-button" onclick="showHistoryTab('current', event)">관심 목록</button>
                            <button class="tab-button" onclick="showHistoryTab('history', event)">조회 기록</button>
                        </div>

                        <div id="current" class="tab-content">
                            <c:choose>
                                <c:when test="${userFavoriteCount > 0}">
                                    <div class="apartment-list">
                                        <c:forEach var="apartment" items="${favoriteApartments}">
                                            <div class="apartment-item">
                                                <div class="apartment-info">
                                                    <div class="apartment-title">${apartment.apartmentName}</div>
                                                    <div class="apartment-location">${apartment.district} ${apartment.dong}</div>
                                                    <div class="apartment-details">
                                                        <span>면적: ${apartment.size}㎡</span>
                                                        <span>가격: <fmt:formatNumber value="${apartment.price}" type="number"/>만원</span>
                                                    </div>
                                                </div>
                                                <div class="apartment-actions">
                                                    <form class="favoriteForm" style="display: inline-block;">
                                                        <input type="hidden" name="apartmentId" value="${apartment.apartmentId}">
                                                        <button type="button" class="return-button" onclick="return_submit(this)">
                                                            <i class="fas fa-heart-broken"></i> 관심 해제
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-icon">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                        <div class="empty-message">관심 등록된 아파트가 없습니다.</div>
                                        <a href="search_map?majorRegion=서울&district=강남구&station=강남역" class="btn btn-outline">
                                            <i class="fas fa-search"></i> 아파트 검색하기
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div id="history" class="tab-content">
                            <c:choose>
                                <c:when test="${userViewCount > 0}">
                                    <div class="apartment-list">
                                        <c:forEach var="apartment" items="${viewedApartments}">
                                            <div class="apartment-item">
                                                <div class="apartment-info">
                                                    <div class="apartment-title">${apartment.apartmentName}</div>
                                                    <div class="apartment-location">${apartment.district} ${apartment.dong}</div>
                                                    <div class="apartment-details">
                                                        <span>조회일: <fmt:formatDate value="${apartment.viewDate}" pattern="yyyy-MM-dd HH:mm"/></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-icon">
                                            <i class="fas fa-eye"></i>
                                        </div>
                                        <div class="empty-message">최근 조회한 아파트가 없습니다.</div>
                                        <a href="search_map?majorRegion=서울&district=강남구&station=강남역" class="btn btn-outline">
                                            <i class="fas fa-search"></i> 아파트 검색하기
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <!-- 정보 수정 탭 추가 -->
                <div id="update-tab" class="tab-content">
                    <div class="section-header">
                        <h2 class="section-title">정보 수정</h2>
                        <div class="section-subtitle">회원 정보를 수정하려면 현재 비밀번호를 입력해주세요.</div>
                    </div>
                    
                    <form id="updateUserForm" method="post" action="userUpdate">
                        <input type="hidden" name="userNumber" value="${user.userNumber}">
                        <input type="hidden" name="userId" value="${user.userId}">
                        
                        <!-- 비밀번호 확인 섹션 추가 -->
                        <div class="password-verification" style="margin-bottom: 30px; padding: 20px; background-color: var(--primary-lighter); border-radius: var(--border-radius); border: 1px solid var(--primary-light);">
                            <div class="info-label" style="margin-bottom: 15px; color: var(--primary-dark); font-weight: 600;">
                                <i class="fas fa-shield-alt" style="margin-right: 8px;"></i> 보안 확인
                            </div>
                            <div style="background-color: white; padding: 15px; border-radius: var(--border-radius-sm);">
                                <div class="info-label">현재 비밀번호</div>
                                <input type="password" id="updateCurrentPassword" name="userPw" class="form-input" placeholder="현재 비밀번호를 입력해주세요" required>
                                <div class="info-description" style="font-size: 13px; color: var(--gray-500); margin-top: 8px;">
                                    * 회원 정보 보호를 위해 현재 비밀번호를 확인합니다.
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">이름</div>
                                <input type="text" name="userName" class="form-input" value="${user.userName}" required>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">아이디</div>
                                <div class="info-value">${user.userId}</div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">이메일</div>
                                <input type="email" name="userEmail" class="form-input" value="${user.userEmail}" required>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">전화번호</div>
                                <input type="tel" name="userTel" class="form-input" value="${user.userTel}" 
                                    pattern="[0-9]{3}-[0-9]{4}-[0-9]{4}" placeholder="010-0000-0000" required>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">생년월일</div>
                                <input type="date" name="userBirth" class="form-input" value="${user.userBirth}" required>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">가입일</div>
                                <div class="info-value">${user.userRegdate}</div>
                            </div>
                        </div>
                        
                        <div class="address-section" style="margin-top: 20px;">
                            <div class="info-item" style="grid-column: span 2;">
                                <div class="info-label">우편번호</div>
                                <div style="display: flex; gap: 10px;">
                                    <input type="text" name="userZipCode" id="userZipCode" class="form-input" 
                                        value="${user.userZipCode}" style="flex: 1;" readonly>
                                    <button type="button" onclick="execDaumPostcode()" class="btn btn-outline" style="white-space: nowrap;">
                                        <i class="fas fa-search"></i> 주소 찾기
                                    </button>
                                </div>
                            </div>
                            
                            <div class="info-item" style="grid-column: span 2;">
                                <div class="info-label">주소</div>
                                <input type="text" name="userAddress" id="userAddress" class="form-input" 
                                    value="${user.userAddress}" readonly>
                            </div>
                            
                            <div class="info-item" style="grid-column: span 2;">
                                <div class="info-label">상세주소</div>
                                <input type="text" name="userDetailAddress" id="userDetailAddress" class="form-input" 
                                    value="${user.userDetailAddress}">
                            </div>
                        </div>
                        
                        <div class="action-buttons">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-check"></i> 정보 수정 완료
                            </button>
                        </div>
                    </form>
                </div>

                <div id="password-tab" class="tab-content">
                    <div class="section-header">
                        <h2 class="section-title">비밀번호 변경</h2>
                    </div>
                    <form id="passwordChangeForm" onsubmit="return false;">
                        <input type="hidden" name="userNumber" value="${user.userNumber}">
                        <div class="info-grid" style="grid-template-columns: 1fr;">
                            <div class="info-item">
                                <div class="info-label">현재 비밀번호</div>
                                <input type="password" id="currentPassword" name="userPw" class="form-input" required>
                                <div id="passwordError" style="color: var(--danger); font-size: 13px; margin-top: 5px;"></div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">새 비밀번호</div>
                                <input type="password" id="newPassword" name="userNewPw" class="form-input" required>
                                <div class="info-label" style="margin-top: 5px; font-size: 12px; color: var(--gray-500);">*
                                    8자 이상, 영문, 숫자, 특수문자 조합</div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">새 비밀번호 확인</div>
                                <input type="password" id="confirmPassword" name="userNewPwCheck" class="form-input" required>
                                <div id="passwordError" style="color: var(--danger); font-size: 13px; margin-top: 5px;"></div>
                            </div>
                        </div>

                        <div class="action-buttons">
                            <button type="button" onclick="changePassword()" class="btn btn-primary">
                                <i class="fas fa-check"></i> 비밀번호 변경
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <c:if test="${not empty errorMsg}">
        <script>
            alert("${errorMsg}");
        </script>
    </c:if>
    <c:if test="${not empty successMsg}">
        <script>
            alert("${successMsg}");
        </script>
    </c:if>
    
    <script>
        function changePassword() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // 비밀번호 유효성 검사
            if (newPassword !== confirmPassword) {
                alert("새 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
                return;
            }
            
            // 비밀번호 복잡성 검사
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
            if (!passwordRegex.test(newPassword)) {
                alert("비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.");
                return;
            }
            
            // AJAX 요청으로 비밀번호 변경
            $.ajax({
                type: "POST",
                url: "userPwUpdate",
                data: $("#passwordChangeForm").serialize(),
                success: function(response) {
                    alert("비밀번호가 성공적으로 변경되었습니다.");
                    // 폼 초기화
                    document.getElementById('currentPassword').value = '';
                    document.getElementById('newPassword').value = '';
                    document.getElementById('confirmPassword').value = '';
                    // 프로필 탭으로 이동
                    showTab('profile', event);
                },
                error: function(xhr, status, error) {
                    if (xhr.status === 401) {
                        alert("현재 비밀번호가 일치하지 않습니다.");
                    } else if (xhr.status === 403) {
                        alert("로그인이 필요합니다.");
                        location.href = "loginForm";
                    } else {
                        alert("비밀번호 변경 중 오류가 발생했습니다.");
                        console.error("Error details:", error);
                    }
                }
            });
        }
    </script>
</body>
</html>
