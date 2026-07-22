-- Seed 52 fake (verified) users + one diagnostic result each. Presentation data.
-- Tagged with @seed.xulqscore.app so they can be identified / removed later.
create extension if not exists pgcrypto with schema extensions;

do $$
declare
  fnames text[] := array['Alisher','Dilnoza','Bekzod','Malika','Rustam','Nodira','Sardor','Kamola','Jasur','Feruza','Oybek','Zarina','Islom','Gulnora','Botir','Shahzod','Nigora','Aziz','Madina','Otabek','Laylo','Firdavs','Sevara','Ulugbek','Kamron','Shoira','Doniyor','Zulfiya','Sherzod','Munisa','Akmal','Dilfuza','Javohir','Nilufar','Temur','Charos','Bahodir','Gavhar','Sanjar','Mohira','Umid','Ozoda','Farrux','Yulduz','Iskandar','Robiya','Davron','Sitora','Elyor','Barno','Mirshod','Muhriddin'];
  lnames text[] := array['Karimov','Yusupova','Rahimov','Tosheva','Abdullayev','Ismoilova','Qodirov','Saidova','Nazarov','Umarova','Xolmatov','Aliyeva','Sobirov','Yodgorova','Tursunov','Ergasheva','Mirzayev','Sultonova','Rasulov','Hakimova'];
  dims text[] := array['CON','INT','SC','LOC','MON','PLN'];
  i int; v_id uuid; e text; nm text; ph text;
  coeff numeric; ov int; bnd text; rev boolean; rs jsonb;
  s_obj jsonb; a_obj jsonb; d text; raw int; a int; sum_adj int; created timestamptz;
begin
  if (select count(*) from auth.users where email like '%@seed.xulqscore.app') >= 52 then
    raise notice 'seed users already present, skipping';
    return;
  end if;

  for i in 1..52 loop
    nm  := fnames[1+floor(random()*array_length(fnames,1))::int] || ' ' || lnames[1+floor(random()*array_length(lnames,1))::int];
    ph  := '+998 (' || lpad((90+floor(random()*9))::int::text,2,'0') || ') '
           || lpad(floor(random()*1000)::int::text,3,'0') || '-'
           || lpad(floor(random()*100)::int::text,2,'0') || '-'
           || lpad(floor(random()*100)::int::text,2,'0');
    e   := 'seed'||i||'@seed.xulqscore.app';
    v_id := gen_random_uuid();
    coeff := round((0.60 + random()*0.40)::numeric, 2);
    created := now() - (random()*60 || ' days')::interval;

    s_obj := '{}'::jsonb; a_obj := '{}'::jsonb; sum_adj := 0;
    foreach d in array dims loop
      raw := 45 + floor(random()*50)::int;      -- 45..94
      a   := round(raw*coeff)::int;
      s_obj := s_obj || jsonb_build_object(d, raw);
      a_obj := a_obj || jsonb_build_object(d, a);
      sum_adj := sum_adj + a;
    end loop;
    ov  := round(sum_adj/6.0)::int;
    bnd := case when ov>=70 then 'A' when ov>=55 then 'B' when ov>=40 then 'C' else 'D' end;
    rev := coeff < 0.80;
    rs  := case when rev then '["r_fast","r_streak"]'::jsonb else '[]'::jsonb end;

    insert into auth.users (
      instance_id,id,aud,role,email,encrypted_password,email_confirmed_at,created_at,updated_at,
      raw_app_meta_data,raw_user_meta_data,confirmation_token,recovery_token,email_change_token_new,email_change
    ) values (
      '00000000-0000-0000-0000-000000000000',v_id,'authenticated','authenticated',e,
      extensions.crypt('seedpass123',extensions.gen_salt('bf')),created,created,created,
      '{"provider":"email","providers":["email"]}'::jsonb,
      jsonb_build_object('full_name',nm,'phone',ph),'','','',''
    );
    insert into auth.identities (provider_id,user_id,identity_data,provider,last_sign_in_at,created_at,updated_at)
    values (e,v_id,jsonb_build_object('sub',v_id::text,'email',e),'email',created,created,created);

    -- profile row already created by trigger; set verified + backdate + type
    insert into public.profiles (id,full_name,phone,type,role,verified,created_at)
    values (v_id,nm,ph,(case when random()<0.3 then 'leg' else 'ind' end),'user',true,created)
    on conflict (id) do update
      set full_name=excluded.full_name, phone=excluded.phone, type=excluded.type,
          verified=true, created_at=excluded.created_at;

    insert into public.test_results (user_id,overall,band,coeff,qs_count,review,reasons,scores,adjusted,created_at)
    values (v_id,ov,bnd,coeff,25+floor(random()*30)::int,rev,rs,s_obj,a_obj,created);
  end loop;
end $$;
