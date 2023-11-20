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

Role:
- Reader    : User biasa, bisa membaca buku dan menyimpan buku dalam list buku yang ingin dibaca kemudian hari
- Publisher  : User yang bisa merilis dan mengubah buku
- admin      : User yang membuat Publisher dan PublisherHouse baru

