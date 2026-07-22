-- Admin verification / approval of registered users.
alter table public.profiles add column if not exists verified boolean not null default false;

-- Admins are always verified
update public.profiles set verified = true where role = 'admin';

-- Allow admins to update any profile (e.g. set verified) — in addition to "own profile update"
drop policy if exists "admin update profiles" on public.profiles;
create policy "admin update profiles" on public.profiles
  for update using (public.is_admin()) with check (public.is_admin());
