-- C:\Users\GDJ67>sqlplus system/admin	접속
-- SQL> desc dba_data_files;	tablespace의 위치 및 파일 확인
-- SQL> select FILE_NAME from dba_data_files;	dba_data_files의 FILE_NAME 확인

-- SQL> CREATE TABLESPACE SQLD // DDL 명령어 : 생성 
--			DATAFILE 'C:\APP\GDJ67\PRODUCT\21C\ORADATA\XE\SQLD.DBF' // 파일 생성 위치, 파일명 설정 
--			SIZE 300M // 초기 크기 
--			AUTOEXTEND ON NEXT 50M // 초기 크기를 넘어 갈 때 확장 크기 
--			MAXSIZE 500M; // 테이블스페이스의 최대 크기

-- SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;	// 12c부터는 일반계정은 '계정##' 형태로 생성해야 함 -> 이거 무시
-- 
-- SQL> CREATE USER SQLD IDENTIFIED BY sqld;		// 유저 생성
-- SQL> DESC DBA_USERS;	// DB의 모듈 유저 조회
-- SQL> SELECT USERNAME FROM DBA_USERS;		// 생성된 유저 확인

-- SQL> ALTER USER SQLD DEFAULT TABLESPACE SQLD QUOTA UNLIMITED ON SQLD;	// 계정이 사용할 테이블스페이스를 연결, quota를 통해서 해당 테이블 스페이스의 사용 크기 할당
-- SQL> ALTER USER SQLD TEMPORARY TABLESPACE TEMP;	// 임시 테이블스페이스 연결

-- SQL> GRANT DBA, RESOURCE, CONNECT TO SQLD;	// 계정의 권한 부여(role을 통해서)

-- SQL> @script파일.sql;	// 스크립트 실행