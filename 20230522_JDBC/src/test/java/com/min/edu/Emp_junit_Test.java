package com.min.edu;


import static org.junit.Assert.*;


import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.junit.Before;
import org.junit.Test;


import com.min.edu.dao.EmpDaoImpl;
import com.min.edu.dao.IEmpDao;
import com.min.edu.dto.Emp_VO;


public class Emp_junit_Test {


	private IEmpDao dao;
	
	@Before
	public void emp_Create() {
		dao = new EmpDaoImpl();
		assertNotNull(dao);
	}


//	@Test
	public void getAllEmp_test() {
		List<Emp_VO> lists = dao.getAllEmp();
		System.out.println(lists.size());
		assertNotNull(lists);
	}
	
//	@Test
	public void getOneEmp_test() {
		Emp_VO outVo = dao.getOneEmp(7900);
		System.out.println(outVo);
		assertNotNull(outVo);
	}
	
//	@Test
	public void setOneEmp_test() {
		Emp_VO inVo = new Emp_VO(0522, "IT", "DEV", null);
		int n = dao.setOneEmp(inVo);
		System.out.println(inVo);
		assertEquals(n,1);
	}
	
//	@Test
	public void setModifyEmp_Test() {
		Map<String, Object> inMap = new HashMap<String, Object>();
		inMap.put("j", "PROG");
		inMap.put("e", "338");
		
		int n = dao.setModifyEmp(inMap);
		assertEquals(n, 1);
	}
	
	@Test
	public void deleteEmp_Test() {
		int empno = 338;
		boolean isc = dao.deleteEmp(empno);
		assertTrue(isc);
	}
}




