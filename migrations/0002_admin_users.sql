-- Create two fixed admin accounts: Muhriddin & Mirshod (password: Newdiepie)
-- Login form maps the name -> <name>@admin.xulqscore.uz behind the scenes.
create extension if not exists pgcrypto with schema extensions;

do $$
declare
  emails text[] := array['muhriddin@admin.xulqscore.uz','mirshod@admin.xulqscore.uz'];
  names  text[] := array['Muhriddin','Mirshod'];
  v_id uuid; e text; nm text; i int;
begin
  for i in 1..array_length(emails,1) loop
    e := emails[i]; nm := names[i];
    select id into v_id from auth.users where email = e;

    if v_id is null then
      v_id := gen_random_uuid();
      insert into auth.users (
        instance_id, id, aud, role, email, encrypted_password,
        email_confirmed_at, created_at, updated_at,
        raw_app_meta_data, raw_user_meta_data,
        confirmation_token, recovery_token, email_change_token_new, email_change
      ) values (
        '00000000-0000-0000-0000-000000000000', v_id, 'authenticated', 'authenticated', e,
        extensions.crypt('Newdiepie', extensions.gen_salt('bf')),
        now(), now(), now(),
        '{"provider":"email","providers":["email"]}'::jsonb,
        jsonb_build_object('full_name', nm),
        '', '', '', ''
      );
      insert into auth.identities (
        provider_id, user_id, identity_data, provider,
        last_sign_in_at, created_at, updated_at
      ) values (
        e, v_id, jsonb_build_object('sub', v_id::text, 'email', e), 'email',
        now(), now(), now()
      );
    else
      -- account already exists: just (re)set the password
      update auth.users
        set encrypted_password = extensions.crypt('Newdiepie', extensions.gen_salt('bf')),
            updated_at = now()
      where id = v_id;
    end if;

    -- ensure profile exists with admin role
    insert into public.profiles (id, full_name, role, type)
      values (v_id, nm, 'admin', 'ind')
      on conflict (id) do update set role = 'admin', full_name = excluded.full_name;
  end loop;
end $$;
