[Unit]
Description=service downloads yt

[Service]
ExecStart=/srv/yt/yt-v2.sh
User=yt

[Install]
WantedBy=multi-user.target