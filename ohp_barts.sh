#!/bin/bash
# Debian and Ubuntu
# OPENHTTP PUNCHER TOOL SCRIPT by lfasmpao
# Modified by iamBARTX™️

# Install Updates
apt update -y 

#Install Needed Sevices
apt install squid dropbear zip unzip screen -y

#Create Squid.conf
cat <<EOF> /etc/squid/squid.conf
http_access allow all
http_port 127.0.0.1:8089
acl barts src 0.0.0.0/0.0.0.0
no_cache deny barts
dns_nameservers 1.1.1.1 1.0.0.1
visible_hostname localhost
EOF

# Create OHP Banner
cat <<'EOF2'> /etc/banner
BartX GTM No Load or With Promo
EOF2

# Create Dropbear
cat <<'EOF3' > /etc/default/dropbear
NO_START=0
DROPBEAR_PORT=110
DROPBEAR_EXTRA_ARGS=""
DROPBEAR_BANNER="/etc/banner"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
EOF3

#Setup Dropbear
echo "[Unit]
Description=Dropbear SSH Server Daemon
Documentation=man:dropbear(8)
Wants=dropbear-keygen.service
After=network.target

[Service]
ExecStart=/usr/sbin/dropbear -E -F -p 127.0.0.1:110 -b /etc/banner

[Install]
WantedBy=multi-user.target" > /etc/default/dropbear

chmod +x /etc/default/dropbear

# Restart Dropbear
systemctl daemon-reload && systemctl restart dropbear

#Restart Squid Proxy
service squid restart

#Install Http Puncher Tool
curl -4SL "https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip" -o ohp.zip

unzip -qq ohp.zip && rm -f ohp.zip

chmod +x ohpserver

screen -S barts -dm bash -c "./ohpserver -port 8088 -proxy 127.0.0.1:8089 -tunnel 127.0.0.1:110"

#screen -r barts

# Adding user/pass
echo '/bin/false' >> /etc/shells

User='Bartx';
Pass='Bartx';
useradd -m -s /bin/false $User && echo -e "$Pass\n$Pass\n" | passwd $User

echo -e "###############################
##                           ##
##   OPENHTTP PUNCHER TOOL   ##
##                           ##
##   Modified by iamBARTX™️   ##
##                           ##
###############################

rm -f ohp_barts*
exit 1
