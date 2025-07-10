<%@page import="com.boot.user.dto.UserDTO" %>
<%@page import="com.boot.board.dto.BoardDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html >
<html>

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>${board.boardTitle} - 메트로하우스</title>
	<link rel="stylesheet" type="text/css" href="/resources/css/board_detail.css">
	<link rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<link
		href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
		rel="stylesheet">
	<script src="/resources/js/board_detail.js"></script>
</head>

<body>
	<jsp:include page="../header.jsp" />

	<div class="container">
		<div class="board-container">
			<div class="board-detail">
				<div class="board-header">
					<div class="board-category">
						<a href="/board_view" class="category-link">
							<i class="fas fa-comments"></i> 커뮤니티 게시판
						</a>
					</div>
					<h1 class="board-title">${board.boardTitle}</h1>
					<div class="board-meta">
						<div class="author-info">
							<div class="author-avatar">${fn:substring(board.userName, 0, 1)}</div>
							<div class="author-details">
								<div class="author-name">${board.userName}</div>
								<div class="post-date">
									<c:set var="dateStr" value="${board.boardWriteDate}" />
									<c:if test="${not empty dateStr}">
										<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
										<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
										<c:choose>
											<c:when test="${fn:length(formattedDate) > 16}">
												${fn:substring(formattedDate, 0, 16)}
											</c:when>
											<c:otherwise>
												${formattedDate}
											</c:otherwise>
										</c:choose>
									</c:if>
								</div>
							</div>
						</div>
						<div class="post-info">
							<div class="info-item">
								<i class="fas fa-eye"></i> <span>${board.boardViews}</span>
							</div>
							<div class="info-item">
								<i class="fas fa-heart"></i> <span
									id="like-count">${board.boardLikes}</span>
							</div>
						</div>
					</div>
				</div>

				<div class="board-content">${board.boardContent}</div>

				<div class="board-actions">
					<button class="like-button" onclick="likePost(${board.boardNumber})">
						<i class="fas fa-heart"></i> <span>추천</span> <span
							class="like-count">${board.boardLikes}</span>
					</button>

					<div class="action-buttons">
						<c:if test="${not empty user && (user.userNumber == board.userNumber || user.userAdmin == 1)}">
							<button class="action-button edit-button"
								onclick="location.href='/board_update?boardNumber=${board.boardNumber}'">
								<i class="fas fa-edit"></i> 수정
							</button>
							<button class="action-button delete-button"
								onclick="deletePost(${board.boardNumber})">
								<i class="fas fa-trash"></i> 삭제
							</button>
						</c:if>
						<button class="action-button list-button" onclick="goToList()">
							<i class="fas fa-list"></i> 목록
						</button>
					</div>
				</div>
			</div>

			<div class="comments-section">
				<h2 class="comments-header">
					<i class="fas fa-comment-dots"></i> 댓글
					<span class="comment-count">${allCount}</span>
				</h2>

				<c:choose>
					<c:when test="${not empty user}">
						<div class="comment-form">
							<form id="commentForm" onsubmit="return submitComment(this);">
								<input type="hidden" name="boardNumber" value="${board.boardNumber}">
								<input type="hidden" name="userNumber" value="${user.userNumber}">
								<input type="hidden" name="userName" value="${user.userName}">
								<input type="hidden" name="commentSubNumber" value="0">
								<input type="hidden" name="commentSubStepNumber" value="0">
								<textarea name="commentContent" class="comment-textarea"
									placeholder="댓글을 작성해주세요"></textarea>
								<button type="submit" class="comment-submit">
									<i class="fas fa-paper-plane"></i> 댓글 작성
								</button>
								<div style="clear: both;"></div>
							</form>
						</div>
					</c:when>
					<c:otherwise>
						<div class="comment-form login-required">
							<p>
								댓글을 작성하려면 <a href="/loginForm">로그인</a>이 필요합니다.
							</p>
						</div>
					</c:otherwise>
				</c:choose>

				<div class="comment-list">
					<c:if test="${empty commentList}">
						<div class="no-comments">
							<i class="fas fa-comment-slash"></i>
							<p>아직 댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
						</div>
					</c:if>

					<!-- 메인 댓글 표시 -->
					<c:forEach items="${commentList}" var="comment">
						<c:if test="${comment.commentSubNumber == 0}">
							<div class="comment-item"
								id="comment-${comment.commentNumber}">
								<div class="comment-header">
									<div class="comment-author-avatar">
										${fn:substring(comment.userName, 0, 1)}
									</div>
									<div class="comment-content-wrapper">
										<div class="comment-meta">
											<div class="comment-author">${comment.userName}
												<!-- 작성일자를 이름 바로 옆으로 이동 -->
												<span class="comment-date">
													<c:set var="dateStr" value="${comment.commentWriteDate}" />
													<c:if test="${not empty dateStr}">
														<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
														<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
														<c:choose>
															<c:when test="${fn:length(formattedDate) > 16}">
																${fn:substring(formattedDate, 0, 16)}
															</c:when>
															<c:otherwise>
																${formattedDate}
															</c:otherwise>
														</c:choose>
													</c:if>
												</span>
											</div>
										</div>
										<div class="comment-content">
											${comment.commentContent}
										</div>
									</div>
								</div>

								<!-- 답글 버튼 -->
								<c:if test="${not empty user}">
									<button class="reply-button"
										onclick="showReplyForm(${comment.commentNumber}, '${comment.userName}', 0)">
										<i class="fas fa-reply"></i> 답글
									</button>

									<!-- 대댓글 작성 폼 -->
									<div class="reply-form"
										id="reply-form-${comment.commentNumber}">
										<form onsubmit="return submitReply(this, ${comment.commentNumber});">
											<input type="hidden" name="boardNumber"
												value="${board.boardNumber}">
											<input type="hidden" name="userNumber"
												value="${user.userNumber}">
											<input type="hidden" name="userName"
												value="${user.userName}">
											<input type="hidden" name="commentSubNumber"
												value="${comment.commentNumber}">
											<input type="hidden"
												name="commentSubStepNumber" value="1">
											<input type="hidden"
												id="replyToUser-${comment.commentNumber}"
												name="replyToUser" value="">
											<div id="replyToMessage-${comment.commentNumber}"
												class="reply-to"></div>
											<textarea name="commentContent"
												class="reply-textarea"
												placeholder="답글을 작성해주세요"></textarea>
											<div class="reply-actions">
												<button type="button"
													class="reply-cancel"
													onclick="hideReplyForm(${comment.commentNumber})">취소</button>
												<button type="submit"
													class="reply-submit">
													<i class="fas fa-paper-plane"></i>
													답글 작성
												</button>
											</div>
											<div style="clear: both;"></div>
										</form>
									</div>
								</c:if>

								<!-- 대댓글 표시 (commentSubStepNumber 순서대로 정렬) -->
								<c:forEach items="${commentList}" var="reply">
									<c:if test="${reply.commentSubNumber == comment.commentNumber}">
										<div class="reply-item" id="comment-${reply.commentNumber}">
											<div class="reply-indicator">
												<i class="fas fa-reply fa-flip-horizontal"></i>
											</div>
											<div class="comment-header">
												<div class="comment-author-avatar reply-avatar">
													${fn:substring(reply.userName, 0, 1)}
												</div>
												<div class="comment-content-wrapper">
													<div class="comment-meta">
														<div class="comment-author">${reply.userName}
															<!-- 작성일자를 이름 바로 옆으로 이동 -->
															<span class="comment-date">
																<c:set var="dateStr" value="${reply.commentWriteDate}" />
																<c:if test="${not empty dateStr}">
																	<c:set var="formattedDate" value="${fn:replace(dateStr, '[', '')}" />
																	<c:set var="formattedDate" value="${fn:replace(formattedDate, ']', '')}" />
																	<c:choose>
																		<c:when test="${fn:length(formattedDate) > 16}">
																			${fn:substring(formattedDate, 0, 16)}
																		</c:when>
																		<c:otherwise>
																			${formattedDate}
																		</c:otherwise>
																	</c:choose>
																</c:if>
															</span>
														</div>
													</div>
													<div class="comment-content">
														${reply.commentContent}
													</div>
												</div>
											</div>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</c:if>
					</c:forEach>
				</div>

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
							<li class="paginate_button ${pageMaker.criteriaDTO.commentPageNum==num ? 'active' : ''}">
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
				<form id="actionForm" action="board_detail_view" method="get">
					<input type="hidden" name="boardNumber" value="${board.boardNumber}">
					<input type="hidden" name="pageNum" value="${param.pageNum}">
					<input type="hidden" name="commentPageNum" value="${pageMaker.criteriaDTO.commentPageNum}">
					<input type="hidden" name="amount" value="${param.amount}">
					<input type="hidden" name="skipViewCount" value="true">
					<c:if test="${not empty param.type}">
						<input type="hidden" name="type" value="${param.type}">
					</c:if>
					<c:if test="${not empty param.keyword}">
						<input type="hidden" name="keyword" value="${param.keyword}">
					</c:if>
				</form>
			</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		function likePost(boardNumber) {
			$.ajax({
				type: "post",
				url: "/boardLikes",
				data: { boardNumber: boardNumber },
				success: (data) => {
					// 좋아요 수 업데이트
					const likeCountElements = $(".like-count, #like-count");
					const currentCount = Number.parseInt(likeCountElements.first().text());
					
					if (data === "추천 완료") {
						// 좋아요 추가
						likeCountElements.text(currentCount + 1);
						// 좋아요 버튼 활성화 효과
						$(".like-button").addClass("active");
					} else if (data === "추천 취소 완료") {
						// 좋아요 취소
						likeCountElements.text(currentCount - 1);
						// 좋아요 버튼 비활성화 효과
						$(".like-button").removeClass("active");
					}
					
					console.log(data);
				},
				error: (xhr) => {
					if (xhr.status === 401) {
						alert("로그인 후 추천을 누르실 수 있습니다.");
					} else {
						alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
					}
				}
			});
		}

		function deletePost(boardNumber) {
			if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
				$.ajax({
					type: "post",
					url: "delete_post",
					data: { boardNumber: boardNumber },
					success: (data) => {
						alert("정상적으로 삭제되었습니다.");
						location.href = "board_view";
					},
					error: () => {
						alert("오류 발생");
					}
				});
			}
		}

		// 댓글 작성 AJAX 처리
		function submitComment(form) {
			// 폼 데이터 가져오기
			const formData = new FormData(form);
			const commentData = {};
			
			// FormData를 객체로 변환
			for (let [key, value] of formData.entries()) {
				commentData[key] = value;
			}
			
			// 빈 댓글 체크
			if (!commentData.commentContent.trim()) {
				alert("댓글 내용을 입력해주세요.");
				return false;
			}
			
			// AJAX 요청
			$.ajax({
				type: "post",
				url: "/comment_write_ok",
				data: commentData,
				success: function(response) {
					// 댓글 입력창 초기화
					form.querySelector('textarea').value = '';
					
					// 조회수 증가 방지를 위해 skipViewCount=true 파라미터 추가하여 새로고침
					const currentUrl = window.location.href;
					const url = new URL(currentUrl);
					url.searchParams.set('skipViewCount', 'true');
					window.location.href = url.toString();
				},
				error: function() {
					alert("댓글 등록 중 오류가 발생했습니다.");
				}
			});
			
			// 폼 기본 제출 동작 방지
			return false;
		}
		
		// 대댓글 작성 AJAX 처리
		function submitReply(form, commentNumber) {
			// 폼 데이터 가져오기
			const formData = new FormData(form);
			const replyData = {};
			
			// FormData를 객체로 변환
			for (let [key, value] of formData.entries()) {
				replyData[key] = value;
			}
			
			// 빈 댓글 체크
			if (!replyData.commentContent.trim()) {
				alert("답글 내용을 입력해주세요.");
				return false;
			}
			
			// AJAX 요청
			$.ajax({
				type: "post",
				url: "/comment_write_ok",
				data: replyData,
				success: function(response) {
					// 답글 폼 숨기기
					hideReplyForm(commentNumber);
					
					// 조회수 증가 방지를 위해 skipViewCount=true 파라미터 추가하여 새로고침
					const currentUrl = window.location.href;
					const url = new URL(currentUrl);
					url.searchParams.set('skipViewCount', 'true');
					window.location.href = url.toString();
				},
				error: function() {
					alert("답글 등록 중 오류가 발생했습니다.");
				}
			});
			
			// 폼 기본 제출 동작 방지
			return false;
		}

		// 대댓글 폼 표시 (replyToUsername: 답글 대상 사용자, currentStep: 현재 대댓글 단계)
		function showReplyForm(commentNumber, replyToUsername, currentStep) {
			// 모든 대댓글 폼 숨기기
			document.querySelectorAll('.reply-form').forEach(form => {
				form.style.display = 'none';
			});

			// 선택한 댓글의 대댓글 폼 표시
			const replyForm = document.getElementById('reply-form-' + commentNumber);
			replyForm.style.display = 'block';

		}

		// 대댓글 폼 숨기기
		function hideReplyForm(commentNumber) {
			document.getElementById('reply-form-' + commentNumber).style.display = 'none';
		}


		// 페이징처리
		var actionForm = $("#actionForm");

		// 페이지번호 처리
		$(".paginate_button a").on("click", function (e) {
			e.preventDefault();
			console.log("click했음");
			console.log("@# href => " + $(this).attr("href"));

			// 댓글 페이지 번호 설정 (pageNum 대신 commentPageNum 사용)
			actionForm.find("input[name='commentPageNum']").val($(this).attr("href"));
			actionForm.find("input[name='skipViewCount']").val("true");

			// 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 페이지 클릭 할 때 content_view2가 작동되는 것을 해결)
			actionForm.attr("action", "board_detail_view").submit();
		}); // end of paginate_button click

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
		
		// 페이지 로드 시 추천 상태 확인
		$(document).ready(function() {
			// 로그인한 사용자만 확인
			<c:if test="${not empty user}">
				const boardNumber = ${board.boardNumber};
				
				$.ajax({
					type: "get",
					url: "/checkLikeStatus",
					data: { boardNumber: boardNumber },
					success: function(hasLiked) {
						if (hasLiked === true || hasLiked === "true") {
							// 이미 추천한 경우 버튼 활성화 스타일 적용
							$(".like-button").addClass("active");
						}
					}
				});
			</c:if>
		});
		
		// 목록 버튼 클릭 시 게시판 목록으로 이동
		function goToList() {
			// 현재 URL에서 쿼리 파라미터 가져오기
			const urlParams = new URLSearchParams(window.location.search);
			const pageNum = urlParams.get('pageNum') || 1;
			const amount = urlParams.get('amount') || 10;
			const type = urlParams.get('type') || '';
			const keyword = urlParams.get('keyword') || '';
			
			let url = "board_view?pageNum=" + pageNum + "&amount=" + amount;
			
			if(type && keyword) {
				url += "&type=" + encodeURIComponent(type) + "&keyword=" + encodeURIComponent(keyword);
			}
			
			// 게시판 목록 페이지로 직접 이동
			window.location.href = url;
		}
		
	</script>
</body>

</html>
