#!/bin/bash
# Debian VPS Script
# Script created by Bonveio
# Do not resell and redistribute this script
# Project by BonvScripts <https://github.com/Bonveio/BonvScripts>




clear
cd ~
export DEBIAN_FRONTEND=noninteractive

function InsWebSocket() {
  clear
  echo -e "Installing and Configuring WebSocket"
  if [ -e /etc/sigmaxph ];
  then
    rm /etc/sigmaxph/* && rm -rf /etc/sigmaxph/* && rmdir /etc/sigmaxph
    iptables-restore < /etc/iptables/rules.v4
    systemctl stop sshws.service && systemctl disable sshws.service 2>/dev/null
    systemctl stop sslws.service && systemctl disable sslws.service 2>/dev/null
    systemctl stop ovpnws.service && systemctl disable ovpnws.service 2>/dev/null
    rm /usr/sbin/*.py && rm /usr/sbin/*.sh && cd /etc/systemd/system && rm sshws.service && rm sslws.service && rm ovpnws.service && cd $home
    touch bukya && crontab bukya && rm bukya
  else
    echo -e " SUCCESSFULLY INSTALLED! "
  fi
  #Configure Iptables
  cd $home
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/refs/heads/main/iptables.sh?token=GHSAT0AAAAAAD5KK4KLAJ2CKUQAE6XQCK562QJF4LA && chmod +x iptables.sh && ./iptables.sh &> /dev/null
  
  #Download Websockets
  cd /usr/sbin
  
  #SSHWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/refs/heads/main/PDirect.py?token=GHSAT0AAAAAAD5KK4KKNYBXXCTP3P3KWVGY2QJF2CA &> /dev/null
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/refs/heads/main/Proxy.py?token=GHSAT0AAAAAAD5KK4KKPUIWHRGMBO664ZM22QJF3SQ &> /dev/null
  
  #SSLWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/refs/heads/main/PStunnel.py?token=GHSAT0AAAAAAD5KK4KLM75WD2QLKYS32DQ62QJFYXA&> /dev/null
  
  #OVPNWS
  wget https://raw.githubusercontent.com/Jadyxph101/VPS/refs/heads/main/POpenvpn.py?token=GHSAT0AAAAAAD5KK4KKA4RWPNODIHSOTDTC2QJFS6A &> /dev/null
  
  #Make it executable
  chmod +x PDirect.py && chmod +x PStunnel.py && chmod +x POpenvpn.py
  
  #Creating Services
  #This will create a services file to /etc/systemd/system
  cd $home && wget https://raw.githubusercontent.com/noahclanman/scripts/main/ws-services.sh && chmod +x ws-services.sh && ./ws-services.sh &> /dev/null
  #Reload services
  systemctl daemon-reload 2>/dev/null
  systemctl enable sshws.service 2>/dev/null
  systemctl enable sslws.service 2>/dev/null
  systemctl enable ovpnws.service 2>/dev/null
  systemctl start sshws.service 2>/dev/null
  systemctl start sslws.service 2>/dev/null
  systemctl start ovpnws.service 2>/dev/null
  
  #Make cron job to delete logs
  crontab -l > cronsigmaxph
  echo "0 */12 * * * /bin/sh /etc/sigmaxph/remover.sh" >> cronsigmaxph
  echo "@daily systemctl reboot -i" >> cronsigmaxph
  echo "*/5 * * * * /bin/sh /etc/sigmaxph/checker.sh" >> cronsigmaxph
  crontab cronsigmaxph
  rm cronsigmaxph
  
  #Extras
  mkdir /etc/sigmaxph && cd /etc/sigmaxph && wget https://raw.githubusercontent.com/noahclanman/scripts/main/remover.sh && chmod +x remover.sh &> /dev/null
  wget https://raw.githubusercontent.com/noahclanman/scripts/main/bbr.sh && chmod +x bbr.sh && ./bbr.sh &> /dev/null
  
  #Now all thing is done time to remove some file
  cd $home && rm iptables.sh && rm ws-services.sh && rm /etc/sigmaxph/bbr.sh
cat <<'Chcker' > /etc/sigmaxph/checker.sh

#!/bin/bash
if [[ $(ps -ef | grep slowdns | grep 'SCREEN') ]] ;
 then
  /etc/sigmaxph/./slowdns-iptables.sh
  wget https://raw.githubusercontent.com/noahclanman/scripts/main/dns-services && chmod +x dns-services && ./dns-services &> /dev/null
  systemctl daemon-reload 2>/dev/null
  systemctl enable dnstt.service 2>/dev/null
  systemctl start dnstt.service 2>/dev/null
  rm dns-services
  rm /etc/sigmaxph/checker.sh
  touch bukya && crontab bukya && rm bukya
  crontab -l > cronsigmaxph
  echo "0 */12 * * * /bin/sh /etc/sigmaxph/remover.sh" >> cronsigmaxph
  echo "@daily systemctl reboot -i" >> cronsigmaxph
  crontab cronsigmaxph
  rm cronsigmaxph
 else
  echo "Do Nothing..."
fi
Chcker
chmod u+x /etc/sigmaxph/checker.sh
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
timedatectl set-timezone Asia/Manila > /dev/null 2>&1

apt install nano wget curl zip unzip tar gzip p7zip-full bc rc openssl cron net-tools dnsutils dos2unix screen bzip2 ccrypt lsof -y 2>/dev/null

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

apt install dropbear stunnel4 privoxy ca-certificates nginx ruby apt-transport-https lsb-release squid jq tcpdump dsniff grepcidr screenfetch -y 2>/dev/null

apt install perl libnet-ssleay-perl libauthen-pam-perl libpam-runtime libio-pty-perl apt-show-versions python dbus libxml-parser-perl shared-mime-info -y 2>/dev/null

gem install lolcat 2>/dev/null
apt autoremove --fix-missing -y &>/dev/null

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
cat <<'EOFOpenSSH' > /etc/ssh/sshd_config
# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
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



rm -f /etc/stunnel/*
echo -e "[\e[32mInfo\e[0m] Cloning Stunnel.pem.."

# Creating stunnel certifcate using openssl
openssl req -new -x509 -days 9999 -nodes -subj "/C=PH/ST=Calabarzon/L=Rizal/O=$MyScriptName/OU=$MyScriptName/CN=$MyScriptName" -out /etc/stunnel/stunnel.pem -keyout /etc/stunnel/stunnel.pem &> /dev/null

echo -e "[\e[32mInfo\e[0m] Creating Stunnel server config.."
cat <<'EOFStunnel3' > /etc/stunnel/stunnel.conf




# BonvScripts
# https://t.me/BonvScripts
# Please star my Repository: https://github.com/Bonveio/BonvScripts
# https://phcorner.net/threads/739298
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
echo -e "[\e[32mInfo\e[0m] Configuring OpenVPN server.."
if [[ ! -e /etc/openvpn ]]; then
 mkdir -p /etc/openvpn
 else
 rm -rf /etc/openvpn/*
fi
mkdir -p /etc/openvpn/server
mkdir -p /etc/openvpn/client

## ADDED SCRIPT OVPN ##

echo "Installing required packages."
if [[ ! `type -P docker` ]]; then
APT="apt-get -y"
$APT install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/$ID/gpg | apt-key add - 
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/$ID $(lsb_release -cs) stable"
$APT update
apt-cache policy docker-ce
$APT install docker-ce
$APT clean; fi



echo "Installing OpenVPN."
$APT install openvpn
opam=`find /usr -name openvpn*auth-pam.so`

cd /etc/openvpn
cat << ovpn > server.conf

cat <<'EOFovpn1' > /etc/openvpn/server/server_tcp.conf

# OVPN_ACCESS_SERVER_PROFILE= ⸸ 𝔊𝔞𝔟𝔯𝔦𝔢𝔩 ⸸ | PRIVATE SERVER PH



port $ovpn
proto tcp
dev tun

topology subnet
server 10.10.0.0 255.255.0.0
ifconfig-pool-persist ipp.save

ca keys/ca.crt
dh keys/dh2048.pem
cert keys/server.crt
key keys/server.key

tls-cipher TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256
ncp-disable

username-as-common-name
verify-client-cert none
plugin $opam login
script-security 2
duplicate-cn

auth none
cipher none

push "verb 3"
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-renew"
push "block-outside-dns"
push "register-dns"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"

cat <<'EOFovpn2' > /etc/openvpn/server/server_udp.conf
# OVPN_ACCESS_SERVER_PROFILE= ⸸ 𝔊𝔞𝔟𝔯𝔦𝔢𝔩 ⸸ | PRIVATE SERVER PH


port 25222
dev tun
proto udp
ca /etc/openvpn/ca.crt
cert /etc/openvpn/bonvscripts.crt
key /etc/openvpn/bonvscripts.key
dh none
persist-tun
persist-key
persist-remote-ip
duplicate-cn
cipher none
ncp-disable
auth none
comp-lzo
tun-mtu 1500
float
fast-io
reneg-sec 0
plugin PLUGIN_AUTH_PAM /etc/pam.d/login
verify-client-cert none
username-as-common-name
max-clients 4080
topology subnet
server 172.29.16.0 255.255.240.0
push "redirect-gateway def1"
keepalive 5 30
status /etc/openvpn/udp_stats.log
log /etc/openvpn/udp.log
verb 2
script-security 2
push "dhcp-option DNS 1.0.0.1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 8.8.4.4"
push "dhcp-option DNS 8.8.8.8"


keepalive 5 60
tcp-nodelay
reneg-sec 0

persist-key
persist-tun

log-append log/openvpn.log
verb 3
ovpn

mkdir keys 2> /dev/null
cd keys

cat << ovpnca > ca.crt
-----BEGIN CERTIFICATE-----
MIIEZzCCA0+gAwIBAgIUH16Z5Nwl9x5QlYO3jVkCJ5I7PpkwDQYJKoZIhvcNAQEL
BQAweDELMAkGA1UEBhMCUEgxDzANBgNVBAgTBk1hbmlsYTEPMA0GA1UEBxMGUXVl
em9uMQowCAYDVQQKEwEtMQowCAYDVQQLEwEtMQ0wCwYDVQQDEwQtIENBMQ4wDAYD
VQQpEwVYLURDQjEQMA4GCSqGSIb3DQEJARYBLTAeFw0xODEyMDMxMjQ2MTZaFw0y
ODExMzAxMjQ2MTZaMHgxCzAJBgNVBAYTAlBIMQ8wDQYDVQQIEwZNYW5pbGExDzAN
BgNVBAcTBlF1ZXpvbjEKMAgGA1UEChMBLTEKMAgGA1UECxMBLTENMAsGA1UEAxME
LSBDQTEOMAwGA1UEKRMFWC1EQ0IxEDAOBgkqhkiG9w0BCQEWAS0wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+DV1Dg3hpA2NFWgs6DJ1hmmeG1oi2AGKC
ZdsaT825IPTJEIFuD23J71NEKHm6kWQLRd2AR8696PyPm/TxSsBlqrrcnmiYrzp9
C+dgUQb71+hnwXvit7zhCeAjy2bj+mtgByCzuHSgNdpFftkw5ew42P6mhxmLSsUw
ba5HXf5MRUtpf67tHbtdS8ii6fVpl5wffOW/GPYyiXgLOXlXLa8sxR92UsFtYdWE
3fyi0kVMc93R8sOW1MTJhBYTxqA+3hrj0hHz0dV8bfjyCs+OhwA5T8cUtruRwa1r
eZNzcka2TfDz0/pIyrEiA4QD2dePJT2XRp3uUyu8a0bVeZ2YepJdAgMBAAGjgegw
geUwHQYDVR0OBBYEFJ+kIC+6Gq350o5VPbs5kwS25hSMMIG1BgNVHSMEga0wgaqA
FJ+kIC+6Gq350o5VPbs5kwS25hSMoXykejB4MQswCQYDVQQGEwJQSDEPMA0GA1UE
CBMGTWFuaWxhMQ8wDQYDVQQHEwZRdWV6b24xCjAIBgNVBAoTAS0xCjAIBgNVBAsT
AS0xDTALBgNVBAMTBC0gQ0ExDjAMBgNVBCkTBVgtRENCMRAwDgYJKoZIhvcNAQkB
FgEtghQfXpnk3CX3HlCVg7eNWQInkjs+mTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3
DQEBCwUAA4IBAQAZ9nn4Z6wSzid+dBlSojEk547688U67idkTFLgShRQfqzAkcuS
ahk/W5gwM/YyGJL+y5JaW0d15dIr+cORAV4vUecrn9/5AS8AAph9UM3VpO9DRl0a
XHIxwzzi4N4mygMgeKdmbYLCOXkqtXEKLgX3hCntttnLEmWWqWfjgssfJd3KPdnd
myo2WMC20CZQ97d+4ga7TLTDr1vhO+H1YUpinURni0FgUp+rIZUUom+j+pDjWMXd
cYUmGUSiTJUo073hILdyyelCZ75cu5AfEAsCrJ10bGz99CKecoBbLRzR6ARgnrrS
n9q7bvX39TPdCLzlGsfdrT+NOvn9XU1zWyz6
-----END CERTIFICATE-----
ovpnca

cat << ovpnskey > server.key
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCptYUiwhQB52TT
O6R3/DkXyTq6rWumxKEAwzVxC5faBipHs4Fv5AjkDzgFWDgbqn5w0sKiXlJJpD7Z
bHhd2fL/PSIX3JH26Qnwn75JFJgNpbBInMVx9MjKeMaG90+HCaXPld9Gdni8CMtj
2L8CuUh3lzIa0fGQJcQoLxiGbI58zz1+acHTHrOfc8+vgMvk//TsBkm3uwj0tk+A
+2IhZ2lKdymhD1k381t9rBzKd2VhM0XHR9omU0sxIzIXEHo3l1ncjNdyRFR4L0Of
nBqF0ovAsYV8NtrM/5FUPbfkaC5+up3Yjx1y0EnTDxWjjUbDjqpU1fjhBksTNwou
ClXXmtZpAgMBAAECggEABX4LbgGL9jfP6ooum3d9PYjUrr/4EPCiKU0oCJ2Qb4zt
h16G3OErbH4VmQ6u2i5dYzde9zRIQ3veUNkS2C66j4oh9VW9H5mRKclxthnFhgOL
vf3c4gBDE1JvUmTknQEx7ZLzI+unoqZCNtwH6oWmk8A/7eBHihu+ynIjwA35Wo6o
8a+Zj1LeEFc83YAOxeklVefV3OvHaesv8da8mfcrq+s9xJR6zwIB6/zsYoLHp/n9
+Nnx/iz4BnuK3vLBKnOByEb8Aw4yD1j06X/zO1Gi1RWmFLZhbYTRw9vARf0Syjnr
29WY55QSCO3QFuLBVQya+ytB6mnDf5cMIzozFZbRgQKBgQDdZx99vde1xGQ8YpfM
iisfxszuXJe6do1G77APngYzYj8zEJ9DpAQPtRfeASvuu5mgjMcBxJdEwwqmO+mx
4eFEfycmZxFIP4peiuniCB97F5LPD+eVIM3E7u71QW55UeF6yvdzAdEjMLp0edJd
SZ15i4xoTDrye6RXcqdscM0fEQKBgQDEOnfcK+q7U3sXnehcaqcO9BRUoFdJdcJ0
83XBOqBhGynhGgDf7eB1bL8rLkyHku858nTqOv6/KfQschGljIwsUs3RoJkk5hW3
SAJlepPJPcL2WWzTgTI/N9ztJ1bK3Vfb/djA3rbHZ1PnND/lCLwzWSFcuI8/zmy2
FA79OLVx2QKBgQC903LenmxaPh4q3+WCy1waDJscK2szxf1vOoZbfYOXfr7tC21h
0zhgN0ZVY+/E6jfXvZvK2kFQBWIWEPxXNXGtBtAMTwY0SbZbRQMudwR2x0lqGxrV
c6C5Hprm0MjlX9zRKUBr7LzhTSAwSVqh/UH1Oj6SFfnceUH4cCc4BKb54QKBgAUK
B1f1HMMQwsF5gaUV7BJbPEZsE7HEP2knc2ex7LpxqyKnu0wE3NXHJCWku7xjjpcr
XctCFpasKiQWDdP1hwgAXF68xBIJgpdBVyZp/m+VkXMoGr5XvAWZlqfUccsl4gK5
Qx642XLHeYUfd2CXV9XtvQiXiL43u9z1KOlh0m8JAoGAbkgGepmMRk3bN56dK8rE
w8fZe0oSw1tYAaXkMQ5M1ulQ8l/zHEGy5FDq7BlanmeqUc9sTV2bp0pq+S9OVZCP
m/nV39+X7Jyj6653a/3Ce5PXOR/6UrsWeFjRAKItWHScJtcQZ2s+JyxlmPQDcJG3
JbXr5yY8k8EKMPR7RsMHrbU=
-----END PRIVATE KEY-----
ovpnskey

cat << ovpnsca > server.crt
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=Calabarzon, L=Rizal, O=-, OU=-, CN=- CA/name=SIGMAPHX/emailAddress=jadyxphsigmax@gmail.com
        Validity
            Not Before: Dec  3 12:46:22 2018 GMT
            Not After : Nov 30 12:46:22 2028 GMT
        Subject: C=PH, ST=Calabarzon, L=Rizal, O=-, OU=-, CN=SIGMAPHX/name=SIGMAPHX/emailAddress=jadyxphsigmax@gmail.com
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (2048 bit)
                Modulus:
                    00:a9:b5:85:22:c2:14:01:e7:64:d3:3b:a4:77:fc:
                    39:17:c9:3a:ba:ad:6b:a6:c4:a1:00:c3:35:71:0b:
                    97:da:06:2a:47:b3:81:6f:e4:08:e4:0f:38:05:58:
                    38:1b:aa:7e:70:d2:c2:a2:5e:52:49:a4:3e:d9:6c:
                    78:5d:d9:f2:ff:3d:22:17:dc:91:f6:e9:09:f0:9f:
                    be:49:14:98:0d:a5:b0:48:9c:c5:71:f4:c8:ca:78:
                    c6:86:f7:4f:87:09:a5:cf:95:df:46:76:78:bc:08:
                    cb:63:d8:bf:02:b9:48:77:97:32:1a:d1:f1:90:25:
                    c4:28:2f:18:86:6c:8e:7c:cf:3d:7e:69:c1:d3:1e:
                    b3:9f:73:cf:af:80:cb:e4:ff:f4:ec:06:49:b7:bb:
                    08:f4:b6:4f:80:fb:62:21:67:69:4a:77:29:a1:0f:
                    59:37:f3:5b:7d:ac:1c:ca:77:65:61:33:45:c7:47:
                    da:26:53:4b:31:23:32:17:10:7a:37:97:59:dc:8c:
                    d7:72:44:54:78:2f:43:9f:9c:1a:85:d2:8b:c0:b1:
                    85:7c:36:da:cc:ff:91:54:3d:b7:e4:68:2e:7e:ba:
                    9d:d8:8f:1d:72:d0:49:d3:0f:15:a3:8d:46:c3:8e:
                    aa:54:d5:f8:e1:06:4b:13:37:0a:2e:0a:55:d7:9a:
                    d6:69
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                Easy-RSA Generated Server Certificate
            X509v3 Subject Key Identifier: 
                CE:EC:8C:89:16:E3:7E:13:86:99:6B:C0:9D:FD:67:3E:9D:E0:B9:17
            X509v3 Authority Key Identifier: 
                keyid:9F:A4:20:2F:BA:1A:AD:F9:D2:8E:55:3D:BB:39:93:04:B6:E6:14:8C
                DirName:/C=PH/ST=Calabarzon/L=Rizal/O=-/OU=-/CN=- CA/name=SIGMAPHX/emailAddress=jadyxphsigmax@gmail.com
                serial:1F:5E:99:E4:DC:25:F7:1E:50:95:83:B7:8D:59:02:27:92:3B:3E:99

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:SIGMAPHX
    Signature Algorithm: sha256WithRSAEncryption
         6a:62:6a:dd:97:d4:fd:1b:4f:78:7a:79:13:0b:0c:cc:72:21:
         0e:c8:a3:09:63:d8:7e:91:43:2f:ad:d4:69:6c:df:19:6f:08:
         cb:c8:e7:3f:5f:d9:51:be:57:53:82:37:35:5e:75:21:b4:36:
         d6:e7:59:1e:53:86:73:0b:f0:5c:ed:50:3c:3e:be:33:04:e9:
         71:6c:84:c9:a3:ad:0b:25:9d:c3:4a:f0:66:3e:a6:6e:4f:b3:
         a4:33:a8:c1:f2:84:6b:5e:6c:c9:09:de:9c:55:e0:24:0e:79:
         c9:dc:10:ef:9a:05:e4:1b:54:e7:b4:87:82:b6:3e:b3:ab:84:
         ea:b4:cf:22:e3:df:9f:7a:03:d4:38:ac:a0:83:ef:25:ed:1f:
         04:f1:7d:a5:87:4a:32:06:2a:67:1f:9b:cc:e9:54:17:d8:6f:
         5b:0d:c8:ce:29:5f:37:11:a5:95:af:69:15:21:72:84:f6:41:
         db:d7:55:e6:9a:49:3f:2d:fd:eb:78:85:e6:cb:b4:3d:00:03:
         16:de:a1:be:18:73:a1:7f:2c:f3:0f:74:29:ab:d1:3e:3f:48:
         80:21:e9:7a:5a:00:2e:0e:7f:9b:56:31:66:f4:ca:08:c2:16:
         15:b7:ba:96:ef:28:62:3d:09:7e:99:00:9b:bc:1c:0e:0f:29:
         b0:ce:6b:94
-----BEGIN CERTIFICATE-----
MIIE0TCCA7mgAwIBAgIBATANBgkqhkiG9w0BAQsFADB4MQswCQYDVQQGEwJQSDEP
MA0GA1UECBMGTWFuaWxhMQ8wDQYDVQQHEwZRdWV6b24xCjAIBgNVBAoTAS0xCjAI
BgNVBAsTAS0xDTALBgNVBAMTBC0gQ0ExDjAMBgNVBCkTBVgtRENCMRAwDgYJKoZI
hvcNAQkBFgEtMB4XDTE4MTIwMzEyNDYyMloXDTI4MTEzMDEyNDYyMloweTELMAkG
A1UEBhMCUEgxDzANBgNVBAgTBk1hbmlsYTEPMA0GA1UEBxMGUXVlem9uMQowCAYD
VQQKEwEtMQowCAYDVQQLEwEtMQ4wDAYDVQQDEwVYLURDQjEOMAwGA1UEKRMFWC1E
Q0IxEDAOBgkqhkiG9w0BCQEWAS0wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQCptYUiwhQB52TTO6R3/DkXyTq6rWumxKEAwzVxC5faBipHs4Fv5AjkDzgF
WDgbqn5w0sKiXlJJpD7ZbHhd2fL/PSIX3JH26Qnwn75JFJgNpbBInMVx9MjKeMaG
90+HCaXPld9Gdni8CMtj2L8CuUh3lzIa0fGQJcQoLxiGbI58zz1+acHTHrOfc8+v
gMvk//TsBkm3uwj0tk+A+2IhZ2lKdymhD1k381t9rBzKd2VhM0XHR9omU0sxIzIX
EHo3l1ncjNdyRFR4L0OfnBqF0ovAsYV8NtrM/5FUPbfkaC5+up3Yjx1y0EnTDxWj
jUbDjqpU1fjhBksTNwouClXXmtZpAgMBAAGjggFjMIIBXzAJBgNVHRMEAjAAMBEG
CWCGSAGG+EIBAQQEAwIGQDA0BglghkgBhvhCAQ0EJxYlRWFzeS1SU0EgR2VuZXJh
dGVkIFNlcnZlciBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUzuyMiRbjfhOGmWvAnf1n
Pp3guRcwgbUGA1UdIwSBrTCBqoAUn6QgL7oarfnSjlU9uzmTBLbmFIyhfKR6MHgx
CzAJBgNVBAYTAlBIMQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBlF1ZXpvbjEK
MAgGA1UEChMBLTEKMAgGA1UECxMBLTENMAsGA1UEAxMELSBDQTEOMAwGA1UEKRMF
WC1EQ0IxEDAOBgkqhkiG9w0BCQEWAS2CFB9emeTcJfceUJWDt41ZAieSOz6ZMBMG
A1UdJQQMMAoGCCsGAQUFBwMBMAsGA1UdDwQEAwIFoDAQBgNVHREECTAHggVYLURD
QjANBgkqhkiG9w0BAQsFAAOCAQEAamJq3ZfU/RtPeHp5EwsMzHIhDsijCWPYfpFD
L63UaWzfGW8Iy8jnP1/ZUb5XU4I3NV51IbQ21udZHlOGcwvwXO1QPD6+MwTpcWyE
yaOtCyWdw0rwZj6mbk+zpDOowfKEa15syQnenFXgJA55ydwQ75oF5BtU57SHgrY+
s6uE6rTPIuPfn3oD1DisoIPvJe0fBPF9pYdKMgYqZx+bzOlUF9hvWw3IzilfNxGl
la9pFSFyhPZB29dV5ppJPy3963iF5su0PQADFt6hvhhzoX8s8w90KavRPj9IgCHp
eloALg5/m1YxZvTKCMIWFbe6lu8oYj0JfpkAm7wcDg8psM5rlA==
-----END CERTIFICATE-----
ovpnsca

cat << ovpndh > dh2048.pem
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEAr5+h3sW+y6/9ZZyitYwQOAZwv5umOCJdMMUtT4CVBzskKu6v6Lua
XSAInneN8Qj+fo8eAUWpu4pZUrhlH5XlQLpjQv0WBq8YUTMiigCqKn+WvrT0886U
DMdBt6TnpR3Hp5tLqCwbq7AjI6khxYJly+GIqs1W9TSYbjGaCjyTLMil8ckZHjIk
a/Uiq/JhNZV2ZsRrUvQP/QhNDwICG1dbKc79L2+AaLFj6R1128wIa6X02sg9jyfH
Eetj2JwwZggp3O/m8efv/MUYAy7OqpziWhllxT0ZGMAdzGmx1O9mdkXXxf+dmNNW
9wj2aOTAWkwqBGP8FrcYywTeInJ9XX9OKwIBAg==
-----END DH PARAMETERS-----
ovpndh

systemctl restart openvpn@server; cd





















mkdir /etc/openvpn/easy-rsa
mkdir /etc/openvpn/easy-rsa-ec

curl -4skL "https://raw.githubusercontent.com/Bonveio/BonvScripts/master/bonvscripts-easyrsa.zip" -o /etc/openvpn/easy-rsa/rsa.zip 2> /dev/null
curl -4skL "https://raw.githubusercontent.com/Bonveio/BonvScripts/master/bonvscripts-easyrsa-ec.zip" -o /etc/openvpn/easy-rsa-ec/rsa.zip 2> /dev/null

unzip -qq /etc/openvpn/easy-rsa/rsa.zip -d /etc/openvpn/easy-rsa
unzip -qq /etc/openvpn/easy-rsa-ec/rsa.zip -d /etc/openvpn/easy-rsa-ec

rm -f /etc/openvpn/easy-rsa/rsa.zip
rm -f /etc/openvpn/easy-rsa-ec/rsa.zip

cd /etc/openvpn/easy-rsa
chmod +x easyrsa
./easyrsa build-server-full server nopass &> /dev/null
cp pki/ca.crt /etc/openvpn/ca.crt
cp pki/issued/server.crt /etc/openvpn/bonvscripts.crt
cp pki/private/server.key /etc/openvpn/bonvscripts.key

cd /etc/openvpn/easy-rsa-ec
chmod +x easyrsa
./easyrsa build-server-full server nopass &> /dev/null
cp pki/ca.crt /etc/openvpn/ec_ca.crt
cp pki/issued/server.crt /etc/openvpn/ec_bonvscripts.crt
cp pki/private/server.key /etc/openvpn/ec_bonvscripts.key

cd ~/ && echo '' > /var/log/syslog

cat <<'NUovpn' > /etc/openvpn/server/server.conf
 ### Do not overwrite this script if you didnt know what youre doing ###
 #
 # New Update are now released, OpenVPN Server
 # are now running both TCP and UDP Protocol. (Both are only running on IPv4)
 # But our native server.conf are now removed and divided
 # Into two different configs base on their Protocols:
 #  * OpenVPN TCP (located at /etc/openvpn/server/server_tcp.conf
 #  * OpenVPN UDP (located at /etc/openvpn/server/server_udp.conf
 # 
 # Also other logging files like
 # status logs and server logs
 # are moved into new different file names:
 #  * OpenVPN TCP Server logs (/etc/openvpn/server/tcp.log)
 #  * OpenVPN UDP Server logs (/etc/openvpn/server/udp.log)
 #  * OpenVPN TCP Status logs (/etc/openvpn/server/tcp_stats.log)
 #  * OpenVPN UDP Status logs (/etc/openvpn/server/udp_stats.log)
 #
 # Since config file name changes, systemctl/service identifiers are changed too.
 # To restart TCP Server: systemctl restart openvpn-server@server_tcp
 # To restart UDP Server: systemctl restart openvpn-server@server_udp
 #
 # Server ports are configured base on env vars
 # executed/raised from this script (OpenVPN_TCP_Port/OpenVPN_UDP_Port)
 #
 # Enjoy the new update
 # Script Updated by Bonveio
NUovpn

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

cat <<'mySiteOvpn' > /var/www/openvpn/index.html
<!DOCTYPE html>
<html lang="en">

<!-- Simple OVPN Download site by Bonveio Abitona | Server by JadyxPH -->

<head><meta charset="utf-8" /><title>MyScriptName OVPN Config Download</title><meta name="description" content="MyScriptName Server" /><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" /><meta name="theme-color" content="#000000" /><link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.2/css/all.css"><link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet"><link href="https://cdnjs.cloudflare.com/ajax/libs/mdbootstrap/4.8.3/css/mdb.min.css" rel="stylesheet"></head><body><div class="container justify-content-center" style="margin-top:9em;margin-bottom:5em;"><div class="col-md"><div class="view"><img src="https://openvpn.net/wp-content/uploads/openvpn.jpg" class="card-img-top"><div class="mask rgba-white-slight"></div></div><div class="card"><div class="card-body"><h5 class="card-title">Config List</h5><br /><ul class="list-group"><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Globe/TM <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For EZ/GS Promo with WNP freebies</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GTMConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> For TU UDP Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/SunConfig.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li><li class="list-group-item justify-content-between align-items-center" style="margin-bottom:1em;"><p>For Sun <span class="badge light-blue darken-4">Android/iOS/PC/Modem</span><br /><small> Trinet GIGASTORIES Promos</small></p><a class="btn btn-outline-success waves-effect btn-sm" href="http://IP-ADDRESS:NGINXPORT/GStories.ovpn" style="float:right;"><i class="fa fa-download"></i> Download</a></li></ul></div></div></div></div></body></html>
mySiteOvpn



# Setting template's correct name,IP address and nginx Port
sed -i "s|MyScriptName|JadyxPH|g" /var/www/openvpn/index.html
sed -i "s|NGINXPORT|86|g" /var/www/openvpn/index.html
sed -i "s|IP-ADDRESS|$(ip_address)|g" /var/www/openvpn/index.html





######


sed -i "s|OPENVPN_SERVER_VERSION|$(openvpn --version | cut -d" " -f2 | head -n1)|g" /var/www/openvpn/*.ovpn
sed -i "s|OPENVPN_SERVER_LOCATION|$(curl -4s http://ipinfo.io/country), $(curl -4s http://ipinfo.io/region)|g" /var/www/openvpn/*.ovpn
sed -i "s|OPENVPN_SERVER_ISP|$(curl -4s http://ipinfo.io/org | sed -e 's/[^ ]* //')|g" /var/www/openvpn/*.ovpn

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
 rm -rf /etc/ohpserver
 systemctl stop ohpserver.service &> /dev/null
 systemctl disable ohpserver.service &> /dev/null
 systemctl stop ohpserver-autorecon.service &>/dev/null
 systemctl disable ohpserver-autorecon.service &>/dev/null
 rm -rf /etc/systemd/system/ohpserver-autorecon.service
 rm -rf /lib/systemd/system/ohpserver.service
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
echo -e "\e[97m NEW! OHPServer builds\e[0m"
echo -e "\e[97m (Good for Payload bugging and any related HTTP Experiments)\e[0m"
echo -e "\e[92m OHP+Dropbear\e[0m\e[97m: 8085\e[0m"
echo -e "\e[92m OHP+OpenSSH\e[0m\e[97m: 8086\e[0m"
echo -e "\e[92m OHP+OpenVPN\e[0m\e[97m: 8087\e[0m"
echo -e "\e[92m OHP+OpenVPN Elliptic Curve\e[0m\e[97m: 8088\e[0m"
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
echo -e " * OHPServer by lfasmpao"
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
