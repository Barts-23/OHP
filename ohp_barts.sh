#!/bin/bash
# CentOS 7 or 8
# OPENHTTP PUNCHER TOOL SCRIPT
# Modified by iamBARTX™️

# Install Updates
yum update -y

yum install epel-release -y

#Install Needed Sevices
yum --enablerepo=epel install squid dropbear zip unzip screen -y

#Create Squid.conf
cat <<EOF> /etc/squid/squid.conf
http_access allow all
http_port 127.0.0.1:25100
acl barts src 0.0.0.0/0.0.0.0
no_cache deny barts
dns_nameservers 1.1.1.1 1.0.0.1
visible_hostname localhost
EOF

# Create OHP Banner
cat <<'EOF2'> /etc/banner
BartX GTM No Load and With Promi Server
EOF2

#Setup Dropbear
echo "[Unit]
Description=Dropbear SSH Server Daemon
Documentation=man:dropbear(8)
Wants=dropbear-keygen.service
After=network.target

[Service]
ExecStart=/usr/sbin/dropbear -E -F -p 127.0.0.1:25102 -b /etc/banner

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/dropbear.service

chmod +x /lib/systemd/system/dropbear.service

# Restart Dropbear
systemctl daemon-reload && systemctl restart dropbear

#Restart Squid Proxy
service squid restart

#Install Http Puncher Tool
curl -4SL "https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip" -o ohp.zip

unzip -qq ohp.zip && rm -f ohp.zip

chmod +x ohpserver

screen -S barts -dm bash -c "./ohpserver -port 687 -proxy 127.0.0.1:25100 -tunnel 127.0.0.1:110"

screen -r barts

# Adding user/pass
echo '/bin/false' >> /etc/shells

User='Bartx';
Pass='Bartx';
useradd -m -s /bin/false $User && echo -e "$Pass\n$Pass\n" | passwd $User

echo -e "" 
echo -e "###############################
##                           ##
##   OPENHTTP PUNCHER TOOL   ##
##                           ##
##   Modified by iamBARTX™️   ##
##                           ##
###############################"
echo -e ""

rm -f ohp_barts.sh*
exit 1