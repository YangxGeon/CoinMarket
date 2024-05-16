<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>거래소</title>
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
		$().ready(btcQuote());
		$().ready(ethQuote());
		$().ready(xrpQuote());
		$().ready(dogeQuote());
		$().ready(showSellOrder('BTC'));
		$().ready(showMySellOrder());
		$().ready(showMySellOrderList());
		$().ready(myKrw());
		$().ready(f_myCoin());
		$("#order").on("click", f_order);
		$("#orderCancel").on("click", f_orderCancel);
		$("#BtnMyCoin").on("click", f_myCoin);
		$().ready(f_loginCheck());
	});
	
	function f_myCoin() {
		var sid = "${sid}";
		var coin = $("#myCoin").val();
		$.ajax({
			url : "../mycoin/mycoin.do",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			type : "get",
			success : function(responseData) {
				$("#myCoinResult").val(
						"보유 " + coin + " :  " + responseData + "개");
			},
			error : function(data) {
				alert("보유 BTC 조회 오류");
			}
		})
	}

	function f_orderCancel() {
		var sid = "${sid}";
		var cancelNum = $("#cancelNumView").val();
		$.ajax({
			url : "../order/cancel.do",
			type : "get",
			data : {
				"num" : cancelNum
			},
			success : function(responseData) {
				alert(sid + "님의 매도 취소주문이 처리되었습니다.");
				showMySellOrder();
				showMySellOrderList();
			},
			error : function(data) {
				alert(data);
			}
		})
	}

	function f_order() {
		var type = $("#orderType").val();
		var sid = "${sid}";
		var coinname = $("#coin").val();
		var price = $("#price").val();
		var quantity = $("#quantity").val();
		var orderNumber = $("#orderNumber").val();

		if (type == "sell") {
			$.ajax({
				url : "../order/sell.do",
				type : "get",
				data : {
					"sid" : sid,
					"name" : coinname,
					"price" : price,
					"quantity" : quantity
				},
				success : function(responseData) {
					if (responseData == 0) {
						alert("매수실패")
					} else {
						alert(sid + "님의 매도주문이 처리되었습니다.");
						showSellOrder(coinname);
						showMySellOrder(coinname);
						f_myCoin()
					}
				},
				error : function(data) {
					alert(data);
				}
			})
		} else if (type == "buy") {
			$.ajax({
				url : "../order/buy.do",
				type : "get",
				data : {
					"orderNum" : orderNumber,
					"sid" : sid,
					"quantity" : quantity,
					"name" : coinname
				},
				success : function(responseData) {
					if (responseData == 0) {
						alert("매수실패")
					} else {
						alert(sid + "님의 매수주문이 처리되었습니다.")
						showSellOrder(coinname);
						btcQuote();
						ethQuote();
						xrpQuote();
						dogeQuote();
						myKrw();
						f_myCoin()
					}
				},
				error : function(data) {
					alert(data);
				}
			})
		}

	}

	function myKrw() {
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

	function btcQuote() {
		$.ajax({
			url : "../coin/btcprice.do",
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#btcQuote").val(responseData + " KRW");
			},
			error : function(data) {
				alert("BTC 최근거래가 오류")
			}

		})
	}

	function ethQuote() {
		$.ajax({
			url : "../coin/ethprice.do",
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#ethQuote").val(responseData + " KRW");
			},
			error : function(data) {
				alert("ETH 최근거래가 오류")
			}

		})
	}
	
	function f_loginCheck(){
		var sid = "${sid}";
		if (sid==null || sid==""){
			location.href="../address/gosignin.go";
		}
	}
	function xrpQuote() {
		$.ajax({
			url : "../coin/xrpprice.do",
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#xrpQuote").val(responseData + " KRW");
			},
			error : function(data) {
				alert("XRP 최근거래가 오류")
			}

		})
	}
	function dogeQuote() {
		$.ajax({
			url : "../coin/dogeprice.do",
			type : "get",
			success : function(responseData) {
				responseData = responseData.replace(
						/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
				$("#dogeQuote").val(responseData + " KRW");
			},
			error : function(data) {
				alert("DOGE 최근거래가 오류")
			}

		})
	}

	function showMySellOrder() {
		var sid = "${sid}";
		$.ajax({
			url : "../order/myorder.do",
			type : "get",
			data : {
				"sid" : sid
			},
			success : function(responseData) {
				var sellOrders = $("#mySellOrders");
				sellOrders.empty();

				var table = $("<table>").addClass("table table-striped");
				var thead = $("<thead>").appendTo(table);
				var tbody = $("<tbody>").appendTo(table);
				var headerRow = $("<tr>").appendTo(thead);
				$("<th>").text("주문번호").appendTo(headerRow);
				$("<th>").text("코인명").appendTo(headerRow);
				$("<th>").text("수량").appendTo(headerRow);
				$("<th>").text("가격").appendTo(headerRow);

				$.each(responseData, function(index, order) {
					var row = $("<tr>").appendTo(tbody);
					$("<td>").text(order.order_num).appendTo(row);
					$("<td>").text(order.coin_name).appendTo(row);
					$("<td>").text(order.order_quantity).appendTo(row);
					var formattedPrice = order.order_price.toString().replace(
							/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
					$("<td>").text(formattedPrice).appendTo(row);

				});
				sellOrders.append(table);
			},
			error : function(data) {
				alert("에러 발생!");
			}
		});
	}

	function showSellOrder(coin) {
		var sid = "${sid}";
		$.ajax({
			url : "../order/select.do",
			type : "get",
			data : {
				"sid" : sid,
				"coin" : coin
			},
			success : function(responseData) {
				var sellOrders = $("#sellOrders");
				sellOrders.empty();
				sellOrders.append("<p>" + coin + " 주문 목록</p>");

				var table = $("<table>").addClass("table table-striped");
				var thead = $("<thead>").appendTo(table);
				var tbody = $("<tbody>").appendTo(table);
				var headerRow = $("<tr>").appendTo(thead);
				$("<th>").text("주문번호").appendTo(headerRow);
				$("<th>").text("코인명").appendTo(headerRow);
				$("<th>").text("수량").appendTo(headerRow);
				$("<th>").text("가격").appendTo(headerRow);

				$.each(responseData, function(index, order) {
					var row = $("<tr>").appendTo(tbody);
					$("<td>").text(order.order_num).appendTo(row);
					$("<td>").text(order.coin_name).appendTo(row);
					$("<td>").text(order.order_quantity).appendTo(row);
					var formattedPrice = order.order_price.toString().replace(
							/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ",");
					$("<td>").text(formattedPrice).appendTo(row);

				});

				sellOrders.append(table);
			},
			error : function(data) {
				alert("에러 발생!");
			}
		});
	}

	function showMySellOrderList() {
		var sid = "${sid}";
		$.ajax({
			url : "../order/myorder2.do",
			type : "get",
			data : {
				"sid" : sid
			},
			success : function(responseData) {
				var selectBox = $("#cancelNumView");
				selectBox.empty();

				$.each(responseData, function(index, order) {
					var option = $("<option>").val(order.order_num).text(
							order.order_num);
					selectBox.append(option);
				});
			},
			error : function(data) {
				alert("에러 발생!");
			}
		});
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

.card {
	margin-top: 20px;
}

.list-group-item.active {
	background-color: transparent;
	border-color: transparent;
}

#contents1 {
	margin-top: 60px;
}

.form-control[readonly] {
	background-color: #f8f9fa;
	text-align: center;
}

#myCoin {
	width: 180px; /* 너비 조정 */
}

.mya {
	text-decoration: none;
}

h5 {
	font-weight:bold;
}
</style>
</head>

<body>
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark fixed-top">
		<div class="container-fluid">
			<a class="navbar-brand" href="../address/main.do">CoinMarket</a>
			<ul class="navbar-nav me-auto">
				<li class="nav-item"><a class="nav-link" href="#">거래소</a></li>
				<li class="nav-item"><a class="nav-link"
					href="../address/gokrw.do">입출금</a></li>
				<li class="nav-item"><a class="nav-link" href="../address/goinvest.do">투자내역</a>

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

	<div class="container-fluid p-5 bg-primary text-white text-center"
		id="contents1">
		<h1>거래소</h1>
	</div>

	<div class="container mt-5">
		<div class="row">
			<div class="col-md-3">
				<div class="card">
					<div class="card-body">

						<h5 class="card-title">코인 검색</h5>
						<hr>
						<ul class="list-group">
							<li class="list-group-item"><img
								src="../static/images/btc.png" width="20" height="20"><a
								href="#" onclick="showSellOrder('BTC')" class="mya"> BTC</a></li>
							<li class="list-group-item"><img
								src="../static/images/eth.png" width="20" height="20"><a
								href="#" onclick="showSellOrder('ETH')" class="mya"> ETH</a></li>
							<li class="list-group-item"><img
								src="../static/images/xrp.png" width="20" height="20"><a
								href="#" onclick="showSellOrder('XRP')" class="mya"> XRP</a></li>
							<li class="list-group-item"><img
								src="../static/images/doge.png" width="20" height="20"><a
								href="#" onclick="showSellOrder('DOGE')" class="mya"> DOGE</a></li>
						</ul>
						<hr>
						<div class="card mt-3">
							<div class="card-body">
								<h5 class="card-title">최근 거래가</h5>
								<hr>
								<ul class="list-group">
									<li class="list-group-item">BTC <input id="btcQuote"
										readonly size="12" class="form-control" type="text"
										style="text-align: center"></li>
									<li class="list-group-item">ETH <input id="ethQuote"
										readonly size="12" class="form-control" type="text"
										style="text-align: center"></li>
									<li class="list-group-item">XRP <input id="xrpQuote"
										readonly size="12" class="form-control" type="text"
										style="text-align: center"></li>
									<li class="list-group-item">DOGE <input id="dogeQuote"
										readonly size="10" class="form-control" type="text"
										style="text-align: center"></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-6">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">주문 목록</h5>
						<hr>
						<div id="sellOrders">
							<!-- 주문 목록 -->
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-3">
				<div class="card">
					<div class="card-body">
						<h5 class="card-title">내 자산</h5>
						<hr>
						<ul class="list-group">

							<li class="list-group-item"><input id="myKrw" readonly
								class="form-control" type="text" style="text-align: center"></li>
							<li class="list-group-item"
								style="display: flex; align-items: center;"><label
								for="myCoin" class="form-label"></label> <select
								class="form-select" id="myCoin" style="margin-right: 5px;">
									<option value="BTC" selected>BTC</option>
									<option value="ETH">ETH</option>
									<option value="XRP">XRP</option>
									<option value="DOGE">DOGE</option>
							</select> <input type="button" class="btn btn-primary" id="BtnMyCoin"
								value="조회"></li>
							<li class="list-group-item"><input id="myCoinResult"
								readonly class="form-control" type="text"
								style="text-align: center"></li>
						</ul>
						<hr>
						<div class="card mt-3">
							<div class="card-body">
								<h5 class="card-title">주문</h5>
								<hr>
								<form id="orderForm">
									<div class="mb-3">
										<label for="orderType" class="form-label">주문 유형</label> <select
											class="form-select" id="orderType"
											onchange="toggleOrderForm()">
											<option value="buy">매수</option>
											<option value="sell">매도</option>
										</select>
									</div>
									<div class="mb-3" id="coinNameDiv" style="display: none;">
										<label for="coin" class="form-label">코인</label> <select
											class="form-select" id="coin">
											<option value="BTC">BTC</option>
											<option value="ETH">ETH</option>
											<option value="XRP">XRP</option>
											<option value="DOGE">DOGE</option>
										</select>
									</div>
									<div class="mb-3" id="orderNumberDiv" style="display: none;">
										<label for="orderNumber" class="form-label">주문번호</label> <input
											type="text" class="form-control" id="orderNumber">
									</div>
									<div class="mb-3" id="priceDiv" style="display: none;">
										<label for="price" class="form-label">가격</label> <input
											type="number" class="form-control" id="price">
									</div>
									<div class="mb-3" id="quantityDiv">
										<label for="quantity" class="form-label">수량</label> <input
											type="number" class="form-control" id="quantity">
									</div>
									<div class="d-flex justify-content-end">
										<input type="button" class="btn btn-primary" id="order"
											value="주문">
									</div>
								</form>
							</div>
						</div>

					</div>
				</div>
				<div class="card mt-3">
					<div class="card-body">
						<h5 class="card-title">나의 매도 주문</h5>
						<hr>
						<div id="mySellOrders">
							<!-- 나의 주문 목록 -->
						</div>
						<div class="row align-items-center">
							<div class="col-auto">
								<label for="cancelNumView" class="form-label"></label>
							</div>
							<div class="col">
								<select class="form-select" id="cancelNumView">
								</select>
							</div>
							<div class="col-auto">
								<input type="button" class="btn btn-primary" id="orderCancel"
									value="주문취소">
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
	</div>
</body>
<script>
	toggleOrderForm();
	function toggleOrderForm() {
		var orderType = document.getElementById('orderType').value;
		var coinNameDiv = document.getElementById('coinNameDiv');
		var orderNumberDiv = document.getElementById('orderNumberDiv');
		var priceDiv = document.getElementById('priceDiv');
		var coinSelect = document.getElementById('coin');
		var orderNumberInput = document.getElementById('orderNumber');
		var priceInput = document.getElementById('price');

		if (orderType === 'buy') {
			coinNameDiv.style.display = 'block';
			coinSelect.style.display = 'inline';
			orderNumberDiv.style.display = 'block';
			orderNumberInput.style.display = 'inline';
			priceDiv.style.display = 'none';
			priceInput.style.display = 'none';
		} else if (orderType === 'sell') {
			coinNameDiv.style.display = 'block';
			coinSelect.style.display = 'inline';
			orderNumberDiv.style.display = 'none';
			orderNumberInput.style.display = 'none';
			priceDiv.style.display = 'block';
			priceInput.style.display = 'inline';
		}
	}
</script>
</html>

