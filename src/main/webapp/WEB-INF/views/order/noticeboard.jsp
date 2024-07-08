<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <meta name="description" content="Figma htmlGenerator">
    <meta name="author" content="htmlGenerator">
    <link href="https://fonts.googleapis.com/css?family=Sigmar+One&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Roboto&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        #middle-img {
            width: 100%; /* 이미지의 가로 크기를 컨테이너의 100%로 설정 */
            max-width: 1500px; /* 이미지의 최대 가로 크기를 1500px로 설정 */
            height: auto; /* 이미지의 세로 비율을 유지하면서 크기 조정 */
            display: block;
            margin: 0 auto 20px; /* 이미지가 가운데 정렬되고 아래 여백 추가 */
            border-radius: 8px;
        }

        .container {

            border-radius: 8px;
        }

        .container h2 {
            margin-top: 0; /* h2 태그의 위쪽 여백 제거 */
          
        }

        .custom-button {
            display: block;
            width: 150px;
            padding: 10px 20px;
            margin: 5px 5px 20px auto; /* 위쪽 5px, 오른쪽 5px, 아래쪽 20px */
            font-size: 16px;
            font-weight: bold; /* 텍스트 굵기 추가 */
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 5px;
            text-align: center; /* 텍스트 가운데 정렬 */
            cursor: pointer;
            
        }

        .custom-button:hover {
            background-color: #0056b3;
        }

        .no-orders {
            text-align: center;
            font-size: 18px;
            color: #888;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/views/common/header.jsp" %>

    <img src="${contextPath}/resources/images/dd.jpg" id="middle-img">
    
    <div class="container">
        <h2>배달 요청</h2>
        <table>
            <thead>
                <tr>
                    <th>No</th>
                    <th>제목</th>
                    <th>글쓴이</th>
                    <th>라이더</th>
                    <th>시작위치</th>
                    <th>도착위치</th>
                    <th>작성시간</th>
                    <th>가격</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="8" class="no-orders">새 주문을 요청하세요!</td>
                    </tr>
                </c:if>
                <c:forEach items="${list}" var="order">
                    <tr class="clickable-row" data-id="${order.orderNo}">
                        <td>${order.orderNo}</td>
                        <td>${order.orderTitle}</td>
                        <td>${order.writer}</td>
                        <td><span class="rider-status">${order.orderStatus}</span></td>
                        <td>${order.startPoint}</td>
                        <td>${order.endPoint}</td>
                        <td><fmt:formatDate value="${order.createDate}" pattern="yy-MM-dd" /></td>
                        <td>${order.price}</td>
                    </tr>
                </c:forEach>		
            </tbody>
        </table>
        <button class="custom-button" id="customButton">배달 요청하기</button>
    </div>

    <%@ include file="/WEB-INF/views/common/footer.jsp" %>

    <script>
        document.querySelectorAll('tbody tr').forEach(row => {
            row.addEventListener('click', function(event) {
                // 클릭된 요소가 라이더 상태 버튼이 아닌 경우에만 페이지 이동
                if (!event.target.closest('.rider-status')) {
                    // 행에 설정된 data-url 속성 값으로 이동
                    const url = this.getAttribute('data-url');
                    if (url) {
                        window.location.href = url;
                    }
                }
            });
        });

        // 라이더 상태 버튼에 대한 별도의 이벤트 리스너
        document.querySelectorAll('.rider-status').forEach(button => {
            button.addEventListener('click', function(event) {
                event.stopPropagation(); // 이벤트 버블링 방지
                console.log('Rider status button clicked');
                // 여기에 라이더 상태 버튼 클릭 시 수행할 동작을 추가하세요
            });
        });

        // 새로운 버튼에 대한 이벤트 리스너
        document.getElementById('customButton').addEventListener('click', function() {
            const url = 'orderInsert'; // URL을 설정하세요
            window.location.href = url;
        });
        
        document.addEventListener('DOMContentLoaded', function() {
            var rows = document.querySelectorAll('.clickable-row');
            rows.forEach(function(row) {
                row.addEventListener('click', function() {
                    const id = row.dataset.id;
                    const url = `/semi/board/detailProduct?id=${id}`;
                    window.location.href = url;
                });
            });
        });
    </script>
</body>
</html>
