# ДЗ 6.5. Elasticsearch

1) Первоначальное конфигурирование elastcisearch

Docker manifest:
```dockerfile
FROM centos:7

LABEL maintainer="scherba.alexander@gmail.com" \
      description="Elasticsearch custom application" \
      version="0.2-snapshot"

ENV VERSION=7.13.2

EXPOSE 9200/tcp 9300/tcp

RUN yum -y upgrade \
 && yum -y install wget initscripts \
 && yum clean all \
 && rm -rf /var/cache/yum

RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
 && yum -y install perl-Digest-SHA-5.85-4.el7.x86_64.rpm \
 && yum clean all \
 && rm -rf /var/cache/yum

WORKDIR /usr/share/

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-linux-x86_64.tar.gz \
 && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${VERSION}-linux-x86_64.tar.gz.sha512 \
 && shasum -a 512 -c elasticsearch-${VERSION}-linux-x86_64.tar.gz.sha512 \
 && tar -xzf elasticsearch-${VERSION}-linux-x86_64.tar.gz

COPY config/* elasticsearch-${VERSION}/config/

RUN useradd -ms /bin/bash elastic \
 && chown -R elastic: elasticsearch-${VERSION}

USER elastic
WORKDIR /usr/share/elasticsearch-${VERSION}
CMD ./bin/elasticsearch

```
[Cсылка](https://hub.docker.com/repository/docker/ascherba/centos-7-elasticsearch) на образ в репозитории dockerhub

Ответ elasticsearch на запрос пути / в json виде
```commandline
# ascherba@~/Docker/centos_eleasticsearch$ docker run -d --rm -p 9200:9200 --name=elastic  ascherba/centos-7-elasticsearch:latest
7b0d3024fca84c9d84fb902816a225925df6b57eaf982e203a2e3771018b1229
# ascherba@~/Docker/centos_eleasticsearch$ curl localhost:9200/
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "_na_",
  "version" : {
    "number" : "7.13.2",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "4d960a0733be83dd2543ca018aa4ddc42e956800",
    "build_date" : "2021-06-10T21:01:55.251515791Z",
    "build_snapshot" : false,
    "lucene_version" : "8.8.2",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

2) Индексы

Получите список индексов и их статусов, используя API и приведите в ответе на задание.
```commandline
# ascherba@~$ curl -X GET "localhost:9200/_cat/indices?pretty"
green  open ind-1 OFy8FpBeTwKi8WLOrEV3mg 1 0 0 0 208b 208b
yellow open ind-3 S7xr6wYYTjOEYW8VvGQl-A 4 2 0 0 832b 832b
yellow open ind-2 hWsTMWzFSMOpHdZmNkTCig 2 1 0 0 416b 416b
```

Получите состояние кластера elasticsearch, используя API
```commandline
# ascherba@~$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 7,
  "active_shards" : 7,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 41.17647058823529
}
```

Кластер желтый так как есть много unassigned_shards и они не смогли запуститься

3) Snapshots

Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
Приведите в ответе запрос API и результат вызова API для создания репозитория.
```commandline
# ascherba@~$ curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "snapshots"
  }
}
'
{
  "acknowledged" : true
}
```

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```commandline
# ascherba@~$ curl -X GET "localhost:9200/_cat/indices?pretty"
green open test ivoUvyYhR5a47Uj1kGfqWg 1 0 0 0 208b 208b
```

Приведите в ответе список файлов в директории со snapshotами.
```commandline
# ascherba@~$ docker exec -ti elastic bash -c "ls -la snapshots/snapshots"
total 52
drwxr-xr-x 3 elastic elastic  4096 Jun 19 19:57 .
drwxr-xr-x 3 elastic elastic  4096 Jun 19 19:55 ..
-rw-r--r-- 1 elastic elastic   505 Jun 19 19:57 index-0
-rw-r--r-- 1 elastic elastic     8 Jun 19 19:57 index.latest
drwxr-xr-x 3 elastic elastic  4096 Jun 19 19:57 indices
-rw-r--r-- 1 elastic elastic 25607 Jun 19 19:57 meta-WEJ2EmpYSMuxtMgNh7P1LA.dat
-rw-r--r-- 1 elastic elastic   360 Jun 19 19:57 snap-WEJ2EmpYSMuxtMgNh7P1LA.dat
```

Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
```commandline
# ascherba@~$ curl -v -X GET "localhost:9200/_cat/indices?pretty"
Note: Unnecessary use of -X or --request, GET is already inferred.
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9200 (#0)
> GET /_cat/indices?pretty HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Warning: 299 Elasticsearch-7.13.2-4d960a0733be83dd2543ca018aa4ddc42e956800 "Elasticsearch built-in security features are not enabled. Without authentication, your cluster could be accessible to anyone. See https://www.elastic.co/guide/en/elasticsearch/reference/7.13/security-minimal-setup.html to enable security."
< content-type: text/plain; charset=UTF-8
< content-length: 0
<
* Connection #0 to host localhost left intact
```

Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
Приведите в ответе запрос к API восстановления и итоговый список индексов.
```commandline
# ascherba@~$ curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot_1/_restore?pretty"
{
  "accepted" : true
}
# ascherba@~$ curl -X GET "localhost:9200/_cat/indices?pretty"
green open test uV-Zkv7SR0uNIan3NhT5OQ 1 0 0 0 208b 208b
```