

LOGIN FIX
- Firebase Analytics dikeluarkan dari critical login path.
- Auth persistence menggunakan browserLocalPersistence.
- Pesan error Firebase ditampilkan secara jelas.
- Error Firestore dibedakan dari error login.
- Mendukung Enter untuk login.
- Jika login gagal, lihat pesan yang muncul di bawah tombol login.

FIREBASE AUTH CHECKLIST
1. Firebase Console > Authentication > Sign-in method > Email/Password = Enabled.
2. Firebase Console > Authentication > Users > pastikan akun admin sudah dibuat.
3. Authentication > Settings > Authorized domains > tambahkan domain deployment bila dibutuhkan.
4. Firestore Rules harus mengizinkan request.auth != null untuk promos dan promoLeads.
