use UNIVER_True;

--Задание №1
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPS'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PROGRESS'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECT'
exec sp_helpindex 'TEACHER'

create table #TempTable (
	id int,
	name nvarchar(50),
	groupcode nvarchar(10),
);

declare @i int = 1;
while @i <= 1000
begin
	insert into #TempTable (id, name, groupcode)
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

drop table #TempTable;

--Select * from #TempTable where id between 150 and 200

checkpoint;  --фиксация БД
DBCC DROPCLEANBUFFERS;  --очистить буферный кэш

--create clustered index #TempTable_CL on #TempTable(id)
--Select * from #TempTable where id between 150 and 200

--Задание №2
create table #TempTableTwo (
	id int,
	name nvarchar(50),
	groupcode nvarchar(10),
);
go

declare @y int = 1;
while @y <= 10000
begin
	insert into #TempTableTwo (id, name, groupcode)
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
go 

drop table #TempTableTwo;
go 

Select * from #TempTableTwo where id between 1000 and 2000

create index #TempTableTwo_NONCLU on #TempTableTwo(id, name)

Select * from #TempTableTwo where id between 1000 and 2000

drop index #TempTableTwo_NONCLU on #TempTableTwo;

--Задание №3

Select * from #TempTableTwo where id between 1000 and 2000

create index #TempTableTwo_ID_X on #TempTableTwo(id) include (name)

Select * from #TempTableTwo where id between 1000 and 2000

drop index  #TempTableTwo_ID_X on #TempTableTwo;

--Задание №4

create index #TempTableTwo_Where on #TempTableTwo(id) where (id >= 1000 and id < 2000);

Select * from #TempTableTwo where id between 1000 and 2000

drop index  #TempTableTwo_Where on #TempTableTwo;

--Задание №5

-- 1. Создаем временную таблицу и индекс
CREATE TABLE #TaskTable (
    id INT,
    name NVARCHAR(50),
    value DECIMAL(10,2)
);

-- Заполняем начальными данными
INSERT INTO #TaskTable (id, name, value)
SELECT 
    number,
    'Name_' + CAST(number AS NVARCHAR(10)),
    number * 1.5
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 1 AND 100;

-- Создаем индекс
CREATE INDEX IX_TaskTable_ID ON #TaskTable(id);

-- Получаем object_id таблицы
DECLARE @object_id INT = OBJECT_ID('tempdb..#TaskTable');

-- 2. Оцениваем начальный уровень фрагментации
SELECT 'ДО операций' AS [Этап], name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID('tempdb'), @object_id, NULL, NULL, NULL) ss
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id;

-- 3. Вызываем фрагментацию множественными вставками
INSERT INTO #TaskTable (id, name, value)
SELECT TOP(5000) 
    id + 1000, 
    name + '_copy', 
    value * 1.1
FROM #TaskTable;

-- 4. Оцениваем фрагментацию ПОСЛЕ вставки
SELECT 'ПОСЛЕ вставки 5000 строк' AS [Этап], name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID('tempdb'), @object_id, NULL, NULL, NULL) ss
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id;

-- 5. Выполняем РЕОРГАНИЗАЦИЮ индекса
ALTER INDEX IX_TaskTable_ID ON #TaskTable REORGANIZE;

-- Оцениваем фрагментацию после РЕОРГАНИЗАЦИИ
SELECT 'ПОСЛЕ РЕОРГАНИЗАЦИИ' AS [Этап], name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID('tempdb'), @object_id, NULL, NULL, NULL) ss
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id;

-- 6. Выполняем ПЕРЕСТРОЙКУ индекса
ALTER INDEX IX_TaskTable_ID ON #TaskTable REBUILD;

-- Оцениваем фрагментацию после ПЕРЕСТРОЙКИ
SELECT 'ПОСЛЕ ПЕРЕСТРОЙКИ' AS [Этап], name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID('tempdb'), @object_id, NULL, NULL, NULL) ss
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id;

-- Очистка
DROP TABLE #TaskTable;

--Задание №6
-- Создаем временную таблицу
CREATE TABLE #EX (
    TKEY INT,
    TF NVARCHAR(50)
);

-- Заполняем начальными данными
INSERT INTO #EX (TKEY, TF)
SELECT 
    number,
    'Text_' + CAST(number AS NVARCHAR(10))
FROM master.dbo.spt_values 
WHERE type = 'P' AND number BETWEEN 1 AND 100;

-- Создаем индекс с FILLFACTOR = 65
CREATE INDEX #EX_TKEY ON #EX(TKEY) WITH (FILLFACTOR = 65);

-- Получаем object_id таблицы
DECLARE @object_id INT = OBJECT_ID('tempdb..#EX');

-- Смотрим начальную фрагментацию
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), @object_id, NULL, NULL, NULL) ss 
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id  
WHERE name IS NOT NULL;

-- Добавляем 50% данных для создания фрагментации
INSERT TOP(50) PERCENT INTO #EX(TKEY, TF) 
SELECT TKEY, TF FROM #EX;

-- Оцениваем уровень фрагментации после вставки
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), @object_id, NULL, NULL, NULL) ss 
JOIN sys.indexes ii ON ss.object_id = ii.object_id AND ss.index_id = ii.index_id  
WHERE name IS NOT NULL;

-- Очистка
DROP TABLE #EX;

--Задание №7

