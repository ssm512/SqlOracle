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
    ORDER BY PHONE_NUMBER ASC;
  
 -- 50번 부서의 직원을출력해라
 SELECT     EMPLOYEE_ID, FIRST_NAME, LAST_NAME
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID = 50; 
    
 -- 부서가 없는 직원을 출력
  SELECT     EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID
    FROM    EMPLOYEES
    WHERE   DEPARTMENT_ID IS NULL;