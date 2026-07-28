-- Admin-granted retake, so a stuck applicant is never locked out for 90 days.
-- Abandoning a test mid-way never locks anyone: the lock is created only when a
-- result row is written, and an abandoned session writes nothing.
alter table public.profiles add column if not exists allow_retake boolean not null default false;

-- Trigger honours the grant and consumes it, so it can only be used once.
create or replace function public.enforce_retest_lock()
returns trigger language plpgsql security definer set search_path = public as $fn$
declare last_ts timestamptz; v_allow boolean;
begin
  select allow_retake into v_allow from public.profiles where id = new.user_id;
  if coalesce(v_allow, false) then
    update public.profiles set allow_retake = false where id = new.user_id;
    return new;
  end if;
  select max(created_at) into last_ts
    from public.test_results where user_id = new.user_id;
  if last_ts is not null and last_ts > now() - interval '90 days' then
    raise exception 'RETEST_LOCKED_UNTIL %', to_char(last_ts + interval '90 days', 'YYYY-MM-DD')
      using errcode = 'P0001';
  end if;
  return new;
end $fn$;

create or replace function public.submit_assessment(p_answers jsonb)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  K            constant numeric := 0.06;
  MIN_ITEMS    constant int     := 25;
  MAX_ITEMS    constant int     := 55;
  MIN_SECONDS  constant numeric := 9;
  FAST_TOL     constant numeric := 0.10;
  SPEED_MAX    constant numeric := 0.35;
  STREAK_STEP  constant numeric := 0.06;
  STREAK_MAX   constant numeric := 0.24;
  CONTRA_GAP   constant numeric := 4;
  CONTRA_POS   constant numeric := 2;
  CONTRA_NEG   constant numeric := -2;
  CONTRA_STEP  constant numeric := 0.06;
  CONTRA_MAX   constant numeric := 0.24;
  COEFF_FLOOR  constant numeric := 0.50;
  REVIEW_AT    constant numeric := 0.80;
  FAST_HARD    constant numeric := 0.50;
  v_dims text[] := array['CON','INT','SC','LOC','MON','PLN'];

  v_uid uuid := auth.uid();
  v_n int; v_a jsonb; v_d text; v_i int;
  v_sc jsonb := '{}'::jsonb;
  v_primw jsonb := '{}'::jsonb;
  v_cur numeric; v_w numeric; v_nd numeric; v_mean numeric;
  v_item text; v_cidx int; v_secs numeric; v_pos text;
  v_nchoices int; v_prim text;
  v_best_idx int; v_best_sum numeric; v_sum numeric;
  v_desirable int := 0; v_total int := 0;
  v_fast int := 0; v_timed int := 0;
  v_run int := 0; v_maxrun int := 0; v_prevp text := null;
  v_contra int := 0; v_arr numeric[];
  v_speed numeric; v_streak numeric; v_cpen numeric; v_coeff numeric;
  v_fast_rate numeric; v_des_rate numeric;
  v_raw jsonb := '{}'::jsonb; v_adj jsonb := '{}'::jsonb;
  v_overall int; v_band text; v_review boolean; v_reasons jsonb := '[]'::jsonb;
  v_spread numeric; v_minv numeric; v_maxv numeric; v_coached boolean;
  v_last timestamptz; v_new_id uuid;
begin
  if v_uid is null then raise exception 'AUTH_REQUIRED'; end if;

  -- an admin may grant a one-off retake; the trigger consumes the grant on insert
  if not coalesce((select allow_retake from public.profiles where id = v_uid), false) then
    select max(created_at) into v_last from public.test_results where user_id = v_uid;
    if v_last is not null and v_last > now() - interval '90 days' then
      raise exception 'RETEST_LOCKED_UNTIL %', to_char(v_last + interval '90 days','YYYY-MM-DD');
    end if;
  end if;

  v_n := jsonb_array_length(coalesce(p_answers,'[]'::jsonb));
  if v_n < MIN_ITEMS or v_n > MAX_ITEMS then raise exception 'BAD_LENGTH'; end if;

  foreach v_d in array v_dims loop
    v_sc := jsonb_set(v_sc, array[v_d], to_jsonb(50::numeric));
    v_primw := jsonb_set(v_primw, array[v_d], '[]'::jsonb);
  end loop;

  for v_i in 0..v_n-1 loop
    v_a := p_answers->v_i;
    v_item := v_a->>'i';
    v_cidx := (v_a->>'c')::int;
    v_secs := nullif(v_a->>'s','')::numeric;
    v_pos  := v_a->>'p';

    select count(*) into v_nchoices from public.scoring_items si where si.item_id = v_item;
    if v_nchoices = 0 then raise exception 'BAD_ITEM %', v_item; end if;
    if v_cidx < 0 or v_cidx >= v_nchoices then raise exception 'BAD_CHOICE'; end if;

    select si.dim into v_prim from public.scoring_items si
      where si.item_id = v_item and si.choice_idx = v_cidx;

    -- score update using effective (mean-centred) weights
    foreach v_d in array v_dims loop
      execute format('select avg(w_%s)::numeric from public.scoring_items where item_id=$1', lower(v_d))
        into v_mean using v_item;
      execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(v_d))
        into v_w using v_item, v_cidx;
      v_w := round(v_w - v_mean, 3);
      v_cur := (v_sc->>v_d)::numeric;
      if    v_w > 0 then v_nd := v_cur + K*v_w*(100-v_cur);
      elsif v_w < 0 then v_nd := v_cur + K*v_w*v_cur;
      else  v_nd := v_cur; end if;
      v_nd := greatest(0, least(100, v_nd));
      v_sc := jsonb_set(v_sc, array[v_d], to_jsonb(v_nd));
    end loop;

    -- desirability: the choice with the highest total weight
    select si.choice_idx into v_best_idx
      from public.scoring_items si
      where si.item_id = v_item
      order by (si.w_con+si.w_int+si.w_sc+si.w_loc+si.w_mon+si.w_pln) desc, si.choice_idx asc
      limit 1;
    if v_best_idx = v_cidx then v_desirable := v_desirable + 1; end if;
    v_total := v_total + 1;

    -- primary-dimension weight history (contradiction detection)
    execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(v_prim))
      into v_w using v_item, v_cidx;
    v_primw := jsonb_set(v_primw, array[v_prim], (v_primw->v_prim) || to_jsonb(v_w));

    -- timing + position streak
    if v_secs is not null then
      v_timed := v_timed + 1;
      if v_secs < MIN_SECONDS then v_fast := v_fast + 1; end if;
    end if;
    if v_pos is not null then
      if v_prevp is not null and v_pos = v_prevp then v_run := v_run + 1; else v_run := 1; end if;
      v_prevp := v_pos;
      if v_run > v_maxrun then v_maxrun := v_run; end if;
    end if;
  end loop;

  v_fast_rate := case when v_timed > 0 then v_fast::numeric/v_timed else 0 end;
  v_speed  := least(SPEED_MAX, SPEED_MAX * greatest(0, v_fast_rate - FAST_TOL)/(1-FAST_TOL));
  v_streak := least(STREAK_MAX, STREAK_STEP * greatest(0, v_maxrun - 5));

  foreach v_d in array v_dims loop
    select array_agg(x::numeric) into v_arr from jsonb_array_elements_text(v_primw->v_d) t(x);
    if v_arr is not null and array_length(v_arr,1) >= 2
       and ((select max(u) from unnest(v_arr) u) - (select min(u) from unnest(v_arr) u)) >= CONTRA_GAP
       and (select max(u) from unnest(v_arr) u) >= CONTRA_POS
       and (select min(u) from unnest(v_arr) u) <= CONTRA_NEG
    then v_contra := v_contra + 1; end if;
  end loop;
  v_cpen := least(CONTRA_MAX, CONTRA_STEP * greatest(0, v_contra - 2));

  v_coeff := round(greatest(COEFF_FLOOR, 1 - v_speed - v_streak - v_cpen), 3);
  v_des_rate := case when v_total > 0 then round(v_desirable::numeric/v_total, 2) else 0 end;

  select min((v_sc->>x)::numeric), max((v_sc->>x)::numeric)
    into v_minv, v_maxv from unnest(v_dims) x;
  v_spread := v_maxv - v_minv;
  v_coached := (v_des_rate > 0.90 and v_minv > 60 and v_spread < 15);

  foreach v_d in array v_dims loop
    v_raw := jsonb_set(v_raw, array[v_d], to_jsonb(round((v_sc->>v_d)::numeric)::int));
    v_adj := jsonb_set(v_adj, array[v_d], to_jsonb(round((v_sc->>v_d)::numeric * v_coeff)::int));
  end loop;
  select round(avg((v_adj->>x)::numeric))::int into v_overall from unnest(v_dims) x;
  v_band := case when v_overall>=70 then 'A' when v_overall>=55 then 'B'
                 when v_overall>=40 then 'C' else 'D' end;

  v_review := (v_coeff < REVIEW_AT or v_fast_rate > FAST_HARD or v_maxrun >= 9
               or v_contra >= 5 or v_coached);
  if v_review then
    if v_fast_rate > FAST_TOL then v_reasons := v_reasons || '["r_fast"]'::jsonb; end if;
    if v_maxrun >= 6          then v_reasons := v_reasons || '["r_streak"]'::jsonb; end if;
    if v_contra >= 3          then v_reasons := v_reasons || '["r_contra"]'::jsonb; end if;
    if v_coached              then v_reasons := v_reasons || '["r_coach"]'::jsonb; end if;
    if jsonb_array_length(v_reasons) = 0 then v_reasons := '["r_fast"]'::jsonb; end if;
  end if;

  insert into public.test_results
    (user_id, overall, band, coeff, qs_count, review, reasons, scores, adjusted)
  values (v_uid, v_overall, v_band, v_coeff, v_n, v_review, v_reasons, v_raw, v_adj)
  returning id into v_new_id;

  return jsonb_build_object('id',v_new_id,'overall',v_overall,'band',v_band,'coeff',v_coeff,
    'qs_count',v_n,'review',v_review,'reasons',v_reasons,'scores',v_raw,'adjusted',v_adj);
end $$;
