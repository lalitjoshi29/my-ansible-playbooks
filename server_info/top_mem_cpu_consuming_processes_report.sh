#!/bin/bash

SERVER_LIST=server_inventory.txt

INPUT_SCRIPT=top_mem_cpu_consuming_processes.sh

OUTPUT_FILE=/var/tmp/top_resource_consuming_processes_report.txt
echo > $OUTPUT_FILE

for server in `cat $SERVER_LIST`
  do
    ssh $server 'bash -s' < $INPUT_SCRIPT
  done > $OUTPUT_FILE

