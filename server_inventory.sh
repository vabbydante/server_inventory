#! /bin/bash

# NOTE : This script and 'server_info.csv' and 'server_block_info.txt' files will be together in the same directory while using in real-time

server_diskinfo (){
    echo "" >> server_block_info.txt
    echo "-----------------------------------------------" >> server_block_info.txt
    ip route | awk 'NR==2{print $9}' >> server_block_info.txt
    echo "-----------------------------------------------" >> server_block_info.txt
    lsblk -a >> server_block_info.txt
}

# Variables with system values : 
server_name=$(uname -n)
ip_addr=$(ip route | awk 'NR==2{print $9}')
os_type=$(uname)
uptime=$(uptime | awk '{print $3}' | sed 's/,//')
ram_free=$(free -mt | grep Total | awk '{print $4" MB"}')
ram_total=$(free -mt | grep Total | awk '{print $2" MB"}')
cpu_name=$(lscpu | grep Model | awk 'NR==2{print $3,$4,$5,$6,$7,$8,$9,$10}')
cores=$(lscpu | awk 'NR==5{print $2}')
kernel_release=$(uname -r)

touch server_info.csv
touch server_block_info.txt
sudo chmod 777 server_info.csv server_block_info.txt
heading=$(cat server_info.csv | awk 'NR==1{print $1}')
if [ "${heading}" == "Server" ]
then
    echo "$server_name, $ip_addr, $os_type, $kernel_release, $uptime, $ram_free, $ram_total, $cpu_name, $cores" >> server_info.csv
else
    echo "Server Name, IP Address, OS Type, Kernel Release, Uptime, RAM Free, RAM Total, CPU Name, CPU Cores" > server_info.csv
    echo "$server_name, $ip_addr, $os_type, $kernel_release, $uptime, $ram_free, $ram_total, $cpu_name, $cores" >> server_info.csv
fi

heading2=$(cat server_block_info.txt | awk 'NR==1{print $1}')
if [ "${heading2}" == "DISK" ]
then
    server_diskinfo
else
    echo -e "DISK BLOCK INFORMATION REPORT\n" > server_block_info.txt
    server_diskinfo
fi
echo "Done!"