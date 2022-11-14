#connect to franky-work.com
echo "nameserver 10.31.3.13" >> /etc/resolv.conf.d

#now sss could access loid-work.com & franky-work.com
#and also the internet

unset http_proxy

apt-get update
apt-get upgrade
apt-get install lynx -y

#Speed limit test
apt-get update
apg-get upgrade
apt-get install speedtest-cli -y
#run : speedtest


#activate the proxy, makesure to run berlint.sh first
export http_proxy="http://10.31.2.69:8080"
# export https_proxy="http://10.31.2.69:8080"

#silahkan coba untuk akses 
#1 : http 
#2 : https (masih gagal)
#3 : loid & franky

