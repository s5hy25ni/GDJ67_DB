-- SELECT 기본 문법

-- SELECT 컬럼명 FROM 테이블명 WHERE 컬럼명 = '값';
-- INSERT INTO 테이블명(컬럼, 컬럼, 컬럼, ...) VALUES ('값', '값', '값', ...);
-- DELETE FROM 테이블명 WHERE 컬럼 = '값';
-- UPDATE 테이블명 SET 컬럼 = '값' WHERE 컬럼 = '값';

SELECT * -- wildcasd 모든 것
	FROM PLAYER p ;

SELECT DISTINCT (TEAM_ID), PLAYER_NAME  
	FROM PLAYER p; -- 테이블 ALIAS
	
SELECT PLAYER.*	-- 잘못된 코드
	FROM PLAYER p; -- FROM절에 ALIAS를 사용했으면 반드시 ALIAS 사용
	
SELECT PLAYER.*
	FROM PLAYER; -- 얘는 댐
	
-- '(SINGLE QUOTE)'와 "(DOUBLE QUOTE)" 차이점
SELECT *
	FROM PLAYER p
	WHERE PLAYER_ID = '2007080'; -- ''는 값을 입력할 때 사용
	
SELECT '난 값이다'
	FROM DUAL; -- DUAL 가상 테이블
	
SELECT "POSITION"  -- ""는 예약어를 호출할 때 사용
	FROM PLAYER p ;

--CREATE TABLE "aaa"(); -- ""는 소문자도 작성 가능 근데 사용 X
-- "" 로 작성한 컬럼 혹은 테이블은 작성된 방식으로만 선언 및 사용 가능
-- CREATE TABLE "AAA"(); 도 호출 시 반드시 "" 사용 가능
-- 컬럼과 테이블은 ""을 사용하지 않는 이상 소문자로 작성을 해도 대문자로 인식

SELECT PLAYER_NAME
	FROM PLAYER p ; -- ""가 없으면 모두 대문자로 인식
	
-- 컬럼 ALIAS
SELECT PLAYER_ID AS 아이디,
		PLAYER_ID 아이디,
		PLAYER_NAME 이름, -- ''은 값이기 때문에 ALIAS로 사용 X
		NATION "우리 나라" -- ALIAS에 공백이 있으면 "" 사용
	FROM PLAYER p ;

SELECT WEIGHT / (HEIGHT*HEIGHT) BMI
	FROM PLAYER p ;

-- FROM 절 ALIAS와 SELECT ALIAS는 다르다.
-- FROM 절에 ALIAS가 있다면 필수, 테이블 명과 ALIAS를 복합으로 사용 불가

SELECT t.TEAM_ID , t.E_TEAM_NAME
	FROM TEAM t ;

SELECT TEAM_ID , E_TEAM_NAME
	FROM TEAM;

-- 문제) 선수들의 정보와 팀의 이름을 조회하고 싶다.
-- 선수들의 정보를 PLAYER
-- 팀의 정보는 TEAM
-- PLAYER 테이블과 TEAM 테이블은 TEAM_ID로 연관관계

SELECT *
	FROM PLAYER p JOIN TEAM t -- 선행테이블이 앞에 나옴
	ON p.TEAM_ID = t.TEAM_ID ;





















