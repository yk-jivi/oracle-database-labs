-- Задание №1

alter table teacher add (
    birthday date,
    salary number(10,2)
);

update teacher set birthday = date '1985-01-01', salary = 1000 where teacher = 'СМЛВ';
update teacher set birthday = date '1990-02-10', salary = 1200 where teacher = 'АКНВЧ';
update teacher set birthday = date '1988-03-15', salary = 1100 where teacher = 'КЛСНВ';

update teacher 
set birthday = date '1985-06-07', salary = 1050 
where teacher = 'СМЛВ';

update teacher 
set birthday = date '1988-03-14', salary = 1150 
where teacher = 'КЛСНВ';

update teacher 
set birthday = date '1990-02-10', salary = 1200 
where teacher = 'АКНВЧ'; 

update teacher 
set birthday = date '1992-05-04', 
    salary = 950 
where birthday = date '1992-05-05';

select * from teacher;

commit;

-- Задание №2
select 
    substr(teacher_name, 1, instr(teacher_name,' ')) ||
    substr(teacher_name, instr(teacher_name,' ')+1,1) || '.' ||
    substr(teacher_name, instr(teacher_name,' ',1,2)+1,1) || '.' as fio
from teacher
where to_char(birthday,'D') = '1';

select 
    regexp_replace(teacher_name, '^(\S+)\s+(\S)\S*\s+(\S)\S*', '\1 \2.\3.') as fio
from teacher
where to_char(birthday,'D') = '1';

-- Задание №3
create or replace view v_next_month as
select 
    teacher_name,
    to_char(birthday,'DD/MM/YYYY') as birthday
from teacher
where extract(month from birthday) = extract(month from add_months(sysdate,1));

select * from v_next_month;

-- Задание №4
create or replace view v_count_by_month as
select 
    to_char(birthday,'Month') as month_name,
    count(*) as cnt
from teacher
group by to_char(birthday,'Month'),
         to_char(birthday,'MM')
order by to_char(birthday,'MM');

select * from v_count_by_month;

-- Задание №5
declare
    cursor c is
        select teacher_name, 
               extract(year from sysdate) - extract(year from birthday) + 1 as age
        from teacher;

begin
    for rec in c loop
        if mod(rec.age,5) = 0 then
            dbms_output.put_line(rec.teacher_name || ' - ' || rec.age);
        end if;
    end loop;
end;

-- Задание №6
declare
    cursor c is
        select f.faculty_name, p.pulpit, floor(avg(t.salary)) as avg_sal
        from faculty f 
        join pulpit p on f.faculty = p.faculty
        join teacher t on t.pulpit = p.pulpit
        group by rollup(f.faculty_name, p.pulpit); -- ROLLUP создает итоги по иерархии
begin
    for rec in c loop
        if rec.pulpit is not null then
            dbms_output.put_line('Кафедра: ' || rec.pulpit || ' - ' || rec.avg_sal);
        elsif rec.faculty_name is not null then
            dbms_output.put_line('Итог по факультету ' || rec.faculty_name || ': ' || rec.avg_sal);
        else
            dbms_output.put_line('Общий итог: ' || rec.avg_sal);
        end if;
    end loop;
end;

-- Задание №7
declare
    a number := 10;
    b number := 0;
    RES number;
begin
    -- проверка делителя
    if b = 0 then
        RAISE_APPLICATION_ERROR(-20001, 'Делитель равен 0!');
    end if;

    RES := a / b;

    DBMS_OUTPUT.PUT_LINE('Результат: ' || RES);

exception
    when ZERO_DIVIDE then
        DBMS_OUTPUT.PUT_LINE('Ошибка: деление на 0');
    when others then
        DBMS_OUTPUT.PUT_LINE('Пользовательская ошибка: ' || SQLERRM);
end;

-- Задание №8
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name
    from teacher
    where teacher = 'XXX';

    dbms_output.put_line(v_name);

exception
    when no_data_found then
        dbms_output.put_line('Преподаватель не найден!');
end;

declare
    v_name teacher.teacher_name%type;
    
    my_exception exception; 
    pragma exception_init(my_exception, 100); 
begin
    select teacher_name into v_name
    from teacher
    where teacher = 'XXX';

exception
    when my_exception then
        dbms_output.put_line('Сработало переопределённое исключение');
end;

-- Задание №9
declare
    e_main exception;
    pragma exception_init(e_main, -20001);
begin
    -- вложенный блок
    declare
        e_inner exception;
        pragma exception_init(e_inner, -20001);
    begin
        raise_application_error(-20001, 'Ошибка во вложенном блоке');
    end;

exception
    when e_main then
        dbms_output.put_line('Ошибка обработана в основном блоке');
end;

declare
    e exception;
begin
    declare
        e exception;
    begin
        raise_application_error(-20001, 'Ошибка');
    end;

exception
    when e then
        dbms_output.put_line('Не сработает без PRAGMA');
    when others then
        dbms_output.put_line('Сработал OTHERS');
end;

-- Задание №10
declare
    v_max_salary number;
begin
    select max(salary) into v_max_salary
    from teacher
    where 1 = 0;
    
    if v_max_salary is null then
        dbms_output.put_line('Данных нет, но исключение не возникло');
    else
        dbms_output.put_line('Максимальная зарплата: ' || v_max_salary);
    end if;

exception
    when no_data_found then
        dbms_output.put_line('Сработало NO_DATA_FOUND');
end;