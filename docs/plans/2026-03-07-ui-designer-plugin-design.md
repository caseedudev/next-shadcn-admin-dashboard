# ui-designer 플러그인 설계 문서

## 개요

UI 페이지 설계 및 구현을 위한 Claude Code 플러그인.
프로젝트를 분석하고, 컴포넌트를 추천하고, 레이아웃을 설계하고, 코드를 생성한다.

## 핵심 결정 사항

| 항목 | 결정 |
|------|------|
| 이름 | `ui-designer` |
| 접근 방식 | 하이브리드 (추천 → 승인 → 코드 생성) |
| 범위 | 마케팅 + 앱 UI 전체 |
| 크로스 플랫폼 | 지식 공유형 (references/ 마크다운) |
| 입력 방식 | 자연어 + 페이지 유형 지정 |
| 기술 스택 | Next.js + shadcn/ui + Tailwind CSS 고정 |
| 핵심 차별점 | 프로젝트 분석 → 인터랙티브 Q&A(추천 포함) → 맥락 기반 구체적 설계 |

## 플러그인 구조

```
ui-designer/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── ui-design-guide/
│       ├── SKILL.md
│       └── references/
│           ├── component-catalog.md
│           ├── layout-patterns.md
│           ├── page-templates.md
│           ├── qa-templates.md
│           └── design-principles.md
├── commands/
│   ├── ui-design.md
│   └── ui-analyze.md
├── agents/
│   ├── ui-consultant.md
│   └── ui-analyzer.md
└── README.md
```

## 워크플로우

```
[0단계: 프로젝트 분석]
프로젝트 스캔 → 기존 페이지/컴포넌트/레이아웃/스타일 분석
분석 결과를 .ui-designer/analysis.json에 저장
    │
    ▼
[1단계: 요구사항 수집 (인터랙티브 Q&A)]
사용자 요청 수신
    → 모호한 부분 식별
    → 질문 + 설명 + 추천/예시 답변 제시
    → "추천대로" 응답 시 전체 추천 일괄 적용
    → 모든 모호함 해소될 때까지 반복
    │
    ▼
[2단계: 설계 제안]
분석 데이터 + 수집된 요구사항 기반
    → 기존 프로젝트 스타일과 일관된 컴포넌트 추천
    → 구체적 레이아웃 구성안 (섹션별 배치, 간격, 크기)
    → 추천 근거 설명
    │
    ▼
← 사용자 승인/수정 →
    │
    ▼
[3단계: 코드 생성]
기존 프로젝트의 패턴/컨벤션에 맞춰 생성
    → Web Interface Guidelines로 최종 검증
```

## 컴포넌트 상세

### 스킬: ui-design-guide/SKILL.md

- 자동 트리거: "페이지 만들어줘", "UI 수정", "레이아웃 변경", "섹션 추가" 등 UI 키워드 감지
- analysis.json 존재 확인 → 없으면 분석 안내
- 페이지 유형 판별 → qa-templates.md에서 질문 로드 → Q&A → 설계안 제시 → 코드 생성

### 커맨드: ui-design.md

- 사용법: `/ui-design [type|description]`
  - `/ui-design` → 대화형 시작
  - `/ui-design landing` → 랜딩 페이지 워크플로우
  - `/ui-design "학원 SaaS Hero 섹션"` → 자연어 설명
- analysis.json 없으면 자동으로 분석 실행
- 인터랙티브 Q&A → 설계안 → 승인 → 코드 생성

### 커맨드: ui-analyze.md

- 사용법: `/ui-analyze`, `/ui-analyze --refresh`
- 프로젝트 스캔 → .ui-designer/analysis.json 생성
- 분석 항목:
  - 페이지 구조 (app/ 라우트 맵)
  - 컴포넌트 인벤토리 (shadcn + 커스텀)
  - 레이아웃 패턴 (사이드바/헤더/콘텐츠)
  - 스타일 컨벤션 (컬러, 폰트, 간격, 테마)
  - 디자인 토큰 (tailwind.config)
  - 기존 반복 UI 패턴

### 에이전트: ui-consultant.md

- 설계 상담 전문 서브에이전트
- 프로젝트 분석 데이터 + 컴포넌트 카탈로그 기반 최적 조합 설계
- 복잡한 설계 분석 시 스킬/커맨드가 내부 호출

### 에이전트: ui-analyzer.md

- 프로젝트 분석 전문 서브에이전트
- /ui-analyze 커맨드가 호출하는 실행 에이전트
- 코드베이스 전체 스캔 → analysis.json 생성

## 지식 베이스 (references/)

### component-catalog.md

21st-ui-components.md 기반, 의사결정 트리 형태로 재구성:

- Marketing Blocks (17종) + UI Components (30+종)
- 각 컴포넌트별: 설명 / 언제 사용 / 언제 사용 안 함 / 조합 추천 / shadcn 매핑 / 변형

### layout-patterns.md

- 그리드 시스템 (12컬럼, 반응형 브레이크포인트)
- 섹션 배치 규칙 (수직 리듬, 콘텐츠 최대 너비)
- 일반 레이아웃 패턴 (사이드바+메인, 풀와이드 히어로, 카드 그리드, 스플릿)
- 간격/사이징 체계

### page-templates.md

페이지 유형별 표준 구성:

- Landing: Navigation → Hero → Features → Testimonials → Pricing → CTA → Footer
- Dashboard: Sidebar + Header → Stats Cards → Charts/Tables → Activity Feed
- Settings: Sidebar/Tabs → Form Sections → Save Actions
- Auth: Centered Card → Form → Social Login → Links
- CRUD List: Header + Filters → Table/Cards → Pagination
- Detail: Breadcrumb → Header → Content Tabs → Related Items
- Pricing: Header → Comparison Cards → FAQ → CTA

각 유형별: 필수/선택 컴포넌트, 레이아웃 스켈레톤, shadcn 구현 매핑

### qa-templates.md

질문 형식:
```
질문: [구체적 질문]
설명: [왜 이 질문이 중요한지 1-2줄]
추천: [이 상황에서 가장 일반적인 선택] ← 분석 데이터 기반
선택지:
  a) [옵션] — [간단 설명]
  b) [옵션] — [간단 설명]
  c) [옵션] — [간단 설명]
  d) 직접 입력
```

- 사용자가 "추천대로" 하면 전체 추천 일괄 적용
- 공통 질문 + 페이지 유형별 전용 질문

### design-principles.md

- 정적 원칙: 시각적 계층, 일관성, 반응형, 컬러, 타이포그래피, 인터랙션
- Vercel Web Interface Guidelines 연동:
  - 소스: https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
  - 코드 생성 후 검증 단계에서 최신 가이드라인 fetch → 위반 사항 자동 수정

## analysis.json 구조

```json
{
  "analyzedAt": "ISO datetime",
  "project": {
    "framework": "next.js",
    "uiLibrary": "shadcn/ui",
    "styling": "tailwind"
  },
  "routes": [
    { "path": "/dashboard", "type": "dashboard", "components": [] }
  ],
  "components": {
    "shadcn": ["Button", "Card", "Table", "Sidebar", "Dialog"],
    "custom": ["ThemeSwitch", "SearchInput", "ProfileDropdown"]
  },
  "layout": {
    "pattern": "sidebar-header-content",
    "sidebar": { "width": "w-64", "collapsible": true },
    "header": { "fixed": true, "height": "h-16" },
    "content": { "maxWidth": "max-w-7xl", "padding": "p-6" }
  },
  "style": {
    "colors": { "primary": "blue" },
    "borderRadius": "rounded-lg",
    "spacing": "consistent-4-8-16",
    "darkMode": true
  },
  "patterns": {
    "dataDisplay": "table-with-toolbar",
    "forms": "card-wrapped-sections",
    "navigation": "sidebar-with-groups"
  }
}
```

## 크로스 플랫폼 호환

### Codex CLI

AGENTS.md에 references/ 경로 참조 블록 추가 안내.

### Antigravity / 기타

references/ 디렉토리를 컨텍스트로 로드하는 방법 안내.
심볼릭 링크 또는 직접 경로 지정.

## 지원 페이지 유형

landing, dashboard, settings, auth, crud-list, detail, pricing, form
