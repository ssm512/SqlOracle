-- 함수
1. 숫자함수
1) ABS()
2) CEIL() 과 FLOOR() -> 결과 정수형
CEIL  : 올림
FLOOR : 버림, 값보다 크지 않은 정수
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001) FROM DUAL;
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001) FROM DUAL;
SELECT FLOOR(-10.123), FLOOR(-10.541), FLOOR(-11.001) FROM DUAL;    -- -11, -11, -12
SELECT TRUNC(-10.123), TRUNC(-10.541), TRUNC(-11.001) FROM DUAL;    -- -10, -10, -11, 소수점 이하만 버림

3) ROUND() 와 TRUNC()

SELECT ROUND(10.154, 1), ROUND(10.154, 2), ROUND(10.154, 3) FROM DUAL;  -- 10.2 10.15 10.154

SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.155, -2) FROM DUAL;   -- 0 120 100

SELECT TRUNC(10.154, 1), TRUNC(10.154, 2), TRUNC(10.154, 3) FROM DUAL;  --  10.1 10.15 10.154

SELECT TRUNC(0, 3), TRUNC(115.155, -1), TRUNC(115.155, -2) FROM DUAL;   -- 0 110 100

4) POWER(N2, N1) : 제곱승, N2의 N1승
   SQRT(N)       : 제곱근, SQUARE ROOT

SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.0001), POWER(4, 0.5) FROM DUAL;    

SELECT SQRT(2), SQRT(4) FROM DUAL;

SELECT SQRT(-4) FROM DUAL;  -- ORA-01428: '-4' 인수가 범위를 벗어났습니다

5) 나머지 MOD(n2, n1)와 REMAINDER(n2, n1)
계산식
• MOD → n2 - n1 * FLOOR (n2/n1)
• REMAINDER → n2 - n1 * ROUND (n2/n1)

SELECT MOD(19,4), MOD(19.123, 4.2) FROM DUAL;       -- 3 2.323

SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2) FROM DUAL;       -- -1 -1.877

6) EXP(n), LN(n) 그리고 LOG(n2, n1)

 SELECT EXP(2), LN(2.713), LOG(10, 100) FROM DUAL;      
 -- 7.3890560989306502272304274605750078132	0.9980550336767946922014710783755035594696	2

7) SIN(), COS(), TAN() : DEGREE가 아니라 RADIAN 임, 원주율/180*각도
SELECT SIN(0.5235987), COS(0.5235987), TAN(0.5235987) FROM DUAL;

2. 문자 함수
1) INITCAP(char), LOWER(char), UPPER(char)
SELECT INITCAP('never say goodbye'), INITCAP('never6say*good가bye') FROM DUAL;
SELECT LOWER('NEVER SAY GOODBYE'), UPPER('never say goodbye')       FROM DUAL;

2) CONCAT(char1, char2), SUBSTR(char, pos, len), SUBSTRB(char, pos, len)

SELECT CONCAT('I Have', ' A Dream'), 'I Have' || ' A Dream' FROM DUAL;
SELECT SUBSTR('ABCDEFG', 1, 4), SUBSTR('ABCDEFG', -1, 4)    FROM DUAL;            
-- ABCD	G
-- SUBSTR('ABCDEFG', -1, 4) : -1 뒤로부터, 4 첫번째에서 4개 앞으로 진행
-- SUBSTR('ABCDEFG', -3, 4) : 'EFG'
SELECT SUBSTRB('ABCDEFG', 1, 4), SUBSTRB('가나다라마바사', 1, 4) FROM DUAL;       -- BYTE
-- ABCD	가 

3) LTRIM(char, set), RTRIM(char, set) -- set이 빈칸이면 공백 없애줌
SELECT LTRIM('ABCDEFGABC', 'ABC'),
       LTRIM('가나다라', '가'),
       RTRIM('ABCDEFGABC', 'ABC'),
       RTRIM('가나다라', '라'),
       TRIM('   ABCDER      '),
       LENGTH(TRIM('   ABCDER      ')),
       TRIM(LEADING ' ' FROM '   ABCDER      '),
       LENGTH(TRIM(LEADING ' ' FROM '   ABCDER      '))
FROM DUAL;
-- DEFGABC	나다라	ABCDEFG	가나다

4)  INSTR(str, substr, pos, occur), LENGTH(chr), LENGTHB(chr)
SELECT INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약') AS INSTR1,
       INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5) AS INSTR2,
       INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 2) AS INSTR3
FROM DUAL;      -- 4	18	32
    -- INSTR(str, substr, pos, occur) : 자바의 indexOf라고 생각하면 됨
    
SELECT LENGTH('대한민국'),          -- 4 글자
       LENGTHB('대한민국')          -- 12 BYTE
FROM DUAL;
 -- LENGTH(chr) - 글자수, LENGTHB(chr)-byte수

5) LPAD(expr1, n, expr2), RPAD(expr1, n, expr2)
CREATE TABLE ex4_1 (phone_num VARCHAR2(30));
INSERT INTO ex4_1 VALUES ('111-1111');
INSERT INTO ex4_1 VALUES ('111-2222');
INSERT INTO ex4_1 VALUES ('111-3333');

SELECT *
FROM ex4_1;

-- 단 이때 원 TABLE의 DATA는 변경되지 않음 명심할 것
SELECT LPAD(phone_num, 12, '(02)')
FROM ex4_1;

SELECT RPAD(phone_num, 12, '(02)')
FROM ex4_1;

6) REPLACE(char, search_str, replace_str), TRANSLATE(expr, FROM_str, to_str)

SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나', '너')
      FROM DUAL;

SELECT LTRIM(' ABC DEF '),
       RTRIM(' ABC DEF '),
       REPLACE(' ABC DEF ', ' ', '')
FROM DUAL;
      
SELECT employee_id, TRANSLATE(EMP_NAME,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','thehillsarealivewiththesou') AS TRANS_NAME
FROM employees;
      
3. 날짜 함수
1) SYSDATE, SYSTIMESTAMP
2) ADD_MONTHS (date, integer)
3) MONTHS_BETWEEN(date1, date2)
4) LAST_DAY(date)
5) ROUND(date, format), TRUNC(date, format)
6) NEXT_DAY (date, char)

4. 변환함수
1) TO_CHAR (숫자 혹은 날짜, format)
https://thebook.io/006696/0110/
SELECT TO_CHAR(123456789, '999,999,999'),
       TO_CHAR(1234567, '99,999,999'),          -- FORMAT만 지정하는 거임, ','로 숫자 구분을 해주는겨
       TO_CHAR(1234567, '00,000,000'),          -- 뒤 00과 비교해서 모자란  0 으로 채움자릿수만큼 
       TO_CHAR(123.4567, '99,990.000'),         -- 소수이하 3자리로 자동 반올림
       TO_CHAR(123456789, '$999,999,999'),      --  달러 표시 추가
       TO_CHAR(123456789, 'L999,999,999')          -- 원 표시 추가, 한국에서는 원이고, 일본에서는 엔화 표시가 추가됨
FROM DUAL; 
--    123,456,789	  1,234,567	 01,234,567	 00,000,123	 $123,456,789	        ￦123,456,789

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')               FROM DUAL;

2) TO_NUMBER(expr, format) 

3) TO_DATE(char, format), TO_TIMESTAMP(char, format)

4) GREATEST(expr1, expr2, …), LEAST(expr1, expr2, …)
SELECT GREATEST(1, 2, 3, 2),                -- 3
           LEAST(1, 2, 3, 2)                -- 1
FROM DUAL;

5) DECODE (expr, search1, result1, search2, result2, …, default)


-- 직원 정보, 담당 업무
SELECT      E.EMPLOYEE_ID, E.FIRST_NAME || ' ' || E.LAST_NAME 이름
            , J.JOB_TITLE
FROM        EMPLOYEES E 
JOIN        JOBS      J ON E.JOB_ID = J.JOB_ID;

-- 직원번호, 담당 업무, 담당 업무 HISTORY
SELECT          EMPLOYEE_ID, JOB_ID
FROM            EMPLOYEES
UNION
SELECT          EMPLOYEE_ID, JOB_ID
FROM            JOB_HISTORY;

SELECT          *
FROM            (       
                SELECT          EMPLOYEE_ID, JOB_ID
                FROM            EMPLOYEES
                UNION
                SELECT          EMPLOYEE_ID, JOB_ID
                FROM            JOB_HISTORY
                ) -- INLINE VIEW : FROM 뒤에 있는 걸 INLINE VIEW 라고 함, TABLE을 만드는데 사용함, FROM 뒤 ODRER BY 사용 가능함
                --SUBQUERY 는 ORDER BY를 사용할 수 없음
ORDER BY        EMPLOYEE_ID;

-- 사번, 업무시작일, 업무종료일, 담당 업무, 부서번호 EX)101번 직원 과거 HISTORY가 있음 
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')      업무시작일
                , '재직중'                              업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서번호
FROM            EMPLOYEES E
UNION
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(START_DATE, 'YYYY-MM-DD')     업무시작일
                , TO_CHAR(END_DATE, 'YYYY-MM-DD')       업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서버호
FROM            JOB_HISTORY H
;


SELECT          * -- * = 사번, 업무시작일, 업무종료일, 담당 업무, 부서번호
FROM            (
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')      업무시작일
                , '재직중'                              업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서번호
FROM            EMPLOYEES E
UNION
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(START_DATE, 'YYYY-MM-DD')     업무시작일
                , TO_CHAR(END_DATE, 'YYYY-MM-DD')       업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서버호
FROM            JOB_HISTORY H
                )
ORDER BY        사번 ASC, 업무시작일 ASC
;

--사번, 직원명, 업무시작일, 업무종료일, 담당 업무명, 부서명    해볼것
SELECT          사번, 업무시작일, 업무종료일, 담당업무, 부서번호, d.department_name
FROM            (
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')      업무시작일
                , '재직중'                              업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서번호
FROM            EMPLOYEES E
UNION
SELECT          EMPLOYEE_ID                             사번
                , TO_CHAR(START_DATE, 'YYYY-MM-DD')     업무시작일
                , TO_CHAR(END_DATE, 'YYYY-MM-DD')       업무종료일
                , JOB_ID                                담당업무
                , DEPARTMENT_ID                         부서버호
FROM            JOB_HISTORY H
                ) A
join            departments D ON A.부서번호 = D.department_id
ORDER BY        사번 ASC, 업무시작일 ASC
;



-------------------------------------------------------------------------------------------
VIEW : 뷰, SQL문을 저장해 놓고 TABLE 처럼 호출해서 사용하는 객체

1) INLINE VIEW -> SELECT 할떄만 VIEW로 작동 : 임시적으로 존재

SELECT      *
FROM        (
            SELECT      EMPLOYEE_ID                             사번
                        , FIRST_NAME || ' ' || LAST_NAME        이름
                        , EMAIL      || '@GREEN.COM'            이메일
                        , PHONE_NUMBER                          전화
            FROM        EMPLOYEES
            ORDER   BY  이름
            ) T
WHERE       T.사번 IN (100, 101, 102);

SELECT      *
FROM        (
            SELECT      DEPARTMENT_ID           DEPT_ID
                        , COUNT(SALARY)         CNT_SAL
                        , SUM(SALARY)           SUM_SAL
                        , AVG(SALARY)           AVG_SAL
            FROM        EMPLOYEES
            GROUP BY    DEPARTMENT_ID
            ORDER BY    DEPARTMENT_ID
            )   T
WHERE       T.AVG_SAL >= 4000;


2) 일반적인 VIEW -> 영구저장된 객체

VIEW 생성 - 영구 보관

-- CREATE VIEW "HR"."VIEW_EMP" ("사번","이름","이메일","전화")
CREATE OR REPLACE VIEW "HR"."VIEW_EMP" ("사번","이름","이메일","전화") -- OR REPLACE 구문은 ORACLE에서만 가능함
AS
    SELECT      EMPLOYEE_ID                             사번
                , FIRST_NAME || ' ' || LAST_NAME        이름
                , EMAIL      || '@GREEN.COM'            이메일
                , PHONE_NUMBER                          전화
    FROM        EMPLOYEES
    ORDER   BY  이름
;

SELECT          *
FROM            VIEW_EMP
WHERE           UPPER(이름) LIKE '%KING%'
;


-------------------------------------------------------------------------------------------
-- WITH : 가상의 테이블 생성
--
WITH A ("사번","이름","이메일","전화")
AS (
    SELECT      EMPLOYEE_ID                             사번
                , FIRST_NAME || ' ' || LAST_NAME        이름
                , EMAIL      || '@GREEN.COM'            이메일
                , PHONE_NUMBER                          전화
    FROM        EMPLOYEES
    ORDER   BY  이름
)
SELECT * FROM A;


-------------------------------------------------------------------------------------------
SELF JOIN - 사용하는 이유 : 계층형 쿼리가 만들어질때 사용, 상사-부하직원 같은 관계가 만들어질때 사용하는겨

-- 1)직원번호, 직속상사번호
SELECT      EMPLOYEE_ID
            , MANAGER_ID
FROM        EMPLOYEES;

-- 2)직원이름, 직속상사이름
-- 상사정보 : E1, 부하정보 : E2 - 테이블 복사
SELECT      E2.FIRST_NAME || ' ' || E2.LAST_NAME 직원이름
            , E1.FIRST_NAME || ' ' || E1.LAST_NAME  직속상사이름
FROM        EMPLOYEES   E1, EMPLOYEES   E2
WHERE       E1.EMPLOYEE_ID = E2.MANAGER_ID
ORDER BY    E1.EMPLOYEE_ID
; -- 사장이 출력되지 않는다

SELECT      E2.FIRST_NAME || ' ' || E2.LAST_NAME 직원이름
            , E1.FIRST_NAME || ' ' || E1.LAST_NAME  직속상사이름
FROM        EMPLOYEES   E1 JOIN  EMPLOYEES   E2
ON          E1.EMPLOYEE_ID = E2.MANAGER_ID
ORDER BY    E1.EMPLOYEE_ID;

-- 모든 직원 정보 : STEVEN KING, 보검, 리나 추가되어야 함
SELECT      E2.EMPLOYEE_ID
            , E2.FIRST_NAME || ' ' || E2.LAST_NAME 직원이름
            , E1.FIRST_NAME || ' ' || E1.LAST_NAME  직속상사이름
FROM        EMPLOYEES   E1 RIGHT JOIN  EMPLOYEES   E2
ON          E1.EMPLOYEE_ID = E2.MANAGER_ID
ORDER BY    E2.EMPLOYEE_ID ASC;

-------------------------------------------------------------------------------------------
-- 계층형 쿼리, CASCADING
--계층형 쿼리 : HIRERACHY

--LEVEL : 예약어임, 계층형 쿼리의 레벨을 구하는 명령어
--START WITH 시작점
--CONNECT BY PRIOR 어떻게
--직원번호, 직원이름, 레벨, 부서명

SELECT          E.EMPLOYEE_ID                           직원번호
                , LPAD(' ' , 3 * (LEVEL-1)) || E.FIRST_NAME || ' ' || E.LAST_NAME    직원이름 
                , LEVEL
                , D.DEPARTMENT_NAME                       부서명
FROM            EMPLOYEES   E JOIN DEPARTMENTS  D
ON              E.DEPARTMENT_ID = D.DEPARTMENT_ID
START WITH      E.MANAGER_ID IS NULL
CONNECT BY PRIOR    E.EMPLOYEE_ID = E.MANAGER_ID
ORDER BY        E.EMPLOYEE_ID
;

-------------------------------------------------------------------------------------------
-- EQUI JOIN (등가 조인) : 조인 조건이 = 인 것
-- NON EQUI JOIN (비등가 조인) : 조인 조건이 =이 아닌 것

직원등급
월급          등급
20000초과      S
15001~20000    A
10001~15000    B
 5001~10000    C
 3001~ 5000    D
    0~ 3000    E
    
    
SELECT          EMPLOYEE_ID                         직원번호
                , FIRST_NAME || ' ' || LAST_NAME    이름
                , SALARY                            월급
                , CASE 
                WHEN    SALARY > 20000  THEN    'S'
                WHEN    SALARY BETWEEN 15001 AND 20000  THEN    'A'
                WHEN    SALARY BETWEEN 10001 AND 15000  THEN    'B'
                WHEN    SALARY BETWEEN  5001 AND 10000  THEN    'C'
                WHEN    SALARY BETWEEN  3001 AND  5000  THEN    'D'
                WHEN    SALARY BETWEEN     0 AND  3000  THEN    'E'
                ELSE                                            '등급없음'
                END                                 등급
FROM            EMPLOYEES
ORDER BY        EMPLOYEE_ID
;

-- 등급 테이블 생성
DROP    TABLE   SALGRADE;

CREATE TABLE    SALGRADE
(
    GRADE   VARCHAR2(1)     PRIMARY KEY
    ,LOSAL  NUMBER(11)
    ,HISAL  NUMBER(11)
);

INSERT  INTO SALGRADE   VALUES('S', 20001, 99999999999);
INSERT  INTO SALGRADE   VALUES('A', 15001, 20000);
INSERT  INTO SALGRADE   VALUES('B', 10001, 15000);
INSERT  INTO SALGRADE   VALUES('C',  5001, 10000);
INSERT  INTO SALGRADE   VALUES('D',  3001,  5000);
INSERT  INTO SALGRADE   VALUES('E',     0,  3000);
COMMIT;
15001~20000    A
10001~15000    B
 5001~10000    C
 3001~ 5000    D
    0~ 3000    E
    
직원번호    직원명     월급  등급
SELECT      E.EMPLOYEE_ID                           직원번호
            , E.FIRST_NAME || ' ' || E.LAST_NAME    이름
            , E.SALARY                              월급
            , NVL(SG.GRADE, '등급없음')             등급
FROM        EMPLOYEES   E   LEFT JOIN        SALGRADE    SG
ON          E.SALARY    BETWEEN SG.LOSAL AND SG.HISAL
ORDER BY    E.EMPLOYEE_ID ASC
;

------------------------------------------------------------------------------------
-- 분석함수와 WINDOW 함수
1. ROW_NUMBER() : 줄번호  --1,2,3,4,5,6,...
2. RANK()       : 석차    --1,2,2,4,5,5,7.....
3. DENSE_RANK() : 석차    --1,2,2,3,4,5,5,6,...
4. NTILE()      : 그룹으로 분류
5. LIST_AGG()   

-- DESC NULLS LAST : NULL 맨 밑으로 간다
-- DESC NULLS FIRST : NULL 맨 위로 간다 : 기본값

1. ROW_NUMBER() : 페이징 기법

-- 전체 자료
SELECT          EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM            EMPLOYEES
ORDER BY        SALARY DESC NULLS LAST
;

-- 자료를 10개만 출력 - 페이징 기술
1) OLD 문법  : ROWNUM -- 의사칼럼(PSEUDO COLUMN, 의사 칼럼), 비추
SELECT          ROWNUM, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM            EMPLOYEES
--WHERE           ROWNUM BETWEEN    1 AND   10
ORDER BY        SALARY DESC NULLS LAST
;

SELECT ROWNUM, EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM            (
    SELECT          EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
    FROM            EMPLOYEES
    ORDER BY        SALARY DESC NULLS LAST
                ) T;
                
2) ANSI 문법 : ROW_NUMBER() -- 11G 부터
SELECT              *
FROM            (
    SELECT          ROW_NUMBER() OVER (ORDER BY SALARY DESC NULLS LAST) RN
                    ,EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
    FROM            EMPLOYEES
                ) T
WHERE           T.RN BETWEEN 11 AND 20
;

3) ORACLE 12C 부터는 OFFSET
SELECT          *
FROM            EMPLOYEES
ORDER BY        SALARY  DESC NULLS LAST
OFFSET          11 ROWS FETCH NEXT 10 ROWS ONLY 
; -- 11부터 10개를 의미함, ROW_NUMBER보다 빠르다함

------------------------------------------------------------------------------------
2. RANK()       : 석차    --1,2,2,4,5,5,7.....

월급순으로 석차를 출력
SELECT              EMPLOYEE_ID                                         사번
                    , FIRST_NAME || '' || LAST_NAME                     이름
                    , SALARY                                            월급
                    , RANK() OVER (ORDER BY SALARY DESC NULLS LAST)     석차
FROM                EMPLOYEES
;

월급순으로 석차를 출력 (1~10등까지)
SELECT      * FROM
(
SELECT              EMPLOYEE_ID                                         사번
                    , FIRST_NAME || '' || LAST_NAME                     이름
                    , SALARY                                            월급
                    , RANK() OVER (ORDER BY SALARY DESC NULLS LAST)     석차
FROM                EMPLOYEES
) T
WHERE      T.석차 BETWEEN 1 AND 10
;

3. DENSE_RANK() : 석차    --1,2,2,3,4,5,5,6,...
SELECT              EMPLOYEE_ID                                         사번
                    , FIRST_NAME || '' || LAST_NAME                     이름
                    , SALARY                                            월급
                    , DENSE_RANK() OVER (ORDER BY SALARY DESC NULLS LAST)     석차
FROM                EMPLOYEES
;

월급순으로 석차를 출력 (1~10등까지)
SELECT      * FROM
(
SELECT              EMPLOYEE_ID                                         사번
                    , FIRST_NAME || '' || LAST_NAME                     이름
                    , SALARY                                            월급
                    , DENSE_RANK() OVER (ORDER BY SALARY DESC NULLS LAST)     석차
FROM                EMPLOYEES
) T
WHERE      T.석차 BETWEEN 1 AND 10
;

------------------------------------------------------------------------------------------
5. LISTAGG()  : 여러줄을 한줄짜리 문자열로 변경

SELECT      DEPARTMENT_ID               FROM        EMPLOYEES;
SELECT      DISTINCT DEPARTMENT_ID     FROM        EMPLOYEES;

SELECT      LISTAGG(DISTINCT DEPARTMENT_ID, ',')
FROM        EMPLOYEES;

SELECT      LISTAGG(DISTINCT DEPARTMENT_ID, ',')
WITHIN  GROUP(ORDER BY  DEPARTMENT_ID DESC)
FROM        EMPLOYEES;