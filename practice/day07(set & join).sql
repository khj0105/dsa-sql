# Set & Join

# DDL : 테이블 생성
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