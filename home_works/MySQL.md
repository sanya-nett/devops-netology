## 6.3. MySQL
 
1 - Найдите команду для выдачи статуса БД 
и приведите в ответе из ее вывода версию сервера БД. 
```commandline
mysql> status
--------------
mysql  Ver 8.0.24 for Linux on x86_64 (MySQL Community Server - GPL)
```

Приведите в ответе количество записей с price > 300.
```commandline
mysql> select count(id) from orders where price>300;
+-----------+
| count(id) |
+-----------+
|         1 |
+-----------+
1 row in set (0.01 sec)
```

2 - Создайте пользователя test в БД c паролем test-pass, используя плагин авторизации mysql_native_password
```commandline
CREATE USER 'test@localhost' 
    IDENTIFIED WITH mysql_native_password BY 'test-pass' 
    PASSWORD EXPIRE INTERVAL 180 DAY 
    FAILED_LOGIN_ATTEMPTS 3 
    ATTRIBUTE '{"name": "James", "surname": "Pretty"}';
ALTER USER 'test@localhost' WITH MAX_QUERIES_PER_HOUR 100;
GRANT SELECT ON test_db.* TO 'test@localhost';
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
```commandline
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test@localhost';
+----------------+------+----------------------------------------+
| USER           | HOST | ATTRIBUTE                              |
+----------------+------+----------------------------------------+
| test@localhost | %    | {"name": "James", "surname": "Pretty"} |
+----------------+------+----------------------------------------+
1 row in set (0.01 sec)
```

3 - Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
```commandline
mysql> select table_name, engine from information_schema.tables where table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.01 sec)
```

Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
```commandline
mysql> SET profiling = 1;

mysql> alter table orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.10 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> select table_name, engine from information_schema.tables where table_schema = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | MyISAM |
+------------+--------+
1 row in set (0.00 sec)

mysql> alter table orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.07 sec)
Records: 5  Duplicates: 0  Warnings: 0


```

4 - Измените его согласно ТЗ (движок InnoDB)

```editorconfig
root@6170f1d790d6:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = 1
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 611M
innodb_log_file_size = 100M
```