-- Remove the post-registration verification gate.
-- Accounts are usable immediately after signup.
alter table public.profiles alter column verified set default true;
update public.profiles set verified = true where verified = false;

-- Scoring no longer requires verification (this was blocking results from saving).
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
  dims text[] := array['CON','INT','SC','LOC','MON','PLN'];

  v_uid uuid := auth.uid();
  n int; a jsonb; d text; i int;
  sc jsonb := '{}'::jsonb;
  primw jsonb := '{}'::jsonb;
  cur numeric; wv numeric; nd numeric; mean numeric;
  item_id text; cidx int; secs numeric; posl text;
  n_choices int; prim text;
  best_idx int; best_sum numeric; s_sum numeric;
  desirable int := 0; total int := 0;
  fast int := 0; timed int := 0;
  run int := 0; maxrun int := 0; prevp text := null;
  contra int := 0; arr numeric[];
  speed numeric; streak numeric; cpen numeric; coeff numeric;
  fast_rate numeric; des_rate numeric;
  raw jsonb := '{}'::jsonb; adj jsonb := '{}'::jsonb;
  overall int; band text; is_review boolean; reasons jsonb := '[]'::jsonb;
  spread numeric; minv numeric; maxv numeric; coached boolean;
  last_ts timestamptz; new_id uuid;
begin
  if v_uid is null then raise exception 'AUTH_REQUIRED'; end if;

  select max(created_at) into last_ts from public.test_results where user_id=v_uid;
  if last_ts is not null and last_ts > now() - interval '90 days' then
    raise exception 'RETEST_LOCKED_UNTIL %', to_char(last_ts + interval '90 days','YYYY-MM-DD');
  end if;

  n := jsonb_array_length(coalesce(p_answers,'[]'::jsonb));
  if n < MIN_ITEMS or n > MAX_ITEMS then raise exception 'BAD_LENGTH'; end if;

  foreach d in array dims loop
    sc := jsonb_set(sc, array[d], to_jsonb(50::numeric));
    primw := jsonb_set(primw, array[d], '[]'::jsonb);
  end loop;

  for i in 0..n-1 loop
    a := p_answers->i;
    item_id := a->>'i'; cidx := (a->>'c')::int;
    secs := nullif(a->>'s','')::numeric; posl := a->>'p';

    select count(*) into n_choices from public.scoring_items si where si.item_id = submit_assessment.item_id;
    if n_choices = 0 then raise exception 'BAD_ITEM %', item_id; end if;
    if cidx < 0 or cidx >= n_choices then raise exception 'BAD_CHOICE'; end if;
    select si.dim into prim from public.scoring_items si
      where si.item_id = submit_assessment.item_id and si.choice_idx = cidx;

    foreach d in array dims loop
      execute format('select avg(w_%s)::numeric from public.scoring_items where item_id=$1', lower(d))
        into mean using item_id;
      execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(d))
        into wv using item_id, cidx;
      wv  := round(wv - mean, 3);
      cur := (sc->>d)::numeric;
      if    wv > 0 then nd := cur + K*wv*(100-cur);
      elsif wv < 0 then nd := cur + K*wv*cur;
      else  nd := cur; end if;
      nd := greatest(0, least(100, nd));
      sc := jsonb_set(sc, array[d], to_jsonb(nd));
    end loop;

    best_idx := null; best_sum := null;
    for cidx in (select si.choice_idx from public.scoring_items si
                 where si.item_id = submit_assessment.item_id order by si.choice_idx) loop
      select (w_con+w_int+w_sc+w_loc+w_mon+w_pln)::numeric into s_sum
        from public.scoring_items si where si.item_id = submit_assessment.item_id and si.choice_idx = cidx;
      if best_sum is null or s_sum > best_sum then best_sum := s_sum; best_idx := cidx; end if;
    end loop;
    cidx := (a->>'c')::int;
    if best_idx = cidx then desirable := desirable + 1; end if;
    total := total + 1;

    execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(prim))
      into wv using item_id, cidx;
    primw := jsonb_set(primw, array[prim], (primw->prim) || to_jsonb(wv));

    if secs is not null then
      timed := timed + 1;
      if secs < MIN_SECONDS then fast := fast + 1; end if;
    end if;
    if posl is not null then
      if prevp is not null and posl = prevp then run := run + 1; else run := 1; end if;
      prevp := posl;
      if run > maxrun then maxrun := run; end if;
    end if;
  end loop;

  fast_rate := case when timed>0 then fast::numeric/timed else 0 end;
  speed  := least(SPEED_MAX, SPEED_MAX * greatest(0, fast_rate - FAST_TOL)/(1-FAST_TOL));
  streak := least(STREAK_MAX, STREAK_STEP * greatest(0, maxrun - 5));

  foreach d in array dims loop
    select array_agg(x::numeric) into arr from jsonb_array_elements_text(primw->d) t(x);
    if arr is not null and array_length(arr,1) >= 2
       and ((select max(v) from unnest(arr) v) - (select min(v) from unnest(arr) v)) >= CONTRA_GAP
       and (select max(v) from unnest(arr) v) >= CONTRA_POS
       and (select min(v) from unnest(arr) v) <= CONTRA_NEG
    then contra := contra + 1; end if;
  end loop;
  cpen := least(CONTRA_MAX, CONTRA_STEP * greatest(0, contra - 2));

  coeff := round(greatest(COEFF_FLOOR, 1 - speed - streak - cpen), 3);
  des_rate := case when total>0 then round(desirable::numeric/total,2) else 0 end;

  select min((sc->>d2)::numeric), max((sc->>d2)::numeric)
    into minv, maxv from unnest(dims) d2;
  spread := maxv - minv;
  coached := (des_rate > 0.90 and minv > 60 and spread < 15);

  foreach d in array dims loop
    raw := jsonb_set(raw, array[d], to_jsonb(round((sc->>d)::numeric)::int));
    adj := jsonb_set(adj, array[d], to_jsonb(round((sc->>d)::numeric * coeff)::int));
  end loop;
  select round(avg((adj->>d2)::numeric))::int into overall from unnest(dims) d2;
  band := case when overall>=70 then 'A' when overall>=55 then 'B' when overall>=40 then 'C' else 'D' end;

  is_review := (coeff < REVIEW_AT or fast_rate > FAST_HARD or maxrun >= 9 or contra >= 5 or coached);
  if is_review then
    if fast_rate > FAST_TOL then reasons := reasons || '["r_fast"]'::jsonb; end if;
    if maxrun >= 6        then reasons := reasons || '["r_streak"]'::jsonb; end if;
    if contra >= 3        then reasons := reasons || '["r_contra"]'::jsonb; end if;
    if coached            then reasons := reasons || '["r_coach"]'::jsonb; end if;
    if jsonb_array_length(reasons)=0 then reasons := '["r_fast"]'::jsonb; end if;
  end if;

  insert into public.test_results
    (user_id,overall,band,coeff,qs_count,review,reasons,scores,adjusted)
  values (v_uid,overall,band,coeff,n,is_review,reasons,raw,adj)
  returning id into new_id;

  return jsonb_build_object('id',new_id,'overall',overall,'band',band,'coeff',coeff,
    'qs_count',n,'review',is_review,'reasons',reasons,'scores',raw,'adjusted',adj);
end $$;
