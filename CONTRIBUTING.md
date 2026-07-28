# Working on this repository

## Deployment
Three Vercel projects build from this one repository:

| Project | Root directory | Domain |
|---|---|---|
| `xulqscore`         | `/`        | xulqscore.uz |
| `xulqscore-admin`   | `/admin`   | admin.xulqscore.uz |
| `xulqscore-partner` | `/partner` | partner.xulqscore.uz |

Any push to `main` redeploys all three.

## Database changes
Never edit the schema by hand in the Supabase dashboard — changes made there are not
reproducible and will be lost. Add a numbered file to `migrations/` instead:

```
migrations/00NN_short_description.sql
```

CI applies it on push and records it in `_migrations`, so it runs exactly once.
Migrations are append-only: to change something, add a new migration rather than
editing one that has already run.

## Conventions
- No build step. The client is plain HTML/CSS/JS and must stay that way.
- Never commit plaintext passwords, tokens or keys. Password changes go in as bcrypt
  hashes only.
- Scoring logic belongs in the database, not the browser.
