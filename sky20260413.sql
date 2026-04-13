------------------------------------------------------------------------------
DDL : data definition language
구조를 생성, 변경, 제거
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

[1] 테이블 복사
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
        WHERE   1 = 0 ; 
    
    
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
        









