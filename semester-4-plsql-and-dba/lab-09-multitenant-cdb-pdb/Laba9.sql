--Задание №1
--Под SYS
alter session set container=freepdb1;

grant create session to syss;
grant create table to syss;
grant create sequence to syss;
grant create cluster to syss;
grant create synonym to syss;
grant create public synonym to syss;
grant create view to syss;
grant create materialized view to syss;
grant create database link to syss;
alter user syss quota unlimited on users;

--Задание №2
create global temporary table TEMP_T (
    id number,
    name varchar2(50)
) on commit delete rows;

insert into TEMP_T values (1, 'Test');
select * from TEMP_T;

commit;

select * from TEMP_T; -- пустота

--Задание №3
create sequence s1
start with 1000
increment by 10
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select s1.nextval from dual;
select s1.nextval from dual;
select s1.currval from dual;

--Задание №4
create sequence S22
start with 10
increment by 10
maxvalue 100
nocycle;

select s22.nextval from DUAL connect by level <= 10;
select s22.currval from dual;

-- попытка превышения
select S22.nextval from DUAL;

--Задание №5
create sequence s33
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

select S33.nextval from DUAL connect by level <= 12;

--Задание №6
create sequence s44
start with 10
increment by 1
minvalue 10
maxvalue 15
cycle
cache 5
noorder;

select S44.nextval from DUAL connect by level <= 10;

--Задание №7
select sequence_name from user_sequences;

--Задание №8
create table t1 (
    n1 number(20),
    n2 number(20),
    n3 number(20),
    n4 number(20)
) storage (buffer_pool keep);


drop sequence s1;
drop sequence s2;
drop sequence s3;
drop sequence s4;

create sequence s1
start with 1000
increment by 10
nominvalue
nomaxvalue
nocycle
nocache
noorder;

create sequence S2
start with 10
increment by 10
maxvalue 100
nocycle;

create sequence s3
start with 10
increment by -10
minvalue -100
maxvalue 10
nocycle
order;

create sequence s4
start with 10
increment by 1
minvalue 10
maxvalue 15
cycle
cache 5
noorder;

insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);
insert into t1 values (s1.nextval, s2.nextval, s3.nextval, s4.nextval);

select * from t1;

--Задание №9
create cluster ABC (
    x number(10),
    v varchar2(12)
)
hashkeys 200;

--Задание №10-12
create table a (
    xa number(10),
    va varchar2(12),
    data_a varchar2(50)
) cluster abc (xa, va);

create table b (
    xb number(10),
    vb varchar2(12),
    data_b varchar2(50)
) cluster abc (xb, vb);

create table c (
    xc number(10),
    vc varchar2(12),
    data_c varchar2(50)
) cluster abc (xc, vc);

--Задание №13
SELECT table_name FROM user_tables WHERE table_name IN ('A','B','C');
SELECT cluster_name FROM user_clusters WHERE cluster_name = 'ABC';

--Задание №14
create synonym syn_c for syss.c;
select * from syn_c;

--Задание №15
create public synonym syn_b for syss.b;
select * from syn_b;

--Задание №16
create table a2 (
    id number primary key,
    name varchar2(50)
);

create table b2 (
    id number primary key,
    a_id number,
    constraint fk_a foreign key (a_id) references a2(id)
);

insert into a2 values (1, 'A');
insert into a2 values (2, 'B');

insert into b2 values (1, 1);
insert into b2 values (2, 2);

create view v1 as
select a.id, a.name, b.id as b_id
from a2 a
inner join b2 b on a.id = b.a_id;

select * from v1;

--Задание №17
create materialized view mv_syss
refresh complete
start with sysdate
next sysdate + 2/1440
as
select a.id, a.name, b.id as b_id
from a2 a
join b2 b on a.id = b.a_id;

select * from mv_syss;

--Задание №18
create database link remote_link
connect to user2 identified by pass123
using '192.168.56.106:1521/FREEPDB1';

select * from TEST_REMOTE@remote_link;

--Задание №19
insert into test_remote@remote_link values (5, 'From VM1');
commit;

update test_remote@remote_link
set name = 'Updated'
where id = 5;
commit;

delete from test_remote@remote_link
where id = 4;
commit;

select * from TEST_REMOTE@remote_link;