<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<div class="card" style="min-height: 500px;max-height: 1000px;">
    <div class="row">
        <div class="col-lg-12">
            <div class="card-body">
                <security:authorize access="isAnonymous()">
                    <h4 class="card-title">GUEST</h4>
                    <p class="card-text">회원님 환영합니다</p>
                    <form action="${cpath}/login/loginProcess" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="form-group">
                            <label for="memID">아이디:</label>
                            <input type="text" class="form-control" id="memID" name="username">
                        </div>
                        <div class="form-group">
                            <label for="memPwd">비밀번호:</label>
                            <input type="password" class="form-control" id="memPwd" name="password">
                        </div>
                        <button type="submit" class="btn btn-primary form-control">로그인</button>
                    </form>
                    <div style="margin-top: 10px;">
                        <form action="${cpath}/login/join">
                            <button type="submit" class="btn btn-outline-primary btn-block">회원가입</button>
                        </form>
                        <!--<a href="${cpath}/login/join"><button type="button" class="btn btn-outline-primary btn-block">회원가입</button></a>-->
                    </div>
                </security:authorize>
            </div>
        </div>
    </div>


</div>