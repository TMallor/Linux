# TP 2 Linux

# I. Fichiers


🌞 Trouver le chemin vers le répertoire personnel de votre utilisateur

```
[tom@TP1 ~]$ useradd toto
[tom@TP1 ~]$ cd ../
[tom@TP1 home]$ ls
tom  toto
```

🌞 Trouver le chemin du fichier de logs SSH

```
[tom@TP1 /]$ sudo cat /var/log/secure  | grep sshd
Dec 19 10:02:42 localhost sshd[798]: Server listening on 0.0.0.0 port 22.
Dec 19 10:02:42 localhost sshd[798]: Server listening on :: port 22.
Dec 19 10:08:20 localhost sshd[704]: Server listening on 0.0.0.0 port 22.
Dec 19 10:08:20 localhost sshd[704]: Server listening on :: port 22.
Dec 19 10:08:40 localhost sshd[1251]: Connection reset by 10.7.1.1 port 50239 [preauth]
Dec 19 10:28:19 localhost sshd[1331]: Accepted password for tom from 10.7.2.1 port 50289 ssh2
Dec 19 10:28:19 localhost sshd[1331]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Dec 19 10:29:06 localhost sshd[1364]: Accepted password for tom from 10.7.2.1 port 50643 ssh2
Dec 19 10:29:06 localhost sshd[1364]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Jan 22 09:12:30 localhost sshd[703]: Server listening on 0.0.0.0 port 22.
Jan 22 09:12:30 localhost sshd[703]: Server listening on :: port 22.
Jan 22 09:36:43 localhost sshd[702]: Server listening on 0.0.0.0 port 22.
Jan 22 09:36:43 localhost sshd[702]: Server listening on :: port 22.
Jan 22 09:37:18 localhost sshd[1245]: Accepted password for tom from 10.7.2.1 port 56262 ssh2
Jan 22 09:37:18 localhost sshd[1245]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Jan 22 10:00:21 localhost sshd[702]: Server listening on 0.0.0.0 port 22.
Jan 22 10:00:21 localhost sshd[702]: Server listening on :: port 22.
Jan 22 10:01:46 localhost sshd[700]: Server listening on 0.0.0.0 port 22.
Jan 22 10:01:46 localhost sshd[700]: Server listening on :: port 22.
Jan 22 10:07:33 localhost sshd[710]: Server listening on 0.0.0.0 port 22.
Jan 22 10:07:33 localhost sshd[710]: Server listening on :: port 22.
Jan 22 10:15:33 localhost sshd[711]: Server listening on 0.0.0.0 port 22.
Jan 22 10:15:33 localhost sshd[711]: Server listening on :: port 22.
Jan 22 10:21:07 localhost sshd[712]: Server listening on 0.0.0.0 port 22.
Jan 22 10:21:07 localhost sshd[712]: Server listening on :: port 22.
Jan 22 10:21:23 localhost sshd[1258]: Accepted password for tom from 10.1.1.1 port 57500 ssh2
Jan 22 10:21:23 localhost sshd[1258]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Jan 22 10:22:36 localhost sshd[1263]: Received disconnect from 10.1.1.1 port 57500:11: disconnected by user
Jan 22 10:22:36 localhost sshd[1263]: Disconnected from user tom 10.1.1.1 port 57500
Jan 22 10:22:36 localhost sshd[1258]: pam_unix(sshd:session): session closed for user tom
Jan 22 10:22:40 localhost sshd[1302]: Accepted password for tom from 10.1.1.1 port 57572 ssh2
Jan 22 10:22:40 localhost sshd[1302]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Jan 22 10:23:09 localhost sshd[1306]: Received disconnect from 10.1.1.1 port 57572:11: disconnected by user
Jan 22 10:23:09 localhost sshd[1306]: Disconnected from user tom 10.1.1.1 port 57572
Jan 22 10:23:09 localhost sshd[1302]: pam_unix(sshd:session): session closed for user tom
Jan 22 10:23:13 localhost sshd[1369]: Accepted password for tom from 10.1.1.1 port 57593 ssh2
Jan 22 10:23:13 localhost sshd[1369]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
Jan 22 10:55:58 localhost sshd[1373]: Received disconnect from 10.1.1.1 port 57593:11: disconnected by user
Jan 22 10:55:58 localhost sshd[1373]: Disconnected from user tom 10.1.1.1 port 57593
Jan 22 10:55:58 localhost sshd[1369]: pam_unix(sshd:session): session closed for user tom
Jan 22 10:56:05 localhost sshd[1462]: Accepted password for tom from 10.1.1.1 port 58687 ssh2
Jan 22 10:56:05 localhost sshd[1462]: pam_unix(sshd:session): session opened for user tom(uid=1000) by (uid=0)
```

🌞 Trouver le chemin du fichier de configuration du serveur SSH

```
[tom@TP1 ssh]$ sudo cat ssh_config
#       $OpenBSD: ssh_config,v 1.35 2020/07/17 03:43:42 dtucker Exp $

# This is the ssh client system-wide configuration file.  See
# ssh_config(5) for more information.  This file provides defaults for
# users, and the values can be changed in per-user configuration files
# or on the command line.

# Configuration data is parsed as follows:
#  1. command line options
#  2. user-specific file
#  3. system-wide file
# Any configuration value is only changed the first time it is set.
# Thus, host-specific definitions should be at the beginning of the
# configuration file, and defaults at the end.

# Site-wide defaults for some commonly used options.  For a comprehensive
# list of available options, their meanings and defaults, please see the
# ssh_config(5) man page.

# Host *
#   ForwardAgent no
#   ForwardX11 no
#   PasswordAuthentication yes
#   HostbasedAuthentication no
#   GSSAPIAuthentication no
#   GSSAPIDelegateCredentials no
#   GSSAPIKeyExchange no
#   GSSAPITrustDNS no
#   BatchMode no
#   CheckHostIP yes
#   AddressFamily any
#   ConnectTimeout 0
#   StrictHostKeyChecking ask
#   IdentityFile ~/.ssh/id_rsa
#   IdentityFile ~/.ssh/id_dsa
#   IdentityFile ~/.ssh/id_ecdsa
#   IdentityFile ~/.ssh/id_ed25519
#   Port 22
#   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
#   MACs hmac-md5,hmac-sha1,umac-64@openssh.com
#   EscapeChar ~
#   Tunnel no
#   TunnelDevice any:any
#   PermitLocalCommand no
#   VisualHostKey no
#   ProxyCommand ssh -q -W %h:%p gateway.example.com
#   RekeyLimit 1G 1h
#   UserKnownHostsFile ~/.ssh/known_hosts.d/%k
#
# This system is following system-wide crypto policy.
# To modify the crypto properties (Ciphers, MACs, ...), create a  *.conf
#  file under  /etc/ssh/ssh_config.d/  which will be automatically
# included below. For more information, see manual page for
#  update-crypto-policies(8)  and  ssh_config(5).
Include /etc/ssh/ssh_config.d/*.conf
```
# II. Users 

1. Nouveau user

🌞 Créer un nouvel utilisateur

```
[tom@TP1 home]$ sudo useradd -m -d /home/papier_alu/marmotte -s /bin/bash marmotte
[sudo] password for tom:
Creating mailbox file: File exists
[tom@TP1 home]$ sudo passwd marmotte
Changing password for user marmotte.
New password:
BAD PASSWORD: The password is shorter than 8 characters
Retype new password:
Sorry, passwords do not match.
New password:
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password:
passwd: all authentication tokens updated successfully.
[tom@TP1 home]$ ls
papier_alu  tom  
[tom@TP1 home]$ cd papier_alu/
[tom@TP1 papier_alu]$ ls
marmotte
[tom@TP1 papier_alu]$
```

2. Infos enregistrées par le système

🌞 Prouver que cet utilisateur a été créé

```
[tom@TP1 home]$ sudo cat /etc/passwd | grep marmotte
marmotte:x:1001:1001::/home/papier_alu/marmotte:/bin/bash
```

🌞 Déterminer le hash du password de l'utilisateur marmotte

```
[tom@TP1 /]$ sudo cat /etc/shadow | grep marmotte
marmotte:$6$LpgK2VKGiGqgbIRN$kozxlYFUEVlVtlaDtg4Z.cqWLE2V2ZUGqSOKfPsV3WFj4ffNnHnT8WazYDeQ8KZFbbe7Y9DG3IdR5Dfz7mcAS.:19744:0:99999:7:::
```

3. Connexion sur le nouvel utilisateur

🌞 Tapez une commande pour vous déconnecter : fermer votre session utilisateur

```
[tom@TP1 /]$ exit
logout
Connection to 10.1.1.10 closed.

```

🌞 Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur marmotte

```
PS C:\Users\tomma> ssh marmotte@10.1.1.10
marmotte@10.1.1.10's password:
Last login: Mon Jan 22 11:54:29 2024
[marmotte@TP1 ~]$ cd ../
[marmotte@TP1 papier_alu]$ cd ../
[marmotte@TP1 home]$ ls
papier_alu  tom
[marmotte@TP1 home]$ cd tom | ls
-bash: cd: tom: Permission denied
papier_alu  tom
[marmotte@TP1 home]$
```

# Partie 2 : Programmes et paquets

# I. Programmes et processus

1. Run then kill 

```
TERMINALE 1
[tom@TP1 ~]$ sleep 10000
```
```
TERMINALE 2
[tom@TP1 /]$ ps aux | grep sleep
tom         1334  0.0  0.0   5584  1020 pts/0    S+   16:35   0:00 sleep 10000
tom         1330  0.0  0.1   6408  2300 pts/1    S+   16:31   0:00 grep --color=auto sleep
```

🌞 Terminez le processus sleep depuis le deuxième terminal

```
[tom@TP1 /]$ ps aux | grep sleep
tom         1351  0.0  0.0   5584  1020 pts/0    S+   16:35   0:00 sleep 10000
tom         1353  0.0  0.1   6408  2300 pts/1    S+   16:35   0:00 grep --color=auto sleep
[tom@TP1 /]$ kill 1351
[tom@TP1 /]$ ps aux | grep sleep
tom         1355  0.0  0.1   6408  2300 pts/1    S+   16:35   0:00 grep --color=auto sleep
[tom@TP1 /]$
```

2. Tâche de fond

🌞 Lancer un nouveau processus sleep, mais en tâche de fond

```
[tom@TP1 ~]$ sleep 1000 &
[1] 1314
```

🌞 Visualisez la commande en tâche de fond

```
 [tom@TP1 ~]$ ps aux | grep sleep &
[2] 1316
[tom@TP1 ~]$ tom         1314  0.0  0.0   5584  1016 pts/0    S    17:52   0:00 sleep 1000
tom         1316  0.0  0.1   6408  2296 pts/0    S    17:53   0:00 grep --color=auto sleep
[tom@TP1 ~]$ jobs
[1]+  Running                 sleep 1000 &
```

3. Find paths

🌞 Trouver le chemin où est stocké le programme sleep

```
[tom@TP1 ~]$ which sleep
/usr/bin/sleep
[tom@TP1 ~]$ ls -al /usr/bin/ | grep sleep
-rwxr-xr-x.  1 root root   36312 Apr 24  2023 sleep
```

🌞 Tant qu'on est à chercher des chemins : trouver les chemins vers tous les fichiers qui s'appellent .bashrc

```
[tom@TP1 ~]$ sudo find / -name "*.bashrc"
[sudo] password for tom:
/etc/skel/.bashrc
/root/.bashrc
/home/tom/.bashrc
/home/papier_alu/marmotte/.bashrc
```


4. La variable PATH


🌞 Vérifier que
```
[tom@TP1 ~]$ echo $PATH
/home/tom/.local/bin:/home/tom/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
```
```
[tom@TP1 ~]$ which sleep
/usr/bin/sleep
[tom@TP1 ~]$ ls -al /usr/bin/sleep
-rwxr-xr-x. 1 root root 36312 Apr 24  2023 /usr/bin/sleep
```
```
[tom@TP1 ~]$ which ssh
/usr/bin/ssh
[tom@TP1 ~]$ ls -al /usr/bin/ssh
-rwxr-xr-x. 1 root root 859480 Nov  2 20:34 /usr/bin/ssh
```
```
[tom@TP1 ~]$ which ping
/usr/bin/ping
[tom@TP1 ~]$ ls -al /usr/bin/ping
-rwxr-xr-x. 1 root root 78336 Oct 31 04:00 /usr/bin/ping
```

# II. Paquets

🌞 Installer le paquet git
```
[tom@TP1 ~]$ sudo dnf install git
Rocky Linux 9 - BaseOS                                                                                                      400  B/s | 4.1 kB     00:10
Rocky Linux 9 - AppStream                                                                                                   444  B/s | 4.5 kB     00:10
Rocky Linux 9 - Extras                                                                                                      279  B/s | 2.9 kB     00:10
Dependencies resolved.
============================================================================================================================================================
 Package                                      Architecture                 Version                                    Repository                       Size
============================================================================================================================================================
Installing:
 git
.
.
.
.
.
 Complete!
```

🌞 Utiliser une commande pour lancer git        

```
[tom@TP1 ~]$ which git
/usr/bin/git
[tom@TP1 ~]$ ls -al /usr/bin/git
-rwxr-xr-x. 1 root root 3960424 May 22  2023 /usr/bin/git
```

🌞 Installer le paquet nginx

```
[tom@TP1 ~]$ sudo dnf install nginx
.
.
.
Installed:
  nginx-1:1.20.1-14.el9_2.1.x86_64 nginx-core-1:1.20.1-14.el9_2.1.x86_64 nginx-filesystem-1:1.20.1-14.el9_2.1.noarch rocky-logos-httpd-90.14-2.el9.noarch

Complete!

```

🌞 Déterminer

```
[tom@TP1 /]$ ls
afs  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[tom@TP1 /]$ cd var
[tom@TP1 var]$ ls
adm  cache  crash  db  empty  ftp  games  kerberos  lib  local  lock  log  mail  nis  opt  preserve  run  spool  tmp  yp
[tom@TP1 var]$ cd log
[tom@TP1 log]$ ls
anaconda  btmp    cron             dnf.log      firewalld   kdump.log  maillog   nginx    README  spooler  tallylog
audit     chrony  dnf.librepo.log  dnf.rpm.log  hawkey.log  lastlog    messages  private  secure  sssd     wtmp
```

```
[tom@TP1 ~]$ which nginx
/usr/sbin/nginx
[tom@TP1 ~]$ ls -al /usr/sbin/nginx
-rwxr-xr-x. 1 root root 1329000 Oct 16 20:00 /usr/sbin/nginx
```

🌞 Mais aussi déterminer...

```
[tom@TP1 ~]$ cat /etc/yum.repos.d/*.repo | grep https
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever$rltype*
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=HighAvailability-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=ResilientStorage-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=NFV-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=plus-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=plus-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=plus-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=AppStream-$releasever-source$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever-debug$rltype
mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=CRB-$releasever-source$rltype
```
#   Partie 3 : Poupée russe

🌞 Récupérer le fichier meow
```
 sudo dnf install wget
Last metadata expiration check: 0:44:08 ago on Tue 23 Jan 2024 09:38:05 AM CET.
Dependencies resolved.
============================================================================================================================================================
 Package                          Architecture                       Version                                    Repository                             Size
============================================================================================================================================================
Installing:
 wget                             x86_64                             1.21.1-7.el9                               appstream                             769 k

```

```
[tom@TP1 /]$ sudo wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow
--2024-01-23 10:22:51--  https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow
Resolving gitlab.com (gitlab.com)... 172.65.251.78, 2606:4700:90:0:f22e:fbec:5bed:a9b9
Connecting to gitlab.com (gitlab.com)|172.65.251.78|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 18016947 (17M) [application/octet-stream]
Saving to: ‘meow’

meow                                   100%[============================================================================>]  17.18M  6.19MB/s    in 2.8s

2024-01-23 10:22:59 (6.19 MB/s) - ‘meow’ saved [18016947/18016947]
``` 

🌞 Trouver le dossier dawa/

```

```