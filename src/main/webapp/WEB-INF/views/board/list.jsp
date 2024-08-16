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
    <style>
        #camera-stream, #snapshot {
            width: 75%;
            height: auto;
        }
    </style>
    <script type="text/javascript">

        $(document).ready(function(){
            var result = '${result}';
            checkModal(result);

            getDrugSearchList();

            $("#regBtn").click(function(){
                location.href = "${cpath}/board/register";
            });

            // 파일 업로드 처리
            $("#file").on('change', function(){ // 값이 변경되면
                if (window.FileReader) { // modern browser
                    var filename = $(this)[0].files[0].name;
                } else { // old IE
                    var filename = $(this).val().split('/').pop().split('\\').pop(); // 파일명만 추출
                }
                // 추출한 파일명 삽입
                $(".upload-name").val(filename);
            });

            var memID = "${mvo.member.memID}";

            // 파일 업로드 버튼 클릭 시
            $("#fileUploadButton").on('click', function() {
                var file = $("#file")[0].files[0];
                console.log("memID before AJAX call: " + memID);
                if (file) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        var dataUrl = e.target.result;
                        $.ajax({
                            url: '${cpath}/board/uploadPhoto',
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ image: dataUrl , user_id: memID }),
                            success: function(response) {
                                window.location.href = '${cpath}/board/drugResult?image_id=' + encodeURIComponent(response.image_id);
                            },
                            error: function(error) {
                                console.error("Upload error:", error);
                            }
                        });
                    };
                    reader.readAsDataURL(file);
                }
            });

            // 웹캠 사진 찍기 및 업로드
            var video = document.getElementById('camera-stream');
            var canvas = document.getElementById('snapshot');
            var context = canvas.getContext('2d');
            var takePhotoButton = document.getElementById('take-photo');
            var uploadPhotoButton = document.getElementById('upload-photo');
            var retakePhotoButton = document.getElementById('retake-photo');
            var resultDiv = document.getElementById('result');

            function startVideoStream() {
                navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
                    video.srcObject = stream;
                    video.play();
                }).catch(function(error) {
                    console.error("Webcam error:", error);
                    resultDiv.innerHTML = '<p>웹캠 접근에 실패했습니다. 브라우저 설정을 확인하세요.</p>';
                });
            }

            function stopVideoStream() {
                let stream = video.srcObject;
                let tracks = stream.getTracks();
                tracks.forEach(function(track) {
                    track.stop();
                });
                video.srcObject = null;
            }

            startVideoStream();

            // 사진 찍기
            takePhotoButton.addEventListener('click', function() {
                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;
                context.drawImage(video, 0, 0, video.videoWidth, video.videoHeight);
                stopVideoStream();
                canvas.style.display = 'block';
                canvas.style.margin = '0 auto';
                video.style.display = 'none';
                uploadPhotoButton.style.display = 'inline-block';
                retakePhotoButton.style.display = 'inline-block';
            });

            // 웹캠 사진 업로드
            uploadPhotoButton.addEventListener('click', function() {
                var dataUrl = canvas.toDataURL('image/jpeg');
                $.ajax({
                    url: '${cpath}/board/uploadPhoto', // Spring Boot 컨트롤러 엔드포인트
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ image: dataUrl, user_id: memID }),
                    success: function(response) {
                        window.location.href = '${cpath}/board/drugResult?image_id=' + encodeURIComponent(response.image_id);
                    },
                    error: function(error) {
                        resultDiv.innerHTML = '<p>사진 업로드 실패</p>';
                        console.error("Upload error:", error);
                    }
                });
            });

            retakePhotoButton.addEventListener('click', function() {
                startVideoStream();
                canvas.style.display = 'none';
                video.style.display = 'block';
                uploadPhotoButton.style.display = 'none';
                retakePhotoButton.style.display = 'none'; // 다시 찍기 버튼 숨기기
            });
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
        <div class="jumbotron jumbotron-fluid">
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
                    <h2 class="title">약 검색</h2>
                    <hr>
                    <form id="fileUploadForm" method="POST" enctype="multipart/form-data">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="filebox" style="display: flex; align-items: center;">
                            <input class="upload-name" value="첨부파일" placeholder="첨부파일" disabled style="flex: 1; margin-right: 10px;">
                            <label for="file" style="margin: 0;">파일찾기</label>
                            <input type="file" id="file" name="file" onchange="readURL(this);" style="display: none;" />
                            <button type="button" class="btn btn-primary btn-sm" id="fileUploadButton" style="margin-left: 10px;">이미지로 검색</button>
                        </div>
                        <div style="margin-top: 20px; text-align: center;">
                            <img id="preview" style="max-width: 50%; margin-top: 10px; display: none; margin: 0 auto;">
                        </div>
                    </form>
                    <hr>
                    <div style="margin-top: 20px; text-align: center;">
                        <div>
                            <video id="camera-stream" autoplay style="display: block; margin: 0 auto;"></video>
                            <canvas id="snapshot" style="display: none; margin: 0 auto;"></canvas>
                        </div>
                        <div style="margin-top: 10px;">
                            <button id="take-photo" class="btn btn-primary">사진 찍기</button>
                            <button id="upload-photo" class="btn btn-success" style="display: none;">사진으로 검색</button>
                            <button id="retake-photo" class="btn btn-secondary" style="display: none;">다시 찍기</button>
                        </div>
                        <div id="result"></div>
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
