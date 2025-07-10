<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>개인정보처리방침 - 메트로하우스</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #51bdbd;
            --primary-dark: #3e9a9a;
            --primary-light: #a0dbdb;
            --primary-lighter: #e0f5f5;
            --secondary: #334155;
            --accent: #10b981;
            --accent2: #f97316;
            --accent3: #06b6d4;
            --accent4: #8b5cf6;
            --success: #22c55e;
            --danger: #ef4444;
            --warning: #f59e0b;
            --info: #0ea5e9;
            --light: #f8fafc;
            --dark: #1e293b;
            --gray-50: #f9fafb;
            --gray-100: #f1f5f9;
            --gray-200: #e2e8f0;
            --gray-300: #cbd5e1;
            --gray-400: #94a3b8;
            --gray-500: #64748b;
            --border-radius: 16px;
            --border-radius-sm: 8px;
            --box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.025);
            --box-shadow-hover: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --primary-gradient: linear-gradient(135deg, #51bdbd 0%, #3e9a9a 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: var(--gray-50);
            color: var(--dark);
            line-height: 1.6;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto 80px;
            padding: 0 24px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            position: relative;
            padding-bottom: 20px;
        }

        .page-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: var(--primary-gradient);
            border-radius: 2px;
        }

        .page-title {
            font-size: 32px;
            font-weight: 800;
            color: var(--dark);
            margin-bottom: 16px;
            letter-spacing: -0.5px;
        }

        .page-subtitle {
            color: var(--gray-500);
            font-size: 17px;
            max-width: 700px;
            margin: 0 auto;
        }

        .privacy-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 40px;
            margin-bottom: 30px;
            border: 1px solid var(--gray-100);
            transition: var(--transition);
        }

        .privacy-card:hover {
            box-shadow: var(--box-shadow-hover);
            transform: translateY(-5px);
        }

        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--gray-200);
            position: relative;
            display: flex;
            align-items: center;
        }

        .section-title i {
            color: var(--primary);
            margin-right: 12px;
            font-size: 20px;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 60px;
            height: 2px;
            background-color: var(--primary);
        }

        .privacy-content {
            font-size: 16px;
            color: var(--secondary);
            margin-bottom: 30px;
        }

        .privacy-content p {
            margin-bottom: 16px;
            line-height: 1.8;
        }

        .privacy-content strong {
            color: var(--dark);
            font-weight: 600;
        }

        .privacy-content ul, .privacy-content ol {
            margin: 16px 0;
            padding-left: 24px;
        }

        .privacy-content li {
            margin-bottom: 10px;
        }

        .privacy-content table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            border-radius: var(--border-radius-sm);
            overflow: hidden;
            box-shadow: 0 0 0 1px var(--gray-200);
        }

        .privacy-content th {
            background-color: var(--primary-lighter);
            color: var(--primary-dark);
            font-weight: 600;
            text-align: left;
            padding: 14px 16px;
        }

        .privacy-content td {
            padding: 14px 16px;
            border-top: 1px solid var(--gray-200);
        }

        .privacy-content tr:nth-child(even) {
            background-color: var(--gray-50);
        }

        .privacy-content tr:hover {
            background-color: var(--primary-lighter);
        }

        .privacy-content a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }

        .privacy-content a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        .privacy-footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid var(--gray-200);
            color: var(--gray-500);
            font-size: 14px;
        }

        .privacy-footer p {
            margin-bottom: 10px;
        }

        .privacy-nav {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 20px;
            margin-bottom: 30px;
            position: sticky;
            top: 20px;
            border: 1px solid var(--gray-100);
            z-index: 10;
        }

        .privacy-nav-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
        }

        .privacy-nav-title i {
            color: var(--primary);
            margin-right: 10px;
        }

        .privacy-nav-list {
            list-style: none;
        }

        .privacy-nav-item {
            margin-bottom: 10px;
        }

        .privacy-nav-link {
            display: flex;
            align-items: center;
            color: var(--secondary);
            text-decoration: none;
            padding: 8px 12px;
            border-radius: var(--border-radius-sm);
            transition: var(--transition);
            font-size: 15px;
        }

        .privacy-nav-link:hover {
            background-color: var(--primary-lighter);
            color: var(--primary);
        }

        .privacy-nav-link i {
            margin-right: 8px;
            font-size: 12px;
            color: var(--primary);
        }

        .privacy-nav-link.active {
            background-color: var(--primary-lighter);
            color: var(--primary);
            font-weight: 600;
        }

        .privacy-layout {
            display: grid;
            grid-template-columns: 280px 1fr;
            gap: 30px;
            align-items: start;
        }

        .last-updated {
            display: inline-block;
            background-color: var(--primary-lighter);
            color: var(--primary-dark);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            margin-top: 10px;
        }

        .last-updated i {
            margin-right: 6px;
        }

        .btn-print {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 20px;
            background-color: var(--gray-100);
            color: var(--gray-500);
            border: none;
            border-radius: var(--border-radius-sm);
            font-size: 15px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 20px;
        }

        .btn-print i {
            margin-right: 8px;
        }

        .btn-print:hover {
            background-color: var(--gray-200);
            color: var(--dark);
        }

        .highlight-box {
            background-color: var(--primary-lighter);
            border-left: 4px solid var(--primary);
            padding: 20px;
            border-radius: 0 var(--border-radius-sm) var(--border-radius-sm) 0;
            margin: 20px 0;
        }

        .highlight-box p {
            margin: 0;
            color: var(--primary-dark);
        }

        @media (max-width: 992px) {
            .privacy-layout {
                grid-template-columns: 1fr;
            }

            .privacy-nav {
                position: relative;
                top: 0;
                margin-bottom: 30px;
            }
        }

        @media (max-width: 768px) {
            .container {
                padding: 0 16px;
                margin: 20px auto 60px;
            }

            .page-title {
                font-size: 28px;
            }

            .privacy-card {
                padding: 30px 20px;
            }

            .section-title {
                font-size: 20px;
            }
        }

        @media (max-width: 576px) {
            .page-title {
                font-size: 24px;
            }

            .privacy-content table {
                display: block;
                overflow-x: auto;
            }
        }

        /* 애니메이션 */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .privacy-card {
            animation: fadeIn 0.5s ease-out;
            animation-fill-mode: both;
        }

        .privacy-card:nth-child(1) { animation-delay: 0.1s; }
        .privacy-card:nth-child(2) { animation-delay: 0.2s; }
        .privacy-card:nth-child(3) { animation-delay: 0.3s; }
        .privacy-card:nth-child(4) { animation-delay: 0.4s; }
        .privacy-card:nth-child(5) { animation-delay: 0.5s; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">개인정보처리방침</h1>
            <p class="page-subtitle">메트로하우스는 이용자의 개인정보를 소중히 여기며, 관련 법령을 준수하고 있습니다.</p>
            <div class="last-updated">
                <i class="fas fa-clock"></i> 최종 업데이트: 202년 4월 30일
            </div>
        </div>

        <div class="privacy-layout">
            <div class="privacy-nav">
                <h3 class="privacy-nav-title"><i class="fas fa-list"></i> 목차</h3>
                <ul class="privacy-nav-list">
                    <li class="privacy-nav-item">
                        <a href="#section1" class="privacy-nav-link active">
                            <i class="fas fa-chevron-right"></i> 개인정보의 수집 및 이용 목적
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section2" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 수집하는 개인정보 항목
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section3" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 개인정보의 보유 및 이용기간
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section4" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 개인정보의 파기절차 및 방법
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section5" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 이용자 및 법정대리인의 권리와 행사방법
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section6" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 개인정보 자동 수집 장치의 설치/운영
                        </a>
                    </li>
                    <li class="privacy-nav-item">
                        <a href="#section7" class="privacy-nav-link">
                            <i class="fas fa-chevron-right"></i> 개인정보 보호책임자
                        </a>
                    </li>
                </ul>
                <button class="btn-print" onclick="window.print()">
                    <i class="fas fa-print"></i> 인쇄하기
                </button>
            </div>

            <div class="privacy-main">
                <div id="section1" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-bullseye"></i> 개인정보의 수집 및 이용 목적</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</p>
                        
                        <ul>
                            <li><strong>회원 가입 및 관리</strong>: 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지 등을 목적으로 개인정보를 처리합니다.</li>
                            <li><strong>서비스 제공</strong>: 아파트 정보 제공, 관심 매물 관리, 맞춤 서비스 제공, 콘텐츠 제공 등을 목적으로 개인정보를 처리합니다.</li>
                            <li><strong>마케팅 및 광고에의 활용</strong>: 신규 서비스 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 서비스의 유효성 확인, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다.</li>
                        </ul>

                        <div class="highlight-box">
                            <p>메트로하우스는 이용자의 개인정보를 수집할 때 반드시 사전에 이용자에게 해당 사실을 알리고 동의를 구하고 있습니다.</p>
                        </div>
                    </div>
                </div>

                <div id="section2" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-clipboard-list"></i> 수집하는 개인정보 항목</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 회원가입, 상담, 서비스 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.</p>

                        <table>
                            <thead>
                                <tr>
                                    <th>구분</th>
                                    <th>수집항목</th>
                                    <th>수집목적</th>
                                    <th>보유기간</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>필수항목</td>
                                    <td>이름, 아이디, 비밀번호, 이메일, 휴대폰번호</td>
                                    <td>회원식별 및 서비스 이용</td>
                                    <td>회원탈퇴 시까지</td>
                                </tr>
                                <tr>
                                    <td>선택항목</td>
                                    <td>주소, 관심지역, 프로필 이미지</td>
                                    <td>맞춤형 서비스 제공</td>
                                    <td>회원탈퇴 시까지</td>
                                </tr>
                                <tr>
                                    <td>자동수집</td>
                                    <td>IP주소, 쿠키, 방문 일시, 서비스 이용 기록</td>
                                    <td>서비스 이용 통계, 부정이용 방지</td>
                                    <td>3개월</td>
                                </tr>
                            </tbody>
                        </table>

                        <p>서비스 이용 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.</p>
                        <ul>
                            <li>IP Address, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록</li>
                            <li>모바일 서비스 이용 시 단말기 정보(모델명, OS 버전)</li>
                        </ul>
                    </div>
                </div>

                <div id="section3" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-clock"></i> 개인정보의 보유 및 이용기간</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.</p>

                        <p>각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.</p>
                        <ul>
                            <li><strong>회원 가입 및 관리</strong>: 회원탈퇴 시까지</li>
                            <li><strong>관심 매물 정보</strong>: 회원탈퇴 시 또는 관심 매물 삭제 시까지</li>
                            <li><strong>부정이용 기록</strong>: 부정이용 발생 시점으로부터 1년</li>
                        </ul>

                        <p>다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지 보관합니다.</p>
                        <ul>
                            <li>관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지</li>
                            <li>서비스 이용에 따른 채권·채무관계 잔존 시에는 해당 채권·채무관계 정산 시까지</li>
                        </ul>
                    </div>
                </div>

                <div id="section4" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-trash-alt"></i> 개인정보의 파기절차 및 방법</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.</p>

                        <p><strong>파기절차</strong></p>
                        <p>이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</p>

                        <p><strong>파기기한</strong></p>
                        <p>이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.</p>

                        <p><strong>파기방법</strong></p>
                        <p>전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기하며, 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.</p>
                    </div>
                </div>

                <div id="section5" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-user-shield"></i> 이용자 및 법정대리인의 권리와 행사방법</h2>
                    <div class="privacy-content">
                        <p>이용자 및 법정 대리인은 언제든지 등록되어 있는 자신 혹은 당해 만 14세 미만 아동의 개인정보를 조회하거나 수정할 수 있으며, 회원탈퇴를 통해 개인정보 처리의 정지를 요청할 수 있습니다.</p>

                        <p>이용자 및 법정 대리인의 권리 행사는 메트로하우스에 대해 서면, 전화, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 메트로하우스는 이에 대해 지체 없이 조치하겠습니다.</p>

                        <p>이용자가 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 또한 잘못된 개인정보를 제3자에게 이미 제공한 경우에는 정정 처리결과를 제3자에게 지체 없이 통지하여 정정이 이루어지도록 하겠습니다.</p>

                        <p>메트로하우스는 이용자 혹은 법정 대리인의 요청에 의해 해지 또는 삭제된 개인정보는 "개인정보의 보유 및 이용기간"에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.</p>
                    </div>
                </div>

                <div id="section6" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-cookie"></i> 개인정보 자동 수집 장치의 설치/운영</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 '쿠키(cookie)'를 사용합니다.</p>

                        <p><strong>쿠키의 사용 목적</strong></p>
                        <p>이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.</p>

                        <p><strong>쿠키의 설치/운영 및 거부</strong></p>
                        <p>이용자는 쿠키 설치에 대한 선택권을 가지고 있습니다. 따라서, 이용자는 웹브라우저에서 옵션을 설정함으로써 모든 쿠키를 허용하거나, 쿠키가 저장될 때마다 확인을 거치거나, 아니면 모든 쿠키의 저장을 거부할 수도 있습니다.</p>

                        <p><strong>쿠키 설정 거부 방법</strong></p>
                        <p>쿠키 설정을 거부하는 방법으로는 이용자가 사용하는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다.</p>
                        
                        <ul>
                            <li>Chrome: 설정 > 개인정보 및 보안 > 쿠키 및 기타 사이트 데이터</li>
                            <li>Internet Explorer: 도구 > 인터넷 옵션 > 개인정보 탭</li>
                            <li>Firefox: 환경설정 > 개인정보 및 보안 > 쿠키 및 사이트 데이터</li>
                            <li>Safari: 환경설정 > 개인정보 보호</li>
                        </ul>
                        
                        <p>단, 쿠키 설치를 거부할 경우 서비스 이용에 어려움이 있을 수 있습니다.</p>
                    </div>
                </div>

                <div id="section7" class="privacy-card">
                    <h2 class="section-title"><i class="fas fa-shield-alt"></i> 개인정보 보호책임자</h2>
                    <div class="privacy-content">
                        <p>메트로하우스는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</p>

                        <table>
                            <tr>
                                <th>구분</th>
                                <th>개인정보 보호책임자</th>
                                <th>개인정보 보호 담당부서</th>
                            </tr>
                            <tr>
                                <td>이름</td>
                                <td>홍길동</td>
                                <td rowspan="3">개인정보보호팀</td>
                            </tr>
                            <tr>
                                <td>직위</td>
                                <td>개인정보보호팀장</td>
                            </tr>
                            <tr>
                                <td>연락처</td>
                                <td>이메일뭘로 하징 ㅋㅋ<br>전화번호 뭘로하징 ㅋㅋ</td>
                            </tr>
                        </table>

                        <p>이용자는 메트로하우스의 서비스를 이용하면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 메트로하우스는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.</p>
                    </div>
                </div>

                <div class="privacy-footer">
                    <p>본 개인정보처리방침은 2025년 4월 30일부터 적용됩니다.</p>
                    <p>이전의 개인정보처리방침은 아래에서 확인하실 수 있습니다.</p>
<!--                    <p><a href="#">2022년 12월 31일 이전 적용</a> | <a href="#">2022년 6월 30일 이전 적용</a></p>-->
                </div>
            </div>
        </div>
    </div>

    <script>
        // 스크롤 시 메뉴 활성화 효과
        window.addEventListener('scroll', function() {
            const sections = document.querySelectorAll('.privacy-card');
            const navLinks = document.querySelectorAll('.privacy-nav-link');
            
            let currentSection = '';
            
            sections.forEach(section => {
                const sectionTop = section.offsetTop - 100;
                const sectionHeight = section.clientHeight;
                if(pageYOffset >= sectionTop && pageYOffset < sectionTop + sectionHeight) {
                    currentSection = section.getAttribute('id');
                }
            });

            navLinks.forEach(link => {
                link.classList.remove('active');
                if(link.getAttribute('href').substring(1) === currentSection) {
                    link.classList.add('active');
                }
            });
        });

        // 부드러운 스크롤 효과
        document.querySelectorAll('.privacy-nav-link').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: 'smooth'
                });
                
                // 활성화 클래스 추가
                document.querySelectorAll('.privacy-nav-link').forEach(link => {
                    link.classList.remove('active');
                });
                this.classList.add('active');
            });
        });
    </script>
</body>
</html>