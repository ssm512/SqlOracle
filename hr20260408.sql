
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT SYSDATE 
    FROM DUAL;

SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, HIRE_DATE
    FROM EMPLOYEES
    WHERE HIRE_DATE ='15/09/21';

SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, HIRE_DATE
    FROM EMPLOYEES
    WHERE HIRE_DATE ='2015-09-21';
    
SELECT EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, HIRE_DATE
    FROM EMPLOYEES
    WHERE TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') ='2026-04-07';

----------------------------------------------------------------
-- 앞으로 날짜 표현은 다음과 같이 표현
SELECT                  EMPLOYEE_ID, FIRST_NAME || ' ' || LAST_NAME, HIRE_DATE
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') ='2026-04-07';

-- 입사 후 일주일내인 직원 명단
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'YYYY-MM-DD') >= SYSDATE -7
    ;

SELECT SYSDATE-7 FROM DUAL;

-- 08월 입사자의 사번, 이름, 입사일을 입사일 순으로 출력

SELECT                  EMPLOYEE_ID                             "사 번"
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')      입사일
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'MM') = '08'
    ORDER BY            HIRE_DATE ASC
    ;
-- 부서번호 80이 아닌 직원
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , DEPARTMENT_ID
    FROM                EMPLOYEES
    -- WHERE               DEPARTMENT_ID != 80 -- !=, <> : 같지 않다
    WHERE               DEPARTMENT_ID <> 80
    ORDER BY            DEPARTMENT_ID;

-- =, <>, >, >=, <, <=, BETWEEN ~AND
-- +, -, *, /, MOD() - 나머지 함수


    
-- 2026년 04월 07일 05시 16분 04초 오후 수요일 
-- 한자로 출력

SELECT SYSDATE
       , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS AM DAY')
       , TO_CHAR(SYSDATE, 'AM')
    FROM DUAL;
-- 午前 午後 年 月 日 
-- 日月火水木金土
-- 曜日

-- 1) TO_CHAR를 활용하는 방법
SELECT   SYSDATE
        , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY AM')          날짜1
        --, TO_CHAR(SYSDATE, 'YYYY년MM월DD일 HH24시MI분SS초 DAY AM')                  날짜2 -- 날짜 형식이 부적합
        , TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" DAY AM')                  날짜2
        , TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" DAY AM')                  날짜3
    FROM DUAL;
-- 2) 조건문 IF 구현
-- 2-1) NVL(), NVL2() : NULL VALUE의 약자
------ 사번, 이름, 월급, 보너스 단, 보너스가 NULL이면 0으로 출력
SELECT              EMPLOYEE_ID                             사번
                    , FIRST_NAME || ' ' || LAST_NAME        이름
                    , SALARY                                월급
                    , NVL(COMMISSION_PCT, 0)                보너스
    FROM            EMPLOYEES
    ;
    
SELECT              EMPLOYEE_ID                             사번
                    , FIRST_NAME || ' ' || LAST_NAME        이름
                    , SALARY                                월급
                    , COMMISSION_PCT                        보너스
                    , NVL2(COMMISSION_PCT, SALARY + (SALARY*COMMISSION_PCT), SALARY)                S2
    FROM            EMPLOYEES
    ;
-- 2-2) NULLIF(expr1, expr2)
-- 둘을 비교해서 같으면 null, 같지 않으면 expr1
-- 책에 있는 예제 확인 해볼것
SELECT              EMPLOYEE_ID
                    , START_DATE
                    , END_DATE
                    , 
    FROM            JOB_HISROY
    WHERE
    ;

-- 2-3) DECODE() : ORACLE에만 있음
-- DECODE (expr, search1, result1, 
--               search2, result2, 
--               …, 
--               default)
-- DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을,
-- 같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
-- 이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다.
-- 크다 작다 비교 못 하고 같은 값만 비교 가능
-- 사번, 부서번호 (단 부서번호가 NULL이면 '부서없음')
SELECT              EMPLOYEE_ID                         사번
                    -- , NVL(DEPARTMENT_ID, '부서없음')    부서번호    --  ORA-01722: 수치가 부적합합니다, 부서번호의 타입은 NUMBER, 부서없음은 STRING
                    , DECODE(DEPARTMENT_ID, NULL, '부서없음',
                                                  DEPARTMENT_ID )       부서번호
    FROM            EMPLOYEES
    ;  
    
SELECT  TO_CHAR(SYSDATE, 'AM')      한글
        , DECODE (TO_CHAR(SYSDATE, 'AM'), '오전', '午前',
                                                  '午後')   한자
    FROM DUAL;
----------------------------------------------------------------
-- DECODE로
-- 사번, 이름, 부서명
/*
10	Administration
20	Marketing
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/
SELECT              EMPLOYEE_ID
                    , FIRST_NAME || ' ' || LAST_NAME
                    , DEPARTMENT_ID
                    , DECODE(DEPARTMENT_ID , 10 , 'Administration'
                                           , 20 , 'Marketing'
                                           , 30 , 'Purchasing'
                                           , 40 , 'Human Resources'
                                           , 50 , 'Shipping'
                                           , 60 , 'IT'
                                           , 70 , 'Public Relations'
                                           , 80 , 'Sales'
                                           , 90 , 'Executive'
                                           , 100, 'Finance'
                                           , 110, 'Accounting'
                                                , '부서 없음'
                    )                                 부서명
    FROM            EMPLOYEES
    ;
-- 직원 명단, 직원의 월급, 보너스 출력 연봉출력
-- NULL이 계산에 포함되면 결과는 NULL 
SELECT              EMPLOYEE_ID                             사번
                    , FIRST_NAME || ' ' || LAST_NAME        이름
                    , SALARY                                기본급
                    , SALARY*NVL2(COMMISSION_PCT, COMMISSION_PCT,0)    보너스
                    , SALARY + (SALARY*NVL2(COMMISSION_PCT, COMMISSION_PCT,0) ) 지급액
                    --, SALARY * 12 + SALARY*COMMISSION_PCT 연봉      -- 값이 NULL이 있으면 결과도 NULL 이 나옴
                    , SALARY * 12  + SALARY*NVL2(COMMISSION_PCT, COMMISSION_PCT,0) 연봉
FROM                EMPLOYEES
;

SELECT              EMPLOYEE_ID                     사번
                    , SALARY                        기본급
                    , COMMISSION_PCT
                    , DECODE (COMMISSION_PCT, 0.1  , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.15 , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.2  , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.25 , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.3  , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.35 , SALARY + (SALARY * COMMISSION_PCT)
                                            , 0.4  , SALARY + (SALARY * COMMISSION_PCT)
                                                                    ,   SALARY
                    )                                      지급액
    FROM            EMPLOYEES
    ;
    
SELECT              EMPLOYEE_ID                             사번
                    , FIRST_NAME || ' ' || LAST_NAME        이름
                    , SALARY                                월급
                    , COMMISSION_PCT                        보너스
                    , NVL2(COMMISSION_PCT, SALARY + (SALARY*COMMISSION_PCT), SALARY)                S2
    FROM            EMPLOYEES
    ;
----------------------------------------------------------------
-- 3) CASE WHEN THEN END
-- WHEN SCORE   BETWEEN 99  AND 100 THEN    'A'
-- WHEN SCORE   90 <= SCORE AND SCORE <= THEN 'A'

-- 사번, 이름, 부서명
SELECT              EMPLOYEE_ID                                사번
                    , FIRST_NAME || ' ' || LAST_NAME            이름
                    , CASE  DEPARTMENT_ID
                        WHEN    60  THEN    'IT'
                        WHEN    80  THEN    'Sales'
                        WHEN    90  THEN    'Executive'
                        WHEN    100  THEN   'Finance'
                        ELSE                 '그외'                
                        END                                     부서명
    FROM            EMPLOYEES
;

SELECT              EMPLOYEE_ID                                사번
                    , FIRST_NAME || ' ' || LAST_NAME            이름
                    , CASE  
                        WHEN    DEPARTMENT_ID = 60  THEN    'IT'
                        WHEN    DEPARTMENT_ID = 80  THEN    'Sales'
                        WHEN    DEPARTMENT_ID = 90  THEN    'Executive'
                        WHEN    DEPARTMENT_ID = 100 THEN    'Finance'
                        ELSE                                '그외'                
                        END                                     부서명
    FROM            EMPLOYEES
    ;
    
    
/* 내가 한거
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT  TO_CHAR(SYSDATE, 'YYYY') || '年' || 
        TO_CHAR(SYSDATE, 'MM') || '月' || 
        TO_CHAR(SYSDATE, 'DD') || '日' ||
        TO_CHAR(SYSDATE, 'HH') || '時' ||
        TO_CHAR(SYSDATE, 'MI') || '分' ||
        TO_CHAR(SYSDATE, 'SS') || '秒' 
    FROM DUAL;
*/

---------------------------------------------------
-- 집계함수 : AGGREGATE 함수
-- 모든 집계는 NULL 값은 포함하지 않는다
-- SUM(), AVG(), MIN(), MAX(), COUNT(), VARIANCE()
-- 그룹핑 : GROUP BY
-- ~ 별 인원수

SELECT *                        FROM EMPLOYEES;
SELECT COUNT(*)                 FROM EMPLOYEES; -- 109 : ROWS 줄 수
SELECT COUNT(EMPLOYEE_ID)       FROM EMPLOYEES; -- 109
SELECT COUNT(DEPARTMENT_ID)     FROM EMPLOYEES; -- 106 : NULL 제외

SELECT  COUNT(EMPLOYEE_ID)
    FROM EMPLOYEES
    WHERE  DEPARTMENT_ID IS NULL;
    
SELECT  EMPLOYEE_ID
    FROM EMPLOYEES
    WHERE  DEPARTMENT_ID IS NULL;

-- 전체 직원의 월급 합 : 세로합 (NULL 은 제외), 결과가 한줄임
SELECT COUNT(SALARY)            FROM EMPLOYEES; -- 107
SELECT SUM(SALARY)              FROM EMPLOYEES; -- 691416
SELECT AVG(SALARY)              FROM EMPLOYEES; -- 6461.831775700934579439252336448598130841
SELECT MAX(SALARY)              FROM EMPLOYEES; -- 24000
SELECT MIN(SALARY)              FROM EMPLOYEES; -- 2100

SELECT SUM(SALARY) / COUNT(SALARY) FROM EMPLOYEES; -- 6461.831775700934579439252336448598130841
SELECT SUM(SALARY) / COUNT(*)      FROM EMPLOYEES; -- 6343.266055045871559633027522935779816514

-- 60번 부서의 월급 합
SELECT          AVG(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID = 60
; -- 5760

-- EMPLOYEES TABLE의 부서수
SELECT          DEPARTMENT_ID
FROM            EMPLOYEES;          --109

SELECT          COUNT(DEPARTMENT_ID)
FROM            EMPLOYEES;             -- 106

-- 중복을 제거(DISTINCT)한 부서의 수를 출력
-- 중복을 제거한 부서번호 리스트 : NULL 출력됨
SELECT          DISTINCT DEPARTMENT_ID
FROM            EMPLOYEES;              -- 12줄

SELECT          COUNT(DISTINCT DEPARTMENT_ID)
FROM            EMPLOYEES;           --11
-- NULL을 포함해서 COUNT하고 싶을땐 DECODE, NVL을 써서 다르게 표현하고 이를 세면 COUNT 가능해짐


-- 직원이 근무하는 부서의 수: 부서장이 있는 부서수 : DEPARTMENTS
SELECT COUNT(MANAGER_ID)
FROM       DEPARTMENTS;
-- 직원수, 월급합, 월급 평균, 최대월급, 최소월급
SELECT COUNT(EMPLOYEE_ID)       직원수
       , SUM(SALARY)            월급합
       , AVG(SALARY)            "월급 평균"
       , MAX(SALARY)            최대월급
       , MIN(SALARY)            "최소 월급"
FROM        EMPLOYEES;
-- 부서 60번 부서 인원수, 월급합, 월급 평균
SELECT          COUNT(DEPARTMENT_ID)
                , SUM(SALARY)
                , AVG(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID = 60
;
-- 부서 50, 60, 80번 부서가 아닌 인원수, 월급합, 월급 평균
SELECT          COUNT(DEPARTMENT_ID)
                , SUM(SALARY)
                , AVG(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID != 50
AND             DEPARTMENT_ID != 60
AND             DEPARTMENT_ID != 80
;
