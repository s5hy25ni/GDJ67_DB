-- JOIN
-- 정규화 이전의 테이블로 구성 하는 것
-- EQU JOIN 등가조인 : PK-FK 관계에서 1:1로 발생
-- NON-EQUI JOIN 비등가조인 : 범위를 가지고 조인

-- PLAYER 축구선수, TEAM 팀정보 테이블이 
-- TEAM_ID를 통해 관계를 가지고 있음
-- TEAM 부모, PLAYER 자식

-- 문제 > 선수들의 정보와 팀명도 저회
SELECT PLAYER_ID , PLAYER_NAME , TEAM_ID 
	FROM PLAYER p ; -- 484명
	
SELECT TEAM_ID , TEAM_NAME 
	FROM TEAM t ; -- 15개
	
--1) CATESIAN PRODUCT, CROSS JOIN : JOIN이 될 수 있는 무작위 조인
	-- 484*15 새로운 조인 테이블 생성
SELECT *
	FROM PLAYER p , TEAM t ; -- FROM 절 JOIN
SELECT *
	FROM PLAYER p CROSS JOIN TEAM t ;
	

SELECT PLAYER_ID , PLAYER_NAME , p.TEAM_ID , TEAM_NAME
	FROM PLAYER p , TEAM t 
	WHERE p.TEAM_ID = t.TEAM_ID ;

-- 플레이어, 팀명, 경기장명
SELECT PLAYER_NAME , TEAM_NAME, STADIUM_NAME
	FROM PLAYER p JOIN TEAM t
	ON p.TEAM_ID = t.TEAM_ID 
	JOIN STADIUM s 
	ON t.STADIUM_ID = s.STADIUM_ID;

SELECT PLAYER_NAME , TEAM_NAME, STADIUM_NAME
	FROM PLAYER p, TEAM t, STADIUM s 
	WHERE p.TEAM_ID =t.TEAM_ID 
		AND t.STADIUM_ID = s.STADIUM_ID ;

SELECT t.TEAM_NAME AS HOMETEAM, t2.TEAM_NAME AS AWAYTEAM
	FROM SCHEDULE s JOIN TEAM t 
	ON S.HOMETEAM_ID = t.TEAM_ID
	JOIN TEAM t2
	ON S.AWAYTEAM_ID = t2.TEAM_ID ;
	
SELECT t.TEAM_NAME AS HOMETEAM, t2.TEAM_NAME AS AWAYTEAM
	FROM SCHEDULE s , TEAM t , TEAM t2 
	WHERE s.HOMETEAM_ID = t.TEAM_ID 
		AND s.AWAYTEAM_ID = t2.TEAM_ID ;