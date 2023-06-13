-- PL/SQL 기초
-- Procedure(절차) Language : SQL문은 단일실행 -> 조건에 따라 동작할 수 있도록 함
-- Merge, Function, Trigger
-- 장점 : 절차 언어 -> 조건 처리 가능 -> Transaction 처리 및 코드 간소화
-- 단점 :	1) Function 하나를 생성 -> 생성된 Function은 수정이 되지 않음(새로 만들어야 함)
--				2) 만들어진 Function은 읽어낼 수가 없음 -> 유지보수가 안되고 독과점이 될 수 있음
--				3) 기능을 많이 선언할수록 RDBMS가 무거워 짐
--				4) DB를 이관시킬 수 없음(데이터만 이관, 기능은 못함)

-- 기본 문법
-- 생성
--CREATE OR REPLACE [프로시저 이름]
--IS
--	BEGIN
--		SQL문작성;
--	END;
--	[EXCEPTION]

-- 사용 이유 및 장단점
-- FOR문, IF문과 같은 조건문을 사용하거나 복잡하고 연속된 쿼리를 작업하고 싶을 때
-- CASE문으로 작성했던 문법 중에서 부서가 20이면 보너스를 100 주고 10이면 ~ M으로 시작되는 사원이라면 ~

CREATE OR REPLACE PROCEDURE TEST_PL
(
	IN_YEAR IN VARCHAR2,
	IN_MONTH IN VARCHAR2,
	IN_DATE IN VARCHAR2
)
IS
BEGIN
	DBMS_OUTPUT.PUT_LINE(IN_YEAR || '/' || IN_MONTH || '/' || IN_DATE);
END;

-- 실행
-- CMD
-- CONSOLE 출력시 PL/SQL은 결과를 출력하지 않음
-- 따라서 SET SERVEROUTPUT ON; 명령어를 통해서 결과를 볼 수 있도록 설정 = 콘솔창 활성화
-- PL/SQL의 실행은 EXEC명렁어 프로시저명(아규먼트);
-- ex) SQL> EXEC TEST_PL('','','');

-- 부서를 등록하는데, 부서가 있다면 -> 이미 등록된 부서입니다.
-- 없는 부서라면 INSERT + 입력완료
-- 예외가 발생하면 ROLLBACK + ERROR
CREATE OR REPLACE PROCEDURE RL_DEPT_INSERT
(
	V_DEPTNO IN NUMBER,
	V_DNAME IN VARCHAR2,
	V_LOC IN VARCHAR2,
	V_RESULT OUT VARCHAR2
)
IS 
	CNT NUMBER := 0;
BEGIN 
	SELECT COUNT(*) INTO CNT 
		FROM DEPT d 
		WHERE DEPTNO = V_DEPTNO;
IF CNT < 0 THEN
	V_RESULT := '이미 등록된 부서입니다.';
ELSE 
	INSERT INTO DEPT(DEPTNO, DNAME, LOC)
		VALUES(V_DEPTNO, V_DNAME, V_LOC);
	COMMIT;
	V_RESULT := '입력 완료';
END IF;
EXCEPTION
	WHEN OTHERS THEN
	ROLLBACK;
	V_RESULT := 'ERROR';
END;

CREATE OR REPLACE PROCEDURE PL_DEPT_INSERT
(
   V_DEPTNO IN NUMBER,
   V__D_NAME IN VARCHAR2,
   V_LOC IN VARCHAR2,
   V_RESULT OUT VARCHAR2
)
IS
   CNT NUMBER :=0;
BEGIN
   SELECT COUNT(*) INTO CNT
      FROM DEPT d 
      WHERE DEPTNO = V_DEPTNO;
IF CNT>0 THEN
   V_RESULT:= '이미 등록된 부서입니다';
ELSE
   INSERT INTO DEPT(DEPTNO, DNAME, LOC)
      VALUES(V_DEPTNO, V_DNAME, V_LOC);
   COMMIT;
   V_RESULT:= '입력완료';
END IF;
EXCEPTION
   WHEN OTHERS THEN 
   ROLLBACK
   V_RESULT:= 'ERROR';
END;


-- TRIGGER 자동으로 작동
-- 자동으로 호출되고 수행되도록 만들어 놓은 명령문의 집합
-- PL과의 차이점 -> 테이블의 자신을 대상으로 함
-- TRIGGER는 조건에 의해서 다른 테이블의 값을 입력하거나 수정하게 됨

-- 주문테이블에서 실시간으로 데이터가 입력 됨
-- 입력이 되면 자동으로 TRIGGER가 발생 -> 일자별 판매집계 테이블에 일자별, 상품별, 판매수량과 판매금액을 계산하여 업데이트

-- 주문정보 테이블
CREATE TABLE ORDER_LIST(
	ORDER_DATE CHAR(8) NOT NULL,
	PRODUCT VARCHAR2(100) NOT NULL,
	QTY NUMBER NOT NULL,
	AMOUNT NUMBER NOT NULL
);
-- 일자별집계 테이블
CREATE TABLE SALES_PER_DATE(
	SALE_DATE CHAR(8) NOT NULL,
	PRODUCT VARCHAR2(100) NOT NULL,
	QTY NUMBER NOT NULL,
	AMOUNT NUMBER NOT NULL 
);

CREATE OR REPLACE TRIGGER SUMMARY_SALES
	AFTER INSERT 
	ON ORDER_LIST
	FOR EACH ROW
DECLARE 
	O_DATE ORDER_LIST.ORDER_DATE%TYPE;
	O_PRODUCT ORDER_LIST.PRODUCT%TYPE;
BEGIN
	O_DATE := :NEW.ORDER_DATE;
	O_PRODUCT := :NEW.PRODUCT;
	UPDATE SALES_PER_DATE
		SET QTY = QTY + :NEW.QTY, AMOUNT = AMOUNT + :NEW.AMOUNT
		WHERE SALE_DATE = O_DATE
			AND PRODUCT = O_PRODUCT;
	IF SQL%NOTFOUND THEN
		INSERT INTO SALES_PER_DATE
			VALUES(O_DATE, O_PRODUCT, :NEW.QTY, :NEW.AMOUNT);
	END IF;
END;

INSERT INTO ORDER_LIST
	VALUES('20230607','KEYBORAD','10','10');
	
---------------------------------------------------------------------------
CREATE TABLE 상품(
	상품코드 CHAR(4) CONSTRAINT 상품_PK PRIMARY KEY,
	상품 VARCHAR2(20) NOT NULL,
	제조자 VARCHAR2(50),
	소비자가격 NUMBER,
	재고수량 NUMBER DEFAULT 0
);

CREATE TABLE 입고(
	입고번호 NUMBER CONSTRAINT 입고_PK PRIMARY KEY,
	상품코드 CHAR(4) CONSTRAINT 입고_FK REFERENCES 상품(상품코드),
	입고일자 DATE DEFAULT SYSDATE,
	입고수량 NUMBER,
	입고단가 NUMBER,
	입고금액 NUMBER
);

-- 입고 시퀀스
CREATE SEQUENCE 입고_SEQ
	START WITH 1 INCREMENT BY 1;
	
-- DUMMY 테이블
INSERT INTO 상품(상품코드, 상품, 제조자, 소비자가격)
	VALUES('A001', '마우스', '삼성', 10000);
INSERT INTO 상품(상품코드, 상품, 제조자, 소비자가격)
	VALUES('A002', '키보드', 'LG', 20000);
INSERT INTO 상품(상품코드, 상품, 제조자, 소비자가격)
	VALUES('A003', '모니터', 'DELL', 50000);

SELECT *
	FROM 상품;
SELECT *
	FROM 입고;

-- 입력 트리거(입고 테이블에 상품이 입력되었을 때 재고를 증가시킴)
-- 입고 테이블에 키보드가 10개가 입고되면 상품테이블의 A002 재고를 +10
CREATE OR REPLACE TRIGGER PRODUCT_INSERT
	AFTER INSERT ON 입고
	FOR EACH ROW 
	BEGIN 
		UPDATE 상품 SET 재고수량 = :NEW.입고수량 + 재고수량
			WHERE 상품코드=:NEW.상품코드;
	END;
	
INSERT INTO 입고
	(입고번호, 상품코드, 입고수량, 입고단가, 입고금액)
	VALUES(입고_SEQ.NEXTVAL, 'A002', 10, 20000, 200000);
	
-- 수정트리거
-- 입고 테이블에 상품의 입고 수량이 변경되었을 때 상품테이블의 재고 수량을 변경
CREATE OR REPLACE TRIGGER PRODUCT_UPDATE
	AFTER UPDATE ON 입고
	FOR EACH ROW
	BEGIN
		UPDATE 상품 SET 재고수량 = 재고수량 - :OLD.입고수량 + :NEW.입고수량
		WHERE 상품코드 = :NEW.상품코드;
	END;

UPDATE 입고 SET 입고수량=7
	WHERE 입고번호=1;
	
-- 삭제트리거
CREATE OR REPLACE TRIGGER PRODUCT_DELETE
	AFTER DELETE ON 입고
	FOR EACH ROW
	BEGIN
		UPDATE 상품 SET 재고수량 = 재고수량 -:OLD.입고수량
		WHERE 상품코드 = :OLD.상품코드;
	END;

DELETE FROM 입고 WHERE 입고번호 = 2;

--SET SERVEROUTPUT ON;
--VARIABLE RSLT VARCHAR2(30);
--EXEC PL_DEPT_INSERT(88,'SW','DEVELOPER',:RSLT);
-- PRINT RSLT

CREATE OR REPLACE PROCEDURE PL_DEPT_INSERT
(
   V_DEPTNO IN NUMBER,
   V_DNAME IN VARCHAR2,
   V_LOC IN VARCHAR2,
   V_RESULT OUT VARCHAR2
)
IS 
   CNT NUMBER:=0;
BEGIN
   SELECT COUNT(*) INTO CNT
   FROM DEPT d 
   WHERE DEPTNO =V_DEPTNO;
IF CNT > 0 THEN 
   V_RESULT:='이미 등록된 부서입니다';
ELSE
   INSERT INTO DEPT(DEPTNO,DNAME,LOC)
      VALUES(V_DEPTNO,V_DNAME,V_LOC);
   COMMIT;
   V_RESULT:='입력완료';
END IF;
EXCEPTION
   WHEN OTHERS THEN
   ROLLBACK;
   V_RESULT:='ERROR';
END;