# Restaurant POS App

Aplikasi Point of Sale (POS) untuk restoran yang dirancang khusus untuk tablet Android. Aplikasi ini menggunakan arsitektur modular sederhana yang cocok untuk bisnis UMKM dan dapat dikembangkan oleh 1-3 developer.

## Fitur Utama

- **Manajemen Menu**: Tambah, edit, dan kelola item menu restoran
- **Sistem Pemesanan**: Buat pesanan baru dengan antarmuka yang intuitif
- **Manajemen Meja**: Kelola status meja (tersedia, terisi, reserved, cleaning)
- **Sistem Pembayaran**: Proses pembayaran dengan berbagai metode
- **Laporan**: Laporan penjualan dan inventori
- **Manajemen User**: Sistem autentikasi dengan role-based access
- **Printer Integration**: Cetak struk melalui Bluetooth

## Teknologi yang Digunakan

- **Flutter**: Framework utama untuk pengembangan aplikasi
- **Provider**: State management
- **SQLite**: Database lokal
- **SharedPreferences**: Penyimpanan konfigurasi
- **HTTP**: Komunikasi dengan REST API
- **GoRouter**: Navigasi dan routing
- **Bluetooth Serial**: Koneksi printer

## Struktur Proyek

```
lib/
├── main.dart
├── config/
│   ├── app_config.dart
│   ├── themes.dart
│   └── route_config.dart
├── models/
│   ├── menu_item.dart
│   ├── order.dart
│   ├── table.dart
│   ├── user.dart
│   └── report.dart
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── order_service.dart
│   ├── bluetooth_service.dart
│   └── local_storage_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── table_provider.dart
│   └── report_provider.dart
├── screens/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── order/
│   │   ├── order_screen.dart
│   │   ├── table_selection_screen.dart
│   │   └── payment_screen.dart
│   ├── menu/
│   │   └── menu_screen.dart
│   ├── report/
│   │   └── report_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── widgets/
│   ├── menu_card.dart
│   ├── order_item_tile.dart
│   ├── app_button.dart
│   ├── confirmation_dialog.dart
│   └── table_card.dart
├── utils/
│   ├── currency_formatter.dart
│   ├── date_formatter.dart
│   └── validators.dart
└── assets/
    ├── images/
    ├── icons/
    └── fonts/
```

## Instalasi dan Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio atau VS Code
- Android SDK untuk pengembangan Android

### Langkah Instalasi

1. Clone repository ini
2. Masuk ke direktori proyek:
   ```bash
   cd restaurant_pos_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Konfigurasi

### Database

Aplikasi menggunakan SQLite untuk penyimpanan data lokal. Database akan dibuat otomatis saat pertama kali aplikasi dijalankan.

### API Backend

Untuk menggunakan fitur online, konfigurasikan endpoint API di `lib/config/app_config.dart`:

```dart
static const String baseUrl = 'https://your-api-endpoint.com';
```

### Printer Bluetooth

Untuk menggunakan fitur cetak struk:
1. Pastikan printer Bluetooth sudah terpasang
2. Pair printer dengan tablet Android
3. Konfigurasi printer di menu Settings

## Penggunaan

### Login
- Buka aplikasi dan masukkan username dan password
- Default admin credentials akan dikonfigurasi saat setup pertama

### Membuat Pesanan
1. Pilih "New Order" dari dashboard
2. Pilih item menu yang diinginkan
3. Atur jumlah dan tambahkan catatan jika perlu
4. Pilih meja untuk pesanan
5. Proses pembayaran

### Manajemen Menu
1. Akses menu "Menu Management" 
2. Tambah item baru dengan mengklik tombol "+"
3. Isi detail menu (nama, deskripsi, harga, kategori)
4. Simpan item menu

### Laporan
1. Akses menu "Reports"
2. Pilih rentang tanggal yang diinginkan
3. Lihat laporan penjualan dan inventori

## Arsitektur

Aplikasi menggunakan arsitektur yang sederhana namun terstruktur:

- **Models**: Definisi struktur data
- **Services**: Logic bisnis dan komunikasi API
- **Providers**: State management menggunakan Provider pattern
- **Screens**: UI screens/halaman aplikasi
- **Widgets**: Komponen UI yang dapat digunakan kembali
- **Utils**: Helper functions dan utilities

## Development Guidelines

### State Management
- Gunakan Provider untuk state management
- Pisahkan logic bisnis ke dalam providers
- Gunakan Consumer widget untuk listening state changes

### API Integration
- Semua API calls melalui ApiService
- Handle error dengan try-catch
- Implementasikan loading states

### UI/UX
- Desain responsive untuk tablet
- Gunakan Material Design 3
- Konsisten dengan tema aplikasi

### Data Persistence
- Data penting disimpan di SQLite
- Konfigurasi disimpan di SharedPreferences
- Implementasikan data sync untuk online/offline

## Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Support

Untuk support dan pertanyaan:
- Email: support@restaurantpos.com
- Documentation: [Link to docs]
- Issues: [GitHub Issues]

## Roadmap

- [ ] Integration dengan payment gateway
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Inventory management
- [ ] Customer management
- [ ] Loyalty program
- [ ] Multi-outlet support
