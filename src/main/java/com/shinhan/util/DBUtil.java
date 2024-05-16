package com.shinhan.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

// DAO에서 사용하려고
public class DBUtil {

	// DBCONNECTIONPOOL DB연결
	public static Connection dbConnection() {
		Context initContext;
		Connection conn = null;
		try {
			initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			DataSource ds = (DataSource) envContext.lookup("jdbc/myoracle");
			conn = ds.getConnection(); // Connection Pooling(서버시작시 미리 connection을 만들어두고 관리)에서 connect 1개 얻기
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return conn;
	}

	// DB연결
	// static이니까 DBUtil은 new하지 않고 DBUtil.dbConnection으로 사용
	public static Connection dbConnection2() {
		// 1. JDBC DRIVER LOAD
		// 2. Connection 생성
		// Data SourceExplorer 에서 확인(안뜨면 java EE) NewOracle/properties/driverproperties
		// ip localhost 127.0.0.1
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String userid = "coin";
		String password = "coin";
		Connection conn = null;
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver"); // 클래스 메모리에 올리고
//			System.out.println("JDBC DRIVER LOAD");
			try {
				conn = DriverManager.getConnection(url, userid, password); // connection연결하고
			} catch (SQLException e) {
				e.printStackTrace();
			}
			// 2. Connection 생성

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
//		System.out.println("DB CONNECTION");
		return conn; // 오류가 없으면 연결을 리턴
	}

	// DB연결해제
	// connection, statement, resultset 모두 닫아줌
	public static void dbDisconnect(Connection conn, Statement st, ResultSet rs) {
		try {
			if (rs != null) {
				rs.close();
			}
			if (rs != null) {
				st.close();
			}
			if (rs != null) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
//		System.out.println("DB DISCONNECT");
	}
}
