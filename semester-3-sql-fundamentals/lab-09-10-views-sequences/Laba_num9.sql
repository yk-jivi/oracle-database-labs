--Задание №1
declare @a char(10) = 'Я T-SQl!',
		@b varchar(50) = 'Привет!',
		@c datetime,
		@d time,
		@e int,
		@f smallint,
		@g tinyint,
		@h numeric (12,5)
Set @c = getdate();
Set @d = getdate();
Set @e = 18;

Select 
	@f = 45, 
	@g = 7, 
	@h = 12345.6789;

Select 
	@a as [a],
	@b as [b],
	@c as [c],
	@d as [d]

Print 'e = ' + cast(@e as varchar(10));
Print 'f = ' + cast(@f as varchar(10));
Print 'g = ' + cast(@g as varchar(10));
Print 'h = ' + cast(@h as varchar(20));

--Задание №2
use UNIVER_True;
declare	@capacity int = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM),
		@count_aud int,
		@avg_capacity float,
		@count_menos int,
		@percent_aud float

Select @capacity [Общая вместимость];

if @capacity > 200
	begin
		Select @count_aud = count(*) from AUDITORIUM;

		Select @avg_capacity = avg(AUDITORIUM_CAPACITY * 1.0) from AUDITORIUM;

		Select @count_menos = count(*)
		from AUDITORIUM
		Where AUDITORIUM_CAPACITY < @avg_capacity;

		Set @percent_aud = (@count_menos * 100.0) / @count_aud;

		Select
			@count_aud [Количество аудиторий],
			@avg_capacity [Средняя вместимость],
			@count_menos [Меньше средней],
			@percent_aud [Процент меньше средней];
	end
else
	begin
		print 'Общая вместимость меньше 200. (' + cast(@capacity as varchar(10)) + ')';
	end

--Задание №3
Select '@@ROWCOUNT' as [Rowcount], @@ROWCOUNT as Значение;
Select '@@VERSION' as [Version], @@VERSION as Значение;
Select '@@SPID' as [SPID], @@SPID as Значение;
Select '@@ERROR' as [Error], @@ERROR as Значение;
Select '@@SERVERNAME' as [ServerName], @@SERVERNAME as Значение;
Select '@@TRANCOUNT' as [TranCount], @@TRANCOUNT as Значение;
Select '@@FETCH_STATUS' as [FetchStatus], @@FETCH_STATUS as Значение;
Select '@@NESTLEVEL' as [NestLevel], @@NESTLEVEL as Значение;

--Задание №4
declare @data table (t float, x float)
insert into @data values (18.5, 19.0), (21.0, 18.5), (18.5, 18.5)

Select t, x,
		case
			when t > x then power(sin(t), 2)
			when t < x then 4 * (t + x)
			else 1 - exp(x - 2)
		end as z
from @data;


declare @tableinfo table (fullname nvarchar(50))
insert into @tableinfo values (N'Шматова Юлия Сергеевна'),(N'Хмелевский Антон Юрьевич'),(N'Шиман Дмитрий Васильевич')
Select 
	left (parsename(replace(fullname, ' ', '.'), 3), 30) + ' ' +
	left (parsename(	replace(fullname, ' ', '.'), 2), 1) + '. ' +
	left (parsename(replace(fullname, ' ', '.'), 1), 1) + '.' as [Фамилия и инициалы]
from @tableinfo


Select
	s.IDSTUDENT,
	s.NAME,
	s.BDAY,
	datediff(year, BDAY, getdate())
		- case 
			when month(BDAY) > month(getdate())
			or month(BDAY) = month(getdate()) and day(BDAY) > day(getdate())
			then 1
			else 0
			end as Возраст
from STUDENT s
where month(BDAY) = month(dateadd(month, 1, getdate()));


Select	
	s.NAME,
	s.IDGROUP,
	p.SUBJECT,
	datename(weekday, p.PDATE) as [День недели]
from PROGRESS p join STUDENT s
on s.IDSTUDENT = p.IDSTUDENT
where s.IDGROUP = 6 and p.SUBJECT = 'БД'

--Задание №5
declare @count_stud int = (select count(*) from STUDENT)
	if @count_stud > 50
		begin
			print 'Количество студентов больше 50';
		end;
	else if @count_stud > 30
		begin
			print 'Количество студентов больше 30';
		end;
	else if @count_stud > 20
		begin
			print 'Количество студентов больше 20';
		end

--Задание №6
use UNIVER_True;
Select 
	s.NAME,
	p.SUBJECT,
	case
		when p.NOTE = 9 then 'Я в шоке!'
		when p.NOTE = 8 then 'Зэ бэст'
		when p.NOTE = 7 then 'Нормик'
		when p.NOTE = 6 then 'Ну такое'
		when p.NOTE = 5 then 'Могло быть лучше'
		when p.NOTE = 4 then 'Отстой'
		else 'Не знаю'
	end as Анализ
from STUDENT s inner join PROGRESS p
On s.IDSTUDENT = p.IDSTUDENT

--Задание №7
Create table #DateTable (
	id int,
	name varchar(50),
	age int
);

declare @i int = 0;

while @i <=10
	begin
		insert into #DateTable (id, name, age)
		values(@i, concat(N'Студент_', @i), 18 + @i%5);
		set @i = @i +1;
	end;

Select * from #DateTable
	
--Задание №8
declare @x int = 1
	print @x+1
	print 'Сейчас будет остановка'
	Return
	print 'Это надпись не должна появиться'


--Задание №9
begin try
	print 'Начало try';

	create table #ExampleTable(
	 id int primary key,
	 name varchar(50)
	);
	
	insert into #ExampleTable (id, name)
	values (1, N'Петя');

	insert into #ExampleTable (id, name)
	values (1, N'Юля');

	print 'Этот текст не напечатается, посколько произойдёт ошибка';
end try

begin catch
	print 'Код последней ошибки: ' + cast(error_number() as varchar(100));
	print 'Сообщение об ошибке: ' + cast(error_message() as varchar(100));
	print 'Номер строки с ошибкой: ' + cast(error_line() as varchar(100));
	print 'Имя процедуры: ' + cast(error_procedure() as varchar(100));
	print 'Уровень серьёзности ошибки: ' + cast(error_severity() as varchar(100));
	print 'Метка ошибки:' + cast(error_state() as varchar(100));
end catch;

drop table #ExampleTable