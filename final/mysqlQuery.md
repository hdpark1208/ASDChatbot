서버에 필요한 데이터 베이스와 테이블을 생성하는 코드<br>
값을 바로 긁어서 사용할 수 있도록 코드창에서 중요하지 않은 부분은 주석처리 해두었음

생성 QUERY
```{mysql}
-- DB 생성하는 쿼리
CREATE DATABASE DB_CHAT;

-- DB 사용하는 쿼리
USE DB_CHAT;

-- 테이블 생성하는 쿼리
CREATE TABLE ChatData(
	ChatIndex Int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  -- ChatIndex를 Int 타입으로 하고 NULL값은 허용하지 않으면서 자동으로 값이 증가하도록 생성함
  -- PRIMARY KEY임.
	ChatDate DATETIME NOT NULL,
  -- DATETIME 널값을 허용하지 않음
  Who CHAR(10) NOT NULL,
  -- 고정값. CHAR 타입 NOTNULL
  Content VARCHAR(50) NOT NULL,
  -- 가변값. 50이지만 더 늘 수 있음. 최소가 사이즈가 50. NOT NULL.
  CHECK(Who IN ("Bot", "User"))
  -- 제약사항. Who에 Bot 혻은 User 라는 값만 들어올 수 있도록 함
);

-- SQL문은 대문자 소문자를 구별하지 못함
-- ChatData 테이블이나 CHATDATA 테이블이나 같은 테이블임
```

---

추가 Query
```{mysql}
INSERT INTO ChatData(ChatDate, Who, Content) VALUES(NOW(), "Bot", "텍스트 입력!");
-- 지정한 테이블의 지정한 변수부분에 값을 넣음
-- ChatIndex는 PIMARY KEY 이므로 널값이 들어갈 수 없지만 값이 자동으로 증가하므로 값을 주지 않아도 됨
-- NOW()로 값이 들어가는 시간을 넣어줌

-- 모든 값을 넣어주는 상황이라면
-- INSERT INTO ChatData VALUES(값1, 값2, 값3, 값4); 
-- 의 형식으로 값을 넣을 수 있음
```

---

제거 QUERY
```{mysql}
-- DB제거 쿼리
DROP DATABASE DB_CHAT;

-- 테이블 제거 쿼리
DROP TABLE ChatData;

-- 테이블 값 제거 쿼리
-- 테이블은 남아있음 값만 제거
DELETE TABLE ChatData;
```

