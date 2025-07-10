<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메트로하우스 - 지하철역 주변 아파트 시세</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/resources/css/header.css">
    <script>
        window.addEventListener("unload", function() {
            navigator.sendBeacon("/disconnect");
        });
    </script>
</head>
<body>
    <c:set var="currentPage" value="${requestScope['javax.servlet.forward.request_uri']}" />

    <header class="top-header">
        <div class="header-container">
            <!-- 로고 섹션 -->
            <div class="logo-section">
                <a href="/" class="logo-link">
                    <div class="logo-icon">
                        <i class="fa-solid fa-train-subway"></i>
                    </div>
                    <span class="logo-text">메트로하우스</span>
                </a>
            </div>

            <!-- 네비게이션 링크 -->
            <nav class="nav-links" id="navLinks">
                <a href="/" class="nav-link ${currentPage == '/' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-house"></i>
                    <span>메인</span>
                </a>
                <a href="/board_view" class="nav-link ${currentPage == '/board_view' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-clipboard-list"></i>
                    <span>게시판</span>
                </a>
                <a href="/search_map?majorRegion=서울&district=강남구&station=강남역" class="nav-link ${currentPage == '/search_map' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-map-location-dot"></i>
                    <span>지도</span>
                </a>
                <c:if test="${user != null}">
                <a href="/favorite_apartment" class="nav-link ${currentPage == '/favorite_apartment' ? 'active' : ''}">
                    <i class="nav-icon fa-solid fa-heart"></i>
                    <span>관심아파트</span>
                </a>
                </c:if>
            </nav>

            <!-- 사용자 메뉴 -->
            <div class="user-menu">
                <c:choose>
                    <c:when test="${user != null}">
                    <div class="user-dropdown" id="userDropdown">
                        <button class="dropdown-toggle" id="dropdownToggle">
                            <div class="user-avatar">
                                ${fn:substring(user.userName, 0, 1)}
                            </div>
                            <span class="user-name">${user.userName} 님</span>
                            <span class="toggle-icon"><i class="fa-solid fa-chevron-down"></i></span>
                        </button>
                        
                        <!-- 드롭다운 메뉴 -->
                        <div class="dropdown-menu">
                            <!-- 드롭다운 헤더 -->
                            <div class="dropdown-header">
                                <div class="dropdown-header-bg"></div>
                                <div class="dropdown-header-content">
                                    <div class="user-avatar large">
                                        ${fn:substring(user.userName, 0, 1)}
                                    </div>
                                    <div class="header-info">
                                        <div class="header-name">${user.userName} 님</div>
                                        <div class="header-email">${user.userEmail}</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 드롭다운 메뉴 컨테이너 -->
                            <div class="dropdown-menu-container">
                                <!-- 내 계정 섹션 -->
                                <div class="dropdown-section">
                                    <div class="dropdown-section-title">내 계정</div>
                                    <a href="mypage" class="dropdown-item">
                                        <div class="dropdown-icon-wrapper">
                                            <i class="dropdown-icon fa-solid fa-user"></i>
                                        </div>
                                        <div class="dropdown-item-content">
                                            <div class="dropdown-item-title">마이페이지</div>
                                            <div class="dropdown-item-description">계정 정보 및 활동 내역 확인</div>
                                        </div>
                                    </a>
                                </div>

                                <!-- 서비스 섹션 -->
<!--                                <div class="dropdown-section">-->
<!--                                    <div class="dropdown-section-title">서비스</div>-->
<!--                                    <a href="/search_history" class="dropdown-item">-->
<!--                                        <div class="dropdown-icon-wrapper">-->
<!--                                            <i class="dropdown-icon fa-solid fa-clock-rotate-left"></i>-->
<!--                                        </div>-->
<!--                                        <div class="dropdown-item-content">-->
<!--                                            <div class="dropdown-item-title">서비스 뭐 넣지</div>-->
<!--                                            <div class="dropdown-item-description">아이디어구상중</div>-->
<!--                                        </div>-->
<!--                                    </a>-->
<!--                                </div>-->

                                <!-- 관리자 섹션 -->
                                <c:if test="${user.userAdmin == 1}">
                                <div class="dropdown-section">
                                    <div class="dropdown-section-title">관리자</div>
<!--                                    <a href="admin_view" class="dropdown-item admin-item">-->
<!--                                        <div class="dropdown-icon-wrapper">-->
<!--                                            <i class="dropdown-icon fa-solid fa-gear"></i>-->
<!--                                        </div>-->
<!--                                        <div class="dropdown-item-content">-->
<!--                                            <div class="dropdown-item-title">관리자모드 <span class="admin-badge">Admin</span></div>-->
<!--                                            <div class="dropdown-item-description">사이트 관리 및 설정</div>-->
<!--                                        </div>-->
<!--                                    </a>-->
                                    
                                    <!-- 최신 데이터 다운로드 -->
                                    <a href="#" class="dropdown-item admin-item" id="currentDataDownload">
                                        <div class="dropdown-icon-wrapper">
                                            <i class="dropdown-icon fa-solid fa-download"></i>
                                        </div>
                                        <div class="dropdown-item-content">
                                            <div class="dropdown-item-title">최신 데이터 다운로드 <span class="admin-badge">Admin</span></div>
                                            <div class="dropdown-item-description">현재 월 아파트 거래 데이터를 APARTMENTINFO 테이블에 저장</div>
                                        </div>
                                    </a>
                                    
                                    <!-- 과거 데이터 다운로드 -->
                                    <a href="#" class="dropdown-item admin-item" id="historicalDataDownload">
                                        <div class="dropdown-icon-wrapper">
                                            <i class="dropdown-icon fa-solid fa-database"></i>
                                        </div>
                                        <div class="dropdown-item-content">
                                            <div class="dropdown-item-title">1. 과거 데이터 다운로드 <span class="admin-badge">Admin</span></div>
                                            <div class="dropdown-item-description">과거 데이터 1월기준 다운로드<br>시간이 오래 걸릴 수 있습니다</div>
                                        </div>
                                    </a>
                                    
                                    <!-- 데이터 동기화 (프로시저 실행) -->
                                    <a href="#" class="dropdown-item admin-item" id="dataSynchronization">
                                        <div class="dropdown-icon-wrapper">
                                            <i class="dropdown-icon fa-solid fa-sync"></i>
                                        </div>
                                        <div class="dropdown-item-content">
                                            <div class="dropdown-item-title">2. 데이터 동기화 <span class="admin-badge">Admin</span></div>
                                            <div class="dropdown-item-description">과거 데이터를 년별 정리<br>(과거 데이터 다운로드 후 실행)</div>
                                        </div>
                                    </a>
                                    
                                    <!-- 큐 데이터 정리 -->
                                    <a href="#" class="dropdown-item admin-item" id="queueCleanup">
                                        <div class="dropdown-icon-wrapper">
                                            <i class="dropdown-icon fa-solid fa-trash-can"></i>
                                        </div>
                                        <div class="dropdown-item-content">
                                            <div class="dropdown-item-title">3. 큐 데이터 정리 <span class="admin-badge">Admin</span></div>
                                            <div class="dropdown-item-description">처리 완료된 큐 데이터 삭제<br>(동기화 후 실행)</div>
                                        </div>
                                    </a>
                                </div>
                                </c:if>
                            </div>

                            <!-- 드롭다운 푸터 -->
                            <div class="dropdown-footer">
                                <a href="/privacy" class="dropdown-footer-link">개인정보처리방침</a>
                                <a href="/logout" class="logout-button">
                                    <i class="fa-solid fa-right-from-bracket"></i>
                                    로그아웃
                                </a>
                            </div>
                        </div>
                    </div>
                    </c:when>
                    <c:otherwise>
                    <!-- 로그인/회원가입 버튼 -->
                    <div class="auth-buttons">
                        <a href="/loginForm" class="auth-link login-link">
                            <i class="fa-solid fa-right-to-bracket"></i> 로그인
                        </a>
                        <a href="/joinForm" class="auth-link register-link">
                            <i class="fa-solid fa-user-plus"></i> 회원가입
                        </a>
                    </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>
	
	<!-- 토큰 만료 시간 관리 컴포넌트 -->
	<c:if test="${user != null}">
	<div class="token-expiry-manager" id="tokenExpiryManager">
	    <div class="token-card">
	        <div class="token-header">
	            <div class="token-title">
	                <i class="fas fa-clock"></i> 세션 만료 시간
	            </div>
	            <div class="token-actions">
	                <button id="extendTokenBtn" class="token-extend-btn">
	                    <i class="fas fa-sync-alt"></i> 연장하기
	                </button>
	                <button id="toggleTokenBtn" class="token-toggle-btn">
	                    <i class="fas fa-chevron-up"></i>
	                </button>
	            </div>
	        </div>
	        
	        <div class="token-body" id="tokenBody">
	            <div class="token-info">
	                <span>남은 시간</span>
	                <span id="remainingTime">--:--</span>
	            </div>
	            
	            <div class="progress-container">
	                <div id="progressBar" class="progress-bar"></div>
	            </div>
	            
	            <div class="token-expiry">
	                <span>* 시간이 만료되면 자동으로 로그아웃됩니다.</span>
	            </div>
	        </div>
	    </div>
	    
	    <!-- 접힌 상태일 때 표시될 미니 타이머 -->
	    <div class="token-mini" id="tokenMini">
	        <i class="fas fa-clock"></i> <span id="miniRemainingTime">--:--</span>
	    </div>
	</div>
	</c:if>
	
    <script src="/resources/js/token_manager.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 사용자 드롭다운 기능
            const dropdownToggle = document.getElementById('dropdownToggle');
            const userDropdown = document.getElementById('userDropdown');

            if (dropdownToggle && userDropdown) {
                dropdownToggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    userDropdown.classList.toggle('active');
                });

                // 외부 클릭 시 드롭다운 닫기
                document.addEventListener('click', function(e) {
                    if (userDropdown && !userDropdown.contains(e.target)) {
                        userDropdown.classList.remove('active');
                    }
                });
            }

            // 헤더 스크롤 효과
            const header = document.querySelector('.top-header');
            window.addEventListener('scroll', function() {
                if (window.scrollY > 10) {
                    header.classList.add('scrolled');
                } else {
                    header.classList.remove('scrolled');
                }
            });

            // 초기 스크롤 위치 확인
            if (window.scrollY > 10) {
                header.classList.add('scrolled');
            }

            // 관리자 기능 이벤트 리스너
            setupAdminFunctions();
        });

        function setupAdminFunctions() {
            // 최신 데이터 다운로드
            const currentDataBtn = document.getElementById('currentDataDownload');
            if (currentDataBtn) {
                currentDataBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    executeCurrentDataDownload();
                });
            }

            // 과거 데이터 다운로드
            const historicalDataBtn = document.getElementById('historicalDataDownload');
            if (historicalDataBtn) {
                historicalDataBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    executeHistoricalDataDownload();
                });
            }

            // 데이터 동기화
            const syncBtn = document.getElementById('dataSynchronization');
            if (syncBtn) {
                syncBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    executeDataSynchronization();
                });
            }

            // 큐 데이터 정리
            const cleanupBtn = document.getElementById('queueCleanup');
            if (cleanupBtn) {
                cleanupBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    executeQueueCleanup();
                });
            }
        }

        // 최신 데이터 다운로드 함수
        function executeCurrentDataDownload() {
            const btn = document.getElementById('currentDataDownload');
            if (!confirm('최신 아파트 거래 데이터를 다운로드하시겠습니까?\n(현재 월 데이터가 APARTMENTINFO 테이블에 저장됩니다)')) {
                return;
            }

            setButtonLoading(btn, true);

            fetch('/api/apartment/download', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                console.log('Current data download response:', data);
                
                if (data.status === 'success') {
                    alert(`최신 데이터 다운로드 완료!\n저장된 데이터 수: ${data.count}개`);
                } else {
                    alert('다운로드 실패: ' + (data.message || '알 수 없는 오류'));
                }
                
                setButtonLoading(btn, false);
            })
            .catch(error => {
                console.error('최신 데이터 다운로드 중 오류:', error);
                alert('다운로드 중 오류가 발생했습니다: ' + error.message);
                setButtonLoading(btn, false);
            });
        }

        // 과거 데이터 다운로드 함수
		function executeHistoricalDataDownload() {
		    const btn = document.getElementById('historicalDataDownload');
		    if (!confirm('과거 아파트 거래 데이터를 다운로드하시겠습니까?\n\n주의사항:\n- 시간이 매우 오래 걸릴 수 있습니다\n- 데이터가 APARTMENTINFO_QUEUE 테이블에 저장됩니다\n- 다운로드 중에는 브라우저를 닫지 마세요')) {
		        return;
		    }

		    const yearsInput = prompt('몇 년치 데이터를 다운로드하시겠습니까? (기본값: 10년)', '10');
		    
		    if (yearsInput === null) {
		        return;
		    }
		    
		    const years = parseInt(yearsInput.trim() || '10');
		    
		    if (isNaN(years) || years <= 0 || years > 20) {
		        alert('올바른 년수를 입력해주세요. (1-20년 사이)');
		        return;
		    }

		    console.log('전송할 년수:', years);

		    setButtonLoading(btn, true);

		    fetch('/api/apartment/download-historical', {
		        method: 'POST',
		        headers: {
		            'Content-Type': 'application/json',
		            'Accept': 'application/json'
		        },
		        body: JSON.stringify({ years: years })
		    })
		    .then(response => response.json())
		    .then(data => {
		        console.log('Historical data download response:', data);
		        
		        if (data.status === 'success') {
		            alert(`과거 ${years}년치 데이터 다운로드 완료!\n저장된 데이터 수: ${data.count}개\n\n다음 단계: 데이터 동기화를 실행해주세요.`);
		        } else {
		            alert('다운로드 실패: ' + (data.message || '알 수 없는 오류'));
		        }
		        
		        setButtonLoading(btn, false);
		    })
		    .catch(error => {
		        console.error('과거 데이터 다운로드 중 오류:', error);
		        alert('다운로드 중 오류가 발생했습니다: ' + error.message);
		        setButtonLoading(btn, false);
		    });
		}

        // 데이터 동기화 함수
        function executeDataSynchronization() {
            const btn = document.getElementById('dataSynchronization');
            if (!confirm('큐에 저장된 데이터를 년별 테이블로 정리하시겠습니까?\n\n주의사항:\n- 과거 데이터 다운로드가 완료된 후 실행해야 합니다\n- 처리 시간이 오래 걸릴 수 있습니다')) {
                return;
            }

            setButtonLoading(btn, true);

			fetch('/api/apartment/execute-procedure', {
			    method: 'POST',
			    headers: {
			        'Content-Type': 'application/json',
			        'Accept': 'application/json'
			    },
			    body: JSON.stringify({
			        procedure: 'process_apartmentinfo_queue'
			    })
			})
            .then(response => response.json())
            .then(data => {
                console.log('Data synchronization response:', data);
                
                if (data.success) {
                    alert(`데이터 동기화 완료!\n처리된 데이터 수: ${data.processedCount}\n생성된 테이블 수: ${data.tableCount}\n\n다음 단계: 큐 데이터 정리를 실행해주세요.`);
                } else {
                    if (data.message && data.message.includes('처리할 데이터가 없습니다')) {
                        alert('처리할 데이터가 없습니다.\n먼저 과거 데이터 다운로드를 실행해주세요.');
                    } else {
                        alert('동기화 실패: ' + (data.message || '알 수 없는 오류'));
                    }
                }
                
                setButtonLoading(btn, false);
            })
            .catch(error => {
                console.error('데이터 동기화 중 오류:', error);
                alert('동기화 중 오류가 발생했습니다: ' + error.message);
                setButtonLoading(btn, false);
            });
        }

        // 큐 데이터 정리 함수
        function executeQueueCleanup() {
            const btn = document.getElementById('queueCleanup');
            if (!confirm('처리 완료된 큐 데이터를 삭제하시겠습니까?\n\n주의사항:\n- 데이터 동기화가 완료된 후 실행해야 합니다\n- 삭제된 데이터는 복구할 수 없습니다')) {
                return;
            }

            setButtonLoading(btn, true);

            fetch('/api/apartment/clean-queue', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json'
                }
            })
            .then(response => response.json())
            .then(data => {
                console.log('Queue cleanup response:', data);
                
                if (data.status === 'success') {
                    alert(`큐 데이터 정리 완료!\n삭제된 데이터 수: ${data.count}개`);
                } else {
                    alert('정리 실패: ' + (data.message || '알 수 없는 오류'));
                }
                
                setButtonLoading(btn, false);
            })
            .catch(error => {
                console.error('큐 데이터 정리 중 오류:', error);
                alert('정리 중 오류가 발생했습니다: ' + error.message);
                setButtonLoading(btn, false);
            });
        }

        // 버튼 로딩 상태 설정
        function setButtonLoading(button, isLoading) {
            const iconWrapper = button.querySelector('.dropdown-icon-wrapper');
            const titleElement = button.querySelector('.dropdown-item-title');
            
            if (isLoading) {
                button.style.pointerEvents = 'none';
                button.dataset.originalIcon = iconWrapper.innerHTML;
                button.dataset.originalTitle = titleElement.innerHTML;
                
                iconWrapper.innerHTML = '<i class="dropdown-icon fa-solid fa-spinner fa-spin"></i>';
                
                const adminBadge = titleElement.querySelector('.admin-badge');
                const badgeHtml = adminBadge ? adminBadge.outerHTML : '';
                titleElement.innerHTML = '처리 중... ' + badgeHtml;
            } else {
                button.style.pointerEvents = 'auto';
                
                if (button.dataset.originalIcon) {
                    iconWrapper.innerHTML = button.dataset.originalIcon;
                }
                if (button.dataset.originalTitle) {
                    titleElement.innerHTML = button.dataset.originalTitle;
                }
            }
        }
    </script>
</body>
</html>