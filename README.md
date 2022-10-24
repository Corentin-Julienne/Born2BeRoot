# Born2beroot_42

## Tutorial

### Tutos made by third parties

First, you will need to download the latest stable version of Debian. The link can be found here : https://www.debian.org/releases/stable/debian-installer/

Choose the AMD64 version

Next step will be to download Virtualbox : https://www.virtualbox.org/wiki/Downloads

You will need to install the guest additions in order for Virtualbox to function properly : https://linuxize.com/post/how-to-install-virtualbox-guest-additions-on-debian-10/ (also the in additionnal resources)

You can go to the end of this tutorial and follow the steps to install the Debian 11 virtual machine : https://baigal.medium.com/born2beroot-e6e26dfb50ac

NB : After changing password policies, you need to change all password for all users, root included. Check this tuto : https://ostechnix.com/how-to-set-password-policies-in-linux/ However, for some specific Debian 11 stuff, use this tutorial instead : https://www.server-world.info/en/note?os=Debian_11&p=pam&f=1

If, when you launch the virtual machine (MC) for the first time, you hava an error message indicating that a kernel is not installed, follow this tutorial (in french, for MacOS) : https://azurplus.fr/comment-reparer-lerreur-kernel-driver-not-installed-rc-1908-de-virtualbox-sur-un-mac/

### some useful info

In the tuto provided by baigal, the link used to get zsh does not works : write this instead : 
```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### setting up shared folder

It is more convenient to write the script in VSC and then use it in your Debian host. You will need shared folder for this. First, enable the guest additions (link to the tutorial above). The, go to the settings of your VM, go to shared folder, add one, make it permanent and do not specify the location. It will be present at the following path : /media/ (once you reboot your Debian host). The name of the shared folder will be sf_name_of_your_folder.

### check all the normal users in your Debian Host

```bash
getent passwd {1000..60000}
```

It is possible to add users, modify the password, etc. Follow this tutorial : https://linuxize.com/post/how-to-create-users-in-linux-using-the-useradd-command/

## Bash script

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
