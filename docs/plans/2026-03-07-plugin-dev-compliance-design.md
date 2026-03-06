# Plugin-Dev 공식 규격 준수 보완 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** dashboard-template-plugin을 공식 plugin-dev 규격에 맞게 보완

**Architecture:** Agent frontmatter 보완 → Skill description 보완 → Skill 본문/version → Command name 필드

**Tech Stack:** Claude Code Plugin (Markdown YAML frontmatter)

---

## Phase 1: Critical Fix

### Task 1: Agent frontmatter 보완 — frontend-architect.md

**Files:** Modify: `dashboard-template-plugin/agents/frontend-architect.md`

- `color: cyan` 추가
- `tools: Read, Grep, Glob, Bash` → `tools: ["Read", "Grep", "Glob", "Bash"]`
- `description`에 `<example>` 블록 2-3개 추가
- 시스템 프롬프트에 스킬 로드 지시 보강

### Task 2: Agent frontmatter 보완 — backend-architect.md

**Files:** Modify: `dashboard-template-plugin/agents/backend-architect.md`

- `color: yellow` 추가
- `tools` 배열 포맷 전환
- `description`에 `<example>` 블록 추가

### Task 3: Agent frontmatter 보완 — fullstack-dev.md

**Files:** Modify: `dashboard-template-plugin/agents/fullstack-dev.md`

- `color: green` 추가
- `description`에 `<example>` 블록 추가

### Task 4: Skill description 보완 — 4개 파일

**Files:**
- `dashboard-template-plugin/skills/frontend-dev/SKILL.md`
- `dashboard-template-plugin/skills/backend-dev/SKILL.md`
- `dashboard-template-plugin/skills/fullstack-review/SKILL.md`
- `dashboard-template-plugin/skills/project-init/SKILL.md`

- 3인칭 전환 + 구체적 트리거 문구 추가

### Task 5: Phase 1 커밋

## Phase 2: Moderate Fix

### Task 6: Skill version 필드 + 본문 문체 정리 (4개)

### Task 7: Command name 필드 일관성 (7개)

### Task 8: Phase 2 커밋
