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

-- 2) 전 세계 국가는 총 몇 개인가?
desc city;
select Name, CountryCode from city;
select count(CountryCode) from city; # 4079

select distinct CountryCode from city;
select count(distinct CountryCode) from city; # 232

-- 3) 한국에 도시는 총 몇개의 도시가 있는지 확인하고 도시이름을 조회해 보세요
desc city;
select 	count(Name) as 도시개수 from city
where CountryCode like 'KOR'; -- 70

-- 4) 한국의 지역명이 “C”로 시작하는 지역의 도시 수는 몇개이고, 어떤 도시가 있는지 확인
desc city;
select * from city;
-- 정답 : 21개 (KOR, C로 시작하는 지역의 도시갯수)
select count(Name) from city
where CountryCode like 'KOR' and District like 'C%';

select Name, District from city
where CountryCode like 'KOR' AND District like 'C%';
-- ORDER BY District;

-- 정답 : 5개 (C로 시작하는 지역명)
SELECT distinct District as 지역명 from city
where CountryCode like 'KOR'
and District like binary 'C%'; # 데이터를 대소문자 가리도록

-- 정답 : 5개 (C로 시작하는 지역명 갯수)
SELECT count(distinct District) as 지역명 from city
where CountryCode like 'KOR'
and District like binary 'C%'; # 데이터를 대소문자 가리도록

-- 5. 한국의 지역명에서 2번째 글짜가 'y'인 경우의 도시명은 어떤 도시들이 있나요?
SELECT District, Name from city
WHERE CountryCode like 'KOR'
and  District like '_y%';

SELECT count(District)
--  Name 
from city
WHERE CountryCode like 'KOR'
and  District like '_y%';

-- 6. 전세계에서 도시의 인구가 300만명을 넘는 도시는 몇개가 있는지 확인하세요.
SELECT COUNT(Name) from city
WHERE  3000000 <= Population;

-- 7. 한국에서 인구가 70만명 ~ 100만명 사이의 도시는 어딘지 확인하세요.
SELECT Name from city
WHERE CountryCode like 'KOR'
and 700000 <= Population and Population <= 1000000;

SELECT CountryCode as ctry, name, Population
from city
where CountryCode like 'KO%'
and Population between 700000 and 1000000;

-- 8. 전 세계 도시이름 4번째 단어에 'j' 또는 'w'가 들어가는 도시중에서 인구가 50만명이 넘는 도시의 도시명, 인구수, 국가코드명을 출력하세요.
-- 정답 
SELECT Name, Population, CountryCode from city
WHERE 
(Name like '___j%' or Name like '___w%') -- like를 먼저하고 50만명이상을 구한다.
AND Population > 500000;

-- select name, Population, CountryCode
-- from city
-- where name like '___j%' or name like '___w%'
-- and Population >= 500000;

select count(name) -- 67
# Population, CountryCode
from city
where name like '___j%' or name like '___w%';
# and Population >= 500000;


# 서브쿼리: select ... from (select ... from ...);
select name, Population, CountryCode from city
where name in (select name from city
where name like '___j%' or name like '___w%')
and Population >= 500000;

/*select ... from tabble
where 1 in (1,2,3,4,5) ==> True
where 1 in (2,3,4,5) ==> False*/


-- 9. 인구 수가 가장 많은 도시 5곳을 출력하시오. ( city 테이블 활용)
SELECT name  
FROM city
Order by Population desc
Limit 5; 

select name, population from city
order by 2 desc
limit 5;

# 서브쿼리 방식
select * from
(select name, population from city order by 2 desc) as sub
limit 5;

-- 10. 세계에서 특정 언어가 해당지역에서 5% 미만으로 사용 되고 있지만, 공식적인 언어로 지정된 경우는 몇 건인가?
-- 또한 사용비율(Percentage) 기준으로 내림정렬 했을 경우, 상위 10개를 출력하세요. # countrylanguage 테이블 활용
desc countrylanguage;
select * from countrylanguage;

SELECT *
FROM countryLanguage
WHERE  Percentage < 5  and IsOfficial = 'T'
ORDER BY Percentage desc
LIMIT 10;

SELECT Count(*)
FROM countryLanguage
WHERE Percentage < 5 and IsOfficial = 'T';

SELECT CountryCode, Language, Percentage, IsOfficial
FROM countryLanguage
WHERE Percentage < 5 and IsOfficial = 'T'
ORDER BY Percentage desc
LIMIT 10;

SELECT CountryCode, Language, Percentage, IsOfficial
FROM countryLanguage
WHERE Percentage < 5 and IsOfficial = 'T'
ORDER BY 3 desc
LIMIT 10;

# KOR
SELECT * -- CountryCode, Language, Percentage, IsOfficial 
from countrylanguage
where CountryCode like '%KO%'
or CountryCode like '%JP%';


-- 11. 우리나라 도시정보를 하기 요구사항에 맞도록 출력하세요. (city 테이블 활용)
-- 1) 지역명을 기준으로 오름차순, 인구수를 기준으로 내림차순 출력 - 출력되는 레코드의 번호도 함께 출력
-- 2) 1)에서 출력된 내용을 기준으로 출력 순서 23번째 부터 10개를 출력하시오. - 출력되는 레코드의 번호도 함께 출력
desc city;
select * from city;

# 11-1-1. 지역명 오름차순, 인구수 내림차순
SELECT name, District, Population, CountryCode
from city
where CountryCode = 'KOR'
order by 2, 3 desc;

# 11-1-2 지역명 오름차순, 인구수 내림차순 => new index 추가
SELECT ROW_NUMBER() OVER(ORDER BY District asc, Population desc) as rw_num, name, District, Population, CountryCode
FROM city
where CountryCode = 'KOR';

# 11-2-1 10~22위 까지만 조회
SELECT name, District, Population, CountryCode
FROM city where CountryCode = 'KOR'
ORDER BY 2 asc, 3 desc
Limit 10 Offset 22;

# 11-2-2 22위 부터 10개 까지만 조회 => new Index 추가
SELECT row_number() over (order by District, Population desc) as rw_num,
		name, District, Population, CountryCode
from city where CountryCode = 'KOR'
limit 10 offset 22;

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


-- 3 Tier (MVC)
-- Frontend - Middleware - Database
-- Java	      Middleware   SQL
-- JavaScript C#
-- Python

-- 비정형
-- 반정형 => 반정형 => 정형   반정형으로 가다 정형으로 (다시 sql)로 돌아오는 이유는 반정형이라도 결국에는 마지막에 정형데이터로 변환해야 완료되기 때문
-- 정형  => 정형

-- #MySQL
-- 1개의 database = n개의 table

-- #오라클
-- 1개의 database = n개 tablespace
--					1개 Tablespace = n개의 Table

-- Database 함수 : SQL를 도와주는 역할
-- SQL은 선언적인 언어 
-- ==> 앞/뒤 명령어가 관계 X <장점>
-- 제어문(if) X <단점>

-- # 함수 지원(제어하는 것 명령어)
-- 단일행 함수 : round() 
-- input 수 = output 수
-- can be nested (중첩가능) ===> f3(f2(f1(x)))
-- 다행 함수 (그룹함수) : avg(), count() 
-- input 수 != output 수
-- cannot be nested (중첩불가능)

-- SQL 공통: 문법 키워드(SELECT, FROM 등)는 대소문자를 구분하지 않지만, 데이터(값) 비교는 DB 종류와 설정에 따라 달라집니다.
-- MySQL: 기본적으로 데이터 대소문자를 구분하지 않으나, BINARY 키워드를 쓰면 문자를 이진 코드(0, 1)로 인식해 엄격하게 구분합니다.
-- Oracle: 데이터의 대소문자를 매우 엄격하게 구분하며, 테이블명이나 컬럼명은 내부적으로 모두 대문자로 관리하는 것이 특징입니다.



-- 무결성은 중복된 더티데이터를 최소화하는 것(중복될 수 도 있음)