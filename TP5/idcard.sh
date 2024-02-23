#!/bin/bash
#tom
#tp5

echo "Nom de la machine:"
hostnamectl | grep Static

echo -n "Nom de l'OS: "
if [ -f /etc/redhat-release ]; then
    cat /etc/redhat-release
elif [ -f /etc/os-release ]; then
    source /etc/os-release
    echo "$PRETTY_NAME"
else
    echo "Information non disponible"
fi

echo "Nom du noyaux: "
uname