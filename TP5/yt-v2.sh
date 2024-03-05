    #!/bin/bash
    #tom
    # youtube telechargement 2



# Définition des variables
downloads_dir="/srv/yt/downloads" 
logs_dir="/var/log/yt"
date="$(date '+[%y:%m:%d %H:%M:%S]')" 
file_dir="/srv/yt/urls" 

# Vérification que le dossier download existe
if [ ! -d "$downloads_dir" ]; then
    exit 1
fi

# Vérification que le dossier logs existe
if [ ! -d $logs_dir ]; then
    exit 1
fi

# Vérification que le fichier d'URLs existe
while :; do
    file_content=$(cat $file_dir) 
    if [[ ! -z $file_content ]]; then 
        echo "$file_content" | while read url; do 
            if [[ $url == https* ]]; then 
                title=$(/usr/local/bin/youtube-dl -e "${url}") 
                
                if [ -d "/srv/yt/downloads/${title}" ]; then
                    echo "Une vidéo avec le même titre a déjà été downloaded. Avant de télécharger ou retélécharger, vous devez la supprimer"
                else
                    mkdir "/srv/yt/downloads/${title}" 
                fi
                /usr/local/bin/youtube-dl -o "/srv/yt/downloads/$title/$title.mp4" --format mp4 $url > /dev/null 
                /usr/local/bin/youtube-dl --get-description "${url}" > "/srv/yt/downloads/$title/description" 
                echo "Video ${url} was downloaded." 
                echo "File path : /srv/yt/downloads/$title/$title.mp4"  
                
                echo "[${date}] Video ${url} was downloaded. File path : ${downloads_dir}/${title}" >> /var/log/yt/download.log
            fi
        done
        echo "" > $file_dir 
    fi
    sleep 10 
done