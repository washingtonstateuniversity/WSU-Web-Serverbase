#!/bin/bash


#set the compiler to be quite
#then return message only it it's a fail
ini(){
    cd /src
	
	yum -y install gcc gcc-c++ make automake unzip zip xz kernel-devel-`uname -r` iptables-devel
	rpm -i http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
	yum -y install perl-Text-CSV_XS

	wget http://downloads.sourceforge.net/project/xtables-addons/Xtables-addons/2.5/xtables-addons-2.5.tar.xz
	tar xvf xtables-addons-2.5.tar.xz
	cd xtables-addons-2.5/
	./configure
	make && make install

	cd geoip/
	./xt_geoip_dl
	./xt_geoip_build GeoIPCountryWhois.csv
	mkdir -p /usr/share/xt_geoip/
	cp -r {BE,LE} /usr/share/xt_geoip/

	# Iptables configuration script

	# Flush all current rules from iptables
	/sbin/iptables -F

	# Loopback address
	/sbin/iptables -A INPUT -i lo -j ACCEPT

	# Allowed any established connections
	/sbin/iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Allow FTP and SSH from specific IPs
	#/sbin/iptables -A INPUT -s 10.0.2.0/24 -p tcp -m state --state NEW -m multiport --dports 21,22 -j ACCEPT

	# Allow SSH only from the US
	iptables -I INPUT -m geoip --src-cc US --dports 22 -j ACCEPT


	# Allow pings from monitoring server
	/sbin/iptables -A INPUT -s 1.1.1.1 -p icmp -m icmp --icmp-type any -j ACCEPT

	# Allow web server access from anywhere
	/sbin/iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT

	# Drop rules to prevent them from entering the logs
	/sbin/iptables -A INPUT -p tcp -m multiport --dports 135,137,138 -j DROP
	/sbin/iptables -A INPUT -p udp -m multiport --dports 135,137,138 -j DROP
	/sbin/iptables -A INPUT -p all -d 255.255.255.255 -j DROP

	# Log dropped traffic
	/sbin/iptables -A INPUT -j LOG -m limit --limit 10/m --log-level 4 --log-prefix "Dropped Traffic: "

	# Set default policies for INPUT, FORWARD and OUTPUT chains
	/sbin/iptables -P INPUT DROP
	/sbin/iptables -P FORWARD DROP
	/sbin/iptables -P OUTPUT ACCEPT

	
	echo "result=True changed=True comment='$resulting'"
}

LOGOUTPUT=$(ini)
