-- Задание №1
create table t_range (
    id number,
    name varchar2(50),
    amount number
)
partition by range (amount) (
    partition p_low values less than (1000),
    partition p_medium values less than (5000),
    partition p_high values less than (10000),
    partition p_max values less than (maxvalue)
);

-- Задание №2
create table t_interval (
    id number,
    event_date date,
    description varchar2(100)
)
partition by range (event_date) 
interval (numtoyminterval(1, 'MONTH')) (
    partition p_start values less than (to_date('01-01-2026', 'DD-MM-YYYY'))
);

-- Задание №3
create table t_hash (
    sku_code varchar2(20),
    product_name varchar2(100),
    quantity number
)
partition by hash (sku_code) partitions 4;
    
-- Задание №4
create table t_list (
    id number,
    country_code char(2),
    city_name varchar2(50)
)
partition by list (country_code) (
    partition p_cis values ('RU', 'BY', 'KZ'),
    partition p_eu values ('FR', 'DE', 'IT'),
    partition p_asia values ('CN', 'JP', 'KR'),
    partition p_others values (default)
);

-- Задание №5
-- Вставка в таблицу T_RANGE
insert into t_range values (1, 'Товар А', 500);   -- в p_low
insert into t_range values (2, 'Товар Б', 2500);  -- в p_medium 
insert into t_range values (3, 'Товар В', 7500);  -- в p_high
insert into t_range values (4, 'Товар Г', 12000); -- в p_max
commit;

-- Вставка в таблицу T_INTERVAL
insert into t_interval values (10, to_date('15-12-2025', 'DD-MM-YYYY'), 'Архив 2025'); -- в p_start
insert into t_interval values (20, to_date('10-02-2026', 'DD-MM-YYYY'), 'Февраль 2026'); -- авто-секция 1
insert into t_interval values (30, to_date('22-05-2026', 'DD-MM-YYYY'), 'Май 2026');
commit;

-- Вставка в таблицу T_HASH
insert into t_hash values ('A100', 'Монитор', 10);
insert into t_hash values ('B250', 'Клавиатура', 50);
insert into t_hash values ('C380', 'Мышь', 100);
insert into t_hash values ('D990', 'Ноутбук', 5);
commit;

-- Вставка в таблицу T_LIST
insert into t_list values (100, 'RU', 'Москва');   -- в p_cis
insert into t_list values (200, 'FR', 'Париж');    -- в p_eu
insert into t_list values (300, 'CN', 'Пекин');    -- в p_asia
insert into t_list values (400, 'US', 'Нью-Йорк'); -- в p_others
commit;

-- Демонстрация
-- T_RANGE
select 'p_low' as sector_name, id, name, amount from t_range partition (p_low) 
union all
select 'p_medium', id, name, amount from t_range partition (p_medium) 
union all
select 'p_high', id, name, amount from t_range partition (p_high) 
union all
select 'p_max', id, name, amount from t_range partition (p_max);

-- T_INTERVAL
select 'p_start' as sector_name, id, event_date, description from t_interval partition (p_start)
union all
select 'Auto-Section (Feb 2026)', id, event_date, description from t_interval partition for (to_date('10-02-2026', 'DD-MM-YYYY'))
union all
select 'Auto-Section (May 2026)', id, event_date, description from t_interval partition for (to_date('22-05-2026', 'DD-MM-YYYY'));

-- T_HASH
-- Имя секций, т.к. Oracle их автоматически создаёт
select partition_name from user_tab_partitions where table_name = 'T_HASH';

select 'Section 1' as sector_name, sku_code, product_name, quantity from t_hash partition (SYS_P1106) 
union all
select 'Section 2', sku_code, product_name, quantity from t_hash partition (SYS_P1107) 
union all
select 'Section 3', sku_code, product_name, quantity from t_hash partition (SYS_P1108) 
union all
select 'Section 4', sku_code, product_name, quantity from t_hash partition (SYS_P1109);

-- T_LIST
select 'p_cis' as sector_name, id, country_code, city_name from t_list partition (p_cis) 
union all
select 'p_eu', id, country_code, city_name from t_list partition (p_eu) 
union all
select 'p_asia', id, country_code, city_name from t_list partition (p_asia) 
union all
select 'p_others', id, country_code, city_name from t_list partition (p_others);

-- Задание №6 
-- Разрешение перемещения строк для всех таблиц
alter table t_range enable row movement;
alter table t_interval enable row movement;
alter table t_hash enable row movement;
alter table t_list enable row movement;


-- Выполнение при сдаче


-- Выполнение UPDATE ключей секционирования
update t_range set amount = 9000 where id = 2;       -- улетает из p_medium в p_high
update t_interval set event_date = to_date('14-12-2025', 'DD-MM-YYYY') where id = 20; -- улетает из авто-секции в p_start
update t_hash set sku_code = 'Z999' where quantity = 100; -- хэш пересчитается, строка сменит секцию
update t_list set country_code = 'DE' where id = 100; -- улетает из p_cis в p_eu (Германия)
commit;

-- Задание №7
alter table t_range merge partitions p_low, p_medium into partition p_merged_low_med;

select 'p_merged_low_med' as sector_name, id, name, amount from t_range partition (p_merged_low_med); 

-- Задание №8
alter table t_range split partition p_high at (7500) 
into (partition p_high_low, partition p_high_top);

select 'p_high_low' as sector_name, id, name, amount from t_range partition (p_high_low); 
select 'p_high_top' as sector_name, id, name, amount from t_range partition (p_high_top); 

-- Задание №9
create table t_list_exchange_buffer (
    id number,
    country_code char(2),
    city_name varchar2(50)
);

insert into t_list_exchange_buffer values (555, 'JP', 'Токио');
commit;

alter table t_list exchange partition p_asia with table t_list_exchange_buffer;

select 'p_asia', id, country_code, city_name from t_list partition (p_asia);

select * from t_list_exchange_buffer;

-- Задание №10
-- 1
select table_name, partitioning_type, partition_count 
from user_part_tables;

-- 2
select partition_name, high_value, partition_position 
from user_tab_partitions 
where table_name = 'T_LIST'
order by partition_position;

-- 3
select * from t_list partition (p_eu);

-- 4
select * from t_list partition for ('DE');






-- Удаление всех таблиц
drop table t_range cascade constraints;
drop table t_interval cascade constraints;
drop table t_hash cascade constraints;
drop table t_list cascade constraints;

drop table t_list_exchange_buffer cascade constraints;