# sysinfo-tools
System Information Collections Scrips

## Firmware Report
**Script for generate firmware currenty installed on linux server**
**How To:** Download "firmware_report.sh" and put on temporary directory and issue below.
```bash
shell> chmod +x firmware_report.sh
shell> ./firmware_report.sh
```
This will create a file containing all info under /tmp/firmware_report directory with the name "/tmp/<hostname>_firmware_report_<date>.tar.bz2"