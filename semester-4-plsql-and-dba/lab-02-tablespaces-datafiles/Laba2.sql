//ALTER SESSION SET "_oracle_script" = TRUE

create tablespace TS_SYS
datafile 'D:\University_2nd_year\4th_semester\Databases\Projects\Laba2\TS_SYS.dbf'
size 7m
autoextend on next 5m
maxsize 30m

create temporary tablespace TS_SYS_TEMP
tempfile 'D:\University_2nd_year\4th_semester\Databases\Projects\Laba2\TS_SYS_TEMP.dbf'
size 5m
autoextend on next 3m
maxsize 20m

select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;

select FILE_NAME, TABLESPACE_NAME, STATUS, MAXBYTES, USER_BYTES from SYS.DBA_DATA_FILES;

create role RL_SYS_CORE

grant create session,
        create table,
        create view,
        create procedure to RL_SYS_CORE;
        
grant alter any table to RL_SYS_CORE;
grant alter any procedure to RL_SYS_CORE;

grant drop any table to RL_SYS_CORE;
grant drop any procedure to RL_SYS_CORE;
grant drop any view to RL_SYS_CORE;

select role from DBA_ROLES where role = 'RL_SYS_CORE';

select * from DBA_SYS_PRIVS where grantee = 'RL_SYS_CORE';

create profile PF_SYSCORE limit
    password_life_time 180
    sessions_per_user 3
    failed_login_attempts 7
    password_lock_time 1
    PASSWORD_REUSE_TIME 10
    password_grace_time default
    connect_time 180
    idle_time 30

select * from DBA_PROFILES;
select * from DBA_PROFILES where profile = 'PF_SYSCORE';
select * from DBA_PROFILES where profile = 'DEFAULT';

create user SYSCORE identified by 12345
default tablespace TS_SYS
temporary tablespace TS_SYS_TEMP
profile PF_SYSCORE
account unlock
password expire

grant RL_SYS_CORE to SYSCORE;

alter user SYSCORE quota 2M on TS_SYS;

alter tablespace TS_SYS offline;

alter tablespace TS_SYS online;
