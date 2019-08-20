####[lalit@example scripts]$ cat disk_usage_alert.sh 
##
#!/bin/sh 
#
# set -x 
#
# Shell script to monitor or watch the disk space 
#################################################################

# set alert level 85% is default 
ALERT=85 
# 

function main_prog() { 
     echo "$(hostname)," 
while read output; 
do 
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1) 
  partition=$(echo $output | awk '{print $2}') 
  if [ $usep -ge $ALERT ] ; then 
     echo "$partition,$usep%" 
  fi 
done 
} 


df -PHT | grep -vE "^Filesystem|tmpfs|cdrom|nfs|cifs" | awk '{print $6 " " $7}' | main_prog 


####################################################################
