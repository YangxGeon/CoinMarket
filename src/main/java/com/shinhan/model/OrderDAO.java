package com.shinhan.model;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.shinhan.dto.OrderDTO;
import com.shinhan.util.DBUtil;

public class OrderDAO {
	Connection conn;
	Statement st;
	ResultSet rs;
	PreparedStatement pst;

	// 매도주문 등록
	public void insertSellOrderAndUpdateMyCoin(String session, String coinName, int quantity, int price) {
		conn = DBUtil.dbConnection();
		try {
			conn.setAutoCommit(false);
			// 매도 주문 등록
			String insertOrderSql = "INSERT INTO ORDERS (MEMBER_ID, ORDER_TYPE, ORDER_QUANTITY, ORDER_PRICE, ORDER_TIME, COIN_NAME)"
					+ " VALUES (?, 'SELL', ?, ?, SYSDATE, ?) ";
			pst = conn.prepareStatement(insertOrderSql);
			pst.setString(1, session);
			pst.setInt(2, quantity);
			pst.setInt(3, price);
			pst.setString(4, coinName);
			pst.executeUpdate();
			// 코인 보유량 감소
			String updateCoinSql = "UPDATE MYCOINS SET MY_QUANTITY = MY_QUANTITY - ? WHERE MEMBER_ID = ? AND COIN_NAME = ?";
			pst = conn.prepareStatement(updateCoinSql);
			pst.setInt(1, quantity);
			pst.setString(2, session);
			pst.setString(3, coinName);
			pst.executeUpdate();

			conn.commit();
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
	}
	// 나의 매도주문조회
	public List<OrderDTO> MySellOrder(String session){
		List<OrderDTO> orderlist = new ArrayList<OrderDTO>();
		String sql = "SELECT * FROM ORDERS WHERE MEMBER_ID = '"+ session+"'";
		conn = DBUtil.dbConnection();
		try {
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			while(rs.next()) {
				OrderDTO order = makeOrder(rs);
				orderlist.add(order);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, st, rs);
		}
		return orderlist;
	}
	
	// 매도주문 취소
	public void CancelMyOrder(int orderNum) {
	    String coinName;
	    int quantity;
	    String orderInfoSql = "SELECT COIN_NAME, ORDER_QUANTITY FROM ORDERS WHERE ORDER_NUM = ?";
	    String deleteOrderSql = "DELETE FROM ORDERS WHERE ORDER_NUM = ?";
	    String updateQuantitySql = "UPDATE MYCOINS SET MY_QUANTITY = MY_QUANTITY + ? WHERE COIN_NAME = ?";
	    
	    conn = DBUtil.dbConnection();

	    try {
	        conn.setAutoCommit(false);
	        
	        pst = conn.prepareStatement(orderInfoSql);
	        pst.setInt(1, orderNum);
	        rs = pst.executeQuery();

	        if (rs.next()) {
	            coinName = rs.getString("COIN_NAME");
	            quantity = rs.getInt("ORDER_QUANTITY");

	            pst = conn.prepareStatement(deleteOrderSql);
	            pst.setInt(1, orderNum);
	            pst.executeUpdate();

	            pst = conn.prepareStatement(updateQuantitySql);
	            pst.setInt(1, quantity);
	            pst.setString(2, coinName);
	            pst.executeUpdate();

	            conn.commit();
	        } else {
	            System.out.println("주문을 찾을 수 없습니다.");
	        }
	    } catch (SQLException e) {
	        try {
	            conn.rollback(); // 롤백
	        } catch (SQLException ex) {
	            ex.printStackTrace();
	        }
	        e.printStackTrace();
	    } finally {
	        DBUtil.dbDisconnect(conn, pst, rs);
	    }
	}

	// 매도주문 조회
	public List<OrderDTO> sellSelectAll(String session, String selectCoin) {
		List<OrderDTO> orderlist = new ArrayList<OrderDTO>();
		String sql = "select * from ORDERS where COIN_NAME = '" + selectCoin + "' AND MEMBER_ID != '" + session
				+ "' ORDER BY ORDER_PRICE";
		conn = DBUtil.dbConnection();
		try {
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			while (rs.next()) {
				OrderDTO order = makeOrder(rs);
				orderlist.add(order);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, st, rs);
		}
		return orderlist;

	}

	// 매수주문 처리
	public void insertOrder(int orderNum, String session, int quantity, String coinName) {
		conn = DBUtil.dbConnection();
		CallableStatement cstmt = null;
		try {
			String sql = "{call process_buy_order_proc(?, ?, ?, ?)}";
			cstmt = conn.prepareCall(sql);
			cstmt.setInt(1, orderNum);
			cstmt.setString(2, session);
			cstmt.setInt(3, quantity);
			cstmt.setString(4, coinName);
			cstmt.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, cstmt, null);
		}
	}

	private OrderDTO makeOrder(ResultSet rs2) throws SQLException {
		OrderDTO order = new OrderDTO();

		order.setOrder_num(rs.getInt("ORDER_NUM"));
		order.setMember_id(rs.getString("MEMBER_ID"));
		order.setCoin_name(rs.getString("COIN_NAME"));
		order.setOrder_price(rs.getInt("ORDER_PRICE"));
		order.setOrder_quantity(rs.getInt("ORDER_QUANTITY"));
		order.setOrder_type(rs.getString("ORDER_TYPE"));
		order.setOrder_time(rs.getDate("ORDER_TIME"));
		return order;
	}

}
