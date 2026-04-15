성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
  
----------------------------------------------------------------------------

 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
CREATE  TABLE   STUDENT
(
    STID        NUMBER(6)           PRIMARY KEY     
    ,STNAME     VARCHAR2(30)        NOT NULL        
    ,PHONE      VARCHAR2(20)        UNIQUE          
    ,INDATE     DATE                DEFAULT      SYSDATE   
);

--학번, 숫자(6), 기본키
--이름, 문자(30) 필수입력
--전화, 문자(20) 중복방지
--입학일 날짜 기본값 -- 오늘

-- 학생정보 입력
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
    VALUES          (1, '가나', '010', SYSDATE);
INSERT INTO STUDENT 
    VALUES          (2, '나나', '011', SYSDATE);    
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (3, '다나', '012'); -- INDATE 생략해서 
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (4, '라나', '013');
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (5, '라나', '014');
    
INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (NULL, '사나', '015'); -- 입력 안됨
-- SQL 오류: ORA-01400: NULL을 ("SKY"."STUDENT"."STID") 안에 삽입할 수 없습니다

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (5, '라나', '014'); -- 입력 안됨, 기본키 중복 안됨
-- ORA-00001: 무결성 제약 조건(SKY.SYS_C008385)에 위배됩니다

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (6, '하나', '014'); -- 입력 안됨, PHONE 중복으로 인해
-- ORA-00001: 무결성 제약 조건(SKY.SYS_C008386)에 위배됩니다

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (7, NULL, '018'); -- 입력 안됨, STNAME not null 제약 조건 위반, 
-- SQL 오류: ORA-01400: NULL을 ("SKY"."STUDENT"."STNAME") 안에 삽입할 수 없습니다
COMMIT;

INSERT INTO STUDENT (STID, STNAME, PHONE)
    VALUES          (6, '하나', '019');

COMMIT;

SELECT * FROM STUDENT;


 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 CREATE TABLE   SCORES
 (
    SCID            NUMBER(7)       NOT NULL
    ,SUBJECT        VARCHAR2(60)    NOT NULL
    ,SCORE          NUMBER(3)       CHECK (SCORE BETWEEN 0 AND 100)
    ,STID           NUMBER(6)       
    ,CONSTRAINTS    SCID_PK
        PRIMARY KEY (SCID, SUBJECT)
    ,CONSTRAINTS    STID_FK
        FOREIGN KEY (STID)
        REFERENCES  STUDENT(STID)
 );
 
 
 -- 일련번호 숫자(7)    기본키, 번호자동 증가
 -- 교과목   문자(60)   필수입력
 -- 점수     숫자(3)    범위 0~100
 -- 학번     숫자(6)    외래키
 
 INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
 VALUES             (1, '국어', 100, 1);
 
 INSERT INTO SCORES VALUES (2, '영어', 100, 1);
 INSERT INTO SCORES VALUES (3, '수학', 100, 1);
 
 INSERT INTO SCORES VALUES (4, '국어', 100, 2);
 INSERT INTO SCORES VALUES (5, '수학', 80, 2);

 INSERT INTO SCORES VALUES (6, '국어', 70, 4);
 INSERT INTO SCORES VALUES (7, '영어', 80, 4); 
 INSERT INTO SCORES VALUES (8, '수학', 85, 4); 
 
 INSERT INTO SCORES VALUES (9, '국어', 805, 5); -- ORA-02290: 체크 제약조건(SKY.SYS_C008389)이 위배되었습니다
 INSERT INTO SCORES VALUES (10, '영어', 100, 8); -- ORA-02291: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 부모 키가 없습니다
 
 -------------------------------------------------------------------------
 DML 추가, 수정, 삭제 -- COMMIT 필수
 1. INSERT(추가) - 줄(DATA) 추가, 
  1) INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
        VALUES (1, '국어', 100, 1);
        
  2) 여러줄 추가
  INSERT INTO EMP4
    SELECT * FROM HR.EMPLOYEES;
    
  3) INSERT문 여러개를 한번에 실행 - 여러줄 추가 : 새문법
  CREATE TABLE EX_SKY
  (
    ID      NUMBER(7)       PRIMARY KEY
    , NAME  VARCHAR2(30)     NOT NULL
  );
    
  INSERT ALL 
    INTO EX_SKY VALUES (103, '이순신')
    INTO EX_SKY VALUES (104, '김유신')
    INTO EX_SKY VALUES (105, '강감찬')
  SELECT * FROM DUAL;
  
  COMMIT;
 
2. DELETE -- 줄(DATA)을 삭제한다, 기본적으로 여러줄이 대상
          -- WHERE 이 없으면 전체를 대상으로 작업한다
DELETE
FROM        테이블명
WHERE       조건;
 
3. UPDATE -- 줄에 변화는 없고, 칸에 있는 정보만 수정한다
          -- WHERE 이 없으면 전체를 대상으로 작업한다
    UPDATE  테이블
    SET     칼럼1 = 고칠값1,
            칼럼2 = 고칠값2
    WHERE   조건;

UPDATE      SCORES
SET         SCORE = 70
WHERE       SCID = 6;

SELECT * FROM SCORES;

ROLLBACK;

COMMIT;

 -------------------------------------------------------------------------
 DATA 제거
 1. DROP TABLE SCORES;      -- 구조(테이블), DATA 모두 삭제, 복구 불가능
 
 2. TRUNCATE TABLE SCORES;  -- 구조는 남기고, DATA만 삭제, 속도빠름 -- 원리가 TABLE을 구조만 하나 복사해서 대조군으로 두고 나머지 DATA들 모두 삭제함
 
 3. DELETE FROM SCORES;     -- 구조는 남기고, DATA만 삭제, 속도 느림
 
 SCORES DATA 삭제
 
 -- SET TIMING ON
 SELECT * FROM SCORES;
 
 DELETE FROM SCORES;
 ROLLBACK;
 
 SELECT * FROM STUDENT;
 DELETE FROM STUDENT; -- ORA-02292: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다 -> 자식 먼저 지우고 부모 지우면 됨
 
 INSERT INTO STUDENT VALUES (11, '히나', '0111', SYSDATE );
 COMMIT;
 
 DELETE FROM STUDENT WHERE  STID = 1; -- ORA-02292: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
 DELETE FROM STUDENT WHERE  STID = 11;
 
 외래키 관계에서 자식 테이블의 DATA를 지우고 부모 테이블의 DATA를 삭제하면 지울수 있다
 DELETE FROM SCORES WHERE STID = 1;
 DELETE FROM STUDENT WHERE  STID=1;
 
 DROP TABLE SCORES;
 DROP TABLE STUDENT;
 
 -------------------------------------------------------------------------
 
 
 성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 -- ---------------------------------------------------------------------
 -- 조회
 -- 1. 학번, 이름, 점수(국어)
1) 학번 이름
SELECT      stid            학번
            , stname        이름
FROM        STUDENT;
2) 점수(국어)
SELECT      stid
            , score           "점수(국어)"
FROM        scores
WHERE       subject LIKE '국어';
3) 1)+2)
SELECT      T.STID          학번
            , T.STNAME      이름
            , S.SCID
            , S.SCORE       점수
FROM        SCORES  S JOIN STUDENT  T
ON          S.STID = T.STID
WHERE       S.SUBJECT LIKE '국어';
;
 -- 2. 학번, 이름, 총점, 평균
1) 총점, 평균
SELECT      S.STID            학번
            , SUM(S.SCORE)
            , ROUND(AVG(S.SCORE), 2)
FROM        SCORES S
GROUP BY    S.STID;

SELECT      S.STID            학번
            , T.STNAME
            , SUM(S.SCORE)
            , ROUND(AVG(S.SCORE), 2)
FROM        SCORES S JOIN STUDENT T ON S.STID=T.STID
GROUP BY    S.STID, T.STNAME;



 -- 3. 모든 학생의 학번, 이름, 총점, 평균 ( 점수가 NULL인 학생은 미응시 )
SELECT      S.STID            학번
            , T.STNAME
            , CASE SUM(S.SCORE)
            WHEN    NULL THEN '미응시'
            WHEN     THEN  SUM(S.SCORE)
            END
            , ROUND(AVG(S.SCORE), 2)
FROM        SCORES S RIGHT JOIN STUDENT T ON S.STID=T.STID
GROUP BY    S.STID, T.STNAME;
 
 
 
SELECT      S.STID            학번
            , T.STNAME
            , SUM(S.SCORE)
            , ROUND(AVG(S.SCORE), 2)
FROM        SCORES S RIGHT JOIN STUDENT T ON S.STID=T.STID
GROUP BY    S.STID, T.STNAME;
 
 -- 4. 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차
 
 
 
 
 