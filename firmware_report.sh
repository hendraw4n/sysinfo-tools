#!/bin/bash
#
# Firmware Report version 1
# Developed by: .,Hendrawan - hendrawan.hendrawan@hpe.com
#
export LANG=C
# set -x
# set -o verbose

[[ -d /tmp/firmware_report ]] && rm -rf /tmp/firmware_report
mkdir /tmp/firmware_report && cd /tmp/firmware_report && mkdir -p firmware/networking firmware/hba firmware/sa firmware/hardware firmware/kernel
PACKAGE=sysfsutils
if rpm -qa | grep -q $PACKAGE; then  echo " "; else  echo "$PACKAGE needs to be installed"; exit; fi

echo -e "Gathering system information..."
date &> date
hostname &> hostname
uname -a &> uname
cat /etc/redhat-release &> redhat-release
uptime &> uptime

echo -e "Gathering application information..."
rpm -qa --last &> rpm-qa

echo -e "Gathering network information..."
ifconfig &> ./firmware/networking/ifconfig
ip a &> ./firmware/networking/ip_a
for i in $(ls /etc/sysconfig/network-scripts/{ifcfg,route,rule}-*) ; do echo -e "$i\n----------------------------------"; cat $i;echo " ";  done &> ./firmware/networking/ifcfg-files
for i in $(ifconfig | grep "^[a-z]" | cut -f 1 -d " "); do echo -e "$i\n-------------------------" ; ethtool $i; ethtool -k $i; ethtool -S $i; ethtool -i $i;echo -e "\n" ; done &> ./firmware/networking/ethtool.out
cp /etc/sysconfig/network ./firmware/networking/ 2>> error_log
cp /etc/sysconfig/network-scripts/ifcfg-* ./firmware/networking/ 2>> error_log
cp /etc/sysconfig/network-scripts/route-* ./firmware/networking/ 2>> error_log
cat /proc/net/bonding/bond* &> ./firmware/networking/proc-net-bonding-bond 2>> error_log
ip route show table all &> ./firmware/networking/ip_route_show_table_all
ip link &> ./firmware/networking/ip_link

echo -e "Gathering kernel information..."
lsmod &> ./firmware/kernel/lsmod
for MOD in `lsmod | grep -v "Used by"| awk '{ print $1 }'`; do modinfo $MOD; done >> ./firmware/kernel/modinfo
cp -a /var/log/dmesg ./firmware/kernel/dmesg 2>> error_log
dmesg &> ./firmware/kernel/dmesg_now

echo -e "Gathering hardware information..."
dmidecode &> ./firmware/hardware/dmidecode
lspci -k &> ./firmware/hardware/lspci_-k
lspci -vvv &> ./firmware/hardware/lspci_-vvv
lspci &> ./firmware/hardware/lspci
cat /proc/meminfo &> ./firmware/hardware/meminfo
cat /proc/cpuinfo &> ./firmware/hardware/cpuinfo
dmidecode -t 4 &> ./firmware/hardware/dmidecode_cpu

echo -e "Gathering BIOS information..."
dmidecode -t bios &> ./firmware/hardware/dmidecode_-t_bios

echo -e "Gathering Smart Array information..."
lspci -vnn | grep "RAID bus controller" &> ./firmware/sa/lscpi_smart_array
ls -l  /sys/class/scsi_host/host*/firmware_revision &> ./firmware/sa/ls_-l_scsi_host_firmware_revision 2>> error_log
cat /sys/class/scsi_host/host*/firmware_revision &> ./firmware/sa/cat_scsi_host_firmware_revision 2>> error_log
modinfo hpsa &> ./firmware/sa/modinfo_hpsa 2>> error_log
cat /proc/driver/cciss/cciss0 &> ./firmware/sa/cciss_firmware_version 2>> error_log
modinfo cciss| head -5 &> ./firmware/sa/cciss_driver_version 2>> error_log

echo -e "Gathering HBA information..."
for FC in $( ls /sys/class/fc_host ); do systool -c fc_host -v -d $FC >> ./firmware/hba/systool_-v; done
modinfo qla2xxx | grep -v firmware | head -5 &> ./firmware/hba/modinfo_qla2xxx_driver 2>> error_log

echo -e "Compressing files..."
tar -cjf /tmp/`hostname`_firmware_report_`date +%F`.tar.bz2 ./

echo -e "Script complete."