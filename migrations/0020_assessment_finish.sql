-- Final scoring from server-held session state. The browser never sees a weight.
create or replace function public.assessment_finish(p_session uuid)
returns jsonb language plpgsql security definer set search_path = public as $fn$
declare
  MIN_SECONDS constant numeric := 9;   FAST_TOL   constant numeric := 0.10;
  SPEED_MAX   constant numeric := 0.35; STREAK_STEP constant numeric := 0.06;
  STREAK_MAX  constant numeric := 0.24; CONTRA_GAP constant numeric := 4;
  CONTRA_POS  constant numeric := 2;   CONTRA_NEG constant numeric := -2;
  CONTRA_STEP constant numeric := 0.06; CONTRA_MAX constant numeric := 0.24;
  COEFF_FLOOR constant numeric := 0.50; REVIEW_AT  constant numeric := 0.80;
  FAST_HARD   constant numeric := 0.50; MIN_ITEMS  constant int := 25;
  dims text[] := array['CON','INT','SC','LOC','MON','PLN'];

  s public.assessment_sessions; d text; v_uid uuid := auth.uid();
  v_fast int := 0; v_timed int := 0; t numeric;
  v_run int := 0; v_maxrun int := 0; v_prev text := null; p text;
  v_contra int := 0; v_arr numeric[];
  v_speed numeric; v_streak numeric; v_cpen numeric; v_coeff numeric;
  v_fastrate numeric; v_desrate numeric;
  v_raw jsonb := '{}'::jsonb; v_adj jsonb := '{}'::jsonb;
  v_overall int; v_band text; v_review boolean; v_reasons jsonb := '[]'::jsonb;
  v_minv numeric; v_maxv numeric; v_coached boolean; v_new uuid;
begin
  select * into s from public.assessment_sessions where id = p_session;
  if s is null or s.user_id <> v_uid then raise exception 'BAD_SESSION'; end if;
  if s.finished_at is not null then raise exception 'SESSION_FINISHED'; end if;
  if s.path_len < MIN_ITEMS then raise exception 'TOO_SHORT'; end if;

  foreach t in array coalesce(s.times,'{}'::numeric[]) loop
    v_timed := v_timed + 1;
    if t < MIN_SECONDS then v_fast := v_fast + 1; end if;
  end loop;
  v_fastrate := case when v_timed > 0 then v_fast::numeric/v_timed else 0 end;
  v_speed := least(SPEED_MAX, SPEED_MAX * greatest(0, v_fastrate - FAST_TOL)/(1-FAST_TOL));

  foreach p in array coalesce(s.choice_hist,'{}'::text[]) loop
    if v_prev is not null and p = v_prev then v_run := v_run + 1; else v_run := 1; end if;
    v_prev := p;
    if v_run > v_maxrun then v_maxrun := v_run; end if;
  end loop;
  v_streak := least(STREAK_MAX, STREAK_STEP * greatest(0, v_maxrun - 5));

  foreach d in array dims loop
    select array_agg(x::numeric) into v_arr from jsonb_array_elements_text(s.primw->d) q(x);
    if v_arr is not null and array_length(v_arr,1) >= 2
       and ((select max(u) from unnest(v_arr) u) - (select min(u) from unnest(v_arr) u)) >= CONTRA_GAP
       and (select max(u) from unnest(v_arr) u) >= CONTRA_POS
       and (select min(u) from unnest(v_arr) u) <= CONTRA_NEG
    then v_contra := v_contra + 1; end if;
  end loop;
  v_cpen := least(CONTRA_MAX, CONTRA_STEP * greatest(0, v_contra - 2));

  v_coeff := round(greatest(COEFF_FLOOR, 1 - v_speed - v_streak - v_cpen), 3);
  v_desrate := case when s.n > 0 then round(s.desirable::numeric/s.n, 2) else 0 end;

  select min((s.scores->>x)::numeric), max((s.scores->>x)::numeric)
    into v_minv, v_maxv from unnest(dims) x;
  v_coached := (v_desrate > 0.90 and v_minv > 60 and (v_maxv - v_minv) < 15);

  foreach d in array dims loop
    v_raw := jsonb_set(v_raw, array[d], to_jsonb(round((s.scores->>d)::numeric)::int));
    v_adj := jsonb_set(v_adj, array[d], to_jsonb(round((s.scores->>d)::numeric * v_coeff)::int));
  end loop;
  select round(avg((v_adj->>x)::numeric))::int into v_overall from unnest(dims) x;
  v_band := case when v_overall>=70 then 'A' when v_overall>=55 then 'B'
                 when v_overall>=40 then 'C' else 'D' end;

  v_review := (v_coeff < REVIEW_AT or v_fastrate > FAST_HARD or v_maxrun >= 9
               or v_contra >= 5 or v_coached);
  if v_review then
    if v_fastrate > FAST_TOL then v_reasons := v_reasons || '["r_fast"]'::jsonb; end if;
    if v_maxrun >= 6         then v_reasons := v_reasons || '["r_streak"]'::jsonb; end if;
    if v_contra >= 3         then v_reasons := v_reasons || '["r_contra"]'::jsonb; end if;
    if v_coached             then v_reasons := v_reasons || '["r_coach"]'::jsonb; end if;
    if jsonb_array_length(v_reasons) = 0 then v_reasons := '["r_fast"]'::jsonb; end if;
  end if;

  insert into public.test_results
    (user_id, overall, band, coeff, qs_count, review, reasons, scores, adjusted)
  values (v_uid, v_overall, v_band, v_coeff, s.path_len, v_review, v_reasons, v_raw, v_adj)
  returning id into v_new;

  update public.assessment_sessions set finished_at = now(), current_item = null
   where id = p_session;

  return jsonb_build_object('id',v_new,'overall',v_overall,'band',v_band,'coeff',v_coeff,
    'qs_count',s.path_len,'review',v_review,'reasons',v_reasons,'scores',v_raw,'adjusted',v_adj);
end $fn$;
revoke all on function public.assessment_finish(uuid) from public;
grant execute on function public.assessment_finish(uuid) to authenticated;

-- P2: indexes that keep the admin panel fast as volume grows
create index if not exists test_results_user_created_idx on public.test_results(user_id, created_at desc);
create index if not exists test_results_created_idx      on public.test_results(created_at desc);
create index if not exists profiles_phone_idx            on public.profiles(phone);
create index if not exists profiles_role_idx             on public.profiles(role);

-- P1 #4: application error log, visible in the admin panel
create table if not exists public.error_log (
  id         bigint generated always as identity primary key,
  user_id    uuid,
  app        text,
  message    text,
  detail     jsonb default '{}'::jsonb,
  user_agent text,
  created_at timestamptz not null default now()
);
alter table public.error_log enable row level security;
drop policy if exists "anyone can report" on public.error_log;
drop policy if exists "admin reads errors" on public.error_log;
create policy "anyone can report"  on public.error_log for insert with check (true);
create policy "admin reads errors" on public.error_log for select using (public.is_admin());
create index if not exists error_log_created_idx on public.error_log(created_at desc);
