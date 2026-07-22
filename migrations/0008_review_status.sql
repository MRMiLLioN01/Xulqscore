-- Make the review queue actionable: store the admin's decision per result.
alter table public.test_results add column if not exists review_status text;   -- null/pending | approved | rejected
alter table public.test_results add column if not exists reviewed_at timestamptz;

-- Allow admins to update results (record review decisions)
drop policy if exists "admin update results" on public.test_results;
create policy "admin update results" on public.test_results
  for update using (public.is_admin()) with check (public.is_admin());
