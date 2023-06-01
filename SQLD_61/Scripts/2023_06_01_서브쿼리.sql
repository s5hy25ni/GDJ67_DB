-- 서브쿼리
-- 쿼리 안에 또 다른 쿼리가 있음
-- 연산자 우선 순위에 의해 무조건 ( ) 안에 작업

-- 서브쿼리의 종류
-- scala subquery : SELECT, WHERE, HAVING, ORDER BY, INSERT, UPDATE
-- inline view : FROM절에 사용

-- 문) 정남일 선수가 소속된 팀의 선수들명, 포지션, 백넘버 출력
-- 		1) 정남일 선수가 소속된 팀 WHERE절
--		2) 1)의 정보를 사용해서 조회
SELECT TEAM_ID 
	FROM PLAYER p 
	WHERE PLAYER_NAME ='정남일';

SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = (SELECT TEAM_ID 
								FROM PLAYER p 
								WHERE PLAYER_NAME ='정남일');

-- 문) 정남일 선수와 같은 팀, 같은 포지션인 축구선수의 정보를 출력
							
SELECT *
	FROM PLAYER p 
	WHERE (TEAM_ID, "POSITION") IN (SELECT TEAM_ID , "POSITION" 
								FROM PLAYER p 
								WHERE PLAYER_NAME ='정남일');
							
-- 문) K07 팀의 평균키보다 작은 선수들의 정보를 출력
SELECT *
	FROM PLAYER p2 
	WHERE HEIGHT < (SELECT AVG(HEIGHT)
								FROM PLAYER p 
								WHERE TEAM_ID = 'K07');
								
-- 다중행 서브쿼리
-- 문제) 정현수가 포함된 팀의 정보
SELECT *
	FROM PLAYER p2  
	WHERE TEAM_ID IN (SELECT TEAM_ID 
									FROM PLAYER p 
									WHERE PLAYER_NAME = '정현수');

-- 문제) 각 팀별 가장 키가 큰 선수들의 정보
SELECT *
	FROM PLAYER p2 
	WHERE (TEAM_ID , HEIGHT) IN (SELECT TEAM_ID, MAX(HEIGHT) -- scala subquery
												FROM PLAYER p 
												GROUP BY TEAM_ID);
												
SELECT *
	FROM PLAYER p JOIN (SELECT TEAM_ID, MAX(HEIGHT) MX -- inline view
												FROM PLAYER p 
												GROUP BY TEAM_ID) p3
	ON p.TEAM_ID = p3.TEAM_ID
	AND p.HEIGHT = p3.Mx;


SELECT p.TEAM_ID , p.PLAYER_NAME , p.HEIGHT 
	FROM PLAYER p 
	WHERE HEIGHT =(
							SELECT MAX(HEIGHT)
								FROM PLAYER p2 
								WHERE p.TEAM_ID = p2.TEAM_ID -- 연관 서브 쿼리
							);

-- 속한 팀의 평균키도 같이 출력
-- PLAYER NAME, TEAM ID, HEIGHT, AVG(HEIGHT)
SELECT p.TEAM_ID , p.PLAYER_NAME , p.HEIGHT, p3.a AVG
	FROM PLAYER p, (SELECT AVG(HEIGHT) a, TEAM_ID 
							FROM PLAYER p 
							GROUP BY TEAM_ID ) p3
	WHERE p.TEAM_ID = p3.TEAM_ID;
							

SELECT *
	FROM PLAYER p JOIN AVG_HEIGHT ah
		USING(TEAM_ID);

CREATE VIEW AVG_HEIGHT AS (SELECT TEAM_ID , AVG(HEIGHT) AVG
										FROM PLAYER p2 
										GROUP BY TEAM_ID);
										
									
SELECT PLAYER_NAME , HEIGHT , TEAM_ID ,
	(SELECT AVG(HEIGHT)
		FROM PLAYER p2
		WHERE p.TEAM_ID= p2.TEAM_ID)
	FROM PLAYER p ;
	

-- 연관 서브 쿼리
-- EXIST 있냐? EXCEPT 제거한다.
-- SCHEDULE 테이블에서 특정 범위에 있는 값을 출력하고 싶다.
-- STADIUM 의 정보
SELECT *
	FROM STADIUM s ;

SELECT *
	FROM SCHEDULE s ;
	
SELECT *
	FROM SCHEDULE s 
	WHERE SCHE_DATE BETWEEN '20120501' AND '20120502';
	
SELECT *
	FROM STADIUM s 
	WHERE STADIUM_ID IN (
		SELECT STADIUM_ID 
			FROM SCHEDULE s 
			WHERE SCHE_DATE BETWEEN '20120501' AND '20120502'
	);

-- EXISTS 문법은 연관 서브 쿼리의 결과가 있다면(=공집합이 아니라면) TRUE로 체크하여 해당 ROW를 반환
SELECT *
	FROM STADIUM s 
	WHERE EXISTS (SELECT '아무거나'
							FROM SCHEDULE s2
							WHERE s.STADIUM_ID = s2.STADIUM_ID 
								AND SCHE_DATE BETWEEN '20120501' AND '20120502');
								
SELECT *
	FROM STADIUM s 
	WHERE NOT EXISTS (SELECT '아무거나'
							FROM SCHEDULE s2
							WHERE s.STADIUM_ID = s2.STADIUM_ID 
								AND SCHE_DATE BETWEEN '20120501' AND '20120502');
								
SELECT *
	FROM STADIUM s , SCHEDULE s2 
	WHERE s.STADIUM_ID = s2.STADIUM_ID 
	AND s2.SCHE_DATE BETWEEN '20120501' AND '20120502';
	
-- 문) 평균키가 K02의 평균키보다 작은 팀의 이름과 해당 팀의 평균키 출력
--			TEAM_ID, TeAM_NAME, AVG()

SELECT TEAM_ID , TEAM_NAME ,
	(SELECT AVG(HEIGHT)
		FROM PLAYER p
		WHERE t.TEAM_ID = p.TEAM_ID
		GROUP BY TEAM_ID) AVG 
	FROM TEAM t;
	
SELECT t.TEAM_ID , TEAM_NAME, p2.AVG 
	FROM TEAM t JOIN(
								SELECT TEAM_ID , AVG(HEIGHT) AVG
									FROM PLAYER p 
									GROUP BY TEAM_ID ) p2
	ON t.TEAM_ID = p2.TEAM_ID
	WHERE p2.AVG < (SELECT AVG(HEIGHT)
									FROM PLAYER p 
									WHERE TEAM_ID ='K07');
									
								
-- 쌤이 풀어줌
SELECT p.TEAM_ID, TEAM_NAME, AVG(HEIGHT)
	FROM PLAYER p JOIN TEAM t 
	ON p.TEAM_ID = t.TEAM_ID 
	GROUP BY p.TEAM_ID , TEAM_NAME 
	HAVING AVG(HEIGHT) < (SELECT AVG(HEIGHT)
										FROM PLAYER p2 
										WHERE TEAM_ID = 'K02');
										
-- UPDATE -> 역정규화
-- TEAM 테이블을 조회할 때 STADIUM_NAME도 조회하는 경우가 빈번하게 발생
-- 이러하여 DBA 담당자가 TEAM 테이블에 STADIUM_NAME을 복제하여 역정규화를 하고자 함
-- TEAM에 STADIUM_NAME 컬럼을 추가하고 STADIUM 테이블에서 STADIUM_NAME을 복제하여 값을 넣어주세요
SELECT STADIUM_ID , STADIUM_NAME 
	FROM TEAM t ;
	
ALTER TABLE TEAM 
	ADD (STADIUM_NAME VARCHAR2(40));
	
UPDATE TEAM t SET STADIUM_NAME = (
												SELECT STADIUM_NAME 
													FROM STADIUM s 
													WHERE t.STADIUM_ID = s.STADIUM_ID);
													
-- INSERT 문
SELECT *
	FROM INFO i ;
-- SEQUENCE TABLE
-- 테이블과 연관된 테이블이 아님
-- 제약조건과 같이 CASCADE를 통해 삭제되는 것이 아닌 외부의 SEQUENCE 만들어주는 테이블
-- PK와 같이 중복되지 않는 값을 만들어낼 때 사용 => 1부터 계속해서 앞으로만 증가 => 무결성 확보
SELECT INFO_SEQ.NEXTVAL 
	FROM DUAL;
	
SELECT INFO_SEQ.CURRVAL
	FROM DUAL;
	
-- 문) SEQUENCE 테이블 없이 중복되지 않는 값을 만들어내는 쿼리를 작성하여 INSERT 문을 구성
DELETE FROM INFO i ;
SELECT * FROM INFO i ;

-- SEQUENCE 사용
INSERT INTO INFO i 
	VALUES(INFO_SEQ.NEXTVAL, 'KOKOA', '0001', 'U', SYSDATE);
	
-- 서브쿼리 사용
INSERT INTO INFO i 
	VALUES(( 
				SELECT NVL(MAX(SEQ),0)
					FROM INFO i2 
				)+1
	,'KOKOA', '0001', 'U', SYSDATE);
	
-- INSERT 문에 사용되는 다중 INSERT 문

-- 문법 INSERT ALL
-- INSERT가 여러 개인 경우
-- INSERT 실행 * 반복
SELECT *
	FROM INFO i ;
SELECT *
	FROM TEST t;

CREATE TABLE TEST(
	ID VARCHAR2(10)
);

INSERT ALL
	INTO INFO (SEQ, NAME, PHONE, AUTH, REGDATE)
		VALUES(6, 'KOKOA', '00700', 'U', SYSDATE)
	INTO INFO (SEQ, NAME, PHONE, AUTH, REGDATE)
		VALUES(7, 'KOKOA', '00700', 'U', SYSDATE)
SELECT *
	FROM DUAL ;

-- UNION ALL  사용
INSERT INTO TEST(ID)
	SELECT 1 FROM DUAL UNION ALL
	SELECT 2 FROM DUAL UNION ALL
	SELECT 3 FROM DUAL UNION ALL
	SELECT 4 FROM DUAL;