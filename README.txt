RECAPPROMO — MIGRASI FIREBASE KE SUPABASE

TUJUAN
Menyalin seluruh data collection:
- Firebase `promos` -> Supabase `promos`
- Firebase `promoLeads` -> Supabase `promo_leads`

Relasi promo/lead tetap dijaga walaupun ID Firebase dan Supabase berbeda.

CARA PAKAI
1. Pastikan schema utama RECAPPROMO Supabase sudah dijalankan.
2. Supabase > SQL Editor > jalankan `migration_patch.sql`.
3. Buka `migrate.html` lewat localhost atau hosting.
4. Masukkan:
   - Login Firebase lama
   - Login Supabase baru
5. Klik "Mulai Migrasi Data".
6. Cocokkan jumlah Promo dan Lead Firebase vs Supabase.
7. Setelah jumlah cocok, gunakan RECAPPROMO versi Supabase.

CATATAN
- File tidak memakai Supabase Secret Key.
- Data Firebase TIDAK dihapus.
- Migrasi menggunakan `legacy_firebase_id`, sehingga aman dijalankan ulang.
- Jangan menghapus Firebase sebelum data sudah divalidasi.
- User Authentication Firebase tidak ikut dimigrasikan oleh tool ini.
