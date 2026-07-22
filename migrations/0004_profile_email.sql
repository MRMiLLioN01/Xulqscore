-- Store email on profiles so the admin panel can list registered users.
alter table public.profiles add column if not exists email text;

-- Backfill existing profiles from auth.users
update public.profiles p
  set email = u.email
  from auth.users u
  where u.id = p.id and (p.email is null or p.email = '');

-- Update signup trigger to capture email going forward
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name, type, phone, org_name)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data->>'full_name',
    coalesce(new.raw_user_meta_data->>'type','ind'),
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'org_name'
  )
  on conflict (id) do update set email = excluded.email;
  return new;
end $$;
