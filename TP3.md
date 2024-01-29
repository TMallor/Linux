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

🌞 Test !
```

```