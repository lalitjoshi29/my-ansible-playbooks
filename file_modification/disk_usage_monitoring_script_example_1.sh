#######################################################
#!/bin/bash 
#
#################
SERVER_LIST=/var/tmp/testdev_server_list.txt 
INPUT_SCRIPT=/etc/scripts/disk_usage_alert.sh 
OUTPUT_FILE=/var/tmp/disk_usage_alert_output.csv 
OUTPUT_TEMP_FILE=/var/tmp/disk_usage_alert_output_temp.csv 
MAIL_RECIPIENTS="xyz@example.com" 

#################
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

##################################################################### 
