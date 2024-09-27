use test_db;
CREATE TABLE tmp (
     id 	INT           NOT NULL,
     name 	varchar(255)
);

INSERT INTO tmp (id, name)
VALUES (1, '카리나'), (2, '닝닝'), (3, '');

UPDATE tmp
SET name = ''
WHERE id = 3
;

-- IS NULL
SELECT id, name
FROM tmp
WHERE name IS NULL;   -- name IS NOT NULL

-- LIKE, Wildcard
SELECT id, name
FROM tmp
WHERE name LIKE '__나';	-- WHERE name LIKE '%닝%';

-- IN
SELECT *
FROM  tmp
WHERE name NOT IN ('카리나', '닝닝')
;

SELECT * FROM tmp
;

-- GROUP BY
SELECT address, name, age
FROM students
GROUP BY address
ORDER BY age desc
    LIMIT 5 OFFSET 3
;

-- 내림차순/오름차순
-- 정렬 기준(열) 다르게 (ORDER BY 열)
-- LIMIT(row수 제한), OFFSET (인덱스) 사용

SELECT address, count(*) cnt
FROM students
GROUP BY address
ORDER BY cnt desc
    LIMIT 3 OFFSET 2;

SELECT address, count(*) AS cnt
FROM students
GROUP BY address
ORDER BY cnt
    LIMIT 5 OFFSET 2;

SELECT     address, count(*) AS cnt
FROM       students
WHERE      age >= 29
GROUP BY   address
HAVING     count(*) >= 3
ORDER BY   cnt DESC;


-- INNER JOIN
SELECT *
FROM students AS s INNER JOIN classes AS c
                              ON s.name = c.name
;


-- students LEFT/RIGHT OUTER JOIN classes
SELECT *
FROM students AS s LEFT OUTER JOIN  classes AS c
                                    ON s.name = c.name
;

SELECT *
FROM students AS s RIGHT OUTER JOIN classes AS c
                                    ON s.name = c.name
;
SELECT s.age, s.address, c.name, c.class_name
FROM students s
         RIGHT OUTER JOIN
     classes c
     ON s.name = c.name
;


-- UNION / UNION ALL
SELECT name, age FROM students WHERE age < 30
UNION
SELECT name, age FROM students WHERE age < 32;


-- 조건문 CASE WHEN THEN
SELECT name, address, (SELECT
                           CASE
                               WHEN(age < 30) THEN '20대'
                               ELSE '30대'
                               END AS '나이'
                       FROM students b
                       WHERE b.name = a.name
)
FROM students a;


-- SQL문에서 조건문 작성하는 방법: CASE WHEN THEN END
SELECT name, address, CASE
                          WHEN(age < 30) THEN '20대'
                          WHEN(age < 40) THEN '30대'
                          ELSE '...'
    END AS '나이'
FROM   students;


-- FROM 절에 들어가는 sub query
SELECT c.*
FROM (
         SELECT *
         FROM classes
         WHERE class_name IN ('데이터베이스')
     ) AS c
;


-- FROM 절에 들어가는 sub query + INNER JOIN
SELECT c.*, s.*
FROM (
         SELECT *
         FROM classes
         WHERE class_name IN ('데이터베이스', '알고리즘')
     ) AS c INNER JOIN students s
                       ON c.name = s.name
;