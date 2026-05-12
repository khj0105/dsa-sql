-- 1. 전 세계 도시는 총 몇개인가요?
select * from city;
select count(*) from city;

-- 2. 전 세계 국가는 총 몇개인가?
select count(*) from country;

-- 3. 한국에 도시는 총 몇개의 도시가 있는지 확인하고 도시이름을 조회해 보세요.
select distinct countrycode from city;

select count(*) from city
where countrycode = 'KOR';

select name from city where countrycode = 'KOR';

-- 4. 한국의 지역명이 "C"로 시작하는 지역의 도시 수는 몇개이고, 어떤 도시가 있는지 확인하기.
select count(*) from city 
where countrycode = 'KOR'
and district like binary 'C%';

select name from city 
where countrycode = 'KOR'
and district like binary 'C%';

-- 5. 한국의 지역명에서 2번째 글자가 "y"인 경우의 도시명은 어떤 도시들이 있나요?
select name, district from city
where countrycode = 'KOR'
and district like '_y%';

-- 6. 전세계에서 도시의 인구가 300만명을 넘는 도시는 몇개가 있는지 확인하세요.
select count(*) from city
where population >= 3000000;

-- 7. 한국에서 인구가 70만명 ~ 100만명 사이의 도시는 어딘지 확인하세요.
select count(*) from city
where countrycode = 'KOR'
and population between 700000 and 1000000; -- population >= 700000 and population <= 1000000

-- 8. 전세계 도시이름 4번째 단어에 'j' 또는 'w'가 들어가는 도시 중에서 인구가 50만명이 넘는 도시의 도시명, 인구수, 국가코드명을 출력하세요.
select name, population, countrycode from city
where (name like '___j%' or name like '___w%')
and population >= 500000;

--  9. 인구 수가 가장 많은 도시 5곳을 출력하시오.
select name, population from city
order by population desc
limit 5;

-- 10. 세계에서 특정 언어가 해당지역에서 5% 미만으로 사용 되고 있지만,
-- 공식적인 언어로 지정된 경우는 몇 건인가? 또한, 사용비율(Percentage)
-- 기준으로 내림정렬 했을 경우, 상위 10개를 출력하세요 (countrylanguage 테이블 사용)
desc countrylanguage;
select count(*) from countrylanguage
where percentage < 5
and isofficial = 'T';

select * from countrylanguage
where percentage < 5
and isofficial = 'T'
order by percentage desc
limit 10;

-- 11. 우리나라 도시 정보를 하기 요구사항에 맞도록 출력하세요.
-- 1) 지역명을 기준으로 오름차순, 인구수를 기준으로 내림차순 출력
-- - 출력되는 레코드 번호도 함께 출력
select row_number() over (order by district, population desc) as "NO", district, name, population, countrycode from city
where countrycode = 'KOR'
order by district, population desc;

-- 2) 1)에서 출력된 내용을 기준으로 출력 순서 23번째 부터 10개를 출력하시오.
select row_number() over (order by district, population desc) as "NO", name, population, countrycode from city
where countrycode = 'KOR'
order by district, population desc
limit 10 offset 22;

-- 1. 단일행 함수를 활용하여 여행가방(luggage) 비번에 해당하는 랜덤정수 3자리를 만드시오.
select rand(); -- 0 ~ 1미만 실수
select concat(truncate(rand() * 10, 0), truncate(rand() * 10, 0), truncate(rand() * 10, 0)) as '난수 3자리';

-- 2. 한미일(KOR, USA, JPA)에서 인구가 많은 도시 top10을 출력하시오.
-- 출력 형식은 "국가코드:지역:도시명"과 "인구(콤마 구분 + '명')"
select concat_ws(':', countrycode, district, name),
concat(format(population, 0), '명')
from city
where countrycode in ('KOR', 'USA', 'JPN')
order by population desc
limit 10;

-- 아래와 같은 테이블을 준비하고, city_info 컬럼을 국가코드와 인구로 분리하여 조회하세요

-- (t_city 테이블이 이미 존재하면 삭제)
drop table if exists t_city; 

-- (t_city 테이블 생성)

create table t_city 
select concat(CountryCode, Name, ' ', Population) as city_info 
from city 
order by CountryCode desc, Population desc 
limit 30;

select * from t_city;
-- 국가코드 + 도시명 + " " + 인구수

select city_info, left(city_info, 3), substring_index(city_info, ' ', -1)  from t_city;

-- 특정 날짜가 주어졌을 때, 해당 월 마지막날의 요일을 출력하세요.
select now();
select last_day(now()); 
select dayname(last_day(now()));