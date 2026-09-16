-- =========================================================
-- RECAPPROMO — FIREBASE -> SUPABASE MIGRATION PATCH
-- Jalankan sekali di Supabase SQL Editor sebelum migrate.html
-- =========================================================

alter table public.promos
  add column if not exists legacy_firebase_id text;

alter table public.promo_leads
  add column if not exists legacy_firebase_id text;

create unique index if not exists promos_legacy_firebase_id_uidx
  on public.promos (legacy_firebase_id)
  where legacy_firebase_id is not null;

create unique index if not exists promo_leads_legacy_firebase_id_uidx
  on public.promo_leads (legacy_firebase_id)
  where legacy_firebase_id is not null;

-- authenticated users sudah punya CRUD dari schema RECAPPROMO sebelumnya.
-- Tidak ada secret/service-role key yang diperlukan untuk utility migrasi ini.
