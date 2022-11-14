echo "
http_port 8080
visible_hostname Berlint
acl available_hour0 time MTWHF 00:00-07:59
acl available_hour1 time MTWHF 08:00-17:00
acl available_hour2 time MTWHF 17:01-23:59
acl available_hour3 time AS 00:00-23:59
acl loid-work dstdomain loid-work.com
acl franky-work dstdomain franky-work.com
http_access allow loid-work available_hour1
http_access allow franky-work available_hour2
http_access deny all
delay_pools 1 available_hour0
delay_class 1 1 available_hour0
delay_access 1 allow all available_hour0
delay_parameters 1 16000/64000 available_hour0
delay_pools 1 available_hour1
delay_class 1 1 available_hour1
delay_access 1 allow all available_hour1
delay_parameters 1 16000/64000 available_hour1


acl all_https ssl::https .
ssl_bump terminate all_https
" > /etc/squid/squid.conf
service squid restart

echo "squid.conf : " >> log.txt
cat /etc/squid/squid.conf >> log.txt
bash lines.sh

service squid restart

echo "bash berlint3.sh : done"