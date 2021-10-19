#!/bin/sh

which nmcli >/dev/null 2>&1
if [ $? -ne 0 ]; then
  sudo yum install -y NetworkManager
  sudo systemctl enable NetworkManager
  sudo systemctl start NetworkManager
fi

ifName=$(nmcli -t -f NAME c show --active)

sudo nmcli c m "$ifName" ipv4.ignore-auto-dns yes
sudo nmcli c m "$ifName" ipv4.dns "10.18.1.208,10.18.1.176"
sudo nmcli c m "$ifName" ipv4.dns-search "perflab.local"
sudo nmcli connection up "$ifName"

sudo bash -c 'cat <<EOF > /etc/resolv.conf
search perflab.local
nameserver 10.18.1.208
nameserver 10.18.1.176
EOF'
