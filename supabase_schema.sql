-- ============================================================
-- RECAPPROMO V2 — SUPABASE / POSTGRESQL
-- Jalankan SELURUH file ini di Supabase > SQL Editor > New query
-- ============================================================

create extension if not exists pgcrypto;

-- ----------------------------
-- PROMOS
-- ----------------------------
create table if not exists public.promos (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  product text not null,
  channel text,
  start_date date not null,
  end_date date not null,
  target_lead integer not null default 0 check (target_lead >= 0),
  target_closing integer not null default 0 check (target_closing >= 0),
  printed integer not null default 0 check (printed >= 0),
  distributed integer not null default 0 check (distributed >= 0),
  location text,
  audience text,
  print_cost numeric(15,2) not null default 0 check (print_cost >= 0),
  distribution_cost numeric(15,2) not null default 0 check (distribution_cost >= 0),
  other_cost numeric(15,2) not null default 0 check (other_cost >= 0),
  cost numeric(15,2) not null default 0 check (cost >= 0),
  offer text,
  created_by uuid default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint promo_date_check check (end_date >= start_date),
  constraint distribution_check check (printed = 0 or distributed <= printed)
);

-- ----------------------------
-- PROMO LEADS
-- ----------------------------
create table if not exists public.promo_leads (
  id uuid primary key default gen_random_uuid(),
  promo_id uuid not null references public.promos(id) on delete restrict,
  lead_date date not null,
  invoice_code text,
  customer text not null,
  contact text,
  customer_type text not null default 'Tidak Diketahui'
    check (customer_type in ('Baru','Existing','Tidak Diketahui')),
  product_need text,
  sales text not null,
  source text,
  status text not null
    check (status in ('Baru','Follow Up','Closing','Lost')),
  follow_up_date date,
  lost_reason text,
  order_value numeric(15,2) not null default 0 check (order_value >= 0),
  hpp numeric(15,2) not null default 0 check (hpp >= 0),
  notes text,
  created_by uuid default auth.uid() references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint closing_invoice_required check (
    status <> 'Closing'
    or (invoice_code is not null and btrim(invoice_code) <> '')
  ),

  constraint closing_value_required check (
    status <> 'Closing'
    or order_value > 0
  ),

  constraint lost_reason_required check (
    status <> 'Lost'
    or (lost_reason is not null and btrim(lost_reason) <> '')
  )
);

-- Invoice tidak boleh double, case-insensitive.
create unique index if not exists promo_leads_unique_invoice
on public.promo_leads (upper(invoice_code))
where invoice_code is not null and btrim(invoice_code) <> '';

create index if not exists promo_leads_promo_id_idx
on public.promo_leads (promo_id);

create index if not exists promo_leads_lead_date_idx
on public.promo_leads (lead_date desc);

create index if not exists promo_leads_sales_idx
on public.promo_leads (sales);

create index if not exists promo_leads_status_idx
on public.promo_leads (status);

-- ----------------------------
-- RLS
-- Semua user authenticated dapat menggunakan RECAPPROMO bersama.
-- ----------------------------
alter table public.promos enable row level security;
alter table public.promo_leads enable row level security;

revoke all on table public.promos from anon;
revoke all on table public.promo_leads from anon;

grant select, insert, update, delete on table public.promos to authenticated;
grant select, insert, update, delete on table public.promo_leads to authenticated;

drop policy if exists "recappromo authenticated read promos" on public.promos;
drop policy if exists "recappromo authenticated insert promos" on public.promos;
drop policy if exists "recappromo authenticated update promos" on public.promos;
drop policy if exists "recappromo authenticated delete promos" on public.promos;

create policy "recappromo authenticated read promos"
on public.promos for select to authenticated
using (true);

create policy "recappromo authenticated insert promos"
on public.promos for insert to authenticated
with check (true);

create policy "recappromo authenticated update promos"
on public.promos for update to authenticated
using (true) with check (true);

create policy "recappromo authenticated delete promos"
on public.promos for delete to authenticated
using (true);

drop policy if exists "recappromo authenticated read leads" on public.promo_leads;
drop policy if exists "recappromo authenticated insert leads" on public.promo_leads;
drop policy if exists "recappromo authenticated update leads" on public.promo_leads;
drop policy if exists "recappromo authenticated delete leads" on public.promo_leads;

create policy "recappromo authenticated read leads"
on public.promo_leads for select to authenticated
using (true);

create policy "recappromo authenticated insert leads"
on public.promo_leads for insert to authenticated
with check (true);

create policy "recappromo authenticated update leads"
on public.promo_leads for update to authenticated
using (true) with check (true);

create policy "recappromo authenticated delete leads"
on public.promo_leads for delete to authenticated
using (true);

-- ----------------------------
-- OPTIONAL: master sales
-- Sudah disediakan untuk pengembangan berikutnya.
-- ----------------------------
create table if not exists public.sales_people (
  id bigint generated by default as identity primary key,
  name text unique not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.sales_people enable row level security;
revoke all on table public.sales_people from anon;
grant select on table public.sales_people to authenticated;

drop policy if exists "recappromo authenticated read sales" on public.sales_people;
create policy "recappromo authenticated read sales"
on public.sales_people for select to authenticated
using (true);

insert into public.sales_people (name) values
('Muhammad Angga Nugraha'),
('Nayla Reva Mutiara'),
('Nabilah Nurul Rahmadhaniyanti'),
('Epri Liyanto'),
('Muis Ramadhan'),
('Ramdani'),
('Sri Bulan Cahyani'),
('Pinkan Julian Salsabilla'),
('Maulidya Hanifah Sitepu'),
('Annisa Ramadhani Santosa'),
('Muhammad Daffa Ramadhiansyah')
on conflict (name) do nothing;
