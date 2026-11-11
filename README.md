# 🗄 Oracle Database & PL/SQL — University Laboratory Archive

[![Oracle Database](https://img.shields.io/badge/Oracle_Database-19c%20%7C%2021c%20%7C%2023c-F80000?style=for-the-badge&logo=oracle&logoColor=white)](https://www.oracle.com/database/)
[![SQL](https://img.shields.io/badge/SQL-Advanced%20Queries-00758F?style=for-the-badge&logo=mysql&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![PL/SQL](https://img.shields.io/badge/Language-PL%2FSQL-blue?style=for-the-badge&logo=oracle)](https://www.oracle.com/database/technologies/appdev/plsql.html)
[![DBA](https://img.shields.io/badge/Administration-Oracle%20DBA-green?style=for-the-badge)](https://docs.oracle.com/en/database/)
[![BSTU](https://img.shields.io/badge/University-BSTU%20(БГТУ)-red?style=for-the-badge)](https://www.belstu.by/)

Комплексный архив лабораторных работ и практических заданий по дисциплинам **«Базы данных»** (3 семестр) и **«Управление данными / Администрирование Oracle»** (4 семестр), выполненных в Белорусском государственном технологическом университете (БГТУ, специальность «Информационные системы и технологии»).

Репозиторий охватывает путь от базовых реляционных выборок до углубленного администрирования экземпляра Oracle Database и программирования серверной бизнес-логики на процедурном языке **PL/SQL**.

---

## 📑 Содержание

- [3 Семестр: Реляционная модель и язык SQL](#-3-семестр-реляционная-модель-и-язык-sql)
  - [Тематический план и состав работ](#тематический-план-3-семестра)
  - [Ключевые изученные концепции SQL](#ключевые-изученные-концепции-sql)
- [4 Семестр: Администрирование Oracle и программирование на PL/SQL](#-4-семестр-администрирование-oracle-и-программирование-на-plsql)
  - [Тематический план и состав работ](#тематический-план-4-семестра)
  - [Архитектура СУБД Oracle и системное администрирование](#архитектура-субд-oracle-и-системное-администрирование)
  - [Продвинутый PL/SQL](#продвинутый-plsql)
- [Среда выполнения и используемые инструменты](#-среда-выполнения-и-используемые-инструменты)

---

## 🎓 3 Семестр: Реляционная модель и язык SQL

В рамках 3-го семестра изучаются теоретические основы проектирования реляционных баз данных, нормализация данных (1NF–3NF, BCNF) и все аспекты диалекта SQL для СУБД Oracle.

### Тематический план 3 семестра

| Каталог | Тема работы | Основные конструкции и операторы |
| :--- | :--- | :--- |
| [`lab-01-intro-ddl`](semester-3-sql-fundamentals/lab-01-intro-ddl/) | Знакомство с СУБД Oracle, DDL-скрипты | `CREATE TABLE`, `DROP TABLE`, типы данных Oracle (`VARCHAR2`, `NUMBER`, `DATE`) |
| [`lab-02-data-modeling`](semester-3-sql-fundamentals/lab-02-data-modeling/) | Проектирование схемы данных и нормализация | Сущности, атрибуты, связи 1:1, 1:M, M:N, устранение аномалий обновления |
| [`lab-03-select-filtering`](semester-3-sql-fundamentals/lab-03-select-filtering/) | Выборка и фильтрация данных | `SELECT`, `WHERE`, `AND`/`OR`/`NOT`, `BETWEEN`, `IN`, `LIKE`, `IS NULL`, `ORDER BY` |
| [`lab-04-group-by-aggregates`](semester-3-sql-fundamentals/lab-04-group-by-aggregates/) | Агрегация данных и группировка | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `GROUP BY`, фильтрация групп `HAVING` |
| [`lab-05-joins`](semester-3-sql-fundamentals/lab-05-joins/) | Соединение таблиц (Relational Joins) | `INNER JOIN`, `LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, `FULL OUTER JOIN`, `CROSS JOIN`, `SELF JOIN` |
| [`lab-06-subqueries`](semester-3-sql-fundamentals/lab-06-subqueries/) | Вложенные подзапросы (Subqueries) | Некоррелированные и коррелированные подзапросы, предикаты `EXISTS`, `NOT EXISTS`, `ALL`, `ANY` |
| [`lab-07-set-operators`](semester-3-sql-fundamentals/lab-07-set-operators/) | Теоретико-множественные операции | `UNION`, `UNION ALL`, `INTERSECT`, `MINUS` (вычитание множеств в Oracle) |
| [`lab-08-dml-operations`](semester-3-sql-fundamentals/lab-08-dml-operations/) | Модификация данных (DML) | `INSERT INTO`, `UPDATE ... SET`, `DELETE FROM`, слияние строк `MERGE INTO ... USING` |
| [`lab-09-10-views-sequences`](semester-3-sql-fundamentals/lab-09-10-views-sequences/) | Представления и генераторы последовательностей | `CREATE VIEW`, `WITH CHECK OPTION`, генераторы ключей `CREATE SEQUENCE (.NEXTVAL, .CURRVAL)` |
| [`lab-11-indexes`](semester-3-sql-fundamentals/lab-11-indexes/) | Индексирование таблиц | B-Tree индексы, `UNIQUE INDEX`, влияние селективности столбцов на выбор индекса |
| [`lab-12-transactions-isolation`](semester-3-sql-fundamentals/lab-12-transactions-isolation/) | Транзакции, блокировки и уровни изоляции | `COMMIT`, `ROLLBACK`, контрольные точки `SAVEPOINT`, тестирование блокировок строк и таблиц |
| [`lab-13-analytical-queries`](semester-3-sql-fundamentals/lab-13-analytical-queries/) | Аналитические функции и оконные операторы | `OVER (PARTITION BY ... ORDER BY ...)`, `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` |
| [`lab-14-advanced-reports`](semester-3-sql-fundamentals/lab-14-advanced-reports/) | Иерархические запросы и сложные выборки | `START WITH ... CONNECT BY PRIOR`, `SYS_CONNECT_BY_PATH`, построение древовидных отчетов |
| [`lab-15-security-privileges`](semester-3-sql-fundamentals/lab-15-security-privileges/) | Разграничение прав и пользователей | `CREATE USER`, `GRANT`, `REVOKE`, системные и объектные привилегии |
| [`lab-16-complex-queries`](semester-3-sql-fundamentals/lab-16-complex-queries/) | Комплексные сводные отчеты | Сводные группировки `ROLLUP`, `CUBE`, `GROUPING SETS` |
| [`control-work`](semester-3-sql-fundamentals/control-work/) | Итоговая контрольная работа | Комплексное решение задач по оптимизированной выборке и анализу данных |

---

## 🛠 4 Семестр: Администрирование Oracle и программирование на PL/SQL

В 4-м семестре фокус смещается на архитектуру сервера Oracle Database, физическую и логическую структуру хранения данных, многопользовательскую архитектуру (Multitenant) и процедурный язык **PL/SQL**.

### Тематический план 4 семестра

| Каталог | Тема работы | Основные концепции и системные представления |
| :--- | :--- | :--- |
| [`lab-01-integrity-constraints`](semester-4-plsql-and-dba/lab-01-integrity-constraints/) | Ограничения целостности | `PRIMARY KEY`, `FOREIGN KEY` (`ON DELETE CASCADE`), `CHECK`, `NOT NULL`, `DEFAULT` |
| [`lab-02-tablespaces-datafiles`](semester-4-plsql-and-dba/lab-02-tablespaces-datafiles/) | Табличные пространства и файлы данных | `CREATE TABLESPACE`, файлы `.dbf`, управление сегментами и экстентами, `AUTOEXTEND` |
| [`lab-04-data-dictionary`](semester-4-plsql-and-dba/lab-04-data-dictionary/) | Системный словарь данных Oracle | `DBA_TABLESPACES`, `DBA_DATA_FILES`, `DBA_SEGMENTS`, `DBA_FREE_SPACE` |
| [`lab-05-redo-logs-undo`](semester-4-plsql-and-dba/lab-05-redo-logs-undo/) | Журналы повторного выполнения и сегменты UNDO | Журналы транзакций (`v$log`, `v$logfile`), переключение групп журналов `ALTER SYSTEM SWITCH LOGFILE` |
| [`lab-06-spfile-parameters`](semester-4-plsql-and-dba/lab-06-spfile-parameters/) | Параметры экземпляра (SPFILE / PFILE) | Инициализация параметров `SHOW PARAMETER`, управление через `ALTER SYSTEM ... SCOPE=BOTH/SPFILE` |
| [`lab-07-memory-architecture`](semester-4-plsql-and-dba/lab-07-memory-architecture/) | Архитектура оперативной памяти Oracle | Общая область памяти SGA (`Buffer Cache`, `Shared Pool`, `Large Pool`) и приватная область PGA |
| [`lab-08-oracle-net-services`](semester-4-plsql-and-dba/lab-08-oracle-net-services/) | Сетевая конфигурация Oracle Net | Настройка сетевого слушателя `listener.ora`, клиентских алиасов `tnsnames.ora`, утилита `lsnrctl` |
| [`lab-09-multitenant-cdb-pdb`](semester-4-plsql-and-dba/lab-09-multitenant-cdb-pdb/) | Мультитенантная архитектура (CDB и PDB) | Корневая БД `CDB$ROOT`, подключаемые базы `PDB` (`ALTER SESSION SET CONTAINER`), сервисы PDB |
| [`lab-10-plsql-basics`](semester-4-plsql-and-dba/lab-10-plsql-basics/) | Введение в язык PL/SQL | Структура анонимного блока (`DECLARE`, `BEGIN`, `EXCEPTION`, `END;`), переменные, циклы `WHILE`, `FOR` |
| [`lab-11-plsql-cursors`](semester-4-plsql-and-dba/lab-11-plsql-cursors/) | Курсоры в PL/SQL | Явные и неявные курсоры, циклы по курсору `FOR rec IN c_cursor`, атрибуты `%FOUND`, `%ROWCOUNT` |
| [`lab-12-plsql-exceptions`](semester-4-plsql-and-dba/lab-12-plsql-exceptions/) | Механизм обработки исключений | Системные ошибки (`NO_DATA_FOUND`, `TOO_MANY_ROWS`), пользовательские исключения, `RAISE_APPLICATION_ERROR` |
| [`lab-13-plsql-packages`](semester-4-plsql-and-dba/lab-13-plsql-packages/) | Хранимые процедуры, функции и пакеты | Спецификация (`PACKAGE`) и тело пакета (`PACKAGE BODY`), сокрытие реализации, перегрузка подпрограмм |
| [`lab-14-database-triggers`](semester-4-plsql-and-dba/lab-14-database-triggers/) | Триггеры базы данных | Триггеры уровня строки (`FOR EACH ROW`, псевдозаписи `:NEW` и `:OLD`), уровня оператора, аудит и валидация |
| [`lab-15-table-partitioning`](semester-4-plsql-and-dba/lab-15-table-partitioning/) | Секционирование больших таблиц | Диапазонное секционирование (`PARTITION BY RANGE`), секционирование по спискам (`LIST`) и хеш-ключам (`HASH`) |

---

## 💻 Среда выполнения и используемые инструменты

- **СУБД:** Oracle Database 19c Enterprise Edition / Oracle Database 21c / 23c Free Developer Release.
- **Инструменты администрирования и разработки:**
  - **Oracle SQL Developer** — визуальная среда разработки, построение планов запросов, профилирование.
  - **DBeaver Universal Database Tool** — подключение по JDBC.
  - **SQL*Plus** — терминальная утилита командной строки для администрирования экземпляра.
  - **Oracle Recovery Manager (RMAN)** — утилита резервного копирования.

---

## 👩‍💻 Автор

**Юлия (Yuliya)**  
- Студентка Белорусского государственного технологического университета (БГТУ)  
- Специализация: Databases (Oracle, PL/SQL, SQL), Frontend Development & UI/UX  
- GitHub: [@yk-jivi](https://github.com/yk-jivi)
