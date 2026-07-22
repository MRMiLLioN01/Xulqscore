-- Phone-first signup: auth email is synthetic (u<digits>@xulqscore.app),
-- optional real email arrives as raw_user_meta_data->>'contact_email'.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name, type, phone, org_name)
  values (
    new.id,
    nullif(new.raw_user_meta_data->>'contact_email',''),
    new.raw_user_meta_data->>'full_name',
    coalesce(new.raw_user_meta_data->>'type','ind'),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'org_name'
  )
  on conflict (id) do update
    set email = excluded.email,
        phone = coalesce(excluded.phone, public.profiles.phone);
  return new;
end $$;

-- Never show the synthetic login-email as a contact email
update public.profiles set email = null where email like '%@xulqscore.app';
