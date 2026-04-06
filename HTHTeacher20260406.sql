/*
HTH 계정 생성 후 + 버튼 클릭 후
이름                    : HTHTeacher
사용자 이름             :   hth
비밀번호                :   1234
호스트 이름             :   접속할 Server의 IP 주소
포트                    :   1521 ( window 방화벽 inbound, outbound port 추가 필요)
SID                     :   xe
*/

INSERT INTO MYCLASS
    VALUES  (9, '신상민', '010-4062-2390', 'shinsang512@naver.com', SYSDATE);
COMMIT;

SELECT * FROM MYCLASS ORDER BY 번호 ASC;