--Лабораторная работа №4

--Задание №1
select tablespace_name, contents, status
from dba_tablespaces;

--Задание №2
select tablespace_name, file_name
from dba_data_files;

select tablespace_name, file_name
from dba_temp_files;

--Задание №3
select group#, status, sequence#
from v$log;

--Задание №4
select GROUP#, member
from V$LOGFILE;

--Задание №5
alter system switch logfile;

select current_scn from v$database;

--Задание №6
alter database add logfile group 4
(
'/opt/oracle/oradata/FREE/redo04a.log',
'/opt/oracle/oradata/FREE/redo04b.log',
'/opt/oracle/oradata/FREE/redo04c.log'
) size 50M;

select GROUP#, member
from V$LOGFILE;

alter system switch logfile;

select GROUP#, SEQUENCE#
from V$LOG;

--Задание №7
select group#, status
from v$log;

alter system switch logfile;
alter system checkpoint;

alter database drop logfile group 4;

select GROUP#, member
from V$LOGFILE;
--Показывает, что файлов нет, но это обман, надо удалить из в консоли сервера.
--Сначала посмотрим каталог, где лежат redo-логи

ls /opt/oracle/oradata/FREE/

--Далее удаляем
rm /opt/oracle/oradata/FREE/redo04a.log
rm /opt/oracle/oradata/FREE/redo04b.log
rm /opt/oracle/oradata/FREE/redo04c.log

--И опять смотрим

ls /opt/oracle/oradata/FREE/

--Теперь всё ок

--Задание №8
archive log list;

--Задание №9
select count(*) as ARCHIVE_COUNT from V$ARCHIVED_LOG;

select sequence#, name from v$archived_log;

--Задание №10
--На сервере выпоняем эту команду
nano /tmp/start.ora

--Далее в текстовом редакторе
db_name='FREE'
db_recovery_file_dest='/opt/oracle/fast_recovery_area'
db_recovery_file_dest_size=10g
control_files='/opt/oracle/oradata/FREE/control01.ctl','/opt/oracle/oradata/FREE/control02.ctl'

processes=500
sessions=572
undo_tablespace='UNDOTBS1'
--Ctrl+X Y Enter

--Далее
unset TWO_TASK;
mkdir -p /opt/oracle/oradata/orcl
mkdir -p /opt/oracle/fast_recovery_area
mkdir -p /opt/oracle/admin/orcl/adump
chown -R oracle:oinstall /opt/oracle/oradata /opt/oracle/fast_recovery_area /opt/oracle/admin

--sqlplus
alter session set container = cdb$root;
shutdown immediate;

--Потом exit из sqlplus, и выполняем
unset TWO_TASK;
--Опять заходим в sqlplus и далее по сценарию

startup mount pfile='/tmp/start.ora';

alter database archivelog;

alter database open;

archive log list;

--Задание №11(sqlplus)
alter system switch logfile;

select sequence#, name, completion_time from v$archived_log;

select current_scn from v$database;

--Задание №12(sqlplus)
shutdown immediate;

--Выходим и на сервере
unset TWO_TASK;
--Опять заходим в sqlplus

startup mount pfile='/tmp/start.ora';

alter database noarchivelog;

alter database open;

archive log list;

--Задание №13(sqlplus)
show parameter CONTROL_FILES;

--Задание №14(sqlplus)
select name from v$database;

select name from v$datafile_header;

select * from v$backup;





--Вопросы
--Вопрос №6
show parameter UNDO_TABLESPACE;
--Вопрос №11
select * from V$CONTROLFILE_RECORD_SECTION;
--Вопрос №12
select group#, status
from v$log;
--Вопрос №14
SELECT group#, first_change#, next_change#
FROM v$log;
--Вопрос №16
select sequence#, first_change#, next_change#
from v$archived_log;
--Вопрос №17
archive log list;
--Вопрос №19
select max(SEQUENCE#) from V$ARCHIVED_LOG;
--Вопрос №20
show parameter log_archive_dest;

select name from v$archived_log;
--Вопрос №23
show parameter CONTROL_FILES;
--Вопрос №24
select name, CREATED, LOG_MODE
from V$DATABASE;

select FILE_ID, FILE_NAME, TABLESPACE_NAME, STATUS
from DBA_DATA_FILES;

select GROUP#, member, STATUS
from V$LOGFILE;

select name, STATUS
from V$CONTROLFILE;