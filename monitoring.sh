#!/bin/sh

LVM=$(lsblk | grep root | awk '{print $6}')
COMPARATOR="lvm"

MEM_TOTAL=$(free -m | grep Mem | awk '{print $2}')
MEM_USED=$(free -m | grep Mem | awk '{print $3}')

DISK_USE=$(df -m --total | grep total | awk '{print $3}')
DISK_TOTAL=$(df -m --total | grep total | awk '{print $2}')
DISK_PERC=$(df --total | grep total | awk '{print $5}')

CPU_LOAD=$(cat /proc/loadavg | awk '{print $1}')

IP_ADDR=$(ifconfig | grep inet | head -n 1 | awk '{print $2}')
MAC_ADDR=$(ifconfig | grep ether | awk '{print $2}')

wall << Display_Script
#Architecture: `uname -a`
#CPU Physical: `lscpu | grep CPU\(s\) | awk '{print $2}' | head -n 1`
#vCPU: `cat /proc/cpuinfo | grep processor | awk '{print $3}'` 
#Memory Usage: `awk -v memuse="$MEM_USED" -v memtot="$MEM_TOTAL" 'BEGIN {
	printf "%d/%dMB (%.2f%%)\n", memuse, memtot, ((memuse / memtot) * 100);
}'`
#Disk Usage: `awk -v diskuse="$DISK_USE" -v disktot="$DISK_TOTAL" -v perc="$DISK_PERC" 'BEGIN {
	printf "%d/%dMB (%s)\n", diskuse, disktot, perc;
}'`
#CPU Load: `awk -v cpu="$CPU_LOAD" 'BEGIN {
	printf "%.2f%%\n", (cpu * 100);
}'`         
#Last Boot: `who -b | awk '{print $(3)" "$(4)}'`
#LVM use: ` if [ $LVM ==  $COMPARATOR ]
		   	then
				echo "yes"
			else
				echo "no"
			fi`
#TCP Connections: `awk  </proc/net/tcp 'BEGIN{t=0};{if ($4 == "01") {t++;}};END{printf "%d ESTABLISHED\n", t}'`
#User Log: `who | uniq | awk '{print $1}' | wc -l`
#Network: `awk -v ip="$IP_ADDR" -v mac="$MAC_ADDR" 'BEGIN {
	printf "IP %s (%s)\n", ip, mac;
}'`
#Sudo: `grep -c 'COMMAND' /var/log/sudo/sudo_log | awk '{printf "%d cmd\n", $1}'`
Display_Script
