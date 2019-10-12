#!/bin/bash
# Purpose:  List all normal users
# 
echo " "
echo " "
echo "Server: " `hostname`
echo "-------------------------"

LOGIN_DEF="/etc/login.defs"
PASS_FILE="/etc/passwd"

## Get minimum UID limit ##
MIN_UID_LIMIT=$(grep "^UID_MIN" $LOGIN_DEF)

## Get maximum UID limit ##
MAX_UID_LIMIT=$(grep "^UID_MAX" $LOGIN_DEF)

## Use awk to print if UID >= $MIN and UID <= $MAX  and shell is not /sbin/nologin ## 
awk -F ':' -v "min=${MIN_UID_LIMIT##UID_MIN}" -v "max=${MAX_UID_LIMIT##UID_MAX}" '{ if ( $3 >= min && $3 <= max && $7 != "/sbin/nologin" ) print $0 }' "$PASS_FILE" >/tmp/user_acct

cat /tmp/user_acct | awk -F ':' '{print $1, " -----" $5}' 
echo ' '

