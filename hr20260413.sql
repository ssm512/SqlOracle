-------------------------------------------------------------
-- 부프로그램 : 프로시져, 함수
1. 프로시져 (PROCEDURE) -- (SUBROUTINE 같은 의미인데 다른 언어에서 부르는), 함수보다 더 많이 사용한다
: 리턴값이 0개 이상
STORED PROCEDURE : 저장 프로시저
2. 함수 (FUNCTION)
: 반드시 리턴값이 1개

USER DEFINE FUNCTION : 사용자 정의 함수, 우리가 함수를 만든다
-------------------------------------------------------------

SELECT * FROM VIEW_EMP;

-- 107 번 직원의 이름과 월급 조회
SELECT      first_name || ' ' || last_name      직원이름
            , salary                            월급
FROM        employees
WHERE       employee_id = 107;

-- oracle로 프로시저 생성한다
-- 익명 프로시저 (익명 블럭) -- 잠깐 실행하고 없어지는 거
SET SERVEROUTPUT ON; -- 익명 블록 시 꼭 써줘야하는것

DECLARE -- java로치면 일종의 지역변수 선언 하는 부분, 정확하게 말하면 전역변수임 -- 변수선언문
    V_NAME      VARCHAR2(46);
    V_SAL       NUMBER(8, 2);  -- 전체 8자리에 소수점이하 2자리
BEGIN
    V_NAME  := '카리나';
    V_SAL   := 10000;
    DBMS_OUTPUT.PUT_LINE(V_NAME);       -- 출력
    DBMS_OUTPUT.PUT_LINE(V_SAL);
    IF V_SAL >= 10000 THEN
        DBMS_OUTPUT.PUT_LINE('Good');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not Good');
    END IF;
END;
/

-- 저장 프로시저, SELECT INTO는 oracle에서만
-- (IN : INPUT, OUT : OUTPUT, INOUT : INPUTOUT)
-- 파라미터는 IN_EMPID IN NUMBER 괄호와 숫자 사용하지 않는다
-- 내부 변수는 V_NAME VARCHAR2(46); 반드시 괄호와 숫자가 필요하다
CREATE  PROCEDURE       GET_EMPSAL (IN_EMPID IN NUMBER) -- parameter, 여기 number도 type을 의미하는데 ()로 크기를 지정하지 않음
IS
    V_NAME      VARCHAR2(46);
    V_SAL       NUMBER(8, 2);      
    BEGIN
        SELECT      first_name || ' ' || last_name, salary                      
        INTO        V_NAME, V_SAL
        FROM        employees
        WHERE       employee_id = IN_EMPID;
        DBMS_OUTPUT.PUT_LINE('이름 : ' || V_NAME );
        DBMS_OUTPUT.PUT_LINE('월급 : ' || V_SAL );
    END;
/

-- 테스트
SET     SERVEROUTPUT ON; -- DBMS_OUTPUT.PUT_LINE () 읠 결과를 화면에 출력
CALL    GET_EMPSAL(107);
/* 결과값임
이름 : Diana Nguyen
월급 : 4200
*/


-- 부서번호입력, 해당 부서의 최고 월급자의 이름, 월급 출력
CREATE OR REPLACE PROCEDURE GET_NAME_MAXSAL ( 
    IN_DEPT_ID IN NUMBER,
    O_NAME OUT VARCHAR2,
    O_SAL OUT NUMBER
)
IS
        V_MAXSAL    NUMBER(8,2);
        BEGIN
        SELECT      MAX(salary)
        INTO        V_MAXSAL
        FROM        employees
        WHERE       department_id = IN_DEPT_ID;
        
        SELECT      first_name || ' ' || last_name, salary
        INTO        O_NAME, O_SAL
        FROM        employees
        WHERE       salary = V_MAXSAL
        AND         department_id = IN_DEPT_ID;
        
        DBMS_OUTPUT.PUT_LINE(O_NAME);
        DBMS_OUTPUT.PUT_LINE(O_SAL);
    END;
/
-- 테스트 : 90, 60, 50 - 결과가 한줄이기에 문제가 없음
SET SERVEROUTPUT ON;
VAR O_NAME VARCHAR2;
VAR O_SAL   NUMBER;
CALL GET_NAME_MAXSAL (50, :O_NAME, :O_SAL);
PRINT O_NAME;
PRINT O_SAL;
--> java에서 호출해서 쓴다

-------------------------------------------------------------------
-- 90번 부서 번호입력, 직원들 출력 : 결과가 여러줄 일 때, 에러 발생
CREATE OR REPLACE PROCEDURE GETEMPLIST( IN_DEPT_ID NUMBER )
IS
    V_EMP_ID    NUMBER(6); 
    V_FNAME     VARCHAR2(20);
    V_LNAME     VARCHAR2(25);
    V_PHONE     VARCHAR2(20);
    BEGIN
        SELECT      employee_id, first_name, last_name, phone_number
        INTO        V_EMP_ID, V_FNAME, V_LNAME, V_PHONE
        FROM        employees
        WHERE       department_id = IN_DEPT_ID;
        DBMS_OUTPUT.PUT_LINE(V_EMP_ID);
    END;
/

--테스트
SET SERVEROUTPUT ON;
EXECUTE GETEMPLIST(90);
--CALL GETEMPLIST(90);

/*
BEGIN GETEMPLIST(90); END;
ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
ORA-06512: "HR.GETEMPLIST",  8행
ORA-06512:  1행
결과가 여러줄인데 표현은 1줄만 표현을 함
*/ 

-- *** SELECT INTO는 결과가 한줄 일때만 사용할 수 있다

-- 해결책) 커서(CURSOR) 사용

-- 90번 부서 번호입력, 직원들 출력 : 결과가 여러줄 일 때 정상 작동 -> 자바로 가면 arraylist로 받을거임
CREATE OR REPLACE PROCEDURE GET_EMPLIST( 
    IN_DEPT_ID  IN    NUMBER, 
    O_CUR       OUT   SYS_REFCURSOR
)
IS
    BEGIN
        
        OPEN        O_CUR FOR 
            SELECT      employee_id, first_name, last_name, phone_number
            FROM        employees
            WHERE       department_id = IN_DEPT_ID;
    END;
/
--테스트
VARIABLE    O_CUR   REFCURSOR;
EXECUTE     GET_EMPLIST(50, :O_CUR)
PRINT       O_CUR;



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





















