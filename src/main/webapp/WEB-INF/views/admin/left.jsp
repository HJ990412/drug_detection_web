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
                <security:authorize access="isAuthenticated()">
                    <h4 class="card-title">${mvo.member.memName}</h4>
                    <p class="card-text"> 회원님 환영합니다</p>
                    <a href="${cpath}/logout">
                        <button type="submit" class="btn btn-primary form-control">로그아웃</button>
                    </a>
                    <security:authorize access="hasRole('ROLE_ADMIN')">
                        <div style="margin-top: 10px;">
                            <button type="submit" class="btn btn-outline-primary btn-block">회원 관리</button>
                        </div>
                    </security:authorize>
                    <div class="row">
                        <div class="col-lg-12" style="overflow: scroll; margin-top: 15px; height: 500px; padding: 10px">
                                <p class="card-text">검색 기록</p>
                                <form name="drugsearch-form">
                                    <input type="hidden" name="memID" value="${mvo.member.memID}"/>
                                </form>
                                <table id="drugsearchTable" class="table">
                                    <tbody>
                                    <!-- 검색 결과가 여기에 추가됩니다 -->
                                    </tbody>
                                </table>
                        </div>
                    </div>
                </security:authorize>
            </div>
        </div>
    </div>


</div>