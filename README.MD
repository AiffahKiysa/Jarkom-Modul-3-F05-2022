|     Nama    |     NRP    |
| :--------- |:--------    |
|Muhammad Amin | 5025201251 |
|Aiffah Kiysa Waafi | 5025201202 |
|Elthan Ramanda B | 5025201092 |



## 1. Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server.

Topologi sesuai soal seperti pada gambar dibawah ini
<img src="image\topologi.jpg">

kemudian mengubah setting network configuration menjadi seperti berikut
- Ostania
```
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
```

- Wise
```
auto eth0
iface eth0 inet static
    address 10.31.2.2
    netmask 255.255.255.0
    gateway 10.31.2.1
```

- Berlint
```
auto eth0
iface eth0 inet static
    address 10.31.2.3
    netmask 255.255.255.0
    gateway 10.31.2.1
```

- Westalis
```
auto eth0
iface eth0 inet static
    address 10.31.2.4
    netmask 255.255.255.0
    gateway 10.31.2.1
```

-Eden (Fixed address client)
```
auto eth0
iface eth0 inet dhcp
hwaddress ether 12:34:56:78:9a:bc
```

- SSS, Garden, NewstonCastle, KemonoPark (Client)
```
auto eth0
iface eth0 inet dhcp
```

## 2. Ostania sebagai DHCP Relay 

Pertama, lakukan instalasi DHCP Relay pada Ostania
```
apt-get update
apt-get install isc-dhcp-relay -y
```

Pada saat instalasi berjalan, maka akan muncul pertanyaan seperti berikut, di enter enter saja (kosongan dulu tidak apa apa)

setelah itu jalankan script dibawah ini untuk mengubah pengaturan dhcp relay
```
echo "
SERVERS=\"10.31.2.4\"
INTERFACES=\"eth1 eth2 eth3\"
OPTIONS=
" > /etc/default/isc-dhcp-relay

echo "
net.ipv4.ip_forward=1
" > /etc/sysctl.conf
```
<br>

<img src="image\dhcp-relay.jpg">

Kemudian kita restart dhcp-relay, dan untuk mengetahui dhcp-relay sudah berjalan, lihat status dengan command berikut
```
service isc-dhcp-relay restart
service isc-dhcp-relay status
```
Untuk memastikan node-node lainnya dapat mengakses internet dapat dijalankan command berikut
```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.31.0.0/16
```
## 3. Loid dan Franky menyusun peta tersebut dengan hati-hati dan teliti. Ada beberapa kriteria yang ingin dibuat oleh Loid dan Franky, yaitu:
1.	Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
2.	Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.155

Sebelum melanjutkan step selanjutnya jalankan command berikut agar dapat terkoneksi ke internet
```
echo nameserver 192.168.122.1 > /etc/resolv.conf
```
IP DNS dapat di check dengan
```
cat /etc/resolv.conf
```

Kita perlu melakukan instalasi dhcp-server terlebih dahulu di Westalis
```
apt-get update
apt-get install isc-dhcp-server -y
```
Kemudian edit konfigurasi interface pada file /etc/default/isc-dhcp-server menjadi eth0

<img src="image\eth0_dhcpserver.jpg">

Dan pada file /etc/dhcp/dhcpd.conf tambahkan command berikut
```
subnet 10.31.1.0 netmask 255.255.255.0 {
    range 10.31.1.50 10.31.1.88;
    range 10.31.1.120 10.31.1.155;
    option routers 10.31.1.1;
    option broadcast-address 10.31.1.255;
    option domain-name-servers 10.31.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
subnet 10.31.2.0 netmask 255.255.255.0 {
}
```
![image](https://user-images.githubusercontent.com/94375772/201642336-1f8f51bf-8e49-4950-9e85-dfb2c358c7bb.png)

Setelah itu restart dhcp-server dan lihat status untuk mengetahui apakah dhcp-server sudah berjalan
```
service isc-dhcp-server restart
service isc-dhcp-server status
```
<img src="image\dhcp-server_running.jpg">

Dengan konfigurasi dhcp diatas, jika kita testing ip maka hasilnya seperti berikut

<img src="image\ip_sss.jpg">

dan client sudah bisa mengakses internet.

<img src="image\ping_google_sss.jpg">


## 4. Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.10 - [prefix IP].3.30 dan [prefix IP].3.60 - [prefix IP].3.85 

Untuk menambahkan cient yang terhubung switch3, buka file /etc/dhcp/dhcpd.conf pada westalis dan tambahkan command berikut
```
subnet 10.31.3.0 netmask 255.255.255.0 {
    range 10.31.3.10 10.31.3.30;
    range 10.31.3.60 10.31.3.85;
    option routers 10.31.3.1;
    option broadcast-address 10.31.3.255;
    option domain-name-servers 10.31.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
```
kemudian restart dhcp-server
```
service isc-dhcp-server restart
```

ip pada client switch3 seperti berikut

<img src="image\ip_eden.jpg">

dan client sudah bisa mengakses internet

<img src="image\ping_google_eden.jpg">

## 5. Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.

Pada file /etc/dhcp/dhcpd.conf edit konfigurasi domain-name-server menjadi seperti berikut

![image](https://user-images.githubusercontent.com/94375772/201648077-1fad8b41-70ec-4710-8ed1-8b189a056b5f.png)

Kemudian lakukan instalasi bind9 pada Wise.
```
apt-get update
apt-get install bind9 -y
```
Dan buka file /etc/bind/named.conf.options, uncomment fowarders dan edit seperti berikut

<img src="image\forwarders.jpg">

Kemudian restart bind9
```
service bind9 restart
```

Kemudian client dapat mengakses internet melalui nameserver, pada file /etc/resolv.conf hasilnya seperti berikut

<img src="image\nameserver.jpg">


## 6.	Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit. 

Pada file /etc/dhcp/dhcpd.conf edit konfigurasi default-lease-time pada switch1 menjadi 300 dan max-lease-time menjadi 6900

<img src="image\time-switch1.jpg">

Kemudian pada switch3 ubah default-lease-time menjadi 600 dan max-lease-time menjadi 6900

<img src="image\time-switch3.jpg">

Restart dhcp-server
```
service isc-dhcp-server restart
```

Kemudian restart juga semua client, dan jika kita buka console salah satu client maka lease time pada client switch1 berubah 300

<img src="image\lease-time_sss.jpg">

dan lease-time pada client switch3 berubah 600

<img src="image\lease-time_eden.jpg">

## 7. Loid dan Franky berencana menjadikan Eden sebagai server untuk pertukaran informasi dengan alamat IP yang tetap dengan IP [prefix IP].3.13 

Pada file /etc/dhcp/dhcpd.conf di Westalis, tambahkan konfigurasi berikut
```
host Eden {
        hardware ethernet 12:34:56:78:9a:bc;
        fixed-address 10.31.3.13;
}
```
dan restart dhcp-server
```
service isc-dhcp-server restart
```

Kemudian pada network configuration Eden tambahkan 
```
hwaddress ether 12:34:56:78:9a:bc
```

Lakukan testing ip pada Eden, maka akan berubah seperti berikut

<img src="image\ip_eden_3.13.jpg">
