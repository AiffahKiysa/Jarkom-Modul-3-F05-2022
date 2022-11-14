#change the network configuration
echo "change the network configuration to dhcp" >> log.txt
echo "
auto eth0
iface eth0 inet dhcp
hwaddress ether 69:69:69:69:69:69
" > /etc/network/interfaces

cat /etc/resolv.conf >> log.txt
bash lines.sh

#restart berlint, squid otomatis berhenti juga ya