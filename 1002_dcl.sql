-- 로컬 Mysql 서버에서 root 사용자의 권한 확인
SHOW GRANTS FOR root@localhost;


-- INSERT / 트랜잭션 commit 테스트
use test_db;
INSERT INTO students VALUES ('jo', 10, '강원도');

SELECT * FROM students;
-- 다른 세션에서도 조회 해보기
COMMIT;
-- commit 후 다른 세션에서도 테이블 데이터 조회 해보기


-- UPDATE / 트랜잭션 ROLLBACK 테스트
UPDATE students
SET   address = '경기도'
WHERE name = 'jo';
SELECT * FROM students;
rollback;
SELECT * FROM students;


-- DELETE / 트랜잭션 ROLLBACK 테스트
DELETE FROM students;
SELECT * FROM students;
ROLLBACK;
SELECT * FROM students;


-- Transaction 실습 - 은행 '송금기능'
-- 사전작업 '계좌' 테이블 생성, 데이터 추가
CREATE TABLE accounts (
                          name     VARCHAR(100) NOT NULL,
                          balance  INT DEFAULT 0
);

INSERT INTO accounts VALUES ('A', 10000);
INSERT INTO accounts VALUES ('B', 10000);

SELECT * FROM accounts;

-- A -> B  5000원
-- 1. A계좌에서 5000원 차감
-- 2. B계좌에서 5000원 추가
BEGIN;
UPDATE accounts
set   balance = balance - 5000
where name = 'A';

UPDATE accounts
set		balance = balance + 5000
where name = 'B';

ROLLBACK;    -- 트랜잭션 성공(commit) 혹은 취소(rollback) 실습 해보기