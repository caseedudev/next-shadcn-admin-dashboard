# UI Designer Plugin v0.2.0

UI 페이지 설계 및 구현을 위한 Claude Code / Codex 플러그인.
프로젝트를 분석하고, 디자인 컨셉을 추천하고, 레이아웃을 설계하고, 코드를 생성한다.

> 아래 슬래시 명령 예시는 Codex 기준이다. Claude Code에서는 같은 명령을 `/ui-designer:...` 형태로 사용한다.

## 핵심 특징

- **프로젝트 맥락 인식**: 기존 코드를 분석하여 스타일/패턴에 맞는 구체적 추천
- **인터랙티브 Q&A**: 질문 + 설명 + 추천으로 모호함 완전 제거
- **하이브리드 워크플로우**: 자동 감지 (스킬) + 명시적 호출 (커맨드)
- **검증 포함**: Vercel Web Interface Guidelines로 생성 코드 자동 검증
- **디자인 컨셉 추천**: 67개 스타일, 116개 컬러, 57개 폰트에서 산업별 자동 추천
- **안티패턴 감지**: AI 생성 코드의 뻔한 패턴 자동 감지 및 대안 제시
- **디자인 시스템 영속성**: 디자인 결정 누적 저장으로 프로젝트 일관성 보장

---

## v0.2.0 새 기능

### 디자인 컨셉 추천 시스템
- **67개 디자인 스타일**: 5개 카테고리(모던/클래식/대담/부드러운/특수)로 분류
- **116개 컬러 팔레트**: 산업별 Light/Dark 모드 포함
- **57개 폰트 페어링**: Google Fonts 기반 Display+Body 조합
- **96개 산업별 추론 규칙**: 산업 키워드만으로 스타일/컬러/폰트 자동 추천

### 디자인 시스템 영속성
- `.ui-designer/design-system.md`에 디자인 결정 누적 저장
- 두 번째 페이지부터 Q&A 자동 단축, 일관성 보장

### 안티패턴 감지
- 30개 "제네릭 AI 미학" 안티패턴 자동 감지
- 코드 생성 시 자동 수정 + PostToolUse 훅으로 사후 검증
- 심각도별(HIGH/MEDIUM/LOW) 분류 및 대안 제시

### 검색 엔진
- BM25 기반 Python 검색 엔진 (`scripts/search.py`)
- 스타일/컬러/폰트/산업/안티패턴 도메인별 검색
- `--design-system` 플래그로 종합 디자인 시스템 생성
- `--check-anti-patterns` 플래그로 파일 안티패턴 검사
- `--persist` 플래그로 디자인 시스템 자동 저장 (Master + 페이지별 오버라이드)
  - `--persist -p "프로젝트명"` → `.ui-designer/design-system.md` (Master)
  - `--persist -p "프로젝트명" --page "대시보드"` → `.ui-designer/pages/대시보드.md` (Override)

---

## 설치

### Claude Code

```bash
bash .claude/plugins/local/ui-designer/install.sh
```

설치 스크립트가 `.claude/` 디렉토리에 심볼릭 링크를 생성한다:
- `commands/ui-designer/` — 슬래시 커맨드 (4개)
- `skills/ui-designer-*` — 자동 트리거 스킬 (1개)
- `agents/` — 서브 에이전트 (2개)

설치 후 Claude Code를 재시작하면 적용된다.

### Antigravity (선택적)

```bash
bash .claude/plugins/local/ui-designer/install-antigravity.sh
```

프로젝트 `.github/skills/`에 스킬 1개를 설치한다.
Antigravity 설치 시 `data/*.csv`와 `scripts/` 전체(`search.py`, `validate-plugin.sh`, `qa-plugin.sh`)도 스킬 디렉토리에 함께 복사되고,
이전 버전에서 남은 `ui-designer-*` 스킬 디렉토리는 정리된다.

### Codex (선택적)

```bash
bash .claude/plugins/local/ui-designer/install-codex.sh
CODEX_HOME="$PWD/.codex" codex
```

프로젝트 로컬 `.codex/prompts/`에 커맨드 4개, `.agents/skills/`에 스킬 1개를 설치한다.
Codex 설치 시 `data/*.csv`와 `scripts/` 전체(`search.py`, `validate-plugin.sh`, `qa-plugin.sh`)도 스킬 디렉토리에 함께 복사된다.
전역 `~/.codex`, `~/.agents`는 건드리지 않는다.
글로벌 `~/.codex/auth.json`이 있으면 로컬 `.codex/auth.json`으로 자동 연결한다.

### 제거

```bash
rm -rf .claude/commands/ui-designer
rm -f .claude/skills/ui-designer-*
rm -f .claude/agents/{ui-analyzer,ui-consultant}.md
rm -f .codex/prompts/ui-designer-*.md
rm -rf .agents/skills/ui-designer-*
```

---

## 빠른 시작

> 슬래시 커맨드는 환경에 따라 형식이 다르다:
> - **Claude Code**: `/ui-designer:ui-design`, `/ui-designer:ui-analyze` (콜론 구분)
> - **Codex**: `/ui-designer-ui-design`, `/ui-designer-ui-analyze` (하이픈 구분)

### 1단계: 프로젝트 분석

```bash
# Claude Code
/ui-designer:ui-analyze

# Codex
/ui-designer-ui-analyze
```

프로젝트의 라우트, 컴포넌트, 레이아웃, 스타일을 스캔하고 `.ui-designer/analysis.json`에 저장한다.

### 2단계: UI 설계

```bash
# Claude Code
/ui-designer:ui-design landing
/ui-designer:ui-design dashboard
/ui-designer:ui-design "학원 SaaS Hero 섹션"

# Codex
/ui-designer-ui-design landing
/ui-designer-ui-design dashboard
/ui-designer-ui-design "학원 SaaS Hero 섹션"
```

페이지 유형을 지정하거나 자유롭게 설명하면 인터랙티브 Q&A → 설계안 → 코드 생성 순서로 진행한다.

### 3단계: 자동 감지

일반 대화에서 "로그인 페이지 만들어줘", "대시보드에 차트 추가해줘" 등 UI 작업을 요청하면 스킬이 자동으로 활성화된다.

### 4단계: 플러그인 검수

```bash
# Claude Code
/ui-designer:ui-validate --full
/ui-designer:ui-qa --all

# Codex
/ui-designer-ui-validate --full
/ui-designer-ui-qa --all
```

설치 이후 구조 검증, 검색 엔진, 안티패턴, 영속성, 동기화 상태까지 한 번에 점검할 수 있다.

Codex 자동화나 비대화형 실행에서는 아래 스크립트를 우선 사용한다:

```bash
bash .claude/plugins/local/ui-designer/scripts/validate-plugin.sh --full
bash .claude/plugins/local/ui-designer/scripts/qa-plugin.sh --all
```

이 스크립트는 Codex에서 안정적으로 실행 가능한 항목은 실제로 돌리고,
인터랙티브 Q&A가 필요한 항목은 프롬프트 계약 검증으로 대체한다.

---

## 슬래시 커맨드

> **커맨드 형식 안내**: 아래는 Codex 형식(`/ui-designer-ui-*`)으로 표기한다.
> Claude Code에서는 `/ui-designer:ui-*` 형식을 사용한다. (예: `/ui-designer:ui-design`)

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
디자인 시스템 체크: .ui-designer/design-system.md

**Q1. 이 대시보드의 주요 타겟 사용자는?**
> 학원 관리자가 수강생/매출 현황을 모니터링

**Q3. 디자인 컨셉**
★ 추천 스타일: Corporate Clean, Data-Dense Dashboard
  산업 분석: "학원 SaaS" → education 카테고리 매칭

  a) Corporate Clean — 깔끔한 기업용 (추천)
  b) Glassmorphism — 반투명 유리 효과
  c) Brutalist — 대담한 실험적
  d) 직접 입력

**Q3.5. 컬러 팔레트**
★ 추천: Education Blue (#2563EB 기반)
  Light/Dark 모드 토큰 포함

**Q3.6. 폰트 페어링**
★ 추천: Inter + Source Sans 3
  a) Inter + Source Sans 3 — 모던 대시보드 (추천)
  b) DM Sans + IBM Plex Sans — 테크 느낌
  c) 직접 입력
```

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

### `/ui-designer-ui-validate [--full | --data | --hooks | --search | --persist]`

플러그인의 구조적 무결성을 검증한다. 7개 Step으로 구성된다.

| 인자 | 동작 |
|------|------|
| 없음 / `--full` | 전체 검증 (Step 1~7 모두 실행) |
| `--data` | CSV 데이터 무결성만 검증 |
| `--hooks` | 훅 스크립트 동작만 검증 |
| `--search` | 검색 엔진 기능만 검증 |
| `--persist` | 디자인 시스템 영속성만 검증 |

**검증 항목:**

| Step | 내용 |
|------|------|
| 1. 구조 검증 | 12개 필수 파일 존재 + frontmatter 유효성 |
| 2. 레퍼런스 검증 | 11개 참조 문서 존재 확인 |
| 3. 데이터 무결성 | 5개 CSV 행 수 + industries.csv 참조 무결성 |
| 4. 훅 검증 | hooks.json 구조 + 스크립트 실행 권한 + 감지 테스트 |
| 5. 검색 엔진 검증 | 도메인별 검색, --design-system, --check-anti-patterns |
| 6. 영속성 검증 | --persist Master + Page override 저장/정리 |
| 7. 외부 동기화 | 소스 ↔ .agents/skills/ diff 비교 |

### `/ui-designer-ui-qa [--all | --search | --workflow | --antipattern | --persist | --edge-cases]`

플러그인의 **모든 기능을 실제로 실행**하여 QA한다. 7개 Test로 구성된다.

| 인자 | 동작 |
|------|------|
| 없음 / `--all` | 전체 QA (Test 1~7 모두 실행) |
| `--search` | 검색 엔진 테스트만 (도메인별, 산업별, 한국어) |
| `--workflow` | 디자인 워크플로우 테스트만 (분석 + Q&A) |
| `--antipattern` | 안티패턴 감지 테스트만 (bad/clean 파일) |
| `--persist` | 디자인 시스템 영속성 테스트만 (Master + Page) |
| `--edge-cases` | 엣지 케이스 테스트만 (빈 쿼리, 특수문자 등) |

**테스트 항목:**

| Test | 내용 | 주요 검증 포인트 |
|------|------|-----------------|
| 1. 검색 엔진 | BM25 도메인별/산업별/한국어 검색 | 결과 정확도, 스코어 정렬 |
| 2. 프로젝트 분석 | /ui-analyze 최초/재분석/로드 | JSON 스키마, 컴포넌트 감지 |
| 3. 디자인 워크플로우 | Q&A 형식, 컨셉 플로우, 추천 일괄 적용 | Q3→Q3-1→Q3.5→Q3.6 흐름 |
| 4. 안티패턴 감지 | bad 파일 6+ 패턴 감지 / clean 파일 0건 | 심각도 분류, false positive |
| 5. 영속성 | Master + 2개 Page override | 계층형 저장, 독립 내용 |
| 6. 디자인 시스템 재사용 | Step 0.5 Q&A 단축 플로우 | a/b/c 선택지, 건너뛰기 |
| 7. 엣지 케이스 | 빈 쿼리, 긴 쿼리, 특수문자, 없는 파일 등 | 크래시 없이 처리 |

실제 워크플로우를 기준으로 검색, Q&A 흐름, 안티패턴 감지, 영속성, 엣지 케이스를 종합 QA 한다.

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

[0.5단계] 디자인 시스템 체크 (NEW)
  → .ui-designer/design-system.md 확인
  → 기존 디자인 결정이 있으면 로드하여 일관성 유지

[1단계] 요구사항 수집
  → 페이지 유형 판별
  → 인터랙티브 Q&A (질문 + 설명 + 추천 + 선택지)
  → Q3: 디자인 컨셉 추천 (67개 스타일)
  → Q3.5: 컬러 팔레트 추천 (116개 팔레트)
  → Q3.6: 폰트 페어링 추천 (57개 조합)
  → "추천대로" 응답 시 일괄 적용

[2단계] 설계 제안
  → 분석 데이터 + Q&A 기반 설계안 생성
  → ASCII 레이아웃 + 컴포넌트 목록 + 파일 구조
  → 스타일 시스템 (컬러 토큰 + 폰트 설정) 포함
  → 사용자 승인

[3단계] 코드 생성 + 안티패턴 검사
  → 기존 프로젝트 패턴/컨벤션 준수
  → 아이콘: lucide-react 기본 사용
  → 30개 안티패턴 자동 감지 및 수정
  → Vercel Web Interface Guidelines 검증
  → 결과 보고

[4단계] 디자인 시스템 저장 (NEW)
  → 디자인 결정을 .ui-designer/design-system.md에 누적 저장
  → 다음 페이지 설계 시 자동 로드
```

---

## 검색 엔진

BM25 기반 검색 엔진으로 디자인 데이터를 탐색할 수 있다.

```bash
# 스타일 검색
python3 scripts/search.py "glassmorphism" --domain style

# 카테고리 필터
python3 scripts/search.py "modern" --domain style --category modern

# 컬러 팔레트 검색
python3 scripts/search.py "premium dark" --domain color

# 폰트 페어링 검색
python3 scripts/search.py "serif elegant" --domain font

# 산업별 디자인 시스템 생성
python3 scripts/search.py "fintech dashboard" --design-system

# 파일 안티패턴 검사
python3 scripts/search.py --check-anti-patterns src/app/page.tsx
```

---

## 스킬

### `ui-designer-ui-design-guide`

UI 관련 작업 시 자동으로 트리거되는 컨텍스트 스킬.

**트리거 키워드:** "create a page", "make a UI", "design a layout", "페이지 만들어줘", "UI 수정", "레이아웃 변경", "섹션 추가", "화면 구성", "대시보드 만들어줘", "로그인 페이지 만들어줘", "폼 추가해줘"

**동작:** 프로젝트 맥락을 인식하여 디자인 컨셉 추천, 컴포넌트 추천, 레이아웃 설계, 코드 생성을 인터랙티브 Q&A로 진행

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
| `design-concepts.md` | 67종 디자인 스타일 카탈로그 (5 카테고리) |
| `color-palettes.md` | 116종 산업별 컬러 팔레트 (Light/Dark) |
| `font-pairings.md` | 57종 폰트 페어링 (Display+Body) |
| `industry-rules.md` | 96종 산업별 디자인 추론 규칙 |
| `anti-patterns.md` | 30종 제네릭 AI 안티패턴 가이드 |

---

## 데이터 규모

| 항목 | 수량 |
|------|------|
| 디자인 스타일 | 67개 (5 카테고리) |
| 컬러 팔레트 | 116개 (85 산업) |
| 폰트 페어링 | 57개 (4 유형) |
| 산업 추론 규칙 | 96개 |
| 안티패턴 | 30개 (5 카테고리) |
| **총 데이터 포인트** | **366개** |

---

## 에이전트

| 에이전트 | 역할 | 호출 시점 |
|---------|------|----------|
| `ui-analyzer` | 프로젝트 UI 구조 분석 | `/ui-designer-ui-analyze` 실행 시 |
| `ui-consultant` | 설계안 생성 및 컨설팅 | `/ui-designer-ui-design` 설계 단계에서 |

Codex에서는 위 에이전트를 별도로 설치하지 않으며, 커맨드가 분석/설계를 직접 수행한다.

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
- 디자인 컨셉: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/design-concepts.md
- 컬러 팔레트: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/color-palettes.md
- 폰트 페어링: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/font-pairings.md
- 산업 규칙: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/industry-rules.md
- 안티패턴: .claude/plugins/local/ui-designer/skills/ui-design-guide/references/anti-patterns.md

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
├── install.sh                   # Claude Code 설치 스크립트
├── install-codex.sh             # Codex 설치 스크립트
├── install-antigravity.sh       # Antigravity 설치 스크립트
├── commands/
│   ├── ui-design.md             # /ui-designer-ui-design
│   ├── ui-analyze.md            # /ui-designer-ui-analyze
│   ├── ui-validate.md           # /ui-designer-ui-validate
│   └── ui-qa.md                 # /ui-designer-ui-qa
├── skills/
│   └── ui-design-guide/         # ui-designer-ui-design-guide (자동 트리거)
│       ├── SKILL.md
│       └── references/
│           ├── component-catalog.md   # 58종 컴포넌트 카탈로그
│           ├── layout-patterns.md     # 레이아웃 패턴
│           ├── page-templates.md      # 페이지 템플릿
│           ├── qa-templates.md        # Q&A 템플릿
│           ├── design-principles.md   # 디자인 원칙
│           ├── external-resources.md  # 외부 리소스
│           ├── design-concepts.md     # 67종 디자인 스타일
│           ├── color-palettes.md      # 116종 컬러 팔레트
│           ├── font-pairings.md       # 57종 폰트 페어링
│           ├── industry-rules.md      # 96종 산업 추론 규칙
│           └── anti-patterns.md       # 30종 안티패턴
├── data/
│   ├── styles.csv               # 디자인 스타일 데이터
│   ├── colors.csv               # 컬러 팔레트 데이터
│   ├── fonts.csv                # 폰트 페어링 데이터
│   ├── industries.csv           # 산업 추론 규칙 데이터
│   └── anti-patterns.csv        # 안티패턴 데이터
├── scripts/
│   └── search.py                # BM25 검색 엔진
├── agents/
│   ├── ui-analyzer.md           # 프로젝트 분석 에이전트
│   └── ui-consultant.md         # UI 설계 컨설턴트 에이전트
├── hooks/
│   ├── hooks.json               # 훅 설정
│   └── scripts/
│       ├── check-anti-patterns.sh  # 안티패턴 검사 훅
│       └── validate-design.sh     # 디자인 검증 훅
└── README.md                    # 이 문서
```

---

## 기술 스택

이 플러그인은 **Next.js + shadcn/ui + Tailwind CSS** 환경에 최적화되어 있다.

> **참고**: 멀티 스택 지원(`--stack`)은 의도적으로 포함하지 않았다.
> 이 플러그인은 프로젝트 특화 플러그인으로, 단일 스택(Next.js + shadcn + Tailwind)에 집중하여
> 더 정확한 추천과 검증을 제공한다. 다른 스택이 필요하면 별도 플러그인을 생성하는 것을 권장한다.
