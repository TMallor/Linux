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