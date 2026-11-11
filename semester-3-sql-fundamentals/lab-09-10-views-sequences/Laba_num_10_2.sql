use shmatova_mybasetwo;

-- задание №1 - просмотр существующих индексов
exec sp_helpindex 'contract'
exec sp_helpindex 'departament'
exec sp_helpindex 'employee'
exec sp_helpindex 'role'

-- создаем временную таблицу для тестирования
create table #temptable (
    id int,
    name nvarchar(50),
    groupcode nvarchar(10)
);

declare @i int = 1;
while @i <= 1000
begin
    insert into #temptable (id, name, groupcode)
    values(
        @i,
        'Имя_' + cast(@i as nvarchar(50)),
        case
            when @i % 3 = 0 then 'A'
            when @i % 3 = 1 then 'B'
            else 'C' 
        end
    );
    set @i = @i + 1;
end;

-- запрос без индекса
select * from #temptable where id between 150 and 200

checkpoint;
dbcc dropcleanbuffers;

-- создаем кластеризованный индекс
create clustered index #temptable_cl on #temptable(id);

-- запрос с индексом
select * from #temptable where id between 150 and 200

drop table #temptable;

-- задание №2 - составной индекс
create table #temptabletwo (
    id int,
    name nvarchar(50),
    groupcode nvarchar(10)
);

declare @y int = 1;
while @y <= 10000
begin
    insert into #temptabletwo (id, name, groupcode)
    values(
        @y,
        'Данные под номером ' + cast(@y as nvarchar(50)),
        case
            when @y % 3 = 0 then 'A'
            when @y % 3 = 1 then 'B'
            else 'C' 
        end
    );
    set @y = @y + 1;
end;

-- запрос без индекса
select * from #temptabletwo where id between 1000 and 2000

-- создаем некластеризованный индекс
create index #temptabletwo_nonclu on #temptabletwo(id, name);

-- запрос с индексом
select * from #temptabletwo where id between 1000 and 2000

drop index #temptabletwo_nonclu on #temptabletwo;

-- задание №3 - индекс с include
select * from #temptabletwo where id between 1000 and 2000

create index #temptabletwo_id_x on #temptabletwo(id) include (name);

select * from #temptabletwo where id between 1000 and 2000

drop index #temptabletwo_id_x on #temptabletwo;

-- задание №4 - фильтрованный индекс
create index #temptabletwo_where on #temptabletwo(id) where (id >= 1000 and id < 2000);

select * from #temptabletwo where id between 1000 and 2000

drop index #temptabletwo_where on #temptabletwo;

drop table #temptabletwo;

-- задание №5 - фрагментация индексов
create table #tasktable (
    id int,
    name nvarchar(50),
    value decimal(10,2)
);

-- заполняем начальными данными
insert into #tasktable (id, name, value)
select 
    number,
    'Name_' + cast(number as nvarchar(10)),
    number * 1.5
from master.dbo.spt_values 
where type = 'P' and number between 1 and 100;

-- создаем индекс
create index ix_tasktable_id on #tasktable(id);

-- получаем object_id таблицы
declare @object_id int = object_id('tempdb..#tasktable');

-- оцениваем начальную фрагментацию
select 'до операций' as [этап], name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id, null, null, null) ss
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id;

-- вызываем фрагментацию множественными вставками
insert into #tasktable (id, name, value)
select top(5000) 
    id + 1000, 
    name + '_copy', 
    value * 1.1
from #tasktable;

-- оцениваем фрагментацию после вставки
select 'после вставки 5000 строк' as [этап], name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id, null, null, null) ss
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id;

-- выполняем реорганизацию индекса
alter index ix_tasktable_id on #tasktable reorganize;

-- оцениваем фрагментацию после реорганизации
select 'после реорганизации' as [этап], name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id, null, null, null) ss
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id;

-- выполняем перестройку индекса
alter index ix_tasktable_id on #tasktable rebuild;

-- оцениваем фрагментацию после перестройки
select 'после перестройки' as [этап], name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id, null, null, null) ss
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id;

-- очистка
drop table #tasktable;

-- задание №6 - fillfactor
create table #ex (
    tkey int,
    tf nvarchar(50)
);

-- заполняем начальными данными
insert into #ex (tkey, tf)
select 
    number,
    'Text_' + cast(number as nvarchar(10))
from master.dbo.spt_values 
where type = 'P' and number between 1 and 100;

-- создаем индекс с fillfactor = 65
create index #ex_tkey on #ex(tkey) with (fillfactor = 65);

-- получаем object_id таблицы
declare @object_id2 int = object_id('tempdb..#ex');

-- смотрим начальную фрагментацию
select name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id2, null, null, null) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
where name is not null;

-- добавляем 50% данных для создания фрагментации
insert top(50) percent into #ex(tkey, tf) 
select tkey, tf from #ex;

-- оцениваем уровень фрагментации после вставки
select name [индекс], avg_fragmentation_in_percent [фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id('tempdb'), @object_id2, null, null, null) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
where name is not null;

-- очистка
drop table #ex;