SELECT * 	FROM PLAYER p ;

RENAME PLAYER TO PLAYER_OLD;

CREATE TABLE PLAYER AS (
	SELECT PLAYER_ID , PLAYER_NAME , UPPER(E_PLAYER_NAME)  AS E_PLAYER_NAME , TEAM_ID , "POSITION" , BACK_NO , NVL(NATION, '대한민국') AS NATION , BIRTH_DATE , HEIGHT , WEIGHT  
	FROM SQLD.PLAYER
) ;

CREATE TABLE TEAM AS (
	SELECT TEAM_ID , REGION_NAME , TEAM_NAME , ORIG_YYYY , STADIUM_ID , HOMEPAGE
	FROM SQLD.TEAM
);

CREATE TABLE STADIUM AS (
	(SELECT STADIUM_ID , s.STADIUM_NAME AS STADIUM_NAME , HOMETEAM_ID , SEAT_COUNT , t.ZIP_CODE1 AS ZIP_CODE1 , t.ZIP_CODE2 AS ZIP_CODE2 , t.ADDRESS AS ADDRESS , t.DDD AS DDD , t.TEL AS TEL , t.FAX AS FAX 
	FROM SQLD.STADIUM s JOIN SQLD.TEAM t
	USING(STADIUM_ID))
);

CREATE TABLE SCHEDULE AS (
	SELECT STADIUM_ID , SCHE_DATE , GUBUN , HOMETEAM_ID , AWAYTEAM_ID , HOME_SCORE , AWAY_SCORE 
	FROM SQLD.SCHEDULE
);

CREATE TABLE LEAGUE_RANK AS (
	SELECT
	HOMETEAM_ID AS TEAM_ID,
	COUNT(*) AS NUMBER_OF_GAMES,
	COUNT(CASE WHEN HOME_SCORE > AWAY_SCORE THEN 1 END) AS VICTORY,
	COUNT(CASE WHEN HOME_SCORE = AWAY_SCORE THEN 1 END) AS TIE,
	COUNT(CASE WHEN HOME_SCORE < AWAY_SCORE THEN 1 END) AS LOSS,
	ROUND(COUNT(CASE WHEN HOME_SCORE > AWAY_SCORE THEN 1 END)/COUNT(*), 3) AS WINNING_RATE
	FROM SCHEDULE
	WHERE GUBUN='Y'
	GROUP BY HOMETEAM_ID
);

-- String, String, String, String, String, int, String, String, int, int
SELECT * FROM PLAYER p ;
-- String, String, String, String, String, String
SELECT * FROM TEAM t ;
-- String, String, String, int, String, String, String, String, String, String
SELECT * FROM STADIUM s ;
-- String, String, String, String, String, int, int
SELECT * FROM SCHEDULE s ;

SELECT VICTORY-LOSS
	FROM (
				SELECT
					RANK() OVER(ORDER BY WINNING_RATE DESC) RANK,
					lr.*
					FROM LEAGUE_RANK lr
	)
	WHERE RANK = 1;
	
CREATE VIEW FIRST_DIFF AS (
	SELECT VICTORY-LOSS AS DIFF
		FROM (
					SELECT
						RANK() OVER(ORDER BY WINNING_RATE DESC) RANK,
						lr.*
						FROM LEAGUE_RANK lr
		)
		WHERE RANK = 1
);

SELECT *
	FROM FIRST_DIFF;
	
	SELECT
				RANK() OVER(ORDER BY WINNING_RATE DESC) RANK,
				lr.*,
				((SELECT DIFF FROM FIRST_DIFF)-(VICTORY-LOSS))/2 AS DIFF
				FROM LEAGUE_RANK lr