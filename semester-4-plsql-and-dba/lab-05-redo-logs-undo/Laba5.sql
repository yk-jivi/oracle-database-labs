--Задание №1
select tablespace_name
from dba_tablespaces;

--Задание №2 (часть 1)
alter session set container = FREEPDB1;

create tablespace SYSS_QDATA
datafile 'D:\University_2nd_year\4th_semester\Databases\Projects\Laba5\SYSS_QDATA.dbf'
size 10m
offline;

select tablespace_name, status
from dba_tablespaces;

alter tablespace SYSS_QDATA online;

create user SYSS identified by 12345
default tablespace users
temporary tablespace temp;

grant create session to SYSS;
grant create table to SYSS;

alter user SYSS quota 2m on SYSS_QDATA;

--Задание №11
select segment_name,
       tablespace_name,
       extent_id,
       blocks,
       bytes
from dba_extents;

--Задание №16
drop tablespace SYSS_QDATA
including contents
and datafiles;

--Вопрос №3
select distinct segment_type from dba_segments;

--Вопрос №12
select value
from v$parameter
where name = 'db_block_size';