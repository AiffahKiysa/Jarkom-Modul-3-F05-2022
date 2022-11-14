#Jalankan ini setelah DHCP Server Westalis selesai

echo "apt-get update && apt-get upgrade" >> log.txt
apt-get update
apt-get upgrade
bash lines.sh

#install isc-dhcp-server
echo "apt-get install isc-dhcp-relay" >> log.txt
apt-get install isc-dhcp-relay -y
bash lines.sh

#cek apakah sudah terinstall
echo "service isc-dhcp-relay" >> log.txt
service isc-dhcp-relay >> log.txt
bash lines.sh

#atur DHCP relay nya, mengarah ke IP Westalis
#semua eth menjadi interface agar semua dapat mengakses DHCP server
echo "
SERVERS=\"10.31.2.4\"
INTERFACES=\"eth1 eth2 eth3\"
OPTIONS=
" > /etc/default/isc-dhcp-relay
echo "edit /etc/default/isc-dhcp-relay" >> log.txt
bash lines.sh

#set ipv4 forward true agar bisa menerima network lain
echo "
net.ipv4.ip_forward=1
" > /etc/sysctl.conf
echo "set ipv4 forward true " >> log.txt
echo "net.ipv4.ip_forward=1" >> log.txt
bash lines.sh

service isc-dhcp-relay stop
service isc-dhcp-relay start
service isc-dhcp-relay status
service isc-dhcp-relay status >> log.txt

echo "bash ostania2.sh : Done"