package com.shinhan.model;

import java.util.List;

import com.shinhan.dto.OrderDTO;

public class OrderService {
	OrderDAO orderDAO = new OrderDAO();

	// 매도주문
	public void insertSellOrderAndUpdateMyCoin(String session, String coinName, int quantity, int price) {
		orderDAO.insertSellOrderAndUpdateMyCoin(session, coinName, quantity, price);
	}
	
	// 나의 매도주문조회
	public List<OrderDTO> MySellOrder(String session){
		return orderDAO.MySellOrder(session);
	}
	
	// 매도주문취소
	public void CancelMyOrder(int orderNum) {
		orderDAO.CancelMyOrder(orderNum);
	}

	// 매도주문조회
	public List<OrderDTO> sellSelectAll(String session, String selectCoin) {
		return orderDAO.sellSelectAll(session, selectCoin);
	}

	// 매수
	public void insertOrder(int orderNum, String session, int quantity, String coinName) {
		orderDAO.insertOrder(orderNum, session, quantity, coinName);
	}

}