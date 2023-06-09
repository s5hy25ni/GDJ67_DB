-- 집계함수
-- 집계가 되면 여러 개의 값이 단일값으로 만들어 짐 -> 따라서 결과를 단일 출력할 수 없음
-- DISTINCT : SELECT 절에서 ㅏ단순히 하나의 컬럼 중복을 제거

-- 문제) 축구 선수의 평균 키
SELECT TRUNC(AVG(HEIGHT))
	FROM PLAYER p ;
	
-- 문제2 축구선수 팀 별별 평균 키
SELECT TRUNC(AVG(HEIGHT)) 평균키, p.TEAM_ID
	FROM PLAYER p JOIN TEAM t 
	ON p.TEAM_ID = t.TEAM_ID
	GROUP BY (t.TEAM_ID) ;

SELECT TRUNC(AVG(HEIGHT)) 평균키, t.TEAM_ID, t.TEAM_NAME 
	FROM PLAYER p JOIN TEAM t 
	ON p.TEAM_ID = t.TEAM_ID
	GROUP BY (t.TEAM_ID, TEAM_NAME) ;
	
-- 문제) 축구선수 정보 출력하는데 각 팀별 평균키도 같이
SELECT PLAYER_NAME , HEIGHT, TEAM_ID 
	FROM PLAYER p ;
	
SELECT DISTINCT(TEAM_ID), PLAYER_ID --484
--	PLAYER_NAME --480
	FROM PLAYER p ;
	
-- COUNT(*) FROM 절에서 조회된 row의 개수 출력, COUNT(컬럼) FROM 절에서 조회된 컬럼의 NULL이 아닌 개수
-- MIN, MAX, SUM, AVG
-- 집계 함수는 null 컬럼의 값은 대상으로 선정 X
-- 축구선수의 개수와 최대키, 최소키, 총 키의 합, 키의 평균
SELECT COUNT(*), COUNT(NICKNAME),
	MIN(HEIGHT), MAX(HEIGHT), SUM(HEIGHT), AVG(HEIGHT)
	FROM PLAYER p 
	GROUP BY TEAM_ID ;
	
-- 가장 큰 키 가진 팀 출력
-- GROUP BY 뒤에는 where를 사용 X
-- WHERE에는 집계 함수 X
-- HAVING이 GROUP BY 바로 위나 바로 아래에 있으면 됨
SELECT TEAM_ID, MAX(HEIGHT)
	FROM PLAYER p 
	WHERE NICKNAME IS NULL
	HAVING MAX(HEIGHT) > 195
	GROUP BY TEAM_ID ;
	
-- 정리
-- GROUP BY 는 SELECT 절에서 단일값으로 출력되는 컬럼을 선택할 수 없음
-- GROUP BY 가 사용된 SQL문은 GROUP BY에 참여하는 컬럼과 집계함수만 가능
-- 집계 함수는 NULL은 계산하지 않음

SELECT "POSITION" , AVG(HEIGHT)
	FROM PLAYER p 
	WHERE "POSITION" IS NOT NULL -- GROUP BY에 참여하는 ROW의 개수를 정제한 후 사용하는게 실행에 유리
	GROUP BY "POSITION" ;
	
SELECT "POSITION" , AVG(HEIGHT)
	FROM PLAYER p 
	GROUP BY "POSITION" 
--	WHERE "POSITION" IS NOT NULL -- GROUP BY 다음에는 GROUP된 ROW의 처리를 위한 HAVING 절만이 정제할 수 있음;
	
SELECT "POSITION" , AVG(HEIGHT)
	FROM PLAYER p 
	GROUP BY "POSITION" -- GROUP BY에는 NULL도 그룹으로 묶임
	HAVING "POSITION" IS NOT NULL; -- GROUP BY된 결과는 HAVING 절에서 조건을 작성한다. HAVING 절은 집계함수도 가능
	
SELECT "POSITION" , AVG(HEIGHT)
	FROM PLAYER p 
	HAVING "POSITION" IS NOT NULL -- HAVING의 위치는 GROUP BY와 같은 묶음으로만 존재하면 된다.
	GROUP BY "POSITION" ;
	
SELECT "POSITION" , AVG(HEIGHT)
	FROM PLAYER p 
	HAVING "POSITION" IS NOT NULL; -- HAVING 은 GROUP BY와 같이 사용되어야 한다.
	
-- FROM절 -> WHERE 절 -> GROUP 절 -> HAVING 절 -> ORDER BY 절
	
SELECT MAX(HEIGHT)
	FROM PLAYER p
	GROUP BY 3; -- INDEX가 아닌 값 --> MYSQL은 INDEX로 GROUP BY 인식
	
-- ORDER BY 
-- ORDER BY는 INDEX, 컬럼명, alias로 가능
SELECT PLAYER_ID , PLAYER_NAME , "POSITION" 포지션
	FROM PLAYER p 
	ORDER BY 1, PLAYER_NAME , 포지션;
	
-- 문제) 평균키가 180이상인 팀을 출력해주세요.
SELECT TEAM_ID, AVG(HEIGHT)
	FROM PLAYER p 
	GROUP BY TEAM_ID 
	HAVING AVG(HEIGHT) >= 180;
	
-- 문제) K05와 K07의 팀 인원수
SELECT COUNT(*), TEAM_ID 
	FROM PLAYER p
	GROUP BY TEAM_ID 
	HAVING TEAM_ID = 'K05' OR TEAM_ID = 'K07';
	
SELECT COUNT(*), TEAM_ID 
	FROM PLAYER p
	WHERE TEAM_ID='K05' OR TEAM_ID='K07'
	GROUP BY TEAM_ID ;

SELECT COUNT(*), TEAM_ID 
	FROM PLAYER p
	WHERE TEAM_ID IN ('K05','K07')
	GROUP BY TEAM_ID ;
	
-- JOB별 등급별 통계
SELECT JOB, 
	SUM(CASE GRADE WHEN 1 THEN 1 END) 등급1,
	SUM(CASE GRADE WHEN 2 THEN 1 END) 등급2,
	SUM(CASE GRADE WHEN 3 THEN 1 END) 등급3,
	SUM(CASE GRADE WHEN 4 THEN 1 END) 등급4,
	SUM(CASE GRADE WHEN 5 THEN 1 END) 등급5
	FROM EMP e , SAL_GRADE sg 
	WHERE e.SAL BETWEEN sg.LOSAL AND sg.HISAL
	GROUP BY JOB;
	
-- 월만 가져오기
SELECT EXTRACT(MONTH FROM HIREDATE), TO_NUMBER(TO_CHAR(HIREDATE, 'MM'))
	FROM EMP e ;
	
SELECT DEPTNO,
	-- EXTRACT
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 1 THEN SAL END) "1월",
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 2 THEN SAL END) "2월",
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 3 THEN SAL END) "3월",
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 4 THEN SAL END) "4월",
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 5 THEN SAL END) "5월",
	AVG(CASE EXTRACT(MONTH FROM HIREDATE) WHEN 6 THEN SAL END) "6월",
	-- TO_CHAR
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='07' THEN SAL END) "7월",
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='08' THEN SAL END) "8월",
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='09' THEN SAL END) "9월",
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='10' THEN SAL END) "10월",
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='11' THEN SAL END) "11월",
	AVG(CASE WHEN TO_CHAR(HIREDATE, 'MM')='12' THEN SAL END) "12월"	
	FROM EMP e
	GROUP BY DEPTNO;
	
SELECT	DEPTNO, DNAME, TO_CHAR(HIREDATE, 'MM') MM
	FROM EMP e JOIN DEPT d 
	USING (DEPTNO)
	ORDER BY 1;
	
CREATE VIEW EMP_VIEW AS SELECT	DEPTNO, DNAME, TO_CHAR(HIREDATE, 'MM') MM, SAL
							FROM EMP e JOIN DEPT d 
							USING (DEPTNO)
							ORDER BY 1;
							
SELECT *
	FROM EMP_VIEW ;
DROP VIEW EMP_VIEW ;
	
SELECT DNAME,
	AVG(CASE MM WHEN '01' THEN SAL END) "1",
	AVG(CASE MM WHEN '02' THEN SAL END) "2",
	AVG(CASE MM WHEN '03' THEN SAL END) "3",
	AVG(CASE MM WHEN '04' THEN SAL END) "4",
	AVG(CASE MM WHEN '05' THEN SAL END) "5",
	AVG(CASE MM WHEN '06' THEN SAL END) "6",
	AVG(CASE MM WHEN '07' THEN SAL END) "7",
	AVG(CASE MM WHEN '08' THEN SAL END) "8",
	AVG(CASE MM WHEN '09' THEN SAL END) "9",
	AVG(CASE MM WHEN '10' THEN SAL END) "10",
	AVG(CASE MM WHEN '11' THEN SAL END) "11",
	AVG(DECODE(MM, '12', SAL)) "12"
	FROM EMP_VIEW
	GROUP BY DNAME;
	

-- 축구선수들 테이블에서 팀별 포지션의 인원 출력
SELECT "POSITION" ,COUNT("POSITION" )
	FROM PLAYER p2 
	GROUP BY "POSITION" ;

SELECT TEAM_ID, 
	SUM(CASE "POSITION" WHEN 'DF' THEN 1 END) DF,
	SUM(CASE "POSITION" WHEN 'MF' THEN 1 END) MF,
	SUM(CASE "POSITION" WHEN 'FW' THEN 1 END) FW,
	SUM(CASE "POSITION" WHEN 'GK' THEN 1 END) GK
	FROM PLAYER p 
	GROUP BY TEAM_ID
	ORDER BY TEAM_ID ;
	
SELECT TEAM_ID, 
	COUNT(DECODE("POSITION", 'DF', '0')) DF,
	COUNT(DECODE("POSITION", 'MF', '0')) MF,
	COUNT(DECODE("POSITION", 'FW', '0')) FW,
	COUNT(DECODE("POSITION", 'GK', '0')) GK
	FROM PLAYER p 
	GROUP BY TEAM_ID
	ORDER BY TEAM_ID ;
	

-- Oracle에서는 DDL이 무조건 Auto-Commit으로 동작이 된다.
-- 즉, DDL 실행전 작업한 모든 내용은 DDL이 실행이 되면 자동으로 Commit
-- 하지만 MS Server에서는 따로 동작 된다. DDL과 DML이 다른 RollBack과 Commit을 가진다.
	
SELECT EMPNO
	FROM EMP
	ORDER BY ENAME DESC; -- ORDER BY SQL 문의 가장 마지막에 실행된 절
															-- SELECT에 출력된 컬럼 뿐만 아니라 FROM절에 있는 컬럼도 선택이 됨
	
-- 집계 함수는 WHERE에 사용하지 못하고, SELECT절/ HAVING절/ORDER BY절 에서 사용 가능
SELECT AVG(SAL)
	FROM EMP
	GROUP BY DEPTNO 
	ORDER BY AVG(SAL), COUNT(*); -- 집계함수임
	
SELECT AVG(SAL) 평균
	FROM EMP
	GROUP BY DEPTNO 
	ORDER BY AVG(SAL), 평균, 평균, COUNT(*); -- 2번 써도 상관 없음
	
SELECT SAL + COMM 
	FROM EMP e 
	ORDER BY SAL+COMM; -- 컬럼임(연산X)
	
SELECT SAL + COMM AS SC
	FROM EMP e 
	ORDER BY SAL+COMM ; -- 연산임
	
-- TOP N 쿼리
-- ROWNUM
-- TABLE에 저장되어 있는 순서대로 SELECT절에 나가면 번호를 매겨줌
SELECT ROWNUM, e.*
	FROM EMP e 
	WHERE ROWNUM < 2; -- ROWNUM은 1부터 만들어지므로 ROWNUM = 2는 안된다.
	
-- 문제) 급여가 높은 순서대로 번호를 매겨주세요.
-- INLINE VIEW(SUBQUERY) => VIEW TABLE
SELECT ROWNUM, e.*
FROM	(
					SELECT *
						FROM EMP 
						ORDER BY SAL DESC) e;
						
-- WINDOWS절
SELECT e.*, ROW_NUMBER () OVER(ORDER BY SAL DESC)
	FROM EMP e ;
	
SELECT *
	FROM PLAYER p JOIN TEAM t 
	ON p.TEAM_ID = t.TEAM_ID 
--		AND p.TEAM_ID ='K01'; -- 맞지 않으나 실행은 됨
	WHERE p.TEAM_ID = 'K01'; -- 표준 문법
	
SELECT *
	FROM PLAYER p , TEAM t 
	WHERE p.TEAM_ID = t.TEAM_ID 
		AND t.TEAM_ID = 'K01';
		
-- SCHEDULE 테이블은 홈팀과 원정팀의 경기 결과를 가지고 있다.
-- 홈팀이 원정팀을 3점 이상으로 이긴 경기를 조회
-- 홈팀명, 원정팀명, 경기장명
SELECT t.TEAM_NAME HOMETEAM, t2.TEAM_NAME AWAYTEAM, STADIUM_NAME STADIUM
	FROM SCHEDULE s JOIN TEAM t 
	ON s.HOMETEAM_ID = t.TEAM_ID 
	JOIN TEAM t2 
	ON s.AWAYTEAM_ID = t2.TEAM_ID 
	JOIN STADIUM s2
	ON s.STADIUM_ID = s2.STADIUM_ID 
	WHERE HOME_SCORE > AWAY_SCORE +2;
	
SELECT t.TEAM_NAME HOMETEAM, t2.TEAM_NAME AWAYTEAM, STADIUM_NAME STADIUM
	FROM SCHEDULE s , TEAM t , TEAM t2 , STADIUM s2 
	WHERE s.HOMETEAM_ID = t.TEAM_ID 
		AND s.AWAYTEAM_ID = t2.TEAM_ID 
		AND s.STADIUM_ID = s2.STADIUM_ID 
		AND HOME_SCORE > AWAY_SCORE +2;