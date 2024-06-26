<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<div class="card" style="min-height: 500px;max-height: 1000px;">
    <div class="row">
        <div class="col-lg-12">
            <div class="card-body">
                <c:if test="${empty mvo}">
                    <h4 class="card-title">GUEST</h4>
                    <p class="card-text">회원님 환영합니다</p>
                    <form action="${cpath}/login/loginProcess" method="post">
                        <div class="form-group">
                            <label for="memID">아이디:</label>
                            <input type="text" class="form-control" name="memID">
                        </div>
                        <div class="form-group">
                            <label for="memPwd">비밀번호:</label>
                            <input type="password" class="form-control" name="memPwd">
                        </div>
                        <button type="submit" class="btn btn-primary form-control">로그인</button>
                    </form>
                    <div style="margin-top: 10px;">
                        <form action="${cpath}/login/join">
                            <button type="submit" class="btn btn-outline-primary btn-block">회원가입</button>
                        </form>
                        <!--<a href="${cpath}/login/join"><button type="button" class="btn btn-outline-primary btn-block">회원가입</button></a>-->
                    </div>
                </c:if>
                <c:if test="${!empty mvo}">
                    <h4 class="card-title">${mvo.memName}</h4>
                    <p class="card-text"> 회원님 환영합니다</p>
                    <form action="${cpath}/login/logoutProcess" method="post">
                        <button type="submit" class="btn btn-primary form-control">로그아웃</button>
                    </form>
                    <div class="row">
                        <div class="col-lg-12" style="overflow: scroll; margin-top: 15px; height: 500px; padding: 10px">
                                <p class="card-text">검색 기록</p>
                                <form name="drugsearch-form">
                                    <input type="hidden" name="memID" value="${mvo.memID}"/>
                                </form>
                                <table id="drugsearchTable" class="table">
                                    <tbody>
                                    <!-- 검색 결과가 여기에 추가됩니다 -->
                                    </tbody>
                                </table>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>


</div>