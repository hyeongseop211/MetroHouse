// 관심 아파트 해제 함수
function return_submit(button) {
	const form = button.closest("form"); // 해당 버튼의 form
	if (!form.checkValidity()) {
		form.reportValidity();
		return;
	}

	const formData = $(form).serialize(); // 개별 form 기준으로 serialize

	$.ajax({
		type: "post",
		data: formData,
		url: "apartment_favorite_remove",
		success: function(data) {
			alert("정상적으로 처리되었습니다.");
			location.href = "mypage"; // 새로고침
		},
		error: function() {
			alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
}

// 다음 주소 API 사용 함수
function execDaumPostcode() {
	new daum.Postcode({
		oncomplete: function(data) {
			document.getElementById('userZipCode').value = data.zonecode;
			document.getElementById('userAddress').value = data.address;
			document.getElementById('userDetailAddress').focus();
		}
	}).open();
}

// 탭 전환 함수
function showTab(tabId, event) {
	// 모든 탭 컨텐츠 숨기기
	document.querySelectorAll('.content-section .tab-content').forEach(tab => {
		tab.classList.remove('active');
	});

	// 모든 메뉴 아이템 비활성화
	document.querySelectorAll('.menu-item').forEach(item => {
		item.classList.remove('active');
	});

	// 선택한 탭 컨텐츠 표시
	document.getElementById(tabId + '-tab').classList.add('active');

	// 선택한 메뉴 아이템 활성화
	if (event && event.currentTarget) {
		event.currentTarget.classList.add('active');
	}
}

// 히스토리 탭 전환 함수
function showHistoryTab(tabId, event) {
	// 모든 탭 컨텐츠 숨기기
	document.querySelectorAll('.tab-container .tab-content').forEach(tab => {
		tab.classList.remove('active');
	});

	// 모든 탭 버튼 비활성화
	document.querySelectorAll('.tab-button').forEach(button => {
		button.classList.remove('active');
	});

	// 선택한 탭 컨텐츠 표시
	document.getElementById(tabId).classList.add('active');

	// 선택한 탭 버튼 활성화
	if (event && event.currentTarget) {
		event.currentTarget.classList.add('active');
	}
}

// 비밀번호 변경 폼 제출 전 검증
function validatePasswordForm() {
	const currentPassword = document.getElementById('currentPassword').value;
	const newPassword = document.getElementById('newPassword').value;
	const confirmPassword = document.getElementById('confirmPassword').value;

	// 현재 비밀번호 입력 확인
	if (!currentPassword) {
		alert('현재 비밀번호를 입력해주세요.');
		document.getElementById('currentPassword').focus();
		return false;
	}

	// 새 비밀번호 입력 확인
	if (!newPassword) {
		alert('새 비밀번호를 입력해주세요.');
		document.getElementById('newPassword').focus();
		return false;
	}

	// 비밀번호 일치 여부 확인
	if (newPassword !== confirmPassword) {
		alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
		document.getElementById('confirmPassword').focus();
		return false;
	}

	// 비밀번호 복잡성 검사
	const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
	if (!passwordRegex.test(newPassword)) {
		alert('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.');
		document.getElementById('newPassword').focus();
		return false;
	}

	return true;
}

// 정보 수정 함수 - AJAX를 사용하여 비밀번호 검증 후 제출
function updateUserInfo() {
	const form = document.getElementById("updateUserForm");
	if (!form.checkValidity()) {
		form.reportValidity();
		return;
	}

	// 비밀번호 확인
	const currentPassword = document.getElementById("updateCurrentPassword").value;
	if (!currentPassword) {
		alert("현재 비밀번호를 입력해주세요.");
		document.getElementById("updateCurrentPassword").focus();
		return;
	}

	// 비밀번호 검증을 위한 AJAX 요청
	$.ajax({
		type: "post",
		url: "verifyPassword", // 비밀번호 검증을 위한 엔드포인트
		data: {
			userId: form.userId.value,
			userPw: currentPassword
		},
		success: function(response) {
			if (response.success) {
				// 비밀번호가 맞으면 폼 제출
				submitUpdateForm();
			} else {
				alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
				document.getElementById("updateCurrentPassword").focus();
			}
		},
		error: function() {
			alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
}

// 정보 수정 폼 제출 함수
function submitUpdateForm() {
	const form = document.getElementById("updateUserForm");
	const formData = $(form).serialize();

	$.ajax({
		type: "post",
		url: "userUpdate",
		data: formData,
		success: function(response) {
			if (response.success) {
				alert(response.message);
				window.location.href = "loginView"; // 로그인 페이지로 이동
			} else {
				alert(response.message);
			}
		},
		error: function() {
			alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
}

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {


	// 정보 수정 폼 이벤트 리스너 등록
	const updateForm = document.getElementById('updateUserForm');
	if (updateForm) {
		updateForm.addEventListener('submit', function(e) {
			e.preventDefault(); // 기본 제출 동작 방지
			updateUserInfo(); // 비밀번호 검증 후 제출
		});
	}

	// 초기 탭 설정 (내 정보 탭 활성화)
	const profileTab = document.getElementById('profile-tab');
	if (profileTab) {
		profileTab.classList.add('active');
	}

	// 초기 메뉴 아이템 활성화
	const activeMenuItem = document.querySelector('.profile-menu .menu-item');
	if (activeMenuItem) {
		activeMenuItem.classList.add('active');
	}

	// 히스토리 탭 초기 설정
	const currentTab = document.getElementById('current');
	if (currentTab) {
		currentTab.classList.add('active');
	}

	// 히스토리 탭 버튼 초기 활성화
	const activeButton = document.querySelector('.tab-buttons .tab-button');
	if (activeButton) {
		activeButton.classList.add('active');
	}

	// URL 파라미터에서 탭 정보 확인
	const urlParams = new URLSearchParams(window.location.search);
	const tab = urlParams.get('tab');
	if (tab) {
		showTab(tab);
		// 해당 메뉴 아이템 활성화
		const menuItem = document.querySelector(`.menu-item[onclick*="${tab}"]`);
		if (menuItem) {
			menuItem.classList.add('active');
		}
	}

	// 에러 메시지가 있으면 해당 탭으로 이동
	if (document.querySelector('.error-message')) {
		const errorTab = document.querySelector('.error-message').closest('.tab-content').id.replace('-tab', '');
		showTab(errorTab);
	}
});
// 비밀번호 변경 함수
function changePassword() {
	// 폼 유효성 검사
	if (!validatePasswordForm()) {
		return;
	}

	// 폼 데이터 수집
	const form = document.getElementById('passwordChangeForm');
	const formData = $(form).serialize();

	// AJAX 요청
	$.ajax({
		type: "post",
		url: "userPwUpdate",
		data: formData,
		dataType: "json",
		success: function(response) {
			if (response.success) {
				alert(response.message);
				window.location.href = "loginForm"; // 로그인 페이지로 이동
			} else {
				alert(response.message);
				document.getElementById('currentPassword').value = '';
				document.getElementById('currentPassword').focus();
			}
		},
		error: function() {
			alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
		}
	});
}

// 비밀번호 유효성 검사
function validatePasswordForm() {
	const currentPassword = document.getElementById('currentPassword').value;
	const newPassword = document.getElementById('newPassword').value;
	const confirmPassword = document.getElementById('confirmPassword').value;

	// 현재 비밀번호 입력 확인
	if (!currentPassword) {
		alert('현재 비밀번호를 입력해주세요.');
		document.getElementById('currentPassword').focus();
		return false;
	}

	// 새 비밀번호 입력 확인
	if (!newPassword) {
		alert('새 비밀번호를 입력해주세요.');
		document.getElementById('newPassword').focus();
		return false;
	}

	// 비밀번호 일치 여부 확인
	if (newPassword !== confirmPassword) {
		alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.');
		document.getElementById('confirmPassword').focus();
		return false;
	}

	// 비밀번호 복잡성 검사
	const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$/;
	if (!passwordRegex.test(newPassword)) {
		alert('비밀번호는 8자 이상, 영문, 숫자, 특수문자를 포함해야 합니다.');
		document.getElementById('newPassword').focus();
		return false;
	}

	return true;
}