-- Security: replace the shared admin password with unique per-admin passwords.
-- Only bcrypt HASHES are stored here (safe to publish); plaintext is never in the repo.
update auth.users
  set encrypted_password = '$2a$10$owtEXtQTJrfWCvnND3L/Xe33cwe8zbX3wpT.Ntdv8MuceXEHvEs9.',
      updated_at = now()
  where email = 'muhriddin@admin.xulqscore.uz';

update auth.users
  set encrypted_password = '$2a$10$bdBVjjFR59vAk9aUnQ8u4eNF/uW0MwAGRfx0oiYtOpJupHSQYK54u',
      updated_at = now()
  where email = 'mirshod@admin.xulqscore.uz';

-- Seed/demo accounts must never be able to sign in
update auth.users set encrypted_password = null
  where email like '%@seed.xulqscore.app';
