<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="/resources/getSatelliteImages.css">
<title>우리 날씨 - 위성 이미지</title>
<script>
	function autoSubmit() {
    	// 페이지 로드 시 자동으로 한 번만 폼을 제출
    	if(!window.location.hash) {
       		window.location = window.location + '#loaded';
        	document.forms['satelliteImageForm'].submit();
    	}
	}
	// 'change' 이벤트 리스너를 추가하여 선택 변경 시 함수를 호출합니다.
	function submitForm() {
		// 여기서 'categoryForm'은 form의 id입니다.
		document.getElementById("categoryForm").submit();
	}

    function startAutoSubmit() {
		let hour = 0;
		let minute = 0;
		const interval = 1000; // 시간 업데이트 간격을 조정하려면 이 값을 변경하세요. 실제로는 600000 (10분)이 적절합니다.

		const intervalId = setInterval(() => {
			// 시간 문자열 생성
			let timeValue = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;

			// 폼의 hidden input 값을 업데이트
			document.getElementById('timeValue').value = timeValue;
                
			// 폼 제출
			// document.getElementById('timeForm').submit();

			console.log("제출 시간: " + timeValue); // 실제 제출 대신 콘솔에 로그 출력

			// 10분 증가
			minute += 10;
			if (minute >= 60) {
				minute = 0;
				hour++;
			}
                
			// 24시간이 지나면 중지
			if (hour >= 24) {
				clearInterval(intervalId);
			}
		}, interval);
	}
</script>
</head>
<body onload="autoSubmit();">
	<!-- 오늘 날짜와 어제 날짜 구하기 -->
	<%
	// 오늘 날짜와 어제 날짜를 구합니다.
	LocalDate today = LocalDate.now();
	LocalDate yesterday = today.minusDays(1);

	// 날짜 형식을 지정합니다. 예: 2023-03-28
	String formatToday = today.toString();
	String formatYesterday = yesterday.toString();
	%>
	<div class="navbar">
		<div>
			<a href="index.html"><img src="images/logo.png" id="Logo"
				alt="왼쪽 이미지"></a>
		</div>
		<div>
			<h1>우리 날씨</h1>
		</div>
		<div class="login-container">
			<div>
				<a href="/WEB-INF/views/user/signin"><button
						class="login-button">로그인</button></a>
			</div>
			<div>
				<a href="#" class="LoginOption">아이디 찾기</a> <a href="#"
					class="LoginOption">비밀번호 찾기</a> <a href="/user/signup"
					class="LoginOption">회원가입</a>
			</div>
		</div>
	</div>

	<div id="box">
		<div id="top">
			<div id="mid_content">
				<span><a href="index.html" class="Menu">지역 날씨</a></span> <span><a
					href="#" class="Menu">세계 날씨</a></span> <span><a href="#"
					class="Menu">미세먼지</a></span> <span><a href="/get" class="Menu">위성
						영상</a></span> <span><a href="#" class="Menu_except">날씨 앱</a></span>
			</div>

			<div id="main">
				<div id="main_title">
					<h2>위성 영상</h2>
				</div>
				<hr>
				<div>
					<form action="/satellite/getSatelliteImages" method="post" name="satelliteImageForm">
    					<!-- 날짜 선택: 기본값으로 오늘 날짜 설정 -->
    					<input type="hidden" name="date" value="<%=formatToday%>">
    					
    					<!-- 현재 시간을 10분 단위로 내려서 HHMM 형식으로 변환
    					
    					LocalTime now = LocalTime.now();
    					int minuteRoundedDown = (now.getMinute() / 10) * 10; // 분을 10분 단위로 내림
    					LocalTime roundedTime = now.withMinute(minuteRoundedDown).withSecond(0).withNano(0); // 초와 나노초를 0으로 설정
    
    					DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm"); // "HHmm" 형식으로 포맷
    					String formattedTime = roundedTime.format(timeFormatter); // 현재 시간을 "HHmm" 형식의 문자열로 변환
    					%>
    					시간 선택: 기본값으로 현재시간 10분 내림 설정
    					<input type="hidden" name="time" value="=formattedTime">
    					
    					<!-- 미디어 타입 선택: 기본값으로 ir105 설정-->
    					<input type="hidden" name="mediaType" value="ir105">
					</form>
					
					<form action="/satellite/getSatelliteImages" method="post">
						<select name="date" placeholder="날짜 선택">
							<option value="<%=formatYesterday%>">어제 (<%=formatYesterday%>)
							</option>
							<option value="<%=formatToday%>" selected>오늘 (<%=formatToday%>)
							</option>
						</select>
						<select name="time" placeholder="시간 선택">
							<%
							for (int hour = 0; hour < 24; hour++) {
								for (int minute = 0; minute < 60; minute += 10) {
									String timeValue = String.format("%02d:%02d", hour, minute);
							%>
							<option value="<%=timeValue%>"><%=timeValue%></option>
							<%
							}
							}
							%>
						</select>
						<select name="mediaType" placeholder="영상 구분">
							<option value="ir105">적외영상</option>
							<option value="vi006">가시영상</option>
							<option value="wv069">수증기영상</option>
							<option value="sw038">단파적외영상</option>
							<option value="rgbt">RGB(컬러)영상</option>
							<option value="rgbdn">RGB(주야간합성)영상</option>
						</select> <input type="submit" value="submit">
					</form>
				</div>
				<div>
					<div>
						<%
						// 폼 제출로부터 날짜 값을 받습니다.
						String selectedDate = request.getParameter("date");
						String selectedTime = request.getParameter("time");

						// 선택된 날짜가 있으면, 어떤 처리를 수행합니다.
						if (selectedDate != null && selectedTime != null) {
						%>

						<%=selectedDate%>/<%=selectedTime%>

						<%
						}
						%>
					</div>
					<div>
						<form action="" method="post">
							<input type="hidden" name="date" value="<%=yesterday%>" />
							<button class="">어제</button>
						</form>
						<form action="" method="post">
							<input type="hidden" name="date" value="<%=today%>" />
							<button class="">오늘</button>
						</form>
						<%
						// 클라이언트로부터 전달받은 'time' 파라미터 처리

						if (selectedTime == null) {
							selectedTime = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm"));
						}

						LocalTime selectedTimeString = LocalTime.parse(selectedTime, DateTimeFormatter.ofPattern("HH:mm"));

						// 10분 전과 10분 후 계산
						LocalTime tenMinutesBefore = selectedTimeString.minusMinutes(10);
						LocalTime tenMinutesAfter = selectedTimeString.plusMinutes(10);

						// 결과 출력
						out.println("선택된 시간 : " + selectedTime);
						%>

						<!-- 10분 전 버튼 -->
						<form action="" method="get">
							<input type="hidden" name="time" value="<%=tenMinutesBefore%>" />
							<button type="submit">10분 전</button>
						</form>

						<!-- 10분 후 버튼 -->
						<form action="" method="get">
							<input type="hidden" name="time" value="<%=tenMinutesAfter%>" />
							<button type="submit">10분 후</button>
						</form>

						<form id="timeForm" action="YourServerSideEndpoint" method="post">
							<input type="hidden" id="timeValue" name="time" />
							<button type="button" onclick="startAutoSubmit();">재생</button>
						</form>
						<div id="satelliteImages">
							<!-- 조건, 반복문 써서 위성 이미지 출력 -->
							임시 이미지!!!
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div id="bot">
		<pre>@Error404: Team Not Found Corp.</pre>
	</div>
</body>
</html>