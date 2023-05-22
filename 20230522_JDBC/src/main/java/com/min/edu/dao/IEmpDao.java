package com.min.edu.dao;


import java.util.List;
import java.util.Map;


import com.min.edu.dto.Emp_VO;


public interface IEmpDao {


	/**
	 * 전체 조회
	 */
	public List<Emp_VO> getAllEmp();
	
	/**
	 * 상세 조회
	 * DB에 입력되어 있는 하나의 row를
	 * pk값을 통해 조회하여
	 * 한 개의 DTO에 담아 객체로 변환
	 * 
	 */
	public Emp_VO getOneEmp(int empno);
	
	/**
	 * 입력
	 * DB에 정보 한 row를 입력
	 * 입력받은 정보는 많은 정보 및 변수 포함하고 있기 때문에
	 * 사용되는 EMP_COPY테이블과 매핑되어 있는 EMP_VO를 통해 입력하면
	 * 필요한 변수를 편하게 입력 가능  
	 */
	public int setOneEmp(Emp_VO vo);
	
	/**
	 * 수정
	 * DB에 입력되어 있는 한 row를 수정
	 * pk값(empno)을 기준으로 JOB의 값을 수정
	 * 반환 결과는 성공한 row의 개수 반환
	 * 성공하면 1, 실패하면 0 
	 */
	public int setModifyEmp(Map<String, Object> inMap);


	/**
	 * 삭제
	 * DB에 들어있는 한 개의 row를
	 * pk를 통해서 삭제 
	 */
	public boolean deleteEmp(int empno);
}
