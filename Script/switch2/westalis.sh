#network configuration
echo "
auto eth0
iface eth0 inet static
	address 10.31.2.4
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

echo "apt-get update && apt-get upgrade" >> log.txt
apt-get update
apt-get upgrade
bash lines.sh

#install isc-dhcp-server
echo "apt-get install isc-dhcp-server" >> log.txt
apt-get install isc-dhcp-server -y
bash lines.sh

#cek apakah sudah terinstall
echo "service isc-dhcp-server" >> log.txt
service isc-dhcp-server >> log.txt
bash lines.sh
echo "dhcpd --version" >> log.txt
dhcpd --version >> log.txt
bash lines.sh

echo "INTERFACES=\"eth0\"" > /etc/default/isc-dhcp-server

#Agar bisa di start harus ada ini minimal kosongan
echo "
subnet 10.31.2.0 netmask 255.255.255.0 {
    range 10.31.2.69 10.31.2.169; #Random range
    option routers 10.31.2.1;
    option broadcast-address 10.31.2.255;
    option domain-name-servers 10.31.2.2;
    default-lease-time 3600; #Random Lease Time
    max-lease-time 7200;
}" > /etc/dhcp/dhcpd.conf

#Nomor 3
echo "
subnet 10.31.1.0 netmask 255.255.255.0 {
    range 10.31.1.50 10.31.1.88; 
    range 10.31.1.120 10.31.1.155;
    option routers 10.31.1.1;
    option broadcast-address 10.31.1.255;
    option domain-name-servers 10.31.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}" >> /etc/dhcp/dhcpd.conf

#Nomor 4
echo "
subnet 10.31.3.0 netmask 255.255.255.0 {
    range 10.31.3.10 10.31.3.30; 
    range 10.31.3.60 10.31.3.85;
    option routers 10.31.3.1;
    option broadcast-address 10.31.3.255;
    option domain-name-servers 10.31.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}" >> /etc/dhcp/dhcpd.conf

#set the fixed address
#make sure to run eden.sh first
#Nomor 7
echo "
host Eden {
    hardware ethernet 12:34:56:78:9a:bc;
    fixed-address 10.31.3.13;
}

host Berlint {
    hardware ethernet 69:69:69:69:69:69;
    fixed-address 10.31.2.69;
}
" >> /etc/dhcp/dhcpd.conf

echo "Fixed address for Eden    : 10.31.3.13" >> log.txt
echo "Fixed address for Berlint : 10.31.2.3" >> log.txt

service isc-dhcp-server stop
service isc-dhcp-server start
service isc-dhcp-server status
service isc-dhcp-server status >> log.txt
bash lines.sh

echo "bash westalis.sh : done"

