package com.shinhan.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.shinhan.dto.CoinDTO;
import com.shinhan.util.DBUtil;

public class CoinDAO {
	Connection conn;
	Statement st;
	ResultSet rs;
	PreparedStatement pst;

	// 코인 이름, 코인 최근 거래가 조회
	public List<CoinDTO> CurrentCoin() {
		List<CoinDTO> coinlist = new ArrayList<CoinDTO>();
		String sql = "SELECT COIN_NAME, COIN_PRICE FROM COINS";

		conn = DBUtil.dbConnection();
		try {
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			while (rs.next()) {
				CoinDTO coin = makeCoin(rs);
				coinlist.add(coin);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, st, rs);
		}
		return coinlist;

	}

	private CoinDTO makeCoin(ResultSet rs) throws SQLException {
		CoinDTO coin = new CoinDTO();

		coin.setCoin_name(rs.getString("COIN_NAME"));
		coin.setCoin_price(rs.getInt("COIN_PRICE"));

		return coin;

	}
}
