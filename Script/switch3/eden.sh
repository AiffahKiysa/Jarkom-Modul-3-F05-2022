echo "
auto eth0
iface eth0 inet dhcp
hwaddress ether 12:34:56:78:9a:bc
" > /etc/network/interfaces

echo "
echo \"----------\" >> log.txt
" > lines.sh
echo "log.txt" > log.txt
bash lines.sh


