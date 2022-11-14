#network configuration
echo "
auto eth0
iface eth0 inet static
       address 10.31.2.2
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
apt-get install bind9 -y

service bind9 >> log.txt
bash lines.sh

echo "
options {
        directory \"/var/cache/bind\";
        forwarders {
                192.168.122.1;
        };
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options

service bind9 stop
service bind9 start
service bind9 status >> log.txt
bash lines.sh