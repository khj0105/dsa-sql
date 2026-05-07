show databases;
use world;

show tables;

desc city;

# 전 세계 도시수
select * from city;
select name, population from city;

-- 1) 전 세계 도시는 총 몇 개인가요?
-- select city from tables;
select count(*) from city; # 4079개의 도시가 있을 것 같다는 추측




-- 정형데이터: 형태(o), 연산(o) SQL
-- 반정형데이터: 형태(o), 연산(x)
-- 비정형데이터: 형태(x), 연산(x) 사진, 동영상

-- #Database : 정형데이터 기반
-- #정형데이터 Object Type
-- 1) 벡터 : 1차원 
-- 2) 행렬 : 2차원 // 단일형
-- 3) * 데이터프레임 : 2차원  ==> 엑셀의 sheet (=table) // 다중 속성, 전통적인 데이터베이스
-- 4) 배열 : 2차원 이상
-- 5) 리스트 : 1차원에서 진화 // 반정형이라고도 할 수 있음(key-value)
-- Database : 2차원 지원
-- ==> 1971 IBM 산호세연구소 Dr.Codd
-- Select
-- Project X(select랑 통합)
-- Join
-- Union
-- Minus 

-- [SQL] 100% 증명됨
-- DQL(조회) : select
-- DDL(정의) : create, alter, drop 
-- DML(조작) : insert, update, delete
-- DCL(제어) : grant, revoke
-- TCL : rollback, commit


