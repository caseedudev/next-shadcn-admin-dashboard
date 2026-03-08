---
name: ui-design-guide
description: "UI 페이지 설계 및 구현 가이드. 67개 디자인 컨셉, 116개 컬러 팔레트, 57개 폰트 페어링, 96개 산업 추론 규칙, 30개 안티패턴 감지. Actions: plan, build, create, design, implement, review, fix, improve, optimize, enhance, refactor UI/UX code. Projects: website, landing page, dashboard, admin panel, settings, auth, CRUD, detail, pricing, form. Elements: button, modal, navbar, sidebar, card, table, form, chart, hero, footer. Styles: glassmorphism, brutalism, neumorphism, minimalism, bento grid, dark mode, responsive. Topics: color palette, font pairing, accessibility, animation, layout, typography, spacing, design concept, anti-pattern. 페이지 만들어줘, UI 수정, 레이아웃 변경, 섹션 추가, 화면 구성, 대시보드, 로그인, 폼 추가, 차트 추가, 디자인 컨셉, 컬러 추천, 폰트 추천."
---

# UI Design Guide

A guide for designing and implementing UI pages based on project analysis data and component catalogs.
Provides concrete designs tailored to the current project's structure/style/conventions, not abstract recommendations.

## Design Philosophy: No Generic AI Aesthetics

> Anthropic frontend-design 핵심 철학: "Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity."

이 플러그인은 **"AI가 만든 티가 나는" 제네릭 디자인을 의식적으로 거부**한다.

### NEVER (절대 하지 말 것)
- 맥락 없는 **보라색 그래디언트** (가장 흔한 AI 슬롭)
- 기본 시스템 폰트(**Inter, Roboto, Arial**)로만 구성
- 모든 페이지에 **좌우 대칭 Hero** 반복
- 의미 없는 `transition-all`과 과도한 애니메이션
- 하드코딩된 컬러 (`bg-white`, `text-black`)

### ALWAYS (반드시 할 것)
- **디자인 컨셉을 먼저 선택**하고, 그 컨셉의 CSS 변수/특성을 일관되게 적용
- **산업과 맥락에 맞는** 컬러 팔레트와 폰트 페어링 사용
- **비대칭 레이아웃**, 의외의 여백, 개성 있는 타이포그래피로 차별화
- 배경에 **분위기와 깊이** 부여 (그래디언트 메시, 노이즈 텍스처, 기하학 패턴 등)
- 선택한 미학적 방향에 **대담하게 커밋** — 중간에서 타협하지 않기

### 핵심 질문
코드 생성 전 스스로에게 물어볼 것:
1. "이 디자인에서 사람들이 기억할 한 가지는 무엇인가?"
2. "AI가 아닌 시니어 디자이너가 만든 것처럼 보이는가?"
3. "선택한 디자인 컨셉이 모든 컴포넌트에 일관되게 적용되었는가?"

## Workflow Overview

Proceeds in 6 steps. No step is skipped.

```
[Step 0: Project Analysis] → [Step 0.5: Design System Check] → [Step 1: Requirements Q&A] → [Step 2: Design Proposal] → [Step 3: Code Generation + Anti-Pattern Check] → [Step 4: Verification] → [Step 5: Design System Save]
```

## Step 0: Project Analysis Check

Check for the `.ui-designer/analysis.json` file in the project root.

**If file exists**: Load the analysis data and proceed to Step 1.

**If file does not exist**: Analyze the repository directly using the same schema as the installed UI analyze command, save `.ui-designer/analysis.json`, summarize the result, then proceed to Step 0.5.

If the user wants a standalone analysis run instead of continuing the design workflow, point them to the environment-specific command:
- Codex: `/ui-designer-ui-analyze`
- Claude Code: `/ui-designer:ui-analyze`

Items to check from analysis data:
- `project.framework`, `project.uiLibrary`, `project.styling` — Tech stack
- `components.shadcn`, `components.custom` — Components in use
- `layout.pattern` — Existing layout structure
- `style.colors`, `style.borderRadius`, `style.darkMode` — Style conventions
- `patterns` — Recurring UI patterns

## Step 0.5: Design System Check

Check for `.ui-designer/design-system.md` in the project root.

**If file exists**: Load the design system and present to user:
> "기존 디자인 시스템을 로드했습니다:
>   스타일: [style] | 컬러: [palette] | 폰트: [font pairing]
>
> 이 설정을 유지할까요?
>   a) 유지 — Q3/Q3-1/Q3.5/Q3.6 건너뛰고 유형별 질문으로
>   b) 이 페이지만 다른 스타일 — 기존 시스템과 별도로 설계
>   c) 전체 변경 — 디자인 시스템을 새로 설정"

**If file does not exist**: Proceed to Step 1 with full Q&A.

## Step 1: Requirements Gathering (Interactive Q&A)

### 1.1 Page Type Identification

Identify the page type from the user's request. Use the quick reference table in `references/page-templates.md`.

| Keyword | Type |
|---------|------|
| landing, homepage, hero, marketing | Landing |
| dashboard, overview, status | Dashboard |
| settings, preferences, configuration | Settings |
| login, signup, auth | Auth |
| list, board, CRUD | CRUD List |
| detail, profile | Detail |
| pricing, plans, rates | Pricing |
| form, input, registration | Form |

If the type is unclear, confirm with the user.

### 1.2 Q&A Progression

Load the question list for the page type from `references/qa-templates.md`.

**Question format rules** (must follow):
```
**Q[N]. [question]**

> [1-2 line explanation of why this question matters]

★ **Recommendation**: [analysis data-based recommendation. 1 line reason]

  a) [option] — [brief description]
  b) [option] — [brief description]
  c) [option] — [brief description]
  d) Custom input
```

**Progression order**:
1. Common questions (Q1~Q4: target, layout relationship, design concept, assets)
   - Q3 is now a 2-step design concept selection: category (Q3) → specific style (Q3-1)
   - Q3.5: Color palette selection (matched to chosen concept + industry)
   - Q3.6: Font pairing selection (matched to chosen concept)
   - If user selects "기존 프로젝트 스타일 유지" in Q3, skip Q3-1/Q3.5/Q3.6
2. Type-specific questions

**Data source for recommendations**:
- Resolve the search script in this order:
  1. `.agents/skills/ui-designer-ui-design-guide/scripts/search.py`
  2. `.claude/plugins/local/ui-designer/scripts/search.py`
- If a script exists: use `python3 <resolved_search_script> "query" --domain [style|color|font]`
- Fallback: read markdown references directly (`design-concepts.md`, `color-palettes.md`, `font-pairings.md`, `industry-rules.md`)

**"Go with recommendations" handling**:
- If the user responds with "go with recommendations" or "decide for me", apply all ★ recommendations at once.
- If the user answers "recommend" to an individual question, apply that question's ★ recommendation.

**★ Recommendation writing rules**:
- Reflect existing project data from analysis.json (existing styles, colors, patterns)
- Combine industry best practices with practical experience
- Explain the recommendation reason concisely in 1 line

## Step 2: Design Proposal

Present a concrete design proposal after all Q&A is complete.

### 2.1 Component Selection

Select suitable components from `references/component-catalog.md`.

Check the following:
- Match `use-when` conditions with user requirements
- Verify no `avoid-when` conditions apply
- Compose natural combinations using `pairs-with`
- Confirm actual implementation components via `shadcn-mapping`

### 2.2 Layout Design

Select a suitable layout pattern from `references/layout-patterns.md`.
Reference the standard configuration for the page type from `references/page-templates.md`.

### 2.3 Design Proposal Format

```
📋 [Page Name] Design Proposal

Style System:
 • Design Concept: [style name] ([category])
 • Color Palette: [palette name] (Primary: #hex | Accent: #hex)
 • Font Pairing: [pairing name] (Display: [font] + Body: [font])
 • CDN: [Google Fonts URL]
 • Anti-pattern Check: [pass/warning summary]

Layout: [pattern name] ([description])
┌─────────────────────────┐
│ [ASCII skeleton]          │
└─────────────────────────┘

Components:
 • [component name] — [role] (shadcn: [mapping])
 • ...

File structure:
 • [path/filename] — [role]
 • ...

Style:
 • Maintain existing project style: [specific items]
 • Additional style: [if needed]
```

After presenting the design proposal, **user approval is mandatory**. If modifications are requested, reflect them and re-present.

## Step 3: Code Generation + Anti-Pattern Check

Generate code after user approval.

### 3.1 Generation Rules

- Follow existing patterns/conventions from analysis.json (import paths, naming, directory structure)
- Apply static principles from `references/design-principles.md`
- Apply the chosen design concept's CSS variables, colors, and font from the Style System
- Prioritize shadcn components already in use in the existing project
- If new shadcn components are needed, provide installation commands

### 3.2 Anti-Pattern Check

After code generation, check against `references/anti-patterns.md`:

1. Scan generated code for known anti-patterns (30 total: color, typography, layout, animation, general)
2. Auto-fix detected patterns where possible (e.g., replace hardcoded colors with CSS variables)
3. Report anti-pattern check results:
   ```
   [안티패턴 검사]
     🔴 generic-purple-gradient → bg-primary 단색으로 수정 완료
     ✅ 하드코딩 컬러 없음
     ✅ 제목 계층 정상
     🟡 symmetric-hero → 비대칭 레이아웃 고려 권장
   ```

### 3.3 Code Verification

After anti-pattern check, verify by referencing Part 2 of `references/design-principles.md`:

1. Fetch the latest Vercel Web Interface Guidelines with the available web-fetching tool
   - URL: `https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md`
2. Compare generated code against the guidelines
3. Auto-fix any violations
4. Report verification results alongside anti-pattern results:
   ```
   ✅ Accessibility: Semantic HTML, alt attributes included
   ✅ Keyboard: Logical Tab order
   ⚠️ Fixed: [fix details]
   ```

### 3.4 Result Presentation

- Summary of generated files and changes
- Guidance on packages/components that need to be newly installed
- Additional considerations (data integration, APIs, etc.)

## Step 4: Verification

Final quality check combining all verification results:
- Design principles checklist (Part 1)
- Anti-pattern check results (Part 1.5)
- Vercel Web Interface Guidelines (Part 2)

Present a unified verification report to the user.

## Step 5: Design System Save

After code generation is complete, persist design decisions using the search engine CLI:

```bash
# Master design system (project-wide defaults)
python3 <search_script> "<industry query>" --design-system --persist -p "<project name>"

# Page-specific override (inherits Master, overrides specific values)
python3 <search_script> "<industry query>" --design-system --persist -p "<project name>" --page "<page name>"
```

**Hierarchical storage**:
- **Master** → `.ui-designer/design-system.md` (project-wide defaults)
- **Page override** → `.ui-designer/pages/{page}.md` (page-specific customizations)
- Page files inherit Master values; only store differences

**If search script is unavailable**, save/update `.ui-designer/design-system.md` manually:

**If file does not exist**: Create with template:

```markdown
# Design System

## 프로젝트 정보
- 프로젝트: [project name]
- 생성일: [date]
- 마지막 수정: [date]

## 디자인 컨셉
- 카테고리: [category]
- 스타일: [style name]
- 설명: [1-line description]

## 컬러 팔레트
- 팔레트명: [palette name]
- Primary: [#hex]
- Accent: [#hex]
- Background: [#hex]
- Foreground: [#hex]
- Mood: [mood keywords]

## 폰트 페어링
- 페어링명: [pairing name]
- Display: [font name] ([weight])
- Body: [font name] ([weight])
- CDN: [Google Fonts URL]

## CSS 변수
\`\`\`css
:root {
  /* colors from chosen palette */
}
.dark {
  /* dark mode colors */
}
\`\`\`

## 적용된 페이지
| 페이지 | 유형 | 적용일 | 비고 |
|--------|------|--------|------|
| [page] | [type] | [date] | [notes] |
```

**If file exists**: Update:
- Add the new page to the "적용된 페이지" table
- Update design decisions only if user chose to change them in Step 0.5

## Reference Documents

### Reference Files

Refer to the following documents as needed during the design process:

- **`references/component-catalog.md`** — Decision guide for 58 component types. Check use-when/avoid-when/pairs-with/shadcn-mapping when selecting components.
- **`references/layout-patterns.md`** — Grids, responsive design, section placement, 6 layout patterns, spacing system. Reference during layout design.
- **`references/page-templates.md`** — Standard configurations for 8 page types. Section order, ASCII skeletons, shadcn mappings, Next.js file structure.
- **`references/qa-templates.md`** — Interactive question templates per page type. Must follow this format during Q&A.
- **`references/design-principles.md`** — Visual hierarchy, consistency, responsive, color, typography, interaction principles + Anti-pattern prevention + Vercel Guidelines verification.
- **`references/external-resources.md`** — Icon policy (Lucide default), external resource list. Reference for icon selection.
- **`references/design-concepts.md`** — 67 design concepts across 5 categories (Modern, Classic, Bold, Soft, Specialized). Style definitions, CSS variables, and use-when conditions.
- **`references/color-palettes.md`** — 116 color palettes with Light/Dark mode CSS variables. Industry and mood matching.
- **`references/font-pairings.md`** — 57 font pairings (Display + Body). Google Fonts CDN links and style matching.
- **`references/industry-rules.md`** — 96 industry inference rules. Maps industries to recommended styles, colors, and fonts.
- **`references/anti-patterns.md`** — 30 generic AI anti-patterns to detect and fix. Color, typography, layout, animation, and general categories.

### Project Analysis Data

- **`.ui-designer/analysis.json`** — Analysis results of the current project's routes, components, layout, style, and patterns.

## Core Principles

1. **Project context first**: Concrete recommendations based on analysis.json, not abstract suggestions
2. **Eliminate ambiguity**: Resolve all uncertainties through Q&A before designing
3. **Execute after approval**: Always show the design proposal to the user and get approval before code generation
4. **Maintain consistency**: Stay consistent with the existing project's styles/patterns/conventions
5. **Verify before submission**: Verify generated code against design principles and Web Interface Guidelines
6. **Lucide icons first**: Use `lucide-react` as the default icon library unless specifically requested otherwise. Refer to icon policy in `references/external-resources.md`.
