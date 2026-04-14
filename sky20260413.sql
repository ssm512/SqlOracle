------------------------------------------------------------------------------
DDL : data definition language
구조를 생성(CREATE), 변경(ALTER), 제거(DROP)
-> commit, rollback의 대상이 아님

CREATE
ALTER
DROP

계정생성
아이디 : SKY
비밀번호 : 1234
cmd에서
SQL> conn /as sysdba
연결되었습니다.
SQL> show user
USER은 "SYS"입니다
SQL> alter session set "_ORACLE_SCRIPT"=true;
세션이 변경되었습니다.
SQL> CREATE USER SKY IDENTIFIED BY 1234;
사용자가 생성되었습니다.
SQL> GRANT CONNECT, RESOURCE TO SKY;
권한이 부여되었습니다.
SQL> ALTER USER SKY DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
------------------------------------------------------------------------------
새로운 계정으로 접속한 뒤작업예정

sky에 hr계정의 data를 가져온다
sqlplus에서 작업한다
1. hr로 로그인
window + r cmd -> 
c:\> sqlplus hr/1234

2. hr에서 다른계정인 sky에게 select 할 수 있는 권한을 부여
SQL> GRANT SELECT ON EMPLOYEES TO SKY;
권한이 부여되었습니다.

3. sky로 로그인하여 
SQL> conn sky/1234

4. sky에서 hr 계정의 employee를 조회한다
SQL> select * from HR.EMPLOYEES; -- 조회 성공
SQL> select * from HR.departments; -- 조회 실패 (DEPARTMENTS TABLE에는 권한이 없음)
select * from HR.departments
                 *
1행에 오류:
ORA-00942: 테이블 또는 뷰가 존재하지 않습니다

------------------------------------------------------------------------------
ORACLE의 TABLE 복사하기
HR의 EMPLOYEES TABLE을 복사해서 SKY로 가져온다

[1] 테이블 생성(CREATE)
1. 테이블 복사
대상 : 테이블 구조, 데이터 (제약 조건의 일부만 복사(NOT NULL)
1) 구조, 데이터 복사, 제약조건은 일부만 복사 -- 109 rows
CREATE TABLE EMP1
  AS
    SELECT * FROM HR.EMPLOYEES;
2) 50번과 80번 부서만 복사 -- 79 rows
CREATE TABLE EMP2
  AS
    SELECT * FROM HR.EMPLOYEES
    WHERE   DEPARTMENT_ID IN (50, 80);

3) DATA 빼고 구조만 복사
CREATE TABLE EMP3
    AS
        SELECT * FROM HR.EMPLOYEES
        WHERE   1 = 0 ; -- 조건을 false로 해서 구조만 복사
    
    
4) 구조만 복사된 TABLE EMP3에 DATA만 추가
CREATE TABLE    EMP4
    AS
        SELECT * FROM  HR.EMPLOYEES
        WHERE   1 = 0;
        
    -- DATA만 추가
    INSERT INTO EMP4
        SELECT * FROM   HR.EMPLOYEES;
    COMMIT;
    
5)  일부 칼럼만 복사해서 새로운 테이블 생성
CREATE TABLE    EMP5
    AS
        SELECT      EMPLOYEE_ID                         EMPID
                    , FIRST_NAME || ' ' || LAST_NAME    ENAME
                    , SALARY                            SAL
                    , SALARY * COMMISSION_PCT           BONUS
                    , MANAGER_ID                        MGR
                    , DEPARTMENT_ID                     DEPTID
        FROM        HR.EMPLOYEES;
        
SELECT * FROM TAB;

---------------------------------------------------------------------
2. SQLDEVELOPER의 메뉴에서 TABLE 생성
sky계정 우클릭 -> 테이블 메뉴 클릭 -> 새 TABLE 클릭 -> TABLE1 생성 : 이름 EMP6로 변경
              EMPID NUMBER(8, 2) NOT NULL PRIMARY KEY
            , ENAME VARCHAR2(46) NOT NULL
            , TEL VARCHAR2(20) 
            , EMAIL VARCHAR2(320) 

3. SCRIPT로 TABLE생성
CREATE TABLE EMP7
(
  EMPID     NUMBER(8, 2)    NOT NULL -- COLUMN 단위 제약 조건
, ENAME     VARCHAR2(46)    NOT NULL
, TEL       VARCHAR2(20) 
, EMAIL     VARCHAR2(320) 
, CONSTRAINT EMP7_PK PRIMARY KEY        -- TABLE 단위 제약 조건, 복합키 만들때 요런 형식임
  (
    EMPID 
  )
  ENABLE 
);

------------------------------------------------------------------------------
[2] TABLE 제거(DROP) - 영구적으로 구조와 데이터가 제거된다
DROP TABLE EMP1;
-- DROP 되는 TABLE이 부모테이블일 경우 자식을 먼저 지워야 삭제가능함
DROP TABLE EMPLOYEES; -- 삭제안됨
-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-- 테이블이 삭제되지 않는다 : 부모키를 가진 부모테이블은 자식테이블에 데이터가 있다면

DROP TABLE EMPLOYEES CASCADE; -- 부모자식 관계의 데이터를 삭제함

------------------------------------------------------------------------------
[3] 구조변경 (ALTER)
1. 칼럼 추가
ALTER   TABLE   EMP5
    ADD (LOC VARCHAR2(6)); -- 추가된 칼럼은 NULL로 채워짐

2. 칼럼 제거
ALTER TABLE     EMP5
    DROP COLUMN LOC;
    
3. TABLE 이름 변경 - ORACLE 전용 명령어
-- RENAME  EMP4    TO NEWEMP;

4. 칼럼 속성 변경 - 데이터 칸 크기를 늘려주거나 줄인다
ALTER   TABLE   EMP5
    MODIFY  (ENAME VARCHAR2(60)); -- 46 -> 60
-- 줄일때 데이터의 내용이 있으면 내용이 소실될(잘려나갈) 수 있다

------------------------------------------------------------------------------
테이블을 생성하고 데이터를 파일에서 가져온다
CREATE  TABLE   ZIPCODE
(
    ZIPCODE     VARCHAR2(7)                 -- 우편번호
    ,SIDO       VARCHAR2(6)                 -- 시도
    ,GUGUN      VARCHAR2(26)                -- 구군
    ,DONG       VARCHAR2(78)                -- 읍면동리건물명
    ,BUNJI      VARCHAR2(26)                -- 번지
    ,SEQ        NUMBER(5)     PRIMARY KEY   -- 일련번호
);

테이블 생성후 ZIPCODE 테이블 선택후 우클릭 -> 데이터 임포트 -> ZIPCODE_UTF8.CSV 선택 ( JAVA, PRJIO에서 들고왔음 )
-- 테이블 생성할떄 각 COLUMN의 칸 크기를 미리 지정해 주는게 좋음

SELECT * FROM ZIPCODE;
SELECT COUNT(*) FROM ZIPCODE;

SELECT  * FROM ZIPCODE WHERE    SIDO = '부산';
SELECT  COUNT(*) FROM ZIPCODE WHERE    SIDO = '부산';

-- 시도별 우편번호 갯수
SELECT          SIDO                    시도
                , COUNT(ZIPCODE)        우편번호갯수
FROM            ZIPCODE
GROUP BY        SIDO
ORDER BY        SIDO DESC;

SELECT          COUNT(ZIPCODE) , COUNT(DISTINCT ZIPCODE)
FROM            ZIPCODE;

SELECT          '[' || ZIPCODE || ']' || 
                SIDO || ' ' 
                || GUGUN || ' ' 
                || DONG || ' ' 
                || BUNJI    AS ADDRESS
                , SEQ
FROM            ZIPCODE
WHERE           DONG    LIKE    '%부전2동%'
ORDER BY        SEQ ASC;