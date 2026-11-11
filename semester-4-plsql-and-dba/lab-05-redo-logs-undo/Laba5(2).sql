--Задание №2(часть 2)
create table SYSS_T1
(
    id number primary key,
    name varchar2(50)
)
tablespace SYSS_QDATA;

insert into SYSS_T1 values (1,'A');
insert into SYSS_T1 values (2,'B');
insert into SYSS_T1 values (3,'C');
commit;

select * from SYSS_T1;

--Задание №3
select segment_name, segment_type, tablespace_name
from user_segments
where tablespace_name='SYSS_QDATA';

--Задание №4
select segment_name, segment_type
from user_segments
where segment_name='SYSS_T1';

--Задание №5
select segment_name, segment_type
from user_segments
where segment_name <> 'SYSS_T1';

--Задание №6
drop table SYSS_T1;

--Задание №7
select segment_name, segment_type
from user_segments;

select object_name, original_name
from user_recyclebin;

--Задание №8
flashback table SYSS_T1 to before drop;

--Задание №9
begin
   for i in 4..10000 loop
      insert into SYSS_T1 (id, name)
      values (i, 'Name_' || i);
   end loop;
   commit;
end;

select count(*) from SYSS_T1;

--Задание №10
select extent_id,
       blocks,
       bytes
from user_extents
where segment_name = 'SYSS_T1';

select count(*) as num_extents
from user_extents
where segment_name = 'SYSS_T1';

--Задание №12
select rowid, id, name
from SYSS_T1
where rownum <= 10;

select 
    rowid,
    dbms_rowid.rowid_object(rowid) as object_number,
    dbms_rowid.rowid_relative_fno(rowid) as file_number,
    dbms_rowid.rowid_block_number(rowid) as block_number,
    dbms_rowid.rowid_row_number(rowid) as row_number,
    id,
    name
from SYSS_T1
where rownum <= 10;

--Заданеие №13
select rowid, ora_rowscn
from syss_t1
where rownum <= 10;

select 
    rowid,
    ora_rowscn,
    scn_to_timestamp(ora_rowscn) as last_change_time,
    id,
    name
from SYSS_T1
where rownum <= 10;
