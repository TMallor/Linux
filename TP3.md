# I. Service SSH

 # 1. Analyse du service

 🌞 S'assurer que le service sshd est démarré

 ```
[tom@node1 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2024-01-29 10:07:49 CET; 42min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 710 (sshd)
      Tasks: 1 (limit: 11024)
     Memory: 5.0M
        CPU: 48ms
     CGroup: /system.slice/sshd.service
             └─710 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Jan 29 10:07:49 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
Jan 29 10:07:49 node1.tp3.b1 sshd[710]: Server listening on 0.0.0.0 port 22.
Jan 29 10:07:49 node1.tp3.b1 sshd[710]: Server listening on :: port 22.
Jan 29 10:07:49 node1.tp3.b1 systemd[1]: Started OpenSSH server daemon.
Jan 29 10:08:24 node1.tp3.b1 sshd[1257]: Accepted password for tom from 10.2.1.1 port 59550 ssh2
Jan 29 10:08:24 node1.tp3.b1 sshd[1257]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)

 ```

 🌞 Analyser les processus liés au service SSH

```
[tom@node1 ~]$ ps -ef | grep sshd
root         710       1  0 10:07 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1257     710  0 10:08 ?        00:00:00 sshd: tom [priv]
tom         1261    1257  0 10:08 ?        00:00:00 sshd: tom@pts/0
tom         1303    1262  0 10:44 pts/0    00:00:00 grep --color=auto sshd  
```

🌞 Déterminer le port sur lequel écoute le service SSH

```
[tom@node1 ~]$ sudo ss -alnpt | grep ssh
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=710,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=710,fd=4))
```

🌞 Consulter les logs du service SSH

```
[tom@node1 ~]$ journalctl -xe -u sshd -f
Jan 29 10:07:49 node1.tp3.b1 systemd[1]: Starting OpenSSH server daemon...
░░ Subject: A start job for unit sshd.service has begun execution
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has begun execution.
░░
░░ The job identifier is 230.
Jan 29 10:07:49 node1.tp3.b1 sshd[710]: Server listening on 0.0.0.0 port 22.
Jan 29 10:07:49 node1.tp3.b1 sshd[710]: Server listening on :: port 22.
Jan 29 10:07:49 node1.tp3.b1 systemd[1]: Started OpenSSH server daemon.
░░ Subject: A start job for unit sshd.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit sshd.service has finished successfully.
░░
░░ The job identifier is 230.
Jan 29 10:08:24 node1.tp3.b1 sshd[1257]: Accepted password for tom from 10.2.1.1 port 59550 ssh2
Jan 29 10:08:24 node1.tp3.b1 sshd[1257]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)

```
```
[tom@node1 log]$ tail -n 10 dnf.log
2024-01-29T10:29:23+0100 DDEBUG Command: dnf makecache --timer
2024-01-29T10:29:23+0100 DDEBUG Installroot: /
2024-01-29T10:29:23+0100 DDEBUG Releasever: 9
2024-01-29T10:29:23+0100 DEBUG cachedir: /var/cache/dnf
2024-01-29T10:29:23+0100 DDEBUG Base command: makecache
2024-01-29T10:29:23+0100 DDEBUG Extra commands: ['makecache', '--timer']
2024-01-29T10:29:23+0100 DEBUG Making cache files for all metadata files.
2024-01-29T10:29:23+0100 INFO Metadata timer caching disabled when running on a battery.
2024-01-29T10:29:23+0100 DDEBUG Cleaning up.
2024-01-29T10:29:23+0100 DDEBUG Plugins were unloaded.
```

# 2. Modification du service

🌞 Identifier le fichier de configuration du serveur SSH

```
[tom@node1 ssh]$ ls
moduli      ssh_config.d  sshd_config.d       ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
ssh_config  sshd_config   ssh_host_ecdsa_key  ssh_host_ed25519_key    ssh_host_rsa_key
[tom@node1 ssh]$ cat ssh_config

```
🌞 Modifier le fichier de conf

```
[tom@node1 ~]$ echo $RANDOM
20046
```
```
[tom@node1 ~] sudo nano /etc/ssh/ssh_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
🌞Port 20046🌞
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
```
```
[tom@node1 ~]$  sudo nano /etc/ssh/sshd_config
[sudo] password for tom:
[tom@node1 ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 20046
#GatewayPorts no
[tom@node1 ~]$ sudo firewall-cmd --remove-port=22/tcp --permanent
Warning: NOT_ENABLED: 22:tcp
success
[tom@node1 ~]$ sudo firewall-cmd --add-port=20046/tcp --permanent
success
[tom@node1 ~]$ sudo firewall-cmd --reload
success
[tom@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 20529/tcp 20046/tcp
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

🌞 Redémarrer le service

```
[tom@node1 ~]$ sudo systemctl restart firewalld
```
🌞 Effectuer une connexion SSH sur le nouveau port
```
PS C:\Users\tomma> ssh -p  20046 tom@10.2.1.11
tom@10.2.1.11's password:
Last failed login: Mon Jan 29 11:58:06 CET 2024 from 10.2.1.1 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Mon Jan 29 11:51:59 2024 from 10.2.1.1  

```


# II. Service HTTP

🌞 Installer le serveur NGINX
```
[tom@node1 ~]$ sudo dnf install nginx
.
.
.
Installed:
  nginx-1:1.20.1-14.el9_2.1.x86_64 nginx-core-1:1.20.1-14.el9_2.1.x86_64 nginx-filesystem-1:1.20.1-14.el9_2.1.noarch rocky-logos-httpd-90.14-2.el9.noarch

Complete!
```
```

[tom@node1 ~]$ dnf search dnf search nginx
Rocky Linux 9 - BaseOS                                                                                                      4.0 MB/s | 2.2 MB     00:00
Rocky Linux 9 - AppStream                                                                                                   8.3 MB/s | 7.4 MB     00:00
Rocky Linux 9 - Extras                                                                                                       42 kB/s |  14 kB     00:00
No matches found.

```
🌞 Déterminer le nom de l'utilisateur qui lance NGINX
```
[tom@node1 ~]$ ps aux | grep nginx
tom        11762  0.0  0.1   6408  2300 pts/0    S+   12:10   0:00 grep --color=auto nginx
```

 🌞 Démarrer le service NGINX
```
[tom@node1 ~]$ sudo systemctl start nginx
```
```
[tom@node1 ~]$ systemctl status nginx

```
```
[tom@node1 ~]$ sudo systemctl enable nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.


[tom@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   🌞  Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)🌞
     Active: active (running) since Tue 2024-01-30 09:06:16 CET; 1min 29s ago
   Main PID: 1322 (nginx)
      Tasks: 2 (limit: 11024)
     Memory: 3.4M
        CPU: 15ms
     CGroup: /system.slice/nginx.service
             ├─1322 "nginx: master process /usr/sbin/nginx"
             └─1323 "nginx: worker process"

Jan 30 09:06:16 node1.tp3.b1 systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jan 30 09:06:16 node1.tp3.b1 nginx[1320]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jan 30 09:06:16 node1.tp3.b1 nginx[1320]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jan 30 09:06:16 node1.tp3.b1 systemd[1]: Started The nginx HTTP and reverse proxy server.

```

🌞 Déterminer sur quel port tourne NGINX

```
[tom@node1 ~]$ sudo ss -alnpt | grep nginx
[sudo] password for tom:
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=1323,fd=6),("nginx",pid=1322,fd=6))
LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=1323,fd=7),("nginx",pid=1322,fd=7))

[tom@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[tom@node1 ~]$ sudo firewall-cmd --reload
success

```


🌞 Déterminer les processus liés au service NGINX

```
[tom@node1 ~]$ ps aux | grep nginx
root        1322  0.0  0.0  10112   952 ?        Ss   09:06   0:00 nginx: master process /usr/sbin/nginx
nginx       1323  0.0  0.2  13912  4972 ?        S    09:06   0:00 nginx: worker process
tom        34591  0.0  0.1   6408  2300 pts/0    S+   09:42   0:00 grep --color=auto nginx
```

🌞 Déterminer le nom de l'utilisateur qui lance NGINX


```
[tom@node1 ~]$ ps aux | grep nginx
root        1322  0.0  0.0  10112   952 ?        Ss   09:06   0:00 nginx: master process /usr/sbin/nginx


[tom@node1 ~]$ sudo cat /etc/passwd | grep root
root:x:0:0:root:/root:/bin/bash
operator:x:11:0:operator:/root:/sbin/nologin
```


🌞 Test !

```
[tom@node1 ~]$ sudo curl http://10.2.1.11:80 | head n7
head: cannot open 'n7' for reading: No such file or directory
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   572k      0 --:--:-- --:--:-- --:--:--  572k
curl: (23) Failure writing output to destination

```

# 2. Analyser la conf de NGINX


🌞 Déterminer le path du fichier de configuration de NGINX

```
[tom@node1 etc]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 Oct 16 20:00 /etc/nginx/nginx.conf
```

🌞 Trouver dans le fichier de conf

```
[tom@node1 ~]$  cat /etc/nginx/nginx.conf | grep server -A 10
    server {
        listen       80;
        listen       [::]:80;
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
--
# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }
```
```


[tom@node1 ~]$  cat /etc/nginx/nginx.conf | grep include
include /usr/share/nginx/modules/*.conf;
    include             /etc/nginx/mime.types;
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/default.d/*.conf;
#        include /etc/nginx/default.d/*.conf;
```

# 3. Déployer un nouveau site web

🌞 Créer un site web

```
[tom@node1 ~]$ sudo mkdir  -p /var/www/tp3_linux
[sudo] password for tom:
[tom@node1 ~]$ sudo nano /var/www/tp3_linux/index.html
[tom@node1 ~]$ sudo cat /var/www/tp3_linux/index.html
<h1>MEOW mon second serveur web</h1>
```

🌞 Gérer les permissions

```
[tom@node1 ~]$ sudo chown nginx:nginx /var/www/tp3_linux/index.html
[tom@node1 ~]$  ls -al
total 20
drwx------. 2 tom  tom    99 Jan 30 09:07 .
drwxr-xr-x. 3 root root   17 Dec 19 10:00 ..
-rw-------. 1 tom  tom  3167 Jan 29 11:57 .bash_history
-rw-r--r--. 1 tom  tom    18 Jan 23  2023 .bash_logout
-rw-r--r--. 1 tom  tom   141 Jan 23  2023 .bash_profile
-rw-r--r--. 1 tom  tom   492 Jan 23  2023 .bashrc
-rw-------. 1 tom  tom    20 Jan 30 09:07 .lesshst

```

🌞 Adapter la conf NGINX

```
[tom@node1 ~]$ sudo cat /etc/nginx/nginx.conf
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;



# Settings for a TLS enabled server.
#
#    server {
#        listen       443 ssl http2;
#        listen       [::]:443 ssl http2;
#        server_name  _;
#        root         /usr/share/nginx/html;
#
#        ssl_certificate "/etc/pki/nginx/server.crt";
#        ssl_certificate_key "/etc/pki/nginx/private/server.key";
#        ssl_session_cache shared:SSL:1m;
#        ssl_session_timeout  10m;
#        ssl_ciphers PROFILE=SYSTEM;
#        ssl_prefer_server_ciphers on;
#
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
#
#        error_page 404 /404.html;
#            location = /40x.html {
#        }
#
#        error_page 500 502 503 504 /50x.html;
#            location = /50x.html {
#        }
#    }

}
```
```
[tom@node1 ~]$ sudo systemctl restart nginx

[tom@node1 ~]$ systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
    🌞 Active: active (running) since Tue 2024-01-30 10:48:40 CET; 26s ago🌞

```

```
[tom@node1 ~] cat /etc/nginx/conf.d/serveur.conf
server {
  # le port choisi devra être obtenu avec un 'echo $RANDOM' là encore
  listen 4548;

  root /var/www/tp3_linux;
}
```


🌞 Visitez votre super site web

```
[tom@node1 ~]$ curl 10.2.1.11:4548
<h1>MEOW mon second serveur web</h1>
```


# III. Your own services



# 2. Analyse des services existants    

🌞 Afficher le fichier de service SSH

```
[tom@node1 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; preset:>
     Active: active (running) since Mon 2024-02-12 09:46:48 CET; 4min 25s a>
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 710 (sshd)
      Tasks: 1 (limit: 11038)
     Memory: 4.9M
        CPU: 114ms
     CGroup: /system.slice/sshd.service
             └─710 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
```
```
[tom@node1 ~]$ cat /usr/lib/systemd/system/sshd.service | grep 'ExecStart='
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 Afficher le fichier de service NGINX

```
[tom@node1 ~]$ cat /usr/lib/systemd/system/nginx.service | grep 'ExecStart='
ExecStart=/usr/sbin/nginx
```

# 3. Création de service

🌞 Créez le fichier /etc/systemd/system/tp3_nc.service

```
[tom@node1 ~]$ sudo touch /etc/systemd/system/tp3_nc.service
[sudo] password for tom:
[tom@node1 ~]$ echo $RANDOM
19569
[tom@node1 ~]$ sudo cat /etc/systemd/system/tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l <19569> -k
[tom@node1 ~]$

```

🌞 Indiquer au système qu'on a modifié les fichiers de service

```
[tom@node1 system]$ sudo systemctl daemon-reload
```

🌞 Démarrer notre service de ouf

```
[tom@node1 system]$ sudo systemctl start tp3_nc
```

🌞 Vérifier que ça fonctionne

```
[tom@node1 system]$ sudo systemctl status tp3_nc.service
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Tue 2024-01-30 11:23:19 CET; 50s ago
   Main PID: 32109 (nc)
      Tasks: 1 (limit: 4896)
     Memory: 1.1M
        CPU: 4ms
     CGroup: /system.slice/tp3_nc.service
             └─32109 /usr/bin/nc -l 19569 -k


[tom@node1 ~]$ ss -tln | grep 19569
LISTEN 0      10           0.0.0.0:19569      0.0.0.0:*
LISTEN 0      10              [::]:19569         [::]:*


[tom@localhost ~]$ nc 10.2.1.11 19569
azerty
```

🌞 Les logs de votre service

```
[tom@node1 system]$ sudo journalctl -xe -u tp3_nc | grep Started
Jan 29 16:37:55 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.

[tom@node1 system]$ sudo journalctl -xe -u tp3_nc | grep nc
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ A start job for unit tp3_nc.service has finished successfully.
Jan 29 16:46:47 node1.tp3.b1 nc[32109]: azerty


[tom@node1 ~]$ sudo systemctl status tp3_nc | grep Active
Active: inactive (dead)
```

🌞 S'amuser à kill le processus

```
[tom@node1 system]$ ps -ef | grep nc
root       32109       1  0 16:37 ?        00:00:00 /usr/bin/nc -l 11720 -k

[tom@node1 system]$ sudo kill 32109

```

🌞 Affiner la définition du service
```
[tom@node1 ~]$ sudo cat /etc/systemd/system/tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
Restart=always
ExecStart=/usr/bin/nc -l 19569 -k
```

```
[tom@node1 ~]$ sudo systemctl start tp3_nc.service
[tom@node1 ~]$  ps -fe | grep nc
dbus         657       1  0 08:58 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root         693       1  0 08:58 ?        00:00:00 login -- tom
tom      839       1  0 09:04 ?        00:00:00 /usr/lib/systemd/systemd --user
tom      841     839  0 09:04 ?        00:00:00 (sd-pam)
tom      849     693  0 09:04 tty1     00:00:00 -bash
root       43166   18011  0 12:01 ?        00:00:00 sshd: tom [priv]
tom    43170   43166  0 12:01 ?        00:00:00 sshd: tom@pts/0
tom    43171   43170  0 12:01 pts/0    00:00:00 -bash
root       43259       1  0 12:28 ?        00:00:00 /usr/bin/nc -l 13584 -k
tom    43260   43171  0 12:29 pts/0    00:00:00 ps -fe
tom    43261   43171  0 12:29 pts/0    00:00:00 grep --color=auto nc

```
```
[tom@node1 ~]$ sudo kill 43259
```
```
[tom@node1 ~]$  ps -fe | grep nc
dbus         657       1  0 08:58 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root         693       1  0 08:58 ?        00:00:00 login -- tom
tom      839       1  0 09:04 ?        00:00:00 /usr/lib/systemd/systemd --user
tom      841     839  0 09:04 ?        00:00:00 (sd-pam)
tom      849     693  0 09:04 tty1     00:00:00 -bash
root       43166   18011  0 12:01 ?        00:00:00 sshd: tom [priv]
tom    43170   43166  0 12:01 ?        00:00:00 sshd: tom@pts/0
tom    43171   43170  0 12:01 pts/0    00:00:00 -bash
root       43265       1  0 12:29 ?        00:00:00 /usr/bin/nc -l 13584 -k
tom    43266   43171  0 12:29 pts/0    00:00:00 ps -fe
tom    43267   43171  0 12:29 pts/0    00:00:00 grep --color=auto nc
```