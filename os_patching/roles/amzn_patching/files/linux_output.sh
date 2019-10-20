#!/bin/bash

## common system information
echo -e "************* System information***************"
echo -e -n "System  uptime:       "; uptime
echo -e -n "System date and time: "; date
echo -e -n "Kernel version:       "; uname -a
echo -e -n "OS version:   "; cat /etc/*-release
echo -e -n "\nHostname:     "; hostname
echo -e -n "\nDomainname:   "; domainname

echo -e "\n\n"
## Hardware information
echo -e "************** Basic hardware information************"
echo -e "System Memory:   "; free -m
echo -e "\nMemory Details:  "; cat /proc/meminfo | egrep -i "Mem|Active|Swap|cache|buffer"
echo -e "\nSwap Details:    "; swapon -s
echo -e "\nSystem CPU:      "; cat /proc/cpuinfo

echo -e "\n\n"
## Disk information
echo -e "************** Disk and Filesystem Information ************"
echo -e "Diks usage:      "; df -hT
echo -e "\nMounted filesystems:     "; mount
echo -e "\nFile System table file (/etc/fstab):     "; cat /etc/fstab
echo -e "\nList block devices:      "; lsblk
echo -e "\nRoot file system metadata info - if file system is ext2,ext3 or ext4(dumpe2fs) / xfs (xfs_info): "; df -hT / | grep ext && dumpe2fs / || xfs_info /
echo -e "\nList scsi devices:       "; lsscsi
echo -e "\nList disk partitions:    "; fdisk -l
echo -e "\nList NFS Filesystems:    "; showmount -e

echo -e "\n\n"
## LVM information
echo -e "************** LVM information ****************"
echo -e "\nList physical volumes:   "; pvs
echo -e "\nDetailed information PV: "; pvdisplay
echo -e "\nList volume groups:      "; vgs -a -o +devices
echo -e "\nDetailed information VG: "; vgdisplay
echo -e "\nList logical volumes:    "; lvs -a -o +devices
echo -e "\nDetailed information LV: "; lvdisplay
echo -e "\nScan Logical volumes:    "; lvmdiskscan


echo -e "\n\n"
## Network information
echo -e "********** Network information ****************"
echo -e "\nIP configuration:        "; ip addr sh
echo -e "\nRouting information:     "; ip route list
echo -e "\nBonding information:     "; for i in `ls /proc/net/bonding/bond*`; do echo -e "-----$i status----"; cat $i;done
echo -e "\nNetwork configuration file:      "; for i in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do echo -e "\ncontents of $i .......";cat $i; echo -e "\n#####################"; done
echo -e "\nDNS information (/etc/resolv.conf):      "; cat /etc/resolv.conf
echo -e "\nLocal database for hosts (/etc/hosts):   "; cat /etc/hosts

echo -e "\n\n"
## port information
echo -e "Port which are Listening ...."; netstat -tunlp; ss -tunlp
## Logged in users and  Process information
echo -e "*********** Displaying current loged in users and running application processes ************"
echo -e "\nCurrent logged in users: "; w
echo -e "\nCurrent app processes:   "; ps -ef | egrep -i "pmon|smon|dataserv|apache|http|nfs"| grep -v egrep
echo -e "\nNon root processes:  "; ps -ef | grep -v root
## List services or systemd
echo -e "******************* List service or systemd status **************************"
grep "release 2" /etc/system-release >/dev/null && (echo -e "\nList enabled systemd units:  "; systemctl list-unit-files | grep enabled; echo -e "\nList running unit files:     "; systemctl list-units | grep running) || (echo -e "\nList services which are enabled at boot time: "; chkconfig --list | grep -w on ; echo -e "\nList running services: "; echo "\nrunning services.....................................*******%%%%%%%%%%%%%%%")

## List all available package updates, Errata Bug fix and Security Advisories
echo -e "************** List all available package updates, Errata bug fix and security advisories **********************"
yum check-update
yum updateinfo list sec


echo -e "\n\n"

## List of all running processes
echo -e "************** List of all running processes *****************"
ps -ef

