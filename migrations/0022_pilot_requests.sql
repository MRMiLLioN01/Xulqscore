-- Pilot / partnership enquiries submitted from the landing page.
-- Before this, the landing form only *pretended* to send: it showed a success
-- panel after a timeout and discarded the lead. This gives it somewhere to go.

create table if not exists public.pilot_requests (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz not null default now(),
  name        text not null check (char_length(name)  between 1 and 120),
  org         text not null check (char_length(org)   between 1 and 160),
  email       text not null check (char_length(email) between 3 and 160
                                   and email like '%@%'),
  volume      text          check (volume is null or char_length(volume) <= 40),
  note        text          check (note   is null or char_length(note)   <= 2000),
  lang        text          check (lang   is null or char_length(lang)   <= 8),
  user_agent  text          check (user_agent is null or char_length(user_agent) <= 400),
  handled     boolean not null default false
);

create index if not exists pilot_requests_created_idx
  on public.pilot_requests (created_at desc);

alter table public.pilot_requests enable row level security;

-- Anonymous visitors may only INSERT. They can never read the table back, so
-- one submitter cannot enumerate other institutions' enquiries.
drop policy if exists "anon insert pilot requests" on public.pilot_requests;
create policy "anon insert pilot requests"
  on public.pilot_requests for insert
  to anon, authenticated
  with check (true);

-- Staff read/update through the existing is_admin() helper.
drop policy if exists "admin read pilot requests" on public.pilot_requests;
create policy "admin read pilot requests"
  on public.pilot_requests for select
  to authenticated
  using (public.is_admin());

drop policy if exists "admin update pilot requests" on public.pilot_requests;
create policy "admin update pilot requests"
  on public.pilot_requests for update
  to authenticated
  using (public.is_admin())
  with check (public.is_admin());
