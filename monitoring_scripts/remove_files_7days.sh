#!/bin/bash
LOGFILE=/tmp/7days_files.log
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $LOGFILE
echo "" >> $LOGFILE
echo `date` >> $LOGFILE
echo "Removing files more than 7 days old........" >> $LOGFILE
find /var/tmp/pdffiles -type f -mtime +1 -name '*.pdf' -exec ls -lh {} \; >> $LOGFILE
echo "Total files removed: " >> $LOGFILE
find /var/tmp/pdffiles -type f -mtime +1 -name '*.pdf' -exec ls {} \; | wc -l >> $LOGFILE
find /var/tmp/pdffiles -type f -mtime +1 -name '*.pdf' -exec rm -- {} \;
echo -e "\n\n" >> $LOGFILE

