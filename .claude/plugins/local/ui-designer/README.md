# UI Designer Plugin

UI 페이지 설계 및 구현을 위한 Claude Code / Codex 플러그인.
프로젝트를 분석하고, 컴포넌트를 추천하고, 레이아웃을 설계하고, 코드를 생성한다.

> 아래 슬래시 명령 예시는 Codex 기준이다. Claude Code에서는 같은 명령을 `/ui-designer:...` 형태로 사용한다.

## 핵심 특징

- **프로젝트 맥락 인식**: 기존 코드를 분석하여 스타일/패턴에 맞는 구체적 추천
- **인터랙티브 Q&A**: 질문 + 설명 + 추천으로 모호함 완전 제거
- **하이브리드 워크플로우**: 자동 감지 (스킬) + 명시적 호출 (커맨드)
- **외부 리소스 리서치**: 특수 페이지 감지 시 Vercel Templates, shadcnblocks 등 자동 탐색
- **batchtool 컴포넌트 발굴**: shadcn.batchtool.com에서 확장 컴포넌트 선택적 탐색
- **검증 포함**: Vercel Web Interface Guidelines로 생성 코드 자동 검증

---

## 설치

### Claude Code

```bash
bash .claude/plugins/local/ui-designer/install.sh
```

설치 스크립트가 `.claude/` 디렉토리에 심볼릭 링크를 생성한다:
- `commands/ui-designer/` — 슬래시 커맨드 (3개)
- `skills/ui-designer-*` — 자동 트리거 스킬 (3개)
- `agents/` — 서브 에이전트 (3개)

설치 후 Claude Code를 재시작하면 적용된다.

### Antigravity (선택적)

```bash
bash .claude/plugins/local/ui-designer/install-antigravity.sh
```

프로젝트 `.github/skills/`에 스킬 3개 설치.

### Codex (선택적)

```bash
bash .claude/plugins/local/ui-designer/install-codex.sh
CODEX_HOME="$PWD/.codex" codex
```

프로젝트 로컬 `.codex/prompts/`에 커맨드 3개, `.agents/skills/`에 스킬 3개를 설치한다.
전역 `~/.codex`, `~/.agents`는 건드리지 않는다.
글로벌 `~/.codex/auth.json`이 있으면 로컬 `.codex/auth.json`으로 자동 연결한다.

### 제거

```bash
rm -rf .claude/commands/ui-designer
rm -f .claude/skills/ui-designer-*
rm -f .claude/agents/{ui-analyzer,ui-consultant,ui-researcher}.md
rm -f .codex/prompts/ui-designer-*.md
rm -rf .agents/skills/ui-designer-*
```

---

## 빠른 시작

### 1단계: 프로젝트 분석

```
/ui-designer-ui-analyze
```

프로젝트의 라우트, 컴포넌트, 레이아웃, 스타일을 스캔하고 `.ui-designer/analysis.json`에 저장한다.

### 2단계: UI 설계

```
/ui-designer-ui-design landing
/ui-designer-ui-design dashboard
/ui-designer-ui-design "학원 SaaS Hero 섹션"
```

페이지 유형을 지정하거나 자유롭게 설명하면 인터랙티브 Q&A → 설계안 → 코드 생성 순서로 진행한다.
복잡한 랜딩·마케팅 페이지 등 특수 페이지가 감지되면 자동으로 외부 리소스 리서치를 제안한다.

### 2.5단계: 외부 리소스 리서치 (선택적)

```
/ui-designer-ui-research template   — Vercel Templates, shadcnblocks 등 탐색
/ui-designer-ui-research component  — batchtool 확장 컴포넌트 탐색 (승인 후 실행)
/ui-designer-ui-research all        — 템플릿 + 컴포넌트 전체 탐색
```

### 3단계: 자동 감지

일반 대화에서 "로그인 페이지 만들어줘", "대시보드에 차트 추가해줘" 등 UI 작업을 요청하면 스킬이 자동으로 활성화된다.

---

## 슬래시 커맨드

### `/ui-designer-ui-design [type|description]`

UI 페이지를 설계하고 구현하는 전체 워크플로우를 실행한다.

| 인자 | 동작 |
|------|------|
| 페이지 유형 키워드 | 해당 유형의 워크플로우를 즉시 시작 |
| 자연어 설명 | 설명을 분석하여 적합한 페이지 유형 판별 후 확인 |
| 인자 없음 | 대화형으로 질문 |

**사용 예시:**

```
> /ui-designer-ui-design dashboard

프로젝트 분석 데이터를 로드합니다...

**Q1. 이 대시보드의 주요 타겟 사용자는?**
> 학원 관리자가 수강생/매출 현황을 모니터링

★ **추천**: KPI 카드 + 차트 + 최근 활동 테이블 조합
  a) 미니멀 (KPI 카드만)
  b) 표준 (KPI + 차트 + 테이블) ← 추천
  c) 풀 대시보드 (위젯 그리드)
  d) 직접 입력
```

### `/ui-designer-ui-research [template|component|all]`

외부 UI 리소스를 리서치하여 프로젝트에 맞는 템플릿, 블록, 컴포넌트를 추천한다.

| 인자 | 동작 |
|------|------|
| `template` | Vercel Templates, shadcnblocks.com, ui.shadcn.com/blocks, shadcnui-blocks.com 탐색 |
| `component` | shadcn.batchtool.com 확장 컴포넌트 탐색 (사용자 승인 필요) |
| `all` | 템플릿 + 컴포넌트 순서로 실행 |
| 없음 | 대화형으로 리서치 유형 선택 |

### `/ui-designer-ui-analyze [--refresh]`

현재 프로젝트의 UI 구조를 분석하고 `.ui-designer/analysis.json`에 저장한다.

| 인자 | 동작 |
|------|------|
| 없음 | 기존 분석이 있으면 결과 표시, 없으면 새로 분석 |
| `--refresh` | 기존 분석 무시하고 재분석 |

**분석 항목:**

| 항목 | 내용 |
|------|------|
| 프로젝트 기본 정보 | 프레임워크, UI 라이브러리, 스타일링 도구 |
| 라우트 맵 | 모든 라우트 경로 + 페이지 유형 판별 |
| 컴포넌트 인벤토리 | shadcn/ui 설치 현황 + 커스텀 컴포넌트 + 사용 빈도 |
| 레이아웃 패턴 | 사이드바/헤더/콘텐츠 구조, 사이드바 너비/접기 여부 |
| 스타일 컨벤션 | CSS 변수, 다크 모드, border-radius, 간격 패턴 |
| 반복 UI 패턴 | 데이터 표시, 폼, 네비게이션 패턴 |

**출력 예시:**
```
프로젝트 분석 완료

기술 스택: Next.js + shadcn/ui + Tailwind CSS
라우트: 12개 페이지 발견
shadcn 컴포넌트: 24개 설치됨
레이아웃: sidebar-header-content (접을 수 있는 사이드바)
스타일: 다크 모드 지원, rounded-lg, hsl 컬러 시스템

분석 결과가 .ui-designer/analysis.json에 저장되었습니다.
이제 /ui-designer-ui-design 으로 UI 설계를 시작할 수 있습니다.
```

---

## 지원 페이지 유형

| 유형 | 키워드 | 용도 |
|------|--------|------|
| Landing | landing, 랜딩, 홈페이지 | 마케팅, 서비스 소개 |
| Dashboard | dashboard, 대시보드 | 데이터 요약, 모니터링 |
| Settings | settings, 설정 | 사용자/시스템 설정 |
| Auth | auth, login, 로그인 | 인증 (로그인/회원가입) |
| CRUD List | crud, 목록, 게시판 | 데이터 목록 조회 |
| Detail | detail, 상세 | 단일 항목 상세 보기 |
| Pricing | pricing, 요금 | 요금제 비교/선택 |
| Form | form, 폼, 입력 | 데이터 입력/생성 |

---

## 워크플로우

```
[0단계] 프로젝트 분석
  → 라우트, 컴포넌트, 레이아웃, 스타일 스캔
  → .ui-designer/analysis.json 저장

[0.5단계] 특수 페이지 감지 (자동)
  → 복잡한 랜딩/마케팅/애니메이션 요청 시 감지
  → 외부 리소스 리서치 제안 (ui-template-scout)
  → 사용자 승인 시 Vercel Templates, shadcnblocks 등 탐색

[1단계] 요구사항 수집
  → 페이지 유형 판별
  → 인터랙티브 Q&A (질문 + 설명 + 추천 + 선택지)
  → "추천대로" 응답 시 일괄 적용

[2단계] 설계 제안
  → 분석 데이터 + Q&A 기반 설계안 생성
  → ASCII 레이아웃 + 컴포넌트 목록 + 파일 구조
  → batchtool 리서치 필요 시 사용자 승인 후 탐색 (ui-component-scout)
  → 사용자 승인

[3단계] 코드 생성
  → 기존 프로젝트 패턴/컨벤션 준수
  → 아이콘: lucide-react 기본 사용
  → Vercel Web Interface Guidelines 검증
  → 결과 보고
```

---

## 스킬

### `ui-designer-ui-design-guide`

UI 관련 작업 시 자동으로 트리거되는 컨텍스트 스킬.

**트리거 키워드:** "create a page", "make a UI", "design a layout", "페이지 만들어줘", "UI 수정", "레이아웃 변경", "섹션 추가", "화면 구성", "대시보드 만들어줘", "로그인 페이지 만들어줘", "폼 추가해줘"

**동작:** 프로젝트 맥락을 인식하여 컴포넌트 추천, 레이아웃 설계, 코드 생성을 인터랙티브 Q&A로 진행

### `ui-designer-ui-template-scout`

특수 페이지 키워드 감지 시 자동 트리거. 외부 템플릿/블록 사이트를 리서치하여 적합한 리소스를 추천한다.

**트리거 조건:** 복잡한 마케팅 랜딩 페이지, 애니메이션/인터랙션 요청, "화려하게"·"인상적으로" 등 임팩트 키워드, 5개+ 이질적 섹션 요구

**리서치 대상:** ui.shadcn.com/blocks → shadcnblocks.com → shadcnui-blocks.com → vercel.com/templates (우선순위 순)

### `ui-designer-ui-component-scout`

**자동 트리거 없음.** 명시적 커맨드(`/ui-designer-ui-research component`) 또는 ui-designer 연동(사용자 승인 후)에만 실행.

**리서치 대상:** shadcn.batchtool.com (shadcn/ui 확장 컴포넌트)

### 지식 베이스

`skills/ui-design-guide/references/` 디렉토리의 마크다운 문서가 핵심 지식이다.

| 파일 | 내용 |
|------|------|
| `component-catalog.md` | 58종 컴포넌트 의사결정 가이드 (use-when, avoid-when, pairs-with, shadcn 매핑) |
| `layout-patterns.md` | 그리드, 반응형, 6종 레이아웃 패턴, 간격 체계 |
| `page-templates.md` | 8종 페이지 유형별 표준 구성, ASCII 스켈레톤 |
| `qa-templates.md` | 페이지 유형별 인터랙티브 질문 템플릿 |
| `design-principles.md` | 디자인 원칙 + Vercel Guidelines 검증 |
| `external-resources.md` | 아이콘 정책(Lucide 기본), 외부 리소스 목록, 특수 페이지 판별 기준 |

---

## 에이전트

| 에이전트 | 역할 | 호출 시점 |
|---------|------|----------|
| `ui-analyzer` | 프로젝트 UI 구조 분석 | `/ui-designer-ui-analyze` 실행 시 |
| `ui-consultant` | 설계안 생성 및 컨설팅 | `/ui-designer-ui-design` 설계 단계에서 |
| `ui-researcher` | 외부 리소스 WebFetch 리서치 (TEMPLATE/COMPONENT 두 모드) | `ui-template-scout`, `ui-component-scout` 스킬이 내부적으로 호출 |

Codex에서는 위 에이전트를 별도로 설치하지 않으며, 커맨드가 분석/설계/리서치를 직접 수행한다.

---

## 다른 AI 도구에서 사용하기

references/ 디렉토리의 마크다운 문서는 도구 독립적이므로 어떤 AI 도구에서든 참조할 수 있다.

### Codex CLI

프로젝트의 `AGENTS.md`에 다음을 추가한다:

```markdown
## UI Design Guidelines

UI 페이지를 생성하거나 레이아웃을 구성할 때 반드시 다음 문서를 참조하세요:

- 컴포넌트 선택: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/component-catalog.md
- 레이아웃 패턴: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/layout-patterns.md
- 페이지 템플릿: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/page-templates.md
- 질문 템플릿: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/qa-templates.md
- 디자인 원칙: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/design-principles.md

프로젝트 분석 데이터: .ui-designer/analysis.json (없으면 먼저 프로젝트를 분석하세요)
```

### Antigravity / 기타 AI 도구

references/ 문서를 컨텍스트로 로드한다:

```bash
# 방법 1: 프로젝트 루트에 심볼릭 링크
ln -s .claude/plugins/local/ui-designer/skills/ui-design-guide/references docs/ui-design-guide

# 방법 2: 각 도구의 컨텍스트 설정에서 직접 경로 지정
```

---

## 디렉토리 구조

```
ui-designer/
├── .claude-plugin/
│   └── plugin.json              # 플러그인 메타데이터
├── install.sh                   # 로컬 설치 스크립트
├── commands/
│   ├── ui-design.md             # /ui-designer-ui-design
│   ├── ui-analyze.md            # /ui-designer-ui-analyze
│   └── ui-research.md           # /ui-designer-ui-research
├── skills/
│   ├── ui-design-guide/         # ui-designer-ui-design-guide (자동 트리거)
│   │   ├── SKILL.md
│   │   └── references/
│   │       ├── component-catalog.md
│   │       ├── layout-patterns.md
│   │       ├── page-templates.md
│   │       ├── qa-templates.md
│   │       ├── design-principles.md
│   │       └── external-resources.md  # 아이콘 정책, 외부 리소스 목록
│   ├── ui-template-scout/       # ui-designer-ui-template-scout (특수 페이지 감지 시 자동 트리거)
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── template-sites.md
│   └── ui-component-scout/      # ui-designer-ui-component-scout (자동 트리거 없음)
│       ├── SKILL.md
│       └── references/
│           └── batchtool-guide.md
├── agents/
│   ├── ui-analyzer.md           # 프로젝트 분석 에이전트
│   ├── ui-consultant.md         # UI 설계 컨설턴트 에이전트
│   └── ui-researcher.md         # 외부 리소스 WebFetch 리서치 에이전트
├── hooks/
│   └── hooks.json
└── README.md                    # 이 문서
```

---

## 기술 스택

이 플러그인은 **Next.js + shadcn/ui + Tailwind CSS** 환경에 최적화되어 있다.
