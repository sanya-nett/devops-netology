## 6.4. PostgreSQL

1 - Найдите и приведите управляющие команды для:

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

2 - Используя `psql` создайте БД `test_database`
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