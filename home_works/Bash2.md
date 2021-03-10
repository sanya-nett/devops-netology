## 4.2. Использование Python для решения типовых DevOps задач
 
1 - Есть скрипт:  
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```
__Result__: Какое значение будет присвоено переменной c? - никакое, `TypeError: unsupported operand type(s)`  
Как получить для переменной c значение 12? если имеется в виду число, а не строка, то `int(str(a) + b)`   
Как получить для переменной c значение 3? здесь просто: `a + int(b)`
 

2 - Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий 
узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно 
начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, 
где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?:  
__Result__: 
```python
#!/usr/bin/env python3
import os

project_path = "~/netology/sysadm-homeworks"
bash_command = [
    "cd", project_path,
    "&&",
    "git", "ls-files", "-m",
]
result_os = os.popen(" ".join(bash_command)).read()
if not len(result_os): 
    exit(0)
for result in result_os.strip().split('\n'):
    print(os.path.join(
        os.path.expanduser(project_path),
        result,
    ))

``` 

3 - Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, 
а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, 
что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются 
локальными репозиториями.  
__Result__: 
```python
#!/usr/bin/env python3
import os
import sys

assert len(sys.argv) == 2, "It must be passed only one argument: path of git repository"
project_path = os.path.expanduser(sys.argv[1])
assert os.path.exists(project_path), "No such directory"
assert os.path.exists(os.path.join(project_path, ".git")), "Missing hidden directory '.git'"
bash_command = [
    "cd", project_path,
    "&&",
    "git", "ls-files", "-m",
]
result_os = os.popen(" ".join(bash_command)).read()
if not len(result_os):
    exit(0)
for result in result_os.strip().split('\n'):
    print(os.path.join(
        project_path,
        result,
    ))

```

4 - Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде 
нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 
Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP 
меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, 
если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 
Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в 
виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из 
предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: 
[ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: 
drive.google.com, mail.google.com, google.com.  
__Result__: 
```python
#!/usr/bin/env python3
import logging
import socket
import time

logging.basicConfig(level=logging.DEBUG)
hosts = [
    "drive.google.com",
    "mail.google.com",
    "google.com",
]
ip_storage = {host: [socket.gethostbyname(host)] for host in hosts}


def check_host_ip(host: str):
    ip_addr = socket.gethostbyname(host)
    host_data = dict(host=host, ip_new=ip_addr, ip_storage=ip_storage[host])
    logging.debug("{host} IP address: {ip_new}. Storage: {ip_storage}".format(**host_data))
    if ip_addr not in ip_storage[host]:
        logging.error("{host} IP mismatch: {ip_new} not in local storage {ip_storage}".format(**host_data))
        ip_storage[host].append(ip_addr)


if __name__ == '__main__':
    while True:
        [check_host_ip(host) for host in hosts]
        time.sleep(1)

```