-- char 타입은 변화가 없는 친구 이름, 성별 ... 데이터베이스를 찾는데 유리
-- varchar 타입은 변화가 많은 친구 주소, 연봉 ...

-- SQL 종류
-- DQL(select)					: 조회								# 해당사항 없음 (트랜잭션을 처리하려면 rock이 있어야 하는데 select는 검색이니 해당사항 없음)
-- DML(insert, update, delete)	: 데이터를 입력/수정/삭제				# 자동 commit(X) *** (commit은 트랜잭션이 끝난걸 알려줌 -> 메모리에 있던 데이터를 하드디스크에 저장하는 과정)
-- DDL(create, alter, drop)		: 데이터가 들여갈 공간정보 생성/수정/제거	# 자동 commit(O) ***
-- DCL(grant, revoke)			: 객체사용 권한 부여/취소				# 자동 commit(O)
-- TCL(commit, rollback)		: 트랜잭션 처리여부 결정					===>>> DML 처리

# 다행함수 (그룹함수)

select user(), database(); -- select는 트랜잭션아님

# 1. 데이터베이스 생성
create database if not exists youDB;
use youDB;

# 2. 테이블 생성
drop table m_emp;
create table m_emp(pid int primary key, 		-- not null(null은 초기화가 안된것), unique,	-- 제약조건은 더티 데이터 중복 방지, 무결성- 중복된 데이터를 최소화시키는 것을 무결성이라 한다.
					pname char(20) not null, 	-- not null, 중복ok
                    page tinyint,
                    p_number varchar(20) default '사줘요~'); -- null이 들어오려고 하면 default값이 들어감
desc m_emp;

# 3. DML: 데이터 key-in
# insert into m_emp(컬럼명,...) values(data,...);
insert into m_emp values(1, '강경태', 33, default);
insert into m_emp values(2, '김태민', 41, '010-2542-8198');
insert into m_emp values(3, '이은희', 18, '010-9874-2566');
insert into m_emp values(4, '정재윤', 61, default);
insert into m_emp values(5, '허수연', 20, default);
insert into m_emp values(6, '문창호', 63, '010-1254-8807');
insert into m_emp values(10, '정휘원', 34, '010-2354-9990');
rollback;
commit;
select * from m_emp;

# 4. DQL
select @@autocommit; # 0이면 autocommit이 아님

# <요구사항> 이름과 연령대(20대, 30대... 60대)만 조회
desc m_emp;

select pid, pname, page,
		case when page between 10 and 19 then '10대'
			 when page between 20 and 29 then '20대'
             when page between 30 and 39 then '30대'
             when page between 40 and 49 then '40대'
             when page between 50 and 59 then '50대'
             when page between 60 and 69 then '60대'
        else '70대 이상' end as '연령대'
 from m_emp;
 
SELECT pname AS "이름", concat(truncate(page, -1), '대') as "연령대";

/*
2004~2019년 개봉한 영화관련 정보 (35,151건)
https://www.kofic.or.kr/kofic/businexx/infm/introData.do
*/
drop table box_office;
create table box_office (
    seq_no          INT PRIMARY KEY,
    years           SMALLINT,
    ranks           INT,
    movie_name      VARCHAR(200),
    release_date    DATETIME,
    sale_amt        DOUBLE,
    share_rate      DOUBLE,
    audience_num    INT,
    screen_num      SMALLINT,
    showing_count   INT,
    rep_country     VARCHAR(50),
    countries       VARCHAR(100),
    distributor     VARCHAR(300),
    movie_type      VARCHAR(100),
    genre           VARCHAR(100),
    director        VARCHAR(1000)
);


use youdb;
select user(), database();

desc box_office;

select count(*) from box_office;

-- 문제
-- 1. 인구가 4,000만명~6,000만명에 해당하는 국가정보를 아래와 같이 조회하세요. # use world; desc country;
use world;
select * from country;
desc country;

select row_number() over(order by population desc) as "NO.", code as '국가코드', 
concat(name, ' ', '<',continent,'>') as '국가 <대륙>', region as '대륙내 지역', format(population, 0) as '인구' from country
where population between 40000000 and 60000000
order by population desc;

# 강사님 풀이
use world;
desc country;

select row_number() over(order by Population desc) as "No", 
	code as 국가코드, 
	concat(name,' <', Continent, '>') as "국가<대륙>", 
	Region as "대륙내 지역", 
	format(Population, 0) as "인구"
from country
where Population between 40000000 and 60000000
order by Population desc;


-- 2. 국가별 독립년도 정보를 확인하여 가장 일찍 개국한 나라 top 10을 조회하세요.
-- (단 정렬은 독립년도 기준 오름차순, 독립년도가 없는 국가는 제외)
-- # use world; desc country;
use world;
select * from country;

-- select row_number() over(order by indepyear) as 'NO.', name as '국가명', indepyear as '개국년도' ,
-- case when indepyear < 0 then 'BC' + 'indepyear * -1' else 'AD' + 'indepyear' end
-- from country
-- where indepyear is not null -- and indepyear < 0 = 'BC' + indepyear or indepyear >= 0 = 'AD'
-- order by indepyear
-- limit 10;
select row_number() over(order by indepyear) as 'NO.', name as '국가명', indepyear as '개국년도' ,
case when indepyear < 0 then concat('BC ' , abs(indepyear)) else concat ('AD ', indepyear) end as '기원구분'
from country
where indepyear is not null -- and indepyear < 0 = 'BC' + indepyear or indepyear >= 0 = 'AD'
order by indepyear
limit 10;

select row_number() over(order by indepyear) as 'NO.', name as '국가명',
case when indepyear < 0 then concat('BC ' , abs(indepyear)) else concat ('AD ', indepyear) end as '개국년도'
from country
where indepyear is not null -- and indepyear < 0 = 'BC' + indepyear or indepyear >= 0 = 'AD'
order by indepyear
limit 10;

# 강사님 풀이
desc country;
select row_number() over (order by IndepYear) as "NO.",
		Name as 국가명,
		concat(case when IndepYear < 0 then "BC "
			 when IndepYear > 0 then "AD "
             end, abs(IndepYear)) as 개국년도
from country
where IndepYear is not null
order by IndepYear
limit 10;

-- 3. 2019년 개봉영화 중에서 하기 조건에 부합하는 영화정보를 조회하시오.
-- # use youDB; desc box_office;
-- * 관객 : 300 ~ 700만명 or
-- * 매출 : 180 ~ 500억원
use youDB;
select * from box_office;

-- select 
-- 	row_number() over(order by sale_amt desc) as 'NO.', 
--     years as '제작년도', 
--     movie_name as '영화제목', release_date as '개봉일', 
--     sale_amt  as '관객수', 
-- 	concat(showing_count, '억') as '총매출' from box_office
-- where  
-- 	(sale_amt between 3000000 and 7000000) 
--     or (showing_count between 180 and 500) 
--     and
-- years = 2019 and release_date is not null
-- order by sale_amt desc;
use youDB;
select * from box_office;

select 
	row_number() over(order by sale_amt desc) as 'NO.', 
    years as '제작년도', 
    movie_name as '영화제목',
    concat(substr(release_date, 1, 4),'-', substr(monthname(release_date), 1, 3), '-', day(release_date)) as '개봉일',
    concat(format(audience_num, 0), '명')as '관객수',
    concat(substring(sale_amt, 1,3), '억') as '총매출'
    from box_office
where  
	years = 2019
    and(
		audience_num between 3000000 and 7000000
        or
        sale_amt between 18000000000 and 50000000000)
order by 
	sale_amt desc;
    
# 강사님 풀이
use youDB;
desc box_office;

select row_number() over(order by sale_amt desc) as "No.",
	years as 제작년도, 
    movie_name as 영화제목, 
    date_format(release_date, '%Y-%b-%e') as 개봉일, 
	concat(format(audience_num, 0), '명') as 관객수, 
    -- sale_amt,
    -- sale_amt/pow(10,8), 
    concat(round(sale_amt/pow(10,8),0),'억') as 총매출 -- pow(x,y)는 x의 y승
from box_office
-- where date_format(release_date, '%Y') = '2019';
WHERE year(release_date) = '2019'
and (audience_num between 3000000 and 7000000
or sale_amt/pow(10,8) between 180 and 500)
order by sale_amt desc;


-- 4. 2014년에 제작되었지만 2018~2019년에 개봉한 영화는?
-- # 여기에서는 years (제작년도), release_date (개봉시점)로 해석
select * from box_office;
select seq_no, 
	   years, 
       ranks, 
       movie_name, 
       release_date, 
       sale_amt, 
       share_rate, 
       audience_num,
	   screen_num, 
       showing_count, 
       rep_country, 
       countries, 
       distributor, 
       movie_type,
       genre, 
       director
from box_office
where years = 2014 and (substr(release_date, 1, 4) = 2018 or substr(release_date, 1, 4) = 2019) 
-- and release_date between 2018 and 2019
order by seq_no;

# 강사님 풀이 2014년 제작(years), 2018-2019(release_date) 개봉
desc box_office;
select release_date from box_office; # 2004-03-12 00:00:00

select * from box_office
where years = 2014
and release_date between '2018-01-01' and '2019-12-31'; 
-- year(release_date) between '2018' and '2019';

-- 5. 2017년 11월에 개봉한 영화 중에서 하기 요구사항에 부합되는 결과를 조회하세요.
-- # use youDB; desc box_office;
-- 여러명의 감독이 참여한 영화 (감독간의 구분자는 '/'로 표기)
-- 영화제목에 " : " 이 들어간 영화
-- -> select list : 영화, 개봉년월, 감독그룹

# 강사님 풀이
desc box_office;
select  
	distinct movie_name as 영화명, 
    extract(year_month from release_date) as 개봉년월, 
    replace(director, ',', '/') as 감독그룹
from box_office
where extract(year_month from release_date) = 201711
and replace(director, ',', '/') like '%/%'
and movie_name like '%:%';

-- 6. 2018~2019년에 개봉한 한국 및 미국영화 총 관객수가 1,000만명이 넘은 영화는?
-- # use youDB; desc box_office;

# 강사님 풀이
desc box_office;
select 
		years as 제작년도, 
        movie_name as 영화명, 
        rep_country as 배포국가, 
        extract(year_month from release_date) as 개봉년월,
        format(audience_num, 0) as 관객수, 
        concat(round(sale_amt/pow(10,8),0), '억원') as 매출 
from box_office
where year(release_date) in (2018, 2019)
and audience_num >= 10000000 
and rep_country in ('한국','미국')
order by audience_num desc;





# ■ Group 함수
-- select 리스트절에서 그룹함수를 제외한 모든 컬럼명은 group by 절에 있어야한다.
-- group by절에 오는 컬럼명 일지라도 select 리스트에 반드시 나올 필요는 없다.

-- 1. 각 국가별 도시의 갯 수가 몇개 있는지 확인하고, 보유 도시수 기준으로 top15를 조회하세요.
-- # 조회내용에서 총계 산출도 추가해서 조회해 보세요.
use world;
desc city;

select 
	CountryCode as 국가코드,
    count(name) as 도시수 -- 그룹 함수
	-- Name as 도시명
from city
group by CountryCode with rollup -- with rollup 는 전체 도시
order by 2 desc
limit 15;

select count(name) from city;

-- 2. 인구가 200만명이 넘는 도시는 각 국가별로 몇개인지 확인하세요.
-- # 조회내용에서 200만명이 넘는 도시를 4개 이상 보유하고 있는 국가는 어디인지 확인하세요.
use world;
desc city;
select
	CountryCode, 
    count(Name) as "num of city"
from city
where Population >= 20000000
group by name >= 4;

-- 4. 2004~2013년(10년간) 까지 년도별 개봉한 영화 수와 각 년도별 상/하반기 개봉한 영화 수
-- 또는 요일별 개봉영화수를 확인하시오. (# 정렬: 년도별 오름차순, 총 결산 표기) 
-- 힌트: x,y,z축 2004~2013년 영화, 년도별 개봉수, 년도별에서 상/하반기 개봉수
use youdb;
desc box_office;
select -- movie_name, release_date, quarter(release_date),
	   year(release_date) as 년도,
	   format(count(*),0) as "개봉영화 수", -- 그룹함수
		format(sum(case when quarter(release_date) in (1,2) then 1 else 0 end), 0) as "상반기 개봉영화수", -- 그룹함수
        format(sum(case when quarter(release_date) in (3,4) then 1 else 0 end), 0) as "하반기 개봉영화수"  -- 그룹함수
from box_office
where year(release_date) between 2004 and 2013
group by year(release_date) with rollup
order by 1;

-- 10.
# 그룹함수 Quiz 10
# 년도별, 100만명 관객이 본 영화 수, 국가별
use youDB;
desc box_office;
select count(distinct rep_country) from box_office; # 81개 국가

select  year(release_date) as 년도, count(*) as "관객 100만명 이상의 영화수",
		sum(case rep_country when '한국' then 1 else 0 end) as 한국횟수, 
		sum(case rep_country when '미국' then 1 else 0 end) as 미국횟수, 
		sum(case rep_country when '일본' then 1 else 0 end) as 일본횟수
from box_office
where year(release_date) between 2015 and 2019
and audience_num/pow(10,4) >= 100
group by year(release_date);