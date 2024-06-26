<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        $(document).ready(function(){
            if(${!empty msgType}){
                $("#messageType").attr("class","modal-content panel-warning");
                $("#myMessage").modal("show");
            }
        });
        function registerCheck(){
            var memID=$("#memID").val();
            $.ajax({
                url : "${cpath}/login/memRegisterCheck",
                type : "get",
                data : { "memID" : memID},
                success : function(result){
                    // 중복유무 출력 ( result=1 사용가능)
                    if(result==1){
                        $("#checkMessage").html("사용할 수 있는 아이디입니다.");
                        $("#checkType").attr("class","modal-content panel-success");
                    }else{
                        $("#checkMessage").html("사용할 수 없는 아이디입니다.");
                        $("#checkType").attr("class","modal-content panel-warning");
                    }
                    $("#myModal").modal("show");
                },
                error : function(){alert("error");}
            });
        }
        function passwordCheck(){
            var memPwd1=$("#memPwd1").val();
            var memPwd2=$("#memPwd2").val();
            if(memPwd1 != memPwd2){
                $("#passMessage").html("비밀번호가 서로 일치하지 않음");
            }else{
                $("#passMessage").html("");
                $("#memPwd").val(memPwd1);
            }
        }
        function goInsert(){
            document.frm.submit();
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
                <form name="frm" action="${cpath}/login/memRegister" method="post">
                    <input type="hidden" id="memPwd" name="memPwd" value="">
                    <table class="table table-bordered" style="text-align: center; boarder: 1px solid #dddddd;">
                        <tr>
                            <td style="width: 110px; vertical-align: middle;">아이디</td>
                            <td><input id="memID" name="memID" class="form-control" type="text" maxlength="20" placeholder="아이디를 입력하세요"/></td>
                            <td style="width: 110px;"><button type="button" class="btn btn-primary btn-sm" onclick="registerCheck()">중복확인</button></td>
                        </tr>
                        <tr>
                            <td style="width: 110px; vertical-align: middle;">비밀번호</td>
                            <td colspan="2"><input id="memPwd1" name="memPwd1" onkeyup="passwordCheck()" class="form-control" type="password" maxlength="20" placeholder="비밀번호를 입력하세요"/></td>
                        </tr>
                        <tr>
                            <td style="width: 110px; vertical-align: middle;">비밀번호 확인</td>
                            <td colspan="2"><input id="memPwd2" name="memPwd2" onkeyup="passwordCheck()" class="form-control" type="password" maxlength="20" placeholder="비밀번호를 확인하세요"/></td>

                        </tr>
                        <tr>
                            <td style="width: 110px; vertical-align: middle;">사용자 이름</td>
                            <td colspan="2"><input id="memName" name="memName" class="form-control" type="text" maxlength="20" placeholder="이름을 입력하세요"/></td>
                        </tr>
                        <tr>
                            <td colspan="3" style="text-align:left;">
                                <span id="passMessage" style="color: red"></span><input type="button" class="btn btn-primary btn-sm pull-right" value="등록" onclick="goInsert()"/>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="col-lg-2">
                <jsp:include page="right.jsp"/>
            </div>
        </div>
    </div>
    <!-- 다이얼로그창(모달) -->
    <!-- Modal -->
    <div id="myModal" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div id="checkType" class="modal-content panel-info">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">메세지 확인</h4>
                </div>
                <div class="modal-body">
                    <p id="checkMessage"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>

        </div>
    </div>
    <!-- 실패 메세지를 출력 -->
    <div id="myMessage" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div id="messageType" class="modal-content panel-info">
                <div class="modal-header panel-heading">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <p>${msg}</p>
                </div>
            </div>

        </div>
    </div>
    <div class="card-footer">똔똔</div>
</div>


</body>
</html>

