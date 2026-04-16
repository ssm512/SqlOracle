/* 
계정 : sky

TMEMBER
회원관리
회원번호		숫자(6)			기본키		자동증가
이름			문자(30)		필수입력	
아이디			문자(20)		필수입력	중복방지
암호			문자(20)		필수입력
이메일			문자(320)		필수입력	중복방지
가입일			날짜			기본값		오늘
*/

-- 아이디, 이름, 이메일
-- 샘플 데이터 5개
DROP TABLE TUSER;
CREATE TABLE	TUSER (
	USERID	VARCHAR2(20)    NOT NULL    PRIMARY KEY
    , USERNAME    VARCHAR2(30)    NOT NULL
    , EMAIL      VARCHAR2(320)    UNIQUE
	);
    
INSERT INTO TUSER VALUES ('a1', '가나', 'gana@naver.com') ;
INSERT INTO TUSER VALUES ('ab12', '나나', 'nana@naver.com') ;
INSERT INTO TUSER VALUES ('cd123', '다나', 'dana@naver.com') ;
INSERT INTO TUSER VALUES ('g2asd', '라나', 'lana@naver.com') ;
INSERT INTO TUSER VALUES ('xyz12', '마나', 'mana@naver.com') ;
COMMIT;

-- 회원 목록
SELECT      * FROM        TUSER;

SELECT      * FROM          TUSER WHERE       USERID = 'ab12';

UPDATE  TUSER SET email = 'SKY1@naver.com' WHERE   userid = 'a1';

rollback;

DELETE FROM TUSER WHERE UPPER(userid) = '';