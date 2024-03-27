# Partie 1 : Mise en place et maîtrise du serveur Web
## 1. Installation

🌞 Installer le serveur Apache

```
[tom@WEB-TP6 ~]$ sudo dnf install httpd
Installed:
  apr-1.7.0-12.el9_3.x86_64            apr-util-1.6.1-23.el9.x86_64
  apr-util-bdb-1.6.1-23.el9.x86_64     apr-util-openssl-1.6.1-23.el9.x86_64
  httpd-2.4.57-5.el9.x86_64            httpd-core-2.4.57-5.el9.x86_64
  httpd-filesystem-2.4.57-5.el9.noarch httpd-tools-2.4.57-5.el9.x86_64
  mailcap-2.1.49-5.el9.noarch          mod_http2-1.15.19-5.el9.x86_64
  mod_lua-2.4.57-5.el9.x86_64          rocky-logos-httpd-90.15-2.el9.noarch

Complete!

```
```
[tom@WEB-TP6 ~]$ sudo cat /etc/httpd/conf/httpd.conf

ServerRoot "/etc/httpd"

Listen 80

Include conf.modules.d/*.conf

User apache
Group apache


ServerAdmin root@localhost


<Directory />
    AllowOverride none
    Require all denied
</Directory>


DocumentRoot "/var/www/html"

<Directory "/var/www">
    AllowOverride None
    Require all granted
</Directory>

<Directory "/var/www/html">
    Options Indexes FollowSymLinks

    AllowOverride None

    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

<Files ".ht*">
    Require all denied
</Files>

ErrorLog "logs/error_log"

LogLevel warn

<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common

    <IfModule logio_module>
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
    </IfModule>


    CustomLog "logs/access_log" combined
</IfModule>

<IfModule alias_module>


    ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"

</IfModule>

<Directory "/var/www/cgi-bin">
    AllowOverride None
    Options None
    Require all granted
</Directory>

<IfModule mime_module>
    TypesConfig /etc/mime.types

    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz



    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
</IfModule>

AddDefaultCharset UTF-8

<IfModule mime_magic_module>
    MIMEMagicFile conf/magic
</IfModule>


EnableSendfile on

IncludeOptional conf.d/*.conf

```

🌞 Démarrer le service Apache

```
[tom@WEB-TP6 ~]$ sudo systemctl start httpd
[tom@WEB-TP6 ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
[tom@WEB-TP6 ~]$ sudo firewall-cmd --add-service=http --permanent
success
[tom@WEB-TP6 ~]$ sudo firewall-cmd --add-service=https --permanent
success
[tom@WEB-TP6 ~]$ sudo firewall-cmd --reload
success
[tom@WEB-TP6 ~]$ sudo ss -tlnp | grep httpd
LISTEN 0      511                *:80              *:*    users:(("httpd",pid=1612,fd=4),("httpd",pid=1611,fd=4),("httpd",pid=1610,fd=4),("httpd",pid=1608,fd=4))


```

🌞 TEST

###### vérifier que le service est démarré
```
[tom@WEB-TP6 ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; preset>
     Active: active (running) since Wed 2024-03-20 11:22:28 CET; 1min 39s a>
       Docs: man:httpd.service(8)
   Main PID: 1608 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; B>
      Tasks: 213 (limit: 11115)
     Memory: 23.2M
        CPU: 169ms
     CGroup: /system.slice/httpd.service
             ├─1608 /usr/sbin/httpd -DFOREGROUND
             ├─1609 /usr/sbin/httpd -DFOREGROUND
             ├─1610 /usr/sbin/httpd -DFOREGROUND
             ├─1611 /usr/sbin/httpd -DFOREGROUND
             └─1612 /usr/sbin/httpd -DFOREGROUND

Mar 20 11:22:28 WEB-TP6 systemd[1]: Starting The Apache HTTP Server...
Mar 20 11:22:28 WEB-TP6 httpd[1608]: AH00558: httpd: Could not reliably det>
Mar 20 11:22:28 WEB-TP6 systemd[1]: Started The Apache HTTP Server.
Mar 20 11:22:28 WEB-TP6 httpd[1608]: Server configured, listening on: port >
lines 1-20/20 (END)
```
###### vérifier qu'il est configuré pour démarrer automatiquement
```
[tom@WEB-TP6 ~]$ sudo systemctl is-enabled httpd
enabled
```

###### vérifier avec une commande curl localhost que vous joignez votre serveur web localement
```
[tom@WEB-TP6 ~]$ curl localhost
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
###### vérifier depuis votre PC que vous accéder à la page par défaut
```
[tom@WEB-TP6 ~]$ curl 10.6.1.11
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

## 2. Avancer vers la maîtrise du service

🌞 Le service Apache...
```
[tom@WEB-TP6 httpd]$ sudo cat /lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#       [Service]
#       Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

🌞 Déterminer sous quel utilisateur tourne le processus Apache
###### mettez en évidence la ligne dans le fichier de conf principal d'Apache (httpd.conf) qui définit quel user est utilisé
```
[tom@WEB-TP6 httpd]$ grep "User" /etc/httpd/conf/httpd.conf
User apache
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
      LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
```

###### utilisez la commande ps -ef pour visualiser les processus en cours d'exécution et confirmer que apache tourne bien sous l'utilisateur mentionné dans le fichier de conf
```
[tom@WEB-TP6 ~]$ ps -ef | grep apache
apache      1609    1608  0 11:22 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1610    1608  0 11:22 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1611    1608  0 11:22 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache      1612    1608  0 11:22 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
tom         1960    1263  0 12:03 pts/0    00:00:00 grep --color=auto apach
```
###### la page d'accueil d'Apache se trouve dans /usr/share/testpage/
```
[tom@WEB-TP6 ~]$ ls -al /usr/share/testpage/
total 12
drwxr-xr-x.  2 root root   24 Mar 20 11:12 .
drwxr-xr-x. 83 root root 4096 Mar 20 11:12 ..
-rw-r--r--.  1 root root 7620 Feb 21 14:12 index.html
```

🌞 Changer l'utilisateur utilisé par Apache
```
[tom@web-tp6 ~]$ grep apache /etc/passwd
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
[tom@web-tp6 ~]$ sudo useradd -m -d /usr/share/httpd -s /sbin/nologin Jojo
useradd: warning: the home directory /usr/share/httpd already exists.
useradd: Not copying any file from skel directory into it.
```
```
[tom@web-tp6 ~]$ sudo sed -i 's/User apache/User Jojo/' /etc/httpd/conf/httpd.conf
[tom@web-tp6 ~]$ grep "User" /etc/httpd/conf/httpd.conf
User Jojo

```
```
[tom@web-tp6 ~]$ sudo systemctl restart httpd
[tom@web-tp6 ~]$ ps -ef | grep httpd
root        1938       1  0 15:14 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
Jojo        1939    1938  0 15:14 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
Jojo        1940    1938  0 15:14 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
Jojo        1941    1938  0 15:14 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
Jojo        1942    1938  0 15:14 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
tom         2155    1313  0 15:14 pts/0    00:00:00 grep --color=auto httpd
```

🌞 Faites en sorte que Apache tourne sur un autre port

###### modifiez la configuration d'Apache pour lui demander d'écouter sur un autre port de votre choix
```
[tom@web-tp6 ~]$ grep "Listen" /etc/httpd/conf/httpd.conf
Listen 80
[tom@web-tp6 ~]$ sudo sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
[tom@web-tp6 ~]$ grep "Listen" /etc/httpd/conf/httpd.conf
Listen 8080
```
###### ouvrez ce nouveau port dans le firewall, et fermez l'ancien
```
[tom@web-tp6 ~]$ sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
success
[tom@web-tp6 ~]$ sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
Warning: NOT_ENABLED: 80:tcp
success
[tom@web-tp6 ~]$ sudo firewall-cmd --reload
success
[tom@web-tp6 ~]$

```
###### redémarrez Apache
```
[tom@web-tp6 ~]$ sudo systemctl restart httpd
[tom@web-tp6 ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; preset>
     Active: active (running) since Wed 2024-03-20 15:18:30 CET; 13s ago
```
###### prouvez avec une commande ss que Apache tourne bien sur le nouveau port choisi
```
[tom@web-tp6 ~]$ ss -tuln | grep 8080
tcp   LISTEN 0      511                *:8080            *:*
```
###### vérifiez avec curl en local que vous pouvez joindre Apache sur le nouveau port
```
[tom@web-tp6 ~]$ curl localhost:8080
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

## Partie 2 : Mise en place et maîtrise du serveur de base de données
🌞 Install de MariaDB sur db.tp6.linux
```
[tom@db-tp6 ~]$ sudo dnf install mariadb-server
Last metadata expiration check: 0:04:40 ago on Mon 25 Mar 2024 10:02:03 AM CET.
Package mariadb-server-3:10.5.22-1.el9_2.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!

```
```
[tom@db-tp6 ~]$ sudo systemctl enable mariadb
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
[tom@db-tp6 ~]$

```
```
[tom@db-tp6 ~]$ sudo systemctl start mariadb

```

🌞 Port utilisé par MariaDB
```
[tom@db-tp6 ~]$ ss -tuln | grep 3306
tcp   LISTEN 0      80                 *:3306            *:*

[tom@db-tp6 ~]$ sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
success
[tom@db-tp6 ~]$ sudo firewall-cmd --reload
success
[tom@db-tp6 ~]$
```
🌞 Processus liés à MariaDB
```
[tom@db-tp6 ~]$  ps aux | grep mariadb
mysql       3615  0.0  5.5 1085364 101400 ?      Ssl  10:08   0:00 /usr/libexec/mariadbd --basedir=/usr
tom         3927  0.0  0.1   6408  2280 pts/0    S+   11:11   0:00 grep --color=auto mariadb
```

## Partie 3 : Configuration et mise en place de NextCloud
### 1. Base de données

🌞 Préparation de la base pour NextCloud 
```
MariaDB [(none)]> CREATE USER 'nextcloud'@'10.6.1.11' IDENTIFIED BY 'pewpewpew';
REATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.6.1.11';
FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.074 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.6.1.11';
Query OK, 0 rows affected (0.003 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)

```

🌞 Exploration de la base de données

```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)

mysql> USE nextcloud
Database changed
mysql>  
Empty set (0.00 sec)
```

🌞 Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données

```
[tom@web-tp6 ~]$ mysql -u root -h 10.6.1.12 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 5.5.5-10.5.22-MariaDB MariaDB Server

Copyright (c) 2000, 2024, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SELECT User, Host FROM mysql.user;
+-------------+-----------+
| User        | Host      |
+-------------+-----------+
| nextcloud   | 10.6.1.11 |
| root        | 10.6.1.11 |
| mariadb.sys | localhost |
| mysql       | localhost |
| root        | localhost |
+-------------+-----------+
5 rows in set (0.01 sec)

```

### 2. Serveur Web et NextCloud
```
 sudo vim /etc/httpd/conf/httpd.conf
  sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
   sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent
   sudo firewall-cmd --reload
   sudo systemctl restart httpd

```
🌞 Install de PHP
```
[tom@web-tp6 ~]$ sudo dnf install php

Installed:
  libxslt-1.1.34-9.el9.x86_64         nginx-filesystem-1:1.20.1-14.el9_2.1.noarch   oniguruma-6.9.6-1.el9.5.x86_64   php-8.0.30-1.el9_2.x86_64
  php-cli-8.0.30-1.el9_2.x86_64       php-common-8.0.30-1.el9_2.x86_64              php-fpm-8.0.30-1.el9_2.x86_64    php-mbstring-8.0.30-1.el9_2.x86_64
  php-opcache-8.0.30-1.el9_2.x86_64   php-pdo-8.0.30-1.el9_2.x86_64                 php-xml-8.0.30-1.el9_2.x86_64

Complete!
```
🌞 Récupérer NextCloud

```
 sudo mkdir /var/www/tp6_nextcloud/
  ls /var/www/tp6_nextcloud/

```
```
 sudo dnf install wget
   34  wget https://download.nextcloud.com/server/releases/latest.zip
   35  ls
   36  mv latest.zip /var/www/tp6_nextcloud/
   37  sudo mv latest.zip /var/www/tp6_nextcloud/
   38  cd /var/www/tp6_nextcloud/
   39  ls
   40  sudo unzip latest.zip
   41  sudo dnf install unzip
   42  sudo unzip latest.zip
[tom@web-tp6 tp6_nextcloud]$ ls
latest.zip  nextcloud
[tom@web-tp6 tp6_nextcloud]$ cd nextcloud/
[tom@web-tp6 nextcloud]$ ls
3rdparty  composer.json  console.php  cron.php    index.php  ocs           package-lock.json  resources   themes
apps      composer.lock  COPYING      dist        lib        ocs-provider  public.php         robots.txt  updater
AUTHORS   config         core         index.html  occ        package.json  remote.php         status.php  version.php
[tom@web-tp6 nextcloud]$ cd ../
[tom@web-tp6 tp6_nextcloud]$ sudo mv nextcloud/* ./
[tom@web-tp6 tp6_nextcloud]$ ls
3rdparty  composer.json  console.php  cron.php    index.php   nextcloud  ocs-provider       public.php  robots.txt  updater
apps      composer.lock  COPYING      dist        latest.zip  occ        package.json       remote.php  status.php  version.php
AUTHORS   config         core         index.html  lib         ocs        package-lock.json  resources   themes
[tom@web-tp6 tp6_nextcloud]$ cd nextcloud/
[tom@web-tp6 nextcloud]$ ls -al
total 12
drwxr-xr-x.  2 root root   40 Mar 26 11:09 .
drwxr-xr-x. 14 root root 4096 Mar 26 11:09 ..
-rw-r--r--.  1 root root 3993 Feb 29 08:46 .htaccess
-rw-r--r--.  1 root root  101 Feb 29 08:46 .user.ini
[tom@web-tp6 nextcloud]$ cd ../
[tom@web-tp6 tp6_nextcloud]$ sudo rmdir nextcloud
rmdir: failed to remove 'nextcloud': Directory not empty
[tom@web-tp6 tp6_nextcloud]$ sudo rmdir nextcloud
rmdir: failed to remove 'nextcloud': Directory not empty
[tom@web-tp6 tp6_nextcloud]$ ls
3rdparty  composer.json  console.php  cron.php    index.php   nextcloud  ocs-provider       public.php  robots.txt  updater
apps      composer.lock  COPYING      dist        latest.zip  occ        package.json       remote.php  status.php  version.php
AUTHORS   config         core         index.html  lib         ocs        package-lock.json  resources   themes
[tom@web-tp6 tp6_nextcloud]$ sudo rm -r nextcloud/
[tom@web-tp6 tp6_nextcloud]$ ls
3rdparty  composer.json  console.php  cron.php    index.php   occ           package.json       remote.php  status.php  version.php
apps      composer.lock  COPYING      dist        latest.zip  ocs           package-lock.json  resources   themes
AUTHORS   config         core         index.html  lib         ocs-provider  public.php         robots.txt  updater
[tom@web-tp6 tp6_nextcloud]$  sudo chown -R apache:apache /var/www/tp6_nextcloud/
[tom@web-tp6 tp6_nextcloud]$ ls -al /var/www/tp6_nextcloud/
total 216512
drwxr-xr-x. 13 apache apache      4096 Mar 26 11:10 .
drwxr-xr-x.  5 root   root          54 Mar 26 10:59 ..
drwxr-xr-x. 44 apache apache      4096 Feb 29 08:49 3rdparty
drwxr-xr-x. 50 apache apache      4096 Feb 29 08:47 apps
-rw-r--r--.  1 apache apache     23796 Feb 29 08:46 AUTHORS
-rw-r--r--.  1 apache apache      1906 Feb 29 08:46 composer.json
-rw-r--r--.  1 apache apache      3140 Feb 29 08:46 composer.lock
drwxr-xr-x.  2 apache apache        67 Feb 29 08:49 config
-rw-r--r--.  1 apache apache      4124 Feb 29 08:46 console.php
-rw-r--r--.  1 apache apache     34520 Feb 29 08:46 COPYING
drwxr-xr-x. 24 apache apache      4096 Feb 29 08:49 core
-rw-r--r--.  1 apache apache      6317 Feb 29 08:46 cron.php
drwxr-xr-x.  2 apache apache     12288 Feb 29 08:46 dist
-rw-r--r--.  1 apache apache       156 Feb 29 08:46 index.html
-rw-r--r--.  1 apache apache      4403 Feb 29 08:46 index.php
-rw-r--r--.  1 apache apache 220492795 Feb 29 08:52 latest.zip
drwxr-xr-x.  6 apache apache       125 Feb 29 08:46 lib
-rw-r--r--.  1 apache apache       283 Feb 29 08:46 occ
drwxr-xr-x.  2 apache apache        55 Feb 29 08:46 ocs
drwxr-xr-x.  2 apache apache        23 Feb 29 08:46 ocs-provider
-rw-r--r--.  1 apache apache      7072 Feb 29 08:46 package.json
-rw-r--r--.  1 apache apache   1044055 Feb 29 08:46 package-lock.json
-rw-r--r--.  1 apache apache      3187 Feb 29 08:46 public.php
-rw-r--r--.  1 apache apache      5597 Feb 29 08:46 remote.php
drwxr-xr-x.  4 apache apache       133 Feb 29 08:46 resources
-rw-r--r--.  1 apache apache        26 Feb 29 08:46 robots.txt
-rw-r--r--.  1 apache apache      2452 Feb 29 08:46 status.php
drwxr-xr-x.  3 apache apache        35 Feb 29 08:46 themes
drwxr-xr-x.  2 apache apache        43 Feb 29 08:47 updater
-rw-r--r--.  1 apache apache       403 Feb 29 08:49 version.php   
```

🌞 Adapter la configuration d'Apache

```
[tom@web-tp6 ~]$ sudo tail -n 5 /etc/httpd/conf/httpd.conf
[sudo] password for tom:


EnableSendfile on

IncludeOptional conf.d/*.conf
```
```
[tom@web-tp6 ~]$ sudo nano /etc/httpd/conf.d/nextcloud.conf
[tom@web-tp6 ~]$ sudo cat /etc/httpd/conf.d/nextcloud.conf
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp6_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web.tp6.linux

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp6_nextcloud/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
[tom@web-tp6 ~]$
```

🌞 Redémarrer le service Apache pour qu'il prenne en compte le nouveau fichier de conf

```
[tom@web-tp6 ~]$ sudo systemctl restart httpd
```

🌞 Installez les deux modules PHP dont NextCloud vous parle
```
[tom@web-tp6 ~]$ sudo dnf install php-json
Last metadata expiration check: 0:34:40 ago on Tue 26 Mar 2024 10:54:19 AM CET.
Package php-common-8.0.30-1.el9_2.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[tom@web-tp6 ~]$ sudo dnf install php-mysqlnd
Last metadata expiration check: 0:35:38 ago on Tue 26 Mar 2024 10:54:19 AM CET.
Package php-mysqlnd-8.0.30-1.el9_2.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!

```
🌞 Pour que NextCloud utilise la base de données, ajoutez aussi
```
[tom@web-tp6 ~]$ sudo dnf install php-pdo
Last metadata expiration check: 0:36:19 ago on Tue 26 Mar 2024 10:54:19 AM CET.
Package php-pdo-8.0.30-1.el9_2.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
[tom@web-tp6 ~]$ sudo dnf install php-mysqlnd
Last metadata expiration check: 0:36:26 ago on Tue 26 Mar 2024 10:54:19 AM CET.
Package php-mysqlnd-8.0.30-1.el9_2.x86_64 is already installed.
Dependencies resolved.
Nothing to do.
Complete!
```

🌞 Exploration de la base de données
```
MariaDB [(none)]> SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'nextcloud' AND table_name LIKE 'oc_%';
+----------+
| COUNT(*) |
+----------+
|      102 |
+----------+
1 row in set (0.002 sec)

```