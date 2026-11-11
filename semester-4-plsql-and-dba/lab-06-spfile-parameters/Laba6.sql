--Задание №1
show parameter spfile;

--Задание №2(сервер)
ls -l $ORACLE_HOME/dbs/

--Задание №3
create pfile='S_PFILE.ORA' from spfile;
--(На сервере)
cat /opt/oracle/product/26ai/dbhomeFree/dbs/S_PFILE.ORA

--Задание №4 (на сервере)
vi /opt/oracle/product/26ai/dbhomeFree/dbs/S_PFILE.ORA
-- i - для редактирования
-- esc после редактирования
-- :wq - сохранение и выход

--Задание №5
create spfile='/opt/oracle/product/26ai/dbhomeFree/dbs/spfileNEW.ora'
from pfile='/opt/oracle/product/26ai/dbhomeFree/dbs/S_PFILE.ORA';

--(Проверка на сервере, что файл создался)
ls -l $ORACLE_HOME/dbs/

--Задание №6
--Проверка, что файлик, который создали, имеется
ls -l /opt/oracle/product/26ai/dbhomeFree/dbs/
--Переименовываем файлик, пишем специальный SID нашей бд, чтобы она автоматом
--подхватила наш файлик
mv /opt/oracle/product/26ai/dbhomeFree/dbs/spfileNEW.ora \
>    /opt/oracle/product/26ai/dbhomeFree/dbs/spfileFREE.ora
--Далее необходимо перезагрузить наш инстанс
--Выходим из sqlplus и на серваке пишем
export ORACLE_SID=FREE
--Потом опять заходим в sqlplus
sqlplus / as sysdba
--Далее по порядку
shutdown immediate
startup open;
--Просто посмотреть, что используется нужный файлик
show parameter spfile;

--Задание №7
alter system set open_cursors=300 scope=spfile;
shutdown immediate;
startup;
show parameter open_cursors;

--Задание №8
select name from v$controlfile;

--Задание №9
alter database backup controlfile to trace;

--Узнаём путь, где храняться все trace-файлы
select value 
from V$DIAG_INFO 
where name = 'Diag Trace';

--На сервере
cd /opt/oracle/diag/rdbms/free/FREE/trace
ls -ltr *.trc
cat FREE_ora_4946.trc

--Задание №10-11
ls -l /opt/oracle/product/26ai/dbhomeFree/dbs/

--Задание №12
 select name, value from V$DIAG_INFO where name in ('Diag Trace', 'Diag Alert', 'Default Trace File'); 

--Задание №13-14
alter system switch logfile;
alter database backup controlfile to trace;

--Задание №13
grep -i "switch" /opt/oracle/diag/rdbms/free/FREE/alert/log.xml | tail -10

--Задание №14
ls -lt /opt/oracle/diag/rdbms/free/FREE/trace/*.trc | head -3
cat $(ls -t /opt/oracle/diag/rdbms/free/FREE/trace/*.trc | head -1) | head -80






SHOW PARAMETER diagnostic_dest;
SELECT value FROM v$diag_info;