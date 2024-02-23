# Partie 1 : Partitionnement du serveur de stockage

🌞 Partitionner le disque à l'aide de LVM

créer un physical volume (PV) 
```     
[tom@storage ~]$  sudo pvcreate /dev/sdb |  sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
  Physical volume "/dev/sdc" successfully created.


  [tom@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB56d6c0e2-cf9f298e PVID 6l8etdFML3nsCq2sC0RlQjbgMBB2cHYY last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
  /dev/sdc      lvm2 ---  2.00g 2.00g
```

créer un nouveau volume group (VG)
```
[tom@storage ~]$ sudo vgcreate storage /dev/sdb
[tom@storage ~]$ sudo vgextend storage /dev/sdc
 Volume group "storage" successfully extended

[tom@storage ~]$  sudo vgs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB56d6c0e2-cf9f298e PVID 6l8etdFML3nsCq2sC0RlQjbgMBB2cHYY last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g

```
créer un nouveau logical volume (LV) : ce sera la partition utilisable
```
[tom@storage ~]$ sudo lvcreate -l 100%FREE storage -n ma_storage
[sudo] password for tom:
  Logical volume "ma_storage" created.
[tom@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VB56d6c0e2-cf9f298e PVID 6l8etdFML3nsCq2sC0RlQjbgMBB2cHYY last seen on /dev/sda2 not found.
  LV         VG      Attr       LSize Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ma_storage storage -wi-a----- 3.99g

```

🌞 Formater la partition    
```
[tom@storage ~]$ sudo mkfs.ext3 /dev/storage/ma_storage
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 49f24165-284b-44b3-8f2b-5580dfe6ef0a
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```

🌞 Monter la partition
```
[tom@storage ~]$ sudo mkdir /mnt/data
[sudo] password for tom:
[tom@storage ~]$ sudo mount /dev/storage/ma_storage /mnt/data
[tom@storage ~]$ df -h | grep '/mnt/data'
/dev/mapper/storage-ma_storage  3.9G   92K  3.7G   1% /mnt/data
```
```

[tom@storage ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Feb 19 09:02:01 2024
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=bb7d105d-cef0-4559-a053-2782d39e7374 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
🌞/dev/storage/ma_storage   /mnt/data  ext4   defaults   0   2🌞


[tom@storage ~]$ df -h | grep /storage
/dev/mapper/storage-ma_storage  3.9G   92K  3.7G   1% /mnt/data

```

# Partie 2 : Serveur de partage de fichiers

🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

``` 
[tom@storage ~]$ cat /etc/exports
/mnt/storage/site_web_1     10.4.2.3(rw,sync,no_subtree_check)
/mnt/storage/site_web_2     10.4.2.3(rw,sync,no_subtree_check)

```
🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux
```
[tom@web ~]$ sudo cat /etc/fstab | grep site_web_
[sudo] password for tom:
storage.tp4.linux:/storage/site_web_1 /var/www/site_web_1 nfs defaults 0 0
storage.tp4.linux:/storage/site_web_2 /var/www/site_web_2 nfs defaults 0 0

```
# Partie 3 : Serveur web

## 2. Install

🌞 Installez NGINX

```
[tom@web ~]$ sudo dnf list | grep nginx
nginx.x86_64                                         1:1.20.1-14.el9_2.1                 @appstream
nginx-core.x86_64                                    1:1.20.1-14.el9_2.1                 @appstream
nginx-filesystem.noarch                              1:1.20.1-14.el9_2.1                 @appstream
nginx-all-modules.noarch                             1:1.20.1-14.el9_2.1                 appstream
nginx-mod-http-image-filter.x86_64                   1:1.20.1-14.el9_2.1                 appstream
nginx-mod-http-perl.x86_64                           1:1.20.1-14.el9_2.1                 appstream
nginx-mod-http-xslt-filter.x86_64                    1:1.20.1-14.el9_2.1                 appstream
nginx-mod-mail.x86_64                                1:1.20.1-14.el9_2.1                 appstream
nginx-mod-stream.x86_64                              1:1.20.1-14.el9_2.1                 appstream
pcp-pmda-nginx.x86_64                                6.0.5-4.el9                         appstream
```

## 3. Analyse

🌞 Analysez le service NGINX

### Déterminer l'utilisateur sous lequel tourne NGINX
```
[tom@web ~]$ ps aux | grep nginx
root        1538  0.0  0.0  10112   952 ?        Ss   18:51   0:00 nginx: master process /usr/sbin/nginx
nginx       1539  0.0  0.2  13912  4972 ?        S    18:51   0:00 nginx: worker process
tom         1545  0.0  0.1   6408  2284 pts/0    S+   18:52   0:00 grep --color=auto nginx
```
### déterminer derrière quel port écoute actuellement le serveur web
```
[tom@web ~]$ ss -ltnep | grep nginx
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    ino:26751 sk:2 cgroup:/system.slice/nginx.service <->
LISTEN 0      511             [::]:80           [::]:*    ino:26752 sk:4 cgroup:/system.slice/nginx.service v6only:1 <->
```