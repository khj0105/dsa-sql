# 1. 숫자함수 countd

/* 1) 나머지
div: 나누기 몫
mod, % : 나누기의 나머지 */

select 7/2, 7 div 4, 7 mod 4, 7 % 2;

/* 2) 주어진 값 기준 최소/최대, 반올림, 절삭
ceil: 주어진 값보다 큰 최소 정수
floor: 주어진 값보다 작은 최대 정수
round (값, 반올림 위치): 반올림, 양수(** 오른쪽방향), 음수(왼쪽방향**)
truncate (값, 절삭위치) */

select ceil(5.146) as "x보다 큰 최소정수",
	floor(5.146) as "x보다 작은 최대정수",
    -- round(5.146) as "5.146 반올림",
    round(5.146, 2) as "반올림: ***.00",
	round(5.146, -1) as "반올림: 0.***",
    truncate(5.146,2) as "절삭: ***.00";
    
/* 3) 절대값, n승, 제곱근, 1/0/-1, 랜덤값
	abs: 절댓값
    pow or power (x,y): x의 y승
    sqrt : 제곱근
    sign : -1, 0, 1
    rand(seed): 난수값 리턴 */

select abs(-20) as "절댓값",
		pow(4,3) as "4의 3승",
        sqrt(16) as "루트16",
        sign(-234) as "1/0/-1",
        rand() as "난수값",
        rand(23) as "seed 난수값";
        
/* 4) 로그와 자연상수 거듭제곱
pow(x, y): x의 y승
log(x, y): 밑이 x인 로그y
log2(y): 밑이 2인 로그 y
log(y): 밑이 e인 로그 y
ln(100): 밑이 e인 로그 y
exp(x): 자연상수 (e, Euler Number)의 x승
exp(n) as "e의 n승" */

select
	pow(2,12) as "2의 12승", log(2,4096) as "밑이 2인 로그4096",
    log(4,100) as "밑이 4인 로그100",
    log2(100) as "밑이 2인 로그10",
    log10(100) as "밑이 10인 상용로그10",
    -- log(100) as "밑이 e인 로그100",
    ln(100) as "밑이 e인 로그100",
    exp(1) as "자연상수의 e의 1승",
    exp(100) as "자연상수 e의 100승";
    
    
# 2. 문자함수 contd
/* 1) 문자길이, 문자열 붙이기, 대&소문자
	length(str): 문자열의 크기 return
    char_length(str): 문자열의 갯수 return
    concat(a, b): 문자열 연결
    concat_ws(sep, a, b): 문자열 연결, 첫번째 매개변수는 sep(구분자)
    lower / lcase : 소문자
    uppder / ucase : 대문자 */
    
    select version();
    
    use world;
    desc city;
    select distinct CountryCode from city;
    select length('jwc정'), char_length('jwc정');
    select concat('정', '재', '완');
    select concat('정', null, '완');
    select concat_ws('--', '정', '재', '완');
    select lower(name), Icase(name),
			upper(lower(name)), ucase(name) from city;
    
    
/* 2) 콤마(,) 문자열 위치
format(data, d) : 숫자 3자리 마다 콤마(,)를 넣어 문자열 반환
				d는 소숫점 이하 자리표기 여부
instr(data, 문자열) : data에서 2번째 매개변수 문자열을 찾아 위치값 반환
locate(문자열, data, pos) : data에서 pos부터 문자열을 찾아 위치값 반환
position(문자열 in data) : data에서 문자열을 찾아 위치값 반환
*/

desc city;
select format(population, 1), population from city
order by 2 desc;

select concat(name, countrycode) as c_name,
		instr(concat(name, countrycode), 'usa') as 'instr()' from city
where countrycode = 'usa';

select locate('db', 'RDBs are mariaDB&mySQL', 3);
select position('db' in 'RDBs are mariaDB&mySQL');

    
    
 /* 3) Lpad/Rpad, Ltrim/Rtrim
Lpad(data, n, 패딩문자) : 총길이(n)에서 data를 제외한 공간을 패딩문자로 왼쪽 채움
Rpad(data, n, 패딩문자) : 총길이(n)에서 data를 제외한 공간을 패딩문자로 오른쪽 채움
Ltrim(data) : data에서 왼쪽 공백제거
Rtrim(data) : data에서 오른쪽 공백제거
*/
select Lpad(name, 10, '#'),
		Rpad(name, 10, '#'),
        '	 mySQL 	',
        Ltrim('  mySQL  '),
        Rtrim('  mySQL  ') from city;
    
    
/* trim(data) : 양쪽에서 한번에 공백제거
trim(both '특수문자' from data) : 양쪽에서 특수문자 한번에 제거
trim(leading '특수문자' from data) : 왼쪽에서 특수문자 제거
trim(trailing '특수문자' from data) : 오른쪽에서 특수문자 제거 */

select
	' **mySQL## ', length(' **mySQL## '),
    trim(' **mySQL## '), length(trim(' **mySQL## ')),
    trim(leading '*' from trim(' **mySQL## ')) as 'left_trim',
    trim(trailing '#' from trim(' **mySQL## ')) as 'right_trim',
    trim(both '?' from '?????mySQL?????') as 'both_trim';
    

/* 4) 필요한 문자열 잘라내기
left(str, n) : 왼쪽에서 str을 n개 만큼 자르기
right(str, n) : 오른쪽에서 str을 n개 만큼 자르기    
substr(str, pos, n) : str을 pos위치에서 n개 만큼 자르기 # mind, substring 
						n값을 지정하지 않으면, 데이터의 끝까지 자름    
*/

desc city;
select * from city limit 5;
select concat(countrycode, name),
		left(concat(countrycode, name), 3),
        substr(concat(countrycode, name),4) from city limit 10;
        

/* 5) 반복, 변경 등
repeat(str, n) : str을 n회 반복
replace(str, a, b) : str에서 a를 b로 변경
reverse(str) : str순서를 반대로
strcmp(str1, str2) : 0(str1 = str2), 1 (str1 > str2), -1(str1 < str2)
*/

select repeat('korea', 3) as "반복",
		replace('myKOREA', 'my', 'our') as "값대체",
        reverse('korea') as "문자역순",
        strcmp('korea', 'rok') as "비교1",
        -- ascii('k'), ascii('r'), ascii('a'),
        strcmp('korea', 'a republic of korea') as "비교2",
        strcmp('korea', 'korea') as "비교3";
        
        

# Q1. 단일행 함수
-- city 테이블에서 countrycode와 name을 붙이고, 구분자는 '.'로 표기 위 결과를 출력할 때 일본의 도시를 한국의 도시로 변경해서 출력하시오.
select user(), database();
use city;
select * from city;
desc city;

-- select countrycode, name from city
-- where name like '&jp&'

select concat(CountryCode, ' : ' , Name)
from city
where CountryCode = 'jpn';

select replace(concat_ws(' : ', CountryCode, Name), 'JPN', 'KOREA') as "R.O.K"
from city
where CountryCode = 'jpn';


-- Oracle 7
-- decode() => if()
-- decode() => case() <SQL 표준> 모든 DB사용가능

# case
use world;
select user(), database();
# DDL : 테이블 생성
create table scit_tab(
		my_name char(10),
        my_team int(5)
);

# DML : 데이터 insert
select * from scit_tab;
insert into scit_tab values('박시윤',1);
insert into scit_tab values('서태민',2);
insert into scit_tab values('송미연',3);
insert into scit_tab values('송보미',4);
insert into scit_tab values('오채원',5);

# TCL
commit;		# 트랜잭션 인정				cpu		메모리(sql) <-> hdd (sql) 	commit; commit을 하면 메모리에 있던 sql이 hdd로 이동 저장
rollback;	# 트랜잭션 취소

# DQL
desc scit_tab;
select my_name, my_team from scit_tab;

select my_name, case my_team when 1 then '1조'
				when 2 then '2조'
                when 3 then '3조'
                else '우리반 아님' end as TEAM
from scit_tab;


# Q2. 단일행 함수
-- 1. 단일행 함수를 활용하여 여행가방(luggage) 비번에 해당하는 랜덤정수 3자리를 만드시오.
-- (단, 매번 실행할 때, 번호는 바뀌도록 구성)
-- create table luggage (
-- 		pw int(3)
-- );

-- select * from luggage;
-- select into luggage values(rand(3))as '난수 3자리'
-- from luggage;


-- 2. 한미일(KOR, USA, JPA)에서 인구가 많은 도시 top10을 출력하시오.
use world;
select * from city;

select contcat_ws(' : ', CountryCode, Name, Name


-- 3. 데이터 구조(사전작업 필요)가 다음과 같을 때, 국가코드와 인구수 데이터를 분리하세요.









