---
name: fullstack-review
description: >
  Fullstack code review skill combining frontend and backend checklists.
  Use when reviewing PRs, performing code reviews, running checklists,
  or when "review" keyword is used. Validates against all PERF, COMP,
  UI, API, SB, DATA rules.
---

# Fullstack Review Skill

## Purpose
Comprehensive code review combining all frontend and backend architecture rules for this admin dashboard template.

## Review Process

1. **Identify changed files** via `git diff` or provided file list
2. **Classify changes** into frontend (React/UI) and backend (API/DB/SQL)
3. **Apply relevant checklists** from `references/checklist.md`
4. **Report findings** with rule ID, severity, file:line, and fix suggestion

## Output Format

```
[RULE-ID] [MUST|SHOULD] file:line — Description
  Fix: Suggested correction
```

## Skills to Load
- `frontend-dev` — For PERF/COMP/UI rules
- `backend-dev` — For API/SB/DATA rules

## External Skills to Reference
- `vercel-react-best-practices`
- `vercel-composition-patterns`
- `web-design-guidelines`
- `supabase-postgres-best-practices`

## Checklist
See `references/checklist.md` for the complete unified checklist.
