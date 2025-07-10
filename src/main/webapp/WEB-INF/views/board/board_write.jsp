<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>게시글 작성 - 메트로하우스</title>
<link rel="stylesheet" type="text/css" href="/resources/css/board_write.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<script src="/resources/js/board_write.js"></script>
</head>
<body>
	<jsp:include page="../header.jsp" />

	<!-- JWT 인증 방식으로 변경: 세션 체크 대신 모델에서 user 객체 확인 -->
	<c:if test="${empty user}">
		<c:redirect url="/loginForm" />
	</c:if>

	<div class="container">
		<div class="board-container">
			<div class="board-form">
				<div class="form-header">
					<h1 class="form-title"><i class="fas fa-pen-to-square"></i> 게시글 작성</h1>
					<p class="form-description">메트로하우스 커뮤니티에 의견을 공유해보세요.</p>
				</div>

				<form id="frm">
					<input type="hidden" name="userNumber" value="${user.userNumber}"> 
					<input type="hidden" name="userName" value="${user.userName}">
					<input type="hidden" name="boardContent" id="boardContent">

					<div class="form-group">
						<label for="boardTitle" class="form-label">제목</label> 
						<input type="text" id="boardTitle" name="boardTitle" class="form-control"
							placeholder="제목을 입력하세요" required>
					</div>

					<div class="form-group">
						<label for="editor" class="form-label">내용</label>
						<div id="editor" class="editor-container" name="boardContent"></div>
						<div id="contentError" class="error-message"></div>
					</div>

					<div class="form-actions">
						<button type="button" class="btn btn-secondary"
							onclick="location.href='board_view'">
							<i class="fas fa-times"></i> 취소
						</button>
						<button type="button" class="btn btn-primary" onclick="fn_submit()">
							<i class="fas fa-check"></i> 등록하기
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		function fn_submit() {
			const content = quill.root.innerHTML;
			const plainText = quill.getText().trim();

			// 유효성 검사
			if (plainText.length < 1) {
				document.getElementById('contentError').textContent = '내용은 최소 10자 이상 입력해주세요.';
				return;
			} else {
				document.getElementById('contentError').textContent = '';
			}

			document.getElementById('boardContent').value = content;

			var formData = $("#frm").serialize();

			$.ajax({
				type: "post",
				url: "board_write_ok",
				data: formData,
				success: function(data) {
					alert("게시글이 등록되었습니다.");
					location.href = "board_view";
				},
				error: function(xhr, status, error) {
					if (xhr.status === 401) {
						alert("로그인이 필요합니다.");
						location.href = "loginForm";
					} else {
						alert("게시글 등록 중 오류가 발생했습니다.");
						console.error("Error details:", error);
					}
				}
			});
		}
		// Quill 에디터 초기화
		var quill = new Quill('#editor', {
			theme: 'snow',
			placeholder: '내용을 입력하세요.',
			modules: {
				toolbar: [
					[{ 'header': [1, 2, 3, 4, 5, 6, false] }],
					['bold', 'italic', 'underline', 'strike'],
					[{ 'color': [] }, { 'background': [] }],
					[{ 'list': 'ordered' }, { 'list': 'bullet' }],
					[{ 'align': [] }],
					['link', 'image'],
					['clean']
				]
			}
		});
	</script>
</body>
</html>
