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
CREATE  PROCEDURE       GET_EMPSAL (IN_EMPID IN NUMBER)
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

-- oracle로 프로시저 생성한다


-- 부서번호입력, 해당 부서의 최고 월급자의 이름, 월급 출력
SELECT      department_id
            , MAX(salary)

FROM        employees
GROUP BY    department_id 
;


-- 90번 부서 번호입력, 직원들 출력
SELECT      employee_id
            , first_name || ' ' || last_name
FROM        employees
WHERE       department_id = 90;