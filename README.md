<div align="center">

# XulqskorAI

**Behavioural credit scoring for people and businesses with no credit history**

[xulqscore.uz](https://xulqscore.uz) · Tashkent, Uzbekistan

</div>

---

## The problem

In Uzbekistan a first-time borrower is effectively invisible to a bank. The credit bureau
holds no file on them, so the lender is left with two poor options: reject a potentially good
customer, or lend blind. This affects the fastest-growing parts of the economy — entrepreneurs,
young people entering the credit market, and women who hold accounts but have never been
assessed for a loan.

## What this is

XulqskorAI measures **behaviour instead of history**. In a 10–15 minute adaptive diagnostic,
an applicant answers 25–55 questions drawn from a bank of 500, where each answer determines
the next. The system evaluates six traits that international research links to repayment and
returns an overall score, a six-dimension profile, and a confidence coefficient describing how
reliable that measurement is.

The score is designed as an **additional signal** alongside a lender's existing tools. The
credit decision always remains with the financial institution.

### The six dimensions

| Code | Dimension |
|------|-----------|
| `CON` | Responsibility & order |
| `INT` | Honesty |
| `SC`  | Self-control |
| `LOC` | Control over one's own life |
| `MON` | Money management |
| `PLN` | Planning |

---

## Live applications

| Application | URL | Purpose |
|---|---|---|
| **Public platform** | [xulqscore.uz](https://xulqscore.uz) | Registration, adaptive assessment, personal cabinet with PDF export |
| **Admin panel** | [admin.xulqscore.uz](https://admin.xulqscore.uz) | KPI dashboard, applicant analytics, integrity review queue, audit log |
| **Partner portal** | [partner.xulqscore.uz](https://partner.xulqscore.uz) | Consent-based score lookup for lenders |

All three are in production, in **Uzbek, Russian and English**.

---

## How consent-based sharing works

A result is never pushed to a lender. The applicant generates a **six-character consent code**
from their cabinet, valid for 24 hours, and hands it to the lender. The lender enters that code
in the partner portal to view the score. Every access is written to an immutable log that the
applicant can see.

```
Applicant → generates code (24h) → gives to lender → lender views score → access logged
```

---

## Architecture

```
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  Public site    │   │  Admin panel    │   │ Partner portal  │
│  xulqscore.uz   │   │ admin.xulq…     │   │ partner.xulq…   │
└────────┬────────┘   └────────┬────────┘   └────────┬────────┘
         │                     │                     │
         └─────────────────────┼─────────────────────┘
                               │
                    ┌──────────▼───────────┐
                    │      Supabase        │
                    │  Postgres + Auth     │
                    │  Row Level Security  │
                    └──────────────────────┘
```

**Scoring runs server-side.** The browser submits only the raw answer log; the score is
computed inside the database by a `SECURITY DEFINER` function and written directly. Clients
have no insert permission on results, so a score cannot be fabricated from the browser.

### Security model

- Row Level Security on every table — users reach only their own records; admins are
  authorised through a `SECURITY DEFINER` role check
- Scoring weights held in a table with **no read policy** — reachable only by the scoring function
- Passwords stored as bcrypt hashes; no plaintext credential is ever committed
- Role separation: `user` · `partner` · `admin` · `super_admin`
- Every administrative action recorded in an append-only audit log
- Consent recorded per signup with policy version, language and timestamp

---

## Integrity layer

Response validity is assessed silently during the test and expressed as a coefficient:

| Signal | Detection |
|---|---|
| Answer-position shuffling | Options are reordered every question, so "always pick A" fails |
| Response speed | Implausibly fast answers reduce the confidence coefficient |
| Straight-lining | Long runs of one screen position are detected |
| Contradiction | Opposing answers within one dimension are counted |
| Over-ideal profiles | Suspiciously perfect answering is routed to human review, never silently penalised |

Flagged assessments go to a reviewer queue rather than being automatically rejected.

---

## Tech stack

| Layer | Technology |
|---|---|
| Frontend | Vanilla HTML/CSS/JS — no build step, no framework |
| Charts | Chart.js |
| Backend | Supabase (PostgreSQL 15, GoTrue auth, PostgREST) |
| Scoring | PL/pgSQL `SECURITY DEFINER` function |
| Hosting | Vercel — three projects from one repository |
| Migrations | GitHub Actions → `psql`, applied automatically on push |

Deliberately dependency-light: the entire client is static and requires no build pipeline,
which keeps the deployment surface small and the load fast on low-end mobile devices.

---

## Repository layout

```
├── index.html              Public platform (assessment engine, cabinet, i18n)
├── admin/index.html        Admin panel (dashboard, analytics, review queue, audit)
├── partner/index.html      Partner portal (consent-code lookup)
├── privacy.html            Privacy policy & data-processing consent (3 languages)
├── migrations/             Sequential SQL migrations — the source of truth for the schema
└── .github/workflows/      CI: applies pending migrations to Supabase on push
```

## Database migrations

Migrations are numbered and applied in order. On every push touching `migrations/`, CI applies
any that have not run yet and records them in a `_migrations` table, so each file executes
exactly once.

```bash
# add a change
migrations/00NN_description.sql
git push          # CI applies it automatically
```

---

## Research basis

The approach follows peer-reviewed evidence:

> Arráiz, I., Bruhn, M., & Stucchi, R. — *"Psychometrics as a Tool to Improve Credit
> Information."* **World Bank Economic Review**, 30(S1), S67.

The study found that psychometric assessment reduced portfolio risk when used as a secondary
screen, and allowed lenders to extend credit to entrepreneurs **without** credit history —
applicants traditional scoring had rejected — without increasing portfolio risk.

## Project status

The platform is built and in production. **Predictive power has not yet been validated against
real repayment outcomes** — that is the explicit objective of the current phase, which is
collecting a real applicant sample for retrospective validation against known lending results.

---

<div align="center">

© 2026 XulqskorAI · All rights reserved

</div>
