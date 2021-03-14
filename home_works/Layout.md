## 4.3. Языки разметки JSON и YAML
 
1 - Исправленный __JSON__ файл (не хватало кавычек для ключа и значения ip):
```json
{
  "info": "Sample JSON output from our service\t",
  "elements": [
    {
      "name": "first",
      "type": "server",
      "ip": 7175
    },
    {
      "name": "second",
      "type": "proxy",
      "ip": "71.78.22.43"
    }
  ]
}
```  


2 - В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже 
реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат 
записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его 
IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.  
__Result__: Для приведения формата вывода как в задании, написал _special_file_format_ функцию. Плюс из описания задания
понял, что файл нужно переписывать, а не дополнять.
```python
#!/usr/bin/env python3
import json
import logging
import socket
import time

import yaml

logging.basicConfig(level=logging.DEBUG)
hosts = [
    "drive.google.com",
    "mail.google.com",
    "google.com",
]
ip_storage = {host: socket.gethostbyname(host) for host in hosts}
special_file_format = lambda data: [{key: value} for key, value in data.items()]


def save_json(filename: str = 'hosts.json'):
    with open(filename, 'w') as file:
        json.dump(special_file_format(ip_storage), file, indent=2)


def save_yaml(filename: str = 'hosts.yaml'):
    with open(filename, 'w') as file:
        yaml.dump(special_file_format(ip_storage), file, explicit_start=True, indent=2)


def check_host_ip(host: str):
    ip_addr = socket.gethostbyname(host)
    host_data = dict(host=host, ip_new=ip_addr, ip_storage=ip_storage[host])
    logging.debug("{host} IP address: {ip_new}. Storage: {ip_storage}".format(**host_data))
    if ip_addr not in ip_storage[host]:
        logging.error("{host} IP mismatch: {ip_new} not in local storage {ip_storage}".format(**host_data))
        ip_storage[host] = ip_addr


if __name__ == '__main__':
    while True:
        [check_host_ip(host) for host in hosts]
        save_json(), save_yaml()
        time.sleep(1)
```
