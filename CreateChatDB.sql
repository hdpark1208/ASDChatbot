-- USER/BOT CAHT DATABASE

-- DROP DATABASE DB_CHAT; 
CREATE DATABASE DB_CHAT;
USE DB_CHAT;


-- CREATE TABLE -------------------------------------------------------------------------
-- DROP TABLE CHAT_DATA;
CREATE TABLE CHAT_DATA(
	ChatIndex Int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ChatDate DATETIME NOT NULL,
    WHO CHAR(10) NOT NULL,
    CONTENT VARCHAR(50) NOT NULL,
    CHECK(WHO IN ("Bot", "User"))
);

-- INSERT TEST ------------------------------------------------------------------------
-- DELETE FROM CHAT_DATA;

-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "Bot", "텍스트 입력!");
-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "Bot", "d");
-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "User", "dsfsdf");
-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "User", "sdfsdafsdf");
-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "Bot", "arghwwgagaw");
-- INSERT INTO CHAT_DATA(ChatDate, Who, Content) VALUES(NOW(), "User", "awg44ga");
-- try catch문 어디갔어..;;;
 

-- SELECT * FROM CHAT_DATA ORDER BY CHATDATE ASC;
-- -- DEFAULT ASC
-- SELECT * FROM CHAT_DATA WHERE WHO = "I" LIMIT 500;

-- -----------------------------------------------------------------------------------