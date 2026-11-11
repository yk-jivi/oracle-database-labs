--Задание №1
show parameter sga_max_size;

--Задание №2
select name, bytes/1024/1024 as mb
from v$sgainfo
where name in (
    'Buffer Cache Size',
    'Shared Pool Size',
    'Large Pool Size',
    'Java Pool Size',
    'Streams Pool Size',
    'Redo Buffers'
);

--Задание №3
--Гранула у всех 16 мб
select
    component,
    current_size,
    max_size,
    last_oper_mode,
    last_oper_time,
    granule_size,
    current_size/granule_size as Ratio
from v$sga_dynamic_components
where current_size > 0;

--Задание №4
select current_size/1024/1024 as free_mb
from v$sga_dynamic_free_memory;

--Задание №5
show parameter sga_target;
show parameter sga_max_size;

--Задание №6
select
component,
min_size,
current_size
from v$sga_dynamic_components;

--Задание №7-8
create table test_keep (
    id number,
    name varchar2(50)
) storage (buffer_pool keep) tablespace users

insert into test_keep values (1, 'Name1')
commit;

create table test_default (
    id number,
    name varchar2(50)
) storage (buffer_pool default) tablespace users

insert into test_default values (1, 'Name1')
commit;

select segment_name, segment_type, tablespace_name, buffer_pool from user_segments
where segment_name in ('TEST_KEEP', 'TEST_DEFAULT')

--Задание №9
show parameter log_buffer;

--Задание №10
select bytes/1024/1024 as LARGE_POOL_FREE_MB
from V$SGASTAT
where POOL='large pool'
and name='free memory';

--Задание №11
select username,  service_name, server from v$session where username is not null

--Задание №12
select name, description
from v$bgprocess
where paddr <> '00';

--Задание №13
select spid, program
from v$process
WHERE background IS NULL

--Задание №14
select count(*) as dbw_count
from v$bgprocess
where name like 'DBW%';

--Можем посмотреть, какие именно процессы
select name
from v$bgprocess
where name like 'DBW%';

--Задание №15
select name
from v$services;

--Задание №16
show parameter dispatchers;
show parameter shared_servers;
show parameter local_listener;
show parameter remote_listener;

--Задание №17 (на сервере)
ps -ef | grep tnslsnr

--Задание №18 (на сервере)
cat $ORACLE_HOME/network/admin/listener.ora

--Задание №19 (на сервере)
--Запуск
lsnrctl
--Далее help и поясняем команды

--Задание №20 (lsnrctl)
services