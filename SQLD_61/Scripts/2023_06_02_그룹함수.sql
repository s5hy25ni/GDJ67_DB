-- 그룹함수 group function
-- group by 함수를 사용하여 소계/총계를 계산하여 row로 만들어 줌
-- ROLLUP, CUBE, GROUPING SET 
-- GROUPING 0과 1료 표기 됨 -> 소계가 된 컬럼이라면 1, 아니라면 0
-- GROUP BY에서는 반드시 GROUP BY에 참여하는 컬럼만 사용이 가능하고, 집계함수만 사용 가능함

-- 부서명과 직업의 총계를 나타내는 쿼리문을 작성하자.
-- 사원은 14명 -- GROUP BY DNAME 3개 -- GROUP BY DNAME, JOB 9개 = 5명이 같은 부서명과 직업을 가짐
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY DNAME, JOB -- DNAME || JOB 처리된 값이 GROUP BY 대상
	ORDER BY DNAME, JOB;
	
-- DNAME이 3종류			합계
--		ACCOUNT 3종류	소계
--		RESEARCH 3종류	소계
--		SALES 3종류			소계
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY ROLLUP(DNAME, JOB )
	ORDER BY DNAME, JOB;
	
SELECT DISTINCT (JOB || DNAME) -- JOB 14개 / DISTINCT(JOB || DNAME) 9개
	FROM DEPT d JOIN EMP e 
	USING (DEPTNO);
	
SELECT JOB, DNAME, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY ROLLUP(JOB,DNAME )
	ORDER BY JOB,DNAME;
	
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY ROLLUP(DNAME), JOB -- DNAME||JOB으로 GROUP
	ORDER BY DNAME;
	
SELECT JOB, DNAME, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY ROLLUP (JOB),DNAME
	ORDER BY JOB;
	
-- 만약 ROLLUP으로 참여하는 컬럼이 하나이고 다른 하나는 ROLLUP이 아니라면
-- 두 개의 컬럼은 AND 조건을 하나의 값으로 처리
-- ROLLUP이 되어있는 컬럼에 대한 통계만 나옴

-- GROUP BY 와 UNION ALL을 통해서도 구성 가능
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY DNAME, JOB
UNION ALL
SELECT DNAME, NULL, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY DNAME
UNION ALL	
SELECT '총합', NULL, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	ORDER BY 1, 2;
	
SELECT JOB, DNAME, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY JOB, DNAME
UNION ALL	
SELECT JOB, NULL, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY JOB
UNION ALL
SELECT '총합', NULL, COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	ORDER BY 1, 2;
	
-- GROUPING 소계가 된 컬럼이라면 1로 ROW의 값을 만들어 줌
SELECT CASE GROUPING (DNAME) WHEN 1 THEN 'ALL DNAME' ELSE DNAME END "DNAME", 
			CASE GROUPING (JOB) WHEN 1 THEN 'ALL JOB' ELSE JOB END "JOB",
			COUNT(*), SUM(SAL)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY ROLLUP(DNAME, JOB )
	ORDER BY DNAME, JOB;
	
-- ROLLUP을 사용할 때 ()의 묶음을 잘 봐야 함
SELECT DNAME, JOB, MGR
	FROM DEPT d JOIN EMP e 
	USING (DEPTNO)
	GROUP BY DNAME, JOB, MGR; -- () 없이 모두 AND 조건으로 처리
	
SELECT DNAME, JOB, MGR, COUNT(*)
	FROM DEPT d JOIN EMP e 
	USING(DEPTNO)
	GROUP BY DNAME, ROLLUP(JOB,MGR) -- DNAME AND JOB||MGR
	ORDER BY 1,2,3;
	
-- ROLLUP 은 통계 GROUP BY ROLLUP(컬럼1, 컬럼2)
-- 		컬럼1 소계, 컬럼1+컬럼2 소계
--		컬럼의 순서 조심
-- GROUP BY는 무조건 AND 조건으로 값을 만들어 그룹화
-- 		ROLLUP은 소계를 만들어야 하기 때문에, ()의 묶음이 중요
--			(컬럼1, 컬럼2, 컬럼3) 컬럼1 + 컬럼1||컬럼2 + 컬럼1||컬럼2||컬럼3
--			(컬럼1, (컬럼2, 컬럼3)) 컬럼1 + 컬럼1||컬럼2||컬럼3

-- GROUP BY 컬럼1, ROLLUP(컬럼2)

-- CUBE 다차원 통계
SELECT CASE WHEN GROUPING(DNAME)=1 THEN 'ALL DNAME' ELSE DNAME END DNAME,
			CASE WHEN GROUPING(JOB)=1 THEN 'ALL JOB' ELSE JOB END JOB,
			COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO 
	GROUP BY CUBE(DNAME, JOB)
	ORDER BY 1,2;
	
SELECT CASE WHEN GROUPING(DNAME)=1 THEN 'ALL DNAME' ELSE DNAME END DNAME,
			CASE WHEN GROUPING(JOB)=1 THEN 'ALL JOB' ELSE JOB END JOB,
			COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO 
	GROUP BY CUBE(DNAME), JOB
	ORDER BY 1,2;
	
-- CUBE를 UNION ALL로 변경
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO 
	GROUP BY DNAME, JOB
UNION ALL
SELECT DNAME, NULL, COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO 
	GROUP BY DNAME
UNION ALL	
SELECT NULL, JOB, COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO 
	GROUP BY JOB
UNION ALL	
SELECT NULL, NULL, COUNT(*), SUM(SAL)
	FROM DEPT d , EMP e 
	WHERE d.DEPTNO = e.DEPTNO
	ORDER BY 1, 2;
	
CREATE VIEW EMPDEPT AS SELECT *
										FROM EMP e JOIN DEPT d 
										USING(DEPTNO);

-- 1) DNAME||JOB 통계									
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY DNAME, JOB
UNION ALL
-- 2) DNAME 통계
SELECT DNAME, NULL, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY DNAME
UNION ALL
-- 3) JOB 통계
SELECT NULL, JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY JOB
UNION ALL
-- 4) 전체 통계
-- 2) DNAME 통계
SELECT NULL,NULL,COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	ORDER BY 1, 2;
	
-- GROUPING SETS
-- 선택된 칼럼만의 소계

SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY GROUPING SETS(DNAME, JOB);
	
SELECT DNAME, JOB, MGR,  COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY GROUPING SETS(JOB, DNAME, MGR);
	
SELECT DNAME, JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY DNAME, GROUPING SETS(JOB)
	ORDER BY 1,2;
	
SELECT DNAME, NULL JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY DNAME
UNION ALL
SELECT NULL, JOB, COUNT(*), SUM(SAL)
	FROM EMPDEPT e
	GROUP BY JOB;