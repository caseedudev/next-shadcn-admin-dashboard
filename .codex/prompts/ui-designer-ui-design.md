---
name: ui-designer-ui-design
description: "UI 페이지 설계 및 구현. 페이지 유형 또는 자연어 설명으로 시작."
argument-hint: "[landing|dashboard|settings|auth|crud|detail|pricing|form] or free-form description"
---

# UI Design Workflow

Execute the full workflow for designing and implementing UI pages.

## Argument Parsing

Analyze user arguments:

- **Type keywords** (landing, dashboard, settings, auth, crud, detail, pricing, form):
  Immediately start the workflow for that type.
- **Natural language description**:
  Analyze the description to determine the appropriate page type and confirm with the user when needed.
- **No arguments**:
  Ask the user what page they want to create.

## Local Reference Files

Read these files directly from the repository as needed:

- `.agents/skills/ui-designer-ui-design-guide/references/component-catalog.md`
- `.agents/skills/ui-designer-ui-design-guide/references/layout-patterns.md`
- `.agents/skills/ui-designer-ui-design-guide/references/page-templates.md`
- `.agents/skills/ui-designer-ui-design-guide/references/qa-templates.md`
- `.agents/skills/ui-designer-ui-design-guide/references/design-principles.md`
- `.agents/skills/ui-designer-ui-design-guide/references/external-resources.md`
- `.agents/skills/ui-designer-ui-design-guide/references/design-concepts.md`
- `.agents/skills/ui-designer-ui-design-guide/references/color-palettes.md`
- `.agents/skills/ui-designer-ui-design-guide/references/font-pairings.md`
- `.agents/skills/ui-designer-ui-design-guide/references/industry-rules.md`
- `.agents/skills/ui-designer-ui-design-guide/references/anti-patterns.md`

Do not assume global skills or sub-agents are available.

## Execution Order

### 1. Project Analysis Check

Check for `.ui-designer/analysis.json`.

- **If it exists**: Load the analysis data.
- **If it does not exist**: Run the same direct repository analysis described by `/ui-designer-ui-analyze`, save the file, then summarize the result.

### 1.5. Design System Check

Check for `.ui-designer/design-system.md` in the project root.

- **If file exists**: Load the design system and present to user:
  > "기존 디자인 시스템을 로드했습니다:
  >   스타일: [style] | 컬러: [palette] | 폰트: [font pairing]
  >
  > 이 설정을 유지할까요?
  >   a) 유지 — Q3/Q3-1/Q3.5/Q3.6 건너뛰고 유형별 질문으로
  >   b) 이 페이지만 다른 스타일 — 기존 시스템과 별도로 설계
  >   c) 전체 변경 — 디자인 시스템을 새로 설정"
- **If file does not exist**: Proceed to Step 2 with full Q&A.

### 2. Interactive Q&A

Load the relevant question set from `qa-templates.md`.

Use this format:

```text
**Q[N]. [question]**

> [why this matters]

★ **Recommendation**: [recommendation + reason]

  a) [option] — [description]
  b) [option] — [description]
  c) [option] — [description]
  d) Custom input
```

Progression order:
1. Common questions (Q1~Q4)
   - Q3 is now a design concept selection flow (category → specific style)
   - Q3-1: Specific style within chosen category
   - Q3.5: Color palette selection (matched to concept + industry)
   - Q3.6: Font pairing selection (matched to concept)
   - If user selected "기존 프로젝트 스타일 유지" in Q3, skip Q3-1/Q3.5/Q3.6
2. Type-specific questions

**Data sources**:
- Resolve the search script in this order:
  1. `.agents/skills/ui-designer-ui-design-guide/scripts/search.py`
  2. `.claude/plugins/local/ui-designer/scripts/search.py`
- If a script exists: `python3 <resolved_search_script> "query" --domain [style|color|font]`
- Fallback: read markdown references directly (`design-concepts.md`, `color-palettes.md`, `font-pairings.md`, `industry-rules.md`)

When the user says "go with recommendations", apply all starred recommendations.

### 2.5. Special Page Detection and External Resource Suggestion

Analyze the page type and request description to determine if it is a special page.

**Special page signals**:
- Complex marketing/landing pages with 5+ heterogeneous sections
- Explicit animation, scroll effect, or parallax requirements
- Strong impact keywords such as "flashy", "impressive", "promotional", "sales"
- Cases where `page-templates.md` is clearly insufficient

If it is a special page, ask whether to research external resources first. When approved, browse the external resources listed in `external-resources.md` and reflect the findings before continuing.

### 3. Design Proposal + Style System + Approval

Generate the design proposal directly after Q&A is complete.

Include:
- **Style System**: design concept, color palette (Primary/Accent hex), font pairing (Display + Body), CDN URL, anti-pattern check summary
- Layout pattern and ASCII skeleton
- Selected component list with shadcn mappings
- Next.js file structure
- Consistency notes with the existing project

**User approval is mandatory.** If the user requests changes, revise and present again.

### 4. Code Generation + Anti-Pattern Check + Vercel Verification

Generate code based on the approved design proposal.

- Follow patterns from `.ui-designer/analysis.json`
- Apply `design-principles.md`
- Apply the chosen design concept's CSS variables, colors, and fonts
- Use `lucide-react` as the default icon library unless the user requested otherwise
- **Anti-Pattern Check**: After code generation, check against `references/anti-patterns.md`. Auto-fix detected patterns where possible. Report results.
- **Vercel Verification**: Verify the generated result against the local design principles and, when needed, the latest Vercel Web Interface Guidelines
- Report combined verification results and a concise change summary

### 5. Design System Save

After code generation is complete, save/update `.ui-designer/design-system.md`:

- **If file does not exist**: Create with the design system template (project info, design concept, color palette, font pairing, CSS variables, applied pages table)
- **If file exists**: Add the new page to the "적용된 페이지" table. Update design decisions only if user chose to change them in Step 1.5
