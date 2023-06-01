-- SET Operation : 집합연산자
-- 서로 다른 두 개의 쿼리 결과를 출력해서 볼 수 있음
-- 컬럼의 갯수(선행 테이블)와 타입만 같다면(익명적 형변환XX) 두 개의 결과를 붙여서 볼 수 있음
-- 선행 테이블의 컬럼명을 후행 테이블이 따라감(변경 불가)
-- 주의사항!! 
--	1) ORDER BY는 맨 마지막에 작성해야 함
-- 	2) 같은 타입의 컬럼이 출력되어야 함(익명적 형변환XX, char-varchar는 상관 없음)
-- 	3) 컬럼은 선행 테이블의 컬럼명으로 정해짐

-- UNION : 중복되는 ROW 제거
-- UNION ALL : 두 개를 쿼리를 단순히 붙여서 출력
-- INTERSECT : 교차되는 ROW의 결과(합집합)
-- MINUS : 선행 테이블에서 교차되는 값을 제거한 순수한 선행 테이블의 ROW(차집합)
SELECT PLAYER_NAME , TO_CHAR( BACK_NO) -- varchar, char
	FROM PLAYER p
UNION
SELECT TEAM_ID , TEAM_NAME -- char, varchar
	FROM TEAM t ;
	
-- 문) 축구선수 정보 중에서 K02와 K07의 정보를 출력
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' OR TEAM_ID = 'K07';
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' 
UNION
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K07';
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID IN ('K02', 'K07');
	
SELECT PLAYER_NAME  이름, TEAM_ID , '1' -- 후행 "POSITION"이 문자이니까 문자
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' 
UNION
SELECT PLAYER_NAME , TEAM_ID , "POSITION" 
	FROM PLAYER p 
	WHERE TEAM_ID = 'K07';
	
SELECT PLAYER_NAME  이름, TEAM_ID , '1' AS 책임, 99 AS 등번호-- NVL은 문자-숫자에서 익명적 형변환이 일어나지만('A'가 아닌 이상), UNION은 익명적 형변환 XX 
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' 
UNION
SELECT PLAYER_NAME , TEAM_ID , "POSITION" , NVL(BACK_NO, '99')
	FROM PLAYER p 
	WHERE TEAM_ID = 'K07';
	
-- DB에서 NULL이 가장 큰 값을 가진다 : 숫자 -> 문자 -> NULL
SELECT COMM , ENAME 
	FROM EMP e 
	ORDER BY COMM DESC, ENAME ;
	
-- 문) 삼성블루윙즈(K02)와 전남드래곤즈인 선수들의 정보를 모두 출력
-- OR
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' OR TEAM_ID = 'K07';
-- IN 
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID IN ('K02', 'K07');
-- UNION
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
UNION 
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K07';
	
-- 문) 축구선수들 중에서 소속이 삼성블루윙즈(K02)인 선수들과
--		포지션이 GK인 선수들을 출력
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
UNION
SELECT *
	FROM PLAYER p2
	WHERE "POSITION" = 'GK' -- 88
	
SELECT COUNT(*)
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'; -- 49
	
SELECT COUNT(*)
	FROM PLAYER p 
	WHERE "POSITION" = 'GK'; -- 43
	
SELECT COUNT(*)
	FROM PLAYER p 
	WHERE TEAM_ID='K02' AND "POSITION" = 'GK'; -- 삼성이면서 GK, INTERCEPT
	
SELECT COUNT(*)
	FROM PLAYER p 
	WHERE TEAM_ID='K02' AND "POSITION" != 'GK'; -- 삼성이면서 NOT GK, MINUS
	
	
-- UNION 88개, K02 + KO2가 아니면서 GK
SELECT PLAYER_ID 
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
UNION
SELECT PLAYER_ID 
	FROM PLAYER p2 
	WHERE "POSITION" = 'GK';
	
-- 11
SELECT TEAM_ID 
	FROM PLAYER p 
	WHERE TEAM_ID ='K02'
UNION 
SELECT TEAM_ID 
	FROM PLAYER p2 
	WHERE "POSITION" = 'GK';
	
-- 15 -> GK 없는 팀이 있구낭,,,
SELECT DISTINCT (TEAM_ID)
	FROM PLAYER p ;
	
SELECT TEAM_ID 팀, PLAYER_ID 
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
UNION
SELECT TEAM_ID, PLAYER_ID 
	FROM PLAYER p2 
	WHERE "POSITION" = 'GK'
--	ORDER BY 2, 1; -- INDEX
--	ORDER BY 팀, 2; -- ALIAS
	ORDER BY 팀, PLAYER_ID ; -- 컬럼명
	
-- 92 (중복값 제거 X)
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
UNION ALL
SELECT *
	FROM PLAYER p2 
	WHERE "POSITION" = 'GK';
	
-- UNION은 같은 값이면 제거하고 출력
-- 		같은 값이란? SELECT절에서 선택된 컬럼만을 대상으로 함!
-- UNION인 경우 : K02(49) + GK(43) - K02 이면서 GK(4) = TOTAL(88)
-- UNION ALL인 경우 : K02(49) + GK(43) = TOTAL(92)
-- 교차인 4명(K02 이면서 GK)은 INTERSECT를 통해 검색 가능

-- 문) 축구선수들 중에서 포지션별 평균키와 팀별 평균키를 출력
-- ~~별 절대로 같은 쿼리로 동작 불가 -> 집계 함수는 여러개 값이 입력되어 하나의 결과, 같은 출력이 안됨
-- ~~별 ~~별 (직원의 팀별 월별 인사인원과 -> HIREDATE에서 월을 추출하여 CASE문을 통해 작성, 그길고 GROUP BY)
-- ~~별 단일 출력 -> WINDOW절의 사용 (ROW_NUMBER() OVER(PARITITION BY 컬럼))
-- 연관서브 쿼리
-- JOIN을 통해서도 가능
SELECT "POSITION" ,AVG(HEIGHT) AS 평균키
	FROM PLAYER p 
	WHERE "POSITION" IS NOT NULL
	GROUP BY "POSITION" 
UNION
SELECT TEAM_ID , AVG(HEIGHT)
	FROM PLAYER p 
	GROUP BY TEAM_ID ;
	
-- 선수들의 이름과, 키와, 축구선수 전체 평균을 출력하고 싶음
SELECT TEAM_ID , TRUNC(AVG(HEIGHT)) 
	FROM PLAYER p 
	GROUP BY TEAM_ID ;
	
SELECT PLAYER_NAME , HEIGHT , TEAM_ID 
	FROM PLAYER p ;
	
SELECT PLAYER_NAME , HEIGHT , TEAM_ID, 팀평균, (SELECT TRUNC(AVG(HEIGHT)) FROM PLAYER p2 ) 전체평균
	FROM PLAYER p JOIN (
								SELECT TEAM_ID , TRUNC(AVG(HEIGHT)) 팀평균
									FROM PLAYER p 
									GROUP BY TEAM_ID
	) pa
	USING(TEAM_ID);

-- GROUP BY 주의점
SELECT JOB, COUNT(NVL(COMM, 0))
	FROM EMP e 
	GROUP BY JOB, COMM; -- JOB || COMM -- 묶음으로 JOB AND COMM 이라는 조건으로 GROUP BY
	
SELECT COMM
	FROM EMP e 
	GROUP BY COMM;

SELECT JOB||COMM
	FROM EMP e ;
	

-- 문) 축구선수들 중에서 K02 이면서 MF가 아닌 선수들의 정보
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID ='K02' AND 
--	"POSITION" != 'MF';
--	"POSITION" ^= 'MF';
--	"POSITION" <> 'MF';
	NOT "POSITION" = 'MF';
	
-- 차집합 구하기
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'; -- 49
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02' AND "POSITION" = 'MF'; -- 18
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
MINUS 	
SELECT *
	FROM PLAYER p2 
	WHERE "POSITION" = 'MF'; -- 31
	
-- 문) 축구선수들 중에서 소속이 K02 이면서 포지션이 MF
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID ='K02'
INTERSECT
SELECT *
	FROM PLAYER p 
	WHERE "POSITION" = 'MF';
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID='K02' AND "POSITION" ='MF';
	
SELECT *
	FROM PLAYER p 
	WHERE TEAM_ID = 'K02'
MINUS
SELECT *
	FROM PLAYER p 
	WHERE "POSITION" = 'MF';