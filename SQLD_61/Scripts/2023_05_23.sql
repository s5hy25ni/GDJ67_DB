-- where절 조건절의 활용

-- FTS(full table scan)
-- optimizer 규칙 : CBO(Cost Base Optimizer), RBO(Rule Base Optimizer)
-- Cost값이 낮은 애로!
-- 확인 작업 EXCUTEION PLAIN (실행규칙)
-- WHERE 절에 PK를 사용하여 검색 조건절로 사용하세요 => INDEX를 자동으로 만들어 줌
-- INDEX를 여러개를 필요로 할 때, WHERE PLAYER_ID와 PLAYER_NAME을 동시에 조건절에서 검색하는 경우 = 복합미 조합
-- EX) WHERE PLAYER_ID = '7900' AND PLAYER_NAME = '보띠';

-- 소속팀이 삼성블루명즈이거나 전남드래곤즈에 소속된 선수들이어야 하고,
-- 포지션이 미드필더(MF:Midfielder) 이어야 한다.
-- 키는 170 센티미터 이상이고 180 센티미터 이하여야 한다.

-- 필요 테이블 : TEAM, PLAYER
-- 관계 : TEAM_ID
-- 조건 : 소속팀은 TEAM
--		포지션, 키 PLAYER
-- 1)
SELECT *
	FROM TEAM t 
	WHERE TEAM_NAME LIKE '%삼성%'; -- K02, 수원, 삼성블루윙즈
--							'삼성____';
	
SELECT *
	FROM TEAM t 
	WHERE TEAM_NAME LIKE '%드래곤%'; -- K07, 전남, 드래곤즈
--							'드래곤_';
	
-- LIKE는 *(와일드카드)를 사용하여 검색 가능
-- % 모든 것, _ 한 단어
-- %를 앞에 사용하면 무리한 검색이 발생 -> _를 통해 제한을 하자!
	
SELECT  SUBSTR(TEAM_NAME, 0, 2)
	FROM TEAM t2;

SELECT *
	FROM TEAM t2 
	WHERE SUBSTR(TEAM_NAME,0,2) = '드래' ;

-- 2)
SELECT *
	FROM TEAM t 
	WHERE TEAM_ID = 'K07' OR TEAM_ID = 'K02' AND TEAM_ID = 'K01'; -- AND가 우선이다.
	
SELECT *
	FROM TEAM t 
	WHERE TEAM_ID = 'K01' AND TEAM_ID = 'K07' OR TEAM_ID = 'K02'; -- AND가 우선이다.

SELECT *
	FROM TEAM t 
	WHERE (TEAM_ID = 'K02' OR TEAM_ID = 'K07') AND TEAM_ID = 'K01'; -- ()가 우선이다.
	
SELECT *
	FROM TEAM t 
	WHERE TEAM_ID IN ('K02', 'K07') AND TEAM_ID = 'K01'; -- IN이 우선이다.
	
SELECT *
	FROM TEAM t 
	WHERE TEAM_ID NOT IN ('K02', 'K07');

SELECT *
	FROM TEAM t 
	WHERE NOT TEAM_ID IN ('K02', 'K07'); -- 이게 원래 맞는 문법
	
SELECT *
	FROM TEAM t 
	WHERE (TEAM_ID = 'K02' OR TEAM_ID = 'K07');
	
SELECT *
	FROM TEAM t 
	WHERE (TEAM_ID != 'K02' AND TEAM_ID != 'K07');
	
SELECT *
	FROM TEAM t 
	WHERE TEAM_ID IN (SELECT TEAM_ID 
						FROM TEAM t2
						WHERE TEAM_NAME LIKE '드래곤%'
						OR TEAM_NAME LIKE '삼성%');
						
-- SQL 연산자(IN 절, IS, BETWEEN, NOT 등)를 제외하면 가증 높은 우선순위를 가진다.
-- AND와 OR절이 있다면9연속으로) AND절을 먼저 실행한 후 OR절 
					
-- 2)
SELECT * 
	FROM PLAYER p 
	WHERE "POSITION" = 'MF';
	
-- 3)
SELECT *
	FROM PLAYER p
	WHERE p.TEAM_ID IN ('K02', 'K07')
	AND "POSITION" = 'MF';

-- 4) K02는 FW와 K07은 MF
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' AND "POSITION" = 'FW'
	OR TEAM_ID = 'K07' AND "POSITION" = 'MF';
	
SELECT *
	FROM PLAYER p 
	WHERE (TEAM_ID, "POSITION") IN (('K02', 'FW'), ('K07', 'MF')); -- 복합쿼리
	
-- 5)
SELECT *
	FROM PLAYER p 
	WHERE HEIGHT >= 170 AND HEIGHT <= 180;
-- 이상과 이하(포함)으로 되어 있는 요구사항에 대해서는 BETWEEN a AND b
-- 반드시 a가 b보다 작아야 함
SELECT *
	FROM PLAYER p 
	WHERE HEIGHT BETWEEN 170 AND 180;
	
SELECT *
	FROM PLAYER p 
	WHERE HEIGHT NOT BETWEEN 170 AND 180;
	
SELECT *
	FROM PLAYER p 
	WHERE HEIGHT < 170 OR HEIGHT >180;
	
SELECT *
	FROM PLAYER p 
	WHERE NOT (HEIGHT < 170 OR HEIGHT >180);
	
SELECT *
	FROM PLAYER p 
	WHERE NOT HEIGHT < 170 AND NOT HEIGHT >180;
	
-- MF가 아닌 선수들
SELECT PLAYER_NAME , "POSITION" 
	FROM PLAYER p 
	WHERE NOT "POSITION" = 'MF';
SELECT PLAYER_NAME , "POSITION" 
	FROM PLAYER p 
	WHERE "POSITION" != 'MF';
SELECT PLAYER_NAME , "POSITION"
	FROM PLAYER p 
	WHERE "POSITION" ^= 'MF';
SELECT PLAYER_NAME , "POSITION" 
	FROM PLAYER p 
	WHERE "POSITION" <> 'MF';
	

-- 1) K리그 선수들의 이름,포지션, 백넘버
-- 2) K02(삼성블루윙즈) 이거나 K07(드래곤즈)에 소속
-- 3) 포지션이 미드필더(MF)
-- 4) 키가 170 이상 180 이하
SELECT PLAYER_NAME , "POSITION" , BACK_NO , HEIGHT , TEAM_ID 
	FROM PLAYER p
	WHERE (TEAM_ID = 'K02' OR TEAM_ID = 'K07')
		AND "POSITION" = 'MF'
		AND (HEIGHT >= 170 AND HEIGHT <= 180);
		
SELECT PLAYER_NAME "선수 이름", "POSITION" 포지션, BACK_NO 등번호
	FROM PLAYER p 
	WHERE (TEAM_ID,"POSITION")  IN (('K02', 'MF'), ('K07', 'MF'))
	AND HEIGHT BETWEEN 170 AND 180;
	
SELECT PLAYER_NAME "선수 이름", "POSITION" 포지션, BACK_NO 등번호
	FROM PLAYER p 
	WHERE TEAM_ID  IN ('K02', 'K07')
	AND "POSITION" = 'MF'
	AND HEIGHT BETWEEN 170 AND 180;
	

-- 위 연산 결과에 선수이름, 포지션, 등번호 , 팀명
SELECT PLAYER_NAME "선수 이름", "POSITION" 포지션, BACK_NO 등번호, TEAM_NAME 팀이름
	FROM PLAYER p JOIN TEAM t 
	ON p.TEAM_ID = t.TEAM_ID	
	WHERE p.TEAM_ID  IN ('K02', 'K07')
	AND "POSITION" = 'MF'
	AND HEIGHT BETWEEN 170 AND 180;

SELECT PLAYER_NAME "선수 이름", "POSITION" 포지션, BACK_NO 등번호, TEAM_NAME 팀이름
	FROM PLAYER p, TEAM t 
	WHERE p.TEAM_ID = t.TEAM_ID	
	AND p.TEAM_ID  IN ('K02', 'K07')
	AND "POSITION" = 'MF'
	AND HEIGHT BETWEEN 170 AND 180;

-- NULL : 미지의 정의되지 않은 값
-- 다른 SQL 연산자는 연산자 앞 혹은 컬럼의 값
-- 기본 연산은 의미 없고 무조건 컬럼 앞
-- 필요시 () 괄호로 묶어 작업

-- IS 연산자 뒤에 NOT, 컬럼의 앞에 NOT
SELECT *
	FROM EMP e 
	ORDER BY COMM IS NULL; -- DB에서는 가증 큰 값을 NULL로 판단
	