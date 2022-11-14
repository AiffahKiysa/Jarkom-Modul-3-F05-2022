#setup DNS Master (domain name) at wise

mkdir /etc/bind/wise

#Buat domain	
echo "
zone \"loid-work.com\" {
	type master;
	file \"/etc/bind/wise/loid-work.com\";
};
" > /etc/bind/named.conf.local

rndc reload

#Set domain name
echo ";
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA    loid-work.com. root.loid-work.com. (
                             2           ; Serial
                        604800           ; Refresh
                         86400           ; Retry
                       2419200           ; Expire
                        604800 )         ; Negative Cache TTL
;
@       IN      NS      loid-work.com.
@       IN      A       10.31.2.2 ; IP WISE
www     IN      CNAME   loid-work.com.
@       IN      AAAA    ::1
" > /etc/bind/wise/loid-work.com

echo "
zone \"franky-work.com\" {
	type master;
	file \"/etc/bind/wise/franky-work.com\";
};
" >> /etc/bind/named.conf.local

rndc reload

#Set domain name
echo ";
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA    franky-work.com. root.franky-work.com. (
                             2           ; Serial
                        604800           ; Refresh
                         86400           ; Retry
                       2419200           ; Expire
                        604800 )         ; Negative Cache TTL
;
@       IN      NS      franky-work.com.
@       IN      A       10.31.3.13 ; IP Eden
www     IN      CNAME   franky-work.com.
@       IN      AAAA    ::1
" > /etc/bind/wise/franky-work.com

service bind9 restart
service bind9 status
service bind9 status >> log.txt
bash lines.sh

