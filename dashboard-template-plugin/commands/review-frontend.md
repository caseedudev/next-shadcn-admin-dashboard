---
description: Run frontend code review using the frontend-architect agent
---

# Frontend Code Review

Delegate to the `frontend-architect` agent for a comprehensive frontend review.

## Steps

1. Identify files to review:
   ```bash
   git diff --name-only HEAD -- 'src/app/**/*.tsx' 'src/app/**/*.ts' 'src/components/**' 'src/features/**'
   ```
   If no diff, review all recently modified frontend files.

2. Spawn the `frontend-architect` agent with these files.

3. The agent will check against:
   - **PERF-001~004**: Waterfalls, RSC boundaries, server fetch, bundle size
   - **COMP-001~004**: Boolean props, compound components, state hiding, React 19
   - **UI-001~004**: Accessibility, form quality, animations, content/layout
   - **ARCH-001~002**: Layer boundaries, dependency direction

4. Compile the agent's findings into a structured report.

5. If violations found, suggest specific fixes with file:line references.
