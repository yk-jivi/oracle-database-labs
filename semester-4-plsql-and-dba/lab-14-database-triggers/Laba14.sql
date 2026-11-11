-- Задание №1
create table students (
    student_id number,
    student_name varchar2(100),
    age number,
    row_status varchar2(10) default 'ACTIVE',
    change_date timestamp default systimestamp,
    constraint pk_students primary key (student_id, row_status, change_date)
);

-- Задание №2
begin
    insert into students(student_id, student_name, age) values (1, 'Иван', 20);
    insert into students(student_id, student_name, age) values (2, 'Мария', 19);
    insert into students(student_id, student_name, age) values (3, 'Алексей', 21);
    insert into students(student_id, student_name, age) values (4, 'Ольга', 20);
    insert into students(student_id, student_name, age) values (5, 'Дмитрий', 22);
    insert into students(student_id, student_name, age) values (6, 'Елена', 19);
    insert into students(student_id, student_name, age) values (7, 'Павел', 20);
    insert into students(student_id, student_name, age) values (8, 'Татьяна', 21);
    insert into students(student_id, student_name, age) values (9, 'Игорь', 22);
    insert into students(student_id, student_name, age) values (10, 'Анна', 20);
    commit;
end;
/

select * from students;

-- Задание №3
create or replace trigger trg_oper_befor_ins_upd_del_students
before insert or update or delete on students
begin
    if inserting then
        dbms_output.put_line('[trg_oper_befor_ins_upd_del_students]: cработает ДО вставки (Оператор)');
    elsif updating then
        dbms_output.put_line('[trg_oper_befor_ins_upd_del_students]: cработает ДО обновления (Оператор)');
    elsif deleting then
        dbms_output.put_line('[trg_oper_befor_ins_upd_del_students]: cработает ДО удаления (Оператор)');
    end if;
end;
/

-- Задание №4-5
create or replace trigger trg_before_row_students
before insert or update or delete on students
for each row
begin
    if inserting then
        dbms_output.put_line('[trg_before_row_students]: ДО вставки строки ID=' || :new.student_id);
    elsif updating then
        dbms_output.put_line('[trg_before_row_students]: ДО обновления строки ID=' || :old.student_id);
    elsif deleting then
        dbms_output.put_line('[trg_before_row_students]: ДО удаления строки ID=' || :old.student_id);
    end if;
end;
/

-- Задание №6
create or replace trigger trg_oper_after_ins_upd_del_students
after insert or update or delete on students
begin
    if inserting then
        dbms_output.put_line('[trg_oper_after_ins_upd_del_students]: cработает ПОСЛЕ вставки (Оператор)');
    elsif updating then
        dbms_output.put_line('[trg_oper_after_ins_upd_del_students]: cработает ПОСЛЕ обновления (Оператор)');
    elsif deleting then
        dbms_output.put_line('[trg_oper_after_ins_upd_del_students]: cработает ПОСЛЕ удаления (Оператор)');
    end if;
end;
/

-- Задание №7
create or replace trigger trg_after_row_students
after insert or update or delete on students
for each row
begin
    if inserting then
        dbms_output.put_line('[trg_after_row_students]: ПОСЛЕ вставки строки ID=' || :new.student_id);
    elsif updating then
        dbms_output.put_line('[trg_after_row_students]: ПОСЛЕ обновления строки ID=' || :new.student_id);
    elsif deleting then
        dbms_output.put_line('[trg_after_row_students]: ПОСЛЕ удаления строки ID=' || :old.student_id);
    end if;
end;
/

-- Задание №8
create table audit_log (
    operation_date date default sysdate,
    operation_type varchar2(20),
    trigger_name   varchar2(50),
    data_info      varchar2(4000)
);

-- Задание №9
create or replace trigger trg_oper_befor_ins_upd_del_students
before insert or update or delete on students
declare
    v_type varchar2(20);
begin
    if inserting then v_type := 'INSERT';
    elsif updating then v_type := 'UPDATE';
    elsif deleting then v_type := 'DELETE';
    end if;

    -- Логирование на серверную консоль
    dbms_output.put_line('[trg_oper_befor_ins_upd_del_students]: cработает ДО ' || v_type || ' (Оператор)');

    -- Логирование в таблицу AUDIT
    insert into audit_log (operation_type, trigger_name, data_info)
    values (v_type, 'trg_oper_befor_ins_upd_del_students', 'Запрос запущен (уровень оператора)');
    commit;
end;
/

create or replace trigger trg_before_row_students
before insert or update or delete on students
for each row
declare
    v_type varchar2(20);
    v_data varchar2(4000);
begin
    if inserting then
        v_type := 'INSERT';
        v_data := 'ДО вставки строки ID=' || :new.student_id || ', Name=' || :new.student_name;
    elsif updating then
        v_type := 'UPDATE';
        v_data := 'ДО обновления строки: Old ID=' || :old.student_id || ' -> New ID=' || :new.student_id;
    elsif deleting then
        v_type := 'DELETE';
        v_data := 'ДО удаления строки ID=' || :old.student_id || ', Name=' || :old.student_name;
    end if;

    -- Логирование на серверную консоль
    dbms_output.put_line('[trg_before_row_students]: ' || v_data);

    -- Логирование в таблицу AUDIT
    insert into audit_log (operation_type, trigger_name, data_info)
    values (v_type, 'trg_before_row_students', v_data);
    commit;
end;
/

create or replace trigger trg_oper_after_ins_upd_del_students
after insert or update or delete on students
declare
    v_type varchar2(20);
begin
    if inserting then v_type := 'INSERT';
    elsif updating then v_type := 'UPDATE';
    elsif deleting then v_type := 'DELETE';
    end if;

    -- Логирование на серверную консоль
    dbms_output.put_line('[trg_oper_after_ins_upd_del_students]: cработает ПОСЛЕ ' || v_type || ' (Оператор)');

    -- Логирование в таблицу AUDIT
    insert into audit_log (operation_type, trigger_name, data_info)
    values (v_type, 'trg_oper_after_ins_upd_del_students', 'Запрос успешно выполнен (уровень оператора)');
    commit;
end;
/

create or replace trigger trg_after_row_students
after insert or update or delete on students
for each row
declare
    v_type varchar2(20);
    v_data varchar2(4000);
begin
    if inserting then
        v_type := 'INSERT';
        v_data := 'ПОСЛЕ вставки строки ID=' || :new.student_id;
    elsif updating then
        v_type := 'UPDATE';
        v_data := 'ПОСЛЕ обновления строки ID=' || :new.student_id;
    elsif deleting then
        v_type := 'DELETE';
        v_data := 'ПОСЛЕ удаления строки ID=' || :old.student_id;
    end if;

    -- Логирование на серверную консоль
    dbms_output.put_line('[trg_after_row_students]: ' || v_data);

    -- Логирование в таблицу AUDIT
    insert into audit_log (operation_type, trigger_name, data_info)
    values (v_type, 'trg_after_row_students', v_data);
    commit;
end;
/

-- Задание №10
declare
    v_now timestamp := systimestamp;
begin
    -- Первая вставка (пройдет успешно)
    insert into students (student_id, student_name, age, row_status, change_date) 
    values (999, 'Тест', 20, 'ACTIVE', v_now);
    commit;
    
    -- Вторая вставка с точно таким же ключом (вызовет ошибку ORA-00001)
    insert into students (student_id, student_name, age, row_status, change_date) 
    values (999, 'Дубликат', 20, 'ACTIVE', v_now);
    commit;
end;
/

select * from audit_log;
/

-- Задание №11
drop table students;

create or replace trigger trg_prevent_drop_students
before drop on schema
begin
    if dictionary_obj_name = 'STUDENTS' and dictionary_obj_type = 'TABLE' then
        raise_application_error(-20001, 'Удаление таблицы STUDENTS запрещено');
    end if;
end;
/

-- Задание №12
drop table audit_log;
/

select * from user_objects;

-- Заново нужно создать таблицу и перекомпилировать триггеры
alter trigger trg_oper_befor_ins_upd_del_students compile;
alter trigger trg_before_row_students compile;
alter trigger trg_oper_after_ins_upd_del_students compile;
alter trigger trg_after_row_students compile;
/

-- Задание №13
alter table students add row_status varchar2(10) default 'ACTIVE';

create or replace view v_students as 
select student_id, student_name, age 
from students 
where row_status = 'ACTIVE';

create or replace trigger trg_instead_of_upd_students
instead of update on v_students
for each row
begin
    update students 
    set row_status = 'INVALID' 
    where student_id = :old.student_id and row_status = 'ACTIVE';

    insert into students (student_id, student_name, age, row_status)
    values (:new.student_id, :new.student_name, :new.age, 'ACTIVE');
end;
/

update v_students set age = 25 where student_id = 4;
commit;

select * from students;

select * from students;

-- Задание №14
update students 
set age = 21 
where student_id in (7, 20) and row_status = 'ACTIVE';

-- Задание №15
create or replace trigger trg_security_check
before insert on students
begin
    dbms_output.put_line('>>> [Триггер Проверки Прав]: Доступ разрешен');
end;
/

create or replace trigger trg_space_allocation
before insert on students
begin
    dbms_output.put_line('>>> [Триггер Выделения Памяти]: Место на диске зарезервировано');
end;
/

insert into students(student_id, student_name, age) values (11, 'Юлия', 40);

create or replace trigger trg_space_allocation
before insert on students
follows trg_security_check -- Жесткое указание: запускаться строго после trg_security_check
begin
    dbms_output.put_line('>>> [Триггер Выделения Памяти]: Место на диске зарезервировано.');
end;
/



