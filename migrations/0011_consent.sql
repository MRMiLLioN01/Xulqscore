-- D: consent record (personal data processing) — auditable proof of consent
create table if not exists public.consents (
  id           bigint generated always as identity primary key,
  user_id      uuid not null references auth.users(id) on delete cascade,
  policy_version text not null default '1.0',
  lang         text,
  granted_at   timestamptz not null default now(),
  user_agent   text
);
alter table public.consents enable row level security;

drop policy if exists "own consent insert" on public.consents;
drop policy if exists "own consent read"   on public.consents;
drop policy if exists "admin read consents" on public.consents;
create policy "own consent insert" on public.consents for insert with check (auth.uid() = user_id);
create policy "own consent read"   on public.consents for select using (auth.uid() = user_id);
create policy "admin read consents" on public.consents for select using (public.is_admin());

create index if not exists consents_user_idx on public.consents(user_id);

-- convenience flag on the profile
alter table public.profiles add column if not exists consent_at timestamptz;
