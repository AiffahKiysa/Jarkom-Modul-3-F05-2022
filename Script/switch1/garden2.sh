
#change the network configuration
echo "change the network configuration to dhcp" >> log.txt
echo "
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces

echo "
echo \"----------\" >> log.txt
" > lines.sh

cat /etc/resolv.conf >> log.txt
bash lines.sh


#Setelah itu restart node Garden dan coba ping
#ping google.com -c 2