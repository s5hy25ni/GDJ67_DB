package com.min.edu.comm;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


/**
 * JDBC 6단계 중
 * 공통적으로 사용하는 1단계, 2단계, 6단계는 자식의 클래스에서 반복되기 때문에
 * 부모 클래스로 만들어 코드의 재활용성 동작
 * 반드시 누군가의 부모 클래스가 되어야 함 -> abstract
 */
public abstract class DataBase {
	public DataBase() {
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("1단계 드라이버 로딩 성공");
		} catch (ClassNotFoundException e) {
			System.out.println("1단계 드라이버 로딩 실패");
		}
	}
	
	public Connection getConnection() throws SQLException {
		Connection conn = null;
		String url = "jdbc:oracle:thin:@192.168.8.208:1521:xe";
		String user = "sqld";
		String pw = "sqld";
		conn = DriverManager.getConnection(url, user, pw);
		return conn;
	}
	
	public void closed(ResultSet rs, Statement stmt, Connection conn) {
		try {
			if(rs != null) {
				rs.close();
			}
			if(stmt != null) {
				stmt.close();
			}
			if(conn != null) {
				conn.close();
			}
			System.out.println("6단계 성공");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}




