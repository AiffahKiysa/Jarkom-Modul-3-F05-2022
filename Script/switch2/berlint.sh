#network configuration
echo "
auto eth0
iface eth0 inet static
       address 10.31.2.3
       netmask 255.255.255.0
       gateway 10.31.2.1
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

apt-get update
apt-get upgrade
apt-get install squid -y
service squid >> log.txt

service squid stop
service squid start
service squid status
service squid status >> log.txt
bash lines.sh
