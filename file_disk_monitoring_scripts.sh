[lalit@example scripts]$ cat alert_disk_usage_testdev.sh 

#!/bin/sh 

# set -x 

# Shell script to monitor or watch the disk space 

# ------------------------------------------------------------------------- 

  

# set alert level 85% is default 

ALERT=85 

  

# 

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

# 

function main_prog() { 

    # echo "$(hostname),$(date +%Z-%Y-%m-%d_%H-%M-%S)" 

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

  

  

  

  

  

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 

  

  

[lalit@example scripts]$ cat disk_usage_monitor_testdev.sh 

#!/bin/bash 

  

SERVER_LIST=/var/tmp/testdev_server_list.txt 

  

INPUT_SCRIPT=/etc/ansible/scripts/alert_disk_usage_testdev.sh 

  

OUTPUT_FILE=/var/tmp/disk_usage_alert.csv 

  

OUTPUT_TEMP_FILE=/var/tmp/disk_usage_alert_temp.csv 

  

MAIL_RECIPIENTS="xyz@example.com" 

  

  

for server in `cat $SERVER_LIST` 

  do 

    ssh $server 'bash -s' < $INPUT_SCRIPT 

  done > $OUTPUT_TEMP_FILE 

  

grep "%$" -B 1 $OUTPUT_TEMP_FILE | grep -v ^- > $OUTPUT_FILE 

  

grep -q "%" $OUTPUT_FILE 

if [ $? -eq 0 ] 

then 

  echo "Disk usage alert for UNIX TEST and DEV servers" | mailx -s "Disk usage alert for UNIX TEST and DEV servers" -a $OUTPUT_FILE $MAIL_RECIPIENTS  < $OUTPUT_FILE 

fi 

  

  

  

---------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

For single host 

cat disk_check.sh 

#!/bin/bash 

  

#set -x 

# Shell script to monitor or watch the disk space 

# ------------------------------------------------------------------------- 

  

# set alert level 85% is default 

ALERT=45 

  

EMAIL='xyz@example.com,abc@example.com' 

  

# 

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

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

  

  

df -PHT | grep -vE "^Filesystem|tmpfs|cdrom|nfs|cifs" | awk '{print $6 " " $7}' | main_prog > /var/tmp/disk_usage_alert.csv 

mailx -s "Alert: Almost out of disk space $(hostname) !!!" -a /var/tmp/disk_usage_alert.csv $EMAIL < /var/tmp/disk_usage_alert.csv 

  

  

==================================================================================== 

  

$ cat remote_file_stat.sh 

#!/bin/bash 

COMMON_DIR=/etc/ansible/scripts/file_stat_difference 

RHEL_SRV_LIST=$COMMON_DIR/rhel_test_servers_list.txt 

RHEL_INPUT_SCRIPT=$COMMON_DIR/rhel_file_stat.sh 

RHEL7_OUTPUT_FILE=/var/tmp/rhel7_file_modify_time.txt 

RHEL6_OUTPUT_FILE=/var/tmp/rhel6_file_modify_time.txt 

DIFF_FILE=/var/tmp/difference_files.txt 

  

echo > $RHEL7_OUTPUT_FILE 

echo > $RHEL6_OUTPUT_FILE 

echo > $DIFF_FILE 

  

for server in `cat $RHEL_SRV_LIST` 

  

do 

  echo -e "\e[34m\e[4mServerName: \e[0m" $server 

  if ssh $server 'grep -q -i "release 6" /etc/redhat-release' 

   then 

     ssh $server 'bash -s' <$RHEL_INPUT_SCRIPT  > $RHEL6_OUTPUT_FILE 

  elif ssh $server 'grep -q -i "release 7" /etc/redhat-release' 

    then 

      ssh $server 'bash -s' <$RHEL_INPUT_SCRIPT > $RHEL7_OUTPUT_FILE 

  fi 

done 

  

echo -e "ServerName1,\t\t\t\t\t\t\tServerName2" > $DIFF_FILE 

  

/bin/sdiff -s $RHEL7_OUTPUT_FILE $RHEL6_OUTPUT_FILE | sed 's/\x1b\[[0-9;]*m//g' >> $DIFF_FILE 

  

  

if [ ! -z "$DIFF_FILE" ] 

 then 

  /bin/mutt -s "Alert !!! file differences found." xyz@abc.com < $DIFF_FILE 

fi 

  

  

---------------------------------------------------------- 

  

  

  

$ cat rhel_file_stat.sh 

#!/bin/bash 

  

DIR_NAME=/tmp 

  

for FILES in `ls -1 $DIR_NAME/*.yml` 

  

do 

  SIZE=`stat $FILES | awk  'FNR == 2 {print $1 $2}'` 

  

  if grep -q -i "release 6" /etc/redhat-release 

   then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 6 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

  elif grep -q -i "release 7" /etc/redhat-release 

   then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 7 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

  fi 

done 

  

---------------------------------------------------------- 

  

  

  

  

$ cat compare_file_stat.sh 

#!/bin/bash 

RHEL7_OUTPUT_FILE=/var/tmp/rhel7_file_modify_time.txt 

RHEL6_OUTPUT_FILE=/var/tmp/rhel6_file_modify_time.txt 

DIFF_FILE=/var/tmp/difference_files.txt 

SERVER1=server1.example.com 

SERVER2=server2.example.com 

  

echo > $RHEL7_OUTPUT_FILE 

echo > $RHEL6_OUTPUT_FILE 

echo > $DIFF_FILE 

  

  

check_stat () { 

  

DIR_NAME=/tmp 

  

for FILES in `ls -1 $DIR_NAME/*.yml` 

  

do 

  SIZE=`stat $FILES | awk  'FNR == 2 {print $1 $2}'` 

  

if grep -q -i "release 6" /etc/redhat-release 

  then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 6 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

elif grep -q -i "release 7" /etc/redhat-release 

  then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 7 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

fi 

done 

  

} 

  

  

ssh  $SERVER2 "$(typeset -f check_stat);check_stat"  > $RHEL6_OUTPUT_FILE 

ssh  $SERVER1 "$(typeset -f check_stat);check_stat"  > $RHEL7_OUTPUT_FILE 

  

echo -e "$SERVER1,\t\t\t\t\t\t\t$SERVER2" > $DIFF_FILE 

  

/bin/sdiff -s $RHEL7_OUTPUT_FILE $RHEL6_OUTPUT_FILE | sed 's/\x1b\[[0-9;]*m//g' >> $DIFF_FILE 

  

  

if [ ! -z "$DIFF_FILE" ] 

 then 

  /bin/mutt -s "Alert !!! file differences found." xyz@abc.com < $DIFF_FILE 

fi 

  

  

---------------------------------------------------------------------------------- 

  

  

$ cat compare_file_stat.sh 

#!/bin/bash 

RHEL7_OUTPUT_FILE=/var/tmp/rhel7_file_modify_time.txt 

RHEL6_OUTPUT_FILE=/var/tmp/rhel6_file_modify_time.txt 

DIFF_FILE=/var/tmp/difference_files.txt 

SERVER1=server1.example.com 

SERVER2=server2.example.com 

  

echo > $RHEL7_OUTPUT_FILE 

echo > $RHEL6_OUTPUT_FILE 

echo > $DIFF_FILE 

  

  

  

check_stat () { 

  

DIR_NAME=/tmp 

cd $DIR_NAME 

  

for FILES in `ls -1 *.yml` 

  

do 

  SIZE=`stat $FILES | awk  'FNR == 2 {print $1 $2}'` 

  

if grep -q -i "release 6" /etc/redhat-release 

  then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 6 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

elif grep -q -i "release 7" /etc/redhat-release 

  then 

     MODIFY_TIME=`stat $FILES | awk  'FNR == 7 {print $1 $2}'` 

     echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

fi 

done 

  

} 

  

  

  

ssh  $SERVER2 "$(typeset -f check_stat);check_stat"  > $RHEL6_OUTPUT_FILE 

ssh  $SERVER1 "$(typeset -f check_stat);check_stat"  > $RHEL7_OUTPUT_FILE 

  

echo -e "$SERVER1,\t\t\t\t\t\t\t$SERVER2" > $DIFF_FILE 

  

/bin/sdiff -s $RHEL7_OUTPUT_FILE $RHEL6_OUTPUT_FILE | sed 's/\x1b\[[0-9;]*m//g' >> $DIFF_FILE 

  

  

if [ ! -z "$DIFF_FILE" ] 

 then 

  /bin/mutt -s "Alert !!! file differences found." xyz@abc.com < $DIFF_FILE 

fi 

  

  

  

  

----------------------------------------------------------------------------------------- 

  

  

  

  

$ cat compare_file_stat.sh 

#!/bin/bash 

SERVER1_OUTPUT_FILE=/var/tmp/server1_file_modify_time.txt 

SERVER2_OUTPUT_FILE=/var/tmp/server2_file_modify_time.txt 

DIFF_FILE=/var/tmp/difference_files.txt 

SERVER1=server1.example.com 

SERVER2=server2.example.com 

SRV1_DIR=/path/on/server1/ 

SRV2_DIR=/path/on/server2/ 

MAILING_LIST="xyz@abc.com" 

  

  

echo > $SERVER1_OUTPUT_FILE 

echo > $SERVER2_OUTPUT_FILE 

echo > $DIFF_FILE 

  

  

#### we are going to define a function 

check_stat () { 

  

cd $DIR_NAME 

  

for FILES in xyz.csv abc.csv efg.csv 

  

do 

  SIZE=`stat $FILES | awk  'FNR == 2 {print $1 $2}'` 

  

  MODIFY_TIME=`stat $FILES | awk  'FNR == 6 {print $1 $2}'` 

  echo -e "\e[92m$FILES: \e[0m$SIZE $MODIFY_TIME" 

done 

  

} 

  

  

### now performing the stat on remote files 

ssh  $SERVER1 "DIR_NAME=`echo $SRV1_DIR`;$(typeset -f check_stat);check_stat"  > $SERVER1_OUTPUT_FILE 

ssh  $SERVER2 "DIR_NAME=`echo $SRV2_DIR`;$(typeset -f check_stat);check_stat"  > $SERVER2_OUTPUT_FILE 

  

  

if [ -s "$SERVER1_OUTPUT_FILE" ] && [ -s "$SERVER2_OUTPUT_FILE" ] 

then 

   /bin/sdiff -s $SERVER1_OUTPUT_FILE $SERVER2_OUTPUT_FILE | sed 's/\x1b\[[0-9;]*m//g' >> $DIFF_FILE 

   if [ -s "$DIFF_FILE" ] 

      then 

         sed -i "1s/^/${SERVER1},\t\t\t\t\t\t\t${SERVER2}/" $DIFF_FILE 

         /bin/mutt -s "Alert !!! file differences found." $MAILING_LIST < $DIFF_FILE 

   fi 

fi 

  

  

------------------------------------------------------------------- 

  

  

  

  

  

  

  

  

  

 