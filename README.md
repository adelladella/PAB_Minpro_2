### Mini Project 1

## "Aplikasi Pencatatan Barang Preloved"

###### Nama: Adella Putri

###### NIM: 2409116006

###### Kelas: A, Sistem Informasi 2024

<img width="3780" height="1890" alt="fix pab (1)" src="https://github.com/user-attachments/assets/f74cc5a8-387d-4a65-9203-a8125c91579c" />

# All About PreLove Notes:

**PreLove Notes** merupakan rancangan aplikasi mobile yang digunakan untuk membantu pengguna dalam mencatat dan mengelola barang preloved (barang bekas layak jual) secara terstruktur dan efisien.

Aplikasi ini dibuat sebagai solusi sederhana bagi individu yang sering menjual kembali barang pribadi seperti pakaian, tas, sepatu, atau aksesoris, namun belum memiliki sistem pencatatan yang rapi. Melalui PreLove Notes, pengguna dapat menyimpan informasi penting terkait barang seperti nama, harga jual, kondisi, kategori, serta status ketersediaan barang.

Secara umum, PreLove Notes berfungsi sebagai aplikasi manajemen data barang preloved berbasis CRUD (Create, Read, Update, Delete). Aplikasi ini dirancang dengan tampilan yang sederhana, serta alur penggunaan yang mudah dipahami oleh pengguna awam sekalipun.

# Yang di Kembangkan Lebih Lanjut pada Mini Project 2  

<details>
<summary> Click Here </summary>

Pada _Mini Project 1_, aplikasi PreLove Notes masih menggunakan **penyimpanan data lokal** yang berada langsung di dalam aplikasi. Data barang disimpan dalam bentuk `List<Map<String, dynamic>>` sehingga hanya tersimpan selama aplikasi berjalan.

Pada _Mini Project 2_, kini aplikasi dikembangkan lebih lanjut agar lebih mendekati struktur aplikasi mobile yang sebenarnya. Beberapa perubahan utama dilakukan baik dari sisi arsitektur aplikasi maupun fitur yang tersedia.

Beberapa pengembangan yang dilakukan antara lain sebagai berikut.
- Integrasi Database Supabase
- Data barang tidak lagi disimpan di dalam list lokal, melainkan disimpan di database Supabase. Dengan adanya integrasi ini, data barang dapat disimpan secara permanen dan dapat diambil kembali ketika aplikasi dijalankan.
- Seluruh proses pengelolaan data kini dilakukan melalui operasi CRUD yang terhubung langsung dengan Supabase.

Operasi yang tersedia meliputi:
- menambahkan barang baru
- menampilkan daftar barang
- memperbarui informasi barang
- menghapus barang dari database

---

### Sistem Login dan Register

Pada versi sebelumnya aplikasi belum memiliki sistem autentikasi. Pada Mini Project 2 ditambahkan fitur login dan register menggunakan _**Supabase Authentication**_.

Pengguna dapat membuat akun baru menggunakan _email_ dan _password_, kemudian _login_ ke dalam aplikasi menggunakan akun tersebut.

Dengan adanya fitur ini, aplikasi menjadi lebih realistis karena setiap pengguna dapat mengakses aplikasi menggunakan akun masing-masing.

---

### Struktur Project yang Lebih Terorganisir

Pada Mini Project 1, sebagian besar kode masih berada di beberapa file utama saja. 

Pada Mini Project 2, struktur project diperbaiki dengan memisahkan kode berdasarkan tanggung jawabnya.

Struktur utama project sekarang terdiri dari beberapa folder seperti:
- pages
- services
- controllers

Pemisahan ini membantu agar kode lebih mudah dibaca, lebih rapi, dan lebih mudah dikembangkan.

---

### Dark Mode dan Light Mode

Aplikasi sekarang mendukung dua mode tampilan yaitu _**Light Mode**_ dan _**Dark Mode**_.

Pengguna dapat mengganti tema langsung dari halaman utama melalui menu _**Toggle Theme**_. Perubahan tema ini diatur menggunakan _GetX Theme Controller_ sehingga perubahan tampilan dapat diterapkan secara global pada seluruh aplikasi.

Pemisahan ini membantu agar kode lebih mudah dibaca, lebih rapi, dan lebih mudah dikembangkan.

---

### Validasi Input yang Lebih Spesifik

Form input pada aplikasi kini dilengkapi dengan validasi yang lebih jelas agar pengguna tidak dapat memasukkan data secara sembarangan.

Beberapa validasi yang diterapkan antara lain:
- nama barang tidak boleh kosong
- email harus memiliki format yang benar
- password minimal 6 karakter
- harga hanya boleh diisi angka
- harga harus lebih dari 0

Validasi ini membantu menjaga kualitas data yang disimpan di database.

---

### Upload dan Penyimpanan Gambar

Pengguna sekarang dapat menambahkan gambar barang melalui galeri perangkat menggunakan package _**image_picker**_.

Gambar yang dipilih akan dikonversi ke dalam format _Base64_ sebelum disimpan ke database. Ketika data ditampilkan kembali pada halaman utama, gambar tersebut akan ditampilkan menggunakan _Image.memory_.

---

### Splash Screen

Aplikasi sekarang memiliki halaman pembuka berupa _**Splash Screen**_. Halaman ini ditampilkan ketika aplikasi pertama kali dijalankan.

Splash screen berfungsi sebagai tampilan pengenalan aplikasi sebelum pengguna masuk ke halaman login atau register.

---

</details>

# Struktur Folder dan Penjelasan File

<details>
<summary>Click Here</summary>

Untuk membuat kode lebih terorganisir, project PreLove Notes menggunakan struktur folder yang memisahkan tampilan, logika aplikasi, dan komunikasi dengan backend.

Struktur utama project pada folder lib adalah sebagai berikut.

```
lib
│
├── controllers
│   └── theme_controller.dart
│
├── pages
│   ├── form_page.dart
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   └── splash_page.dart
│
├── services
│   ├── auth_service.dart
│   └── supabase_service.dart
│
└── main.dart
```

Selain itu, project juga menggunakan file konfigurasi:

`.env`

yang digunakan untuk menyimpan Supabase URL dan API Key secara aman, dan setiap folder memiliki fungsi yang berbeda agar kode tidak tercampur dalam satu tempat.

---


## 1. Main.dart
  
File main.dart merupakan titik awal aplikasi. Semua proses awal aplikasi dijalankan dari file ini.

Beberapa proses penting yang dilakukan pada file ini antara lain:

### a. Inisialisasi Flutter
`WidgetsFlutterBinding.ensureInitialized();`

Kode ini memastikan Flutter sudah siap menjalankan proses asynchronous sebelum aplikasi dimulai.

---

### b. Membaca File Environment

`await dotenv.load();`

Kode ini digunakan untuk membaca file .env yang berisi konfigurasi Supabase seperti URL dan API Key.

Dengan menggunakan .env, informasi sensitif tidak perlu ditulis langsung di dalam kode program.


---

### c. Inisialisasi Supabase

```
await Supabase.initialize(
  url: dotenv.env['SUPABASE_URL']!,
  anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
);
```

Kode ini menghubungkan aplikasi Flutter dengan database Supabase sehingga aplikasi dapat melakukan operasi CRUD.

---

### d. Inisialisasi Theme Controller

`Get.put(ThemeController());`

Kode ini digunakan untuk mendaftarkan `ThemeController` agar dapat digunakan di seluruh aplikasi.

Controller ini bertanggung jawab untuk mengatur perubahan tema antara light mode dan dark mode.

---

### e. Menjalankan Aplikasi

`runApp(const MyApp());`

Widget MyApp menjadi root widget dari seluruh aplikasi.

---

### f. Widget MyApp

MyApp menggunakan GetMaterialApp karena aplikasi memanfaatkan GetX untuk mengatur state tema.

Pengaturan tema aplikasi dilakukan menggunakan kode berikut.

```
themeMode: themeController.isDark.value
    ? ThemeMode.dark
    : ThemeMode.light,
```

Jika nilai `isDark` bernilai `true` maka aplikasi menggunakan _dark mode_, jika `false` maka aplikasi menggunakan _light mode_.

---

### g. Pengaturan Light Mode

Light mode menggunakan warna yang lebih terang seperti:
- background krem
- card berwarna putih
- icon coklat
  
<img height="500" alt="Image" src="https://github.com/user-attachments/assets/9866ef10-5c02-4e25-ac77-0d1e8b61772d" />

Font utama yang digunakan adalah Poppins dari Google Fonts.

### h. Pengaturan Dark Mode

Dark mode menggunakan warna yang lebih gelap seperti:
- background coklat gelap
- card berwarna lebih gelap
- icon berwarna terang

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/1d1757eb-65a1-423a-a6ed-3cb23503414a" />

Mode ini membantu pengguna menggunakan aplikasi dengan lebih nyaman pada kondisi pencahayaan rendah.

---

### i. Halaman Awal Aplikasi

`home: const SplashPage(),`

Halaman pertama yang ditampilkan ketika aplikasi dibuka adalah `SplashPage`.

Halaman ini berfungsi sebagai tampilan pembuka sebelum pengguna masuk ke halaman login atau register.

---

## 2. Folder Services
  
Folder services berisi kode yang bertugas menghubungkan aplikasi dengan Supabase.

Dengan memisahkan kode database ke dalam folder ini, halaman aplikasi tidak perlu langsung menangani logika database.

Folder ini berisi dua file utama.

1. `auth_service.dart`
2. `supabase_service.dart`

---

### 2.1. `auth_service.dart`

File ini bertanggung jawab untuk menangani autentikasi pengguna menggunakan Supabase Auth.

Class utama pada file ini adalah `AuthService`.

Class ini menyimpan instance Supabase client yang digunakan untuk mengakses layanan autentikasi.

```
final supabase = Supabase.instance.client;
```

Beberapa fungsi yang tersedia pada file ini antara lain:

---

### a. Register

Digunakan untuk membuat akun baru menggunakan email dan password.

`supabase.auth.signUp(email: email, password: password);`

### b. Login

Digunakan untuk memverifikasi akun pengguna yang sudah terdaftar.

`supabase.auth.signInWithPassword(email: email, password: password);`

### c. Logout

Digunakan untuk mengakhiri session login pengguna.

`supabase.auth.signOut();`

### 2.2. supabase_service.dart

File ini menangani seluruh operasi CRUD data barang pada database Supabase.

Data barang disimpan pada tabel bernama _items_.

Class utama pada file ini adalah `SupabaseService`.

### a. Mengambil Data Barang'

`supabase.from('items').select();`

Digunakan untuk mengambil seluruh data barang dari database dan menampilkannya pada halaman utama.

### b. Menambahkan Data Barang

`supabase.from('items').insert(item);`

Digunakan ketika pengguna menambahkan barang baru melalui halaman form.

### c. Mengupdate Data Barang

`supabase.from('items').update(item).eq('id', id);`

Digunakan ketika pengguna mengedit informasi barang.

### e. Menghapus Data Barang

`supabase.from('items').delete().eq('id', id);`

Digunakan ketika pengguna menghapus barang dari daftar.

---

## 3. Folder Controllers

Folder controllers digunakan untuk menyimpan logic yang mengatur state aplikasi.

Pada aplikasi ini controller digunakan untuk mengatur tema aplikasi.

File yang terdapat pada folder ini adalah:

`theme_controller.dart`

---

### 3.1 theme_controller.dart

File ini digunakan untuk mengatur perubahan tema antara Light Mode dan Dark Mode.

Controller ini menggunakan GetX sebagai state management.

Class utama pada file ini adalah `ThemeController`.

`class ThemeController extends GetxController`

Controller ini memiliki variabel reactive bernama `isDark`.

`var isDark = false.obs;`

Variabel `.obs` menandakan bahwa nilainya bersifat _reactive_ sehingga perubahan nilainya akan langsung mempengaruhi tampilan aplikasi.

### a. Mengubah Tema

Perubahan tema dilakukan melalui fungsi berikut.

`void toggleTheme()`

Ketika fungsi ini dipanggil, nilai `isDark` akan berubah dan aplikasi akan mengganti mode tema antara _light mode_ dan _dark mode_.

Fungsi ini dipanggil dari halaman _HomePage_ melalui menu `Toggle Theme`.

---

</details>

# Penjelasan Setiap Halaman Aplikasi

<details>
<summary> Click Here </summary>

Folder pages berisi seluruh tampilan utama aplikasi.
Setiap file pada folder ini merepresentasikan satu halaman yang dapat diakses oleh pengguna.

Halaman yang tersedia pada aplikasi PreLove Notes antara lain:

1. SplashPage

2. LoginPage

3. RegisterPage

4. HomePage

5. FormPage

Setiap halaman memiliki fungsi yang berbeda dalam alur penggunaan aplikasi.

---

## 🌟 SplashPage

SplashPage merupakan halaman pertama yang ditampilkan ketika aplikasi dibuka.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/6c4d92bd-73ee-42fd-aa68-a3d559e4d225" />

Halaman ini berfungsi sebagai tampilan pembuka aplikasi sebelum pengguna masuk ke proses login atau pembuatan akun.

Pada halaman ini terdapat dua bagian utama yaitu:

### 1. Bagian Gambar

Pada bagian atas halaman terdapat gambar yang ditampilkan menggunakan widget:

`Image.asset()`

Gambar ini berfungsi sebagai elemen visual untuk memperkenalkan aplikasi kepada pengguna.

Ukuran gambar diatur menggunakan SizedBox agar menyesuaikan ukuran layar perangkat.

Tampilan menggunakan Desktop:

<img width="1919" height="1020" alt="Image" src="https://github.com/user-attachments/assets/c1759117-6953-42b6-a802-cd2324e9ed24" />

Tampilan menggunakan Ipad:

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/10f84f7b-39ad-46c7-953e-b25cc17f9d3e" />


### 2. Bagian Konten

Bagian bawah halaman berisi teks dan tombol navigasi yang mengarahkan pengguna ke halaman berikutnya.

Teks utama ditampilkan menggunakan font _Playfair Display_ melalui package `GoogleFonts`.

<img width="390" height="202" alt="Image" src="https://github.com/user-attachments/assets/cc66f3d0-ca07-4eac-bbb0-8c29d65b85ac" />

Widget yang digunakan antara lain:
- Column untuk menyusun elemen secara vertikal
- Text untuk menampilkan judul dan deskripsi
- ElevatedButton untuk tombol utama
- TextButton untuk navigasi tambahan

### Navigasi ke Halaman Berikutnya

`SplashPage` menyediakan dua tombol utama.

Tombol _**Get Started**_ akan mengarahkan pengguna ke halaman `RegisterPage`.

<img width="400" height="101" alt="Image" src="https://github.com/user-attachments/assets/c4d8a904-f2a7-4e3a-93ea-222a7b6af536" />

```
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const RegisterPage()),
);
```

Sedangkan tombol _**Login**_ akan mengarahkan pengguna ke halaman `LoginPage`.

<img width="400" height="55" alt="Image" src="https://github.com/user-attachments/assets/9c5ae161-de76-4197-8b31-be27b9baa715" />

Dengan adanya halaman ini, aplikasi memiliki tampilan awal yang lebih realistis seperti aplikasi mobile pada umumnya.

---

## 🌟 LoginPage

LoginPage digunakan untuk melakukan proses login pengguna sebelum dapat mengakses aplikasi.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/c39182dd-94b3-4a92-a925-6e72f321fcde" />

Halaman ini meminta pengguna untuk memasukkan:
- email
- password

Input tersebut diambil menggunakan `TextEditingController`.

### Input Field

Form login menggunakan widget `TextField` untuk mengambil input dari pengguna.

<img width="648" height="644" alt="Image" src="https://github.com/user-attachments/assets/dea54ad0-16a5-4935-8fe1-36355bdbd6fd" />

Beberapa komponen yang digunakan pada field antara lain:

- `prefixIcon` untuk menampilkan icon email dan password
- `hintText` sebagai _placeholder_
- `OutlineInputBorder` untuk membuat tampilan field lebih rapi

### Proses Login

Ketika tombol login ditekan, aplikasi akan memanggil fungsi login dari `AuthService`.

```
await authService.login(email, password);
```

Jika login berhasil, pengguna akan diarahkan ke halaman `HomePage`.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/e365bf77-f165-41ba-bccf-309500abdb77" />

```
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const HomePage()),
);
```

Jika login gagal, aplikasi akan menampilkan pesan kesalahan menggunakan `SnackBar`.

### Navigasi ke RegisterPage

Pada bagian bawah halaman terdapat tombol untuk pengguna yang belum memiliki akun.

Tombol ini menggunakan `widget TextButton` yang akan mengarahkan pengguna ke halaman `RegisterPage`.

---

## 🌟 RegisterPage

`RegisterPage` digunakan untuk membuat akun baru pada aplikasi.

Pengguna diminta untuk mengisi tiga field utama:
- nama
- email
- password

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/2d466129-2f3b-4712-8e2f-1ffb7b92b0c0" />

Semua input diambil menggunakan `TextEditingController`.

### Validasi Input

Sebelum proses registrasi dilakukan, aplikasi terlebih dahulu melakukan validasi terhadap input yang dimasukkan.

Validasi yang diterapkan antara lain:
- nama tidak boleh kosong
- email tidak boleh kosong
- email harus memiliki format yang benar
- password minimal 6 karakter

Jika ada input yang tidak valid, aplikasi akan menampilkan pesan menggunakan `SnackBar`.

### Proses Registrasi

Jika semua input valid, aplikasi akan memanggil fungsi register dari `AuthService`.

```
await authService.register(email, password);
```

Supabase kemudian akan membuat akun baru untuk pengguna.

Setelah registrasi berhasil, pengguna akan diarahkan ke halaman `LoginPage`.

### Tampilan Glass Card

RegisterPage menggunakan efek _glassmorphism_ dengan memanfaatkan widget:
- BackdropFilter
- ClipRRect

<img width="386" height="415" alt="Image" src="https://github.com/user-attachments/assets/dd08a3ba-5337-4793-b1e4-f2e73a806cf3" />

Efek blur ini membuat tampilan form terlihat lebih modern dan menarik.

---

## 🌟 HomePage

HomePage merupakan halaman utama aplikasi yang menampilkan seluruh data barang preloved yang tersimpan di database.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/6a0d5f02-94a4-4951-ae36-366ce9d0a6e7" />

Halaman ini menggunakan `StatefulWidget` karena data barang dapat berubah ketika pengguna menambahkan, mengedit, atau menghapus data.

### Mengambil Data dari Supabase

Ketika halaman pertama kali dibuka, aplikasi akan memanggil fungsi berikut.

`fetchItems();`

Fungsi ini mengambil data dari database menggunakan `SupabaseService`.

```
final data = await supabaseService.getItems();
```

Data kemudian disimpan ke dalam variabel items dan ditampilkan pada halaman.

### Menampilkan Daftar Barang

Data barang ditampilkan menggunakan widget:

`ListView.builder`

Widget ini digunakan untuk menampilkan daftar data secara dinamis berdasarkan jumlah data yang tersedia.

Setiap item ditampilkan dalam bentuk card barang yang berisi:
- gambar barang
- nama barang
- harga
- kondisi barang
- status barang

### Format Harga Rupiah

Harga barang diformat menggunakan package `intl`.

```
NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ')
```

Dengan format ini, angka seperti `250000` akan ditampilkan sebagai:

`Rp 250.000`

### Status Barang

Setiap barang memiliki dua status yaitu:
1. Available
2. SOLD

Jika barang sudah terjual, maka status akan berubah menjadi _**SOLD**_ dan sistem akan menyimpan **tanggal penjualan**.

Contoh barang jika sudah terjual:

<img width="388" height="140" alt="Image" src="https://github.com/user-attachments/assets/3a139434-31bf-4905-a5b7-0591fe141c7e" />

Contoh barang jika belum terjual:

<img width="389" height="147" alt="Image" src="https://github.com/user-attachments/assets/bcb9a244-4b63-4071-bf2f-0df0a09f8c9f" />

Tanggal tersebut ditampilkan menggunakan format:

```
13 Mar 2026
```

### Filter Kategori

HomePage juga memiliki fitur filter kategori yang ditampilkan menggunakan horizontal scroll.

Kategori yang tersedia antara lain:
- Tas
- Atasan
- Bawahan
- Sepatu
- Aksesoris

<img width="389" height="64" alt="Image" src="https://github.com/user-attachments/assets/b99565b0-20ed-43b0-9a26-82eed11bd506" />

Filter ini dibuat menggunakan widget `ListView` dengan arah scroll _horizontal_.

### Toggle Theme

Pada bagian menu terdapat fitur Toggle Theme yang digunakan untuk mengganti tampilan antara _light mode_ dan _dark mode_.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/de4db385-50d5-4072-917d-08dd8207f6a8" />

Fitur ini memanggil fungsi dari `ThemeController`.

```
themeController.toggleTheme();
```

### Logout

HomePage juga menyediakan tombol logout yang akan mengakhiri session pengguna.

<img width="69" height="55" alt="Image" src="https://github.com/user-attachments/assets/1246ffd0-7fa3-4f41-8412-f6374402b38d" />

```
supabase.auth.signOut();
```

Setelah logout, pengguna akan diarahkan kembali ke halaman login.

---

## 🌟 FormPage

FormPage digunakan untuk **menambahkan barang baru** ataupun **mengedit data barang yang sudah ada**.

Halaman ini juga menggunakan `StatefulWidget` karena form memiliki data yang dapat berubah.

Tampilan Form Page ketika menambahkan barang baru:

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/2b26fef1-238c-4bbf-8628-b2ccc3358a21" />

Tampilan Form Page ketika mengedit barang yang sudah ada:

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/e1670c21-aebe-45b8-8911-0bf0a4de4d25" />


### Input Data Barang

FormPage memiliki beberapa field input yaitu:
- Nama Barang
- Harga Jual
- Kondisi Barang
- Kategori Barang
- Upload Foto

Input teks menggunakan widget `TextField`, sedangkan pilihan kondisi dan kategori menggunakan `DropdownButton`.

### Upload Foto

Pengguna dapat mengupload gambar menggunakan package `image_picker`.

<img width="384" height="240" alt="Image" src="https://github.com/user-attachments/assets/04305a7c-4080-4182-ac2f-40d8cc1b8422" />

```
final XFile? image = await picker.pickImage(source: ImageSource.gallery);
```

Gambar yang dipilih akan dibaca sebagai _byte data_ kemudian dikonversi menjadi _Base64_ sebelum disimpan ke database.

### Menyimpan Data

Ketika tombol Simpan ditekan, data dari form akan dikemas ke dalam bentuk Map.

Jika form dalam mode tambah barang maka aplikasi akan memanggil:

`addItem()`

Namun jika form dalam mode edit maka aplikasi akan memanggil:

`updateItem()` 

### Validasi Harga

Harga hanya dapat diisi angka dengan bantuan:

```
FilteringTextInputFormatter.digitsOnly
```

Selain itu, aplikasi juga memeriksa apakah harga lebih besar dari 0 sebelum data disimpan.

<img height="500" alt="Image" src="https://github.com/user-attachments/assets/00909646-eb93-4696-8987-ed715a1ae08e" />

Hal ini memastikan pengguna tidak memasukkan harga yang tidak valid.

---

</details>

### Tampilan Keseluruhan Aplikasi dan Alur Penggunaan Aplikasi

<details>
<summary> Click Here </summary>

Pada bagian ini ditampilkan alur penggunaan aplikasi PreLove Notes mulai dari proses registrasi akun hingga pengelolaan data barang preloved.

---

1. Splash Screen

Saat aplikasi pertama kali dibuka, pengguna akan melihat halaman Splash Screen yang berfungsi sebagai halaman pembuka aplikasi.

Halaman ini menampilkan pengenalan singkat aplikasi serta tombol untuk memulai penggunaan aplikasi.

<img src=" " width="300">

2. Registrasi Akun

Jika pengguna belum memiliki akun, pengguna dapat membuat akun baru melalui halaman Register dengan mengisi beberapa informasi berikut:

Nama

Email

Password

Setelah data diisi dan valid, akun akan dibuat menggunakan Supabase Authentication.

<img src="LINK_GAMBAR_REGISTER" width="300">
3. Login Pengguna

Setelah akun berhasil dibuat, pengguna dapat melakukan login menggunakan email dan password yang telah didaftarkan.

Jika login berhasil, pengguna akan diarahkan ke halaman utama aplikasi.

<img src="LINK_GAMBAR_LOGIN" width="300">
4. Halaman Utama Aplikasi

Setelah login berhasil, pengguna akan masuk ke halaman HomePage.

Pada halaman ini pengguna dapat melihat seluruh daftar barang preloved yang telah disimpan di database.

Informasi yang ditampilkan pada setiap barang meliputi:

Nama barang

Harga

Kondisi barang

Status barang

<img src="LINK_GAMBAR_HOME" width="300">
5. Menambahkan Barang

Pengguna dapat menambahkan barang baru dengan menekan tombol Floating Action Button (+) yang terdapat pada bagian bawah halaman.

Pengguna kemudian akan diarahkan ke halaman FormPage untuk mengisi data barang seperti:

Nama barang

Harga jual

Kondisi barang

Kategori barang

Upload foto barang

<img src="LINK_GAMBAR_TAMBAH_BARANG" width="300">
6. Mengedit Data Barang

Jika pengguna ingin memperbarui informasi barang, pengguna dapat menekan ikon edit pada card barang.

FormPage akan terbuka dalam mode edit dan field akan otomatis terisi dengan data lama.

Pengguna dapat mengubah informasi barang lalu menekan tombol Update untuk menyimpan perubahan.

<img src="LINK_GAMBAR_EDIT_BARANG" width="300">
7. Menandai Barang sebagai SOLD

Jika barang telah terjual, pengguna dapat menekan status barang pada card.

Aplikasi akan menampilkan dialog konfirmasi sebelum mengubah status barang menjadi SOLD.

Setelah status berubah, sistem akan otomatis mencatat tanggal penjualan barang.

<img src="LINK_GAMBAR_SOLD" width="300">
8. Menghapus Barang

Jika barang tidak lagi diperlukan dalam daftar, pengguna dapat menghapus data barang dengan menekan ikon delete.

Aplikasi akan menampilkan konfirmasi terlebih dahulu sebelum data dihapus dari database.

<img src="LINK_GAMBAR_DELETE" width="300">
9. Logout

Jika pengguna ingin keluar dari aplikasi, pengguna dapat menekan tombol logout pada bagian atas halaman.

Setelah logout, pengguna akan kembali ke halaman login.

<img src="LINK_GAMBAR_LOGOUT" width="300">

</details>
