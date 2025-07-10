function fn_submit() {
    // jQuery 사용 확인
    if (typeof jQuery === "undefined") {
      console.error("jQuery is not loaded")
      return
    }
  
    // 선택된 값 확인
    const selectedRegion = document.getElementById("majorRegion").value
    const selectedDistrict = document.getElementById("district").value
    const selectedStation = document.getElementById("station").value
  
    // 유효성 검사
    if (!selectedRegion) {
      alert("지역을 선택해주세요.")
      return
    }
  
    if (!selectedDistrict) {
      alert("구/군을 선택해주세요.")
      return
    }
  
    if (!selectedStation) {
      alert("지하철역을 선택해주세요.")
      return
    }
  
    // 폼 데이터 직렬화
    var formData = jQuery("#search-form").serialize()
  
    // 선택된 지하철역 값을 searchKeyword 파라미터로 추가
    // 기존 코드와의 호환성을 위해 searchKeyword 파라미터도 함께 전송
    // formData += "&searchKeyword=" + encodeURIComponent(selectedStation)
  
    // console.log("전송 데이터:", formData)
  
    // AJAX 요청 전송
    jQuery.ajax({
      type: "GET",
      url: "search_map",
      data: formData,
      success: (data) => {
        // 결과 페이지로 이동
        location.href = "search_map?" + formData
      },
      error: (xhr) => {
        console.error("AJAX 오류:", xhr)
        alert("검색 요청 중 오류가 발생했습니다.")
      },
    })
  }
  
  // 페이지 로드 시 이벤트 리스너 등록
  document.addEventListener("DOMContentLoaded", () => {
    // 폼 제출 시 엔터 입력을 막고 fn_submit 호출
    const searchForm = document.getElementById("search-form")
    if (searchForm) {
      searchForm.addEventListener("submit", (e) => {
        e.preventDefault() // 새로고침 방지
        fn_submit() // 검색 함수 호출
      })
    }
  })
  

  