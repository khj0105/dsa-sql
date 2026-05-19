# Set & Join

# DDL : 테이블 생성
drop table t1;
drop table t2;
create table t1 (no int, name char(20), java tinyint);
create table t2 (no int, name char(20), java tinyint);

# DML : insert
select * from t1;
select * from t2;

# t1 insert
insert into t1 values (1, '강경태', round(rand() * 100, 0));
insert into t1 values
row (2, '박시은', round (rand() * 100, 0)),
row (3, '김태민', round (rand() * 100, 0)),
row (4, '이은희', round (rand() * 100, 0));

# t2 insert
insert into t2 values(9, '정휘원', round(rand()*100,0));
insert into t2 values
row(10, '정재윤', round(rand()*100,0)),
row(11, '허수연', round(rand()*100,0)),
row(12, '문창호', round(rand()*100,0));

select * from t1;
select * from t2;
rollback;
commit;

# DML: update
# 2 -> 73
update t1
set java = 73
where no = 4;
select * from t1;

# 16 -> 91
update t2
set java = 91
where no = 11;
select * from t2;

#
update t1
set java = 3
where no = 1;#같은 컬럼 하나 더 만듬

# union 중복 x 합집합
select * from t1
union
select * from t2;

# union all 중복
select * from t1
union all
select * from t2;

# DDL: 테이블 카피명령어
create table t3
as
select * from t1
union
select * from t2;

select * from t3;

# 교집합
select * from t1
where exists (select * from t2
where t1.no = t2.no); # 같은 레코드가 있어야 나옴

# 차집합 (t1-t2)
select * from t1
where no not in (select no from t2);

# 차집합 (t2-t1)
select * from t2
where no not in (select no from t1);



#
select count(*) from t1; # 4개
select count(*) from t2; # 5개
select count(*) from t1, t2; # 20개

select * from t1, t2; # 20개


# use world;
-- 1. Join 연산자를 활용하여 하기내용과 같이 출력하세요. (국가코드, 국가명, 지역명, 도시명, 인구)
use world;
desc city;
desc country;

select CountryCode, District, name, Population
from city
limit 3; -- AFG	Kabol	Kabul	1780000

select Code, Name
from country limit 3; -- ABW	Aruba

# join : city, country
select CountryCode as 국가코드, ctry.name as 국가명,
		District as 지역명, ct.name as 도시명, ctry.Population as 국가인구, ct.Population as 도시인구
-- CountryCode, District, name, Population
from city ct, country ctry
where ct.CountryCode = ctry.Code
limit 10;


-- 2. Join 연산자를 활용하여 하기 내용과 같이 출력하세요.(국가명, 사용언어, 공식언어유무, 언어사용비율)
desc countrylanguage;
desc country;
select * from countrylanguage;
select * from country;

select language, isofficial, percentage
from countrylanguage;

select name, code
from country;

select 
	name as 국가명,
    language as 사용언어,
    isofficial as 공식언어유무,
    percentage as 사용비율
from country ctry, countrylanguage ctrylg
where ctry.code = ctrylg.CountryCode
limit 15;

# use world;
-- 3. 하기 요구사항에 맞는 SQL을 개발하시오
-- 각 국가별 도시 수 현황
-- 도시 수가 60~150개 되는 국가현황
use world;
desc city;
desc country;
select * from city;
select * from country;


select countrycode, name
from city;

select Name, code
from country;

-- select 
-- 	ctry.name as 국가명,
--     ct.name as 도시수
-- from city ct, country ctry
-- where ct.countrycode = ctry.code and count(ct.name) between 60 and 150;

select 
	ctry.name as 국가명,
    count(ct.name) as 도시수
from city ct, country ctry
where ct.countrycode = ctry.code 
group by ctry.name
having count(ct.name) between 60 and 150
order by count(ct.name) desc;

-- 강사님 풀이
# 총 도시수: 4079개
# 60 ~ 150 도시수의 총 도시수: ?
# 1)
create table tt
as
select  ctry.name as 국가명,
		count(ct.name) as 도시수
from city ct, country ctry
where ct.CountryCode = ctry.Code
group by ctry.name
having count(ct.name) between 60 and 150
order by 도시수 desc;

desc tt;
select 국가명, sum(도시수) 
from tt
group by 국가명 with rollup
order by 2 desc;

-- 2) 서브 쿼리 활용
select 국가명, sum(도시수) from
(select  ctry.name as 국가명,
		count(ct.name) as 도시수
from city ct, country ctry
where ct.CountryCode = ctry.Code
group by ctry.name
having count(ct.name) between 60 and 150
order by 도시수 desc) as sub
group by 국가명 with rollup
order by 2 desc;

# 데이터 딕셔너리
use world;
show create table city;
-- CREATE TABLE `city` (
--    `ID` int NOT NULL AUTO_INCREMENT,
--    `Name` char(35) NOT NULL DEFAULT '',
--    `CountryCode` char(3) NOT NULL DEFAULT '',
--    `District` char(20) NOT NULL DEFAULT '',
--    `Population` int NOT NULL DEFAULT '0',
--    PRIMARY KEY (`ID`),
--    KEY `CountryCode` (`CountryCode`),
--    CONSTRAINT `city_ibfk_1` FOREIGN KEY (`CountryCode`) REFERENCES `country` (`Code`)
--  ) ENGINE=InnoDB AUTO_INCREMENT=4080 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

show create table country;
show create table scit_tab;
-- CREATE TABLE `scit_tab` (
--    `my_name` char(10) DEFAULT NULL,
--    `my_team` int DEFAULT NULL
--  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

desc information_schema.KEY_COLUMN_USAGE;
desc information_schema.TABLE_CONSTRAINTS;
desc information_schema.REFERENTIAL_CONSTRAINTS;

select * from information_schema.KEY_COLUMN_USAGE where CONSTRAINT_SCHEMA = 'youDB'; 
select * from information_schema.TABLE_CONSTRAINTS where CONSTRAINT_SCHEMA = 'youDB'; 
select * from information_schema.REFERENTIAL_CONSTRAINTS where CONSTRAINT_SCHEMA = 'youDB'; 


# 부모테이블 생성
use youDB;

drop table p_test;
create table p_test(
	p_id int primary key auto_increment,
    p_name varchar(20) not null unique,
    p_age tinyint not null,
    
    check (p_age >= 22 and p_age <= 37)
);

# 자식 테이블 생성
drop table c_test;
create table c_test (
	c_id int primary key,
    c_add varchar(20),
    
    constraint my_fk1 foreign key (c_id) references p_test(p_id)
);

desc p_test;
desc c_test;


# insert 부모
select * from p_test;
insert into p_test(p_name, p_age) values('시윤', 35); #1
insert into p_test(p_name, p_age) values('태민', 31); #2
insert into p_test values(101, '정식', 32);			 #11
insert into p_test(p_name, p_age) values('노은', 24);	 #12
insert into p_test values(3, '태윤', 28);				 #3
insert into p_test(p_name, p_age) values('미연', 25); #13
commit;

# insert 자식
desc c_test;
select * from c_test;
insert into c_test values(1, '부원동');
insert into c_test values(13, '중앙동');
insert into c_test values(11, '주거지 없음');

# 누가 어디에 사는지 조회
desc p_test;
desc c_test;
select
*
from p_test p join c_test c on p.p_id = c.c_id;
	
select * from p_test p, c_test c
where p.p_id = c.c_id;

# 부모삭제 시도
delete from p_test;
delete from p_test where p_id  = 11; # 정식 삭제

# 자식 삭제 ----> 부모 삭제
delete from c_test where c_id = 11; #1) 자식에서 정식 데이터 삭제
delete from p_test where p_id = 11; #2) 부모에서 정식 데이터 삭제