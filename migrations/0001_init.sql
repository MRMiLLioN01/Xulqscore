-- ============================================================
-- XulqskorAI — Supabase schema
-- Run this in Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- 1) PROFILES: one row per registered user (links to auth.users)
create table if not exists public.profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text,
  type        text not null default 'ind' check (type in ('ind','leg')), -- individual / legal entity
  phone       text,
  org_name    text,          -- for legal entities
  role        text not null default 'user' check (role in ('user','admin')),
  created_at  timestamptz not null default now()
);

-- 2) TEST RESULTS: one row per completed diagnostic
create table if not exists public.test_results (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  overall     int,
  band        text,          -- A / B / C / D
  coeff       numeric,       -- validity coefficient
  qs_count    int,
  review      boolean default false,
  reasons     jsonb default '[]'::jsonb,
  scores      jsonb,         -- raw dimension scores
  adjusted    jsonb,         -- coeff-adjusted scores
  created_at  timestamptz not null default now()
);

-- 3) Auto-create a profile row whenever someone signs up
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name, type, phone, org_name)
  values (
    new.id,
    new.raw_user_meta_data->>'full_name',
    coalesce(new.raw_user_meta_data->>'type','ind'),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'org_name'
  );
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4) Row Level Security
alter table public.profiles     enable row level security;
alter table public.test_results enable row level security;

-- helper: is the current user an admin?
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

-- profiles policies
drop policy if exists "own profile read"   on public.profiles;
drop policy if exists "own profile update" on public.profiles;
drop policy if exists "admin read all profiles" on public.profiles;
create policy "own profile read"   on public.profiles for select using (auth.uid() = id);
create policy "own profile update" on public.profiles for update using (auth.uid() = id);
create policy "admin read all profiles" on public.profiles for select using (public.is_admin());

-- test_results policies
drop policy if exists "own results read"   on public.test_results;
drop policy if exists "own results insert" on public.test_results;
drop policy if exists "admin read all results" on public.test_results;
create policy "own results read"   on public.test_results for select using (auth.uid() = user_id);
create policy "own results insert" on public.test_results for insert with check (auth.uid() = user_id);
create policy "admin read all results" on public.test_results for select using (public.is_admin());

-- 5) Admin dashboard view (joins result + who took it).
-- security_invoker=on makes the view honor the querying user's RLS, so it does
-- NOT leak data — only admins (via the policies above) can read all rows.
create or replace view public.admin_applicants
  with (security_invoker = on) as
  select r.*, p.full_name, p.type, p.phone, p.org_name
  from public.test_results r
  join public.profiles p on p.id = r.user_id;

-- ============================================================
-- AFTER a user signs up, make yourself admin by running:
--   update public.profiles set role='admin' where id = (
--     select id from auth.users where email = 'YOUR_EMAIL_HERE');
-- ============================================================
-- migration pipeline installed 2026-07-22
