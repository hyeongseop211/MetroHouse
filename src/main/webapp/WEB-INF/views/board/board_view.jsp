<%@page import="com.boot.user.dto.UserDTO" %>
<%@page import="com.boot.board.dto.BoardDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>커뮤니티 게시판 - 메트로하우스</title>
    <link rel="stylesheet" type="text/css" href="/resources/css/board_view.css">
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link
        href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
    <script src="/resources/js/board_view.js"></script>
</head>

<body>
    <jsp:include page="../header.jsp" />

    <div class="container">
        <div class="board-container">
            <div class="board-header">
                <h1 class="board-title"><i class="fas fa-comments"></i> 커뮤니티 게시판</h1>
                <div class="board-actions">
                    <c:if test="${not empty user}">
                        <button class="write-button" onclick="location.href='/board_write'">
                            <i class="fas fa-pen"></i> 글쓰기
                        </button>
                    </c:if>
                </div>
            </div>

            <form id="searchForm" method="get">
                <select name="type">
                    <option value="T" <c:out
                        value="${pageMaker.criteriaDTO.type eq 'T' ? 'selected':''}" />>제목
                    </option>
                    <option value="C" <c:out
                        value="${pageMaker.criteriaDTO.type eq 'C' ? 'selected':''}" />>내용
                    </option>
                    <option value="W" <c:out
                        value="${pageMaker.criteriaDTO.type eq 'W' ? 'selected':''}" />>작성자
                    </option>
                </select>
                <input type="text" name="keyword" class="search-input"
                    placeholder="검색어를 입력하세요" value="${pageMaker.criteriaDTO.keyword}">
                <input type="hidden" name="pageNum" value="1">
                <input type="hidden" name="amount" value="${pageMaker.criteriaDTO.amount}">
                <button type="submit" class="search-button">
                    <i class="fas fa-search"></i>
                </button>
            </form>

            <div class="table-container">
                <table class="board-table">
                    <thead>
                        <tr>
                            <th class="board-number">번호</th>
                            <th class="board-title-col">제목</th>
                            <th class="board-author">작성자</th>
                            <th class="board-date">작성일</th>
                            <th class="board-views">조회</th>
                            <th class="board-likes">추천</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty boardList}">
                            <tr>
                                <td colspan="6" class="empty-message">등록된 게시글이 없습니다.</td>
                            </tr>
                        </c:if>

                        <c:forEach items="${boardList}" var="board" varStatus="status">
                            <tr>
                                <td class="board-number">${board.boardNumber}</td>
                                <td class="board-title-col">
                                    <a href="board_detail_view?boardNumber=${board.boardNumber}&pageNum=${pageMaker.criteriaDTO.pageNum}&amount=${pageMaker.criteriaDTO.amount}${not empty pageMaker.criteriaDTO.type ? '&type='.concat(pageMaker.criteriaDTO.type) : ''}${not empty pageMaker.criteriaDTO.keyword ? '&keyword='.concat(pageMaker.criteriaDTO.keyword) : ''}"
                                       class="title-link">
                                           ${board.boardTitle}
                                           <c:if test="${commentCounts[board.boardNumber] > 0}">
                                            <span class="comment-count">[${commentCounts[board.boardNumber]}]</span>
                                        </c:if>
                                    </a>
                                </td>
                                <td class="board-author">${board.userName}</td>
                                <td class="board-date">
                                    <c:set var="dateStr" value="${board.boardWriteDate}" />
                                    <c:if test="${not empty dateStr}">
                                        <c:choose>
                                            <c:when test="${fn:length(dateStr) > 10}">
                                                ${fn:substring(dateStr, 0, 10)}
                                            </c:when>
                                            <c:otherwise>
                                                ${dateStr}
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                                <td class="board-views">${board.boardViews}</td>
                                <td class="board-likes">${board.boardLikes}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
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

                    <c:forEach var="num" begin="${pageMaker.startPage}"
                        end="${pageMaker.endPage}">
                        <li
                            class="paginate_button ${pageMaker.criteriaDTO.pageNum==num ? 'active' : ''}">
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
            <form id="actionForm" action="board_view" method="get">
                <input type="hidden" name="pageNum" value="${pageMaker.criteriaDTO.pageNum}">
                <input type="hidden" name="amount" value="${pageMaker.criteriaDTO.amount}">
                <c:if test="${not empty pageMaker.criteriaDTO.type}">
                    <input type="hidden" name="type" value="${pageMaker.criteriaDTO.type}">
                </c:if>
                <c:if test="${not empty pageMaker.criteriaDTO.keyword}">
                    <input type="hidden" name="keyword" value="${pageMaker.criteriaDTO.keyword}">
                </c:if>
            </form>
        </div>

        <script>
            // 페이징처리
            var actionForm = $("#actionForm");

            // 페이지번호 처리
            $(".paginate_button a").on("click", function (e) {
                e.preventDefault();
                console.log("click했음");
                console.log("@# href => " + $(this).attr("href"));

                // actionForm.find("input[name='pageNum']").val(this).attr("href");
                actionForm.find("input[name='pageNum']").val($(this).attr("href"));

                // 버그처리(게시글 클릭 후 뒤로가기 누른 후 다른 페이지 클릭 할 때 content_view2가 작동되는 것을 해결)
                actionForm.attr("action", "board_view").submit();
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
                searchForm.attr("action", "board_view").submit();
            }); // end of searchForm click

            // type 콤보박스 변경
            $("#searchForm select").on("change", function () {
                if (searchForm.find("option:selected").val() == "") {
                    // 키워드를 널값으로 변경
                    searchForm.find("input[name='keyword']").val("");
                }
            }); // end of searchForm click 2
        </script>
</body>

</html>
