<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>KRW 입출금</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function() {
		$("#balance").ready(f_balance());
		$("#deposit").on("click", f_deposit);
		$("#withdraw").on("click", f_withdraw);
		$().ready(f_loginCheck());
	});

	function f_balance() {
		var sid = "${sid}";
		$.ajax({
			url : "../member/balance.do",
			data : {
				"sid" : sid
			},
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#balanceAmount").val(responseData + " KRW");
			},
			error : function(data) {
				alert("조회실패");
			}
		})
	}

	function f_deposit() {
		var sid = "${sid}";
		var money = $("#depositAmount").val();
		if (money <= 0) {
			alert("금액을 입력하세요")
		} else {
			$.ajax({
				url : "../member/deposit.do",
				data : {
					"sid" : sid,
					"money" : money
				},
				type : "get",
				success : function(responseData) {
					if (responseData == 1) {
						alert(money + "KRW 입금완료")
						f_balance();
					} else {
						alert("입금실패")
					}
				},
				error : function(data) {
					alert("입금오류")
				}
			})
		}
	}

	function f_withdraw() {
		var sid = "${sid}";
		var money = $("#withdrawAmount").val();
		if (money <= 0){
			alert("금액을 입력하세요")
		} else {
		$.ajax({
			url : "../member/withdraw.do",
			data : {
				"sid" : sid,
				"money" : money
			},
			type : "get",
			success : function(responseData) {
				if (responseData == 1) {
					alert(money + "KRW 출금완료")
					f_balance();
				} else {
					alert("입금실패")
				}
			},
			error : function(data) {
				alert("금액을 입력하세요")
			}
		})
		}
	}
	
	function f_loginCheck(){
		var sid = "${sid}";
		if (sid==null || sid==""){
			location.href="../address/gosignin.go";
		}
	}
</script>
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

.form-control {
	
}

.btn-group {
	margin-top: 10px;
}

.card {
	margin-top: 20px;
}
.form-control[readonly] {
            background-color: #f8f9fa;
            text-align: center;
        }
</style>
</head>
<body>
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="../address/main.do">CoinMarket</a>
			<ul class="navbar-nav me-auto">
				<li class="nav-item"><a class="nav-link"
					href="../address/gomarket.do">거래소</a></li>
				<li class="nav-item"><a class="nav-link" href="#">입출금</a></li>
				<li class="nav-item"><a class="nav-link"
					href="../address/goinvest.do">투자내역</a></li>
			</ul>
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link" href="#"><%=(String) session.getAttribute("sid")%>님</a>
				</li>
				<li class="nav-item dropdown"><a
					class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
					role="button" data-bs-toggle="dropdown" aria-expanded="false">
						계정 </a>
					<ul class="dropdown-menu dropdown-menu-end bg-primary"
						aria-labelledby="navbarDropdown">
						<li><a class="dropdown-item text-dark"
							href="../member/signout.do">로그아웃</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>

	<div class="container-fluid p-5 bg-primary text-white text-center">
		<h1>KRW 입출금</h1>
	</div>

	<div class="container mt-5">
		<div class="row justify-content-center">
			<div class="col-md-6">
				<div class="card">
					<div class="card-body">
						<div class="input-group mb-3">
						<input class="btn btn-primary" value="나의 KRW" readonly>
							<input type="text" class="form-control" id="balanceAmount"
								placeholder="나의 KRW 조회" readonly> 
						</div>
						<div class="input-group mb-3">
							<input type="number" class="form-control" id="depositAmount"
								placeholder="입금할 금액" autofocus> <input type="button" id="deposit"
								class="btn btn-primary" value="입금">
						</div>
						<div class="input-group mb-3">
							<input type="number" class="form-control" id="withdrawAmount"
								placeholder="출금할 금액"> <input type="button" id="withdraw"
								class="btn btn-primary" value="출금">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
