create table SYS_t
(
    id number(3) constraint PK_SYS_t primary key,
    name varchar(50)
);

insert into SYS_t values (1, 'Музыка');
insert into SYS_t values (2, 'Книги');
insert into SYS_t values (3, 'Спорт');
commit;

update SYS_t set name = 'Сон' where id = 1;
update SYS_t set name = 'Дом' where id = 2;
commit;

select * from SYS_t where id > 2;

select count(*) as Количество_строк,
        max(id) as Максимальный_ID,
        min(id) as Минимальный_ID
from SYS_t;
    
delete from SYS_t where id = 1;
rollback;

create table SYS_t_child
(
    child_id number(3) constraint PK_SYS_t_child primary key,
    parent_id number(3),
    description varchar2(50),
    constraint FK_SYS_t_child foreign key(parent_id)
    references SYS_t(id)
);

insert into SYS_t_child values (1, 1, 'Книги');
insert into SYS_t_child values (2, 2, 'Музыка');
insert into SYS_t_child values (3, 3, 'Душа');
commit;

select p.id, c.description
from SYS_t p join SYS_t_child c
On p.id = c.parent_id;

select p.id, c.description
from SYS_t p left join SYS_t_child c
On p.id = c.parent_id;

drop table SYS_t_child;
drop table SYS_t;