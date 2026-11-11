-- Неявные курсоры
-- Задание №1
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name
    from teacher
    where teacher = 'СМЛВ';
    dbms_output.put_line('Преподаватель: ' || v_name);
end;

-- Задание №2
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name
    from teacher
    where pulpit = 'ИСиТ';
exception
    when others then
        dbms_output.put_line('Ошибка: ' || sqlerrm);
        dbms_output.put_line('Код: ' || sqlcode);
end;

-- Задание №3
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name
    from teacher
    where pulpit = 'ИСиТ';
exception
    when too_many_rows then
        dbms_output.put_line('Слишком много строк.');
end;

-- Задание №4
declare
    v_name teacher.teacher_name%type;
begin
    select teacher_name into v_name
    from teacher
    where teacher = 'XXX';

exception
    when no_data_found then
        dbms_output.put_line('Преподаватель не найден.');
end;

begin
    update teacher
    set teacher_name = teacher_name
    where pulpit = 'ИСиТ';

    dbms_output.put_line('Изменено строк: ' || sql%rowcount);

    if sql%found then
        dbms_output.put_line('Строки найдены');
    end if;
end;

-- Задание №5
-- insert
begin
    insert into teacher (teacher, teacher_name, pulpit)
    values ('СМЛВ', 'Дубликат', 'ИСиТ');

exception
    when dup_val_on_index then
        dbms_output.put_line('Нарушение уникальности (PK)');
end;

-- update
begin
    update teacher
    set pulpit = 'XXX'
    where teacher = 'СМЛВ';

exception
    when others then
        dbms_output.put_line('Ошибка UPDATE (FK): ' || sqlerrm);
end;

-- delete
begin
    delete from pulpit
    where pulpit = 'ИСиТ';

exception
    when others then
        dbms_output.put_line('Ошибка DELETE (есть связанные TEACHER): ' || sqlerrm);
end;

-- Явные курсоры
-- Задание №6
declare
    cursor c_teacher is 
    select teacher, teacher_name, pulpit 
    from teacher;
    v_id   teacher.teacher%type;
    v_name teacher.teacher_name%type;
    v_pulpit teacher.pulpit%type;
begin
    open c_teacher;
    loop
        fetch c_teacher into v_id, v_name, v_pulpit;
        exit when c_teacher%notfound;

        dbms_output.put_line(v_id || ' | ' || v_name || ' | ' || v_pulpit);
    end loop;
    close c_teacher;
end;

-- Задание №7
declare
    cursor c_subject is select * from subject;
    v_row subject%rowtype;
begin
    open c_subject;
    fetch c_subject into v_row;

    while c_subject%found loop
        dbms_output.put_line(v_row.subject || ' | ' || v_row.subject_name);
        fetch c_subject into v_row;
    end loop;
    
    close c_subject;
end;

-- Задание №8
declare
    -- курсор с параметрами
    cursor c_aud (p_min number, p_max number) is
        select auditorium, auditorium_capacity
        from auditorium
        where auditorium_capacity between p_min and p_max;

    v_aud auditorium.auditorium%type;
    v_cap auditorium.auditorium_capacity%type;
begin
    -- 1. LOOP (< 20)
    dbms_output.put_line('Меньше 20: ');

    open c_aud(0, 19);
    loop
        fetch c_aud into v_aud, v_cap;
        exit when c_aud%notfound;

        dbms_output.put_line(v_aud || ' (' || v_cap || ')');
    end loop;
    close c_aud;

    -- 2. WHILE (21–30)
    dbms_output.put_line('21–30: ');

    open c_aud(21, 30);
    fetch c_aud into v_aud, v_cap;

    while c_aud%found loop
        dbms_output.put_line(v_aud || ' (' || v_cap || ')');
        fetch c_aud into v_aud, v_cap;
    end loop;
    close c_aud;

    -- 3. FOR (31–60)
    dbms_output.put_line('31–60: ');

    for rec in c_aud(31, 60) loop
        dbms_output.put_line(rec.auditorium || ' (' || rec.auditorium_capacity || ')');
    end loop;

    -- 4. FOR (61–80)
    dbms_output.put_line('61–80: ');
    for rec in c_aud(61, 80) loop
        dbms_output.put_line(rec.auditorium || ' (' || rec.auditorium_capacity || ')');
    end loop;

    -- 5. FOR (81 и выше)
    dbms_output.put_line('81 и выше: ');
    for rec in (
        select auditorium, auditorium_capacity
        from auditorium
        where auditorium_capacity >= 81
    ) loop
        dbms_output.put_line(rec.auditorium || ' (' || rec.auditorium_capacity || ')');
    end loop;

end;

-- Задание №9
declare
    type ref_cursor is ref cursor;
    rc ref_cursor;
    v_name auditorium.auditorium%type;
begin
    open rc for
        select auditorium
        from auditorium
        where auditorium_capacity > 50;
    loop
        fetch rc into v_name;
        exit when rc%notfound;
        dbms_output.put_line(v_name);
    end loop;

    close rc;
end;

-- Задание №10
declare
    cursor c_aud (min_c number, max_c number) is
        select *
        from auditorium
        where auditorium_capacity between min_c and max_c
        for update;
begin
    for rec in c_aud(40, 80) loop
        update auditorium
        set auditorium_capacity = auditorium_capacity * 0.9
        where current of c_aud;
    end loop;
    commit;
end;

select * from auditorium;