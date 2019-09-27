#!/bin/bash
### croninfo.sh

CRONDIR=/var/spool/cron
echo " "
hostname
echo "-----------------"

if [ -z "$(ls -A /var/spool/cron)" ]; then
  echo " "
  echo " No cron jobs running on this server  :( "
  echo " "
  echo " "
else
  echo "cron jobs running for following user(s): "
  echo "-----------------------------------------"
  ls -1 $CRONDIR
  echo " "

fi

for i in `ls -1 $CRONDIR`;
     do
       echo " "
       echo "cron jobs of '$i' are listed as below:"
       echo "-------------------------------------"
       cat $CRONDIR/$i
       echo " "
       echo " "
       echo " "

done
