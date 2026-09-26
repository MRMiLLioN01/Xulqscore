-- Security hardening after the pre-review audit (Supabase Security Advisor).
--
-- 1. public._migrations had RLS disabled, so anyone holding the public anon key
--    could read or insert rows through the REST API (and make CI skip a real
--    migration). Lock it: RLS on, no policies, no grants. CI connects as the
--    database owner, which bypasses RLS, so migrations keep working.
-- 2. Supabase grants EXECUTE on new functions to anon/authenticated directly,
--    so the earlier "revoke ... from public" did not remove anon access.
--    Internal helpers and trigger functions are now callable by nobody except
--    the owner; the assessment RPCs are signed-in only.
-- 3. The two public insert policies used WITH CHECK (true). They now check
--    something real, and a trigger rate-limits inserts so the landing form and
--    error logger cannot be used to flood the database.

-- 1 ---------------------------------------------------------------------------
alter table if exists public._migrations enable row level security;
revoke all on table public._migrations from anon, authenticated;

-- 2 ---------------------------------------------------------------------------
do $$
declare f record;
begin
  -- internal helpers + trigger functions: nobody but the owner
  for f in
    select p.oid::regprocedure as sig
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in ('_is_done','_next_item','_pick_item','handle_new_user','enforce_retest_lock')
  loop
    execute format('revoke all on function %s from public, anon, authenticated', f.sig);
  end loop;

  -- user-facing RPCs: signed-in users only
  for f in
    select p.oid::regprocedure as sig
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in ('assessment_start','assessment_answer','assessment_finish',
                        'create_share_code','partner_lookup','submit_assessment')
  loop
    execute format('revoke all on function %s from public, anon', f.sig);
    execute format('grant execute on function %s to authenticated', f.sig);
  end loop;
end $$;

-- 3 ---------------------------------------------------------------------------
drop policy if exists "anon insert pilot requests" on public.pilot_requests;
create policy "anon insert pilot requests"
  on public.pilot_requests for insert
  to anon, authenticated
  with check (handled = false and email like '%_@_%._%');

drop policy if exists "anyone can report" on public.error_log;
create policy "anyone can report"
  on public.error_log for insert
  to anon, authenticated
  with check (
    (user_id is null or user_id = auth.uid())
    and char_length(coalesce(message, '')) <= 600
    and char_length(coalesce(user_agent, '')) <= 400
    and pg_column_size(coalesce(detail, '{}'::jsonb)) <= 4000
  );

create or replace function public._rate_limit_inserts()
returns trigger language plpgsql security definer set search_path = public as $fn$
declare n int;
begin
  if tg_table_name = 'pilot_requests' then
    select count(*) into n from public.pilot_requests
      where lower(email) = lower(new.email) and created_at > now() - interval '1 hour';
    if n >= 3 then raise exception 'Too many requests from this address. Please try again later.' using errcode = 'P0001'; end if;
    select count(*) into n from public.pilot_requests where created_at > now() - interval '1 hour';
    if n >= 60 then raise exception 'Too many requests. Please try again later.' using errcode = 'P0001'; end if;
  elsif tg_table_name = 'error_log' then
    select count(*) into n from public.error_log where created_at > now() - interval '1 minute';
    if n >= 120 then return null; end if;   -- silently drop floods
  end if;
  return new;
end $fn$;
revoke all on function public._rate_limit_inserts() from public, anon, authenticated;

drop trigger if exists pilot_requests_rate_limit on public.pilot_requests;
create trigger pilot_requests_rate_limit before insert on public.pilot_requests
  for each row execute function public._rate_limit_inserts();

drop trigger if exists error_log_rate_limit on public.error_log;
create trigger error_log_rate_limit before insert on public.error_log
  for each row execute function public._rate_limit_inserts();

create index if not exists pilot_requests_email_idx on public.pilot_requests (lower(email), created_at desc);
