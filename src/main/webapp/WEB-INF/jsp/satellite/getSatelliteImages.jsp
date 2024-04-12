<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.LocalTime"%>
<%@ page import="java.util.Optional"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="/static/css/getSatelliteImages.css"
	type="text/css">
<title>우리 날씨 - 위성 이미지</title>

</head>
<body>
	<!-- 날짜와 시간 구하기 -->
	<%
	// 오늘 날짜와 어제 날짜 구하기
	LocalDate today = LocalDate.now();
	LocalDate yesterday = today.minusDays(1);

	// 날짜 형식을 "yyyyMMdd"로 지정
	DateTimeFormatter formatterDate = DateTimeFormatter.ofPattern("yyyyMMdd");
	String formatToday = today.format(formatterDate);
	String formatYesterday = yesterday.format(formatterDate);

	// 현재 시간 구하기
	LocalTime now = LocalTime.now();

	// 10분전 10분후의 기준이 될 시간값 폼 제출로부터 받아오기
	String tenTime = request.getParameter("time");

	// 받아온 시간 값을 LocalTime으로 파싱
	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HHmm");

	// 받아온 시간 값 검증 및 파싱
	LocalTime time;
	if (tenTime != null && !tenTime.isEmpty()) {
		time = LocalTime.parse(tenTime, formatter);
	} else {
		// tenTime이 null 또는 빈 문자열인 경우 현재 시간 사용
		time = LocalTime.now();
	}

	// 10분 전과 10분 후 계산
	LocalTime tenMinutesBefore = time.minusMinutes(10);
	String formattedTenMinutesBefore = tenMinutesBefore.format(formatter);
	LocalTime tenMinutesAfter = time.plusMinutes(10);
	String formattedTenMinutesAfter = tenMinutesAfter.format(formatter);

	// 9시간 20분 전의 시간을 계산
	LocalTime nineHoursTenMinutesBefore = now.minusHours(9).minusMinutes(20);

	// 계산한 시간의 분을 10분 단위로 내림
	int minutes = nineHoursTenMinutesBefore.getMinute();
	int roundedDownMinutes = (minutes / 10) * 10;
	LocalTime roundedTime = nineHoursTenMinutesBefore.withMinute(roundedDownMinutes);

	// "HHMM" 형태로 변환
	DateTimeFormatter formatterTime = DateTimeFormatter.ofPattern("HHmm");
	String formatTime = roundedTime.format(formatterTime);

	// 폼 제출로부터 날짜 값을 받습니다.
	String selectedDate = request.getParameter("date");
	String selectedTime = request.getParameter("time");

	System.out.println("현재 선택된 날짜 : " + selectedDate);
	System.out.println("현재 선택된 시간 : " + selectedTime);

	// 영상종류 선언
	String infrared = "ir105";
	String visible = "vi006";
	String vapor = "wv069";
	String shortWave = "sw038";
	String rgbColor = "rgbt";
	String rgbDay = "rgbdn";

	// 선택된 미디어 타입 불러오기
	String selectedMediaType = request.getParameter("mediaType");
	%>

	<div class="navbar">
		<div>
			<a href="/weather/main/view"><img src="/static/image/logo.png" id="Logo"
				alt="왼쪽 이미지"></a>
		</div>
		<div>
			<h1>우리 날씨</h1>
		</div>
		<div class="login-container">
			<div>
				<a href=""><button class="login-button">로그인</button></a>
			</div>
			<div>
				<a href="/user/signin/view" class="LoginOption">아이디 찾기</a> <a href="/"
					class="LoginOption">비밀번호 찾기</a> <a href="/user/signup"
					class="LoginOption">회원가입</a>
			</div>
		</div>
	</div>

	<div id="box">
		<div id="top">
			<div id="mid_content">
				<span><a href="index.html" class="Menu">지역 날씨</a></span> <span><a
					href="/" class="Menu">세계 날씨</a></span> <span><a href="/"
					class="Menu">미세먼지</a></span> <span><a
					href="/satellite/getSatelliteImages" class="Menu">위성영상</a></span> <span><a
					href="/" class="Menu_except">날씨 앱</a></span>

			</div>

			<div id="main">
				<div id="main_title">
					<h2>위성 영상</h2>
				</div>
				<hr>
				<br>
				<div id="mainForm">
					<div id="selectForm">
						<form action="/satellite/getSatelliteImages" method="get"
							id="submitForm">
							<select class="selectbox" name="date" placeholder="날짜 선택">
								<option value="<%=formatYesterday%>">어제(<%=formatYesterday%>)
								</option>
								<option value="<%=formatToday%>" selected>오늘(<%=formatToday%>)
								</option>
							</select> <select class="selectbox" name="time" placeholder="시간 선택">
								<c:forEach begin="0" end="23" var="hour">
									<c:forEach begin="0" end="5" var="index">
										<c:set var="minute" value="${index * 10}" />
										<option
											value="${hour < 10 ? '0' : ''}${hour}${minute < 10 ? '0' : ''}${minute}">
											${hour < 10 ? '0' : ''}${hour}:${minute < 10 ? '0' : ''}${minute}</option>
									</c:forEach>
								</c:forEach>
							</select> <select class="selectbox" name="mediaType" placeholder="영상 구분">
								<option value="<%=infrared%>">적외영상</option>
								<option value="<%=visible%>">가시영상</option>
								<option value="<%=vapor%>">수증기영상</option>
								<option value="<%=shortWave%>">단파적외영상</option>
								<option value="<%=rgbColor%>">RGB(컬러)영상</option>
								<option value="<%=rgbDay%>">RGB(주야간합성)영상</option>
							</select> <input class="buttonStyle" id="searchButton" type="submit"
								value="조회">
						</form>
					</div>
					<div id="buttonDiv">
						<div id="searchedDate">
							<input type="text" id="searchedText"
								value="<%=selectedDate%>/<%=selectedTime%>">
						</div>
						<div class="searchButton">
							<!-- 어제 버튼 -->
							<div class="buttonDiv">
								<form action="/satellite/getSatelliteImages" method="get"
									id="yesterdayForm">
									<input type="hidden" name="date" value="<%=formatYesterday%>" />
									<input type="hidden" name="time" value="<%=selectedTime%>">
									<input type="hidden" name="mediaType"
										value="<%=selectedMediaType%>"> <input
										class="buttonStyle" type="submit" id="yesterdayButton"
										value="어제">
								</form>
							</div>
							<!-- 오늘 버튼 -->
							<div class="buttonDiv">
								<form action="/satellite/getSatelliteImages" method="get"
									id="todayForm">
									<input type="hidden" name="date" value="<%=formatToday%>" /> <input
										type="hidden" name="time" value="<%=selectedTime%>">
									<input type="hidden" name="mediaType"
										value="<%=selectedMediaType%>"> <input
										class="buttonStyle" type="submit" id="todayButton" value="오늘">
								</form>
							</div>
							<!-- 10분전 버튼 -->
							<div class="buttonDiv">
								<form action="/satellite/getSatelliteImages" method="get"
									id="tenMinBeforeForm">
									<input type="hidden" name="date" value="<%=selectedDate%>">
									<input type="hidden" name="time"
										value="<%=formattedTenMinutesBefore%>"> <input
										type="hidden" name="mediaType" value="<%=selectedMediaType%>">
									<input class="buttonStyle" type="submit" id="tenBeforeButton"
										value="&lt;&lt;">
								</form>
							</div>
							<!-- 10분후 버튼 -->
							<div class="buttonDiv">
								<form action="/satellite/getSatelliteImages" method="get"
									id="tenMinAfterForm">
									<input type="hidden" name="date" value="<%=selectedDate%>">
									<input type="hidden" name="time"
										value="<%=formattedTenMinutesAfter%>"> <input
										type="hidden" name="mediaType" value="<%=selectedMediaType%>">
									<input class="buttonStyle" type="submit" id="tenAfterButton"
										value="&gt;&gt;">
								</form>
							</div>
							<!-- 재생/멈춤 버튼 -->
							<div class="buttonDiv">
								<input class="buttonStyle" type="button" id="playButton"
									value="재생"> <input class="buttonStyle" type="button"
									id="stopButton" value="멈춤">
							</div>
						</div>
					</div>
				</div>
				<hr>
				<br>
				<!-- 위성 이미지 출력 div -->
				<div id="satelliteImages"
					data-setss="${satellite.response.body.items.item.get(0).satImgCFile}">
					<div id="alertMessage">조회 버튼을 눌러 조회하고싶은 시간대와 이미지 종류를 선택하십시오.</div>
					<br>
					<img id="defaultImage" src="/static/image/pet.png">
					<img id="response" src="">
				</div>
			</div>
		</div>
	</div>
	<div id="bot">
		<pre>@Error404: Team Not Found Corp.</pre>
	</div>
	<script>	
	$(document).ready(function() {
		// 조회 버튼 클릭 시 이미지 URL 업데이트
	   	$('#searchButton').on('click', function(event) {
	   		// 기본 이벤트(폼 제출 등) 방지
	   	    event.preventDefault();
	   	
	   	 	$('#submitForm').submit();
	    });
		
	 	// 어제 버튼 클릭 시 이미지 URL 업데이트
	    $("#yesterdayButton").click(function(event) {
	    	// 기본 이벤트(폼 제출 등) 방지
	   	    event.preventDefault();
	   	
	   	 	$('#yesterdayForm').submit();
	    });
	 	
	 	// 오늘 버튼 클릭 시 이미지 URL 업데이트
	    $("#todayButton").click(function(event) {
	    	// 기본 이벤트(폼 제출 등) 방지
	   	    event.preventDefault();
	   	
	   	 	$('#todayForm').submit();
	    });
	 
	 	// 10분 전 버튼 클릭 시 이미지 URL 업데이트
	    $("#tenBeforeButton").click(function(event) {
	    	// 기본 이벤트(폼 제출 등) 방지
	   	    event.preventDefault();
	   	
	   	 	$('#tenMinBeforeForm').submit();
	    });
	 	
	 	// 10분 후 버튼 클릭 시 이미지 URL 업데이트
	    $("#tenAfterButton").click(function(event) {
	    	// 기본 이벤트(폼 제출 등) 방지
	   	    event.preventDefault();
	   	
	   	 	$('#tenMinAfterForm').submit();
	    });

	    // "재생" 버튼 클릭 시 이미지 URL 자동 갱신
	    $("#playButton").click(function(event) {
	        var satImgCFile = $('#satelliteImages').data("setss");
	        var urls = satImgCFile.split(",");
	        var currentIndex = 0;
	        var intervalId;

	        function updateImage() {
	            var trimmedUrl = urls[currentIndex].trim().replace(/\[|\]/g, '');
	            $('#response').attr('src', trimmedUrl);
	            currentIndex = (currentIndex + 1) % urls.length; // 다음 URL 인덱스로 이동
	        }

	        updateImage(); // 최초 실행

	        // 10초마다 이미지 URL 업데이트
	        intervalId = setInterval(updateImage, 1000);

	        // "멈춤" 버튼 클릭 시 setInterval 중지
	        $("#stopButton").click(function() {
	            clearInterval(intervalId);
	        });
	    });
	    
	});
	
	// 폼 제출 후의 이미지 URL 업데이트
	function loadImageAfterSubmit() {
	    // URL분리 작업
	    var satImgCFile = $('#satelliteImages').data("setss");
	    var urls = satImgCFile.split(",").map(function(url) {
	        return url.trim().replace(/\[|\]/g, '');
	    });
		
	 	// 폼에서 직접 시간 값을 가져옵니다.
   		var selectedDate = "<%=selectedDate%>"; // 사용자가 선택한 날짜
   		var selectedTime = "<%=selectedTime%>"; // 사용자가 선택한 시간

			var matchedUrl = urls.find(function(url) {
				return url.includes(selectedDate + selectedTime);
			});

			if (matchedUrl) {
				$('#response').attr('src', matchedUrl + "?timestamp=" + new Date().getTime());
				$('#defaultImage').hide();
				$('#alertMessage').hide(); // 이미지가 있으므로 경고 메시지 숨김
			} else {
				$('#response').hide(); // 기존 이미지 숨김
				$('#alertMessage').text('조회 버튼을 눌러 검색하실 시간대를 선택해주세요.').show(); // 경고 메시지 표시
				// 첫 페이지 로드 시에는 경고 대화 상자가 표시되지 않도록 조건 추가
				if (selectedDate && selectedTime) {
					alert("선택하신 시간대의 위성이미지가 아직 업데이트되지 않았습니다.\n다른 시간대를 선택해주세요.");
				}
			}

		}

		document.addEventListener("DOMContentLoaded", function() {
			loadImageAfterSubmit();
		});
	</script>
</body>
</html>