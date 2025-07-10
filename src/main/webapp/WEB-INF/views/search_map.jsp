<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>

<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>지하철역 주변 아파트 검색 결과 - 메트로하우스</title>
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700&display=swap"
        rel="stylesheet">
   <script type="text/javascript"
         src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services,clusterer"></script>
   <link rel="stylesheet" type="text/css" href="/resources/css/main.css">
   <link rel="stylesheet" type="text/css" href="/resources/css/search_map.css">
   <%-- <script src="/resources/js/search_map_marker.js"></script> --%>
   <script src="/resources/js/subway_section.js"></script>
   <script src="/resources/js/main.js"></script>
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.8.0/proj4.js"></script>

   <!-- JSP 데이터 바인딩용 전역 변수 선언 -->
   <script>
      const favoriteList = JSON.parse('<c:out value="${empty favoriteListJson ? '[]' : favoriteListJson}" escapeXml="false" />');
      const currentUserNumber = ${user.userNumber};
   </script>

</head>

<body>
<jsp:include page="header.jsp" />
<div class="container">
   <div class="main-content-wrapper">
      <div class="comparison-container">
         <div class="comparison-header">
            <i class="fas fa-exchange-alt"></i>
            아파트 비교
         </div>
         <div class="selected-apartment" id="selectedApartment">
            <p class="no-selection-message">
               <i class="fas fa-info-circle"></i> 우측 목록에서 아파트를 선택하세요.
            </p>
         </div>
         <div class="comparison-divider">
            <span>관심 목록과 비교</span>
         </div>
         <div class="interest-comparison-list" id="interestComparisonList">
            <c:choose>
               <c:when test="${empty interestList}">
                  <p class="no-interest-message">
                     <i class="fas fa-heart"></i> 관심 등록된 아파트가 없습니다.
                  </p>
               </c:when>
               <c:otherwise>
                  <c:forEach var="apt" items="${interestList}">
                     <div class="comparison-item" data-apt-id="${apt.apartmentId}">
                        <div class="comparison-heart" data-favorite-id="${apt.favoriteId}">
                           <i class="fas fa-heart"></i>
                           <i class="fas fa-heart-broken"></i>
                        </div>
                        <div class="comparison-apt-info">
                           <h3 class="comparison-apt-name">
                                 ${fn:split(apt.aptNm, '(')[0]}
                           </h3>
                           <div class="comparison-apt-location">${apt.estateAgentSggNm}</div>
                           <c:choose>
                              <c:when test="${not empty apt.subwayStation}">
                                 <div class="comparison-apt-subway">
                                       ${fn:split(apt.subwayStation, ' ')[0]}에서 ${apt.subwayDistance}m
                                 </div>
                              </c:when>
                              <c:otherwise>
                                 <div class="comparison-apt-subway">
                                    지하철역정보없음
                                 </div>
                              </c:otherwise>
                           </c:choose>
                        </div>
                        <div class="comparison-details">
                           <div class="comparison-detail">
                              <span class="detail-label">가격</span>
                              <span class="detail-value">${apt.dealAmount}만원</span>
                           </div>
                           <div class="comparison-detail">
                              <span class="detail-label">평수</span>
                              <span class="detail-value">${apt.excluUseAr}㎡</span>
                           </div>
                           <div class="comparison-detail">
                              <span class="detail-label">층수</span>
                              <span class="detail-value">${apt.floor}층</span>
                           </div>
                           <div class="comparison-detail">
                              <span class="detail-label">건축년도</span>
                              <span class="detail-value">${apt.buildYear}년</span>
                           </div>
                        </div>
                     </div>
                  </c:forEach>
               </c:otherwise>
            </c:choose>
         </div>
      </div>

      <div class="search-result-container">
         <div class="search-result-header">
            <h1 class="search-result-title">
               <i class="fas fa-subway"></i>검색 결과
            </h1>
            <form class="search-form" id="search-form">
               <div class="search-filters">
                  <div class="search-filter">
                     <label class="filter-label" for="majorRegion">지역</label>
                     <select class="filter-select" id="majorRegion" name="majorRegion">
                        <option value="">선택하세요</option>
                        <option value="서울" ${param.majorRegion=='서울' ? 'selected' : '' }>서울특별시</option>
                        <option value="부산" ${param.majorRegion=='부산' ? 'selected' : '' }>부산광역시</option>
                        <option value="대구" ${param.majorRegion=='대구' ? 'selected' : '' }>대구광역시</option>
                        <option value="인천" ${param.majorRegion=='인천' ? 'selected' : '' }>인천광역시</option>
                        <option value="광주" ${param.majorRegion=='광주' ? 'selected' : '' }>광주광역시</option>
                        <option value="대전" ${param.majorRegion=='대전' ? 'selected' : '' }>대전광역시</option>
                        <option value="울산" ${param.majorRegion=='울산' ? 'selected' : '' }>울산광역시</option>
                        <option value="경기" ${param.majorRegion=='경기' ? 'selected' : '' }>경기도</option>
                     </select>
                  </div>
                  <div class="search-filter">
                     <label class="filter-label" for="district">구/군</label>
                     <select class="filter-select" id="district" name="district">
                        <option value="">구/군 선택</option>
                     </select>
                  </div>
                  <div class="search-filter">
                     <label class="filter-label" for="station">지하철역</label>
                     <select class="filter-select" id="station" name="station">
                        <option value="">지하철역 선택</option>
                     </select>
                  </div>
                  <div class="search-button-container">
                     <button type="button" class="search-icon-button" onclick="fn_submit()">
                        <i class="fas fa-search"></i>
                     </button>
                  </div>
               </div>
            </form>
         </div>
         <div class="map-container">
            <div id="map"></div>
            <div class="map-loading" id="mapLoading">
               <p style="text-align: center; color: var(--gray-500);">
                  <i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i> 지도를 불러오는 중입니다...
               </p>
            </div>
         </div>
      </div>

      <div class="apartment-list-container">
         <div class="apartment-list-header">
            <i class="fas fa-building"></i>
            주변 아파트 목록
         </div>
         <div class="apartment-list" id="apartmentList">
            <p style="text-align: center; padding: 50px 0; color: var(--gray-500);" id="loadingMessage">
               <i class="fas fa-spinner fa-spin" style="margin-right: 8px;"></i> 데이터를 불러오는 중...
            </p>
         </div>
      </div>
   </div>
</div>

<script>









	   // --- 전역 변수 ---
	   let map;
	   let clusterer;
	   let currentOverlay = null; // 현재 열려있는 오버레이 객체
	   let apartmentDataStore = {}; // 전체 아파트 데이터 캐시 (Key: uniqueAptId, Value: apt 객체)
	   let markersForClusterer = []; // 클러스터러에 추가할 마커 배열
	   let drawnPolygons = []; // 그려진 폴리곤 배열
	   let gecoder;

	   // --- 좌표계 변환 함수 ---
	   proj4.defs('EPSG:5179', '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs');
	   proj4.defs('EPSG:4326', '+proj=longlat +datum=WGS84 +no_defs');
	   function convertTMToWGS84(x, y) {
	      return proj4('EPSG:5179', 'EPSG:4326', [x, y]);
	   }

	   // --- 폴리곤 관련 함수 ---
	   function clearPolygons() {
	      drawnPolygons.forEach(polygon => polygon.setMap(null));
	      drawnPolygons = [];
	   }

	   //관심목록 추가/제거 관련함수
	   function roundToFixed(num, fixed = 5) {
	      return Number(parseFloat(String(num).trim()).toFixed(fixed));
	   }

	   function normalizeAmount(amountStr) {
	      return Number(String(amountStr).replace(/[^\d]/g, '').trim());
	   }

	   function isApartmentAlreadyFavorite(lat, lng, dealAmountRaw) {
	      return favoriteList.some(item =>
	              roundToFixed(item.lat) === roundToFixed(lat) &&
	              roundToFixed(item.lng) === roundToFixed(lng) &&
	              normalizeAmount(item.dealAmount) === normalizeAmount(dealAmountRaw) &&
	              String(item.userNumber).trim() === String(currentUserNumber).trim()
	      );
	   }


	   // --- 오버레이 내용 생성 헬퍼 함수 ---
	   function createOverlayContentForApt(apt) {
	      const aptName = apt.aptNm || "이름 없음";
	      const excluUseAr = apt.excluUseAr ? apt.excluUseAr + "㎡" : "면적 없음";
	      const dealAmount = apt.dealAmount ? apt.dealAmount.toLocaleString() + "만원" : "가격 없음";
	      const locationContent = apt.estateAgentSggNm || "위치 없음";
	      const addressText = locationContent + " " + aptName;
	      const floorText = apt.floor || "-";
	      const buildYearText = apt.buildYear ? apt.buildYear + "년" : "-";
	      const distanceText = apt.subwayDistance ? (apt.subwayStation ? apt.subwayStation.split(' ')[0] : '') + "에서 " + apt.subwayDistance + "m" : "지하철역정보없음";
	      const lat = apt.lat;
	      const lng = apt.lng;
	      const dealAmountRaw = String(apt.dealAmount || '').replace(/,/g, '').replace('만원', '').trim();
	      const uniqueAptIdForFavorite = apt.apartmentId || `fav_`+lat+`_`+lng; // 관심등록용 ID
	      // 관심 등록 여부 확인 (apartmentId 기준)
	      const isAlreadyFavorite = favoriteList.some(item =>
	              String(item.apartmentId).trim() === String(apt.apartmentId).trim() &&
	              String(item.userNumber).trim() === String(currentUserNumber).trim()
	      );

	// 버튼 텍스트 및 스타일
	      const buttonText = isAlreadyFavorite
	              ? `<i class="fas fa-heart-broken"></i> 관심 해제`
	              : `<i class="fas fa-heart"></i> 관심 등록`;

	      const buttonColor = isAlreadyFavorite
	              ? `background-color: #e74c3c;`
	              : `background-color: #3498db;`;

	      const favoriteId = isAlreadyFavorite
	              ? (favoriteList.find(item =>
	                      String(item.apartmentId).trim() === String(apt.apartmentId).trim() &&
	                      String(item.userNumber).trim() === String(currentUserNumber).trim()
	              )?.favoriteId || '')
	              : '';

	      let overlayContentHTML = `
	            <div class="custom-overlay apartment-overlay">
	                <div class="overlay-header">
	                    <div class="title">`+aptName.split('(')[0]+`</div>
	                    <button class="close overlay-close-btn" title="닫기"></button>
	                </div>
	                <div class="overlay-body">
	                    <div class="overlay-section">
	                        <div class="overlay-price">`+dealAmount+`</div>
	                        <div class="overlay-size">`+excluUseAr+`</div>
	                    </div>
	                    <div class="overlay-section">
	                        <div class="overlay-address">`+addressText+`</div>`;
	      if (distanceText !== '지하철역에서 0m' && distanceText !== '지하철역정보없음' && distanceText !== '-') {
	         overlayContentHTML += `<div class="overlay-distance">`+distanceText+`</div>`;
	      } else {
	         overlayContentHTML += `<div class="overlay-distance">지하철역정보없음</div>`;
	      }
	      overlayContentHTML += `
	                    </div>
	                    <div class="overlay-section overlay-details">
	                        <div class="detail-item"><span>층수:</span> `+floorText+`</div>
	                        <div class="detail-item"><span>건축년도:</span> `+buildYearText+`</div>
	                    </div>
	                </div>
	                <div class="overlay-footer">
	<!--                    <button class="overlay-button favorite" style="width: 100%; `+buttonColor+`" data-lat="`+lat+`" data-lng="`+lng+`" data-dealamount="`+dealAmountRaw+`" data-apt-id="`+uniqueAptIdForFavorite+`">-->
	                    <button class="overlay-button favorite" style="width: 100%; `+buttonColor+`" data-apartment-id="`+apt.apartmentId+`" data-favorite-id="`+favoriteId+`" data-favorite="`+isAlreadyFavorite+`">
	<!--						<i class="fas fa-heart"></i>관심 등록-->
							`+buttonText+`
						</button>
	                </div>
	            </div>
	        `;
	      return overlayContentHTML;
	   }

	   // --- 지도 마커 및 아파트 목록 표시 함수 (롤백된 버전) ---
	   function displayApartments(apartmentsToDisplay) {
	      console.time("displayApartments_original");
	      const apartmentListContainer = document.getElementById('apartmentList');
	      apartmentListContainer.innerHTML = ''; // 기존 목록 비우기

	      const loadingMsgElement = document.getElementById('loadingMessage');
	      if (loadingMsgElement) loadingMsgElement.style.display = 'none';

	      if (clusterer) {
	         clusterer.clear();
	      }
	      markersForClusterer = [];

	      if (currentOverlay) {
	         currentOverlay.setMap(null);
	         currentOverlay = null;
	      }

	      if (!apartmentsToDisplay || apartmentsToDisplay.length === 0) {
	         apartmentListContainer.innerHTML = `
	                <p style="text-align: center; padding: 50px 0; color: var(--gray-500);" id="noResultsMessage">
	                    표시할 아파트 정보가 없습니다.
	                </p>`;
	         console.timeEnd("displayApartments_original");
	         return;
	      }

	      const listFragment = document.createDocumentFragment();

	      apartmentsToDisplay.forEach((apt, idx) => {
	         if (apt.lat && apt.lng) { // 유효한 위경도 값인지 확인
	            // 1. 마커 생성
	            const position = new kakao.maps.LatLng(parseFloat(apt.lat), parseFloat(apt.lng));
	            const marker = new kakao.maps.Marker({
	               position: position,
	               clickable: true
	            });
	            const uniqueAptId = apt.apartmentId || `apt_`+apt.lat+`_`+apt.lng+`_`+idx;
	            marker.aptId = uniqueAptId; // 마커에 ID 연결 (apartmentDataStore 참조용)
	            marker.sigunguCode = apt.sggCd;


	            kakao.maps.event.addListener(marker, 'click', function() {
	               const aptDetail = apartmentDataStore[this.aptId];
	               if (!aptDetail) {
	                  console.warn('마커 클릭: Apartment detail not found in store for ID:', this.aptId);
	                  return;
	               }
	               if (currentOverlay) {
	                  currentOverlay.setMap(null);
	               }
	               const content = createOverlayContentForApt(aptDetail);
	               currentOverlay = new kakao.maps.CustomOverlay({
	                  content: content,
	                  map: map,
	                  position: this.getPosition(),
	                  yAnchor: 1,
	                  zIndex: 10
	               });
	               map.panTo(this.getPosition());

	               if(this.sigunguCode) {
	                  clearPolygons();
	                  getApartmentData(this.sigunguCode);
	               }
	               else{
	                  console.log("시군구 코드 부재");
	               }
	            });
	            markersForClusterer.push(marker);

	            // 2. 아파트 카드 생성
	            const aptName = apt.aptNm || "이름 없음";
	            const excluUseAr = apt.excluUseAr ? apt.excluUseAr + "㎡" : "면적 없음";
	            const dealAmount = apt.dealAmount ? apt.dealAmount.toLocaleString() + "만원" : "가격 없음";
	            const locationContent = apt.estateAgentSggNm || "위치 없음";
	            const floorText = apt.floor || "-";
	            const buildYearText = apt.buildYear ? apt.buildYear + "년" : "-";
	            const subwayStation = apt.subwayStation ? apt.subwayStation.split(' ')[0] : '정보 없음';
	            const subwayDistance = apt.subwayDistance || '정보 없음';
	            const sggCd = apt.sggCd;

	            const apartmentCard = document.createElement('div');
	            apartmentCard.className = 'apartment-card';
	            apartmentCard.dataset.aptId = uniqueAptId; // 마커와 동일한 ID 사용
	            apartmentCard.dataset.floor = floorText;
	            apartmentCard.dataset.buildYear = buildYearText;
	            apartmentCard.dataset.subwayStation = subwayStation;
	            apartmentCard.dataset.subwayDistance = subwayDistance;
	            apartmentCard.dataset.name = aptName;
	            apartmentCard.dataset.location = locationContent;
	            apartmentCard.dataset.price = dealAmount;
	            apartmentCard.dataset.size = excluUseAr;
	            apartmentCard.dataset.lat = apt.lat;
	            apartmentCard.dataset.lng = apt.lng;
	            apartmentCard.dataset.sggCd = sggCd;


	            apartmentCard.innerHTML = `
	                    <div class="apartment-image">
	                        <i class="fas fa-building"></i>
	                    </div>
	                    <div class="apartment-info">
	                        <h3 class="apartment-name">`+aptName.split('(')[0]+`</h3>
	                        <div class="apartment-location">`+locationContent+`</div>
	                        <div class="apartment-details">
	                            <span>`+excluUseAr+`</span>
	                            <span class="apartment-price">`+dealAmount+`</span>
	                        </div>
	                    </div>
	                `;
	            listFragment.appendChild(apartmentCard);
	         }
	      });

	      if (clusterer) {
	         clusterer.addMarkers(markersForClusterer);
	      }
	      apartmentListContainer.appendChild(listFragment);
	      console.timeEnd("displayApartments_original");
	   }

	   // --- 아파트 데이터 가져오기 (시군구 코드 기반) ---
	   function getApartmentData(sigunguCode) {
	      // const now = new Date();
	      // const yearMonth = now.getFullYear().toString() + String(now.getMonth() + 1).padStart(2, '0');
	      // console.log('API 호출 파라미터 (getApartmentData):', {sigunguCode, yearMonth});
	      console.log('API 호출 파라미터 getApartmentData(sigunguCode)');

	      // const apartmentListContainer = document.getElementById('apartmentList');
	      // const loadingMsgElement = document.getElementById('loadingMessage');
	      // if (loadingMsgElement) {
	      //    loadingMsgElement.innerHTML = `<p style="text-align: center; padding: 50px 0; color: var(--gray-500);"><i class="fas fa-spinner fa-spin"></i> 지역 아파트 정보를 불러오는 중...</p>`;
	      //    loadingMsgElement.style.display = 'block';
	      // } else if(apartmentListContainer) { // loadingMsgElement가 없을 경우 apartmentListContainer에 직접 삽입
	      //    apartmentListContainer.innerHTML = `<p style="text-align: center; padding: 50px 0; color: var(--gray-500);" id="loadingMessage"><i class="fas fa-spinner fa-spin"></i> 지역 아파트 정보를 불러오는 중...</p>`;
	      // }
	      clearPolygons();
	      $.getJSON('/resources/json/sig2025.json', function(geojson) {
	         geojson.features.forEach(function(feature) {
	            if (feature.properties.SIG_CD === sigunguCode) {
	               var coordsArray = feature.geometry.coordinates;
	               let paths = [];
	               if (feature.geometry.type === 'Polygon') {
	                  coordsArray.forEach(ring => {
	                     const transformedRing = ring.map(coord => {
	                        const wgs84 = convertTMToWGS84(coord[0], coord[1]);
	                        return new kakao.maps.LatLng(wgs84[1], wgs84[0]);
	                     });
	                     paths.push(transformedRing);
	                  });
	               } else if (feature.geometry.type === 'MultiPolygon') {
	                  coordsArray.forEach(polygon => {
	                     polygon.forEach(ring => {
	                        const transformedRing = ring.map(coord => {
	                           const wgs84 = convertTMToWGS84(coord[0], coord[1]);
	                           return new kakao.maps.LatLng(wgs84[1], wgs84[0]);
	                        });
	                        paths.push(transformedRing);
	                     });
	                  });
	               }
	               paths.forEach(path => {
	                  var polygon = new kakao.maps.Polygon({
	                     path: path,
	                     strokeWeight: 2, strokeColor: 'red', strokeOpacity: 0.8,
	                     fillColor: 'rgb(155, 155, 155)', fillOpacity: 0.3
	                  });
	                  polygon.setMap(map);
	                  drawnPolygons.push(polygon);
	               });
	            }
	         });
	      });
	   }

	   // --- 전체 아파트 데이터 로드 및 표시 함수 ---
	   function loadAndDisplayAllCachedApartments() {
	      console.log("실행됨")
	      const loadingMsg = $('#loadingMessage');
	      if (loadingMsg.length > 0) {
	         loadingMsg.html(`<p style="text-align: center; padding: 50px 0; color: var(--gray-500);"><i class="fas fa-spinner fa-spin"></i> 전체 아파트 정보를 불러오는 중...</p>`);
	         loadingMsg.show();
	      }

	      $.ajax({
	         url: '/AllApartmentTradeInfo',
	         type: 'GET',
	         dataType: 'json',
	         success: function (data) {
	            if (loadingMsg.length > 0) loadingMsg.hide();

	            if (data && data.length > 0) {
	               console.log(`전체 아파트 `+data.length+`건 데이터 로드 완료 (캐시)`);
	               apartmentDataStore = {};
	               data.forEach((apt, idx) => {
	                  const uniqueAptId = apt.apartmentId || `store_all_`+apt.lat+`_`+apt.lng+`_`+idx;
	                  apartmentDataStore[uniqueAptId] = apt;
	               });
	               displayApartments(data); // 롤백된 displayApartments 함수 호출
	            } else {
	               console.log('조회된 전체 아파트 데이터가 없습니다.');
	               displayApartments([]);
	            }
	         },
	         error: function (xhr, status, error) {
	            if (loadingMsg.length > 0) loadingMsg.hide();
	            console.error('전체 아파트 정보 조회 API 오류:', error, xhr.responseText);
	            displayApartments([]);
	            alert('전체 아파트 정보를 불러오는 중 오류가 발생했습니다.');
	         }
	      });
	   }

	   // --- 비교 관련 함수 (기존 코드 유지) ---
	   function updateComparison(selectedPrice, selectedSize, selectedFloor, selectedBuildYear) {
	      const comparisonItems = document.querySelectorAll('.comparison-item');
	      if (comparisonItems.length === 0) return;
	      comparisonItems.forEach(item => {
	         try {
	            const priceElement = item.querySelector('.comparison-detail:nth-child(1) .detail-value');
	            if (priceElement) compareValues(priceElement, priceElement.textContent, selectedPrice, false);

	            const sizeElement = item.querySelector('.comparison-detail:nth-child(2) .detail-value');
	            if (sizeElement) compareValues(sizeElement, sizeElement.textContent, selectedSize, false);

	            const floorElement = item.querySelector('.comparison-detail:nth-child(3) .detail-value');
	            if (floorElement) compareValues(floorElement, floorElement.textContent, selectedFloor, false);

	            const yearElement = item.querySelector('.comparison-detail:nth-child(4) .detail-value');
	            if (yearElement) compareValues(yearElement, yearElement.textContent, selectedBuildYear, false);
	         } catch (error) {
	            console.error('비교 중 오류 발생:', error);
	         }
	      });
	   }
	   function compareValues(element, itemValue, selectedValue, isHigherWorse) {
	      const itemNum = extractNumber(itemValue);
	      const selectedNum = extractNumber(selectedValue);
	      if (itemNum === null || selectedNum === null) {
	         element.classList.remove('better-value', 'worse-value');
	         return;
	      }
	      if (itemNum === selectedNum) {
	         element.classList.remove('better-value', 'worse-value');
	      } else if ((itemNum < selectedNum && isHigherWorse) || (itemNum > selectedNum && !isHigherWorse)) {
	         element.classList.add('better-value');
	         element.classList.remove('worse-value');
	      } else {
	         element.classList.add('worse-value');
	         element.classList.remove('better-value');
	      }
	   }
	   function extractNumber(str) {
	      if (!str || typeof str !== 'string') return null;
	      const matches = str.match(/[\d,]+/);
	      if (!matches) return null;
	      return parseFloat(matches[0].replace(/,/g, ''));
	   }


	   // --- DOMContentLoaded ---
	   document.addEventListener('DOMContentLoaded', function () {
	      // 지도 초기화
	      const mapContainer = document.getElementById('map');
	      const mapOptions = {
	         center: new kakao.maps.LatLng(37.566826, 126.9786567), // 서울 시청
	         level: 5
	      };
	      map = new kakao.maps.Map(mapContainer, mapOptions);
	      clusterer = new kakao.maps.MarkerClusterer({
	         map: map, averageCenter: true, minLevel: 6, disableClickZoom: false
	      });
	      const zoomControl = new kakao.maps.ZoomControl();
	      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
	      kakao.maps.event.addListener(map, 'tilesloaded', () => {
	         document.getElementById('mapLoading').style.display = 'none';
	      });
	      geocoder = new kakao.maps.services.Geocoder();
	      /*kakao.maps.event.addListener(map, 'click', (mouseEvent) => { // 지도 클릭 시 열린 오버레이 닫기
	         if (currentOverlay) {
	            currentOverlay.setMap(null);
	            currentOverlay = null;
	         }
	         const latlng = mouseEvent.latLng;
	         getAddressInfo(latlng.getLat(), latlng.getLng());
	         // 시군구 따오는 코드 필요 - 폴리곤 그리기
	         // getApartmentData(sigunguCode);


	      });*/

	      // 아파트 카드 클릭 이벤트 위임 (비교 패널 업데이트 및 지도 연동)
		  const apartmentListContainer = document.getElementById('apartmentList');
		  if (apartmentListContainer) {
		     apartmentListContainer.addEventListener('click', function(event) {
		        const card = event.target.closest('.apartment-card:not(.comparison-item)');
		        if (card) {
		           const aptId = card.dataset.aptId;
		           const aptDetail = apartmentDataStore[aptId]; // 스토어에서 상세 정보 조회
		           const sggCd = card.dataset.sggCd;

		           // 1. 비교 패널 업데이트
		           const selectedApartmentDiv = document.getElementById('selectedApartment');
		           if (selectedApartmentDiv) {
		              let html = `<div class="selected-apt-header"><h3 class="selected-apt-name">`+card.dataset.name.split('(')[0]+`</h3><span class="selected-apt-label">선택됨</span></div>`;
		              html += `<div class="selected-apt-location">`+card.dataset.location+`</div>`;
		              if (card.dataset.subwayStation && card.dataset.subwayStation !== '정보 없음' && card.dataset.subwayStation !== '지하철역') {
		                 html += `<div class="selected-apt-subway">`+card.dataset.subwayStation+`에서 `+card.dataset.subwayDistance+`m</div>`;
		              } else {
		                 html += `<div class="selected-apt-subway">지하철역정보없음</div>`;
		              }
		              html += `<div class="selected-apt-details">
		                       <div class="selected-detail"><span class="detail-label">가격</span><span class="detail-value selected-price">`+card.dataset.price+`</span></div>
		                       <div class="selected-detail"><span class="detail-label">평수</span><span class="detail-value selected-size">`+card.dataset.size+`</span></div>
		                       <div class="selected-detail"><span class="detail-label">층수</span><span class="detail-value selected-floor">`+card.dataset.floor+`층</span></div>
		                       <div class="selected-detail"><span class="detail-label">건축년도</span><span class="detail-value selected-year">`+card.dataset.buildYear+`</span></div>
		                     </div>`;
		              selectedApartmentDiv.innerHTML = html;
		           }
		           updateComparison(card.dataset.price, card.dataset.size, card.dataset.floor, card.dataset.buildYear);

		           // 2. 지도 이동 및 오버레이 표시 - 개선된 포커스 기능
		           if (aptDetail && aptDetail.lat && aptDetail.lng) {
		              const position = new kakao.maps.LatLng(parseFloat(aptDetail.lat), parseFloat(aptDetail.lng));
		              
		              // 지도 중앙으로 부드럽게 이동 (애니메이션 효과 추가)
		              map.panTo(position);
		              
		              // 줌 레벨 조정 (더 가깝게 보이도록)
		              map.setLevel(2, { animate: true });
		              
		              // 기존 오버레이 제거 후 새 오버레이 표시
		              if (currentOverlay) {
		                 currentOverlay.setMap(null);
		              }
		              
		              // 마커 강조 표시 (필요시 활성화)
		              // markersForClusterer.forEach(marker => {
		              //    if (marker.aptId === aptId) {
		              //       marker.setZIndex(10); // 선택된 마커를 앞으로
		              //    } else {
		              //       marker.setZIndex(1);
		              //    }
		              // });
		              
		              // 오버레이 생성 및 표시
		              const content = createOverlayContentForApt(aptDetail);
		              currentOverlay = new kakao.maps.CustomOverlay({
		                 content: content, 
		                 map: map, 
		                 position: position, 
		                 yAnchor: 1, 
		                 zIndex: 10
		              });
		              
		              // 500ms 후 다시 한번 중앙 정렬 (애니메이션 완료 후 정확한 위치 보장)
		              setTimeout(() => {
		                 map.setCenter(position);
		              }, 500);
		           } else {
		              console.warn("카드 클릭: aptDetail을 찾지 못했거나 위치 정보가 없습니다.", aptId, aptDetail);
		           }
		           
		           // 시군구 코드가 있으면 해당 지역 폴리곤 표시
		           if (sggCd) {
		              getApartmentData(sggCd);
		           } else {
		              console.log("아파트 카드 시군구 코드 에러");
		           }
		        }
		     });
		  }

	      // 오버레이 닫기 버튼 이벤트 위임
	      document.addEventListener('click', function(event) {
	         if (event.target.classList.contains('overlay-close-btn')) {
	            if (currentOverlay) {
	               currentOverlay.setMap(null);
	               currentOverlay = null;
	            }
	         }
	      });


	      // 초기 지하철역 검색 로직 (기존 코드 유지, getApartmentData 호출)
	      const searchParams = {
	         region: "<c:out value='${searchParams.majorRegion}' default='' />",
	         district: "<c:out value='${searchParams.district}' default='' />",
	         station: "<c:out value='${searchParams.station}' default='' />"
	      };
	      const stationName = searchParams.station;

	      if (stationName) {
	         const ps = new kakao.maps.services.Places();
	         ps.keywordSearch(stationName, function (data, status) {
	            if (status === kakao.maps.services.Status.OK) {
	               let stationPlace = data.find(p => p.category_name.includes('지하철역')) || data[0];
	               if (stationPlace) {
	                  const stationPosition = new kakao.maps.LatLng(stationPlace.y, stationPlace.x);
	                  map.setCenter(stationPosition);
	                  geocoder.coord2RegionCode(stationPlace.x, stationPlace.y, function(result, geostatus) {
	                     if (geostatus === kakao.maps.services.Status.OK) {
	                        const region = result.find(item => item.region_type === 'H');
	                        if (region) {
	                           const sigunguCode = region.code.substring(0, 5);
	                           console.log('시군구 코드:', sigunguCode);
	                           getApartmentData(sigunguCode);
	                           // getApartmentData(region.code.substring(0, 5));

	                        }
	                     }
	                  });
	                  // 지하철역 커스텀 마커 및 정보 오버레이 (기존 코드 유지)
	                  new kakao.maps.CustomOverlay({ position: stationPosition, content: '<div style="padding:15px;background-color:#51bdbd;color:white;border-radius:50%;font-size:24px;font-weight:bold;box-shadow:0 2px 6px rgba(0,0,0,0.3);display:flex;align-items:center;justify-content:center;width:60px;height:60px;transform:translate(-50%, -50%);"><i class="fas fa-subway"></i></div>', map: map, zIndex: 3 });
	                  new kakao.maps.CustomOverlay({ position: stationPosition, content: '<div class="custom-overlay" style="position:relative;bottom:95px;border-radius:6px;background:#fff;padding:10px;box-shadow:0 2px 6px rgba(0,0,0,0.3);transform:translateX(-50%);white-space:nowrap;"><div class="title" style="display:block;font-size:14px;font-weight:600;color:#51bdbd;text-align:center;">' + stationName + '</div><div style="content:\'\';position:absolute;bottom:-8px;left:50%;margin-left:-8px;width:0;height:0;border-width:8px 8px 0 8px;border-style:solid;border-color:#fff transparent transparent transparent;"></div></div>', map: map, yAnchor: 0.5 });

	               } else {
	                  console.warn("지하철역 정보를 찾지 못했습니다:", stationName);
	                  loadAndDisplayAllCachedApartments(); // 지하철역 정보 없으면 전체 데이터 로드
	               }
	            } else {
	               console.warn("장소 검색 실패:", status);
	               loadAndDisplayAllCachedApartments(); // 장소 검색 실패 시 전체 데이터 로드
	            }
	         });
	      } else {
	         // 지하철역 파라미터가 없으면 전체 데이터 로드
	         loadAndDisplayAllCachedApartments();
	      }

	      // 관심등록 AJAX (기존 코드 유지)
	      // $(document).on('click', '.overlay-button.favorite', function () {
	      //    const lat = $(this).data('lat');
	      //    const lng = $(this).data('lng');
	      //    const dealAmount = $(this).data('dealamount');
	      //    const aptId = $(this).data('apt-id');
	      //    if (!lat || !lng) { alert('위도 또는 경도 정보가 없습니다.'); return; }
	      //    $.ajax({
	      //       url: '/favorite/insert', type: 'POST', contentType: 'application/json',
	      //       data: JSON.stringify({ lat: lat, lng: lng, dealAmount: dealAmount, apartmentId: aptId }),
	      //       xhrFields: { withCredentials: true },
	      //       success: function () { alert('관심목록에 등록되었습니다.'); location.reload(); }, // UX 개선을 위해 reload 대신 부분 업데이트 고려
	      //       error: function () { alert('관심등록 실패!'); }
	      //    });
	      // });
	//관심등록/제거 ajax
	$(document).on("click", ".overlay-button.favorite", function () {
	  const $btn = $(this)
	  const apartmentId = $btn.data("apartment-id")
	  const isFavorite = $btn.data("favorite") === true || $btn.data("favorite") === "true"
	  const favoriteId = $btn.data("favorite-id")

	  $btn.prop("disabled", true)

	  if (isFavorite) {
	    // 관심 해제
	    $.ajax({
	      url: "/apartment_favorite_remove",
	      type: "POST",
	      data: { favoriteId: favoriteId },
	      success: () => {
	        alert("관심 목록에서 삭제되었습니다.")

	        // 버튼 상태 업데이트
	        $btn.data("favorite", false)
	        $btn.data("favorite-id", "")
	        $btn.html('<i class="fas fa-heart"></i> 관심 등록')
	        $btn.attr("style", "width: 100%; background-color: #3498db;")

	        // 관심목록 비교창에서 해당 아이템 바로 제거
	        console.log("삭제할 apartmentId:", apartmentId)

	        // 여러 방법으로 요소 찾기 시도
	        let $targetItem = $('#interestComparisonList .comparison-item[data-apt-id="' + apartmentId + '"]')

	        if ($targetItem.length === 0) {
	          // favoriteId로 찾기
	          $targetItem = $('#interestComparisonList .comparison-heart[data-favorite-id="' + favoriteId + '"]').closest(
	            ".comparison-item",
	          )
	        }

	        console.log("찾은 요소 개수:", $targetItem.length)

	        if ($targetItem.length > 0) {
	          $targetItem.remove()
	          console.log("요소 삭제 완료")
	        }

	        // 빈 목록 체크 및 메세지 표시
	        if ($("#interestComparisonList .comparison-item").length === 0) {
	          $("#interestComparisonList").html(
	            '<p class="no-interest-message"><i class="fas fa-heart"></i> 관심 등록된 아파트가 없습니다.</p>',
	          )
	        }

	        $btn.prop("disabled", false)
	      },
	      error: () => {
	        alert("관심 해제 실패")
	        $btn.prop("disabled", false)
	      },
	    })
	  } else {
	    // 관심 등록
	    $.ajax({
	      url: "/favorite/insert",
	      type: "POST",
	      contentType: "application/json",
	      data: JSON.stringify({ apartmentId: apartmentId }),
	      success: (res) => {
	        if (res.success) {
	          alert("관심 목록에 등록되었습니다.")

	          // 버튼 상태 변경
	          $btn.data("favorite", true)
	          $btn.data("favorite-id", res.favoriteId)
	          $btn.html('<i class="fas fa-heart-broken"></i> 관심 해제')
	          $btn.attr("style", "width: 100%; background-color: #e74c3c;")

	          // 현재 아파트 정보 가져오기
	          // console.log("apartmentDataStore 확인:", typeof apartmentDataStore)
	          //console.log("찾는 apartmentId:", apartmentId)

	          let currentApt = null

	          // apartmentDataStore에서 찾기
	          if (typeof apartmentDataStore === "object" && apartmentDataStore !== null) {
	            for (const key in apartmentDataStore) {
	              if (apartmentDataStore[key].apartmentId == apartmentId) {
	                currentApt = apartmentDataStore[key]
	                break
	              }
	            }
	          }

	          console.log("찾은 currentApt:", currentApt)

	          if (currentApt) {
	            // 혹시나 모르니까 사용자 친화적으로 처리했음
	            const aptName = currentApt.aptNm ? currentApt.aptNm.split("(")[0] : "이름 없음"
	            const dealAmount = currentApt.dealAmount || "정보없음"
	            const excluUseAr = currentApt.excluUseAr || "정보없음"
	            const floor = currentApt.floor || "정보없음"
	            const buildYear = currentApt.buildYear || "정보없음"
	            const estateAgentSggNm = currentApt.estateAgentSggNm || "위치 정보 없음"

	            let subwayInfo = "지하철역정보없음"
	            if (currentApt.subwayStation && currentApt.subwayDistance) {
	              subwayInfo = currentApt.subwayStation.split(" ")[0] + "에서 " + currentApt.subwayDistance + "m"
	            }

	            // 메세지 제거
	            $("#interestComparisonList .no-interest-message").remove()

	            // 등록을 하면새로운 comparison-item HTML 생성
	            const newComparisonItem =
	              '<div class="comparison-item" data-apt-id="' + apartmentId + '">' + 
				  	'<div class="comparison-heart" data-favorite-id="' + res.favoriteId + '">' +
	              		'<i class="fas fa-heart"></i>' +
	              		'<i class="fas fa-heart-broken"></i>' +
					"</div>" +
	              '<div class="comparison-apt-info">' +
	              		'<h3 class="comparison-apt-name">' + aptName + "</h3>" +
	              		'<div class="comparison-apt-location">' + estateAgentSggNm +
						"</div>" +
	              		'<div class="comparison-apt-subway">' + subwayInfo +
						"</div>" +
	              "</div>" +
	              '<div class="comparison-details">' +
	             		'<div class="comparison-detail">' +
	              		'<span class="detail-label">가격</span>' +
	              		'<span class="detail-value">' + dealAmount + "만원</span>" +
	              "</div>" +
	              '<div class="comparison-detail">' +
	              		'<span class="detail-label">평수</span>' +
	             		 '<span class="detail-value">' +  excluUseAr + "㎡</span>" +
	              "</div>" +
	              '<div class="comparison-detail">' +
	              		'<span class="detail-label">층수</span>' +
	              		'<span class="detail-value">' + floor + "층</span>" +
	              "</div>" +
	              '<div class="comparison-detail">' +
	              		'<span class="detail-label">건축년도</span>' +
	              		'<span class="detail-value">' +  buildYear + "년</span>" +
	              "</div>" +
	              "</div>" +
	              "</div>"

	            // 관심목록 비교창에 바로 넣기
	            $("#interestComparisonList").append(newComparisonItem)
	            // console.log("추가 완료")
	          } else {
	            // console.error("currentApt없음 apartmentId:", apartmentId)
	            // console.log("apartmentDataStore 내용:", apartmentDataStore)
	          }
	        } else {
	          alert(res.message || "관심 등록 실패")
	        }
	        $btn.prop("disabled", false)
	      },
	      error: () => {
	        alert("관심 등록 실패")
	        $btn.prop("disabled", false)
	      },
	    })
	  }
	})

		  
	      // 관심목록 삭제 AJAX (기존 코드 유지)
	      $('#interestComparisonList').on("click", ".comparison-heart", function (e) {
	         e.stopPropagation();
	         const favoriteId = $(this).data("favorite-id");
	         if (confirm("정말로 이 아파트를 관심 목록에서 삭제하시겠습니까?")) {
	            $.ajax({
	               type: "post", data: { favoriteId: favoriteId }, url: "apartment_favorite_remove",
	               success: () => {
	                  alert("관심 목록에서 삭제되었습니다.");
	                  $(this).closest('.comparison-item').remove();
	                  if ($('#interestComparisonList .comparison-item').length === 0) {
	                     $('#interestComparisonList').html('<p class="no-interest-message"><i class="fas fa-heart"></i> 관심 등록된 아파트가 없습니다.</p>');
	                  }
	               },
	               error: () => { alert("서버 오류가 발생했습니다."); }
	            });
	         }
	      });

	      // subway_section.js의 함수들을 호출하기 위한 초기화 (필요한 경우)
	      // 예: initializeSubwaySection();

	      loadAndDisplayAllCachedApartments();
	   });

	   function getAddressInfo(lat, lng) {
	      if (!geocoder) { // Add a check to ensure geocoder is initialized
	         console.error("Geocoder not initialized yet.");
	         return;
	      }
	      geocoder.coord2RegionCode(lng, lat, function(result, status) {
	         if (status === kakao.maps.services.Status.OK) {
	            const region = result.find(item => item.region_type === 'H');
	            if (region) {
	               const sigunguCode = region.code.substring(0, 5);
	               console.log('시군구 코드:', sigunguCode);
	               getApartmentData(sigunguCode);
	            } else {
	               console.warn('행정동 정보를 찾을 수 없습니다.');
	            }
	         } else {
	            console.error('주소 변환 실패:', status);
	         }
	      });
	   }
	</script>
</body>
</html>
