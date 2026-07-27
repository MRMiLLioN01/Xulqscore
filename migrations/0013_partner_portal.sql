-- B: partner (lender) portal — consent-based score sharing via short-lived codes
alter table public.profiles drop constraint if exists profiles_role_check;
alter table public.profiles add constraint profiles_role_check
  check (role in ('user','admin','super_admin','partner'));

create or replace function public.is_partner()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'partner');
$$;

-- Consent artefacts: the applicant generates a code and hands it to a lender.
create table if not exists public.score_shares (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  user_id     uuid not null references auth.users(id) on delete cascade,
  result_id   uuid references public.test_results(id) on delete cascade,
  created_at  timestamptz not null default now(),
  expires_at  timestamptz not null,
  revoked     boolean not null default false
);
alter table public.score_shares enable row level security;
drop policy if exists "own shares read"   on public.score_shares;
drop policy if exists "own shares update" on public.score_shares;
drop policy if exists "admin read shares" on public.score_shares;
create policy "own shares read"   on public.score_shares for select using (auth.uid() = user_id);
create policy "own shares update" on public.score_shares for update using (auth.uid() = user_id);
create policy "admin read shares" on public.score_shares for select using (public.is_admin());
create index if not exists score_shares_user_idx on public.score_shares(user_id);

-- Every partner view is recorded (proof of who saw what, and when)
create table if not exists public.share_access (
  id          bigint generated always as identity primary key,
  share_id    uuid references public.score_shares(id) on delete cascade,
  partner_id  uuid,
  partner_org text,
  viewed_at   timestamptz not null default now()
);
alter table public.share_access enable row level security;
drop policy if exists "admin read access" on public.share_access;
drop policy if exists "own access read"   on public.share_access;
create policy "admin read access" on public.share_access for select using (public.is_admin());
create policy "own access read"   on public.share_access for select
  using (exists (select 1 from public.score_shares s where s.id = share_id and s.user_id = auth.uid()));

-- Applicant: create a share code (valid 24h) for their latest result
create or replace function public.create_share_code()
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_uid uuid := auth.uid(); v_res uuid; v_code text; alphabet text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
begin
  if v_uid is null then raise exception 'AUTH_REQUIRED'; end if;
  select id into v_res from public.test_results where user_id=v_uid order by created_at desc limit 1;
  if v_res is null then raise exception 'NO_RESULT'; end if;
  -- reuse an active code if one exists
  select code into v_code from public.score_shares
    where user_id=v_uid and not revoked and expires_at>now() order by created_at desc limit 1;
  if v_code is not null then
    return jsonb_build_object('code',v_code,'reused',true);
  end if;
  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(alphabet, 1+floor(random()*length(alphabet))::int, 1);
    end loop;
    exit when not exists (select 1 from public.score_shares s where s.code = v_code);
  end loop;
  insert into public.score_shares(code,user_id,result_id,expires_at)
    values (v_code, v_uid, v_res, now() + interval '24 hours');
  return jsonb_build_object('code',v_code,'reused',false);
end $$;
revoke all on function public.create_share_code() from public;
grant execute on function public.create_share_code() to authenticated;

-- Partner: look up a score by consent code (records the access)
create or replace function public.partner_lookup(p_code text)
returns jsonb language plpgsql security definer set search_path = public as $$
declare v_uid uuid := auth.uid(); s record; r record; p record; org text;
begin
  if v_uid is null then raise exception 'AUTH_REQUIRED'; end if;
  if not public.is_partner() then raise exception 'NOT_PARTNER'; end if;

  select * into s from public.score_shares
    where code = upper(trim(p_code)) and not revoked and expires_at > now();
  if s is null then raise exception 'INVALID_CODE'; end if;

  select * into r from public.test_results where id = s.result_id;
  if r is null then raise exception 'NO_RESULT'; end if;
  select full_name, phone, type, org_name into p from public.profiles where id = s.user_id;

  select org_name into org from public.profiles where id = v_uid;
  insert into public.share_access(share_id,partner_id,partner_org) values (s.id, v_uid, org);

  return jsonb_build_object(
    'full_name',p.full_name,'phone',p.phone,'type',p.type,'org_name',p.org_name,
    'overall',r.overall,'band',r.band,'coeff',r.coeff,'qs_count',r.qs_count,
    'review',r.review,'adjusted',r.adjusted,'taken_at',r.created_at,
    'expires_at',s.expires_at);
end $$;
revoke all on function public.partner_lookup(text) from public;
grant execute on function public.partner_lookup(text) to authenticated;

-- Demo partner account (password stored as bcrypt hash only)
do $$
declare v_id uuid; e text := 'demo@partner.xulqscore.uz';
begin
  select id into v_id from auth.users where email = e;
  if v_id is null then
    v_id := gen_random_uuid();
    insert into auth.users (instance_id,id,aud,role,email,encrypted_password,email_confirmed_at,
      created_at,updated_at,raw_app_meta_data,raw_user_meta_data,
      confirmation_token,recovery_token,email_change_token_new,email_change)
    values ('00000000-0000-0000-0000-000000000000',v_id,'authenticated','authenticated',e,
      '$2a$10$Rag6oDPnnH3BNAbdS6alxO4udJ7vyQkONG8IYT.uO5Zp0LSdQrwvm',
      now(),now(),now(),'{"provider":"email","providers":["email"]}'::jsonb,
      '{"full_name":"Demo Partner"}'::jsonb,'','','','');
    insert into auth.identities (provider_id,user_id,identity_data,provider,last_sign_in_at,created_at,updated_at)
    values (e,v_id,jsonb_build_object('sub',v_id::text,'email',e),'email',now(),now(),now());
  else
    update auth.users set encrypted_password='$2a$10$Rag6oDPnnH3BNAbdS6alxO4udJ7vyQkONG8IYT.uO5Zp0LSdQrwvm' where id=v_id;
  end if;
  insert into public.profiles (id,full_name,role,type,org_name,verified)
    values (v_id,'Demo Partner','partner','leg','Demo Bank',true)
    on conflict (id) do update set role='partner', org_name='Demo Bank', verified=true;
end $$;
