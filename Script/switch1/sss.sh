#network configuration
echo "
auto eth0
iface eth0 inet dhcp
" > /etc/network/interfaces

echo "
echo \"----------\" >> log.txt
" > lines.sh
echo "log.txt" > log.txt
bash lines.sh

cat /etc/resolv.conf >> log.txt
bash lines.sh

#restart it
#then run sss2.sh