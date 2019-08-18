$ cat alert_disk_usage_prod.sh 

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

  

  

  

---------------------------------------------------------------------------------------- 

  

$ cat disk_usage_monitor_prod.sh 

#!/bin/bash 

  

SERVER_LIST=/var/tmp/prod_server_list.txt 

  

INPUT_SCRIPT=/etc/ansible/scripts/alert_disk_usage_prod.sh 

  

OUTPUT_FILE=/var/tmp/disk_usage_alert_prod.csv 

  

OUTPUT_TEMP_FILE=/var/tmp/disk_usage_alert_prod_temp.csv 

  

MAIL_RECIPIENTS="abc@xyx.com" 

  

  

for server in `cat $SERVER_LIST` 

  do 

    ssh $server 'bash -s' < $INPUT_SCRIPT 

  done > $OUTPUT_TEMP_FILE 

  

grep "%$" -B 1 $OUTPUT_TEMP_FILE | grep -v ^- > $OUTPUT_FILE 

  

grep -q "%" $OUTPUT_FILE 

if [ $? -eq 0 ] 

then 

  echo "Disk usage alert for UNIX PROD servers" | mailx -s "Disk usage alert for UNIX PROD servers" -a $OUTPUT_FILE $MAIL_RECIPIENTS  < $OUTPUT_FILE 

fi 

  

---------------------------------------------------------------------------------------- 

  

Memory usage alert 

#!/bin/bash 

  

used=`free -m |awk 'NR==2 {print $3}'` 

total=`free -m |awk 'NR==2 {print $2}'` 

result=`echo "$used / $total" |bc -l` 

result2=`echo "$result > 0.2" |bc` 

  

if [ $result2 -eq 1 ];then 

{ echo -e "++++ $(hostname) ++++ !!!! More than 90% of RAM used !!!!\nMemory Usage: \n $(free -m)\n";  echo "Top 3 memory consuming processes: "; ps -eo user,pid,ppid,%mem,%cpu --sort=-%mem | head -4; } >/tmp/top3_proccesses_consuming_memory.txt 

mailx -s "High memory usage on $(hostname)" -a /tmp/top3_proccesses_consuming_memory.txt abc@xyz.com </tmp/top3_proccesses_consuming_memory.txt 

fi 

  

  

-------------------------------------------------------------------------------- 

  

 cat sysinfo_play.yml 

--- 

- name: Playbook - Basic System Information 

  hosts: serverlist 

  tasks: 

    - name: basic system info 

      shell: hostname; lscpu | grep 'Vendor ID'; lscpu | grep 'Model name'; lscpu | grep -i 'CPU MHz'; grep -m 1 'processor' /proc/cpuinfo | cut -d$'\t' -f1; grep -c 'processor' /proc/cpuinfo; grep -m 1 'cpu cores' /proc/cpuinfo |cut -d$'\t' -f1; grep 'cpu cores' /proc/cpuinfo |cut -d":" -f2 | awk '{s+=$1} END {print s}'; free -m -h | grep -i mem | cut -c1-20 

      register: system_info 

  

    - debug: var=system_info.stdout_lines 

  

----------------------------------------------------------------------- 

cat totaldisksize.sh 

#!/bin/bash 

lsblk -dn -o NAME,TYPE,SIZE | egrep -v 'fd0|sr0' |awk '/disk/ {sum+=$NF} END {print sum, "GB"}' 

  

---------------------------------------------------------------------------- 

  

cat server_memory_usage_alert.sh 

#!/bin/bash 

  

### Memory usage alert script - Created by UNIX team. 

  

USED=`free -m |awk 'NR==2 {print $3}'` 

TOTAL=`free -m |awk 'NR==2 {print $2}'` 

RESULT1=`echo "$USED / $TOTAL" |bc -l` 

RESULT2=`echo "$RESULT1 > 0.15" |bc` 

MAIL_RECPT="xyz@abc.com" 

OUTPUT_FILE="/tmp/$(hostname -s)_memory_usage_details.txt" 

  

  

if [ $RESULT2 -eq 1 ];then 

        { echo -e "++++ $(hostname) ++++ !!!! More than 90% of RAM used !!!!\nMemory Usage: \n $(free -m)\n";  echo "Top 5 memory consuming processes: "; ps -eo user,pid,ppid,%mem,%cpu --sort=-%mem | head -6; } >$OUTPUT_FILE 

        mailx -s "High memory usage on $(hostname)" $MAIL_RECPT <$OUTPUT_FILE 

fi 

  

--------------------------------------------------------------------------------- 

  

  

#    - name: Displaying paths of all .txt files in dir 

#      debug: msg={{ lookup('fileglob', '/var/tmp/memory_usage_data/*.txt') }} 

  

------------------------------------ 

cat script/memory_usage_alert.sh 

#!/bin/bash 

  

### Memory usage alert script - Created by UNIX team. 

  

USED=`free -m |awk 'NR==2 {print $3}'` 

TOTAL=`free -m |awk 'NR==2 {print $2}'` 

RESULT1=`echo "$USED / $TOTAL" |bc -l` 

RESULT2=`echo "$RESULT1 > 0.15" |bc` 

#MAIL_RECPT="xyz@abc.com" 

OUTPUT_FILE="/tmp/$(hostname -s)_memory_usage_details.txt" 

  

  

if [ $RESULT2 -eq 1 ];then 

        { echo -e "++++ $(hostname) ++++ !!!! More than 90% of RAM used !!!!\nMemory Usage: \n $(free -m)\n";  echo "Top 5 memory consuming processes: "; ps -eo user,pid,ppid,%mem,%cpu --sort=-%mem | head -6; } >$OUTPUT_FILE 

#       mailx -s "High memory usage on $(hostname)" $MAIL_RECPT <$OUTPUT_FILE 

fi 

  

------------------------------------------------------------------------------ 

cat mem_usage.sh 

#!/bin/bash 

  

if grep -q -i "release 6" /etc/redhat-release 

then 

        MEM_USED=`free | awk 'FNR == 3 {print $3/($3+$4)*100}'` 

        echo "Memory Utilization is : $MEM_USED%" 

elif grep -q -i "release 7" /etc/redhat-release 

then 

        MEM_USED1=`free | awk 'FNR == 2 {print ($2-$7)/$2*100}'` 

        echo "Memory Utilization is : $MEM_USED1%" 

fi 

  

  

------------------------------------------------------------------------- 

  

cat memory_alert.yml 

--- 

- name: Memory usage alert playbook 

  hosts: all 

 # hosts: serverlist 

 # hosts: library 

  vars_files: 

     - vars/main.yml 

  

  tasks: 

    - name: Running Memory usage script on remote RHEL hosts 

      script: /etc/ansible/memory_usage_alert/script/rh_memory_usage_alert.sh 

      when: ansible_os_family == "RedHat" 

  

  

    - name: Running Memory usage script on remote Ubuntu hosts 

      script: /etc/ansible/memory_usage_alert/script/ubuntu_memory_usage_alert.sh 

      when: ansible_os_family == "Debian" 

  

  

    - name: Checking if file for memory usage details exists 

      stat: 

         path: /tmp/{{ ansible_hostname }}_memory_usage_details.txt 

      register: memory_details_file 

  

  

    - name: Copying details from remote hosts to ansible server 

      fetch: 

        src: /tmp/{{ ansible_hostname }}_memory_usage_details.txt 

        dest: /var/tmp/memory_usage_data/ 

        flat: yes 

      when: memory_details_file.stat.exists 

  

  

    - name: Sending mail alerts to Unix team 

      local_action: 

         module: mail 

         host: localhost 

         port: 25 

         to: "{{ mail_recipient }}" 

         bcc: "{{ mail_bcc }}" 

         subject: "High memory usage on Linux Server" 

         body: "{{ lookup('file', '{{ item }}') }}" 

         from: "{{ mail_from }}" 

      with_fileglob: 

             - "/var/tmp/memory_usage_data/*" 

      become: no 

      run_once: yes 

  

  

    - name: Cleaning up directory 

      file: 

         path: "{{ item }}" 

         state: absent 

      with_fileglob: 

         - "/var/tmp/memory_usage_data/*" 

      delegate_to: localhost 

      run_once: yes 

  

  

    - name: Cleaning up temp memory usage details file on remote servers 

      file: 

         path: /tmp/{{ ansible_hostname }}_memory_usage_details.txt 

         state: absent 

      when: memory_details_file.stat.exists 

  

  

  

---------------------------------------------------------------------------- 

cat script/rh_memory_usage_alert.sh 

#!/bin/bash 

  

### Memory usage alert script - Created by UNIX team. 

if grep -q -i "release 6" /etc/redhat-release 

then 

        MEM_USED=`free | awk 'FNR == 3 {print $3/($3+$4)*100}'` 

elif grep -q -i "release 7" /etc/redhat-release 

then 

        MEM_USED=`free | awk 'FNR == 2 {print ($2-$7)/$2*100}'` 

fi 

  

MEMORY_UTILIZATION=`echo "($MEM_USED)/1" |bc` 

OUTPUT_FILE="/tmp/$(hostname -s)_memory_usage_details.txt" 

  

if [ $MEMORY_UTILIZATION -gt 85 ];then 

        { echo -e "++++ $(hostname) ++++ !!!!Alert!!!$MEM_USED% of RAM used !!!!\n\nServer uptime: $(uptime;date)\n\nMemory Usage: $MEM_USED%\nMemory Details (in MB):\n$(free -m)\n";  echo "===============================";echo "Top 5 memory consuming processes ";echo "==============================="; ps -eo user,pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -6; } >$OUTPUT_FILE 

fi 

  

-------------------------------------------------------------------- 

  

cat script/ubuntu_memory_usage_alert.sh 

#!/bin/bash 

  

### Memory usage alert script - Created by UNIX team. 

  

if egrep -q  "Ubuntu 14|Ubuntu 12" /etc/os-release 

then 

        MEM_USED=`free | awk 'FNR == 3 {print $3/($3+$4)*100}'` 

elif grep -q "Ubuntu 16" /etc/os-release 

then 

        MEM_USED=`free | awk 'FNR == 2 {print ($2-$7)/$2*100}'` 

fi 

  

MEMORY_UTILIZATION=`echo "($MEM_USED)/1" |bc` 

OUTPUT_FILE="/tmp/$(hostname -s)_memory_usage_details.txt" 

  

if [ $MEMORY_UTILIZATION -gt 85 ];then 

        { echo -e "++++ $(hostname) ++++ !!!!Alert!!!$MEM_USED% of RAM used !!!!\n\nServer uptime: $(uptime;date)\n\nMemory Usage: $MEM_USED%\nMemory Details (in MB):\n$(free -m)\n"; echo "==============================="; echo "Top 5 memory consuming processes "; echo "==============================="; ps -eo user,pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -6; } >$OUTPUT_FILE 

fi 

 
------------------------------------------------------ 

cat vars/main.yml 

--- 

mail_recipient: xyz@abc.com 

mail_from: 123@abc.com 

mail_bcc: 234@abc.com 

  

------------------------------------------------------------------ 

﷟HYPERLINK "https://misc.flogisoft.com/bash/tip_colors_and_formatting"https://misc.flogisoft.com/bash/tip_colors_and_formatting 

  

The commands: 

--------------------------------------- 

echo -e "\e[1mbold\e[0m" 

echo -e "\e[3mitalic\e[0m" 

echo -e "\e[4munderline\e[0m" 

echo -e "\e[9mstrikethrough\e[0m" 

echo -e "\e[31mHello World\e[0m" 

echo -e "\x1B[31mHello World\e[0m" 

  

  

$ ls 

inventory  Remote_server_monitor_resource_utilization.sh  top_resource_consuming_processes.sh 

  

$ cat top_resource_consuming_processes.sh 

#!/bin/bash 

  

echo -e "\e[93m======================================================" 

echo "" 

echo -e "\e[92m\e[4m ServerName \e[0m" 

hostname 

echo "" 

echo -e "\e[92m\e[4m ServerIP \e[0m" 

hostname -i 

echo "" 

echo -e "\e[91m\e[4m Top 5 Memory consuming processes \e[0m" 

echo "" 

ps -A --sort -rss -o user,pid,pmem,pcpu,command | head -6 

echo "" 

echo -e "\e[91m\e[4m Top 5 CPU consuming processes \e[0m" 

echo "" 

ps -A --sort -pcpu -o user,pid,pmem,pcpu,command | head -6 

echo "" 

  

Or (another version) 

  

$ cat top_resource_consuming_processes.sh 

#!/bin/bash 

  

echo -e "\e[93m======================================================" 

echo "" 

echo -e "\e[92m\e[1mServerName: \e[0m" $(hostname) 

echo -e "\e[92m\e[1mServerIP: \e[0m" $(hostname -i) 

echo "" 

echo -e "\e[91m\e[4m Top 5 Memory consuming processes \e[0m" 

echo "" 

ps -A --sort -rss -o user,pid,pmem,pcpu,command | head -6 

echo "" 

echo -e "\e[91m\e[4m Top 5 CPU consuming processes \e[0m" 

echo "" 

ps -A --sort -pcpu -o user,pid,pmem,pcpu,command | head -6 

echo "" 

  

  

$ cat Remote_server_monitor_resource_utilization.sh 

#!/bin/bash 

  

SERVER_LIST=/etc/ansible/top_resource_consuming_processes/inventory 

  

INPUT_SCRIPT=/etc/ansible/top_resource_consuming_processes/top_resource_consuming_processes.sh 

  

OUTPUT_FILE=/var/tmp/top_resource_consuming_processes_report.txt 

echo > $OUTPUT_FILE 

  

for server in `cat $SERVER_LIST` 

  do 

    ssh $server 'bash -s' < $INPUT_SCRIPT 

  done > $OUTPUT_FILE 

  

  

  

--------------------------------------------------------------------- 

  

  

  

  

  

  

  

  

 