-- PIVOT 11G 부터 나온 함수
-- PIVOT & UNPIVOT
-- PIVOT 이란? 행을 열로 변환할 때 GROUP BY + 집계 + CASE 을 사용하여 변환
--						PIVOT 사용시 변경이 간단해짐
-- 					FROM절에서 값을 구분할 조건절로 만들어서 컬럼명과 IN으로 값을 생성

CREATE TABLE STUDENT(
	JOIN_MONTH VARCHAR2(10),
	NAME VARCHAR2(20)
);

INSERT INTO STUDENT s VALUES('1월','또치');
INSERT INTO STUDENT s VALUES('1월','또치');
INSERT INTO STUDENT s VALUES('1월','둘리');
INSERT INTO STUDENT s VALUES('2월','또치');
INSERT INTO STUDENT s VALUES('2월','둘리');
INSERT INTO STUDENT s VALUES('2월','고길동');

SELECT *
	FROM STUDENT s ;
	
SELECT *
	FROM STUDENT s 
	PIVOT(COUNT(JOIN_MONTH) FOR JOIN_MONTH IN ('1월', '2월'));
	
SELECT '둘리' NAME, '2' 일월, '1' 이월 FROM DUAL 
UNION ALL
SELECT '또치' NAME, '1' 일월, '1' 이월 FROM DUAL;

SELECT NAME, COL_NUM, COL_VAL
	FROM 
	(
		SELECT '둘리' NAME, '2' ONE, '1' TWO FROM DUAL
		UNION ALL
		SELECT '또치' NAME, '1' ONE, '1' TWO FROM DUAL
	)
UNPIVOT
	(
		COL_VAL FOR COL_NUM IN(ONE, TWO)
	)
	ORDER BY 1;
	
WITH TEMP AS(
	SELECT 1 AS COL1, 2 AS COL2, 3 AS COL3 FROM DUAL
)
SELECT COL_NM, COL_VAL
	FROM(SELECT *
					FROM TEMP)
UNPIVOT
	(
		COL_VAL FOR COL_NM IN (COL1,COL2,COL3)
	);