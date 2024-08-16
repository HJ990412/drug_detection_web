<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="${cpath}/resources/css/style.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">

        $(document).ready(function(){
            var result = '${result}';
            checkModal(result);

            $('#listBtn').click(function() {
                var formData = $("<form>", {
                    "method": "post",
                    "action": "${cpath}/board/list"
                });

                $("body").append(formData);
                formData.submit();
            });

            getDrugSearchList();

        });

        function getSearchList(){
            $.ajax({
                type: "get",
                url: "${cpath}/board/search",
                data: $("form[name=search-form]").serialize(),
                success: function(result){
                    $('#searchTable').empty();
                    if(result.length >= 1){
                        result.forEach(function(item){
                            var sList = "<tr>";
                            sList += "<td>" + item.foodCategory + "</td>";
                            sList += "<td>" + item.foodName + "<td>";
                            sList += "</tr>";
                            $('#searchTable').append(sList);
                        });
                    }
                },
                error : function(){alert("error");}
            });
        }

        function getDrugSearchList(){
            $.ajax({
                type:"get",
                url:"${cpath}/board/drugSearchList",
                data : { memID: "${mvo.member.memID}"},
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
                    alert("error");
                }
            });
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

        function checkModal(result) {
            if(result==''){
                return;
            }
            if(parseInt(result)>0){
                // 새로운 다이얼로그 창 띄우기
                $(".modal-body").html("게시글 "+parseInt(result)+"번 등록");
            }
            $("#myModal").modal("show");
        }
    </script>
</head>
<body>
<div class="card">
    <div class="card-header">
        <div class="jumbotron jumbotron-fluid" style="cursor: pointer;" onclick="location.href='${cpath}/board/list'">
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
                <div class="container">
                    <h2>회원 목록</h2>
                    <c:if test="${not empty msg}">
                        <div class="alert alert-${msgType}">${msg}</div>
                    </c:if>
                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>이름</th>
                            <th>권한</th>
                            <th>삭제</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="member" items="${members}">
                            <tr>
                                <td>${member.memID}</td>
                                <td>${member.memName}</td>
                                <td>
                                    <c:forEach var="auth" items="${member.authList}">
                                        ${auth.auth}<br/>
                                    </c:forEach>
                                </td>
                                <td>
                                    <form action="${cpath}/admin/deleteMember" method="post">
                                        <input type="hidden" name="memID" id="memID" value="${member.memID}">
                                        <c:choose>
                                            <c:when test="${fn:contains(member.authList, 'ROLE_ADMIN')}">
                                                <button type="submit" class="btn btn-danger" disabled>삭제</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="submit" class="btn btn-danger">삭제</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <div>
                        <button data-btn="list" class="btn btn-sm btn-info" id="listBtn">돌아가기</button>
                    </div>
                </div>
                <!-- Modal -->
                <div id="myModal" class="modal fade" role="dialog">
                    <div class="modal-dialog">
                        <!-- Modal content-->
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title">Message</h4>
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                            <div class="modal-body">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
