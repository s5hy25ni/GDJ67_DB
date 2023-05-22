package com.min.edu.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;


import com.min.edu.comm.DataBase;
import com.min.edu.dto.Emp_VO;


public class EmpDaoImpl extends DataBase implements IEmpDao {


	@Override
	public List<Emp_VO> getAllEmp() {
		List<Emp_VO> lists = new ArrayList<Emp_VO>();
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT EMPNO, ENAME, JOB, HIREDATE"
				+" FROM EMP_COPY ec";	
		
		try {
			conn = getConnection();
			System.out.println("2단계 성공");
			
			stmt = conn.prepareStatement(sql);
			System.out.println("3단계 쿼리 준비 성공");
			
			rs = stmt.executeQuery();
			System.out.println("4단계 쿼리 실행 성공");
			
			while(rs.next()) {
				Emp_VO vo = new Emp_VO(rs.getInt(1),
										rs.getString(2),
										rs.getString(3),
										rs.getString(4));
				lists.add(vo);
				
			}
			System.out.println("5단계 결과 받기 성공");
		} catch (SQLException e) {
			System.out.println("getAllEMP 실패");
			e.printStackTrace();
		} finally {
			closed(rs, stmt, conn);
		}
		
		return lists;
	}


	@Override
	public Emp_VO getOneEmp(int empno) {
		Emp_VO vo = new Emp_VO();
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// SqlSyntexException 발생시 쿼리문제 해결
		String sql = " SELECT EMPNO, ENAME, JOB, HIREDATE"
				+ "	FROM EMP_COPY ec"
				+ "	WHERE EMPNO=?";
		
		try {
			conn = getConnection();
			System.out.println("2단계 성공");
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, empno);
			System.out.println("3단계 성공");
			
			rs = stmt.executeQuery();
			System.out.println("4단계 성공");
			
			while(rs.next()) {
				// 컬럼명 사용할 때 장점 : 순서가 상관 없음
				// 단점 : 많아지면 힘들어짐
				// EMPNO, ENAME, JOB, HIREDATE
				vo.setEmpno(empno);
				vo.setEname(rs.getString("ENAME"));
				vo.setJob(rs.getString("JOB"));
				vo.setHiredate(rs.getString("HIREDATE"));
			}
			System.out.println("5단계 성공");
			
		} catch (SQLException e) {
			System.out.println("getOneEmp 실패");
			e.printStackTrace();
		} finally {
			closed(rs, stmt, conn);
		}
		
		return vo;
	}


	@Override
	public int setOneEmp(Emp_VO vo) {
		int n = 0;
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = " INSERT INTO EMP_COPY ex (EMPNO, ENAME, JOB)"
				+ "	VALUES(?, ?, ?)";
		
		try {
			conn = getConnection();
			System.out.println("2단계 성공");
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, vo.getEmpno());
			stmt.setString(2, vo.getEname());
			stmt.setString(3, vo.getJob());
			System.out.println("3단계 성공");
			
			n = stmt.executeUpdate();
			System.out.println("4단계 성공");
		} catch (SQLException e) {
			System.out.println("setOneEmp 실행");
			e.printStackTrace();
		} finally {
			closed(rs, stmt, conn);
		}
		
		return n;
	}


	@Override
	public int setModifyEmp(Map<String, Object> inMap) {


		int n = 0;
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "UPDATE EMP_COPY"
				+ "	SET JOB=?"
				+ "	WHERE EMPNO = ?";
		
		try {
			conn = getConnection();
			System.out.println("2단계 성공");
			
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, (String)inMap.get("j"));
			stmt.setString(2, (String)inMap.get("e"));
			System.out.println("3단계 성공");
			
			n = stmt.executeUpdate();
			System.out.println("4단계 성공");
		} catch (SQLException e) {
			System.out.println("setModifyEmp 실패");
			e.printStackTrace();
		} finally {
			closed(rs, stmt, conn);
		}
		
		return n;
	}


	@Override
	public boolean deleteEmp(int empno) {
		boolean isc = false;
		
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "DELETE FROM EMP_COPY ex"
				+ "	WHERE EMPNO = ?";
		
		try {
			conn = getConnection();
			System.out.println("2단계 성공");
			
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, empno);
			System.out.println("3단계 성공");
			
			int n = stmt.executeUpdate();
			System.out.println("4단계 성공");
			
			isc = (n>0)?true:false;
		} catch (SQLException e) {
			System.out.println("deleteEmp 실패");
			e.printStackTrace();
		} finally {
			closed(rs, stmt, conn);
		}
		return isc;
	}


}
