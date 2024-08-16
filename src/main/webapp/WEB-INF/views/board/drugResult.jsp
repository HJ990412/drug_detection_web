<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/style.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">

        $(document).ready(function() {

            $("#searchFood").click(function () {
                var loginInfo = "로그인이 필요합니다. 로그인 해주세요.";
                $("#loginInfo").html(loginInfo);
                $("#loginModal .modal-body").removeClass('alert-success').addClass('alert-warning');
                $("#loginModalLabel").text("로그인");
                $("#loginModal").modal("show");
            });

            <security:authorize access="isAuthenticated()">
                getDrugSearchList();
            </security:authorize>

            $("#file").on('change', function () { // 값이 변경되면
                if (window.FileReader) {// modern browser
                    var filename = $(this)[0].files[0].name;
                } else {// old IE
                    var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출
                }

                // 추출한 파일명 삽입
                $(".upload-name").val(filename);
            });
        });

        var foodIngredient = "${foodIngredient}";

        function redirectBasedOnAuth() {
            <security:authorize access="isAuthenticated()">
            window.location.href = '${cpath}/board/list';
            </security:authorize>
            <security:authorize access="isAnonymous()">
            window.location.href = '${cpath}/login/login'
            </security:authorize>
        }

        function getSearchList(){
            $.ajax({
                type: "get",
                url: "${cpath}/board/search",
                data: $("form[name=search-form]").serialize(),
                success: function(result){
                    $('#searchTable').empty();
                    if(result.length>=1){
                        result.forEach(function(item){
                            var sList="<tr onclick='checkFoodIngredient(\"" + item.foodName + "\")'>";
                            sList+="<td>"+item.foodCategory+"</td>";
                            sList+="<td>"+item.foodName+"</td>";
                            sList+="</tr>";
                            $('#searchTable').append(sList);
                        });
                    }
                },
                error: function() {
                    alert("음식검색오류");
                }
            });
        }

        function checkFoodIngredient(foodName) {
            $.ajax({
                type: "get",
                url: "${cpath}/board/getFoodIngredients",
                data: { foodName: foodName },
                success: function(food) {
                    console.log(food);

                    var foodIngredients = [
                        {name: 'carotene1', value: food.carotene1},
                        {name: 'carotene2', value: food.carotene2},
                        {name: 'carotene3', value: food.carotene3},
                        {name: 'glucose', value: food.glucose},
                        {name: 'cholesterol', value: food.cholesterol},
                        {name: 'palmitoyl2linoleoylphosphatidylcholine', value: food.palmitoyl2linoleoylphosphatidylcholine},
                        {name: 'cdpDg', value: food.cdpDg},
                        {name: 'hexadecanoic1', value: food.hexadecanoic1},
                        {name: 'hexadecanoic2', value: food.hexadecanoic2},
                        {name: 'nicotinic', value: food.nicotinic},
                        {name: 'lLysine', value: food.lLysine},
                        {name: 'retinol', value: food.retinol},
                        {name: 'riboflavin', value: food.riboflavin},
                        {name: 'selenium', value: food.selenium},
                        {name: 'lactose', value: food.lactose},
                        {name: 'thiamin', value: food.thiamin},
                        {name: 'water', value: food.water},
                        {name: 'glutamic', value: food.glutamic},
                        {name: 'lThreonine', value: food.lThreonine},
                        {name: 'phosphatidylcholine', value: food.phosphatidylcholine},
                        {name: 'fat', value: food.fat},
                        {name: 'calcium', value: food.calcium},
                        {name: 'copper', value: food.copper},
                        {name: 'iron', value: food.iron},
                        {name: 'magnesium', value: food.magnesium},
                        {name: 'phosphorus', value: food.phosphorus},
                        {name: 'potassium', value: food.potassium},
                        {name: 'sodium', value: food.sodium},
                        {name: 'zinc', value: food.zinc},
                        {name: 'vitaminB12', value: food.vitaminB12},
                        {name: 'vitaminB6', value: food.vitaminB6},
                        {name: 'lAscorbicAcid', value: food.lAscorbicAcid},
                        {name: 'vitaminE', value: food.vitaminE},
                        {name: 'vitaminK', value: food.vitaminK}
                    ];

                    var warningIngredients = foodIngredients.filter(function(ingredient) {
                        return ingredient.value !== 0 && foodIngredient.includes(ingredient.name);
                    }).map(function(ingredient) {
                        return ingredient.name;
                    });

                    console.log(warningIngredients);

                    if (warningIngredients.length > 0) {
                        showFoodInfo(foodName, warningIngredients.join(", "));
                    } else {
                        showFoodSafe(foodName);
                    }
                },
                error: function() {
                    alert("위험성분체크오류");
                }
            });
        }

        function getDrugSearchList(){
            $.ajax({
                type:"get",
                url:"${cpath}/board/drugSearchList",
                data : { memID: "${mvo.memID}"},
                success: function(result){
                    $('#drugSearchList').empty();
                    if(result.length >=1){
                        result.forEach(function(item){
                            var dList = "<tr>";
                            dList += "<td><a class='moveMyDrug' href='${cpath}/board/getMyDrug?id=" + item.id + "'>" + item.message + "</a></td>";
                            dList += "</tr>";
                            $('#drugsearchTable').append(dList);
                        });
                    }
                },
                error: function(){
                    alert("약검색리스트오류");
                }
            });
        }

        function showFoodInfo(foodName, warningIngredients) {
            var foodInfo = "음식 이름: " + foodName + "<br>유해 성분: " + warningIngredients
                + "<br>다른 음식을 섭취하시길 추천드립니다";
            $("#foodInfo").html(foodInfo);
            $("#foodModal .modal-body").removeClass('alert-success').addClass('alert-danger');
            $("#modal-type").text("경고");
            $("#foodModal").modal("show");
        }

        function showFoodSafe(foodName) {
            var foodInfo = "음식 이름: " + foodName + "<br>유해 성분이 없습니다. 안전하게 섭취하셔도 좋습니다.";
            $("#foodInfo").html(foodInfo);
            $("#foodModal .modal-body").removeClass('alert-danger').addClass('alert-success');
            $("#modal-type").text("안전");
            $("#foodModal").modal("show");
        }

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    var preview = document.getElementById('preview');
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                var preview = document.getElementById('preview');
                preview.src = "";
                preview.style.display = 'none';
            }
        }
    </script>
</head>
<body>
<div class="card">
    <div class="card-header">
        <div class="jumbotron jumbotron-fluid" style="cursor: pointer;" id="jumbotron" onclick="redirectBasedOnAuth()">
        <div class="container">
                <h1>DRUG-FOOD</h1>
                <p>Detection & Search</p>
            </div>
        </div>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-lg-2">
                <jsp:include page="left.jsp"/>
            </div>
            <div class="col-lg-8">
                <div id="root">
                    <h2 class="title">검색 결과</h2>
                    <hr>
                    <div class="row" style="display: flex; align-items: center; margin-top: 20px;">
                        <div class="col-lg-4" style="padding: 10px; display: flex; justify-content: center; align-items: center; height: 100%; overflow: hidden;">
                            <img src="data:image/jpeg;base64,${processedImage}" alt="Processed Image" style="width: 400px; height: auto;">
                        </div>
                        <div class="col-lg-8" style="padding: 10px;">
                            <h4>약 이름: ${flaskMessage}</h4>
                            <p>위험 성분: ${foodIngredient}</p>
                        </div>
                    </div>
                    <hr>
                    <div>
                        <button data-btn="list" class="btn btn-sm btn-info" onclick="redirectBasedOnAuth()" >돌아가기</button>
                    </div>
                </div>
                <!-- Modal -->
                <div class="modal fade" id="foodModal" tabindex="-1" role="dialog" aria-labelledby="foodModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 class="modal-title" id="modal-type">경고</h3>
                            </div>
                            <div class="modal-body">
                                <p id="foodInfo"></p>
                                <div class="text-right">
                                    <button type="button" class="btn btn-danger" data-dismiss="modal">닫기</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- end Modal -->
                <!-- Modal -->
                <div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h3 class="modal-title" id="loginModalLabel">로그인</h3>
                            </div>
                            <div class="modal-body">
                                <p id="loginInfo"></p>
                                <div class="text-right">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- end Modal -->
            </div>
            <div class="col-lg-2">
                <jsp:include page="right.jsp"/>
            </div>
        </div>
    </div>
    <div class="card-footer">똔똔</div>
</div>


</body>
</html>

