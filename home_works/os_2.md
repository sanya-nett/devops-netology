## 4.1. Операционные системы, лекция 2
 
#### Настройка Node Exporter сервиса

Описания файла с параметрами запуска экспортера: `/etc/default/node_exporter`
```bash
# Collectors are enabled by providing a --collector.<name> flag.
# Collectors that are enabled by default can be disabled by providing a --no-collector.<name> flag.
# To enable only some specific collector(s), use --collector.disable-defaults --collector.<name> ....
EXPORTER_OPTS=--collector.disable-defaults --collector.cpu --collector.meminfo --collector.time
```

Описание unit файла: `/etc/systemd/system/node_exporter.service`
```bash
[Unit]
Description=Node Exporter Service
After=network.target

[Service]
Type=simple
User=node_exporter
Group=node_exporter

EnvironmentFile=/etc/default/node_exporter
ExecStart=/usr/local/bin/node_exporter ${EXPORTER_OPTS}

SyslogIdentifier=node_exporter
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Список действий:
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.1/node_exporter-1.1.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.1.1.linux-amd64.tar.gz
cd node_exporter-*
sudo -s
cp node_exporter /usr/local/bin
useradd --no-create-home --home-dir / --shell /bin/false node_exporter
vi /etc/systemd/system/node_exporter.service
systemctl start node_exporter
systemctl enable node_exporter
```

#### Опции для базового мониторинга хоста по CPU, памяти, диску и сети.
`--collector.disable-defaults --collector.cpu --collector.meminfo --collector.diskstats --collector.netstat --collector.time`


- Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?  
Можно, `[  +0.000002] CPU MTRRs all blank - virtualized system.`

- Как настроен sysctl fs.nr_open на системе по-умолчанию?  
Это системное ограничение на кол-во открытых файлов, по умолчанию там: `1048576`  
__Max number of file handles a process can allocate__
`max user processes              (-u) 3580` не позволит открыть больше процессов

- Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) 
в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter.
```bash
sudo -i
unshare -f --pid --mount-proc top
```

В другой сессии:
```bash
pstree -p | grep top
sudo nsenter -t 1451 --pid --mount

root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.3  11712  3684 pts/0    S+   20:15   0:00 top
root           2  0.0  0.4   9836  4024 pts/1    S    20:15   0:00 -bash
root          11  0.0  0.3  11492  3396 pts/1    R+   20:16   0:00 ps aux
```

- Найдите информацию о том, что такое :(){ :|:& };: - это форк бомба, которая порождает процессы в геометрической прогрессии


```bash
vagrant@vagrant:~$ dmesg -H
[Feb20 20:18] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-7.scope
```


- как изменить число процессов, которое можно создать в сессии
В файле добавить лимиты для пользователя: `/etc/security/limits.conf`
```bash
vagrant  soft nproc     16384
vagrant  hard nproc     16384
```
либо добавить в `/.bash_profile`