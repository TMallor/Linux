#!/bin/bash
#tom
# youtube telechargement 

video_url="$1"

download_dir="/srv/yt/downloads"

log_dir="/var/log/yt"

log_file="$log_dir/download.log"

if [ ! -d "$log_dir" ]; then
    sudo mkdir -p "$log_dir"
fi

if [ ! -d "$download_dir" ]; then
    echo "Error: Download directory $download_dir does not exist. Exiting."
    exit 1
fi

youtube_dl_path="/usr/local/bin/youtube-dl"  # Replace with the actual path

youtube_dl_command="cd $download_dir && sudo $youtube_dl_path $video_url"

download_output=$(eval "$youtube_dl_command" 2>&1)

timestamp=$(date +"%y/%m/%d %H:%M:%S")
log_line="[$timestamp] Video $video_url was downloaded. File path : $download_output"
echo "$log_line" | sudo tee -a "$log_file" > /dev/null

echo "$log_line"


    