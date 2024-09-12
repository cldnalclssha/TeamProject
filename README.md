 # 딜리메이트

![Cinemacloud Image](./images/mainImage.png)
[시네마클라우드](https://github.com/juseungpark97/FinalProject)

**개발 기간**: 2024.06 ~ 2024.07


## 웹개발팀 인원(총 6명)

- 이은호, 박주승, 오민혁, 김경호, 정인석, 이주빈 

## 프로젝트 소개


### 주요 기능

주문 생성
채팅방(고객, 라이더 1:1 채팅방)
목록 조회/상세 조회
회원가입/고객 및 라이더 로그인 (아이디/비밀번호 찾기)
파일 첨부
고객 문의
신고하기
긴급배송

### 사용된 기술 스택

- **프론트엔드**:
  - HTML5
  - CSS3
  - JavaScript
- **백엔드**:
  - Spring Framework(Version: 3.9.18.RELEASE)
- **데이터베이스**:
  - Oracle Database 21c Express Edition
- **개발 환경**:
  - Java(TM) 플랫폼: 11.0.21, 0.2  
  - Oracle IDE: 23.1.1.345.2114
- **서버**:
  - Tomcat v9.0 Server

### 사용된 API

- 카카오맵API
- 카카오모빌리티API

### 담당 기능
 - **주문생성 페이지 경로 생성**
![image](https://github.com/user-attachments/assets/5375a96b-0d1b-4f63-8f52-823ca7602193)
### 주요 기능
- 경로 표시 기능 :  브라우저에서 사용자의 위치를 받아 지도의 중심으로 설정하고, 지도를 클릭할 때 클릭한 위치에 마커를 표시합니다. 두 개의 마커가 설정되면, Kakao API를 통해 두 지점 간의 경로를 찾아 지도에 그리며, 경로의 거리와 이에 따른 요금을 계산합니다. 또한, 클릭한 좌표를 주소로 변환해 출발지와 도착지 주소를 표시해 줍니다.
### 코드 예시
```java
<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=API-KEY&libraries=services"></script>
var mapContainer = document.getElementById('map'); 
var mapOption = {
    center: new kakao.maps.LatLng(33.450701, 126.570667), 
    level: 3 
};
var map = new kakao.maps.Map(mapContainer, mapOption);
var geocoder = new kakao.maps.services.Geocoder();
if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
        var lat = position.coords.latitude;
        var lon = position.coords.longitude;
        var locPosition = new kakao.maps.LatLng(lat, lon);
        map.setCenter(locPosition);
    }, function(error) {
        console.error(error);
    });
}
var markers = [];
var polylines = [];
kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
    if (markers.length >= 2) {
        clearMap();
    } else {
        var latlng = mouseEvent.latLng;
        var marker = new kakao.maps.Marker({
            position: latlng 

        });
        marker.setMap(map); 
        markers.push(marker); 
        getAddressFromCoords(latlng); 
        if (markers.length === 2) {
            setTimeout(() => {}, 5000); 
            findRouteAndDrawLine(); 
        }
    }
});
function findRouteAndDrawLine() {
    var start = markers[0].getPosition();
    var end = markers[1].getPosition()
    var url = `https://apis-navi.kakaomobility.com/v1/directions?origin=${start.getLng()},${start.getLat()}&destination=${end.getLng()},${end.getLat()}&waypoints=&priority=RECOMMEND&road_details=false`;
    
    fetch(url, {
        method: 'GET',
        headers: {
            'Authorization': 'KakaoAK API-KEY' 
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.routes && data.routes.length > 0) {
            var route = data.routes[0]; 
            var linePath = []; 
            route.sections.forEach(section => {
                section.roads.forEach(road => {
                    road.vertexes.forEach((vertex, index) => {
                        if (index % 2 === 0) {
                            linePath.push(new kakao.maps.LatLng(road.vertexes[index+1], road.vertexes[index]));
                        }
                    });
                });
            });
            var polyline = new kakao.maps.Polyline({
                path: linePath,
                strokeWeight: 5,
                strokeColor: '#86C1C6',
                strokeOpacity: 0.7,
                strokeStyle: 'solid'
            });
            polyline.setMap(map); 
            polylines.push(polyline); 
            var distance = polyline.getLength();
            var distanceKm = (distance / 1000).toFixed(2); 
            
            var distanceMoney = 5000 + Math.floor(distanceKm * 4000);
            document.getElementById("price").value = distanceMoney + "원";
            document.getElementById("dis").value = distanceKm + "km";
            console.log('Distance: ' + distanceKm + ' km');
        } else {
            console.log('Route not found.');
        }
    })
    .catch(error => console.log('Error:', error));
}
function getAddressFromCoords(coords) {
    geocoder.coord2Address(coords.getLng(), coords.getLat(), function(result, status) {
       


 if (status === kakao.maps.services.Status.OK) {
            var address = result[0].address.address_name;
            if (markers.length === 1) {
                document.getElementById('start-point').value = address;
            } else if (markers.length === 2) {
                document.getElementById('end-point').value = address;
            }
        }
    });
}


```
 - **회원가입 페이지지**
![image](https://github.com/user-attachments/assets/b53637b4-eba4-407e-9c33-2840c361129d)

### 주요 기능
- 이메일/닉네임 중복확인 : 사용자가 입력한 이메일/ 닉네임이 이미 사용중인지 서버에 요청을 보내 확인하고, 결과 메시지 출력
- 휴대폰 번호 최적화 : 입력한 휴대폰 번를 실시간으로 한국식 포맷으로 변환 하고 하이픈을 제거하여 숫자만 남긴다. 


### 코드 예시

```typescript
function idCheck() {
    var $email = $(".form-group input[name=email]");
    $.ajax({
        url: "/semi/user/idCheck",
        method: "GET",
        data: { email: $email.val() },
        success: function(result) {
            if (result == 1) {
                alert("이미 사용 중인 이메일입니다.");
                $email.val("");
                $email.focus();
            } else {
                alert("사용 가능한 이메일입니다.");
            }
        }
    });
}
function nnCheck() {
    var $nickname = $(".form-group input[name=nickname]");
    $.ajax({
        url: "/semi/user/nnCheck",
        method: "GET",
        data: { nickname: $nickname.val() },
        success: function(result) {
            if (result == 1) {
                alert("이미 사용 중인 닉네임입니다.");
             

 
  
$nickname.val("");
   $nickname.focus();
            } else {
                alert("사용 가능한 닉네임입니다.");
           

 }
      
  }
    });
}
function formatPhoneNumber(input) {
    let cleaned = input.value.replace(/\D/g, ''); 
    let formatted = '';
    if (cleaned.length > 3 && cleaned.length <= 7) {
        formatted = cleaned.replace(/(\d{3})(\d+)/, '$1-$2');
    } else if (cleaned.length > 7) {
        formatted = cleaned.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
    } else {
        formatted = cleaned;
    }
    input.value = formatted;
}
function cleanPhoneNumber() {
    let phoneInput = document.getElementById('phone');
    phoneInput.value = phoneInput.value.replace(/-/g, '');
}


```


 - **아이디 비밀번호 찾기/변경**
![image](https://github.com/user-attachments/assets/2c9acf29-f9b2-41c2-8621-03e5fbaf9b7e)
### 주요 기능
- 아이디 찾기: 가입할때 입력한 번호와 일치하는 아이디가 있다면 비동기 처리방식으로 출력
- 비밀번호 찾기: 찾고자하는 비밀번호의 이메일과 생년월일이 일치하면 비밀번호 변경 페이지로 이동한다.
                      변경하고자 하는 두개의 비밀번호가 일치하면 데이터 베이스에 업데이트 한다. 
### 코드 예시

```java
   <script>
    $(document).ready(function() {
        $('#findIdButton').click(function() {
            var phone = $('input[name="phone"]').val();
            $.ajax({
                type: 'POST',
                url: '${pageContext.request.contextPath}/user/idfind',
                contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                data: { phone: encodeURIComponent(phone) },
                success: function(response) {
                    $('#foundId').text(response);
                },
                error: function() {
                    $('#foundId').text('아이디를 찾을 수 없습니다.');
                }
            });

@PostMapping("/idfind")
@ResponseBody
public ResponseEntity<String> idfind(@RequestParam String phone) {
   
   String username = uService.idfind(phone);
   
   String responseMessage = (username != null) ? username : "아이디를 찾을 수 없습니다.";
   return ResponseEntity.ok().contentType(MediaType.TEXT_PLAIN).body(responseMessage);
}
@PostMapping("/changepw")
public String findPassword(@RequestParam("email") String email, @RequestParam("birth") String birth,
      HttpSession session, Model model) {
   
   String password = uService.pwfind(birth, email);
   
   session.setAttribute("email", email);
   if (password != null) {
   .
      model.addAttribute("password", password);
      return "/user/changepw"; 
 
  } else {
      model.addAttribute("error", "No matching account found.");
      return "user/pwfind"; 
   }
}
@PostMapping("/updatepw")
public String updatePassword(@RequestParam("pw1") String pw1, @RequestParam("pw2") String pw2,
      @SessionAttribute("email") String email, RedirectAttributes ra) {
   if (pw1.equals(pw2)) {
      String encPwd = encoder.encode(pw1);
      int result = uService.updatepw(encPwd, email);
      if (result >= 1) {
         ra.addFlashAttribute("alertMsg", "비밀번호 변경 성공");
         return "redirect:/"; 
      } else {
         return "redirect:/"; 
      }
   } else {
      return "redirect:/"; 
   }
}

```

- **주문상세 페이지**
![image](https://github.com/user-attachments/assets/27e75046-9a9f-44ab-a514-772794891341)
### 주요 기능
주문자가 올린 물건의 여러 정보들이 들어가 있는 페이지 
- 지도 상세 보기  :  두 지점의 주소를 KAKAO MAPS API를 이용해서 좌표로 변환후, 지도에 마커표시를 한다. 
                           마커가 모두 보이도록 지도의 시각적인 범위를 조절한다.
### 코드 예시
```typescript
function initializeMap() {
   var mapContainer = document.getElementById('map');
   var mapOption = {
       center: new kakao.maps.LatLng(33.450701, 126.570667),
       level: 4
   };
   var map = new kakao.maps.Map(mapContainer, mapOption);
   var geocoder = new kakao.maps.services.Geocoder();
   var startPoint = "${order.startPoint}";
   var endPoint = "${order.endPoint}";
   var markers = [];
   var polylines = [];
   function geocodeAddress(address) {
       return new Promise(function(resolve, reject) {
           geocoder.addressSearch(address, function(result, status) {
               if (status === kakao.maps.services.Status.OK) {
                   resolve(new kakao.maps.LatLng(result[0].y, result[0].x));
               } else {
                   reject(status);
               }
           });
       });
   }
   Promise.all([geocodeAddress(startPoint), geocodeAddress(endPoint)])
       .then(function(coords) {
           var startMarker = new kakao.maps.Marker({
               map: map,
             
position: coords[0]
           });
           markers.push(startMarker);
           var endMarker = new kakao.maps.Marker({
               map: map,
               position: coords[1]
           });
           markers.push(endMarker);
           adjustMapBounds();
           if (markers.length === 2) {
               findRouteAndDrawLine();
           }
       })
       .catch(function(error) {
           console.error('Geocode error:', error);
       });
   function adjustMapBounds() {
       if (markers.length === 2) {
           var bounds = new kakao.maps.LatLngBounds();
           markers.forEach(marker => bounds.extend(marker.getPosition()));
           map.setBounds(bounds);
       }
   }
}

```

- **신고등록 및 목록 페이지**
![image](https://github.com/user-attachments/assets/382e639c-f37d-48f1-b24b-feafb3cbf6f8)
### 주요 기능
- 신고제출 페이지 : 사용자가 신고내용을 작성하여 제출할 수 있는 페이지를 제공한다. 
                         제출버튼을 누르면 사용자가 입력한 내용이 서버로 전송된다. 
- 신고 목록 페이지 : 관리자가 사용자가 작성한 신고 내용을 목록 으로 확인할 수 있음. 
### 코드 예시
```typescript
<main>
    <form action="${contextPath}/report/save" method="POST" id="reportForm" class="report-form">
        <div class="form-group">
            <label for="reportContent">신고 내용</label>
            <textarea id="reportContent" name="content" rows="5" required></textarea>
        </div>
        <div class="button-group">
            <button type="submit" class="btn-submit">신고 제출</button>
        </div>
    </form>
</main>
<div class="header">
    <h2>신고 목록</h2>
</div>
<table>
    <thead>
        <tr>
            <th>이름</th>
            <th>신고 내용</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${reports}" var="report">
            <tr>
                <td>${report.nickName}</td>
                <td>${report.content}</td>
        
    </tr>
        </c:forEach>
    </tbody>
</table>

```







