# Supabase & Data Rules (SB-001~004, DATA-001~006)

Source: `docs/architecture/development-rules.md` Section 7, `docs/architecture/nextjs-best-case-rules.md` Section 6

## SB-001 Client Usage (MUST)

- Server context (cookie-based): `createSupabaseServerClient` from `src/lib/supabase/server.ts`
- Browser context: `createSupabaseBrowserClient` from `src/lib/supabase/client.ts`
- Service role key: server-only routes, minimal scope

```typescript
// Server context
import { createSupabaseServerClient } from '@/lib/supabase/server';
const supabase = await createSupabaseServerClient();

// Browser context
import { createSupabaseBrowserClient } from '@/lib/supabase/client';
const supabase = createSupabaseBrowserClient();
```

## SB-002 Multi-Tenancy Security (MUST)

- Multi-tenant tables: `RLS + FORCE RLS` always enabled.
- App-level guards (proxy/layout) are UX optimization only, NOT the security boundary.

```sql
ALTER TABLE academy_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE academy_enrollments FORCE ROW LEVEL SECURITY;
```

## SB-003 Schema Change Principle (MUST)

- Schema changes are migration-only (never manual DDL in production).
- User reference columns use `auth.users(id)` FK.
- RLS policies use `(select auth.uid())` pattern (NOT bare `auth.uid()`).

```sql
-- Good: Subquery pattern for performance
CREATE POLICY "members_select_own" ON academy_members
  FOR SELECT USING (user_id = (select auth.uid()));

-- Bad: Direct function call (re-evaluated per row)
CREATE POLICY "members_select_own" ON academy_members
  FOR SELECT USING (user_id = auth.uid());
```

## SB-004 Onboarding/Seed Principle (MUST)

- Seed scripts MUST be idempotent (safe for repeated execution).
- Missing prerequisite data triggers fail-fast exception.

```sql
-- Idempotent: ON CONFLICT DO NOTHING
INSERT INTO academies (id, name) VALUES ('fixed-uuid', 'Demo Academy')
ON CONFLICT (id) DO NOTHING;

-- Fail-fast: Missing owner
IF _owner_id IS NULL THEN
  RAISE EXCEPTION 'Owner email % not found in auth.users', _email;
END IF;
```

---

## DATA-001 Single Authority for Access Control (MUST)

Final authority for user data access is Supabase RLS policies. App-level guards are UX-only.

## DATA-002 Supabase-First Path (MUST)

User-facing CRUD uses Supabase server client + RLS. Input via `zod.safeParse`, errors via 400/401/403/500.

## DATA-003 Prisma Usage Boundary (MUST)

Prisma is limited to:
- Internal admin/ops APIs
- Background jobs/batch processing
- Complex reports not dependent on RLS

Public APIs using Prisma directly require ADR documenting the authorization gap.

## DATA-004 NextAuth Usage Boundary (MUST)

- NextAuth only for social login extension (OAuth providers).
- NextAuth sessions do NOT replace Supabase RLS.
- User identifier sync rules must be documented when introduced.

## DATA-005 Schema/Migration Principle (MUST)

- Single source of truth: `supabase/migrations/*.sql`
- User reference columns: `auth.users(id)` FK
- Policy `auth.uid()`: always use `(select auth.uid())` pattern
- Seed: idempotent + fail-fast

## DATA-006 Performance/Operations (SHOULD)

- Index all `WHERE`/`JOIN`/`FK` columns. (`query-missing-indexes`, `schema-foreign-key-indexes`)
- List queries: cursor pagination default. (`data-pagination`)
- Upsert: `INSERT ... ON CONFLICT`. (`data-upsert`)
- High-concurrency: connection pooling assumed. (`conn-pooling`)

## Cross-Reference
- Supabase skill: `supabase-postgres-best-practices` (query-*, security-*, schema-*, data-*)
