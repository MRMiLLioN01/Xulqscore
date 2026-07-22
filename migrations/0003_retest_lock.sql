-- Enforce: an account can only take the test once every 90 days.
-- Real enforcement at the DB layer (can't be bypassed from the browser console).
create or replace function public.enforce_retest_lock()
returns trigger language plpgsql security definer set search_path = public as $$
declare last_ts timestamptz;
begin
  select max(created_at) into last_ts
    from public.test_results where user_id = new.user_id;
  if last_ts is not null and last_ts > now() - interval '90 days' then
    raise exception 'RETEST_LOCKED_UNTIL %', to_char(last_ts + interval '90 days', 'YYYY-MM-DD')
      using errcode = 'P0001';
  end if;
  return new;
end $$;

drop trigger if exists trg_retest_lock on public.test_results;
create trigger trg_retest_lock
  before insert on public.test_results
  for each row execute function public.enforce_retest_lock();
