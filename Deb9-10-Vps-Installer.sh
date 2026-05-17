#!/bin/bash
# Debian VPS Script
# Script created by Bonveio
# Do not resell and redistribute this script
# Project by BonvScripts <https://github.com/Bonveio/BonvScript





clear
cd ~
export DEBIAN_FRONTEND=noninteractive

function InsWebSocket() {
  clear
  echo -e "Installing and Configuring WebSocket"
  if [ -e /etc/sigmaphx ];
  then
    rm /etc/sigmaphx/* && rm -rf /etc/sigmaphx/* && rmdir /etc/sigmaphx
    iptables-restore < /etc/iptables/rules.v4
    systemctl stop sshws.service && systemctl disable sshws.service 2>/dev/null
    systemctl stop sslws.service && systemctl disable sslws.service 2>/dev/null
    systemctl stop ovpnws.service && systemctl disable ovpnws.service 2>/dev/null
    rm /usr/sbin/*.py && rm /usr/sbin/*.sh && cd /etc/systemd/system && rm sshws.service && rm sslws.service && rm ovpnws.service && cd $home
    touch bukya && crontab bukya && rm bukya
  else
    echo -e " SUCCESSFULLY INSTALLED"
  fi
  #Configure Iptables
  cd $home
  https://raw.githubusercontent.com/Jadyxph101/VPS/main/iptables.sh && chmod +x iptables.sh && ./iptables.sh &> /dev/null
  
  #Download Websockets
  cd /usr/sbin
  
  #SSHWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/PDirect.py
 &> /dev/null
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/Proxy.py &> /dev/null
  
  #SSLWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/PStunnel.py &> /dev/null
  
  #OVPNWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/POpenvpn.py &> /dev/null
  
  #Make it executable
  chmod +x PDirect.py && chmod +x PStunnel.py && chmod +x POpenvpn.py
  
  #Creating Services
  #This will create a services file to /etc/systemd/system
  cd $home && wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/ws-services.sh && chmod +x ws-services.sh && ./ws-services.sh &> /dev/null
  
  #Reload services
  systemctl daemon-reload 2>/dev/null
  systemctl enable sshws.service 2>/dev/null
  systemctl enable sslws.service 2>/dev/null
  systemctl enable ovpnws.service 2>/dev/null
  systemctl start sshws.service 2>/dev/null
  systemctl start sslws.service 2>/dev/null
  systemctl start ovpnws.service 2>/dev/null
  
  #Make cron job to delete logs
  crontab -l > cronsigmaphx
  echo "0 */12 * * * /bin/sh /etc/sigmaphx/remover.sh" >> cronsigmaphx
  echo "@daily systemctl reboot -i" >> cronsigmaphx
  echo "*/5 * * * * /bin/sh /etc/sigmaphx/checker.sh" >> cronsigmaphx
  crontab cronsigmaphx
  rm cronsigmaphx
  
  #Extras
  mkdir /etc/sigmaphx && cd /etc/sigmaphx && wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/remover.sh && chmod +x remover.sh &> /dev/null
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/bbr.sh && chmod +x bbr.sh && ./bbr.sh &> /dev/null
  
  #Now all thing is done time to remove some file
  cd $home && rm iptables.sh && rm ws-services.sh && rm /etc/sigmaphx/bbr.sh
cat <<'Chcker' > /etc/sigmaphx/checker.sh


#!/bin/bash
if [[ $(ps -ef | grep slowdns | grep 'SCREEN') ]] ;
 then
  /etc/sigmaphx/./slowdns-iptables.sh
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/main/dns-services && chmod +x dns-services && ./dns-services &> /dev/null
  systemctl daemon-reload 2>/dev/null
  systemctl enable dnstt.service 2>/dev/null
  systemctl start dnstt.service 2>/dev/null
  rm dns-services
  rm /etc/sigmaphx/checker.sh
  touch bukya && crontab bukya && rm bukya
  crontab -l > cronsigmaphx
  echo "0 */12 * * * /bin/sh /etc/sigmaphx/remover.sh" >> cronsigmaphx
  echo "@daily systemctl reboot -i" >> cronsigmaphx
  crontab cronsigmaphx
  rm cronsigmaphx
 else
  echo "Do Nothing..."
fi
Chcker
chmod u+x /etc/sigmaphx/checker.sh
}

function ip_address(){
  local IP="$( ip addr | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -Ev "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )"
  [ -z "${IP}" ] && IP="$(curl -4s ipv4.icanhazip.com)"
  [ -z "${IP}" ] && IP="$(curl -4s ipinfo.io/ip)"
  [ ! -z "${IP}" ] && echo "${IP}" || echo '0.0.0.0'
}

function BONV-MSG(){
 printf "%b\n" "\e[38;5;192m (｡◕‿◕｡)\e[0m\e[38;5;121m Bonveio Debian VPS Installer\e[0m"
 echo -e " v20201227 stable"
 echo -e ""
 echo -e " Updates: https://t.me/BonvScripts"
 echo -e ""
}

function InsEssentials(){
apt update 2>/dev/null
apt upgrade -y 2>/dev/null
printf "%b\n" "\e[32m[\e[0mInfo\e[32m]\e[0m\e[97m Please wait..\e[0m"
apt autoremove --fix-missing -y > /dev/null 2>&1
apt remove --purge apache* ufw -y > /dev/null 2>&1

# Server local time
timedatectl set-timezone Asia/Manila > /dev/null 2>&1

# Installing some important machine essentials
apt install nano wget curl zip unzip tar gzip p7zip-full bc rc openssl cron net-tools dnsutils dos2unix screen bzip2 ccrypt lsof -y 2>/dev/null


# Removing some firewall tools that may affect other services
if [[ "$(command -v firewall-cmd)" ]]; then
 apt remove --purge firewalld -y
 apt autoremove -y -f
fi

apt install iptables-persistent -y -f
systemctl restart netfilter-persistent &>/dev/null
systemctl enable netfilter-persistent &>/dev/null

apt install tuned -y -f > /dev/null 2>&1
 if [[ "$(command -v tuned-adm)" ]]; then
  systemctl enable tuned &>/dev/null
  systemctl restart tuned &>/dev/null
  tuned-adm profile throughput-performance 2>/dev/null
 fi


# Now installing all our wanted services
apt install dropbear stunnel4 privoxy ca-certificates nginx ruby apt-transport-https lsb-release squid jq tcpdump dsniff grepcidr screenfetch -y 2>/dev/null

 # Installing all required packages to install Webmin
apt install perl libnet-ssleay-perl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python dbus libxml-parser-perl shared-mime-info -y 2>/dev/null

# Installing a text colorizer
gem install lolcat 2>/dev/null

# Trying to remove obsolette packages after installation
apt autoremove --fix-missing -y &>/dev/null

# Installing OpenVPN by pulling its repository inside sources.list file 
 #rm -rf /etc/apt/sources.list.d/openvpn*
rm -rf /etc/apt/sources.list.d/openvpn*
echo "deb http://build.openvpn.net/debian/openvpn/stable $(lsb_release -sc) main" > /etc/apt/sources.list.d/openvpn.list
apt-key del E158C569 &> /dev/null

wget -qO - https://raw.githubusercontent.com/Bonveio/BonvScripts/master/openvpn-repo.gpg | apt-key add - &>/dev/null

apt update 2>/dev/null
apt install openvpn git build-essential libssl-dev libnss3-dev cmake -y 2>/dev/null
apt autoremove --fix-missing -y &>/dev/null
apt clean 2>/dev/null

if [[ "$(command -v squid)" ]]; then
 if [[ "$(squid -v | grep -Ec '(V|v)ersion\s3.5.23')" -lt 1 ]]; then
  apt remove --purge squid -y -f 2>/dev/null
  wget "http://security.debian.org/debian-security/pool/updates/main/s/squid3/squid_3.5.23-5+deb9u5_amd64.deb" -qO squid.deb
  dpkg -i squid.deb
  rm -f squid.deb
 else
  echo -e "Squid v3.5.23 already installed"
 fi
else
 apt install libecap3 squid-common squid-langpack -y -f 2>/dev/null
 wget "http://security.debian.org/debian-security/pool/updates/main/s/squid3/squid_3.5.23-5+deb9u5_amd64.deb" -qO squid.deb
 dpkg -i squid.deb
 rm -f squid.deb
fi

## install squid3 if deb10
if [ -e /etc/squid/squid.conf ];
 then
 echo -e "squid3 already installed"
 else
 # install squid3
 cd $home && apt install squid3 -y
 # removing file squid.conf
 rm /etc/squid/squid.conf
fi

if [[ "$(command -v privoxy)" ]]; then
 apt remove privoxy -y -f 2>/dev/null
 wget -qO /tmp/privoxy.deb 'https://download.sourceforge.net/project/ijbswa/Debian/3.0.28%20%28stable%29%20stretch/privoxy_3.0.28-1_amd64.deb'
 dpkg -i  --force-overwrite /tmp/privoxy.deb
 rm -f /tmp/privoxy.deb
fi

## Running FFSend installation in background
rm -rf {/usr/bin/ffsend,/usr/local/bin/ffsend}
printf "%b\n" "\e[32m[\e[0mInfo\e[32m]\e[0m\e[97m running FFSend installation on background\e[0m"
screen -S ffsendinstall -dm bash -c "curl -4skL "https://github.com/timvisee/ffsend/releases/download/v0.2.65/ffsend-v0.2.65-linux-x64-static" -o /usr/bin/ffsend && chmod a+x /usr/bin/ffsend"
hostnamectl set-hostname localhost &> /dev/null
printf "%b\n" "\e[32m[\e[0mInfo\e[32m]\e[0m\e[97m running DDoS-deflate installation on background\e[0m"
cat <<'ddosEOF'> /tmp/install-ddos.bash
#!/bin/bash
if [[ -e /etc/ddos ]]; then
 printf "%s\n" "DDoS-deflate already installed" && exit 1
else
 curl -4skL "https://github.com/jgmdev/ddos-deflate/archive/master.zip" -o ddos.zip
 unzip -qq ddos.zip
 rm -rf ddos.zip
 cd ddos-deflate-master
 echo -e "/r/n/r/n"
 ./install.sh &> /dev/null
 cd .. && rm -rf ddos-deflate-master
 systemctl start ddos &> /dev/null
 systemctl enable ddos &> /dev/null
fi
ddosEOF
screen -S ddosinstall -dm bash -c "bash /tmp/install-ddos.bash && rm -f /tmp/install-ddos.bash"

printf "%b\n" "\e[32m[\e[0mInfo\e[32m]\e[0m\e[97m running Iptables configuration on background\e[0m"
cat <<'iptEOF'> /tmp/iptables-config.bash

#!/bin/bash
function ip_address(){
  local IP="$( ip addr | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -Ev "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )"
  [ -z "${IP}" ] && IP="$(curl -4s ipv4.icanhazip.com)"
  [ -z "${IP}" ] && IP="$(curl -4s ipinfo.io/ip)"
  [ ! -z "${IP}" ] && echo "${IP}" || echo 'ipaddress'
}
IPADDR="$(ip_address)"
PNET="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)"
CIDR="172.29.0.0/16"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables -A INPUT -s $IPADDR -p tcp -m multiport --dport 1:65535 -j ACCEPT
iptables -A INPUT -s $IPADDR -p udp -m multiport --dport 1:65535 -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j REJECT   
iptables -A FORWARD -p tcp --dport 25 -j REJECT
iptables -A OUTPUT -p tcp --dport 25 -j REJECT
iptables -I FORWARD -s $CIDR -j ACCEPT
iptables -t nat -A POSTROUTING -s $CIDR -o $PNET -j MASQUERADE
iptables -t nat -A POSTROUTING -s $CIDR -o $PNET -j SNAT --to-source $IPADDR
iptables -A INPUT -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A INPUT -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A INPUT -m string --algo bm --string ".torrent" -j REJECT
iptables -A INPUT -m string --algo bm --string "torrent" -j REJECT
iptables -A INPUT -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A INPUT -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A INPUT -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A FORWARD -m string --algo bm --string ".torrent" -j REJECT
iptables -A FORWARD -m string --algo bm --string "torrent" -j REJECT
iptables -A FORWARD -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A FORWARD -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables -A OUTPUT -m string --algo bm --string "BitTorrent" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "BitTorrent protocol" -j REJECT
iptables -A OUTPUT -m string --algo bm --string ".torrent" -j REJECT
iptables -A OUTPUT -m string --algo bm --string "torrent" -j REJECT
iptables -A OUTPUT -m string --string "BitTorrent" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "BitTorrent protocol" --algo kmp -j REJECT
iptables -A OUTPUT -m string --string "bittorrent-announce" --algo kmp -j REJECT
iptables-save > /etc/iptables/rules.v4
iptEOF
screen -S configIptables -dm bash -c "bash /tmp/iptables-config.bash && rm -f /tmp/iptables-config.bash"

printf "%b\n" "\e[32m[\e[0mInfo\e[32m]\e[0m\e[97m running BadVPN-udpgw installation on background\e[0m"
cat <<'badvpnEOF'> /tmp/install-badvpn.bash
#!/bin/bash
if [[ -e /usr/local/bin/badvpn-udpgw ]]; then
 printf "%s\n" "BadVPN-udpgw already installed"
 exit 1
else
 curl -4skL "https://github.com/ambrop72/badvpn/archive/4b7070d8973f99e7cfe65e27a808b3963e25efc3.zip" -o /tmp/badvpn.zip
 unzip -qq /tmp/badvpn.zip -d /tmp && rm -f /tmp/badvpn.zip
 cd /tmp/badvpn-4b7070d8973f99e7cfe65e27a808b3963e25efc3
 cmake -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1 &> /dev/null
 make install &> /dev/null
 rm -rf /tmp/badvpn-4b7070d8973f99e7cfe65e27a808b3963e25efc3
 cat <<'EOFudpgw' > /lib/systemd/system/badvpn-udpgw.service
[Unit]
Description=BadVPN UDP Gateway Server daemon
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 4000 --max-connections-for-client 4000 --loglevel info
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOFudpgw

systemctl daemon-reload &>/dev/null
systemctl restart badvpn-udpgw.service &>/dev/null
systemctl enable badvpn-udpgw.service &>/dev/null

fi
badvpnEOF
screen -S badvpninstall -dm bash -c "bash /tmp/install-badvpn.bash && rm -f /tmp/install-badvpn.bash"
}


function ConfigOpenSSH(){
echo -e "[\e[32mInfo\e[0m] Configuring OpenSSH Service"
if [[ "$(cat < /etc/ssh/sshd_config | grep -c 'BonvScripts')" -eq 0 ]]; then
 cp /etc/ssh/sshd_config /etc/ssh/backup.sshd_config
fi

# Creating a SSH server config using cat eof tricks
cat <<'EOFOpenSSH' > /etc/ssh/sshd_config

Port 22
Port 225
ListenAddress 0.0.0.0
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key
#KeyRegenerationInterval 3600
#ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
PermitRootLogin yes
StrictModes yes
#RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
#RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
#GatewayPorts yes
PrintMotd no
PrintLastLog yes
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
Banner /etc/banner
TCPKeepAlive yes
ClientAliveInterval 120
ClientAliveCountMax 2
UseDNS no
EOFOpenSSH

curl -4skL "https://raw.githubusercontent.com/noahclanman/sshbanner/main/sshbanner.txt" -o /etc/banner

sed -i '/password\s*requisite\s*pam_cracklib.s.*/d' /etc/pam.d/common-password && sed -i 's|use_authtok ||g' /etc/pam.d/common-password

echo -e "[\e[33mNotice\e[0m] Restarting OpenSSH Service.."
systemctl restart ssh &> /dev/null
}


function ConfigDropbear(){
echo -e "[\e[32mInfo\e[0m] Configuring Dropbear.."
cat <<'EOFDropbear' > /etc/default/dropbear
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
NO_START=0
DROPBEAR_PORT=555
DROPBEAR_EXTRA_ARGS="-p 550 -p 143"
DROPBEAR_BANNER="/etc/banner"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
EOFDropbear

echo -e "[\e[33mNotice\e[0m] Restarting Dropbear Service.."
systemctl enable dropbear &>/dev/null
systemctl restart dropbear &>/dev/null
}


function ConfigStunnel(){
if [[ ! "$(command -v stunnel4)" ]]; then
 StunnelDir='stunnel'
 else
 StunnelDir='stunnel4'
fi
echo -e "[\e[32mInfo\e[0m] Configuring Stunnel.."
cat <<'EOFStunnel1' > "/etc/default/$StunnelDir"
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
BANNER="/etc/banner"
PPP_RESTART=0
# RLIMITS="-n 4096 -d unlimited"
RLIMITS=""
EOFStunnel1

 # Removing all stunnel folder contents
rm -f /etc/stunnel/*
echo -e "[\e[32mInfo\e[0m] Cloning Stunnel.pem.."

 # Creating stunnel certifcate using openssl
openssl req -new -x509 -days 9999 -nodes -subj "/C=PH/ST=CALABARZON/L=Rizal/O=$MyScriptName/OU=$MyScriptName/CN=$MyScriptName" -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem &> /dev/null

echo -e "[\e[32mInfo\e[0m] Creating Stunnel server config.."

 # Creating stunnel server config
cat <<'EOFStunnel3' > /etc/stunnel/stunnel.conf


# My Stunnel Config
pid = /var/run/stunnel.pid
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
TIMEOUTclose = 0

[dropbear]
accept = 443
connect = 127.0.0.1:550

[openssh]
accept = 444
connect = 127.0.0.1:225

[openvpn]
accept = 995
connect = 127.0.0.1:110

[pop3]
accept = 993
connect = 127.0.0.1:143
              
[openvpn_websocket]
accept = 8443
connect = 127.0.0.1:8080

[ssl_websocket_8280]
accept = 2053
connect = 127.0.0.1:8280

[ssl_websocket_kh1]
accept = 9443
connect = 127.0.0.1:8880

[ssl_websocket_kh2]
accept = 8243
connect = 127.0.0.1:8880
EOFStunnel3

echo -e "[\e[33mNotice\e[0m] Restarting Stunnel.."
systemctl restart "$StunnelDir"
}


function ConfigProxy(){
echo -e "[\e[32mInfo\e[0m] Configuring Privoxy.."
rm -f /etc/privoxy/config*
cat <<'EOFprivoxy' > /etc/privoxy/config
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 127.0.0.1:25800
toggle 1
enable-remote-toggle 0
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
max-client-connections 4000
enable-proxy-authentication-forwarding 1
forwarded-connect-retries 1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
EOFprivoxy
cat <<'EOFprivoxy2' > /etc/privoxy/user.action
{ +block }
/

{ -block }
IP-ADDRESS
127.0.0.1
EOFprivoxy2
sed -i "s|IP-ADDRESS|$(ip_address)|g" /etc/privoxy/user.action
echo -e "[\e[32mInfo\e[0m] Configuring Squid.."
rm -rf /etc/squid/sq*
cat <<'EOFsquid' > /etc/squid/squid.conf
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298

acl VPN dst IP-ADDRESS/32
http_access allow VPN
http_access deny all
http_port 0.0.0.0:8000
http_port 0.0.0.0:8888
http_port 0.0.0.0:8080

acl bonv src 0.0.0.0/0.0.0.0
no_cache deny bonv
dns_nameservers 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
visible_hostname localhost
EOFsquid
sed -i "s|IP-ADDRESS|$(ip_address)|g" /etc/squid/squid.conf

echo -e "[\e[33mNotice\e[0m] Restarting Privoxy Service.."
systemctl restart privoxy
echo -e "[\e[33mNotice\e[0m] Restarting Squid Service.."
systemctl restart squid

##  OHP SERVER ##


function ConfigWebmin(){
printf "%b\n" "\e[1;32m[\e[0mInfo\e[1;32m]\e[0m\e[97m running Webmin installation on background\e[0m"
cat <<'webminEOF'> /tmp/install-webmin.bash
#!/bin/bash
if [[ -e /etc/webmin ]]; then
 echo 'Webmin already installed' && exit 1
fi
rm -rf /etc/apt/sources.list.d/webmin*
echo 'deb https://download.webmin.com/download/repository sarge contrib' > /etc/apt/sources.list.d/webmin.list
apt-key del 1719003ACE3E5A41E2DE70DFD97A3AE911F63C51 &> /dev/null
wget -qO - https://download.webmin.com/jcameron-key.asc | apt-key add - &> /dev/null
apt update &> /dev/null
apt install webmin -y &> /dev/null
sed -i "s|\(ssl=\).\+|\10|" /etc/webmin/miniserv.conf
lsof -t -i tcp:10000 -s tcp:listen | xargs kill 2>/dev/null
systemctl restart webmin &> /dev/null
systemctl enable webmin &> /dev/null
webminEOF
screen -S webmininstall -dm bash -c "bash /tmp/install-webmin.bash && rm -f /tmp/install-webmin.bash"
}

function ConfigOpenVPN(){
# Checking if openvpn folder is accidentally deleted or purged
echo -e "[\e[32mInfo\e[0m] Configuring OpenVPN server.."
if [[ ! -e /etc/openvpn ]]; then

# Removing all existing openvpn server files
 mkdir -p /etc/openvpn
 else
 rm -rf /etc/openvpn/*
fi
mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/client

# Creating server.conf, ca.crt, server.crt and server.key
 cat <<'myOpenVPNconf1' > /etc/openvpn/server_tcp.conf
# XAMScript

port MyOvpnPort1
dev tun
proto tcp
ca /etc/openvpn/ca.crt
cert /etc/openvpn/xbarts.crt
key /etc/openvpn/xbarts.key
duplicate-cn
dh none
persist-tun
persist-key
persist-remote-ip
cipher none
ncp-disable
auth none
comp-lzo
tun-mtu 1500
reneg-sec 0
plugin /etc/openvpn/openvpn-auth-pam.so /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4000
topology subnet
server 172.16.0.0 255.255.0.0
push "redirect-gateway def1"
keepalive 5 60
status /etc/openvpn/tcp_stats.log
log /etc/openvpn/tcp.log
verb 2
script-security 2
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
myOpenVPNconf1
cat <<'myOpenVPNconf2' > /etc/openvpn/server_udp.conf
# XAMScript

port MyOvpnPort2
dev tun
proto udp
ca /etc/openvpn/ca.crt
cert /etc/openvpn/xbarts.crt
key /etc/openvpn/xbarts.key
duplicate-cn
dh none
persist-tun
persist-key
persist-remote-ip
cipher none
ncp-disable
auth none
comp-lzo
tun-mtu 1500
reneg-sec 0
plugin /etc/openvpn/openvpn-auth-pam.so /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4000
topology subnet
server 172.17.0.0 255.255.0.0
push "redirect-gateway def1"
keepalive 5 60
status /etc/openvpn/tcp_stats.log
log /etc/openvpn/tcp.log
verb 2
script-security 2
socket-flags TCP_NODELAY
push "socket-flags TCP_NODELAY"
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"
myOpenVPNconf2
 cat <<'EOF7'> /etc/openvpn/ca.crt
-----BEGIN CERTIFICATE-----
MIID0jCCAzugAwIBAgIJALnVZsGmA5VVMA0GCSqGSIb3DQEBCwUAMIGeMQswCQYD
VQQGEwJQSDEOMAwGA1UECAwFQklLT0wxDTALBgNVBAcMBE5hZ2ExFDASBgNVBAoM
C1NjcmlwdEJhcnRzMSQwIgYDVQQLDBtodHRwczovL2dpdGh1Yi5jb20vQmFydHMt
MjMxETAPBgNVBAMMCElBTUJBUlRYMSEwHwYJKoZIhvcNAQkBFhJpYW1iYXJ0eEBn
bWFpbC5jb20wHhcNMjAwODE5MTUzNDM3WhcNNDgwMTA0MTUzNDM3WjCBnjELMAkG
A1UEBhMCUEgxDjAMBgNVBAgMBUJJS09MMQ0wCwYDVQQHDAROYWdhMRQwEgYDVQQK
DAtTY3JpcHRCYXJ0czEkMCIGA1UECwwbaHR0cHM6Ly9naXRodWIuY29tL0JhcnRz
LTIzMREwDwYDVQQDDAhJQU1CQVJUWDEhMB8GCSqGSIb3DQEJARYSaWFtYmFydHhA
Z21haWwuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbIUbQYcSduz0B
HdaLDGUxByjbdS7R8RQBUmsGbdhZFDSAsqlesgDPfkWO3lUHlUxVf5z3S/aJIvpk
dUeG80p0bHgqJBbkaJWdZzlqS47WPr5N9mkzx7ZxOel5zLTsXGL316SbqKuSXP9K
8FysbxNUOqQw+0PcRR9qRGWFU/d1jQIDAQABo4IBFDCCARAwHQYDVR0OBBYEFKfS
tTje+kKpL1hc2Dt2RaV1yeklMIHTBgNVHSMEgcswgciAFKfStTje+kKpL1hc2Dt2
RaV1yekloYGkpIGhMIGeMQswCQYDVQQGEwJQSDEOMAwGA1UECAwFQklLT0wxDTAL
BgNVBAcMBE5hZ2ExFDASBgNVBAoMC1NjcmlwdEJhcnRzMSQwIgYDVQQLDBtodHRw
czovL2dpdGh1Yi5jb20vQmFydHMtMjMxETAPBgNVBAMMCElBTUJBUlRYMSEwHwYJ
KoZIhvcNAQkBFhJpYW1iYXJ0eEBnbWFpbC5jb22CCQC51WbBpgOVVTAMBgNVHRME
BTADAQH/MAsGA1UdDwQEAwIBBjANBgkqhkiG9w0BAQsFAAOBgQBwdEQ1WxL+CFnu
TXpxBDxCAdVt0wx/BajZoUTFQNx+ayLvbMZG/u39blTYlZZ/Q2VRFw6wa+VRviDk
qLaAs4jTq/IhomRM5eEZRvcCx7sgs5zu3ggD6HFZqrlrTS7XKxBgASkuJtT/DiT8
u37RrsJDD4VPMq8d+Jc0HqPwdatkKg==
-----END CERTIFICATE-----
EOF7
 cat <<'EOF9'> /etc/openvpn/xbarts.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            77:4a:a5:72:b1:bf:cb:e3:9e:77:75:7d:02:96:eb:e3
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=BIKOL, L=Naga, O=ScriptBarts, OU=https://github.com/Barts-23, CN=IAMBARTX/emailAddress=iambartx@gmail.com
        Validity
            Not Before: Aug 19 15:34:54 2020 GMT
            Not After : Jan  4 15:34:54 2048 GMT
        Subject: C=PH, ST=CALABARZON, L=Rizal, O=ScriptBarts, OU=https://github.com/Barts-23, CN=server/emailAddress=iambartx@gmail.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (1024 bit)
                Modulus:
                    00:a7:b4:a7:d4:25:46:3d:0c:f0:55:9b:32:cb:8b:
                    92:e2:d6:d4:d8:09:c2:60:14:30:1b:27:95:76:87:
                    4e:9e:3e:b1:0c:c9:98:02:77:a1:ec:e8:c3:92:6d:
                    b4:e9:86:19:76:35:71:7d:2b:91:70:c0:9b:f3:b7:
                    30:1a:53:12:e0:d8:5e:7b:0c:65:f0:60:36:22:d3:
                    9e:49:ff:2a:74:04:33:ba:f7:a2:98:02:f4:1f:2c:
                    32:d3:c1:be:af:f1:8a:8b:72:fb:7e:8f:4d:73:30:
                    d3:3b:d3:79:77:14:96:37:e4:45:82:6f:a3:3a:05:
                    a1:db:78:13:d5:f0:31:51:89
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            X509v3 Subject Key Identifier: 
                9C:3B:FA:35:9F:A8:21:33:97:83:2F:E4:82:85:39:7E:B6:36:8B:72
            X509v3 Authority Key Identifier: 
                keyid:A7:D2:B5:38:DE:FA:42:A9:2F:58:5C:D8:3B:76:45:A5:75:C9:E9:25
                DirName:/C=PH/ST=CALABARZON/L=Rizal/O=ScriptBarts/OU=https://github.com/Barts-23/CN=IAMBARTX/emailAddress=iambartx@gmail.com
                serial:B9:D5:66:C1:A6:03:95:55

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:server
    Signature Algorithm: sha256WithRSAEncryption
         12:ba:a0:bc:95:0f:29:95:84:48:7c:01:ee:04:e1:8c:57:1b:
         08:8d:08:0e:cd:14:f0:5a:50:59:13:f9:04:64:d0:37:96:b0:
         1d:b7:7f:62:2f:03:78:12:1a:ec:93:bd:9c:0b:15:b8:71:c7:
         2d:75:50:56:3f:13:94:22:0a:e3:de:e3:a1:1e:33:49:e4:76:
         d6:91:ad:e7:10:72:80:c8:38:67:70:90:cb:b7:21:49:32:a3:
         fc:95:ef:d7:0d:97:87:cc:40:72:d5:42:1f:d9:9c:a7:ba:8b:
         5e:f9:69:4f:3d:c6:da:6c:e1:8d:96:cc:ad:66:50:f3:5c:db:
         74:fd
-----BEGIN CERTIFICATE-----
MIID/DCCA2WgAwIBAgIQd0qlcrG/y+Oed3V9Apbr4zANBgkqhkiG9w0BAQsFADCB
njELMAkGA1UEBhMCUEgxDjAMBgNVBAgMBUJJS09MMQ0wCwYDVQQHDAROYWdhMRQw
EgYDVQQKDAtTY3JpcHRCYXJ0czEkMCIGA1UECwwbaHR0cHM6Ly9naXRodWIuY29t
L0JhcnRzLTIzMREwDwYDVQQDDAhJQU1CQVJUWDEhMB8GCSqGSIb3DQEJARYSaWFt
YmFydHhAZ21haWwuY29tMB4XDTIwMDgxOTE1MzQ1NFoXDTQ4MDEwNDE1MzQ1NFow
gZwxCzAJBgNVBAYTAlBIMQ4wDAYDVQQIDAVCSUtPTDENMAsGA1UEBwwETmFnYTEU
MBIGA1UECgwLU2NyaXB0QmFydHMxJDAiBgNVBAsMG2h0dHBzOi8vZ2l0aHViLmNv
bS9CYXJ0cy0yMzEPMA0GA1UEAwwGc2VydmVyMSEwHwYJKoZIhvcNAQkBFhJpYW1i
YXJ0eEBnbWFpbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKe0p9Ql
Rj0M8FWbMsuLkuLW1NgJwmAUMBsnlXaHTp4+sQzJmAJ3oezow5JttOmGGXY1cX0r
kXDAm/O3MBpTEuDYXnsMZfBgNiLTnkn/KnQEM7r3opgC9B8sMtPBvq/xioty+36P
TXMw0zvTeXcUljfkRYJvozoFodt4E9XwMVGJAgMBAAGjggE5MIIBNTAJBgNVHRME
AjAAMB0GA1UdDgQWBBScO/o1n6ghM5eDL+SChTl+tjaLcjCB0wYDVR0jBIHLMIHI
gBSn0rU43vpCqS9YXNg7dkWldcnpJaGBpKSBoTCBnjELMAkGA1UEBhMCUEgxDjAM
BgNVBAgMBUJJS09MMQ0wCwYDVQQHDAROYWdhMRQwEgYDVQQKDAtTY3JpcHRCYXJ0
czEkMCIGA1UECwwbaHR0cHM6Ly9naXRodWIuY29tL0JhcnRzLTIzMREwDwYDVQQD
DAhJQU1CQVJUWDEhMB8GCSqGSIb3DQEJARYSaWFtYmFydHhAZ21haWwuY29tggkA
udVmwaYDlVUwEwYDVR0lBAwwCgYIKwYBBQUHAwEwCwYDVR0PBAQDAgWgMBEGA1Ud
EQQKMAiCBnNlcnZlcjANBgkqhkiG9w0BAQsFAAOBgQASuqC8lQ8plYRIfAHuBOGM
VxsIjQgOzRTwWlBZE/kEZNA3lrAdt39iLwN4Ehrsk72cCxW4ccctdVBWPxOUIgrj
3uOhHjNJ5HbWka3nEHKAyDhncJDLtyFJMqP8le/XDZeHzEBy1UIf2Zynuote+WlP
PcbabOGNlsytZlDzXNt0/Q==
-----END CERTIFICATE-----
EOF9
 cat <<'EOF10'> /etc/openvpn/xbarts.key
-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKe0p9QlRj0M8FWb
MsuLkuLW1NgJwmAUMBsnlXaHTp4+sQzJmAJ3oezow5JttOmGGXY1cX0rkXDAm/O3
MBpTEuDYXnsMZfBgNiLTnkn/KnQEM7r3opgC9B8sMtPBvq/xioty+36PTXMw0zvT
eXcUljfkRYJvozoFodt4E9XwMVGJAgMBAAECgYBiMSBi0kBB1qWROgGPs/UY4/hT
VcN9RdS00YRtleOuO76mYhKivzEL6W04+wsGAAJAeCIuy6eogN3O4N9FSoauNNq+
Om95WGLY+OWE9H61Y+UioafqMRN6CFiSvy1a0inOclunBljcf68uZIkeKgTPoc0v
osNfuCas7LfO48XPkQJBANFoKHsAqdYvbF+/RZqVfd5sqXMUPNCww9YeQsGz3mBp
yp+Tx7T+wGUKGKZzD9fqwN2+z0kP1QYtkCSF4pRL4ZMCQQDNBTFc0AWBietYonsN
ewllx+D72k5Tt2TdSBOhYsoZFu28ybkiagGLDBsQsAdpsjSc7HiaBsuiyLjS16kK
eOHzAkEAmnLZUIeXvFrz8tavbqmN0YyRmkg15rJJbtaY5CdXAANnKDWmGU+/9YXx
0mqRJ+6EW8jNOBUOSGU4qEd7a2dgMwJABUyjEAEYg1arTKk2gQyzG3xlJl1oNOXC
p62bREqnaqqbDowwSuFulMeFU5MZPfQrQ/sgyupuDREfJeQJLIofXQJBAKpVRR0G
JFriv/ukvYSEiw4bgneXbKtTjvXVE5B518RSPaaLEdz7agCJZ3yGWt8Hw3L1GEHE
1Z9t3f/rftuj+4U=
-----END PRIVATE KEY-----
EOF10


# setting openvpn server port
 sed -i "s|MyOvpnPort1|$OpenVPN_Port1|g" /etc/openvpn/server_tcp.conf
 sed -i "s|MyOvpnPort2|$OpenVPN_Port2|g" /etc/openvpn/server_udp.conf

# Getting some OpenVPN plugins for unix authentication
wget -qO /etc/openvpn/b.zip 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/openvpn_plugin64'
unzip -qq /etc/openvpn/b.zip -d /etc/openvpn
rm -f /etc/openvpn/b.zip

ovpnPluginPam="$(find /usr -iname 'openvpn-*.so' | grep 'auth-pam' | head -n1)"
if [[ -z "$ovpnPluginPam" ]]; then
 sed -i "s|PLUGIN_AUTH_PAM|/etc/openvpn/openvpn-auth-pam.so|g" /etc/openvpn/server/*.conf
else
 sed -i "s|PLUGIN_AUTH_PAM|$ovpnPluginPam|g" /etc/openvpn/server/*.conf
fi

sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.conf
sed -i '/#net.ipv4.ip_forward.*/d' /etc/sysctl.conf
sed -i '/net.ipv4.ip_forward.*/d' /etc/sysctl.d/*
sed -i '/#net.ipv4.ip_forward.*/d' /etc/sysctl.d/*
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/20-openvpn.conf
sysctl --system &> /dev/null



# Some workaround for OpenVZ machines for "Startup error" openvpn service
if [[ "$(hostnamectl | grep -i Virtualization | awk '{print $2}' | head -n1)" == 'openvz' ]]; then
 sed -i 's|LimitNPROC|#LimitNPROC|g' /lib/systemd/system/openvpn*
 systemctl daemon-reload
fi

sed -i 's|ExecStart=.*|ExecStart=/usr/sbin/openvpn --status %t/openvpn-server/status-%i.log --status-version 2 --suppress-timestamps --config %i.conf|g' /lib/systemd/system/openvpn-server\@.service
systemctl daemon-reload

echo -e "[\e[33mNotice\e[0m] Restarting OpenVPN Service.."
systemctl restart openvpn-server &> /dev/null
systemctl start openvpn-server@server_tcp &>/dev/null
systemctl start openvpn-server@server_udp &>/dev/null
systemctl enable openvpn-server@server_tcp &> /dev/null
systemctl enable openvpn-server@server_udp &> /dev/null

systemctl start openvpn-server@ec_server_tcp &> /dev/null
systemctl start openvpn-server@ec_server_udp &> /dev/null
systemctl enable openvpn-server@ec_server_tcp &> /dev/null
systemctl enable openvpn-server@ec_server_udp &> /dev/null
}

function ConfigMenu(){
echo -e "[\e[32mInfo\e[0m] Creating Menu scripts.."

cd /usr/local/sbin/
rm -rf {accounts,base-ports,base-ports-wc,base-script,bench-network,clearcache,connections,create,create_random,create_trial,delete_expired,diagnose,edit_dropbear,edit_openssh,edit_openvpn,edit_ports,edit_squi*,edit_stunne*,locked_list,menu,options,ram,reboot_sys,reboot_sys_auto,restart_services,screenfetch,server,set_multilogin_autokill,set_multilogin_autokill_lib,show_ports,speedtest,user_delete,user_details,user_details_lib,user_extend,user_list,user_lock,user_unlock,*_gtm_noload}
wget -q 'https://raw.githubusercontent.com/Bonveio/BonvScripts/master/menuV1.zip'
unzip -qq -o menuV1.zip
rm -f menuV1.zip
chmod +x ./*
dos2unix -q ./*
cd ~
}

function ConfigSyscript(){
echo -e "[\e[32mInfo\e[0m] Creating Startup scripts.."
if [[ ! -e /etc/bonveio ]]; then
 mkdir -p /etc/bonveio
fi
cat <<'EOFSH' > /etc/bonveio/startup.sh
#!/bin/bash
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
#
export DEBIAN_FRONTEND=noninteractive
#apt clean
screen -S delexpuser -dm bash -c "/usr/local/sbin/delete_expired" &>/dev/null
EOFSH
chmod +x /etc/bonveio/startup.sh

echo 'clear' > /etc/profile.d/bonv.sh
echo 'screenfetch -p -A Debian | sed -r "/^\s*$/d" ' >> /etc/profile.d/bonv.sh
chmod +x /etc/profile.d/bonv.sh

echo "[Unit]
Description=Bonveio Startup Script
Before=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/bonveio/startup.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/bonveio.service
chmod +x /etc/systemd/system/bonveio.service
systemctl daemon-reload
systemctl start bonveio
systemctl enable bonveio &> /dev/null

#sed -i '/0\s*4\s*.*/d' /etc/cron.d/*
#sed -i '/0\s*4\s*.*/d' /etc/crontab
sed -i '/*.root\sreboot$/d' /etc/cron.d/*
sed -i '/*.root\sreboot$/d' /etc/crontab
echo -e "\r\n" >> /etc/crontab
echo -e "0 4\t* * *\troot\treboot" >> /etc/cron.d/reboot_sys
printf "%s" "0 */4  * * *  root  /usr/bin/screen -S delexpuser -dm bash -c '/usr/local/sbin/delete_expired'" > /etc/cron.d/autodelete_expireduser
systemctl restart cron
}

function ConfigNginxOvpn(){
echo -e "[\e[32mInfo\e[0m] Configuring Nginx configs.."

cat <<'EOFnginx' > /etc/nginx/conf.d/bonveio-ovpn-config.conf
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
#
server {
 listen 0.0.0.0:86;
 server_name localhost;
 root /var/www/openvpn;
 index index.html;
}
EOFnginx

rm -rf /etc/nginx/sites-*
rm -rf /usr/share/nginx/html
rm -rf /var/www/openvpn
mkdir -p /var/www/openvpn

echo -e "[\e[32mInfo\e[0m] Creating OpenVPN client configs.."

# Creating OVPN download site index.html
cat <<'mySiteOvpn' > /var/www/openvpn/index.html
<!DOCTYPE html>
<html lang="en">

<!-- OVPN Download site by XAMJYSS -->

<head><meta charset="utf-8" /><title>MyScriptName OVPN Config Download</title><meta name="description" content="MyScriptName Server" /><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="theme-color" content="#000000" /><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"><link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"><link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet"></head><body><div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;"><div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"><div class="mask rgba-white-slight"></div></div><div class="card"><div class="card-body"><h5 class="card-title">Config List</h5><br /><ul class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Globe/TM <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For EZ/GS Promo with WNP freebies</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GTMConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For TU UDP Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/SunConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> Trinet GIGASTORIES Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GStories.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li></ul></div></div></div></div></body></html>
mySiteOvpn

sed -i "s|MyScriptName|JadyxPH|g" /var/www/openvpn/index.html
sed -i "s|NGINXPORT|86|g" /var/www/openvpn/index.html
sed -i "s|IP-ADDRESS|$(ip_address)|g" /var/www/openvpn/index.html

######
 # Restarting nginx service
 systemctl restart nginx
 
 # Creating all .ovpn config archives
cd /var/www/openvpn
zip -r Configs.zip *.ovpn &> /dev/null
cd

echo -e "[\e[33mNotice\e[0m] Restarting Nginx Service.."
systemctl restart nginx
}

function UnistAll(){
 echo -e " Removing dropbear"
 sed -i '/Port 225/d' /etc/ssh/sshd_config
 sed -i '/Banner .*/d' /etc/ssh/sshd_config
 systemctl restart ssh
 systemctl stop dropbear
 apt remove --purge dropbear -y
 rm -f /etc/default/dropbear
 rm -rf /etc/dropbear/*
 echo -e " Removing stunnel"
 systemctl stop stunnel &> /dev/null
 systemctl stop stunnel4 &> /dev/null
 apt remove --purge stunnel -y
 rm -rf /etc/stunnel/*
 rm -rf /etc/default/stunnel*
 echo -e " Removing webmin"
 systemctl stop webmin
 apt remove --purge webmin -y
 rm -rf /etc/webmin/*;
 rm -f /etc/apt/sources.list.d/webmin*;
 echo -e " Removing OpenVPN server and client config download site"
 systemctl stop openvpn-server@server_tcp &>/dev/null
 systemctl stop openvpn-server@server_udp &>/dev/null
 systemctl stop openvpn-server@ec_server_tcp &>/dev/null
 systemctl stop openvpn-server@ec_server_udp &>/dev/null
 systemctl disable openvpn-server@server_tcp &>/dev/null
 systemctl disable openvpn-server@server_udp &>/dev/null
 systemctl disable openvpn-server@ec_server_tcp &>/dev/null
 systemctl disable openvpn-server@ec_server_udp &>/dev/null
 apt remove --purge openvpn -y -f
 rm -rf /etc/openvpn/*
 rm -rf /var/www/openvpn
 rm -f /etc/apt/sources.list.d/openvpn*
 rm -rf /etc/nginx/conf.d/bonveio-ovpn-config*
 systemctl restart nginx &> /dev/null
 echo -e "Removing squid"
 apt remove --purge squid -y
 rm -rf /etc/squid/*
 echo -e "Removing privoxy"
 apt remove --purge privoxy -y
 rm -rf /etc/privoxy/*
 systemctl stop badvpn-udpgw.service &>/dev/null
 systemctl disable badvpn-udpgw.service &>/dev/null
 rm -rf /usr/local/{share/man/man7/badvpn*,share/man/man8/badvpn*,bin/badvpn-*}
 echo -e " Finalizing.."
 rm -rf /etc/bonveio
 rm -rf /etc/banner
 systemctl disable bonveio &> /dev/null
 rm -rf /etc/systemd/system/bonveio.service
 rm -rf /etc/cron.d/b_reboot_job
 rm -rf /etc/cron.d/reboot_sys
 rm -rf /etc/cron.d/autodelete_expireduser
 systemctl restart cron &> /dev/null
 rm -rf /usr/local/sbin/{accounts,base-ports,base-ports-wc,base-script,bench-network,clearcache,connections,create,create_random,create_trial,delete_expired,diagnose,edit_dropbear,edit_openssh,edit_openvpn,edit_ports,edit_squi*,edit_stunne*,locked_list,menu,options,ram,reboot_sys,reboot_sys_auto,restart_services,server,set_multilogin_autokill,set_multilogin_autokill_lib,show_ports,speedtest,user_delete,user_details,user_details_lib,user_extend,user_list,user_lock,user_unlock,activate_gtm_noload,deactivate_gtm_noload}
 rm -rf /etc/profile.d/bonv.sh
 rm -rf /tmp/*
 apt autoremove -y -f
 rm -rf /lib/systemd/system/badvpn-udpgw.service
 systemctl daemon-reload &>/dev/null
 echo 3 > /proc/sys/vm/drop_caches
}

function InstallScript(){
if [[ ! -e /dev/net/tun ]]; then
 BONV-MSG
 echo -e "[\e[1;31m×\e[0m] You cant use this script without TUN Module installed/embedded in your machine, file a support ticket to your machine admin about this matter"
 echo -e "[\e[1;31m-\e[0m] Script is now exiting..."
 exit 1
fi

rm -rf /root/.bash_history && echo '' > /var/log/syslog && history -c

## Start Installation
clear
clear
BONV-MSG
echo -e ""
InsEssentials
ConfigOpenSSH
ConfigDropbear
ConfigStunnel
ConfigProxy
ConfigWebmin
ConfigOpenVPN
ConfigMenu
ConfigSyscript
ConfigNginxOvpn
InsWebSocket

echo -e "[\e[32mInfo\e[0m] Finalizing installation process.."
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime
sed -i '/\/bin\/false/d' /etc/shells
sed -i '/\/usr\/sbin\/nologin/d' /etc/shells
echo '/bin/false' >> /etc/shells
echo '/usr/sbin/nologin' >> /etc/shells
sleep 1
######

clear
clear
clear
bash /etc/profile.d/bonv.sh
BONV-MSG
echo -e ""
echo -e "\e[38;5;46m=\e[0m\e[38;5;46m=\e[0m\e[38;5;47m S\e[0m\e[38;5;47mu\e[0m\e[38;5;48mc\e[0m\e[38;5;48m\e[0m\e[38;5;49mc\e[0m\e[38;5;49me\e[0m\e[38;5;50ms\e[0m\e[38;5;50ms\e[0m\e[38;5;51m I\e[0m\e[38;5;51mn\e[0m\e[38;5;50ms\e[0m\e[38;5;50mt\e[0m\e[38;5;49ma\e[0m\e[38;5;49ml\e[0m\e[38;5;48ml\e[0m\e[38;5;48ma\e[0m\e[38;5;47mt\e[0m\e[38;5;47mi\e[0m\e[38;5;46mo\e[0m\e[38;5;46mn \e[0m\e[38;5;47m=\e[0m\e[38;5;47m=\e[0m"
echo -e ""
echo -e "\e[92m Service Ports\e[0m\e[97m:\e[0m"
echo -e "\e[92m OpenSSH\e[0m\e[97m: 22, 225\e[0m"
echo -e "\e[92m Stunnel\e[0m\e[97m: 443, 444\e[0m"
echo -e "\e[92m Dropbear\e[0m\e[97m: 550, 555\e[0m"
echo -e "\e[92m Squid\e[0m\e[97m: 8000, 8080\e[0m"
echo -e "\e[92m OpenVPN\e[0m\e[97m: 110(TCP), 25222(UDP)\e[0m"
echo -e "\e[92m OpenVPN EC\e[0m\e[97m: 25980(TCP), 25985(UDP)\e[0m"
echo -e "\e[92m NGiNX\e[0m\e[97m: 86\e[0m"
echo -e "\e[92m Webmin\e[0m\e[97m: 10000\e[0m"
echo -e "\e[92m BadVPN-udpgw\e[0m\e[97m: 7300\e[0m"
echo -e ""
echo -e ""
echo -e ""
echo -e "\e[92m OpenVPN Configs Download Site\e[0m\e[97m:\e[0m"
echo -e "\e[97m http://$(ip_address):86\e[0m"
echo -e ""
echo -e "\e[92m All OpenVPN Configs Archive\e[0m\e[97m:\e[0m"
echo -e "\e[97m http://$(ip_address)/Configs.zip\e[0m"
echo -e ""
echo -e ""
echo -e " * Script by Bonveio"
echo -e " * WebSocket Server by JadyxPH"
echo -e " ©BonvScripts"
echo -e ""
echo -e " [Note] DO NOT RESELL THIS SCRIPT"
echo -e " This script is under project of\n https://github.com/Bonveio/BonvScripts"
echo -e ""
rm -f DebianVPS-Installe*
rm -rf /root/.bash_history && history -c && echo '' > /var/log/syslog
}

source /etc/os-release > /dev/null 2>&1
if [[ "$ID" != 'debian' ]]; then
 BONV-MSG
 echo -e "[\e[1;31mError\e[0m] This script is for Debian only, exting..." 
 exit 1
fi

if [[ "$VERSION_ID" -lt 9 ]]; then
 BONV-MSG
 echo -e "[\e[1;31mError\e[0m] This script is supported only on Debian 9 stretch above." 
 exit 1
fi

if [[ $EUID -ne 0 ]]; then
 BONV-MSG
 echo -e "[\e[1;31mError\e[0m] This script must be run as root, exiting..."
 exit 1
fi

case $1 in
 install)
 BONV-MSG
 InstallScript
 exit 1
 ;;
 uninstall|remove)
 BONV-MSG
 UnistAll
 clear
 BONV-MSG
 echo -e ""
 echo -e " Uninstallation complete."
 rm -f DebianVPS-*
 exit 1
 ;;
 help|--help|-h)
 BONV-MSG
 echo -e " install = Install script"
 echo -e " uninstall = Remove all services installed by this script"
 echo -e " help = show this help message"
 exit 1
 ;;
 *)
 BONV-MSG
 echo -e " Starting Installation"
 echo -e " CRTL + C if you wish to cancel it"
 sleep 5
 InstallScript
 exit 1
 ;;
esac
