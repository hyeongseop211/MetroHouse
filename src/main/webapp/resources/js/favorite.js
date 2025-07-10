/**
 * 관심목록 관련 기능을 처리하는 JavaScript 파일
 */

// 관심목록 불러오기 함수
function loadFavorites() {
  console.log("관심목록 불러오기 시작")

  const interestComparisonList = document.getElementById("interestComparisonList")
  if (!interestComparisonList) {
    console.error("interestComparisonList 요소를 찾을 수 없습니다")
    return
  }

  // 로딩 표시
  interestComparisonList.innerHTML = `
        <p class="loading-message">
            <i class="fas fa-spinner fa-spin"></i> 관심목록을 불러오는 중...
        </p>
    `

  // AJAX로 관심목록 가져오기
  $.ajax({
    url: "/api/favorites",
    method: "GET",
    dataType: "json",
    success: (response) => {
      console.log("관심목록 데이터 수신:", response)
      displayFavorites(response)
    },
    error: (xhr, status, error) => {
      console.error("관심목록 가져오기 오류:", error)
      console.error("상태 코드:", xhr.status)
      console.error("응답 텍스트:", xhr.responseText)

      // 오류 메시지 표시
      interestComparisonList.innerHTML = `
                <p class="error-message">
                    <i class="fas fa-exclamation-circle"></i> 관심목록을 불러오는 중 오류가 발생했습니다.
                    ${xhr.status === 401 ? "로그인이 필요합니다." : "잠시 후 다시 시도해주세요."}
                </p>
            `
    },
  })
}

// 관심목록 표시 함수
function displayFavorites(favorites) {
  console.log("관심목록 표시 시작:", favorites?.length || 0)

  const interestComparisonList = document.getElementById("interestComparisonList")
  if (!interestComparisonList) {
    console.error("interestComparisonList 요소를 찾을 수 없습니다")
    return
  }

  if (!favorites || favorites.length === 0) {
    interestComparisonList.innerHTML = `
            <p class="no-interest-message">
                <i class="fas fa-heart"></i> 관심 등록된 아파트가 없습니다.
            </p>
        `
    return
  }

  let html = ""
  favorites.forEach((apt) => {
    // 데이터 유효성 검사 및 기본값 설정
    const aptId = apt.id || ""
    const aptName = apt.aptNm || "이름 없음"
    const location = apt.estateAgentSggNm || "위치 정보 없음"
    const dealAmount = apt.dealAmount ? `${apt.dealAmount.toLocaleString()}만원` : "가격 정보 없음"
    const excluUseAr = apt.excluUseAr ? `${apt.excluUseAr}㎡` : "면적 정보 없음"
    const floor = apt.floor ? `${apt.floor}층` : "층수 정보 없음"
    const buildYear = apt.buildYear ? `${apt.buildYear}년` : "건축년도 정보 없음"

    html += `
            <div class="comparison-item" data-apt-id="${aptId}">
                <div class="comparison-apt-info">
                    <h3 class="comparison-apt-name">${aptName}</h3>
                    <div class="comparison-apt-location">${location}</div>
                </div>
                <div class="comparison-details">
                    <div class="comparison-detail">
                        <span class="detail-label">가격</span>
                        <span class="detail-value">${dealAmount}</span>
                    </div>
                    <div class="comparison-detail">
                        <span class="detail-label">평수</span>
                        <span class="detail-value">${excluUseAr}</span>
                    </div>
                    <div class="comparison-detail">
                        <span class="detail-label">층수</span>
                        <span class="detail-value">${floor}</span>
                    </div>
                    <div class="comparison-detail">
                        <span class="detail-label">건축년도</span>
                        <span class="detail-value">${buildYear}</span>
                    </div>
                </div>
            </div>
        `
  })

  interestComparisonList.innerHTML = html
  console.log("관심목록 표시 완료")
}

// 페이지 로드 시 관심목록 불러오기
document.addEventListener("DOMContentLoaded", () => {
  loadFavorites()
})