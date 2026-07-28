-- Mark demonstration records so they can never be mistaken for real users.
-- Demo profiles are renamed and flagged; the admin panel surfaces this visibly.
alter table public.profiles add column if not exists is_demo boolean not null default false;

update public.profiles p
   set is_demo = true
  from auth.users u
 where u.id = p.id
   and u.email like '%@seed.xulqscore.app';

-- Prefix the display name so it is unmistakable wherever it appears
update public.profiles
   set full_name = 'DEMO — ' || full_name
 where is_demo = true
   and full_name is not null
   and full_name not like 'DEMO —%';

create index if not exists profiles_is_demo_idx on public.profiles(is_demo);
