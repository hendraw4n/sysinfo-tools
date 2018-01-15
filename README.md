# sysinfo-tools
System Information Scripts

## Firmware Report
**Script for generate firmware currenty installed on linux server**

**How To:** Download "firmware_report.sh" and put on temporary directory and issue below.
```bash
shell> chmod +x firmware_report.sh
shell> ./firmware_report.sh
```
This will create a file containing all info under /tmp/firmware_report directory with the name "/tmp/hostname_firmware_report_date.tar.bz2"

**Output:** 
```bash
shell>./firmware_report.sh
Gathering system information...
Gathering application information...
Gathering network information...
Gathering kernel information...
Gathering hardware information...
Gathering BIOS information...
Gathering Smart Array information...
Gathering HBA information...
Compressing files...
Script complete.

shell>ls -ltr /tmp/ |grep firmware_report
drwxr-xr-x 3 root          root              130 Jan 15 07:23 firmware_report
-rw-r--r-- 1 root          root            80092 Jan 15 07:23 hostname.example.com_firmware_report_2018-01-15.tar.bz2
```
