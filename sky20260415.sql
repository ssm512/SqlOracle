------------------------------------------------------------------------
-- 관계가 설정된 테이블 삭제 방법1
DROP TABLE SCORES;      -- 자식 테이블(ENTITIY)을 먼저 삭제
DROP TABLE STUDENT;     -- 부모 테이블을 나중에 삭제
-- 관계가 설정된 테이블 삭제 방법2
DROP TABLE STUDENT CASCADE CONSTRAINTS PURGE; -- 순서에 무관하게 삭제 가능
DROP TABLE SCORES;

-------------------------------------------------------------------------
 
 성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
-------------------------------------------------------------------------
-- 학생정보
SELECT      *   FROM        student;
SELECT      *   FROM        scores;

-- 조회
-- 1. 학번, 이름, 점수(국어)
SELECT          ST.stid         학번
                , ST.stname     이름
                , SC.score      점수
FROM            STUDENT  ST, SCORES  SC
WHERE           ST.stid = SC.stid(+)
;

SELECT          ST.stid         학번
                , ST.stname     이름
                , SC.score      점수
FROM            student  ST JOIN scores  SC
ON           ST.stid = SC.stid(+)
;
-- 2. 학번, 이름, 총점, 평균
SELECT      ST.STID                   학번, 
            ST.STNAME                 이름, 
            SUM(SC.SCORE)             총점, 
            ROUND(AVG(SC.SCORE), 2)   평균
FROM        STUDENT ST, SCORES SC
WHERE       ST.STID = SC.STID(+)
GROUP BY    ST.STID, ST.STNAME       
ORDER BY    ST.STID, ST.STNAME ASC;

SELECT      ST.STID                   학번, 
            ST.STNAME                 이름, 
            SUM(SC.SCORE)             총점, 
            ROUND(AVG(SC.SCORE), 2)   평균
FROM        STUDENT ST LEFT OUTER JOIN SCORES SC
ON          ST.STID = SC.STID
GROUP BY    ST.STID, ST.STNAME       
ORDER BY    ST.STID, ST.STNAME ASC;

-- 3. 모든 학생의 학번, 이름, 총점, 평균 ( 점수가 NULL인 학생은 미응시 )
SELECT      ST.STID                                             학번, 
            ST.STNAME                                           이름, 
            DECODE(SUM(SC.SCORE), NULL, '미응시', SUM(SC.SCORE))총점, 
            CASE                                 
                WHEN  ROUND(AVG(SC.SCORE), 2) IS NULL  THEN '미응시'
                ELSE                                    TO_CHAR(AVG(SC.SCORE), '990.00')
            END                                                 평균
FROM        STUDENT ST, SCORES SC
WHERE       ST.STID = SC.STID(+)
GROUP BY    ST.STID, ST.STNAME       
ORDER BY    ST.STID, ST.STNAME ASC;

--SUBQUERY로 풀어봄
SELECT      학번, 이름, 
            DECODE(총점, NULL, '미응시', TO_CHAR(총점, '999'))     총점,
            DECODE(평균, NULL, '미응시', TO_CHAR(평균, '990.00'))  평균
FROM 
(
SELECT      ST.STID                   학번, 
            ST.STNAME                 이름, 
            SUM(SC.SCORE)             총점, 
            ROUND(AVG(SC.SCORE), 2)   평균
FROM        STUDENT ST LEFT OUTER JOIN SCORES SC
ON          ST.STID = SC.STID
GROUP BY    ST.STID, ST.STNAME       
ORDER BY    ST.STID, ST.STNAME ASC
);

-- 4. 모든 학생의 학번, 이름, 총점, 평균, 등급, 석차










