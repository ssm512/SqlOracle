select * From tab;      -- 테이블 목록 조회

/*
select          칼럼명1 별칭1, 칼럼명2 별칭2, ......
  from          테이블명
  where         조건
  order by      정렬할 칼럼1 ASC, 정렬할 칼럼2 DESC;
*/

-- 직원의 이름을 성과 이름을 붙여서 출력
SELECT          FIRST_NAME, LAST_NAME,
                FIRST_NAME || ' ' || LAST_NAME  EMPNAME
    FROM        EMPLOYEES
    -- ORDER BY    FIRST_NAME || ' ' || LAST_NAME
    --ORDER BY    EMPNAME
    ORDER BY 3          -- 3번쨰 칼럼을 기준으로 정렬을 한다는 의미
    ;
    
-- 부서 번호가 60인 직원 정보(번호, 이름, 이메일, 부서번호)
-- WHERE 문 의 조건 : =, ( 같지 않다 : !=, <>, ^= )
--                    <, >, <=, >=
--                    NOT, AND, OR
SELECT              EMPLOYEE_ID 
                    , FIRST_NAME || ' ' || LAST_NAME  EMPNAME
                    , EMAIL
                    , DEPARTMENT_ID
    FROM            EMPLOYEES
    WHERE           DEPARTMENT_ID = 60
    ORDER BY        EMPNAME
    ;

-- 부서번호가 90인 직원 정보
SELECT          EMPLOYEE_ID
                , FIRST_NAME || ' ' || LAST_NAME  EMPNAME
                , DEPARTMENT_ID
    FROM        EMPLOYEES
    WHERE       DEPARTMENT_ID = 90
    ORDER BY        EMPNAME
    ;
    
-- 부서번호가 60, 90인 직원 정보 (번호, 이름, 이메일, 부서번호)
-- alt + ' 누르면 글짜 대소문자 자동으로 바꾸어짐 (블록 지정해서 해야됨)
SELECT                  E.EMPLOYEE_ID                         번호  
                        , E.FIRST_NAME || ' ' || E.LAST_NAME  이름
                        , E.EMAIL                             이메일
                        , E.DEPARTMENT_ID                     부서번호
    FROM                EMPLOYEES       E
    WHERE               DEPARTMENT_ID = 60 
    OR                  DEPARTMENT_ID = 90      --  OR : 이거나 , 논리합
    ORDER BY            E.DEPARTMENT_ID
    ;
    
-- IN 명령어 ( OR 대체 )
SELECT                  E.EMPLOYEE_ID                         번호  
                        , E.FIRST_NAME || ' ' || E.LAST_NAME  이름
                        , E.EMAIL                             이메일
                        , E.DEPARTMENT_ID                     부서번호
    FROM                EMPLOYEES       E
    WHERE               E.DEPARTMENT_ID         IN (90 , 60, 80)
    ORDER BY            E.DEPARTMENT_ID,       -- 부서번호 순으로 정렬, 부서번호가 같으면 이름 순으로 정렬
                        이름
    ;    

-- 1. 월급이 12000 이상인 직원의 번호, 이름, 이메일, 월급을 월급순으로 출력
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , E.EMAIL                               이메일
                        , E.SALARY                              월급
    FROM                EMPLOYEES       E
    WHERE               E.SALARY >= 12000
    ORDER BY            E.SALARY DESC
    ;
-- 2. 월급이 10000~15000인 직원의 사번, 이름, 월급, 부서번호
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , E.EMAIL                               이메일
                        , E.SALARY                              월급
                        , E.DEPARTMENT_ID                       부서
    FROM                EMPLOYEES       E
    WHERE               10000 <= E.SALARY 
    AND                 E.SALARY <= 15000
    ORDER BY            E.SALARY    DESC
    ;
    
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , E.EMAIL                               이메일
                        , E.SALARY                              월급
                        , E.DEPARTMENT_ID                       부서
    FROM                EMPLOYEES       E
    WHERE               E.SALARY BETWEEN 10000 AND 15000        -- 성능적으로는 위에나 밑에나 같음, 코드의 직관성이 좋은뿐
    ORDER BY            E.SALARY    DESC
    ;
-- 3. 직업 ID가 IT_PROG 인 직원 명단
-- 1)
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , E.EMAIL                               이메일
                        , E.DEPARTMENT_ID                       부서
                        , E.JOB_ID                              직업                      
    FROM                EMPLOYEES       E
    WHERE               E.JOB_ID = 'IT_PROG'
    OR                  E.JOB_ID = 'it_prog'
    ORDER BY            번호
    ;
-- 2) UPPER(), LOWER(), INITCAP() 함수
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , E.EMAIL                               이메일
                        , E.DEPARTMENT_ID                       부서
                        , E.JOB_ID                              직업                      
    FROM                EMPLOYEES       E
    WHERE               LOWER(E.JOB_ID) = 'it_prog'
    ORDER BY            번호
    ;
    
-- 4. 직원 이름이 GRANT인 직원을 찾으세요
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
    FROM                EMPLOYEES       E
    WHERE               UPPER(FIRST_NAME)   =   'GRANT'
    OR                  UPPER(LAST_NAME)    =   'GRANT'
    ;
-- 5. 사번, 월급, 10% 인상한 월급
SELECT                  EMPLOYEE_ID                             번호
                        , SALARY                                월급
                        , SALARY * 1.1                          월급2
    FROM                EMPLOYEES       E
    ORDER BY            SALARY * 1.1 DESC
    ;
-- 6. 50번 부서의 직원명단, 월급, 부서번호
SELECT                  E.EMPLOYEE_ID                           번호
                        , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , SALARY                                월급
                        , DEPARTMENT_ID                         부서번호
    FROM                EMPLOYEES       E
    WHERE               DEPARTMENT_ID       =   50      --  45명
    ;
    
-- 7. 20, 80, 60, 90 번 부서의 직원명단, 월급, 부서번호
SELECT                  E.FIRST_NAME || ' ' || E.LAST_NAME    이름
                        , SALARY                                월급
                        , DEPARTMENT_ID                         부서번호
    FROM                EMPLOYEES       E
--    WHERE               DEPARTMENT_ID IN (20, 80, 60, 90)     --  44명
    WHERE               DEPARTMENT_ID       =   20
    OR                  DEPARTMENT_ID       =   60
    OR                  DEPARTMENT_ID       =   80
    OR                  DEPARTMENT_ID       =   90
    ORDER BY            부서번호 ASC, 월급 DESC
    ;
    
-- 중요 데이터를 2개 입력
-- 전체 자료수 출력
SELECT                  COUNT(*)        --   107, 전체 자료 수를 출력 함, ROWS의 count를 센거임
    FROM                EMPLOYEES;
    
    
SELECT  SYSDATE             --  where문이 없으면 기본은 모든 줄에 대해서 true
FROM    DEPARTMENTS;        --  DEPARTMENTS의 rows 수 만큼 출력함

SELECT  SYSDATE             --  where문이 없으면 기본은 모든 줄에 대해서 true
FROM    DUAL;                  -- 이를 해결하기 위해 DUAL로 한줄만 출력, 오늘의 날짜 : 연월일시분초
-- LOCALDATETIME
-- TIMESTAMP : 밀리초도
-- SMALLDATE
-- SYSTEM : 함수처럼 동작은 하지만 함수는 아님 괄호 없음, 가상칼럼

-- 신입사원 입사 ( 박보검 , 장원영 )
INSERT INTO EMPLOYEES
    VALUES  (207, '보검', '박', 'BOKUM', '1.515.555.8888', SYSDATE,
            'IT_PROG', NULL, NULL, NULL, NULL);
    --  column에 안 맞으면 오류 뜸, 빈값을 넣고 싶으면 0 이나 null, 공백이라도 무조건 추가해야 함
INSERT INTO EMPLOYEES
    VALUES  (208, '리나', '카', 'LINA', '1.515.555.9999', SYSDATE,
            'IT_PROG', NULL, NULL, NULL, NULL);
            
SELECT *        FROM EMPLOYEES;
SELECT COUNT(*) FROM EMPLOYEES;

UPDATE                 EMPLOYEES
    SET                EMAIL=   'KRINA'
                       , PHONE_NUMBER   =   '010-1234-5678'
    WHERE              EMPLOYEE_ID =   208
;       -- EMPLOYEES table의 ID가 208인걸 찾아서 EMAIL과 PHONE_NUMBER의 값을 수정한다
-- transjection : 한 덩어리의 작업
-- insert나 update는 commit을 하기전까지는 메모리에만 저장되어 있음 
-- 그래서 위의 insert와 update는 아래의 commit 전까지는 SQL developer에서는 table의 rows 수가 109인데, sqlplus에서는 107임
-- commit 하고 나면 디스크에 변경된 정보들이 저장됨, sqlplus에서도 확인이 됨
-- java로 oracle에 update이나 insert하면 자동 commit까지 함... 그래서 transjection 

COMMIT;
ROLLBACK;

-- 8. 보너스 없는 직원명단 (COMMSSION_PCT 가 없다)
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , COMMISSION_PCT                        보너스
                        , DEPARTMENT_ID                         부서번호
    FROM                EMPLOYEES
    WHERE               COMMISSION_PCT IS NULL
    -- WHERE               COMMISSION_PCT IS NOT NULL
    ;

-- 9. 전화번호가 010으로 시작하는
-- 패턴 매칭 (pattern matching) : LIKE 사용
-- % : 0자 이상의 모든 숫자 글자
-- _ : 1자의 모든 숫자 글자
SELECT                   EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , PHONE_NUMBER                          전화번호
    FROM                EMPLOYEES
    WHERE               PHONE_NUMBER LIKE '010%'    -- 010으로 시작하는
    -- WHERE               PHONE_NUMBER LIKE '%555%'    -- CONATAINS    555를 포함하는
    -- WHERE               PHONE_NUMBER LIKE '010%'    -- STARTS WITH 010로 시작되는
    -- WHERE               PHONE_NUMBER LIKE '%16'    -- ENDS WITH 16로 끝나는
    ;
-- 10. LAST_NAME 서번쨰, 네번쨰 글자가 LL 인것을 찾아라
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME
                        , LAST_NAME
                        , FIRST_NAME || ' ' || LAST_NAME        이름
    FROM                EMPLOYEES
    WHERE               UPPER(LAST_NAME) LIKE '__LL%'
    ;
    
-- 날짜 26/04/07 : 표현법이 틀림 년/월/일
-- 2026-04-07 : ANSI 표준
-- 04/07/26  : 월/일/년    -> 미국식
-- 07/04/26  : 일/월/년    -> 영국식
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
-- 이번 접속할떄만 수정하는데 날짜 표현하는 포멧을 ''와 같이 해주세요
SELECT      SYSDATE             FROM DUAL;  -- 26/04/07, 2026-04-07 16:27:50
SELECT      7/2                 FROM DUAL;  -- 3.5
SELECT      0/2                 FROM DUAL;  -- 0
SELECT      2/0                 FROM DUAL;  -- 오류, ORA-01476 : 제수(분모)가 0입니다.
SELECT      2.0/0.0             FROM DUAL;  -- 오류, ORA-01476 : 제수(분모)가 0.0입니다.
SELECT      SYSTIMESTAMP        FROM DUAL;  -- 26/04/07 15:36:12.182000000 +09:00
SELECT      SYSDATE - 7                 -- 일주일 전 날짜
            , SYSDATE                   -- 오늘 날짜
            , SYSDATE + 7               -- 일주일 후 날짜
    FROM DUAL;
-- 날짜 + n, 날짜 : n 몇일 전, 후
-- 날짜1 - 날짜2 : 두 날짜 사이의 차이를 날 수 차이 계산
-- 날짜1 + 날짜2 : 오류 잘못된 표현, 의미 없음

-- 크리스마스와 오늘날짜의 차이
-- To_DATE(), TO_CHAR(), TO_NUMBER
SELECT      To_DATE('2026-12-25') - SYSDATE
FROM DUAL; -- 261.340833333333333333333333333333333333 일

-- 소수이하 3자리로 반올림 : ROUND(VAL, 3)
-- 소수이하 3자리로 절사 : TRUNC(VAL, 3)
-- 15일 기준으로 반올림 날짜 : ROUND(SYSDATE, 'MONTH')
-- 해당달의 첫번째 날짜 : TRUNC(SYSDATE, 'MONTH')
SELECT SYSDATE, ROUND(SYSDATE, 'MONTH'), TRUNC(SYSDATE, 'MONTH')
    FROM DUAL;

SELECT NEXT_DAY(SYSDATE, '월요일') FROM DUAL;  -- 26/04/13 : 다음 월요일
SELECT TRUNC(SYSDATE, 'MONTH') FROM DUAL;   -- 26/04/01 : SYSDATE 날짜 해당월의 첫번쨰 날
SELECT LAST_DAY(SYSDATE) FROM DUAL;         -- 26/04/30 : SYSDATE 날짜 해당월의 마지막 날

-- 11. 입사년월이 17년 2월인 사원 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE                             입사일
    FROM                EMPLOYEES
    WHERE               HIRE_DATE
        BETWEEN         '2017-02-01'
        AND             LAST_DAY('2017-02-01')
    ;
/*
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE                             입사일
    FROM                EMPLOYEES
    WHERE               TRUNC(HIRE_DATE, 'MONTH') = TO_DATE('17/02', 'YY/MM')
    ;
    */
-- 12. '17/02/07' 에 입사한 사람출력
-- '12/06/07'에 입사한 사람출력
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE
    FROM                EMPLOYEES
    WHERE               HIRE_DATE = '2017-02-07'
    ;
    
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE
    FROM                EMPLOYEES
    WHERE               HIRE_DATE = '2012-06-07'
    ;
-- 13. 오늘 '26/04/07' 입사한 사람 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'; --이게 먼저 실행되어야 함
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE
    FROM                EMPLOYEES
    --WHERE               HIRE_DATE  = '26/04/07' -- 26/04/07 00:00:00 인걸 찾은겨
    WHERE               '2026-04-07 00:00:00' <= HIRE_DATE
    AND                 HIRE_DATE <= '2026-04-07 23:59:59'
    ;
-- WHERE                TRUNC(HIRE_DATE) = '2026-04-07 00:00:00';    

-- TYPE 변환
-- TO_DATE(문자) -> 날짜
-- TO_NUMBER(문자) -> 숫자
-- TO_CHAR( 숫자, '포맷' ) -> 글자
-- TO_CHAR( 날짜, '포맷' ) -> 날짜 형태의 문자
-- 포맷 : YYYY-MM-DD HH24:MI:SS DAY AM
-- YYYY : 연도
-- MM : 월
-- DD : 날짜
-- HH24 : 24시간계, HH12 : 12시간계
-- MI : 분
-- SS : 초
-- DAY : 요일, 일요일
-- DY : 요일, 일
-- AM : 오전/오후 의미
    
-- 입사년월이 17년 2월인 사원 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE                             입사일
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'YYYY-MM') =  '2017-02';

-- 화요일 입사자를 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')      입사일
                        , TO_CHAR(HIRE_DATE, 'DY')              요일
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'DY') = '화'
    ORDER BY            HIRE_DATE ASC;
    
-- 입사 후 일주일내인 직원 명단
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE
    FROM                EMPLOYEES
    WHERE               HIRE_DATE > SYSDATE -7
    ;

SELECT SYSDATE-7 FROM DUAL;

-- 08월 입사자의 사번, 이름, 입사일을 입사일 순으로 출력
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , HIRE_DATE
    FROM                EMPLOYEES
    WHERE               TO_CHAR(HIRE_DATE, 'MM') = '08'
    ORDER BY            HIRE_DATE ASC
    ;
-- 부서번호 80이 아닌 직원
SELECT                  EMPLOYEE_ID
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , DEPARTMENT_ID
    FROM                EMPLOYEES
    WHERE               DEPARTMENT_ID != 80
    ORDER BY            DEPARTMENT_ID;
    
-- 2026년 04월 07일 05시 16분 04초 오후 수요일 
-- 한자로 출력

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH12:MI:SS AM DAY';
SELECT SYSDATE
FROM DUAL;
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SELECT  TO_CHAR(SYSDATE, 'YYYY') || '年' || 
        TO_CHAR(SYSDATE, 'MM') || '月' || 
        TO_CHAR(SYSDATE, 'DD') || '日' ||
        TO_CHAR(SYSDATE, 'HH') || '時' ||
        TO_CHAR(SYSDATE, 'MI') || '分' ||
        TO_CHAR(SYSDATE, 'SS') || '秒' 
    FROM DUAL;