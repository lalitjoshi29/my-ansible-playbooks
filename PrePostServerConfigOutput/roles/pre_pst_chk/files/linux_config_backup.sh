#!/bin/bash
## backup of linux configuration files
NOW=$(date +"%m_%d_%Y")
BACKUP_DIR=/var/tmp/backup/`hostname`_$NOW
[ ! -d $BACKUP_DIR ] && mkdir -p $BACKUP_DIR

### Backup of Basic system configuration
cp -p /etc/redhat-release $BACKUP_DIR/redhat-release_$NOW
cat /proc/cpuinfo > $BACKUP_DIR/cpuinfo_$NOW
cat /proc/meminfo > $BACKUP_DIR/meminfo_$NOW
cat /proc/swaps > $BACKUP_DIR/swaps_$NOW
cp -p /etc/hosts $BACKUP_DIR/hosts_$NOW
cp -p /etc/selinux/config  $BACKUP_DIR/selinux_config_$NOW
cp -p /etc/resolv.conf  $BACKUP_DIR/resolv.conf_$NOW

## Backup of Boot loader configuration
cp -p /etc/default/grub  $BACKUP_DIR/default_grub_$NOW
cp -p /boot/grub2/grub.cfg  $BACKUP_DIR/grub.cfg_$NOW


## Backup of User configuration
cp -p /etc/passwd $BACKUP_DIR/passwd_$NOW
cp -p /etc/shadow $BACKUP_DIR/shadow_$NOW
cp -p /etc/group $BACKUP_DIR/group_$NOW
cp -p /etc/nsswitch.conf $BACKUP_DIR/nsswitch.conf_$NOW
cp -p /etc/security/access.conf  $BACKUP_DIR/access.conf_$NOW
cp -p /etc/security/limits.conf  $BACKUP_DIR/limits.conf_$NOW
cp -p /etc/security/pam_winbind.conf  $BACKUP_DIR/pam_winbind.conf_$NOW

## Compressed Backup of /etc/ directory
/bin/tar cJPf $BACKUP_DIR/etc-tar_$NOW.xz /etc/

## DISK and Filesystem information
df -hT > $BACKUP_DIR/df_$NOW
cp -p /etc/fstab  $BACKUP_DIR/fstab_$NOW
lsblk > $BACKUP_DIR/lsblk_$NOW
fdisk -l > $BACKUP_DIR/fdisk-l_$NOW
(pvs;pvdisplay) > $BACKUP_DIR/pvs_pvdisplay_$NOW
(vgs -a -o +devices; vgdisplay) > $BACKUP_DIR/vgs_vgdisplay_$NOW
(lvs -a -o +devices; lvdisplay) > $BACKUP_DIR/lvs_lvdisplay_$NOW

