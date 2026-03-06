---
description: Run backend code review using the backend-architect agent
---

# Backend Code Review

Delegate to the `backend-architect` agent for a comprehensive backend review.

## Steps

1. Identify files to review:
   ```bash
   git diff --name-only HEAD -- 'src/app/api/**' 'src/lib/supabase/**' 'supabase/**'
   ```
   If no diff, review all recently modified backend files.

2. Spawn the `backend-architect` agent with these files.

3. The agent will check against:
   - **API-001~004**: Versioning, input validation, pagination, separation
   - **SB-001~004**: Client usage, RLS, schema changes, seeds
   - **DATA-001~006**: Access control, Supabase-first, Drizzle ORM boundaries, NextAuth opt-in rules, performance

4. Compile the agent's findings into a structured report.

5. If violations found, suggest specific fixes with file:line references.
