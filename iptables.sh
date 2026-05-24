#!/bin/bash
# apt install iptables-persistent
iptables-save > /etc/iptables/rules.v4.backup
iptables -I INPUT -p tcp --dport 2052 -j ACCEPT
iptables -I INPUT -p tcp --dport 2082 -j ACCEPT
iptables -I INPUT -p tcp --dport 2086 -j ACCEPT
iptables -I INPUT -p tcp --dport 2095 -j ACCEPT
iptables -t nat -I PREROUTING -p tcp --dport 2052 -j REDIRECT --to-ports 80
iptables -t nat -I PREROUTING -p tcp --dport 2082 -j REDIRECT --to-ports 80
iptables -t nat -I PREROUTING -p tcp --dport 2086 -j REDIRECT --to-ports 80
iptables -t nat -I PREROUTING -p tcp --dport 2095 -j REDIRECT --to-ports 80
iptables-save > /etc/iptables/rules.v4

# resolve if after installing slowdns
iptables-save > /etc/iptables/shinu-rules.v4
# extra iptables options if have slowdns
cat <<'LAMISA' > /etc/shinu/slowdns-iptables.sh
#!/bin/bash
iptables-restore < /etc/iptables/shinu-rules.v4
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
iptables -A IN_public_allow -p tcp -m tcp --dport 10000 -m conntrack --ctstate NEW,UNTRACKED -j ACCEPT
iptables-save > /etc/iptables/rules.v4
LAMISA
chmod +x /etc/shinu/slowdns-iptables.sh
