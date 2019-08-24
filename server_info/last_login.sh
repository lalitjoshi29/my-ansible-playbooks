#!/bin/bash
{
last | awk '{print $1}' | sort| uniq |egrep -v 'root|wtmp|lastlog|reboot|\(unknown'
} > /tmp/last_login.txt
for i in `cat /tmp/last_login.txt`
do
lastlog -u $i
done

