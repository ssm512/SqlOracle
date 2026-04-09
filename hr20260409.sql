SELECT * FROM TAB;
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
-- 1) IT 부서의 부서번호를 찾는다 60
SELECT      DEPARTMENT_ID
FROM        DEPARTMENTS
WHERE       DEPARTMENT_NAME =   'IT'
;
-- 2) 60번 부서의 직원 정보를 출력
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , DEPARTMENT_ID
FROM        EMPLOYEES
WHERE       DEPARTMENT_ID = 60
;
-- 1) + 2) 
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , DEPARTMENT_ID
FROM        EMPLOYEES
WHERE       DEPARTMENT_ID = ( 
                SELECT      DEPARTMENT_ID
                FROM        DEPARTMENTS
                WHERE       DEPARTMENT_NAME = 'IT'
)
;
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , DEPARTMENT_ID
FROM        EMPLOYEES
WHERE       DEPARTMENT_ID IN ( -- 60, 80을 return 받는데 =는 하나의 return 값만 받을 수 있음 =을 IN으로 수정
                SELECT      DEPARTMENT_ID
                FROM        DEPARTMENTS
                WHERE       DEPARTMENT_NAME IN ('IT', 'Sales')
)
;

-- 평균월급보다 많은 월급을 받는 사람의 명단
-- 1) 평균월급 6461.831775700934579439252336448598130841
SELECT      AVG(SALARY)
FROM        EMPLOYEES
;
-- 2) 월급이 6461.831775700934579439252336448598130841 보다 많은 직원
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > 6461.831775700934579439252336448598130841
ORDER BY    SALARY
;

-- 1) + 2)
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > (
            SELECT      AVG(SALARY)
            FROM        EMPLOYEES
)
ORDER BY    SALARY
;

-- 60번 부서의 평균 월급보다 많은 월급을 받는 사람들의 명단
-- 1) 60번 부서 평균 월급 5760
SELECT          AVG(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID = 60
;
-- 2) 60번 부서의 평균 월급보다 많은 월급을 받는 사람들의 명단
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > 5760
ORDER BY    SALARY
;

-- 1) + 2)
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > (
                SELECT          AVG(SALARY)
                FROM            EMPLOYEES
                WHERE           DEPARTMENT_ID = 60
)
ORDER BY    SALARY
;

-- 50번 부서의 최고 월급자의 이름을 출력
-- 1) 50번 부서 최고 월급
SELECT          MAX(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID =  50
;
-- 2) 최고 월급자의 이름 - 마지막에 50번 부서 확인 안했음....
SELECT          EMPLOYEE_ID
                , FIRST_NAME || ' ' || LAST_NAME
                , SALARY
                , DEPARTMENT_ID
FROM            EMPLOYEES
WHERE           SALARY = (
                SELECT          MAX(SALARY)
                FROM            EMPLOYEES
                WHERE           DEPARTMENT_ID =  50
                )
AND             DEPARTMENT_ID = 50
;

-- SALES 부서의 평균 월급보다 많은 월급을 받는 사람의 명단
-- 1) SALES 부서 찾기 80
SELECT      DEPARTMENT_ID
FROM        DEPARTMENTS
WHERE       UPPER(DEPARTMENT_NAME)    =   'SALES'
;
-- 2) SALES 부서의 평균 월급 8955.882352941176470588235294117647058824
SELECT          AVG(SALARY)
FROM            EMPLOYEES
WHERE           DEPARTMENT_ID = (
        SELECT      DEPARTMENT_ID
        FROM        DEPARTMENTS
        WHERE       UPPER(DEPARTMENT_NAME)    =   'SALES'
)
;
-- 3) SALES 부서의 평균 월급보다 많은 월급을 받는 사람의 명단
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > 8955.882352941176470588235294117647058824
ORDER BY    SALARY
;
-- 1) + 2) + 3)
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY > (
                SELECT          AVG(SALARY)
                FROM            EMPLOYEES
                WHERE           DEPARTMENT_ID = (
                        SELECT      DEPARTMENT_ID
                        FROM        DEPARTMENTS
                        WHERE       UPPER(DEPARTMENT_NAME)    =   'SALES'
                        )
                )
ORDER BY    SALARY
;


-- 다중열 SUBQUERY
-- employees 테이블에서 job_id별로 가장 낮은 salary가 얼마인지 찾아보고, 
-- 찾아낸 job_id별 salary에 해당하는 직원이 누구인지 다중 열 서브쿼리를 이용해 찾아보세요.
SELECT A.employee_id
       , first_name || ' ' || last_name
       , job_id
       , salary
FROM employees A
WHERE (A.job_id, A.salary) IN (
                               SELECT job_id, MIN(salary) 그룹별급여
                               FROM employees
                               GROUP BY job_id
                              )
ORDER BY A.salary DESC;

-- 상관 서브 쿼리 co relative subquery
-- job history에 있는 부서와 부서명을 알고 싶은 거임
-- 부서명은 job history에 없음
-- 메인 쿼리에서 사용된 부서 테이블의 부서번호와 job_history 테이블의 부서번호가 같은 건을 조회
-- job_history에 있는 부서번호와 departments에 있는 부서번호가 같은 부서를 찾아서
-- departments에 있는 department_name을 출력해라
SELECT a.department_id, a.department_name
      FROM departments a
     WHERE EXISTS ( SELECT 1
                      FROM job_history b
                     WHERE a.department_id = b.department_id );

-- SHIPPING 부서의 직원 명단
1) shipping 부서 찾기
SELECT      DEPARTMENT_ID
FROM        DEPARTMENTS
WHERE       UPPER(DEPARTMENT_NAME) = 'SHIPPING'
;
2) 직원 명단 출력
SELECT          a.EMPLOYEE_ID
                , a.FIRST_NAME || ' ' || a.LAST_NAME
                , a.DEPARTMENT_ID
FROM            EMPLOYEES   a
WHERE           DEPARTMENT_ID   = 50
;
3) 합치기
SELECT          a.EMPLOYEE_ID
                , a.FIRST_NAME || ' ' || a.LAST_NAME
                , a.DEPARTMENT_ID
FROM            EMPLOYEES   a
WHERE           DEPARTMENT_ID   = (
                SELECT      b.DEPARTMENT_ID
                FROM        DEPARTMENTS     b
                WHERE       UPPER(b.DEPARTMENT_NAME) = 'SHIPPING'
                )
;
---------------------------------------------------------------
join
---------------------------------------------------------------
직원이름, 부서명       -- 출력 109줄
1) 카티션프로덕트 
: 107 * 27 = 2943  -> cross join
조건이 없는 JOIN

ORACLE OLD 문법
SELECT      FIRST_NAME || ' ' || LAST_NAME          직원이름
            , DEPARTMENT_NAME                       부서명
FROM        EMPLOYEES, DEPARTMENTS
;

2) 내부 조인 : 양쪽다 존재한 DATA, NULL 제외
: 109 - 3(부서번호 NULL) = 106 -> inner join

SELECT      EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME          직원이름
            , DEPARTMENTS.DEPARTMENT_NAME                       부서명
FROM        EMPLOYEES, DEPARTMENTS
WHERE       EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
;

SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME          직원이름
            , D.DEPARTMENT_NAME                       부서명
FROM        EMPLOYEES   E, DEPARTMENTS  D
WHERE       E.DEPARTMENT_ID = D.DEPARTMENT_ID
;

3) LEFT OUTER JOIN : 기준을 정해서 
모든 직원을 출력해라 : 109줄
-- 직원의 부서번호가 NULL이라도 출력해야 한다, 왼쪽에 NULL이 있더라고 출력하라
(+) : 기준(직원)이 되는 조건의 반대방향에 붙인다
    NULL이 출력될 곳
    
SELECT          E.FIRST_NAME    || ' ' || E.LAST_NAME
                , D.DEPARTMENT_NAME
FROM            EMPLOYEES       E, DEPARTMENTS      D
WHERE           E.DEPARTMENT_ID    =   D.DEPARTMENT_ID(+)           
;

4) RIGHT OUTER JOIN

SELECT          E.FIRST_NAME    || ' ' || E.LAST_NAME
                , D.DEPARTMENT_NAME
FROM            EMPLOYEES       E, DEPARTMENTS      D
WHERE           D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID   
;

RIGHT OUTER JOIN의 예시임
모든 부서를 출력해라 , 오른쪽에 NULL 이 있더라도 포함해서 출력
-- 직원 정보가 없더라도 출력해야 한다
- 122 : (109-3) + (27 - 11)

SELECT          E.FIRST_NAME    || ' ' || E.LAST_NAME
                , D.DEPARTMENT_NAME
FROM            EMPLOYEES       E, DEPARTMENTS      D
WHERE           E.DEPARTMENT_ID(+)    =   D.DEPARTMENT_ID
;

5) FULL OUTER JOIN : OLD 문법에는 존재하지 않음
모든 직원과 모든 부서를 출력하여라

--------------------------------------------------------------
표준 SQL 문법
1. CROSS JOIN : 2943, ON 을 쓰지 않는거임
SELECT          E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM            EMPLOYEES E CROSS JOIN DEPARTMENTS D
;

2. INNER JOIN : 106, (INNER) 생략 가능함 - 중복값만 출력하겠다는 뜻
SELECT          E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
-- FROM            EMPLOYEES E INNER JOIN DEPARTMENTS D 
FROM            EMPLOYEES E JOIN DEPARTMENTS D 
ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID -- TABLE 2개를 붙이는 조건만 
;

3. OUTER JOIN : (OUTER)생략 가능함
1) LEFT (OUTER) JOIN : 109
SELECT          E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM            EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID
;
2) RIGHT (OUTER) JOIN : 122 = (109-3) + (27 - 11)
SELECT          E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM            EMPLOYEES E RIGHT JOIN DEPARTMENTS D
ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID
;

3) FULL (OUTER) JOIN : 125 = 109 + (27-11)
SELECT          E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME
FROM            EMPLOYEES E FULL JOIN DEPARTMENTS D
ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID
;

---- 연습문제 INNER, OUTER JOIN 다 써볼것, CROEE JOIN은 연구용으로 만들때만 -- 점심시간 이후
-- 직원 이름, 담당업무(JOB_TITLE) - JOB_ID, JOB_TITLE은 NULLABLE NO 이므로 OUTER JOIN의 의미가 없음
-- WHERE 
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME
            , J.JOB_TITLE
FROM        EMPLOYEES E, JOBS J
WHERE       E.JOB_ID = J.JOB_ID
;
-- 1) INNER JOIN 
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME
            , J.JOB_TITLE
FROM        EMPLOYEES E INNER JOIN JOBS J
ON          E.JOB_ID = J.JOB_ID
;
-- 2) LEFT JOIN : 왼쪽 NULL 출력
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME
            , J.JOB_TITLE
FROM        EMPLOYEES E LEFT JOIN JOBS J
ON          E.JOB_ID = J.JOB_ID
;
-- 3) RIGHT JOIN : 오른쪽 NULL 출력
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME
            , J.JOB_TITLE
FROM        EMPLOYEES E RIGHT JOIN JOBS J
ON          E.JOB_ID = J.JOB_ID
;
-- 4) FULL JOIN
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME
            , J.JOB_TITLE
FROM        EMPLOYEES E FULL JOIN JOBS J
ON          E.JOB_ID = J.JOB_ID
;

-- 부서명, 부서위치 (CITY, STREET_ADDRESS)
-- DEPARTMENTS의 LOCATION ID 가짓수 : 7
SELECT      LOCATION_ID
            , COUNT(DEPARTMENT_ID)
FROM        DEPARTMENTS
GROUP BY    LOCATION_ID;


-- 1) INNER JOIN : 27
SELECT      D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        DEPARTMENTS D INNER JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
ORDER BY    DEPARTMENT_NAME
;
-- 2) LEFT JOIN : D에 NULL 이 없도록 모든 부서 출력
SELECT      D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        DEPARTMENTS D LEFT JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;
--3) RIGHT JOIN : 43 = 27 + (23-7)
SELECT      D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        DEPARTMENTS D RIGHT JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;
-- 4) FULL JOIN : 43
SELECT      D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        DEPARTMENTS D RIGHT JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;

-- 직원명, 부서명, 부서위치 (CITY, STREE_ADDRESS) --JOIN을 2번?
-- WHERE
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY || '' || L.STREET_ADDRESS 부서위치
FROM        EMPLOYEES E , DEPARTMENTS D, LOCATIONS L
WHERE       E.DEPARTMENT_ID = D.DEPARTMENT_ID
AND         D.LOCATION_ID = L.LOCATION_ID
ORDER BY    E.FIRST_NAME || ' ' || E.LAST_NAME
;

-- 1) INNER JOIN - 106
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        EMPLOYEES E INNER JOIN DEPARTMENTS D     ON          E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        INNER JOIN  LOCATIONS  L     ON          D.LOCATION_ID = L.LOCATION_ID
;
-- 2) LEFT JOIN - 109
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON          E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;
-- 3) RIGHT JOIN - 138
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        EMPLOYEES E RIGHT JOIN DEPARTMENTS D
ON          E.DEPARTMENT_ID = D.DEPARTMENT_ID
RIGHT JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;
4) FULL JOIN - 141
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS
FROM        EMPLOYEES E FULL JOIN DEPARTMENTS D
ON          E.DEPARTMENT_ID = D.DEPARTMENT_ID
FULL JOIN LOCATIONS L
ON          D.LOCATION_ID = L.LOCATION_ID
;

-- 직원명, 부서명, 국가, 부서위치 (CITY, STREE_ADDRESS)
-- 1) INNER JOIN - 106
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS, C.COUNTRY_NAME
FROM        EMPLOYEES E INNER JOIN DEPARTMENTS  D ON    E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        INNER JOIN LOCATIONS    L ON    D.LOCATION_ID   = L.LOCATION_ID
                        INNER JOIN COUNTRIES    C ON    L.COUNTRY_ID    = C.COUNTRY_ID
;
-- 2) LEFT JOIN : 109
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS, C.COUNTRY_NAME
FROM        EMPLOYEES E LEFT JOIN DEPARTMENTS   D ON    E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        LEFT JOIN LOCATIONS     L ON    D.LOCATION_ID   = L.LOCATION_ID
                        LEFT JOIN COUNTRIES     C ON    L.COUNTRY_ID    = C.COUNTRY_ID
;

-- 3) RIGHT JOIN : 149
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS, C.COUNTRY_NAME
FROM        EMPLOYEES E RIGHT JOIN DEPARTMENTS D    ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        RIGHT JOIN LOCATIONS   L    ON  D.LOCATION_ID   = L.LOCATION_ID
                        RIGHT JOIN COUNTRIES   C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
ORDER BY    C.COUNTRY_NAME
;
-- 4) FULL JOIN : 152
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, L.CITY, L.STREET_ADDRESS, C.COUNTRY_NAME
FROM        EMPLOYEES E FULL JOIN DEPARTMENTS D    ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        FULL JOIN LOCATIONS   L    ON  D.LOCATION_ID   = L.LOCATION_ID
                        FULL JOIN COUNTRIES   C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
ORDER BY    C.COUNTRY_NAME
;

-- 부서명, 국각 : 모든 부서: 27줄 이상
1) INNER JOIN : 27
SELECT      D.DEPARTMENT_NAME
            , C.COUNTRY_NAME
FROM        DEPARTMENTS D INNER JOIN LOCATIONS L    ON  D.LOCATION_ID   = L.LOCATION_ID
                          INNER JOIN COUNTRIES C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
;
2) LEFT JOIN : 27
SELECT      D.DEPARTMENT_NAME
            , C.COUNTRY_NAME
FROM        DEPARTMENTS D LEFT JOIN LOCATIONS L    ON  D.LOCATION_ID   = L.LOCATION_ID
                          LEFT JOIN COUNTRIES C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
;
3) RIGHT JOIN : 54
SELECT      D.DEPARTMENT_NAME
            , C.COUNTRY_NAME
FROM        DEPARTMENTS D RIGHT JOIN LOCATIONS L    ON  D.LOCATION_ID   = L.LOCATION_ID
                          RIGHT JOIN COUNTRIES C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
;

4) FULL JOIN : 54
SELECT      D.DEPARTMENT_NAME
            , C.COUNTRY_NAME
FROM        DEPARTMENTS D FULL JOIN LOCATIONS L    ON  D.LOCATION_ID   = L.LOCATION_ID
                          FULL JOIN COUNTRIES C    ON  L.COUNTRY_ID    = C.COUNTRY_ID
;

-- 직원명, 부서위치 단 IT 부서만
1) INNER JOIN : 
SELECT      E.FIRST_NAME || ' ' || E.LAST_NAME, D.DEPARTMENT_NAME, E.JOB_ID, L.STATE_PROVINCE|| ',' || L.CITY || ',' || L.STREET_ADDRESS  "부서 위치"
FROM        EMPLOYEES E INNER JOIN  DEPARTMENTS D   ON  E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        INNER JOIN  LOCATIONS   L   ON  D.LOCATION_ID   = L.LOCATION_ID
WHERE       E.DEPARTMENT_ID = (
            SELECT      DEPARTMENT_ID
            FROM        DEPARTMENTS
            WHERE       UPPER(DEPARTMENT_NAME) = 'IT'
            )
ORDER BY    E.FIRST_NAME || ' '|| E.LAST_NAME
;

-- 부서명별 월급 평균 .....
1) 부서번호, 월급 평균
SELECT          DEPARTMENT_ID       부서번호, 
                ROUND(AVG(SALARY),2) 월급평균
FROM            EMPLOYEES
GROUP BY        DEPARTMENT_ID
ORDER BY        DEPARTMENT_ID
;

2) 부서명, 월급 평균 : INNER JOIN 11
SELECT          D.DEPARTMENT_NAME       부서명, 
                ROUND(AVG(E.SALARY),2) 월급평균
FROM            EMPLOYEES  E JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY        D.DEPARTMENT_NAME
ORDER BY        D.DEPARTMENT_NAME
;
 3) 모든 부서 : RIGHT JOIN 27
 단, 월급평균이 NULL이면 '직원없음'
SELECT          D.DEPARTMENT_NAME                       부서명, 
                -- NVL(ROUND(AVG(E.SALARY),2), 0) 월급평균 -- 0으로 정상 출력
                -- NVL(ROUND(AVG(E.SALARY),2), '직원없음') 월급평균 -- 수치부적합으로 안 나옴
                DECODE (AVG(E.SALARY), NULL, '직원없음'
                                           ,  ROUND(AVG(E.SALARY),2))  월급평균 
FROM            EMPLOYEES  E RIGHT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY        D.DEPARTMENT_NAME
ORDER BY        D.DEPARTMENT_NAME
;
/* 내가 한거.... 안나옴
SELECT      D.DEPARTMENT_NAME
            , E.DEPARTMENT_ID
            , E.SALARY
FROM        DEPARTMENTS D FULL JOIN EMPLOYEES E ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE       (E.DEPARTMENT_ID, E.SALARY) IN (
                                            SELECT DEPARTMENT_ID, AVG(SALARY)
                                            FROM   EMPLOYEES
                                            GROUP BY DEPARTMENT_ID
                                            )
;

*/

-- 직원의 근무 연수
-- MONTHS_BETWEEN(날짜1, 날짜2) : 날짜1 - 날짜2 : 월단위로
-- ADD_MONTH(날짜, 숫자N) : 날짜 +n개월 / 날짜 -n개월

SELECT          FIRST_NAME || ' ' || LAST_NAME                      직원명
                , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')                  입사일
                , TO_CHAR(TRUNC(HIRE_DATE, 'MM'), 'YYYY-MM-DD')     "입사월의 첫번째날"
                , TO_CHAR(LAST_DAY(HIRE_DATE), 'YYYY-MM-DD')        "입사월의 마지막날"
                , TRUNC(SYSDATE - HIRE_DATE)                        근무일수
                , TRUNC(TRUNC(SYSDATE - HIRE_DATE) / 365.2422)      근무연수
                , TRUNC(MONTHS_BETWEEN(SYSDATE , HIRE_DATE) /12)    근무연수
FROM            EMPLOYEES
;

-- 60번 부서 최소월급과 같은 월급자의 명단 출력
1) 최소월급
2) 1) 월급을 받는 사람의 이름
SELECT      EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME
            , DEPARTMENT_ID
            , SALARY
FROM        EMPLOYEES
WHERE       SALARY = (
            SELECT  MIN(SALARY)
            FROM    EMPLOYEES
            WHERE   DEPARTMENT_ID = 60
            )
;

-- 부서명, 부서장의 이름 ..... JOIN문의 ON 에 대해 잘못 이해함
1) INNER JOIN : 양쪽다 존재하는 데이터만 출력
SELECT          D.DEPARTMENT_NAME           부서명
                , E.FIRST_NAME || ' ' || E.LAST_NAME        "부서장의 이름"
FROM            DEPARTMENTS D 
JOIN            EMPLOYEES E   ON D.MANAGER_ID = E.EMPLOYEE_ID
;

2) 모든부서에 대해서 출력을 하라
SELECT          D.DEPARTMENT_NAME           부서명
                , E.FIRST_NAME || ' ' || E.LAST_NAME        "부서장의 이름"
FROM            DEPARTMENTS D 
LEFT JOIN            EMPLOYEES E   ON D.MANAGER_ID = E.EMPLOYEE_ID
;
--  D.MANAGER_ID가 없는 경우 E.FIRST_NAME || ' ' || E.LAST_NAME 의 ' ' 만 찍음

------------------------------------------------------------------------
결합연산자 - 줄 단위 결합 
조건 - 두 테이블의 칸수와 타입이 동일해야 한다
1) UNION            중복 제거 결합
2) UNION ALL        중복 포함 결합
3) INTERSECT        교집합 : 공통부분
4) MINUS            차집합 A - B

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80; -- 34
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 45

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
UNION
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50; -- 79

-- 칼럼수와 칼럼들의 TYPE이 같으면 합쳐진다 -> 주의!할 것 : 의미 없는 결합이 가능함
SELECT  EMPLOYEE_ID, FIRST_NAME FROM EMPLOYEES;
SELECT  DEPARTMENT_ID, DEPARTMENT_NAME  FROM DEPARTMENTS;

SELECT  EMPLOYEE_ID, FIRST_NAME FROM EMPLOYEES
UNION
SELECT  DEPARTMENT_ID, DEPARTMENT_NAME  FROM DEPARTMENTS;
------------------------------------------------------------------------

-- 직원 정보, 담당 업무
SELECT      E.EMPLOYEE_ID, E.FIRST_NAME || ' ' || E.LAST_NAME 이름, J.JOB_TITLE
FROM        EMPLOYEES E JOIN JOBS J ON E.JOB_ID = J.JOB_ID;

-- 직원명, 담당 업무, 담당 업무 HISTORY


-- 사번, 업무시작일, 업무종료일, 담당 업무, 부서번호 EX)101번 직원 과거 HISTORY가 있음 
SELECT
