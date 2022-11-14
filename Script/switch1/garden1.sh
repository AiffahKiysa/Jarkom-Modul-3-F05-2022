

echo "
auto eth0
iface eth0 inet static
       address 10.31.1.3
       netmask 255.255.255.0
       gateway 10.31.1.1
" > /etc/network/interfaces

echo "
echo \"----------\" >> log.txt
" > lines.sh
echo "log.txt" > log.txt
bash lines.sh

#Connect to internet
echo "nameserver 192.168.122.1" > /etc/resolv.conf
echo "nameserver 192.168.122.1" >> log.txt
bash lines.sh

#Setelah itu restart node Garden dan coba ping
#ping google.com -c 2