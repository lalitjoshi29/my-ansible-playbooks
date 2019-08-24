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

