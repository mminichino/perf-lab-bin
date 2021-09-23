#!/bin/sh
[ ! -d $HOME/.dns ] && mkdir $HOME/.dns && chmod 700 $HOME/.dns

echo -n "DNS Key : "
read DNSKEY

echo "{ \"dnskey\": \""$DNSKEY"\" }" | jq . > $HOME/.dns/dns.key
chmod 600 $HOME/.dns/dns.key
