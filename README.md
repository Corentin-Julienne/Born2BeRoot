# BORN2BEROOT
![VM](https://img.shields.io/badge/VirtualBox-21416b?style=for-the-badge&logo=VirtualBox&logoColor=white) ![Debian](https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white) ![GNU](https://img.shields.io/badge/GNU%20Bash-4EAA25?style=for-the-badge&logo=GNU%20Bash&logoColor=white)
<br>
## 🗣️ About
---
<br>
The Project Born2BeRoot of School 42 is aimed to teach some bases of system administration. 

More specifically, the goal is to setup a Virtual Machine (VM) with a Linux OS (Debian Latest or CentOS). The goal will be to learn what is a VM and how to use it, and how to setup services such as UFW, SSH and to add a good password policy within the OS present in the VM.

More information can be found in the PDF.
<br>
## 🛠️ Tutorial
---
<br>
First, you will need to download the latest stable version of Debian. The link can be found here : https://www.debian.org/releases/stable/debian-installer/. Choose the AMD64 version

Next step will be to download Virtualbox : https://www.virtualbox.org/wiki/Downloads

You will need to install the guest additions in order for Virtualbox to function properly : https://linuxize.com/post/how-to-install-virtualbox-guest-additions-on-debian-10/ (also the in additionnal resources)

You can go to the end of this tutorial and follow the steps to install the Debian 11 virtual machine : https://baigal.medium.com/born2beroot-e6e26dfb50ac

NB : After changing password policies, you need to change all password for all users, root included. Check this tuto : https://ostechnix.com/how-to-set-password-policies-in-linux/ However, for some specific Debian 11 stuff, use this tutorial instead : https://www.server-world.info/en/note?os=Debian_11&p=pam&f=1

If, when you launch the virtual machine (MC) for the first time, you hava an error message indicating that a kernel is not installed, follow this tutorial (in french, for MacOS) : https://azurplus.fr/comment-reparer-lerreur-kernel-driver-not-installed-rc-1908-de-virtualbox-sur-un-mac/
<br>
##  Bash script
---
<br>

This is the bash script used to display informations about the OS (check the PDF for more information). A CRON job is used to display it every 10 minutes.

```bash

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

```
