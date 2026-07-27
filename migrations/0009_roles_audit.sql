-- E: admin roles (super_admin) + audit log
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check
  check (role in ('user','admin','super_admin'));

-- Muhriddin becomes super admin
update public.profiles set role='super_admin', verified=true
  where id = (select id from auth.users where email='muhriddin@admin.xulqscore.uz');

-- is_admin() now includes super_admin
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles
    where id = auth.uid() and role in ('admin','super_admin'));
$$;

create or replace function public.is_super_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles
    where id = auth.uid() and role = 'super_admin');
$$;

-- Audit log
create table if not exists public.audit_log (
  id          bigint generated always as identity primary key,
  actor_id    uuid,
  actor_name  text,
  action      text not null,
  target_id   uuid,
  target_name text,
  detail      jsonb default '{}'::jsonb,
  created_at  timestamptz not null default now()
);
alter table public.audit_log enable row level security;
drop policy if exists "admin read audit"  on public.audit_log;
drop policy if exists "admin write audit" on public.audit_log;
create policy "admin read audit"  on public.audit_log for select using (public.is_admin());
create policy "admin write audit" on public.audit_log for insert with check (public.is_admin());
create index if not exists audit_log_created_idx on public.audit_log(created_at desc);
