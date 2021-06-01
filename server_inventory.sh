#! /bin/bash

# NOTE : This script and 'server_info.csv' file must be together in the same directory!!!

server_name=$(uname -n)
ip_addr=$(ip route | awk 'NR==2{print $9}')
os_type=$(uname)
uptime=$(uptime | awk '{print $3}' | sed 's/,//')
ram_free=$(free -mt | grep Total | awk '{print $4" MB"}')
ram_total=$(free -mt | grep Total | awk '{print $2" MB"}')
cpu_name=$(lscpu | grep Model | awk 'NR==2{print $3,$4,$5,$6,$7,$8,$9,$10}')
cores=$(lscpu | awk 'NR==5{print $2}')
kernel_release=$(uname -r)

heading=$(cat server_info.csv | awk 'NR==1{print $10}')
if [ "${heading}" == "RAM" ]
then
    echo "$server_name, $ip_addr, $os_type, $kernel_release, $uptime, $ram_free, $ram_total, $cpu_name, $cores" >> server_info.csv
else
    echo "Server Name, IP Address, OS Type, Kernel Release, Uptime, RAM Free, RAM Total, CPU Name, CPU Cores" > server_info.csv
    echo "$server_name, $ip_addr, $os_type, $kernel_release, $uptime, $ram_free, $ram_total, $cpu_name, $cores" >> server_info.csv
fi
echo "Done!"