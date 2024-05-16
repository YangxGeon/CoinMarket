<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>로그인</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="../jsp/InitDisplay.jsp">CoinMarket</a>
			<ul class="navbar-nav">
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
					role="button" data-bs-toggle="dropdown" aria-expanded="false">
						계정 </a>
					<ul class="dropdown-menu dropdown-menu-end bg-primary"
						aria-labelledby="navbarDropdown">
						<li><a class="dropdown-item text-dark"
							href="../member/gosignup.do">회원가입</a></li>
						<li><a class="dropdown-item text-dark"
							href="../member/gosignin.do">로그인</a></li>
					</ul></li>
			</ul>
		</div>

	</nav>
	<div class="container mt-3">
		<h2>Sign in</h2>
		<form action="../member/signin.do" method="post">
			<div class="mb-3 mt-3">
				<label for="text">ID:</label> <input type="text"
					class="form-control" id="memid" placeholder="Enter ID"
					name="memberid" autofocus>
			</div>
			<div class="mb-3">
				<label for="pwd">PW:</label> <input type="password"
					class="form-control" id="mempw" placeholder="Enter password"
					name="memberpw">
			</div>
			<div class="form-check mb-3">
				<label class="form-check-label"> <input
					class="form-check-input" type="checkbox" name="remember">
					Remember me
				</label>
			</div>
			<button type="submit" class="btn btn-primary">로그인</button>${message}
		</form>
	</div>

</body>
</html>