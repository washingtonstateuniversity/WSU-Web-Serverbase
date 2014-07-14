#!/bin/bash

# Change this path to your actual "xtables-addons" folder.
# For Debian, use "/usr/lib/xtables-addons/".
cd /opt/src/xtables-addons-1.47.1

cd geoip
./xt_geoip_dl
[ ! -f "./GeoIPCountryWhois.csv" ] && { echo "Error: GeoIPCountryWhois.csv file not found."; exit 1; }
[ ! -s "./GeoIPCountryWhois.csv" ] && { echo "Error: GeoIPCountryWhois.csv file is empty."; exit 1; }
./xt_geoip_build GeoIPCountryWhois.csv
mkdir -p /usr/share/xt_geoip/
cp -rf {BE,LE} /usr/share/xt_geoip/


# /etc/cron.d/update_GeoIP
 
# Global variables
#SHELL=/bin/bash
#PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin
#MAILTO=root
#HOME=/
#25 4 5,10 * * root /root/GeoIP_update.sh >/dev/null 2>&1
