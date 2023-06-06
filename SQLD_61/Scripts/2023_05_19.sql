-- SELECT 기본 문법

-- SELECT 컬럼명 FROM 테이블명 WHERE 컬럼명 = '값';
-- INSERT INTO 테이블명(컬럼, 컬럼, 컬럼, ...) VALUES ('값', '값', '값', ...);
-- DELETE FROM 테이블명 WHERE 컬럼 = '값';
-- UPDATE 테이블명 SET 컬럼 = '값' WHERE 컬럼 = '값';

SELECT * -- wildcard 모든 것
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

SELECT p.*, TEAM_NAME, TEAM_NAME
-- TEAM, TEAM_NAME -- FROM 절 ALIAS를 사용하여  지정해줘야 함
	FROM TEAM t JOIN PLAYER p
	ON p.TEAM_ID = t.TEAM_ID;
	
-- 급여가 1250 초과하면서 직무가 SALESMAN인 직원의 정보와 부서명 조회
-- 사용되는 테이블 EMP:직원 정보, 급여, 직무
-- 				DEPT : 부서명
-- EMP와 DEPT는 DEPTNO로 연관 컬럼을 가지고 있음
-- 조건 SAL > 1250, JOB = 'SALESMANE'
SELECT *
	FROM EMP e;
SELECT *
	FROM DEPT d;
SELECT ENAME, JOB, SAL, DEPTNO
	FROM EMP e
	WHERE SAL > '1250'
		AND JOB = 'SALESMAN';
		
SELECT ENAME, JOB, SAL, DNAME --e.DEPTNO
	FROM EMP e JOIN DEPT d
	ON e.DEPTNO = d.DEPTNO
	WHERE SAL > '1250'
		AND JOB = 'SALESMAN';
		
-- 축구 선수의 정보를 조회
-- 축구선수명(등번호) ex) 박지성(7)
-- CONCATENATION 오라클은 || 연산, 나머지는 +, CONCAT 지원
SELECT PLAYER_NAME , BACK_NO
	FROM PLAYER p ;
	
SELECT PLAYER_NAME || '(' || BACK_NO  || ')' 축구선수
	FROM PLAYER p ;
	
-- BACK_NO 없는 애들 조회 -> 없으면 00 출력
SELECT PLAYER_NAME || '(' || NVL(BACK_NO, '00')  || ')' 축구선수
	FROM PLAYER p
	WHERE BACK_NO IS NULL ;
	
-- 190 page 선수들의 키에서 몸무게를 뺀 값
SELECT PLAYER_NAME , HEIGHT , WEIGHT , HEIGHT-WEIGHT "키-몸무게"
	FROM PLAYER p ;
-- 191 page 다음과 같은 선수들의 출력 형태를 만들어 본다.
-- 선수명 선수, 키 cm, 몸무게 kg
SELECT PLAYER_NAME || ' 선수' 이름, HEIGHT || ' cm' 키, WEIGHT || ' kg' 몸무게
	FROM PLAYER p ;
	
SELECT ENAME || SAL , SAL || ENAME
	FROM EMP e ;



















