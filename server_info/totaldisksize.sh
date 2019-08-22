### $ cat totaldisksize.sh
#!/bin/bash
lsblk -dn -o NAME,TYPE,SIZE | egrep -v 'fd0|sr0' |awk '/disk/ {sum+=$NF} END {print sum, "GB"}'

