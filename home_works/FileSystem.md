## 3.5. Файловые системы
 
1 - Узнайте о __sparse__ (разряженных) файлах  
__Result__: Файлы, которые занимают меньше физического места, 
так как вместо нулевых битов хранится информация об их кол-ве

2 - Могут ли файлы, являющиеся жесткой ссылкой на один объект, 
иметь разные права доступа и владельца? Почему?  
__Result__: Не могут, так как жесткая ссылка не создает новый объект,
а значит они имеют одинаковую метаинформацию, в том числе и владельца и
права доступа

4 - Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство  
__Result__:
```
root@vagrant:/home/vagrant/temp# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
```

5 - Используя sfdisk, перенесите данную таблицу разделов на второй диск  
__Result__: `sfdisk -d /dev/sdb | sfdisk /dev/sdc`
```
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm  /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm  [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
└─sdc2                 8:34   0  511M  0 part
```

6 - Соберите mdadm RAID1 на паре разделов 2 Гб  
__Result__: `mdadm --create --verbose /dev/md0 -l 1 -n 2 /dev/sd{b,c}1`
```
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
```

7 - Соберите mdadm RAID0 на второй паре маленьких разделов  
__Result__: `mdadm --create --verbose /dev/md1 -l 0 -n 2 /dev/sd{b,c}2`
```
root@vagrant:~# lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
```

8 - Создайте 2 независимых PV на получившихся md-устройствах  
__Result__: `pvcreate /dev/md{0,1}`
```
root@vagrant:~# pvdisplay /dev/md{0,1}
  "/dev/md0" is a new physical volume of "<2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/md0
  VG Name
  PV Size               <2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               Cb0H3I-Kvez-oMbg-mc0E-TaDc-Ugqq-sUMGt4

  "/dev/md1" is a new physical volume of "1018.00 MiB"
  --- NEW Physical volume ---
  PV Name               /dev/md1
  VG Name
  PV Size               1018.00 MiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               euLTzu-p0vj-NM66-2Hfz-tLIN-TUa1-thyk0B
```

9 - Создайте общую volume-group на этих двух PV  
__Result__: `vgcreate "MyVolumeGroup" /dev//md{0,1}`
```
root@vagrant:~# pvdisplay /dev/md{0,1} | grep "VG Name"
  VG Name               MyVolumeGroup
  VG Name               MyVolumeGroup
```

10 - Создайте LV размером 100 Мб, указав его расположение на PV с RAID0  
__Result__: `lvcreate -L 100M MyVolumeGroup /dev/md1`
```
root@vagrant:~# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0  512M  0 part  /boot/efi
├─sda2                      8:2    0    1K  0 part
└─sda5                      8:5    0 63.5G  0 part
  ├─vgvagrant-root        253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1      253:1    0  980M  0 lvm   [SWAP]
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm
```

11 - Создайте mkfs.ext4 ФС на получившемся LV  
__Result__: `mkfs -t ext4 /dev/MyVolumeGroup/lvol0`

12 - Смонтируйте этот раздел в любую директорию, например, `/tmp/new`  
__Result__: `mkdir /tmp/new && mount /dev/MyVolumeGroup/lvol0 /tmp/new`
```
root@vagrant:/tmp/new# lsblk | grep MyVolumeGroup-lvol0
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm   /tmp/new
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm   /tmp/new
```

14 - Прикрепите вывод lsblk.  
__Result__:
```
root@vagrant:/tmp/new# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0  512M  0 part  /boot/efi
├─sda2                      8:2    0    1K  0 part
└─sda5                      8:5    0 63.5G  0 part
  ├─vgvagrant-root        253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1      253:1    0  980M  0 lvm   [SWAP]
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdb2                      8:18   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm   /tmp/new
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md0                     9:0    0    2G  0 raid1
└─sdc2                      8:34   0  511M  0 part
  └─md1                     9:1    0 1018M  0 raid0
    └─MyVolumeGroup-lvol0 253:2    0  100M  0 lvm   /tmp/new
```

16 - Используя `pvmove`, переместите содержимое PV с RAID0 на RAID1  
__Result__: 
```
root@vagrant:/tmp/new# pvmove -i1 /dev/md1 /dev/md0
  /dev/md1: Moved: 24.00%
  /dev/md1: Moved: 100.00%
```

17 - Сделайте --fail на устройство в вашем RAID1 md  
__Result__: `mdadm --fail /dev/md0 /dev/sdc1`

18 - Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии  
__Result__:
```
root@vagrant:/tmp/new# dmesg | grep :md0
[  540.440914] md/raid1:md0: not clean -- starting background reconstruction
[  540.440915] md/raid1:md0: active with 2 out of 2 mirrors
[ 3602.136120] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```