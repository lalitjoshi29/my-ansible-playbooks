### $ cat totaldisksize.sh
### Before using this script, please make sure "lsblk" utility should be installed on the server. 
#!/bin/bash
lsblk -dn -o NAME,TYPE,SIZE | egrep -v 'fd0|sr0' |awk '/disk/ {sum+=$NF} END {print sum, "GB"}'
