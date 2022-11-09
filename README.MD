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

- SSS, Garden, Eden, NewstonCastle, KemonoPark (Client)
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

Pada saat instalasi berjalan, maka akan muncul pertanyaan seperti berikut
```
Servers the DHCP relay should forward requests to:
```
Isi dengan '10.31.2.4'
```
Interfaces the DHCP relay should listen on:
```
Isi dengan 'eth1 eth2 eth3'.
Pada pertanyaan Additional options for the DHCP relay daemon:, tidak perlu diisi. Pada file /etc/default/isc-dhcp-relay konfigurasi akan terisi server dan interface seperti berikut
<img src="image\dhcp-relay.jpg">

Kemudian kita restart dhcp-relay, dan untuk mengetahui dhcp-relay sudah berjalan, lihat status dengan command berikut
```
service isc-dhcp-relay restart
service isc-dhcp-relay status
```

## 3. Loid dan Franky menyusun peta tersebut dengan hati-hati dan teliti. Ada beberapa kriteria yang ingin dibuat oleh Loid dan Franky, yaitu:
1.	Semua client yang ada HARUS menggunakan konfigurasi IP dari DHCP Server.
2.	Client yang melalui Switch1 mendapatkan range IP dari [prefix IP].1.50 - [prefix IP].1.88 dan [prefix IP].1.120 - [prefix IP].1.155

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
```
Setelah itu restart dhcp-server dan lihat status untuk mengetahui apakah dhcp-server sudah berjalan
```
service isc-dhcp-server restart
service isc-dhcp-server status
```
<img src="image\dhcp-server_running.jpg">

Dengan konfigurasi dhcp diatas, maka client yang melalui switch1 yaitu SSS dan Garden sudah bisa mengakses internet.
<img src="image\ping_google_sss.jpg">
