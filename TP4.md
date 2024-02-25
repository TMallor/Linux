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

### déterminer dans quel dossier se trouve la racine web

```
[tom@web ~]$ grep -i 'root' /etc/nginx/nginx.conf
        root         /usr/share/nginx/html;
#        root         /usr/share/nginx/html;
```

### inspectez les fichiers de la racine web, et vérifier qu'ils sont bien accessibles en lecture par l'utilisateur qui lance le processus

```
[tom@web ~]$ ls -l /usr/share/nginx/html
total 12
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 22 18:48 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
-rw-r--r--. 1 root root  368 Oct 16 19:58 nginx-logo.png
lrwxrwxrwx. 1 root root   14 Oct 16 20:00 poweredby.png -> nginx-logo.png
lrwxrwxrwx. 1 root root   37 Oct 16 20:00 system_noindex_logo.png -> ../../pixmaps/system-noindex-logo.png
```

# 4. Visite du service web 

🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX 

```
[tom@web ~]$ sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
success
[tom@web ~]$ sudo firewall-cmd --reload
success
```

🌞 Accéder au site web

```
[tom@web ~]$ curl http://10.4.2.3
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
      }
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1);
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;

      }


  h1 {
    text-align: center;
    margin: 0;
    padding: 0.6em 2em 0.4em;
    color: #fff;
    font-weight: bold;
    font-family: 'Montserrat', sans-serif;
    font-size: 2em;
  }
  h1 strong {
    font-weight: bolder;
    font-family: 'Montserrat', sans-serif;
  }
  h2 {
    font-size: 1.5em;
    font-weight:bold;
  }

  .title {
    border: 1px solid black;
    font-weight: bold;
    position: relative;
    float: right;
    width: 150px;
    text-align: center;
    padding: 10px 0 10px 0;
    margin-top: 0;
  }

  .description {
    padding: 45px 10px 5px 10px;
    clear: right;
    padding: 15px;
  }

  .section {
    padding-left: 3%;
   margin-bottom: 10px;
  }

  img {

    padding: 2px;
    margin: 2px;
  }
  a:hover img {
    padding: 2px;
    margin: 2px;
  }

  :link {
    color: rgb(199, 252, 77);
    text-shadow:
  }
  :visited {
    color: rgb(122, 206, 255);
  }
  a:hover {
    color: rgb(16, 44, 122);
  }
  .row {
    width: 100%;
    padding: 0 10px 0 10px;
  }

  footer {
    padding-top: 6em;
    margin-bottom: 6em;
    text-align: center;
    font-size: xx-small;
    overflow:hidden;
    clear: both;
  }

  .summary {
    font-size: 140%;
    text-align: center;
  }

  #rocky-poweredby img {
    margin-left: -10px;
  }

  #logos img {
    vertical-align: top;
  }

  /* Desktop  View Options */

  @media (min-width: 768px)  {

    body {
      padding: 10em 20% !important;
    }

    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 {
      float: left;
    }

    .col-md-1 {
      width: 8.33%;
    }
    .col-md-2 {
      width: 16.66%;
    }
    .col-md-3 {
      width: 25%;
    }
    .col-md-4 {
      width: 33%;
    }
    .col-md-5 {
      width: 41.66%;
    }
    .col-md-6 {
      border-left:3px ;
      width: 50%;


    }
    .col-md-7 {
      width: 58.33%;
    }
    .col-md-8 {
      width: 66.66%;
    }
    .col-md-9 {
      width: 74.99%;
    }
    .col-md-10 {
      width: 83.33%;
    }
    .col-md-11 {
      width: 91.66%;
    }
    .col-md-12 {
      width: 100%;
    }
  }

  /* Mobile View Options */
  @media (max-width: 767px) {
    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
      float: left;
    }

    .col-sm-1 {
      width: 8.33%;
    }
    .col-sm-2 {
      width: 16.66%;
    }
    .col-sm-3 {
      width: 25%;
    }
    .col-sm-4 {
      width: 33%;
    }
    .col-sm-5 {
      width: 41.66%;
    }
    .col-sm-6 {
      width: 50%;
    }
    .col-sm-7 {
      width: 58.33%;
    }
    .col-sm-8 {
      width: 66.66%;
    }
    .col-sm-9 {
      width: 74.99%;
    }
    .col-sm-10 {
      width: 83.33%;
    }
    .col-sm-11 {
      width: 91.66%;
    }
    .col-sm-12 {
      width: 100%;
    }
    h1 {
      padding: 0 !important;
    }
  }


  </style>
  </head>
  <body>
    <h1>HTTP Server <strong>Test Page</strong></h1>

    <div class='row'>

      <div class='col-sm-12 col-md-6 col-md-6 '></div>
          <p class="summary">This page is used to test the proper operation of
            an HTTP server after it has been installed on a Rocky Linux system.
            If you can read this page, it means that the software is working
            correctly.</p>
      </div>

      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>


        <div class='section'>
          <h2>Just visiting?</h2>

          <p>This website you are visiting is either experiencing problems or
          could be going through maintenance.</p>

          <p>If you would like the let the administrators of this website know
          that you've seen this page instead of the page you've expected, you
          should send them an email. In general, mail sent to the name
          "webmaster" and directed to the website's domain should reach the
          appropriate person.</p>

          <p>The most common email address to send to is:
          <strong>"webmaster@example.com"</strong></p>

          <h2>Note:</h2>
          <p>The Rocky Linux distribution is a stable and reproduceable platform
          based on the sources of Red Hat Enterprise Linux (RHEL). With this in
          mind, please understand that:

        <ul>
          <li>Neither the <strong>Rocky Linux Project</strong> nor the
          <strong>Rocky Enterprise Software Foundation</strong> have anything to
          do with this website or its content.</li>
          <li>The Rocky Linux Project nor the <strong>RESF</strong> have
          "hacked" this webserver: This test page is included with the
          distribution.</li>
        </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>

          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>

        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>
      </div>
      </div>

      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```

🌞 Vérifier les logs d'accès

```
[tom@web ~]$ ls /var/log/nginx/access.log
/var/log/nginx/access.log
[tom@web ~]$ tail -n 3 /var/log/nginx/access.log
10.4.2.1 - - [25/Feb/2024:11:38:25 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://10.4.2.3/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.4.2.1 - - [25/Feb/2024:11:38:25 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://10.4.2.3/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.4.2.3 - - [25/Feb/2024:11:38:54 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```

# 5. Modif de la conf du serveur web

🌞 Changer le port d'écoute 

### une simple ligne à modifier, vous me la montrerez dans le compte rendu
```
[tom@web ~]$ sudo cat /etc/nginx/nginx.conf
    server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    } 
```
### redémarrer le service pour que le changement prenne effet
```
[tom@web ~]$  sudo systemctl restart nginx
[tom@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Sun 2024-02-25 12:00:28 CET; 5s ago
    Process: 1884 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1885 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1886 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1887 (nginx)
      Tasks: 2 (limit: 11038)
     Memory: 2.0M
        CPU: 14ms
     CGroup: /system.slice/nginx.service
             ├─1887 "nginx: master process /usr/sbin/nginx"
             └─1888 "nginx: worker process"

Feb 25 12:00:28 web systemd[1]: nginx.service: Deactivated successfully.
Feb 25 12:00:28 web systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Feb 25 12:00:28 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 25 12:00:28 web nginx[1885]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 25 12:00:28 web nginx[1885]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 25 12:00:28 web systemd[1]: Started The nginx HTTP and reverse proxy server.
```
### prouvez-moi que le changement a pris effet avec une commande ss
```
[tom@web ~]$  sudo ss -ltnep | grep nginx
LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=1888,fd=6),("nginx",pid=1887,fd=6)) ino:27323 sk:4 cgroup:/system.slice/nginx.service <->
LISTEN 0      511             [::]:8080         [::]:*    users:(("nginx",pid=1888,fd=7),("nginx",pid=1887,fd=7)) ino:27324 sk:6 cgroup:/system.slice/nginx.service v6only:1 <->
```
### n'oubliez pas de fermer l'ancien port dans le firewall, et d'ouvrir le nouveau
```
[tom@web ~]$ sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
success
[tom@web ~]$ sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
success
[tom@web ~]$ sudo firewall-cmd --reload
success

```
### prouvez avec une commande curl sur votre machine que vous pouvez désormais visiter le port 8080
```
[tom@web ~]$ curl http://10.4.2.3:8080
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
        height: 100%;
        width: 100%;
      }
        body {
  background: rgb(20,72,50);
  background: -moz-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%)  ;
  background: -webkit-linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%) ;
  background: linear-gradient(180deg, rgba(23,43,70,1) 30%, rgba(0,0,0,1) 90%);
  background-repeat: no-repeat;
  background-attachment: fixed;
  filter: progid:DXImageTransform.Microsoft.gradient(startColorstr="#3c6eb4",endColorstr="#3c95b4",GradientType=1);
        color: white;
        font-size: 0.9em;
        font-weight: 400;
        font-family: 'Montserrat', sans-serif;
        margin: 0;
        padding: 10em 6em 10em 6em;
        box-sizing: border-box;

      }


  h1 {
    text-align: center;
    margin: 0;
    padding: 0.6em 2em 0.4em;
    color: #fff;
    font-weight: bold;
    font-family: 'Montserrat', sans-serif;
    font-size: 2em;
  }
  h1 strong {
    font-weight: bolder;
    font-family: 'Montserrat', sans-serif;
  }
  h2 {
    font-size: 1.5em;
    font-weight:bold;
  }

  .title {
    border: 1px solid black;
    font-weight: bold;
    position: relative;
    float: right;
    width: 150px;
    text-align: center;
    padding: 10px 0 10px 0;
    margin-top: 0;
  }

  .description {
    padding: 45px 10px 5px 10px;
    clear: right;
    padding: 15px;
  }

  .section {
    padding-left: 3%;
   margin-bottom: 10px;
  }

  img {

    padding: 2px;
    margin: 2px;
  }
  a:hover img {
    padding: 2px;
    margin: 2px;
  }

  :link {
    color: rgb(199, 252, 77);
    text-shadow:
  }
  :visited {
    color: rgb(122, 206, 255);
  }
  a:hover {
    color: rgb(16, 44, 122);
  }
  .row {
    width: 100%;
    padding: 0 10px 0 10px;
  }

  footer {
    padding-top: 6em;
    margin-bottom: 6em;
    text-align: center;
    font-size: xx-small;
    overflow:hidden;
    clear: both;
  }

  .summary {
    font-size: 140%;
    text-align: center;
  }

  #rocky-poweredby img {
    margin-left: -10px;
  }

  #logos img {
    vertical-align: top;
  }

  /* Desktop  View Options */

  @media (min-width: 768px)  {

    body {
      padding: 10em 20% !important;
    }

    .col-md-1, .col-md-2, .col-md-3, .col-md-4, .col-md-5, .col-md-6,
    .col-md-7, .col-md-8, .col-md-9, .col-md-10, .col-md-11, .col-md-12 {
      float: left;
    }

    .col-md-1 {
      width: 8.33%;
    }
    .col-md-2 {
      width: 16.66%;
    }
    .col-md-3 {
      width: 25%;
    }
    .col-md-4 {
      width: 33%;
    }
    .col-md-5 {
      width: 41.66%;
    }
    .col-md-6 {
      border-left:3px ;
      width: 50%;


    }
    .col-md-7 {
      width: 58.33%;
    }
    .col-md-8 {
      width: 66.66%;
    }
    .col-md-9 {
      width: 74.99%;
    }
    .col-md-10 {
      width: 83.33%;
    }
    .col-md-11 {
      width: 91.66%;
    }
    .col-md-12 {
      width: 100%;
    }
  }

  /* Mobile View Options */
  @media (max-width: 767px) {
    .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6,
    .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
      float: left;
    }

    .col-sm-1 {
      width: 8.33%;
    }
    .col-sm-2 {
      width: 16.66%;
    }
    .col-sm-3 {
      width: 25%;
    }
    .col-sm-4 {
      width: 33%;
    }
    .col-sm-5 {
      width: 41.66%;
    }
    .col-sm-6 {
      width: 50%;
    }
    .col-sm-7 {
      width: 58.33%;
    }
    .col-sm-8 {
      width: 66.66%;
    }
    .col-sm-9 {
      width: 74.99%;
    }
    .col-sm-10 {
      width: 83.33%;
    }
    .col-sm-11 {
      width: 91.66%;
    }
    .col-sm-12 {
      width: 100%;
    }
    h1 {
      padding: 0 !important;
    }
  }


  </style>
  </head>
  <body>
    <h1>HTTP Server <strong>Test Page</strong></h1>

    <div class='row'>

      <div class='col-sm-12 col-md-6 col-md-6 '></div>
          <p class="summary">This page is used to test the proper operation of
            an HTTP server after it has been installed on a Rocky Linux system.
            If you can read this page, it means that the software is working
            correctly.</p>
      </div>

      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>


        <div class='section'>
          <h2>Just visiting?</h2>

          <p>This website you are visiting is either experiencing problems or
          could be going through maintenance.</p>

          <p>If you would like the let the administrators of this website know
          that you've seen this page instead of the page you've expected, you
          should send them an email. In general, mail sent to the name
          "webmaster" and directed to the website's domain should reach the
          appropriate person.</p>

          <p>The most common email address to send to is:
          <strong>"webmaster@example.com"</strong></p>

          <h2>Note:</h2>
          <p>The Rocky Linux distribution is a stable and reproduceable platform
          based on the sources of Red Hat Enterprise Linux (RHEL). With this in
          mind, please understand that:

        <ul>
          <li>Neither the <strong>Rocky Linux Project</strong> nor the
          <strong>Rocky Enterprise Software Foundation</strong> have anything to
          do with this website or its content.</li>
          <li>The Rocky Linux Project nor the <strong>RESF</strong> have
          "hacked" this webserver: This test page is included with the
          distribution.</li>
        </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>

          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>

        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>
      </div>
      </div>

      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>

```

🌞 Changer l'utilisateur qui lance le service

```
[tom@web ~]$  sudo useradd -m -d /home/web -s /bin/bash web
[tom@web ~]$ sudo passwd web
Changing password for user web.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
```
### modifiez la conf de NGINX pour qu'il soit lancé avec votre nouvel utilisateur
```
[tom@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
```
### n'oubliez pas de redémarrer le service pour que le changement prenne effet
```
[tom@web ~]$ sudo systemctl restart nginx
[tom@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Sun 2024-02-25 12:10:29 CET; 6s ago
    Process: 1971 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1972 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1973 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1974 (nginx)
      Tasks: 2 (limit: 11038)
     Memory: 1.9M
        CPU: 16ms
     CGroup: /system.slice/nginx.service
             ├─1974 "nginx: master process /usr/sbin/nginx"
             └─1975 "nginx: worker process"

Feb 25 12:10:29 web systemd[1]: nginx.service: Deactivated successfully.
Feb 25 12:10:29 web systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Feb 25 12:10:29 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 25 12:10:29 web nginx[1972]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 25 12:10:29 web nginx[1972]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 25 12:10:29 web systemd[1]: Started The nginx HTTP and reverse proxy server.
```

### vous prouverez avec une commande ps que le service tourne bien sous ce nouveau utilisateur
```
[tom@web ~]$ ps -aux | grep nginx
root        1974  0.0  0.0  10112   952 ?        Ss   12:10   0:00 nginx: master process /usr/sbin/nginx
web         1975  0.0  0.2  13912  4992 ?        S    12:10   0:00 nginx: worker process
tom         1979  0.0  0.1   6408  2300 pts/0    S+   12:11   0:00 grep --color=auto nginx
```

🌞 Changer l'emplacement de la racine Web

### configurez NGINX pour qu'il utilise une autre racine web que celle par défaut
```
[tom@web ~]$ sudo nano /var/www/site_web_1/index.html
[tom@web ~]$ sudo cat /etc/nginx/nginx.conf
  server {
        listen       8080;
        listen       [::]:8080;
        server_name  _;
🌞root          /var/www/site_web_1;🌞

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

### n'oubliez pas de redémarrer le service pour que le changement prenne effet
```

[tom@web ~]$ sudo systemctl restart nginx
[tom@web ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; preset: disabled)
     Active: active (running) since Sun 2024-02-25 12:16:25 CET; 3s ago
    Process: 1996 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 1997 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 1998 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 1999 (nginx)
      Tasks: 2 (limit: 11038)
     Memory: 2.0M
        CPU: 15ms
     CGroup: /system.slice/nginx.service
             ├─1999 "nginx: master process /usr/sbin/nginx"
             └─2000 "nginx: worker process"

Feb 25 12:16:25 web systemd[1]: nginx.service: Deactivated successfully.
Feb 25 12:16:25 web systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Feb 25 12:16:25 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 25 12:16:25 web nginx[1997]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 25 12:16:25 web nginx[1997]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 25 12:16:25 web systemd[1]: Started The nginx HTTP and reverse proxy server.
```
### prouvez avec un curl depuis votre hôte que vous accédez bien au nouveau site
```
[tom@web ~]$ curl http://10.4.2.3:8080/index.html
désolé pour le retard ;)
```

# 6. Deux sites web sur un seul serveur 

🌞 Repérez dans le fichier de conf 

```
[tom@web ~]$ grep -i 'include' /etc/nginx/nginx.conf
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

🌞 Créez le fichier de configuration pour le premier site

```
[tom@web ~]$  sudo cat /etc/nginx/conf.d/site_web_1.conf
server {
    listen       8080;
    listen       [::]:8080;
    server_name  _;
    root         /var/www/site_web_1;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /404.html {
    }
}
```

🌞 Créez le fichier de configuration pour le deuxième site

```
[tom@web ~]$ sudo nano /etc/nginx/conf.d/site_web_2.conf
[tom@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf
server {
    listen       8888;
    listen       [::]:8888;
    server_name  _;
    root         /var/www/site_web_2;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    error_page 404 /404.html;
    location = /404.html {
    }
}
[tom@web ~]$ sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent
success
[tom@web ~]$ sudo firewall-cmd --reload
success
[tom@web ~]$  sudo systemctl restart nginx
[tom@web ~]$ ss -ltenp | grep 8888
LISTEN 0      511          0.0.0.0:8888      0.0.0.0:*    ino:30429 sk:7 cgroup:/system.slice/nginx.service <->
LISTEN 0      511             [::]:8888         [::]:*    ino:30430 sk:9 cgroup:/system.slice/nginx.service v6only:1 <->
```

🌞 Prouvez que les deux sites sont disponibles

```
[tom@web ~]$  curl http://10.4.2.3:8080/index.html
désolé pour le retard ;)
[tom@web ~]$ curl http://10.4.2.3:8888/index.html
<html>
<head><title>404 Not Found</title></head>
<body>
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.20.1</center>
</body>
</html>
```