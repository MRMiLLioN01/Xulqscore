-- Remove the account used to verify the server-side routing pipeline.
delete from auth.users where email = 'u998993334455@xulqscore.app';
delete from public.error_log where message like '%audit selftest%';
