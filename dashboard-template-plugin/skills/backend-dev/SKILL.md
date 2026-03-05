---
name: backend-dev
description: >
  Backend development skill for Supabase + Next.js API routes.
  Use when working on API routes, route handlers, Supabase, migrations,
  RLS policies, database schema, SQL, seed scripts, zod validation,
  or server-side data access. Enforces API, SB, DATA rules automatically.
---

# Backend Development Skill

## Purpose
Enforce backend architecture rules when working with API routes, Supabase, database schema, and server-side logic.

## External Skills to Reference
- `supabase-postgres-best-practices` — Query performance, connection management, security/RLS, schema design, data access patterns

## Project-Specific Rules

### API Rules (API-001 ~ API-004)
See `references/api-rules.md` for full details.
- API-001: All APIs under `src/app/api/v1/**/route.ts` (MUST)
- API-002: Input via `zod.safeParse`, status codes 400/401/403/500 (MUST)
- API-003: List APIs use cursor pagination (`id > cursor`, `limit + 1`) (MUST)
- API-004: Route Handlers are thin adapters; delegate to `features`/`lib` (MUST)

### Supabase Rules (SB-001 ~ SB-004)
See `references/supabase-rules.md` for full details.
- SB-001: Server context uses `createSupabaseServerClient`, browser uses `createSupabaseBrowserClient` (MUST)
- SB-002: Multi-tenant tables require RLS + FORCE RLS (MUST)
- SB-003: Schema changes are migration-only; `auth.uid()` -> `(select auth.uid())` (MUST)
- SB-004: Seed scripts are idempotent; fail-fast on missing prerequisites (MUST)

### Data Rules (DATA-001 ~ DATA-006)
See `references/supabase-rules.md` for full details.
- DATA-001: Final authority for data access is Supabase RLS (MUST)
- DATA-002: User CRUD goes through Supabase server client + RLS (MUST)
- DATA-003: Prisma limited to internal ops/batch/complex reports (MUST)
- DATA-004: NextAuth only for social login extension, never replaces RLS (MUST)
- DATA-005: Schema source of truth is `supabase/migrations/*.sql` (MUST)
- DATA-006: Index WHERE/JOIN/FK columns; cursor pagination; upsert via ON CONFLICT (SHOULD)

### Migration Rules
See `references/migration-rules.md` for full details.

## Tech Stack
- Next.js 16 Route Handlers (`/api/v1/**`)
- Supabase Auth + Postgres + RLS
- zod (input validation)
- TanStack Query (client-side server state)

## Observability Rules (OBS-001 ~ OBS-002)
- OBS-001: Event names use domain prefix (`academy.created`, `enrollment.added`); no PII (MUST)
- OBS-002: PostHog script lazy-loaded; critical conversion events logged server-side too (MUST)

## Testing Rules (QA-001 ~ QA-003)
- QA-001: New rules/structures/policies must have corresponding contract tests (MUST)
- QA-002: PR gate: `npm run check && npm run test && npm run build` must pass (MUST)
- QA-003: Auth/permission/DB policy changes always require docs + tests (MUST)

## Architecture Boundaries
- Route Handlers: thin adapters only (validate + auth + delegate)
- Domain logic: `src/features/<domain>/`
- Infrastructure: `src/lib/supabase/` (server.ts, client.ts, env.ts)
- Dependency direction: `app -> features -> lib`
