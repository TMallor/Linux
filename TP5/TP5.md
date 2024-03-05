# Partie 1 : Script carte d'identité

## Rendu

###### 📁 Fichier /srv/idcard/idcard.sh

[idcard.sh](idcard.sh)

🌞 Vous fournirez dans le compte-rendu Markdown, en plus du fichier, un exemple d'exécution avec une sortie

```
[tom@TP5 idcard]$ /srv/idcard/idcard.sh
Machine-name
TP5

OS_name
Rocky Linux release 9.3 (Blue Onyx)

Kernel_version
Linux TP5 5.14.0-362.18.1.el9_3.0.1.x86_64 #1 SMP PREEMPT_DYNAMIC Sun Feb 11 13:49:23 UTC 2024 x86_64 x86_64 x86_64 GNU/Linux

IP_adress
10.5.1.3
10.0.3.15

Ram_condition
Used: 303 Mo, Available: 1460 Mo, Total: 1763 Mo

Disk_info
Total space: 17G, Used space: 1.5G, Free space: 16G

Top 5 processes by RAM usage
667 firewalld 2.3%
678 NetworkManager 1.3%
1 systemd 0.8%
1222 systemd 0.7%
668 systemd-logind 0.7%

Listening_ports
 - 127.0.0.1:323 udp
 - [::1]:323 udp
 - 0.0.0.0:22 tcp
 - [::]:22 tcp

PATH_directories
 - /home/tom/.local/bin
 - /home/tom/bin
 - /usr/local/bin
 - /usr/bin
 - /usr/local/sbin
 - /usr/sbin

Random Cat Image
Here is your random cat (jpg file) :
https://cdn2.thecatapi.com/images/5d3.jpg

```

# II. Script youtube-dl

# 1. Premier script youtube-dl

## B. Rendu attendu
    

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie



📁[yt.sh](yt.sh)


```
🌞 exécution avec une sortie
[24/03/05 11:35:44] Video https://www.youtube.com/watch?v=0IhMVBUiSac was downloaded. File path : [youtube] 0IhMVBUiSac: Downloading webpage
[download] Destination: UFC 299 Benoît Saint Denis Vs Dustin Poirier - La préparation-0IhMVBUiSac.mp4
[download] 100% of 71.53MiB in 00:0293MiB/s ETA 00:004

```
```
📁 Le fichier de log /var/log/yt/download.log

[tom@TP5 ~]$ sudo cat /var/log/yt/download.log
[24/03/05 11:22:25] Video https://www.youtube.com/watch?v=YcmAlig1JMk was downloaded. File path : [youtube] YcmAlig1JMk: Downloading webpage
[youtube] YcmAlig1JMk: Downloading player 31eb286a
[download] Destination: Découvrez les secrets de la transformation physique d'INOXTAG-YcmAlig1JMk.mp4
[download] 100% of 234.87MiB in 00:0746MiB/s ETA 00:008
[24/03/05 11:26:08] Video https://www.youtube.com/watch?v=YcmAlig1JMk was downloaded. File path : [youtube] YcmAlig1JMk: Downloading webpage
[download] Découvrez les secrets de la transformation physique d'INOXTAG-YcmAlig1JMk.mp4 has already been downloaded
[download] 100% of 234.87MiB
```

# C. Rendu


📁 [yt-v2.sh](yt-v2.sh)

📁[yt.service.sh](yt.service.sh)

```    
[tom@TP5 ~]$ systemctl status yt
● yt.service - service downloads yt
     Loaded: loaded (/etc/systemd/system/yt.service; enabled; preset: disabled)
     Active: active (running) since Tue 2024-03-05 17:36:18 CET; 2s ago
   Main PID: 1601 (yt-v2.sh)
      Tasks: 2 (limit: 4673)
     Memory: 80.5M
        CPU: 26.256s
     CGroup: /system.slice/yt.service
             ├─1601 /bin/bash /srv/yt/yt-v2.sh
             └─47696 sleep 10

Tue 05 17:41:45 script systemd[1]: Started service downloads yt.
Tue 05 17:41:58 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=UK1NdDucYT4 was downloaded.
Tue 05 17:41:58 script yt-v2.sh[39405]: File path : /srv/yt/downloads/J’ai transformé Amine en véritable athlète! (-30kg)/J’ai transformé Amine en véritable athlète! (-30kg).mp4
Tue 05 17:42:12 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=S5HCZZ1ZYYk was downloaded.
Tue 05 17:42:12 script yt-v2.sh[39405]: File path : /srv/yt/downloads/J'ARNAQUE MES CLIENTS SUR SUPERMARKET SIMULATOR #4/J'ARNAQUE MES CLIENTS SUR SUPERMARKET SIMULATOR #4.mp4

```
```

Tue 05 17:41:45 script systemd[1]: Started service downloads yt.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 4438.
Tue 05 17:41:58 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=UK1NdDucYT4 was downloaded.
Tue 05 17:41:58 script yt-v2.sh[39405]: File path : /srv/yt/downloads/J’ai transformé Amine en véritable athlète! (-30kg)/J’ai transformé Amine en véritable athlète! (-30kg).mp4
Tue 05 17:42:12 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=S5HCZZ1ZYYk was downloaded.
Tue 05 17:42:12 script yt-v2.sh[39405]: File path : /srv/yt/downloads/J'ARNAQUE MES CLIENTS SUR SUPERMARKET SIMULATOR #4/J'ARNAQUE MES CLIENTS SUR SUPERMARKET SIMULATOR #4.mp4
Tue 05 17:42:26 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=RwoQwKUKpdU&t was downloaded.
Tue 05 17:42:26 script yt-v2.sh[39405]: File path : /srv/yt/downloads/Mon personnage n'a plus rien à prouver 😂 (Nightingale)/ Mon personnage n'a plus rien à prouver 😂 (Nightingale).mp4
Tue 05 17:42:39 script yt-v2.sh[39405]: Video https://www.youtube.com/watch?v=VwM9-HHKc70&t was downloaded.
Tue 05 17:42:39 script yt-v2.sh[39405]: File path : /srv/yt/downloads/ON RÉAGIT À DES VIDÉOS DE NOUS PETITS #2 !/ON RÉAGIT À DES VIDÉOS DE NOUS PETITS #2 !.mp4
lines 1061-1101/1101 (END)

```

