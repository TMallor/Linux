#!/bin/bash
#tom
#tp5



echo "Machine-name"
machine_name=$(hostnamectl --static)
echo "$machine_name"
echo


echo "OS_name"
if [ -f "/etc/redhat-release" ]; then
    os_name=$(cat /etc/redhat-release)
elif [ -f "/etc/os-release" ]; then
    source /etc/os-release
    os_name=$PRETTY_NAME
else
    os_name="Unknown"
fi
echo "$os_name"
echo


echo "Kernel_version"
kernel_version=$(uname -a)
echo "$kernel_version"
echo


echo "IP_adress"
ip_address=$(ip a | awk '/inet / && !/127.0.0.1/ {gsub("/.*", "", $2); print $2}')
echo "$ip_address"
echo


echo "Ram_condition"
ram_info=$(free -m | awk '/Mem/{print "Used: " $3 " Mo, Available: " $7 " Mo, Total: " $2 " Mo"}')
echo "$ram_info"
echo


echo "Disk_info"
disk_info=$(df -h / | awk 'NR==2{print "Total space: " $2 ", Used space: " $3 ", Free space: " $4}')
echo "$disk_info"
echo


echo "Top 5 processes by RAM usage"
top_processes=$(ps -eo pid,comm,%mem --sort=-%mem | head -6 | awk 'NR>1{print $1, $2, $3"%"}')
echo "$top_processes"
echo


echo "Listening_ports"
listening_ports=$(ss -tuln | awk 'NR>1 {print " - " $5, $1}')
echo "$listening_ports"
echo


echo "PATH_directories"
echo $PATH | tr ':' '\n' | awk '{print " - " $1}'
echo

echo "Random cat"
json_data=$(curl -s "https://api.thecatapi.com/v1/images/search")
url=$(echo "$json_data" | grep -o '"url": *"[^"]*"' | cut -d '"' -f 4)
echo -e "Here is your random cat (jpg file) :\n${url}"

