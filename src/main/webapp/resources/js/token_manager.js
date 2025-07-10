/**
 * 토큰 만료 시간 관리 스크립트
 */
document.addEventListener('DOMContentLoaded', function() {
    // 필요한 DOM 요소
    const tokenManager = document.getElementById('tokenExpiryManager');
    const progressBar = document.getElementById('progressBar');
    const remainingTimeEl = document.getElementById('remainingTime');
    const miniRemainingTimeEl = document.getElementById('miniRemainingTime');
    const extendTokenBtn = document.getElementById('extendTokenBtn');
    const toggleTokenBtn = document.getElementById('toggleTokenBtn');
    const tokenMini = document.getElementById('tokenMini');
    
    // 요소가 없으면 실행하지 않음
    if (!remainingTimeEl || !progressBar || !extendTokenBtn || !tokenManager || !toggleTokenBtn || !miniRemainingTimeEl) {
        return;
    }
    
    // 상태 변수
    let expiryTime = null;
    let issuedAtTime = null;
    let totalValidTime = 0;
    let remainingTime = 0;
    let timerInterval;
    let isCollapsed = localStorage.getItem('tokenManagerCollapsed') === 'true';
    
    // 초기 상태 설정
    if (isCollapsed) {
        tokenManager.classList.add('collapsed');
    }
    
    // 토큰 정보 가져오기
    function getTokenInfo() {
        fetch('/api/token/info')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    expiryTime = new Date(data.expiryTime);
                    issuedAtTime = new Date(data.issuedAt);
                    totalValidTime = data.totalValidTime;
                    
                    updateRemainingTime();
                    startTimer();
                } else {
                    console.error('토큰 정보를 가져오는데 실패했습니다:', data.message);
                }
            })
            .catch(error => {
                console.error('토큰 정보 요청 중 오류:', error);
            });
    }
    
    // 타이머 시작
    function startTimer() {
        if (timerInterval) {
            clearInterval(timerInterval);
        }
        
        timerInterval = setInterval(updateRemainingTime, 1000);
    }
    
    // 남은 시간 업데이트
    function updateRemainingTime() {
        if (!expiryTime) return;
        
        const now = new Date();
        const diffMs = expiryTime.getTime() - now.getTime();
        const diffSec = Math.floor(diffMs / 1000);
        
        remainingTime = diffSec > 0 ? diffSec : 0;
        
        // 남은 시간 표시 업데이트 (일반 뷰)
        remainingTimeEl.textContent = formatTime(remainingTime);
        
        // 미니 타이머 업데이트 (접힌 뷰) - 분:초 형식만 표시
        miniRemainingTimeEl.textContent = formatTimeMinSec(remainingTime);
        
        // 프로그레스 바 업데이트
        updateProgressBar();
        
        // 만료 10분 전 알림
        if (remainingTime <= 600 && remainingTime > 595) {
            // 접힌 상태라면 펼치기
            if (tokenManager.classList.contains('collapsed')) {
                toggleTokenManager();
            }
        }
        
        // 만료되면 타이머 정리 및 페이지 새로고침
        if (remainingTime <= 0) {
            clearInterval(timerInterval);
            
            // 접힌 상태라면 펼치기
            if (tokenManager.classList.contains('collapsed')) {
                toggleTokenManager();
            }

//				tokenManager.style.display="none";
//				progressBar.style.display="none";
//				miniRemainingTimeEl.style.display="none";
//				extendTokenBtn.style.display="none";
//				toggleTokenBtn.style.display="none";
//				tokenMini.style.display="none";
            // 토큰 끝나면 로그인이동
//            window.location.href = '/loginForm';
            location.reload(true);
        }
    }
    
    // 프로그레스 바 업데이트
    function updateProgressBar() {
        const percentage = calculateProgress();
        progressBar.style.width = percentage + '%';
        
        // 진행률에 따른 클래스 변경
        progressBar.classList.remove('warning', 'danger');
        if (percentage <= 20) {
            progressBar.classList.add('danger');
        } else if (percentage <= 50) {
            progressBar.classList.add('warning');
        }
    }
    
    // 진행률 계산
    function calculateProgress() {
        if (!expiryTime || !issuedAtTime) return 100;
        
        const now = new Date();
        const elapsed = now.getTime() - issuedAtTime.getTime();
        const percentage = 100 - (elapsed / totalValidTime * 100);
        
        return Math.max(0, Math.min(100, percentage));
    }
    
    // 시간 포맷팅 (분:초)
    function formatTime(seconds) {
        const minutes = Math.floor(seconds / 60);
        const secs = seconds % 60;
        
        if (minutes > 0) {
            return `${minutes}분 ${secs}초`;
        } else {
            return `${secs}초`;
        }
    }
    
    // 시간 포맷팅 (분:초) - 미니 타이머용
    function formatTimeMinSec(seconds) {
        const minutes = Math.floor(seconds / 60);
        const secs = seconds % 60;
        
        return `${minutes}분 ${secs}초`;
    }
    
    // 토큰 연장 처리
    function extendToken() {
        // 버튼 상태 변경
        extendTokenBtn.disabled = true;
        extendTokenBtn.classList.add('refreshing');
        
        // 서버에 토큰 연장 요청
        fetch('/api/token/extend', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // 새 만료 시간 설정
                expiryTime = new Date(data.newExpiryTime);
                issuedAtTime = new Date(data.issuedAt);
                totalValidTime = data.totalValidTime;
                
                // UI 업데이트
                updateRemainingTime();
            } else {
                console.error('토큰 연장 실패:', data.message);
                // 실패 시 페이지 새로고침 또는 로그인 페이지로 이동
                // window.location.href = '/loginForm';
            }
        })
        .catch(error => {
            console.error('토큰 연장 중 오류:', error);
        })
        .finally(() => {
            // 버튼 상태 복원
            extendTokenBtn.disabled = false;
            extendTokenBtn.classList.remove('refreshing');
        });
    }
    
    // 토큰 매니저 토글 함수
    function toggleTokenManager() {
        tokenManager.classList.toggle('collapsed');
        isCollapsed = tokenManager.classList.contains('collapsed');
        
        // 상태 저장
        localStorage.setItem('tokenManagerCollapsed', isCollapsed);
    }
    
    // 이벤트 리스너 등록
    if (extendTokenBtn) {
        extendTokenBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            extendToken();
        });
    }
    
    // 토글 버튼 이벤트 리스너
    if (toggleTokenBtn) {
        toggleTokenBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            toggleTokenManager();
        });
    }
    
    // 미니 타이머 클릭 시 펼치기
    if (tokenMini) {
        tokenMini.addEventListener('click', function() {
            if (tokenManager.classList.contains('collapsed')) {
                toggleTokenManager();
            }
        });
    }
    
    // 초기 토큰 정보 가져오기
    getTokenInfo();
});