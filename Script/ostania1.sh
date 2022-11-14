#network configuration
echo "
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.31.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.31.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 10.31.3.1
	netmask 255.255.255.0
" > /etc/network/interfaces

echo "
echo \"----------\" >> log.txt
" > lines.sh
echo "log.txt" > log.txt
bash lines.sh

#jalankan ini agar node dibawahnya dapat mengakses internet
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.31.0.0/16
echo "iptables -t nat -L" >> log.txt
iptables -t nat -L >> log.txt
bash lines.sh

#cek nameserver
echo "cat /etc/resolv.conf" >> log.txt
cat /etc/resolv.conf >> log.txt
bash lines.sh
#nameserver 192.168.1.1
#ubah file /etc/resolv.conf pada node lain jika ingin connect to internet


#DONE
clear
echo "bash Ostania1.sh : Done"