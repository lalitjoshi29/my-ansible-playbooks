# Pre and Post Activity server configuration output

## Run this playbook to take system output before activity and after activity.
## first update the inventory with hostname/IP of the servers

## There are two tags in this playbook
## ansible-playbook playbook_pre_pst_chk.yml --list-tags
## TASK TAGS: [post_chk, pre_chk]

## For taking server output before activity run playbook as below:
	 ansible-playbook playbook_pre_pst_chk.yml -t pre_chk

## For taking server output after activity run playbook as below:
	 ansible-playbook playbook_pre_pst_chk.yml -t post_chk

