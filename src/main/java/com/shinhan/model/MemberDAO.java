package com.shinhan.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.shinhan.dto.MemberDTO;
import com.shinhan.util.DBUtil;

public class MemberDAO {
	Connection conn;
	Statement st;
	ResultSet rs;
	PreparedStatement pst;

	// 회원가입
	public int joinMember(MemberDTO mem) {
		int result = 0;
		String sql = "INSERT INTO MEMBERS VALUES (?,?,?,0)";
		conn = DBUtil.dbConnection();
		try {
			pst = conn.prepareStatement(sql);
			pst.setString(1, mem.getMember_id());
			pst.setString(2, mem.getMember_pw());
			pst.setString(3, mem.getMember_name());
			result = pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
			;
		}
		return result;
	}

	// 로그인
	public boolean login(String id, String pw) {
		boolean loginSuccessful = false;
		String sql = "SELECT MEMBER_NAME FROM MEMBERS WHERE MEMBER_ID = ? AND MEMBER_PW = ?";
		conn = DBUtil.dbConnection();
		try {
			pst = conn.prepareStatement(sql);
			pst.setString(1, id);
			pst.setString(2, pw);
			rs = pst.executeQuery();
			if (rs.next()) {
				loginSuccessful = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
		return loginSuccessful;
	}

	// KRW 입금
	public int deposit(int money, String session) {
		int result = 0;
		String sql = "UPDATE MEMBERS SET MEMBER_KRW = MEMBER_KRW + ? WHERE MEMBER_ID = ?";
		conn = DBUtil.dbConnection();
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, money);
			pst.setString(2, session);
			result = pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
		return result;
	}

	// KRW 출금
	public int withdraw(int money, String session) {
		int result = 0;
		String sql = "UPDATE MEMBERS SET MEMBER_KRW = MEMBER_KRW - ? WHERE MEMBER_ID = ?";
		conn = DBUtil.dbConnection();
		try {
			pst = conn.prepareStatement(sql);
			pst.setInt(1, money);
			pst.setString(2, session);
			result = pst.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
		return result;
	}

	// KRW 조회
	public int balance(String session) {
		int result = 0;
		String sql = "SELECT MEMBER_KRW FROM MEMBERS WHERE MEMBER_ID= ?";
		conn = DBUtil.dbConnection();
		try {
			pst = conn.prepareStatement(sql);
			pst.setString(1, session);
			rs = pst.executeQuery();
			if (rs.next()) {
				result = rs.getInt("MEMBER_KRW");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DBUtil.dbDisconnect(conn, pst, rs);
		}
		return result;
	}
}
