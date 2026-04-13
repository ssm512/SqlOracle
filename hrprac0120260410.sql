-- 책내용
SELECT      JOB_ID
            , REPLACE(JOB_ID, 'ACCOUNT', 'ACCN')
FROM        EMPLOYEES
WHERE       JOB_ID LIKE '%ACCOUNT%'
;

SELECT      TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MM') 오늘날짜,
            TO_CHAR(SYSDATE +1 , 'YYYY-MM-DD HH24:MM') 더하기1,
            TO_CHAR(SYSDATE -1, 'YYYY-MM-DD HH24:MM') 빼기1,
            TO_DATE('20171202')-TO_DATE('20171201') 날짜빼기,
            SYSDATE + 13/24 시간더하기
FROM DUAL;


SELECT  LTRIM('  ABC  DEF  '),
        RTRIM('  ABC  DEF  ')
FROM    DUAL;


-- 직원 정보, 담당 업무
SELECT          employee_id
                , job_id
FROM            employees;

-- 직원번호, 담당 업무, 담당 업무 from HISTORY -힌트 : INLINE VIEW
SELECT          *
FROM
(
SELECT          employee_id
                , job_id
FROM            employees
UNION
SELECT          employee_id
                , job_id
FROM            job_history
) T
ORDER BY        T.employee_id
;
-- 사번, 업무시작일, 업무종료일, 담당 업무, 부서번호 EX)101번 직원 과거 HISTORY가 있음 
SELECT          *
FROM            (
    SELECT          employee_id             사번
                    , TO_CHAR(hire_date, 'YYYY-MM-DD')             업무시작일
                    , TO_CHAR('', 'YYYY-MM-DD')                    업무종료일
                    , job_id                담당업무
                    , department_id         부서번호
    FROM            employees
    UNION
    SELECT          employee_id             사번
                    , TO_CHAR(start_date, 'YYYY-MM-DD')            업무시작일
                    , TO_CHAR(end_date, 'YYYY-MM-DD')              업무종료일
                    , job_id                담당업무
                    , department_id         부서번호
    FROM            job_history
)
ORDER BY            사번
;

/*
---------------------------------------------------------
SUBQUERY : SQL 문 안에 SQL 문을 넣어서 실행하는 방법
         : 반드시 () 안에 있어야 한다
         : () 안에는 ORDER BY를 사용할 수 없다
         : WHERE 조건에 맞도록 작성한다
         : 퀴리를 실행하는 순서가 중요할 때 사용함
---------------------------------------------------------
*/
-- IT 부서의 직원 정보를 출력하시오








-- 익명 프로시져
SET SERVEROUTPUT ON;

DECLARE
    V_NAME      VARCHAR2(46);
    V_SAL       NUMBER(8,2);
BEGIN
    V_NAME      := '카리나';
    V_SAL       := 10000;
    DBMS_OUTPUT.PUT_LINE(V_NAME);
    DBMS_OUTPUT.PUT_LINE(V_SAL);
    IF V_SAL >= 10000 THEN
        DBMS_OUTPUT.PUT_LINE('GOOD');
    ELSE
        DBMS_OUTPUT.PUT_LINE('NOT GOOD');
    END IF;
END;
/
    
-- 107번 직원의 이름과 월급 조회
CREATE OR REPLACE PROCEDURE GET_EMPSAL (IN_EMPID IN NUMBER)
IS
  V_NAME        VARCHAR2(46);
  V_SAL         NUMBER(8,2);
    BEGIN
        SELECT  FIRST_NAME || ' ' || LAST_NAME, SALARY
        INTO    V_NAME, V_SAL
        FROM    EMPLOYEES
        WHERE   EMPLOYEE_ID = IN_EMPID;
        DBMS_OUTPUT.PUT_LINE('이름 : ' || V_NAME);
        DBMS_OUTPUT.PUT_LINE('월급 : ' || V_SAL);
    END;
/

-- 테스트
SET SERVEROUTPUT ON;
CALL GET_EMPSAL(107);


-- 부서번호 입력, 해당 부서의 최고 월급자의 이름, 월급 출력
CREATE OR REPLACE PROCEDURE GET_NAME_MAXSAL (
    IN_DEPT_ID  IN  NUMBER,
    O_NAME      OUT VARCHAR2,
    O_SAL       OUT NUMBER
)
IS  
    V_MAXSAL        NUMBER(8,2);
    BEGIN
        SELECT      MAX(SALARY)
        INTO        V_MAXSAL
        FROM        EMPLOYEES
        WHERE       DEPARTMENT_ID = IN_DEPT_ID;
        
        SELECT      FIRST_NAME || ' ' || LAST_NAME
                    , SALARY
        INTO        O_NAME, O_SAL
        FROM        EMPLOYEES
        WHERE       SALARY  =   V_MAXSAL
        AND         DEPARTMENT_ID = IN_DEPT_ID;
        
        DBMS_OUTPUT.PUT_LINE(O_NAME);
        DBMS_OUTPUT.PUT_LINE(O_SAL);
        
    END;
/    

-- 테스트
SET SERVEROUTPUT ON;
VAR O_NAME VARCHAR2;
VAR O_SAL   NUMBER;
CALL GET_NAME_MAXSAL (50, :O_NAME, :O_SAL);
PRINT O_NAME;
PRINT O_SAL;

--------------------------------------------------------------------
-- 90번 부서 번호입력, 직원들 출력 - 결과라 여러줄인때 CURSOR를 사용해야 함
CREATE OR REPLACE PROCEDURE GET_EMPLIST (
    IN_DEPT_ID  IN  NUMBER,
    O_CUR       OUT SYS_REFCURSOR
)
IS
    BEGIN
        OPEN        O_CUR   FOR
            SELECT      EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER
            FROM        EMPLOYEES
            WHERE       DEPARTMENT_ID   =   IN_DEPT_ID;
    END;
/    

--테스트
VARIABLE        O_CUR   REFCURSOR;
EXECUTE         GET_EMPlIST(50, :O_CUR)
PRINT           O_CUR;