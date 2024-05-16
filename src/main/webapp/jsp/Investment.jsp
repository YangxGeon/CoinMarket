<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>투자내역</title>
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
		$().ready(f_myKrw());
		$().ready(f_btc());
		$().ready(f_btcp());
		$().ready(f_eth());
		$().ready(f_ethp());
		$().ready(f_xrp());
		$().ready(f_xrpp());
		$().ready(f_doge());
		$().ready(f_dogep());
		$().ready(f_holding());
		$().ready(f_loginCheck());
	});
	
	function f_myKrw() {
		var sid = "${sid}";
		$.ajax({
			url : "../member/balance.do",
			data : {
				"sid" : sid
			},
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#myKrw").val(responseData + " KRW");
			},
			error : function(data) {
				alert("조회실패");
			}
		})
	}

	function f_btc() {
		var sid = "${sid}";
		var coin = "BTC";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "get",
			success : function(responseData) {
				$("#myBtc").val(responseData);
			},
			error : function(data) {
				alert("보유 BTC 조회 오류");
			}
		})
	}
	function f_btcp() {
		var sid = "${sid}";
		var coin = "BTC";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "post",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#myBtcM").val(responseData + " KRW");
			},
			error : function(data) {
				alert("BTC 평가 오류")
			}
		})
	}

	function f_eth() {
		var sid = "${sid}";
		var coin = "ETH";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "get",
			success : function(responseData) {
				$("#myEth").val(responseData);
			},
			error : function(data) {
				alert("보유 ETH 조회 오류");
			}
		})
	}
	function f_ethp() {
		var sid = "${sid}";
		var coin = "ETH";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "post",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#myEthM").val(responseData + " KRW");
			},
			error : function(data) {
				alert("ETH 평가 오류")
			}
		})
	}
	function f_xrp() {
		var sid = "${sid}";
		var coin = "XRP";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "get",
			success : function(responseData) {
				$("#myXrp").val(responseData);
			},
			error : function(data) {
				alert("보유 ETH 조회 오류");
			}
		})
	}
	function f_xrpp() {
		var sid = "${sid}";
		var coin = "XRP";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "post",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#myXrpM").val(responseData + " KRW");
			},
			error : function(data) {
				alert("ETH 평가 오류")
			}
		})
	}
	function f_loginCheck(){
		var sid = "${sid}";
		if (sid==null || sid==""){
			location.href="../address/gosignin.go";
		}
	}

	function f_doge() {
		var sid = "${sid}";
		var coin = "DOGE";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "get",
			success : function(responseData) {
				$("#myDoge").val(responseData);
			},
			error : function(data) {
				alert("보유 ETH 조회 오류");
			}
		})
	}
	function f_dogep() {
		var sid = "${sid}";
		var coin = "DOGE";
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "post",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#myDogeM").val(responseData + " KRW");
			},
			error : function(data) {
				alert("ETH 평가 오류")
			}
		})
	}

	function f_holding() {
		var sid = "${sid}";
		$.ajax({
			url : "../mycoin/mytotal.do",
			data : {
				"sid" : sid
			},
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#holding").val(responseData + " KRW");
			},
			error : function(data) {
				alert("총 평가 오류")
			}
		})
	}

	function comma(num) {
		return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
</script>
<style>
        body {
            padding-top: 60px;
            background-color: #f8f9fa;
        }

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

        .card {
            margin-bottom: 20px;
        }

        .card-title {
            margin-bottom: 15px;
        }

        .form-control[readonly] {
            background-color: #f8f9fa;
            text-align: center;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-sm bg-primary navbar-dark fixed-top">
        <div class="container-fluid">
            <a class="navbar-brand" href="../address/main.do">CoinMarket</a>
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="../address/gomarket.do">거래소</a></li>
                <li class="nav-item"><a class="nav-link" href="../address/gokrw.do">입출금</a></li>
                <li class="nav-item"><a class="nav-link" href="#">투자내역</a></li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="#"><%=(String) session.getAttribute("sid")%>님</a></li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        계정
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end bg-primary" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item text-dark" href="../member/signout.do">로그아웃</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container-fluid p-5 bg-primary text-white text-center" id="contents1">
        <h1>투자내역</h1>
        <p>최근 코인거래가가 시세로 실시간 반영됩니다.</p>
    </div>

    <div class="container mt-5">
        <div class="row row-cols-1 row-cols-md-2 g-4 justify-content-center">
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">보유 KRW</h5>
                        <input type="text" id="myKrw" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">총 보유자산</h5>
                        <input type="text" id="holding" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">보유 BTC 수량</h5>
                        <input type="text" id="myBtc" class="form-control" readonly>
                        <hr>
                        <h5 class="card-title">총 평가</h5>
                        <input type="text" id="myBtcM" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">보유 ETH 수량</h5>
                        <input type="text" id="myEth" class="form-control" readonly>
                        <hr>
                        <h5 class="card-title">총 평가</h5>
                        <input type="text" id="myEthM" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">보유 XRP 수량</h5>
                        <input type="text" id="myXrp" class="form-control" readonly>
                        <hr>
                        <h5 class="card-title">총 평가</h5>
                        <input type="text" id="myXrpM" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card">
                    <div class="card-body text-center">
                        <h5 class="card-title">보유 DOGE 수량</h5>
                        <input type="text" id="myDoge" class="form-control" readonly>
                        <hr>
                        <h5 class="card-title">총 평가</h5>
                        <input type="text" id="myDogeM" class="form-control" readonly>
                    </div>
                </div>
            </div>
            
        </div>
    </div>
</body>
</html>
