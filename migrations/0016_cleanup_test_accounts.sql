-- Remove accounts created while verifying the save path end-to-end.
delete from auth.users where email in (
  'u998991112233@xulqscore.app',
  'u998992223344@xulqscore.app'
);
