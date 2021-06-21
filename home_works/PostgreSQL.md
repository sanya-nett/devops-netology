## 6.4. PostgreSQL

1) Найдите и приведите управляющие команды для:

* вывода списка БД
```commandline
\l[+]   [PATTERN]      list databases
```
* подключения к БД
```commandline
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo} 
    connect to new database (currently "admin")
```  
* вывода списка таблиц
```commandline
\dt[S+] [PATTERN]      list tables
```
* вывода описания содержимого таблиц
```commandline
\d[S+]  NAME           describe table, view, sequence, or index
```
* выхода из psql
```commandline
\q                     quit psql
```

2) Используя `psql` создайте БД `test_database`
```commandline
admin=# create database test_database;
CREATE DATABASE
```

Восстановите бэкап БД в test_database.
```commandline
root@d56ffc0a479e:/# psql -U admin -d test_database < /backup/dump.sql
```

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```commandline
admin-# \c test_database
You are now connected to database "test_database" as user "admin".
test_database=# analyze verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```

Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.
```commandline
select attname, avg_width from pg_catalog.pg_stats 
where tablename = 'orders' 
order by avg_width desc 
limit 1
> name	13
```

3) Предложите SQL-транзакцию для проведения данной операции.
```
begin;
create table public.orders_new (
	id serial NOT NULL,
	"name" varchar(50) NOT NULL,
	price numeric NOT NULL,
	constraint orders_pkey_new PRIMARY KEY (id, price)
) partition by range (price);

create table public.orders_1 partition of public.orders_new 
for values from (500) to (MAXVALUE);

create table public.orders_2 partition of public.orders_new
for values from (MINVALUE) to (499);

insert into public.orders_new (id, name, price)
select id, name, price from public.orders;

alter table public.orders rename constraint orders_pkey TO orders_pkey_backup;
alter table public.orders rename to orders_backup;
alter table public.orders_new rename constraint orders_pkey_new TO orders_pkey;
alter table public.orders_new rename to orders;

commit;
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
__Result__: возможно можно, но при использовании дополнительных приложений (из коробки нет)

4) Используя утилиту pg_dump создайте бекап БД test_database.

```commandline
docker exec -ti psql-db bash -c "pg_dump -U admin test_database > /backup/my_dump.sql"
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?  
__Result__: наверное, имелось в виду поле `name` и `surname` для таблиц.
Для диперса скорее всего сначала раскатил этот дамп где-то в защищенной среде,
прошел бы скриптом по важным таблицам и изменил реальные имена на хэш или что-то такое


