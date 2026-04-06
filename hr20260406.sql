select * from tab;

DESC EMPLOYEES;

select * from EMPLOYEES;

-- 직원 번호가 100인 사람을 출력
select      *
    from    EMPLOYEES
    where   EMPLOYEE_ID = 100;

--Last name이 King인 사람을 출력
select      *
    from    EMPLOYEES
    where   LAST_NAME = 'King';

-- Salary 내림차순으로 직원 정보를 출력하라
SELECT      EMPLOYEE_ID, FIRST_NAME, SALARY
 FROM       EMPLOYEES
 ORDER  BY  SALARY DESC;    --- 107명
 
-- Salary가 5000 이상이고 Salary 내림차순으로 직원 정보를 출력하라
SELECT      EMPLOYEE_ID, FIRST_NAME, SALARY
 FROM       EMPLOYEES
 WHERE      SALARY >= 5000
 ORDER  BY  SALARY DESC;    --- 58명
 
 -- 전화번호에 010이 포함된 직원
 SELECT     EMPLOYEE_ID, FIRST_NAME, PHONE_NUMBER
    FROM    EMPLOYEES
    WHERE   PHONE_NUMBER LIKE '%010%'
    ORDER BY EMPLOYEE_ID ASC;
  
 -- 50번 부서의 직원을출력해라
 SELECT     EMPLOYEE_ID                      사번,        -- 사번 : Alias 별칭,별명 -> 자바에서는 Alias 명으로 db에서 data를 받아옴
            FIRST_NAME || ' ' || LAST_NAME   이름,     -- Alias 안에 띄워쓰기를 포함하고 싶으면 ""를 사용하여 둘러싸면 됨
            DEPARTMENT_ID                    "부서 번호"
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID = 50
    --ORDER BY FIRST_NAME || ' ' || LAST_NAME ASC;
    ORDER BY FIRST_NAME ASC, LAST_NAME ASC; -- FIRST_NAME으로 1차 정렬, LAST_NAME으로 2차 정렬
    
 -- 부서가 없는 직원을 출력
  SELECT    EMPLOYEE_ID
            , FIRST_NAME || ' ' || LAST_NAME      ENAME
            , DEPARTMENT_ID
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID IS NULL;      -- = NULL (작동 안함), IS NULL, IS NOT NULL