use test_db;

-- NOT NULL 제약조건 테스트
CREATE TABLE nulltest (
    col1 varchar(10) NOT NULL,
    col2 varchar(10)
);
INSERT INTO nulltest (col1, col2) VALUES
('첫번째', '1'), ('두번째', '2'), (null, 'null 컬럼');  -- Error Code: 1048. Column 'col1' cannot be null

-- PRIMARY KEY & DEFAULT 제약조건 테스트
CREATE TABLE defaulttable (
    id 		INT PRIMARY KEY,
    name 	VARCHAR(20) NOT NULL,
    defaultcol VARCHAR(20) DEFAULT '-'
);
INSERT INTO defaulttable (id, name) VALUES (1, 'sungyeon'), (1, '');
SELECT * FROM defaulttable;

-- PK 제약조건에서 AUTO_INCREMENT 옵션
CREATE TABLE autoinctable (
    id	 INT 		 PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20)
);
INSERT INTO autoinctable (name) VALUES ('이름1'), ('이름2'), ('이름3');
SELECT * FROM autoinctable;

-- UNIQUE 제약조건
CREATE TABLE uniquetest (
                            id		VARCHAR(30) PRIMARY KEY,
                            name    VARCHAR(30) NOT NULL,
                            email   VARCHAR(400) UNIQUE
);
INSERT INTO uniquetest (id, name, email) VALUES
                                             ('jsy', '조성연', 'js@naver.com'),
                                             ('lsk', '이슬기', 'ls@gmail.com')
;
SELECT * FROM uniquetest;

UPDATE uniquetest
SET email = 'ls@gmail.com'
WHERE id = 'jsy';   -- Error Code: 1062. Duplicate entry 'ls@gmail.com' for key 'uniquetest.email'


-- FK 제약조건 - RESTRICT 옵션
CREATE TABLE customer (
                          id INT PRIMARY KEY,
                          name VARCHAR(10) NOT NULL,
                          address VARCHAR(200),
                          contact VARCHAR(100)
);
CREATE TABLE orders (
                        id INT PRIMARY KEY,
                        customer_id INT, 			-- 외래키
                        date TIMESTAMP DEFAULT now(),
                        payment VARCHAR(50),
                        amount INT,
                        delivery_amount INT,
                        FOREIGN KEY (customer_id) REFERENCES customer(id)
);
INSERT INTO customer VALUES
                         (1, '동해물', '서울', '010-1234-5678'),
                         (2, '백두산', '부산', '010-8765-4321');
INSERT INTO orders VALUES
                       (1, 1, '2023-11-12', '신용카드', 10000, 2500),
                       (2, 1, '2023-11-13', '신용카드', 20000, 2500),
                       (3, 2, '2023-11-12', '계좌이체', 30000, 3000);
delete from customer where id = 1;
delete from orders where customer_id = 1;   -- customer, orders 삭제 순서 확인

SELECT * FROM customer;
SELECT * FROM orders;

INSERT INTO orders VALUES
                       (1, 1, '2023-11-12', '신용카드', 10000, 2500),
                       (2, 1, '2023-11-13', '신용카드', 20000, 2500); --DML 실행시 오류 발생

-- FK 제약조건 - CASCADE 옵션
DROP TABLE orders;
DROP TABLE customer;

CREATE TABLE customer (
                          id INT PRIMARY KEY,
                          name VARCHAR(10) NOT NULL,
                          address VARCHAR(200),
                          contact VARCHAR(100)
);
CREATE TABLE orders (
                        id INT PRIMARY KEY,
                        customer_id INT, 			-- 외래키 설정
                        date TIMESTAMP DEFAULT now(),
                        payment VARCHAR(50),
                        amount INT,
                        delivery_amount INT,
                        FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE
);
INSERT INTO customer VALUES
                         (1, '동해물', '서울', '010-1234-5678'),
                         (2, '백두산', '부산', '010-8765-4321');
INSERT INTO orders VALUES
                       (1, 1, '2023-11-12', '신용카드', 10000, 2500),
                       (2, 1, '2023-11-13', '신용카드', 20000, 2500),
                       (3, 2, '2023-11-12', '계좌이체', 30000, 3000);
select * from customer;
select * from orders;

delete from customer where id = 1;      -- 삭제 성공!
-- delete from orders where customer_id = 1; -- 자동 삭제


-- FK 제약조건 - SET NULL 옵션
DROP TABLE customer;
DROP TABLE orders;

CREATE TABLE customer (
                          id INT PRIMARY KEY,
                          name VARCHAR(10) NOT NULL,
                          address VARCHAR(200),
                          contact VARCHAR(100)
);
-- create table orders (customer_id 컬럼에 FK 제약조건 SET NULL 옵션)
CREATE TABLE orders (
                        id INT PRIMARY KEY,
                        customer_id INT, 			-- 외래키
                        date TIMESTAMP DEFAULT now(),
                        payment VARCHAR(50),
                        amount INT,
                        delivery_amount INT,
                        FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE SET NULL
);
INSERT INTO customer VALUES
                         (1, '동해물', '서울', '010-1234-5678'),
                         (2, '백두산', '부산', '010-8765-4321');
INSERT INTO orders VALUES
                       (1, 1, '2023-11-12', '신용카드', 10000, 2500),
                       (2, 1, '2023-11-13', '신용카드', 20000, 2500),
                       (3, 2, '2023-11-12', '계좌이체', 30000, 3000);
select * from customer;
select * from orders;

delete from customer where id = 1;
-- 회원 id = 1 삭제했을 때 orders customer_id(참조값은) 어떻게 되었는지?? 확인해보기
select * from customer;
select * from orders;


-- ALTER TABLE : 열(=컬럼) 추가, 수정, 삭제
select * from students;
ALTER TABLE students
    ADD grade VARCHAR(200);   	-- 열 추가

ALTER TABLE students
    RENAME COLUMN grade TO great;	-- 열 이름 변경

ALTER TABLE students
    MODIFY COLUMN great VARCHAR(300);  -- 열 타입 변경

ALTER TABLE students
DROP COLUMN great;				-- 열 삭제