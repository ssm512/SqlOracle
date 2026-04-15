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
-- 점수가 null 인 학생은 미응시
학번, 이름, 총점, 평균, 등급, 석차
SELECT      st.stid                                                 학번, 
            st.stname                                               이름, 
            CASE
                WHEN    SUM(sc.score) IS NULL THEN '미응시'
                ELSE                                TO_CHAR(SUM(sc.score), '990')
            END                                                     총점, 
            CASE
                WHEN    AVG(SC.SCORE) IS NULL THEN '미응시'
                ELSE                                TO_CHAR(AVG(SC.SCORE), '990.00')
            END                                                     평균,
            CASE
                WHEN    ROUND(AVG(SC.SCORE), 2) BETWEEN 90 AND 100    THEN 'A'
                WHEN    ROUND(AVG(SC.SCORE), 2) BETWEEN 80 AND 89.99  THEN 'B'
                WHEN    ROUND(AVG(SC.SCORE), 2) BETWEEN 70 AND 79.99  THEN 'C'
                WHEN    ROUND(AVG(SC.SCORE), 2) BETWEEN 60 AND 69.99  THEN 'D'
                ELSE                                                       'F'
            END                                                     등급,
            RANK() OVER(ORDER BY SUM(sc.score) DESC NULLS LAST )    석차
FROM        student st LEFT OUTER JOIN scores sc
ON          st.stid = sc.stid
GROUP BY    st.stid, st.stname
;

-- 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차

-- 학번, 이름, 국어, 영어, 수학
1. ORACLE 10G 방식
1-1) 학번, 국어, 영어, 수학
SELECT      sc.stid                                       학번, 
            DECODE(sc.subject, '국어', sc.score )           국어, 
            DECODE(sc.subject, '영어', sc.score )           영어,
            DECODE(sc.subject, '수학', sc.score )           수학
FROM        scores sc;
1-2) 학번, 국어, 영어, 수학
SELECT      sc.stid                                              학번, 
            SUM(DECODE(sc.subject, '국어', sc.score ))           국어, 
            SUM(DECODE(sc.subject, '영어', sc.score ))           영어,
            SUM(DECODE(sc.subject, '수학', sc.score ))           수학
FROM        scores sc
GROUP BY    sc.stid
;
1-3) 학번, 이름, 국어, 영어, 수학
SELECT      st.stid                                              학번,
            st.stname                                            이름,
            SUM(DECODE(sc.subject, '국어', sc.score ))           국어, 
            SUM(DECODE(sc.subject, '영어', sc.score ))           영어,
            SUM(DECODE(sc.subject, '수학', sc.score ))           수학
FROM        scores  sc RIGHT JOIN student  st
ON          sc.stid = st.stid
GROUP BY    st.stid, st.stname
ORDER BY    st.stid, st.stname
;

1-4) 학번, 이름, 국어, 영어, 수학, 총점, 평균
SELECT      st.stid                                              학번,
            st.stname                                            이름,
            SUM(DECODE(sc.subject, '국어', sc.score ))           국어, 
            SUM(DECODE(sc.subject, '영어', sc.score ))           영어,
            SUM(DECODE(sc.subject, '수학', sc.score ))           수학,
            SUM(sc.score)                                        총점,
            ROUND(AVG(sc.score),2)                               평균
FROM        scores  sc RIGHT JOIN student  st
ON          sc.stid = st.stid
GROUP BY    st.stid, st.stname
ORDER BY    st.stid, st.stname
;

1-5) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차 
-- 미응시자는 '미응시'로 출력
-- 등급 : 비등가 조인으로 해결
1-5-1) 비등가 조인을 위해 등급 table 먼저
CREATE  TABLE   SCOREGRADE  
(
    GRADE   VARCHAR2(1) PRIMARY KEY,
    LOSCORE    NUMBER(6, 2),
    HISCORE    NUMBER(6, 2)
);
DROP TABLE SCOREGRADE;
INSERT INTO SCOREGRADE VALUES ('A', 90, 100);
INSERT INTO SCOREGRADE VALUES ('B', 80, 89.99);
INSERT INTO SCOREGRADE VALUES ('C', 70, 79.99);
INSERT INTO SCOREGRADE VALUES ('D', 60, 69.99);
INSERT INTO SCOREGRADE VALUES ('F', 0, 59.99);
COMMIT;

1-5-2)
SELECT      T.학번, 
            T.이름, 
            DECODE(T.국어, NULL, '미응시', T.국어)            국어,
            DECODE(T.영어, NULL, '미응시', T.영어)            영어, 
            DECODE(T.수학, NULL, '미응시', T.수학)            수학, 
            DECODE(T.총점, NULL, '미응시', T.총점)            총점, 
            DECODE(T.평균, NULL, '미응시', T.평균)            평균, 
            DECODE(sg.grade, NULL, '미응시', sg.grade)        등급,
            RANK() OVER(ORDER BY T.총점 DESC NULLS LAST)      석차
FROM
(
SELECT      st.stid                                              학번,
            st.stname                                            이름,
            SUM(DECODE(sc.subject, '국어', sc.score ))           국어, 
            SUM(DECODE(sc.subject, '영어', sc.score ))           영어,
            SUM(DECODE(sc.subject, '수학', sc.score ))           수학,
            SUM(sc.score)                                        총점,
            ROUND(AVG(sc.score),2)                               평균
FROM        scores  sc RIGHT JOIN student  st
ON          sc.stid = st.stid
GROUP BY    st.stid, st.stname
ORDER BY    st.stid, st.stname
) T LEFT OUTER JOIN scoregrade SG 
ON          T.평균 BETWEEN sg.loscore AND sg.hiscore
;

2. ORACLE 11G 방식 -- PIVOT 명령어로 구현, 통계를 생성 - 일반적으로 집계 함수와 같이 사용한다
-- 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차

2-1) 학번, 이름, 국어, 영어, 수학
SELECT * FROM (
    SELECT STID, SUBJECT, SCORE
    FROM    SCORES
)
PIVOT   
(
    SUM(SCORE)
        FOR subject
            IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
);

2-2) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
SELECT  ST.stid                                                         학번, 
        ST.stname                                                       이름, 
        DECODE(T.국어, NULL, '미응시', T.국어)                          국어, 
        DECODE(T.영어, NULL, '미응시', T.영어)                          영어, 
        DECODE(T.수학, NULL, '미응시', T.수학)                          수학, 
        (NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학,0))                총점, 
        ROUND((NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학,0))/3, 2)    평균, 
        sg.grade                                                        등급, 
        RANK() OVER(ORDER BY (NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학,0)) DESC NULLS LAST)  석차
FROM    (
        SELECT * FROM (
            SELECT STID, SUBJECT, SCORE
            FROM    SCORES
        )
        PIVOT   
        (
            SUM(SCORE)
                FOR subject
                    IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
        ) -- pivot괄호
) T RIGHT JOIN student ST ON T.stid = ST.stid
    LEFT  JOIN scoregrade SG 
    ON         (NVL(T.국어,0) + NVL(T.영어, 0) + NVL(T.수학,0))/3 
    BETWEEN SG.loscore AND SG.hiscore
;




