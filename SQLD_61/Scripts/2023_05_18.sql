-- CREATE문 같은 DDL (CREATE, DROP, RENAME, ALTER)

--CREATE TABLE [테이블명] (
--	컬럼 타입(),
--	컬럼 타입() 제약조건,
--);

-- 테이블을 만들 때 테이블명과 컬럼은 무조건 대문자
-- 단, ""를 사용해서 생성하면 대소문자 구분, 예약어도 사용 가능, 생성할 때 특수 경우, 공백 포함 -> 안쓰는게 좋다
-- 제약조건 컬럼 정의, 테이블 정의, ALTER 명령어
CREATE TABLE TESTBOARD(
	NAME VARCHAR2(20),
	"address" VARCHAR2(100),
	BIRTH DATE,
	AGE NUMBER(10)
);

-- p146
-- ALTER
-- 컬럼 추가 (ADD COLUMN) RENAME XX
ALTER TABLE TESTBOARD 
ADD (PHONE VARCHAR2(30));

-- 컬럼 삭제 (DROP COLUMN)
ALTER TABLE TESTBOARD 
DROP COLUMN PHONE;


-- EX) 테이블명은 PASSPORT
-- 		컬럼은 ID 문자3자리
--			NAME 가변문자 50
--			TITLE 가변문자 100
--			REGATE DATE
--		컬럼 추가 DELFLAG 문자 1
--		NAME 컬럼을 삭제

CREATE TABLE PASSPORT(
	ID CHAR(3),
	NAME VARCHAR2(50),
	TITLE VARCHAR2(100),
	REGATE DATE
);

ALTER TABLE PASSPORT 
ADD DELFLAG CHAR(1);

ALTER TABLE PASSPORT 
DROP COLUMN NAME;

-- DESC TESTBORD; // IDE에서는 동작되지 않음(CLI 명령어), IDE는 GUI로 확인

-- 테이블 수정
-- BIRTH에 DEFAULT 값 추가, 현재 날짜(SYSDATE), NN(NOT NULL) 추가

ALTER TABLE TESTBOARD 
MODIFY BIRTH VARCHAR2(10);

ALTER TABLE TESTBOARD 
MODIFY BIRTH DATE;

ALTER TABLE TESTBOARD 
MODIFY BIRTH DEFAULT SYSDATE;

ALTER TABLE TESTBOARD 
MODIFY BIRTH NOT NULL;

-- 제약조건 삭제
ALTER TABLE TESTBOARD 
DROP CONSTRAINT SYS_C008362;

ALTER TABLE TESTBOARD 
MODIFY BIRTH DEFAULT NULL;
-- 수정후 save 누르면 CLI 명령어 나옴

ALTER TABLE TESTBOARD 
MODIFY NAME NOT NULL;

-- 명시적 방법 '' NULL 입력할 때 값이 없음
INSERT INTO TESTBOARD t (NAME, BIRTH)
	VALUES('홍길동','');
INSERT INTO TESTBOARD t (NAME, BIRTH)
	VALUES('홍홍홍', NULL);

UPDATE TESTBOARD SET BIRTH = '20230501'
	WHERE NAME = '홍길동';

SELECT * 
	FROM TESTBOARD t ;

ALTER TABLE TESTBOARD 
	DROP CONSTRAINT SYS_C008364;

INSERT INTO TESTBOARD t (NAME)
	VALUES('길길길');

-- ADDRESS의 크기를 줄여보자
-- ADDRESS의 값이 없다. NULL
ALTER TABLE TESTBOARD
	MODIFY "address" VARCHAR2(5);

-- 서로 변환 가능한 타입은 변경 가능
ALTER TABLE TESTBOARD
	MODIFY "address" CHAR(10);

-- 값이 있으면 NOT NULL 불가
--ALTER TABLE TESTBOARD 
--	MODIFY "address" NOT NULL;

ALTER TABLE TESTBOARD 
	MODIFY BIRTH DEFAULT '20000101'
	
INSERT INTO TESTBOARD t (NAME)
	VALUES('동동동');
	
SELECT *
	FROM SQLD.TESTBOARD t ;
	
-- 컬럼의 이름 변경
-- 컬럼을 바꿀 땐 무조건 ALTER로 시작
ALTER TABLE TESTBOARD 
	RENAME COLUMN NAME TO ID;
	
ALTER TABLE TESTBOARD 
	RENAME COLUMN "address" TO ADDRESS;
	
-- 제약조건 중에서 TABLE의 관계인PK FK
-- TESTBOARD에 PK를 설정하자
ALTER TABLE TESTBOARD
	ADD CONSTRAINT TESTBOARD_PK1
	PRIMARY KEY (ID);

-- PK조건 : UNIQUE KEY, NOT NULL, INDEX -> INDEX는 같이 생성/삭제
ALTER TABLE TESTBOARD
	DROP CONSTRAINT TESTBOARD_PK1;
	
ALTER TABLE TESTBOARD 
	DROP CONSTRAINT TESTBOARD_PK1;

-- pk - fk 관계: 이렇게 하면 안된다!
-- fk? 다른 테이블의 pk

DROP TABLE TESTBOARD ; -- 데이터 및 인덱스, 제약조건 다 삭제

-- 컬럼정의 방식
CREATE TABLE TESTBOARD(
	ID VARCHAR2(10) PRIMARY KEY
);

-- 테이블 정의 방식
CREATE TABLE TESTBOARD(
	ID VARCHAR2(10),
	CONSTRAINT TESTBOARD_PK1 PRIMARY KEY (ID)
);

-- ALTER 방식
-- 특정 컬럼이 선택된 PK라면 다시는 PK가 될 수 없다.
CREATE TABLE TESTBOARD(
	ID VARCHAR2(10)
);

ALTER TABLE TESTBOARD 
	ADD CONSTRAINT TESTBOARD_PK1
	PRIMARY KEY (ID);

-- 다른 곳에서 사용되는 제약조건의 이름은 사용할 수 없다.
--ALTER TABLE TESTBOARD 
--	ADD CONSTRAINT TEAM_PK
--	PRIMARY KEY (ID);

CREATE TABLE T2(
	ID CHAR(5),
	NAME VARCHAR2(10),
	PHONE VARCHAR2(10),
	JOIN_DATE DATE
);

ALTER TABLE T2 
	ADD CONSTRAINT PEOPLE_PK
	PRIMARY KEY (ID);

CREATE TABLE T1(
	SEQ CHAR(5),
	ID CHAR(5),
	TITLE VARCHAR2(20),
	CONTENT VARCHAR2(500),
	REGDATE DATE
);

ALTER TABLE T2 
	ADD CONSTRAINT T2_PK
	PRIMARY KEY (ID);

ALTER TABLE T1 
	ADD CONSTRAINT T1_FK
	FOREIGN KEY (ID)
	REFERENCES T2(ID);

ALTER TABLE T1
	MODIFY SEQ NUMBER;

-- FK관계를 갖는 컬럼은 서로 같은 타입과 크기를 가져야 한다.
ALTER TABLE T2 
	MODIFY PHONE CHAR(5);

ALTER TABLE T1 
	DROP CONSTRAINT BOARD_PK;

-- SEQUENCE는 테이블이다. 
CREATE SEQUENCE T1_SEQ 
	START WITH 1
	INCREMENT BY 1;

-- 부모가 없으면 자식은 안들어간다!
INSERT INTO T2 
	VALUES('MK001', 'KOKOA', '00700', '20230131');
INSERT INTO T2 
	VALUES('MK002', 'BANANA', '00300', '20220506');

INSERT INTO T1 t
	VALUES(T1_SEQ.NEXTVAL, 'MK001', '안녕하세요',
			'가입인사 드립니다.', '20230131');

INSERT INTO T1 t
	VALUES(T1_SEQ.NEXTVAL, 'MK001', '코코아인데요',
			'질문있습니다.', '20230519');

-- 테이블 한 개만 생성할 때는 문제가 없다.
-- 두개가 관계가 있다면 PK-FK 관계라면
-- 연관된 컬럼은 같은 타입과 크기를 가지고 있어야 한다.
-- 값을 입력을 할 때는 반드시 부모(PK만 가지고 있는 테이블)을 먼저 입력하고
-- 사용되는 컬럼의 값을 사용해야 한다.

SELECT T1_SEQ.NEXTVAL
	FROM DUAL;

RENAME T1 TO TEST1;
RENAME T2 TO TEST2;


-- 테이블 삭제
-- DROP 
DROP SEQUENCE T1_SEQ;
DROP TABLE TESTBOARD ;
DROP TABLE TEST1; -- 자식부터 삭제~!
-- 부모에서 옵션을 포함하여 명령어의 의도와 다르게 모든 연관된 자식 테이블도 삭제
-- 사용하지 XX
DROP TABLE TEST2 CASCADE CONSTRAINT; 
DROP TABLE TEST2;


-- 삭제 명령어 179 page
-- DROP : 테이블도 삭제하고 정보도 삭제하는 DDL 명령어 -> 복구 못함
-- TRUNCATE : 테이블의 구조는 두고 정보만 삭제 DDL 명령어 -> 복구 못함
-- DELETE : 테이블의 구조는 두고 정보만 삭제 DML 명령어

DELETE FROM T2;
TRUNCATE TABLE T2;

SELECT *
	FROM T2;
ROLLBACK;

DROP TABLE T2;