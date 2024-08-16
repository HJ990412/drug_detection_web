<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="cpath" value="${pageContext.request.contextPath}"/>
<div class="card" style="min-height: 500px;max-height: 1000px;">
    <div class="card-body">
        <h4>Food Search</h4>
        <form class="form-inline" name="search-form" autocomplete="off">
            <div class="input-group mb-3">
                <input type="text" id="searchFood" class="form-control" name="searchFood" value="" readonly/>
                <div class="input-group-append">
                    <input type="button" class="btn btn-success" onclick="getSearchList()" value="Search"/>
                </div>
            </div>
            <div id="searchList" style="overflow: scroll; height: 500px; padding: 10px">
                <table class='table table-hover'>
                    <thead>
                        <tr>
                            <th>분류</th>
                            <th>음식</th>
                        </tr>
                    </thead>
                    <tbody id="searchTable">
                    </tbody>
                </table>
            </div>
        </form>
    </div>
</div>