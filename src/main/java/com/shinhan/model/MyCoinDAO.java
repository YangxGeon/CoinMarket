package com.shinhan.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.shinhan.dto.MyCoinDTO;
import com.shinhan.util.DBUtil;

public class MyCoinDAO {
	Connection conn;
	Statement st;
	ResultSet rs;
	PreparedStatement pst;

	// 나의 코인 전체정보 조회
	public List<MyCoinDTO> getMyCoins(String session) {
		List<MyCoinDTO> myCoins = new ArrayList<>();
		conn = DBUtil.dbConnection();
		try {
			conn = DBUtil.dbConnection();
			String sql = "SELECT MYCOINS.COIN_NAME, MYCOINS.MY_QUANTITY, COINS.COIN_PRICE, COINS.COIN_PRICE * MYCOINS.MY_QUANTITY AS TOTAL_VALUE"
					+ " FROM MYCOINS JOIN COINS ON MYCOINS.COIN_NAME = COINS.COIN_NAME"
					+ " WHERE MYCOINS.MEMBER_ID = ?";
			pst = conn.prepareStatement(sql);
			pst.setString(1, session);
			rs = pst.executeQuery();

			while (rs.next()) {
				MyCoinDTO myCoinDTO = new MyCoinDTO();
				myCoinDTO.setCoin_name(rs.getString("COIN_NAME"));
				myCoinDTO.setMy_quantity(rs.getInt("MY_QUANTITY"));
				myCoinDTO.setCoin_price(rs.getInt("COIN_PRICE"));
				myCoinDTO.setTotal_value(rs.getInt("TOTAL_VALUE"));
				myCoins.add(myCoinDTO);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
		return myCoins;
	}

	// 나의 코인보유량 조회
	public int getMyCoinQuantity(String session, String coinName) {
	    int quantity = 0;
	    String sql = "SELECT MY_QUANTITY FROM MYCOINS WHERE MEMBER_ID = ? AND COIN_NAME = ?";
	    
	    try {
	        conn = DBUtil.dbConnection();
	        pst = conn.prepareStatement(sql);
	        pst.setString(1, session);
	        pst.setString(2, coinName);
	        rs = pst.executeQuery();
	        
	        if (rs.next()) {
	            quantity = rs.getInt("MY_QUANTITY");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        DBUtil.dbDisconnect(conn, pst, rs);
	    }
	    
	    return quantity;
	}

}
