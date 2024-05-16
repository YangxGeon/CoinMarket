<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>CoinMarket</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
.navbar-brand {
	font-size: 24px;
	font-weight: bold;
}

.navbar-nav .nav-link {
	color: #ffffff;
}

.navbar-nav .nav-link:hover {
	color: #000000;
}

.news-item {
	border: 1px solid #ddd;
	padding: 15px;
	margin-bottom: 20px;
}
</style>
<script>
	function showLoader() {
		document.getElementById("loader").style.display = "block";
	}

	function hideLoader() {
		document.getElementById("loader").style.display = "none";
	}

	function loadLatestNews() {
		showLoader(); // 로딩 애니메이션 표시

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange = function() {
			if (this.readyState == 4 && this.status == 200) {
				hideLoader(); // 로딩 애니메이션 숨기기
				document.getElementById("news-container").innerHTML = this.responseText;
			}
		};
		xmlhttp.open("GET", "../jsp/latestNews.jsp", true);
		xmlhttp.send();
	}

	window.onload = function() {
		loadLatestNews(); // 페이지 로드 시 최신 뉴스 가져오기
		setInterval(loadLatestNews, 60000); // 1분마다 최신 뉴스 업데이트
	};
</script>
</head>
<body>
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="InitDisplay.jsp">CoinMarket</a>
			<ul class="navbar-nav me-auto">
				<li class="nav-item"><a class="nav-link"
					href="../address/gosignin.go">거래소</a></li>
				<li class="nav-item"><a class="nav-link"
					href="../address/gosignin.go">입출금</a></li>
				<li class="nav-item"><a class="nav-link"
					href="../address/gosignin.go">투자내역</a></li>
			</ul>
			<ul class="navbar-nav">
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
					role="button" data-bs-toggle="dropdown" aria-expanded="false">
						계정 </a>
					<ul class="dropdown-menu dropdown-menu-end bg-primary"
						aria-labelledby="navbarDropdown">
						<li><a class="dropdown-item text-dark"
							href="../address/gosignup.go">회원가입</a></li>
						<li><a class="dropdown-item text-dark"
							href="../address/gosignin.go">로그인</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>

	<div class="container-fluid p-5 bg-primary text-white text-center">
		<h1>CoinMarket</h1>
		<p>Welcome</p>
	</div>

	<div class="container mt-5">
		<h2 class="text-center mb-4">최신 뉴스</h2>
		<div class="row" id="news-container">
			<!-- Latest news -->
		</div>
	</div>
	<div id="loader" class="text-center mt-3" style="display: none;">
		<div class="spinner-border" role="status">
			<span class="visually-hidden">Loading...</span>
		</div>
		<div>Loading...</div>
	</div>

</body>
</html>

