# TBRead Mobile - PBP D10

Nama anggota kelompok:
1. Maurice Yang (2206816866)
2. Sekar Gandes Dianti (2206082713)
3. Fredo Melvern Tanzil (2206024713)
4. Samuel Farrel Bagasputra (2206826614)
5. Joseph Bintang Ardhirespati (2206082966)
6. Tiffany Lindy Adisuryo (2206025136)

Selamat datang di TBRead! 📖📚📑

Disini semua buku tersedia dari A sampai Z. Kamu dapat membaca buku yang ada. Ketika bingung mau baca buku apa, tinggal lihat buku favorit para pembaca biar ga ketinggalan. Atau malah sebaliknya, banyak sekali buku yang kamu ingin baca? Bisa diatasi, taruh buku tersebut pada TBR atau To Be Read, sehingga setelah menyelesaikan satu buku kamu tidak lupa untuk check out buku yang menarik lainnya. Kamu mau publish bukumu? Tentu saja bisa! Jadi, buku apa yang kamu baca hari ini?

Modul yang akan diimplementasikan:
- Book            : Model untuk mengatur buku, buku yang telah disimpan user
- Reader          : Model tambahan untuk _extend_ user, terdapat data tambahan seperti buku yang telah disimpan, dll
- Publisher        : Model tambahan untuk _extend_ user, mempunyai privilege untuk merilis buku
- PublisherHouse  : Model untuk mengatur publisher berdasarkan dari penerbit mana, seperti grup untuk publisher
- Search bar      : Modul untuk mencari buku berdasarkan kata kunci
- Like Book       : Modul untuk memberi opsi kepada pembaca untuk _like_ buku yang mereka sukai

Pembagian tugas modul
- publisher oleh Joseph Bintang A
- publisher house oleh Sekar Gandes Dianti
- reader oleh Tiffany Lindy Adisuryo
- profile oleh Samuel Farrel Bagasputra
- home page, login & register page, dan book detail page oleh Maurice Yang
- search bar & like book oleh Fredo Melvern Tanzil

Role:
- Reader    : User biasa, bisa membaca buku dan menyimpan buku dalam list buku yang ingin dibaca kemudian hari
- Publisher  : User yang bisa merilis dan mengubah buku
- admin      : User yang membuat Publisher dan PublisherHouse baru

Link berita acara: https://docs.google.com/spreadsheets/d/1dzGmWAET50FUOgAlvgXIZAMh0bGd6IZIpqdXS_3GczQ/edit#gid=667496128


Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester:
1. Menambahkan dependency http ke proyek yang digunakan untuk bertukar data melalui HTTP request
2. Membuat model sesuai ddengan respon data yang berasal dari aplikasi web proyek tengah semester
3. Mengirim http request ke web service menggunakan dependency http
4. Mengubah objek yang diperoleh dari web service ke model yang telah dibuat
5. Menampilkan data yang telah diubah ke aplikasi flutter dengan FutureBuilder

[![Build status](https://build.appcenter.ms/v0.1/apps/6b9f1205-6dbc-4df7-841d-875d2e6b038d/branches/main/badge)](https://appcenter.ms)
