
--Задание №1
begin
    null;
end;

--Задание №2
begin
    dbms_output.put_line('Hello World!');
end;

--Задание №3 (sqplus)
select keyword from v_$reserved_words where length = 1 and keyword != 'A';

--Задание №4 (sqlplus)
select keyword from v$reserved_words where reserved = 'Y';

begin
    for r in (select keyword from v$reserved_words where length = 1 and keyword != 'A')
    loop
        dbms_output.put_line('Символ: ' || r.keyword);
    end loop;

    for r in (select keyword from v$reserved_words where reserved = 'Y' and length > 1)
    loop
        dbms_output.put_line('Ключевое слово: ' || r.keyword);
    end loop;
exception
    when others then
        if sqlcode = -942 then
            dbms_output.put_line('Ошибка: У вас нет прав на чтение таблицы V$RESERVED_WORDS');
        else
            dbms_output.put_line('Ошибка: ' || sqlerrm);
        end if;
end;


--Задание №5
declare
    a number := 1;
    b number(2) := 18;
    c number;
    d number(5,2) := 18.18;
    e number(5,-1) := 123;
    f number := 1e3;
    dt date := sysdate;
    str varchar2(20) := 'Yuliya';
    flag boolean := true;
begin
    c := a + b;
    dbms_output.put_line('Сумма: ' || c);
    dbms_output.put_line('Деление: ' || a/b);
    dbms_output.put_line('Остаток: ' || mod(a,b));
    dbms_output.put_line('Дата: ' || dt);
    dbms_output.put_line(str);
end;

--Задание №6
declare
  v_const constant number := 10;
  v_str constant varchar2(10) := 'ABC';
begin
    v_const := 11;
exception
    when others
        then dbms_output.put_line('error = ' || v_const);
end;

--Задание №7-8
declare
    subject syss.subject.subject%type;
    pulpit syss.pulpit.pulpit%type;
    faculty_rec syss.faculty%rowtype;
begin
    subject := 'ПИС';
    pulpit := 'ИСиТ';
    faculty_rec.faculty := 'ИДиП';
    faculty_rec.faculty_name := 'Факультет издательского дела и полиграфии';
    dbms_output.put_line(subject);
    dbms_output.put_line(pulpit);
    dbms_output. put_line(rtrim(faculty_rec.faculty) || ':' || faculty_rec.faculty_name);
exception
    when others
     then dbms_output.put_line('error = '|| sqlerrm);
end;

--Задание №9
declare
    x pls_integer := 17;
begin
    if 8 > x
    then
        dbms_output.put_line('8 > '|| x);
    end if;

    if 8 > x
    then
        dbms_output.put_line( '8 > ' || x);
        
    else
        dbms_output.put_line('8 <= ' || x);
    end if;

    if 8 > x
    then
        dbms_output.put_line('8 > ' || x);
    elsif 8 = x
    then
        dbms_output.put_line('8 = ' || x) ;
    elsif 12 > x
    then
        dbms_output.put_line('12 > ' || x);
    elsif 12 = x
    then
        dbms_output.put_line('12 = ' || x) ;
    else
        dbms_output.put_line('12 < ' || x);
    end if;
end;

--Задание №10
declare
    x pls_integer := 17;
begin
    case x
        when 1 then dbms_output. put_line('l');
        when 2 then dbms_output. put_line('2');
        when 3 then dbms_output. put_line('3');
        else dbms_output. put_line('else');
    end case;
    case
        when 8 > x then dbms_output.put_line('8 > ' || x);
        when 8 = x then dbms_output.put_line('8 = ' || x);
        when 12 = x then dbms_output.put_line( '12 = ' || x) ;
        when x between 13 and 20 then dbms_output.put_line('13 <= ' || x || ' <= 20');
        else dbms_output.put_line('else');
    end case;
end;
    
--Задание №11-13
declare
    x pls_integer := 0;
begin
    loop
        x := x + 1;
        dbms_output.put_line(x);
    exit when x > 5;
    end loop;
    
    for k in 1..5
    loop
        dbms_output.put_line(k);
    end loop;
    
    while(x > 0)
    loop
        x := x - 1;
        dbms_output.put_line(x);
    end loop;
end;