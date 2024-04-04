// script.js 파일에 저장
const provinceSelect = document.getElementById('province');
const citySelect = document.getElementById('city');
const resultDiv = document.getElementById('resultValue');
const generateResultButton = document.getElementById('generateResult');

const citiesByProvince = {
    '서울특별시': ['강남구', '강서구', '관악구'],
    '경기도': ['수원시', '성남시', '용인시']
    // 다른 시/도에 따른 구/군 정보 추가
};

function populateOptions(selectElement, options) {
    selectElement.innerHTML = '';
    options.forEach(option => {
        const optionElement = document.createElement('option');
        optionElement.textContent = option;
        optionElement.value = option;
        selectElement.appendChild(optionElement);
    });
}

function updateCityOptions() {
    const selectedProvince = provinceSelect.value;
    const cities = citiesByProvince[selectedProvince];
    populateOptions(citySelect, cities);
    citySelect.disabled = false;
    updateResult();
}

function updateResult() {
    const province = provinceSelect.value;
    const city = citySelect.value || "";
    resultDiv.textContent = `${province} ${city}`;
}

function printSelectedValuesToConsole() {
    const province = provinceSelect.value;
    const city = citySelect.value || "";
    console.log(`${province} ${city}`);
}



provinceSelect.addEventListener('change', updateCityOptions);
citySelect.addEventListener('change', updateResult);
generateResultButton.addEventListener('click', printSelectedValuesToConsole);

updateCityOptions();
updateResult();

// script.js 파일

//어제 날짜
function getYesterday() {
    var yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);

    var year = yesterday.getFullYear();
    var month = yesterday.getMonth() + 1;
    var day = yesterday.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return year + "" + month + "" + day;
}

// 오늘 날짜를 가져오는 함수
function getToday() {
    var today = new Date();
    var year = today.getFullYear();
    var month = today.getMonth() + 1;
    var day = today.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;
    return year + "" + month + "" + day;
}

// 오늘 날짜 다른 함수
function getTodayFormatted() {
    var today = new Date();
    var tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate());

    var month = tomorrow.getMonth() + 1;
    var day = tomorrow.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return month + "." + day;
}

//내일 날짜를 가져오는 함수
function getTomorrow() {
    var today = new Date();
    var tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    var year = tomorrow.getFullYear();
    var month = tomorrow.getMonth() + 1;
    var day = tomorrow.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return year + "" + month + "" + day;
}

// 내일 날짜 다른 함수
function getTomorrowFormatted() {
    var today = new Date();
    var tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    var month = tomorrow.getMonth() + 1;
    var day = tomorrow.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return month + "." + day;
}

// 모레 날짜를 가져오는 함수
function getDayAfterTomorrow() {
    var today = new Date();
    var dayAfterTomorrow = new Date(today);
    dayAfterTomorrow.setDate(dayAfterTomorrow.getDate() + 2);

    var year = dayAfterTomorrow.getFullYear();
    var month = dayAfterTomorrow.getMonth() + 1;
    var day = dayAfterTomorrow.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return year + "" + month + "" + day;
}

// 모레 날짜 다른 함수
function getAfterTomorrowFormatted() {
    var today = new Date();
    var tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 2);

    var month = tomorrow.getMonth() + 1;
    var day = tomorrow.getDate();
    month = month < 10 ? '0' + month : month;
    day = day < 10 ? '0' + day : day;

    return month + "." + day;
}

var baseDateYesterday = getYesterday(); // 어제 날짜

var baseDateToday = getTodayFormatted() // 오늘 날짜 00.00 버전

$.getJSON("https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date=" + baseDateYesterday + "&base_time=0500&nx=55&ny=127",
    function (data) {
        console.log(data);

        let tmn_today = {},
            tmx_today = {};

        // 각 항목을 반복하면서
        $.each(data.response.body.items.item, function (index, item) {
            let date = item.fcstDate;
            let value = item.fcstValue;

            if (date === getTomorrow()) {
                // 카테고리가 'TMN' (최저 기온)인 경우
                if (item.category == "TMN") {
                    tmn_today[date] = parseInt(value); // 정수로 변환
                }
                // 카테고리가 'TMX' (최고 기온)인 경우
                else if (item.category == "TMX") {
                    tmx_today[date] = parseInt(value); // 정수로 변환
                }
            }
        });

        // tmn_today과 tmx_today에 저장된 값을 결과에 표시
        $.each(tmn_today, function (date, value) {
            let content = "오늘 " + baseDateToday + "<br>" + value + "° / " + tmx_today[date] + "°";
            $('#results0').append('<p>' + content + '</p>');
        });

    });


var baseDate = getToday(); // 오늘 날짜

var baseDateTomorrow = getTomorrowFormatted() // 내일 날짜 00.00 버전

var baseDateAfterTomorrow = getAfterTomorrowFormatted() // 모레 날짜 00.00 버전

$.getJSON("https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&pageNo=1&numOfRows=1000&dataType=JSON&base_date=" + baseDate + "&base_time=0500&nx=55&ny=127",
    function (data) {
        console.log(data);

        let tmn_today = {},
            tmx_today = {},
            tmn_dayAfterTomorrow = {},
            tmx_dayAfterTomorrow = {};

        // 각 항목을 반복하면서
        $.each(data.response.body.items.item, function (index, item) {
            let date = item.fcstDate;
            let value = item.fcstValue;

            if (date === getTomorrow()) {
                // 카테고리가 'TMN' (최저 기온)인 경우
                if (item.category == "TMN") {
                    tmn_today[date] = value;
                }
                // 카테고리가 'TMX' (최고 기온)인 경우
                else if (item.category == "TMX") {
                    tmx_today[date] = value;
                }
            } else if (date === getDayAfterTomorrow()) {
                // 카테고리가 'TMN' (최저 기온)인 경우
                if (item.category == "TMN") {
                    tmn_dayAfterTomorrow[date] = value;
                }
                // 카테고리가 'TMX' (최고 기온)인 경우
                else if (item.category == "TMX") {
                    tmx_dayAfterTomorrow[date] = value;
                }
            }
        });

        // tmn_today과 tmx_today에 저장된 값을 결과에 표시
        $.each(tmn_today, function (date, value) {
            let content = "내일 " + baseDateTomorrow + "<br>" + " 최저 기온: " + value + " 최고 기온: " + tmx_today[date];
            $('#results1').append('<p>' + content + '</p>');
        });

        // tmn_dayAfterTomorrow과 tmx_dayAfterTomorrow에 저장된 값을 결과에 표시
        $.each(tmn_dayAfterTomorrow, function (date, value) {
            let content = baseDateAfterTomorrow + "<br>" + value + "°C / " + tmx_dayAfterTomorrow[date] + "°C";
            $('#results2').append('<p>' + content + '</p>');
        });



        ///3일~10일
        // 3일부터 10일까지의 날짜 반환하는 함수
        function getLaterDate(daysLater) {
            var today = new Date();
            var futureDate = new Date(today);
            futureDate.setDate(futureDate.getDate() + daysLater);

            var month = futureDate.getMonth() + 1;
            var day = futureDate.getDate();
            month = month < 10 ? '0' + month : month;
            day = day < 10 ? '0' + day : day;

            return month + "." + day;
        }

        var baseDateThreeDay = getLaterDate(3); // 3일 후 날짜
        var baseDateFourDay = getLaterDate(4); // 4일 후 날짜
        var baseDateFiveDay = getLaterDate(5); // 5일 후 날짜
        var baseDateSixDay = getLaterDate(6); // 6일 후 날짜
        var baseDateSevenDay = getLaterDate(7); // 7일 후 날짜
        var baseDateEightDay = getLaterDate(8); // 8일 후 날짜
        var baseDateNineDay = getLaterDate(9); // 9일 후 날짜
        var baseDateTenDay = getLaterDate(10); // 10일 후 날짜

        $.getJSON("https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&regId=11B10101&tmFc=" + baseDate + "0600",
            function (data) {
                console.log(data);

                let item = data.response.body.items.item[0];

                let content = baseDateThreeDay + "  " + item.taMin3 + "°/" + item.taMax3 + "°";
                $('#results3').text(content);

                let content2 = baseDateFourDay + "  " + item.taMin4 + "°/" + item.taMax4 + "°";
                $('#results4').text(content2);
                let content3 = baseDateFiveDay + "  " + item.taMin5 + "°/" + item.taMax5 + "°";
                $('#results5').text(content3);
                let content4 = baseDateSixDay + "  " + item.taMin6 + "°/" + item.taMax6 + "°";
                $('#results6').text(content4);
                let content5 = baseDateSevenDay + "  " + item.taMin7 + "°/" + item.taMax7 + "°";
                $('#results7').text(content5);
                let content6 = baseDateEightDay + " " + item.taMin8 + "°/" + item.taMax8 + "°";
                $('#results8').text(content6);
                let content7 = baseDateNineDay + "  " + item.taMin9 + "°/" + item.taMax9 + "°";
                $('#results9').text(content7);
                let content8 = baseDateTenDay + "  " + item.taMin10 + "°/" + item.taMax10 + "°";
                $('#results10').text(content8);

            });


        //미세먼지 초미세먼지

        // 등급을 숫자에서 문자열로 변환하는 함수
        function convertUltrafineDustGrade(grade) {
            if (grade <= 25) return "좋음";
            else if (grade <= 50) return "보통";
            else if (grade <= 75) return "나쁨";
            else return "매우 나쁨";
        }

        function convertFineDustGrade(grade) {
            if (grade = 1) return "좋음";
            else if (grade = 2) return "보통";
            else if (grade = 3) return "나쁨";
            else return "매우 나쁨";
        }

        $.getJSON("https://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&returnType=json&numOfRows=100&pageNo=1&sidoName=%EC%84%9C%EC%9A%B8&ver=1.7.2",
            function (data) {
                let item = data.response.body.items[0];

                // 등급 변환
                let ultrafineDustGrade = convertUltrafineDustGrade(parseInt(item.pm10Value));
                let fineDustGrade = convertFineDustGrade(item.pm10Grade1h);

                let content = "초미세먼지: " + ultrafineDustGrade;
                $('.resultUltrafineDust').text(content);

                let content2 = "미세먼지: " + fineDustGrade;
                $('.resultFineDust').text(content2);
            });

        // 자외선
        // 등급을 숫자에서 문자열로 변환하는 함수
        function ultravioletRays(ultraviolet) {
            if (ultraviolet >= 0 && ultraviolet < 3) return "낮음";
            else if (ultraviolet >= 3 && ultraviolet < 6) return "보통";
            else if (ultraviolet >= 6 && ultraviolet < 8) return "높음";
            else if (ultraviolet >= 8 && ultraviolet < 10) return "매우높음";
            else if (ultraviolet >= 11) return "매우높음";
        }

        $.getJSON("https://apis.data.go.kr/1360000/LivingWthrIdxServiceV4/getUVIdxV4?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&areaNo=1100000000&time=" + baseDate,
            function (data) {
                console.log(data);

                console.log(data.response.header.resultCode);

                //                 단계	지수범위
                // 위험	11 이상
                // 매우높음	8~10
                // 높음	6~7
                // 보통	3~5
                // 낮음	0~2
                let item = data.response.header.resultCode;

                let ultraviolet = ultravioletRays(item);

                let content = "자외선: " + ultraviolet;
                $('.ultraviolet').text(content);
            });

        //일출 일몰
        class City {
            constructor(name, latitude, longitude, containerId) {
                this.name = name;
                this.latitude = latitude;
                this.longitude = longitude;
                this.containerId = containerId;
            }

            fetchAndPrintSunriseSunset(apiKey) {
                const apiUrl = `https://api.openweathermap.org/data/2.5/forecast?lat=${this.latitude}&lon=${this.longitude}&appid=${apiKey}&units=metric&lang=kr`;

                fetch(apiUrl)
                    .then(response => response.json())
                    .then(data => {
                        const sunriseTime = new Date(data.city.sunrise * 1000);
                        const sunsetTime = new Date(data.city.sunset * 1000);
                        const formatTime = time => {
                            const hours = time.getHours().toString().padStart(2, '0');
                            const minutes = time.getMinutes().toString().padStart(2, '0');
                            return `${hours}:${minutes}`;
                        };

                        const cityInfoContainer = document.getElementById(this.containerId);
                        const cityInfo = document.createElement("div");
                        cityInfo.classList.add("city-info");
                        cityInfo.innerHTML = `<p>${this.name} 일출 시간: ${formatTime(sunriseTime)}</p><p>${this.name} 일몰 시간: ${formatTime(sunsetTime)}</p>`;
                        cityInfoContainer.appendChild(cityInfo);
                    })
                    .catch(error => console.error(`${this.name}의 데이터를 불러오는 중 오류가 발생했습니다:`, error));
            }
        }

        const cities = [
            { name: "서울", latitude: "37.5665", longitude: "126.9780", containerId: "seoulInfo1" },
            { name: "서울", latitude: "37.5665", longitude: "126.9780", containerId: "seoulInfo2" },
            { name: "부산", latitude: "35.1796", longitude: "129.0756", containerId: "busanInfo1" },
            { name: "인천", latitude: "37.4563", longitude: "126.7052", containerId: "incheonInfo1" },
            { name: "대구", latitude: "35.8714", longitude: "128.6014", containerId: "daeguInfo1" },
            { name: "대전", latitude: "36.3504", longitude: "127.3845", containerId: "daejeonInfo1" },
            { name: "광주", latitude: "35.1595", longitude: "126.8526", containerId: "gwangjuInfo1" },
            { name: "울산", latitude: "35.5384", longitude: "129.3114", containerId: "ulsanInfo1" },
            { name: "수원", latitude: "37.2636", longitude: "127.0286", containerId: "suwonInfo1" },
            { name: "강릉", latitude: "37.7519", longitude: "128.8760", containerId: "gangneungInfo1" },
            { name: "춘천", latitude: "37.8810", longitude: "127.7298", containerId: "chuncheonInfo1" },
            { name: "울릉", latitude: "37.4847", longitude: "130.8988", containerId: "uljinInfo1" },
            { name: "청주", latitude: "36.6394", longitude: "127.4897", containerId: "cheongjuInfo1" },
            { name: "안동", latitude: "36.5686", longitude: "128.7294", containerId: "andongInfo1" },
            { name: "포항", latitude: "36.0198", longitude: "129.3700", containerId: "pohangInfo1" },
            { name: "전주", latitude: "35.8242", longitude: "127.1470", containerId: "jeonjuInfo1" },
            { name: "목포", latitude: "34.8128", longitude: "126.3945", containerId: "mokpoInfo1" },
            { name: "여수", latitude: "34.7445", longitude: "127.7385", containerId: "yeosuInfo1" },
            { name: "제주", latitude: "33.4996", longitude: "126.5312", containerId: "jejuInfo1" },
            { name: "부산", latitude: "35.1796", longitude: "129.0756", containerId: "busanInfo2" },
            { name: "인천", latitude: "37.4563", longitude: "126.7052", containerId: "incheonInfo2" },
            { name: "대구", latitude: "35.8714", longitude: "128.6014", containerId: "daeguInfo2" },
            { name: "대전", latitude: "36.3504", longitude: "127.3845", containerId: "daejeonInfo2" },
            { name: "광주", latitude: "35.1595", longitude: "126.8526", containerId: "gwangjuInfo2" },
            { name: "울산", latitude: "35.5384", longitude: "129.3114", containerId: "ulsanInfo2" },
            { name: "수원", latitude: "37.2636", longitude: "127.0286", containerId: "suwonInfo2" },
            { name: "강릉", latitude: "37.7519", longitude: "128.8760", containerId: "gangneungInfo2" },
            { name: "춘천", latitude: "37.8810", longitude: "127.7298", containerId: "chuncheonInfo2" },
            { name: "울릉", latitude: "37.4847", longitude: "130.8988", containerId: "uljinInfo2" },
            { name: "청주", latitude: "36.6394", longitude: "127.4897", containerId: "cheongjuInfo2" },
            { name: "안동", latitude: "36.5686", longitude: "128.7294", containerId: "andongInfo2" },
            { name: "포항", latitude: "36.0198", longitude: "129.3700", containerId: "pohangInfo2" },
            { name: "전주", latitude: "35.8242", longitude: "127.1470", containerId: "jeonjuInfo2" },
            { name: "목포", latitude: "34.8128", longitude: "126.3945", containerId: "mokpoInfo2" },
            { name: "여수", latitude: "34.7445", longitude: "127.7385", containerId: "yeosuInfo2" },
            { name: "제주", latitude: "33.4996", longitude: "126.5312", containerId: "jejuInfo2" }
            // 다른 도시들도 같은 방식으로 추가
        ];

        const apiKey = "35751a4ab55af8aaee858624e4a8d31e";

        cities.forEach(city => {
            const newCity = new City(city.name, city.latitude, city.longitude, city.containerId);
            newCity.fetchAndPrintSunriseSunset(apiKey);
        });


        //풍속 풍향
        $.getJSON("https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst?serviceKey=SK%2BPRcZcmwLI1Ay0iY4upnwt8YM36JwLQ9lNFQebeaz7yXOCb0BmR6HdvFQgBR7YrCPgf%2FDfscztrpYzGxoc1g%3D%3D&pageNo=1&numOfRows=10&dataType=JSON&base_date=" + baseDate+"&base_time=0500&nx=60&ny=127",
        function (data) {
            console.log(data);

            const items = data.response.body.items.item;
            let vecValue, wsdValue;

            items.forEach(item => {
                if (item.category === 'VEC') {
                    // 풍향 값 변환 함수
                    function convertWindDirection(deg) {
                        if (deg >= 0 && deg <= 45) return '북북동';
                        else if (deg > 45 && deg <= 90) return '북동';
                        else if (deg > 90 && deg <= 135) return '동동남';
                        else if (deg > 135 && deg <= 180) return '동남';
                        else if (deg > 180 && deg <= 225) return '남남서';
                        else if (deg > 225 && deg <= 270) return '남서';
                        else if (deg > 270 && deg <= 315) return '서서북';
                        else if (deg > 315 && deg <= 360) return '서북';
                        else return '알 수 없음';
                    }

                    vecValue = convertWindDirection(item.fcstValue);
                } else if (item.category === 'WSD') {
                    wsdValue = item.fcstValue;
                }
            });

            $(".result-vec").text(`풍향: ${vecValue}`);
            $(".result-wsd").text(`풍속: ${wsdValue} m/s`);
        });





    });