#!/bin/bash

### Memory usage alert script - For Ubuntu servers

if egrep -q  "Ubuntu 14|Ubuntu 12" /etc/os-release
then
        MEM_USED=`free | awk 'FNR == 3 {print $3/($3+$4)*100}'`
elif grep -q "Ubuntu 16" /etc/os-release
then
        MEM_USED=`free | awk 'FNR == 2 {print ($2-$7)/$2*100}'`
fi

MEMORY_UTILIZATION=`echo "($MEM_USED)/1" |bc`
OUTPUT_FILE="/tmp/$(hostname -s)_memory_usage_details.txt"
USER_LOGED=`w |sed -n '1!p'`

if [ $MEMORY_UTILIZATION -gt 85 ];then
        { echo -e "++++ $(hostname) ++++ !!!!Alert!!!$MEM_USED% of RAM used !!!!\n\nServer uptime: $(uptime;date)\n$USER_LOGED\n\nMemory Usage: $MEM_USED%\nMemory Details (in MB):\n$(free -m)\n"; echo "==============================="; echo "Top 5 memory consuming processes "; echo "==============================="; ps -eo user,pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -6; } >$OUTPUT_FILE
fi


