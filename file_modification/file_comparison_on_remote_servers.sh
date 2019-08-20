#################################################################################
##
## This script is used for comparing same files located on two different servers
## It will compare file size and Modification date only. 
##
## $ cat compare_file_stat.sh 
#################################################################################

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

   /bin/sdiff -s $SERVER1_OUTPUT_FILE $SERVER2_OUTPUT_FILE | sed 's/\x1b\[[0-9;]*m//g' > $DIFF_FILE 

   if [ -s "$DIFF_FILE" ] 

      then 

         sed -i "1s/^/${SERVER1},\t\t\t\t\t\t\t${SERVER2}\n/" $DIFF_FILE 

         /bin/mutt -s "Alert !!! file differences found." $MAILING_LIST < $DIFF_FILE 

   fi 

fi 
  

#################################################### 
