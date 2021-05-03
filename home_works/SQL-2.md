## 6.2. SQL
 
1 - Manifest of docker-compose.yml:  
```yaml
version: '3.1'
services:
  postgres:
    image: postgres:12
    container_name: psql-db
    volumes:
      - ./psql-backup:/backup
      - ./psql-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
    ports:
      - 5432:5432
  postgres2:
    image: postgres:12
    container_name: psql-db2
    volumes:
      - ./psql-backup:/backup
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
    ports:
      - 5432:5432
```

2 - итоговый список БД после выполнения 
```commandline
test_db=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)
```
Описание таблиц (использовал psql синтаксис для лучшего представления):
```commandline
test_db=# \d orders;
                                   Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default
--------+-----------------------+-----------+----------+------------------------------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass)
 name   | character varying(50) |           | not null |
 price  | numeric               |           | not null |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)

test_db=# \d clients;
                                    Table "public.clients"
  Column  |         Type          | Collation | Nullable |               Default
----------+-----------------------+-----------+----------+-------------------------------------
 id       | integer               |           | not null | nextval('clients_id_seq'::regclass)
 surname  | character varying(50) |           | not null |
 country  | character varying(50) |           | not null |
 order_id | integer               |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country_idx" btree (country)
```

SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```commandline
select distinct grantee 
from information_schema.table_privileges 
where table_catalog = 'test_db'

>> PUBLIC
>> admin
>> test-admin-user
>> test-simple-user
```
Список пользователей с правами над таблицами test_db
```commandline
select distinct grantee, privilege_type 
from information_schema.table_privileges 
where table_catalog = 'test_db'

>> PUBLIC	SELECT
>> PUBLIC	UPDATE
>> admin	DELETE
>> admin	INSERT
>> admin	REFERENCES
>> admin	SELECT
>> admin	TRIGGER
>> admin	TRUNCATE
>> admin	UPDATE
>> test-admin-user	DELETE
>> test-admin-user	INSERT
>> test-admin-user	REFERENCES
>> test-admin-user	SELECT
>> test-admin-user	TRIGGER
>> test-admin-user	TRUNCATE
>> test-admin-user	UPDATE
>> test-simple-user	DELETE
>> test-simple-user	INSERT
>> test-simple-user	SELECT
>> test-simple-user	UPDATE
```

Используя foreign keys свяжите записи из таблиц
```commandline
alter table clients add constraint clients_fk foreign key (id) references orders(id)

update clients 
set order_id = (select id from orders where "name" = 'Книга') 
where surname = 'Иванов Иван Иванович'

update clients 
set order_id = (select id from orders where "name" = 'Монитор') 
where surname = 'Петров Петр Петрович'

update clients 
set order_id = (select id from orders where "name" = 'Гитара') 
where surname = 'Иоганн Себастьян Бах'
```

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса
```commandline
select id, surname 
from clients 
where order_id  is not null

>> 1	Иванов Иван Иванович
>> 2	Петров Петр Петрович
>> 3	Иоганн Себастьян Бах 
```

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN)
```commandline
explain verbose select id, surname from clients where order_id  is not null 

>> Seq Scan on public.clients  (cost=0.00..13.00 rows=298 width=122)
  Output: id, surname
  Filter: (clients.order_id IS NOT NULL)
```
Данный запрос показывает, что:
* поиск проходил только внутри таблицы __public.clients__
* приблизительаня и общая стоимость запуска запроса, ожидаемое число строк и средний размер строк (в байтах)
* вернуло значения полей __id, surname__
* фильтрация по полю __clients.order_id__ (проверка, что оно не пустой)

Приведите список операций, который вы применяли для бэкапа данных и восстановления.
```commandline
docker exec -ti psql-db bash -c 'pg_dumpall -U admin > /backup/all.sql'
docker stop psql-db
docker-compose up -d postgres2
docker exec -ti psql-db2 bash -c 'psql -U admin < /backup/all.sql'
```
Я сделал полный бэкап данных, так как при дампе одной таблице появляется 
следующая проблема. При восстановлении таблицы на нулевой постгри там нету наших пользователей,
которым нужно привилегии установить
