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
