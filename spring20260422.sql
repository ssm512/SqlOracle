Microsoft Windows [Version 10.0.19045.6218]
(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 수 4월 22 14:44:55 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn /as sysdba
연결되었습니다.
SQL> show user
USER은 "SYS"입니다
SQL> alter session set "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> CREATE USER spring IDENTIFIED BY 1234;

사용자가 생성되었습니다.

SQL> GRANT CONNECT, RESOURCE TO spring;

권한이 부여되었습니다.

SQL> alter user spring default tablespace users quota unlimited on users;

사용자가 변경되었습니다.

SQL> show user
USER은 "SYS"입니다
SQL> conn spring/1234
연결되었습니다.
SQL> show user
USER은 "SPRING"입니다

------------------------------------------------------------------------------
-- 메뉴 목록
CREATE TABLE MENUS (
    MENU_ID     VARCHAR2(6)     PRIMARY KEY,
    MENU_NAME   VARCHAR2(100),
    MENU_SEQ    NUMBER(5)
);

INSERT INTO MENUS VALUES ('MENU01', 'JAVA', 1);

SELECT * FROM menus;

COMMIT;

INSERT INTO MENUS VALUES ('MENU02', 'SPRING', 2);
INSERT INTO MENUS VALUES ('MENU03', 'ORACLE', 3);
COMMIT;

SELECT * FROM menus ORDER BY menu_id;
DELETE FROM spring WHERE menu_id = '?';

COMMIT;


INSERT INTO menus (
    menu_id,
    menu_name,
    menu_seq
) VALUES ( (SELECT 'MENU' || TRIM(TO_CHAR(NVL(MAX(SUBSTR(menu_id, 5,2)),0) + 1, '00')) FROM MENUS),
           :v0,
           (SELECT NVL(MAX(menu_seq),0)+1 FROM MENUS)
);


SELECT MAX(menu_seq)+1 FROM MENUS;

SELECT SUBSTR(MAX(menu_id),5, 2) + 1 FROM MENUS;

SELECT MAX(SUBSTR(menu_id,2))+1 FROM MENUS;

SELECT NVL(MAX(SUBSTR(menu_id, 5,2)),0) + 1
FROM MENUS;

SELECT TO_CHAR(NVL(MAX(SUBSTR(menu_id, 5,2)),0) + 1, '00')
FROM MENUS;

SELECT 'MENU' || TO_CHAR(NVL(MAX(SUBSTR(menu_id, 5,2)),0) + 1, '00')
FROM MENUS;

SELECT 'MENU' || TRIM(TO_CHAR(NVL(MAX(SUBSTR(menu_id, 5,2)),0) + 1, '00'))
FROM MENUS;
// 'MENU' || TO_CHAR(SUBSTR(NVL(MAX(menu_id), '00'),5, 2) + 1) 
// MAX(MENU_ID)를 찾는데 null 이면 00을 리턴하고 
// 아니면 5번째 자리부터 2자리를 잘라서 +1을 한다
// 그리고 이를 문자로 변환하고 MENU와 합친다

CREATE TABLE TUSER (
    USERID          VARCHAR2(12)    PRIMARY KEY,
    PASSWORD        VARCHAR2(12)    NOT NULL,
    USERNAME        VARCHAR2(100)   NOT NULL,
    EMAIL           VARCHAR2(320)   ,
    UPOINT          NUMBER(9)       DEFAULT 0,
    REGDATE         DATE            DEFAULT SYSDATE
);

DROP TABLE YUSER;

INSERT INTO TUSER VALUES ('USER01', '1234', 'JAVA', 'JAVA@green.com', 200, SYSDATE);

rollback;

SELECT * FROM tuser ORDER BY userid;

INSERT INTO TUSER VALUES ('spring02', '1234', 'spring02', 'spring02A@green.com', 0, SYSDATE);

commit;

DELETE FROM tuser WHERE userid = '?';



--------------------------------------------------------------------------------

CREATE TABLE BOARD (
    IDX            NUMBER(8,0) PRIMARY KEY,
    MENU_ID        VARCHAR2(6)  REFERENCES MENUS (MENU_ID),
    TITLE          VARCHAR2(300)   NOT NULL,
    CONTENT        VARCHAR2(4000),
    WRITER         VARCHAR2(12),
    REGDATE        DATE     DEFAULT SYSDATE,
    HIT            NUMBER(9,0)      DEFAULT 0
);

INSERT INTO board (
    idx,
    menu_id,
    title,
    content,
    writer
) VALUES ( 
    1,
    'MENU01',
    'JAVA Hello',
    '자바 게시판에 오신것을 환영합니다',
    'java'
);
SELECT * FROM board;

commit;

SELECT
    idx,
    menu_id,
    title,
    content,
    writer,
    TO_CHAR(regdate, 'YYYY-MM-DD') REGDATE,
    hit
FROM
    board
ORDER BY    idx DESC;

INSERT INTO board (
    (SELECT NVL(MAX(IDX),0)+1 FROM BOARD)  IDX,
    menu_id,
    title,
    content,
    writer
) VALUES ( 
    1,
    'MENU01',
    'JAVA Hello',
    '자바 게시판에 오신것을 환영합니다',
    'java'
);


INSERT INTO board (
    IDX,
    menu_id,
    title,
    content,
    writer
) VALUES ( 
    (SELECT NVL(MAX(IDX),0)+1 FROM BOARD),
    'MENU02',
    'JSP Hello',
    'JSP 게시판에 오신것을 환영합니다',
    'jsp'
);

commit;

SELECT
    idx,
    menu_id,
    title,
    content,
    writer,
    TO_CHAR(regdate, 'YYYY-MM-DD') REGDATE,
    hit
FROM
    board
WHERE   menu_id = 'MENU01'
ORDER BY    idx DESC;


---------------------------------------------------------------------------------

20260506

SELECT
		    IDX,
		    MENU_ID,
		    TITLE,
		    CONTENT,
		    WRITER,
		    TO_CHAR(REGDATE, 'YYYY-MM-DD') REGDATE,
		    HIT
		FROM
		    BOARD
		WHERE   idx = 3;
        
        
select * from board;