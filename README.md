# Shamo - Mobile E-Commerce Application 👟

**Shamo** adalah aplikasi mobile e-commerce modern yang berfokus pada penjualan sepatu. Proyek ini dikembangkan menggunakan framework **Flutter** dan **Supabase** sebagai Backend-as-a-Service (BaaS). Aplikasi ini dirancang khusus untuk menjembatani komunikasi antara penjual dan pembeli melalui fitur *Real-time Chat* yang interaktif.

> **Tugas Akhir Semester (EAS)** > **Mata Kuliah:** Teknologi Berkembang  
> **Institusi:** Departemen Sistem Informasi, Institut Teknologi Sepuluh Nopember (ITS).

---

## 🌟 Fitur Utama

Aplikasi Shamo dilengkapi dengan berbagai fitur fungsional untuk mendukung pengalaman belanja yang optimal:

* **Autentikasi & Sesi**: Login, Registrasi, dan manajemen sesi otomatis menggunakan Supabase Auth.
* **Katalog Produk Dinamis**:
    * *Popular Products*: Tampilan horizontal untuk produk terlaris.
    * *New Arrivals*: Tampilan list vertikal untuk koleksi terbaru.
    * *Category Filter*: Memfilter produk berdasarkan tipe (Running, Training, dll).
* **Interactive Real-time Chat**:
    * Komunikasi instan dengan dukungan *Real-time Stream*.
    * *Product Preview Bubble*: Mengirimkan detail produk langsung ke dalam chat.
    * *Quick Action*: Tombol "Add to Cart" dan "Buy Now" langsung dari dalam gelembung percakapan.
* **Sistem Transaksi Lengkap**:
    * Manajemen Keranjang (*Cart*) yang tersinkronisasi dengan database.
    * Halaman Wishlist untuk produk favorit.
    * Proses Checkout dengan integrasi tabel transaksi dan item transaksi.
* **Profil & Riwayat**: Update informasi profil dan melihat riwayat pesanan (*Order History*).

---

## 🛠 Teknologi yang Digunakan

| Kategori | Teknologi |
| :--- | :--- |
| **Frontend Framework** | [Flutter](https://flutter.dev/) (Dart) |
| **Backend (BaaS)** | [Supabase](https://supabase.com/) |
| **Database** | PostgreSQL |
| **Design Tool** | Figma |
| **State Management** | Provider / StreamBuilder |

---

## 📂 Struktur Folder (Modular)

Proyek ini disusun secara modular untuk memudahkan pemeliharaan kode:

```text
lib/
├── main.dart             # Entry point & Inisialisasi Supabase
├── theme.dart            # Konfigurasi desain global (Warna, Font, Margin)
├── models/               # Representasi data (Product, CartItem, User)
├── services/             # Logika API, Auth, & Database
│   ├── auth_service.dart
│   ├── chat_service.dart
│   ├── product_service.dart
│   └── cart_service.dart
├── pages/                # Halaman UI Aplikasi
│   ├── home/             # Tab utama (Home, Chat, Wishlist, Profile)
│   ├── cart_page.dart
│   ├── checkout_page.dart
│   ├── product_page.dart
│   └── splash_page.dart
└── widgets/              # Komponen UI Reusable
    ├── product_card.dart
    ├── chat_bubble.dart
    ├── custom_button.dart
    └── cart_card.dart

```

---

## 🚀 Get Started

Ikuti langkah-langkah di bawah ini untuk menjalankan Shamo di lingkungan lokal Anda.

### 1. ⚙️ Prasyarat

Sebelum memulai, pastikan mesin pengembang Anda telah terinstal:

* **Flutter SDK** (Versi terbaru sangat direkomendasikan)
* **Git** (Untuk manajemen repositori)
* **IDE** (VS Code atau Android Studio)
* **Emulator/Device** (Android atau iOS)

### 2. 📥 Clone Repositori

Buka terminal dan jalankan perintah berikut:

```bash
git clone [https://github.com/AryaYubi/belajarflutter.git](https://github.com/AryaYubi/belajarflutter.git)
cd belajarflutter

```

### 3. 📦 Instal Dependensi

Unduh semua paket Flutter yang diperlukan:

```bash
flutter pub get

```

### 4. 🔑 Konfigurasi Supabase

Buka file `lib/main.dart` dan masukkan kredensial proyek Supabase Anda (bisa didapatkan di Settings > API pada dashboard Supabase):

```dart
await Supabase.initialize(
  url: 'https://YOUR_PROJECT_URL.supabase.co',
  anonKey: 'YOUR_ANON_KEY',
);

```

### 5. 📱 Jalankan Aplikasi

Hubungkan perangkat Anda atau jalankan emulator, lalu ketik:

```bash
flutter run

```

---

## 👥 Tim Pengembang (Kelompok 1)

| NRP | Nama Anggota |
| --- | --- |
| **5026231175** | Muhammad Farrel Danendra |
| **5026231166** | Azrul Afif S. |
| **5026231165** | Putu Arya Yubi Wirayudha |
| **5026231028** | Kellan Matthew S. |
| **5026231138** | Peter Christian Erastus |
| **5026231129** | Rafindita Sumar Ramadhan |
| **5026231212** | Baqhiz Faruq S. |

**Dosen Pengampu:** Bekti Cahyo Hidayanto, S.Si., M.Kom.

---

<p align="center">
<b>© 2025 Departemen Sistem Informasi - ITS Surabaya</b>
</p>
