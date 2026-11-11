-- Задание №1
declare
    procedure get_teachers (pcode teacher.pulpit%type) is
        cursor c_teachers is 
            select teacher_name from teacher where pulpit = pcode;
    begin
        dbms_output.put_line('Преподаватели кафедры ' || pcode || ':');
        for rec in c_teachers loop
            dbms_output.put_line('- ' || rec.teacher_name);
        end loop;
    end get_teachers;
begin
    get_teachers('ИСиТ');
end;

-- Задание №2 
declare
    function get_num_teachers (pcode teacher.pulpit%type) return number is
        v_count number;
    begin
        select count(*) into v_count from teacher where pulpit = pcode;
        return v_count;
    end get_num_teachers;
begin
    dbms_output.put_line('Кол-во преподавателей: ' || get_num_teachers('ИСиТ'));
end;

-- Задание №3
-- Процедура по факультету
create or replace procedure get_teachers_by_faculty (fcode faculty.faculty%type) is
begin
    dbms_output.put_line('Преподаватели факультета ' || fcode || ':');
    for rec in (select t.teacher_name 
                from teacher t
                join pulpit p on t.pulpit = p.pulpit
                where p.faculty = fcode) 
    loop
        dbms_output.put_line('- ' || rec.teacher_name);
    end loop;
end;
/

-- Процедура по предметам кафедры
create or replace procedure get_subjects (pcode subject.pulpit%type) is
begin
    dbms_output.put_line('Дисциплины кафедры ' || pcode || ':');
    for rec in (select subject_name from subject where pulpit = pcode) 
    loop
        dbms_output.put_line('- ' || rec.subject_name);
    end loop;
end;
/

-- Вызов в анонимном блоке
begin
    get_teachers_by_faculty('ХТиТ');
    get_subjects('ИСиТ');
end;

-- Задание №4
create or replace function get_num_teachers_f (fcode faculty.faculty%type) return number is
    v_num number;
begin
    select count(t.teacher) into v_num
    from teacher t join pulpit p on t.pulpit = p.pulpit
    where p.faculty = fcode;
    return v_num;
end;

-- Функция: кол-во предметов на кафедре
create or replace function get_num_subjects (pcode subject.pulpit%type) return number is
    v_num number;
begin
    select count(*) into v_num from subject where pulpit = pcode;
    return v_num;
end;

begin
    dbms_output.put_line('Преподов на ХТиТ: ' || get_num_teachers_f('ХТиТ'));
    dbms_output.put_line('Предметов на ИСиТ: ' || get_num_subjects('ИСиТ'));
end;

-- Задание №5
create or replace package teachers_pkg is
    procedure get_teachers(fcode faculty.faculty%type);
    procedure get_subjects(pcode subject.pulpit%type);
    function get_num_teachers(fcode faculty.faculty%type) return number;
    function get_num_subjects(pcode subject.pulpit%type) return number;
end teachers_pkg;
/

create or replace package body teachers_pkg is

    procedure get_teachers(fcode faculty.faculty%type) is
    begin
        for rec in (select t.teacher_name from teacher t 
                    join pulpit p on t.pulpit = p.pulpit 
                    where p.faculty = fcode) loop
            dbms_output.put_line(rec.teacher_name);
        end loop;
    end;

    procedure get_subjects(pcode subject.pulpit%type) is
    begin
        for rec in (select subject_name from subject where pulpit = pcode) loop
            dbms_output.put_line(rec.subject_name);
        end loop;
    end;

    function get_num_teachers(fcode faculty.faculty%type) return number is
        v_res number;
    begin
        select count(*) into v_res from teacher t 
        join pulpit p on t.pulpit = p.pulpit where p.faculty = fcode;
        return v_res;
    end;

    function get_num_subjects(pcode subject.pulpit%type) return number is
        v_res number;
    begin
        select count(*) into v_res from subject where pulpit = pcode;
        return v_res;
    end;

end teachers_pkg;
/

create or replace package body teachers_pkg is

    procedure get_teachers(fcode faculty.faculty%type) is
    begin
        get_teachers_by_faculty(fcode); 
    end;

    procedure get_subjects(pcode subject.pulpit%type) is
    begin
        SYSS.get_subjects(pcode); 
    end;

    function get_num_teachers(fcode faculty.faculty%type) return number is
    begin
        return get_num_teachers_f(fcode);
    end;

    function get_num_subjects(pcode subject.pulpit%type) return number is
    begin
        return SYSS.get_num_subjects(pcode);
    end;

end teachers_pkg;
/

begin
    dbms_output.put_line('--- Тест пакета ---');
    dbms_output.put_line('1. Кол-во предметов на ИСиТ: ' || teachers_pkg.get_num_subjects('ИСиТ'));
    dbms_output.put_line('2. Кол-во преподавателей на ХТиТ: ' || teachers_pkg.get_num_teachers('ХТиТ'));
    
    dbms_output.put_line('---------------------------');

    dbms_output.put_line('3. Список предметов кафедры ИСиТ:');
    teachers_pkg.get_subjects('ИСиТ');
    
    dbms_output.put_line('---------------------------');

    dbms_output.put_line('4. Список преподавателей факультета ХТиТ:');
    teachers_pkg.get_teachers('ХТиТ');
    
end;
/