#!/bin/bash

if [[ "$(command -v squid)" ]]; then
 if [[ "$(squid -v | grep -Ec '(V|v)ersion\s4.6')" -lt 1 ]]; then
  apt remove --purge squid -y -f 2>/dev/null
  wget "http://security.debian.org/debian-security/pool/updates/main/s/squid3/squid3_4.6-1+deb10u8_all.deb" -qO squid.deb
  dpkg -i squid.deb
  rm -f squid.deb
 else
  echo -e "Squid v4.6 already installed"
 fi
else
 apt install libecap3 squid-common squid-langpack -y -f 2>/dev/null
 wget "http://security.debian.org/debian-security/pool/updates/main/s/squid3/squid3_4.6-1+deb10u8_all.deb" -qO squid.deb
 dpkg -i squid.deb
 rm -f squid.deb
fi

    

