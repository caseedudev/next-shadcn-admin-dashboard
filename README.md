# Next.js 어드민 대시보드 템플릿 (TypeScript & Shadcn UI)

**Studio Admin** — 다양한 대시보드, 인증 화면, 커스터마이징 가능한 테마 프리셋 등을 포함한 어드민 템플릿.

<img src="https://github.com/arhamkhnz/next-shadcn-admin-dashboard/blob/main/media/dashboard.png?version=5" alt="대시보드 스크린샷">

대부분의 어드민 템플릿은 복잡하거나, 오래되었거나, 유연하지 않았습니다. 테마 전환, 레이아웃 제어 같은 기능을 갖추면서도 깔끔하고 최신 디자인을 유지하는 대안으로 만들었습니다.

디자인 영감을 받은 다양한 소스가 있습니다. 크레딧이 필요한 경우 이슈나 연락을 주세요.

> **데모 보기:** [studio admin](https://next-shadcn-admin-dashboard.vercel.app)

> [!TIP]
> Nuxt.js, Svelte, React (Vite + TanStack Router) 버전도 준비 중입니다. 곧 공개됩니다.

---

## ⚡ 퀵 가이드

3단계만 따라하면 로컬에서 바로 실행할 수 있습니다.

```bash
# 1. 저장소 클론
git clone https://github.com/arhamkhnz/next-shadcn-admin-dashboard.git
cd next-shadcn-admin-dashboard

# 2. 의존성 설치
npm install

# 3. 개발 서버 실행
npm run dev
```

브라우저에서 [http://localhost:3000](http://localhost:3000) 으로 접속하면 대시보드를 확인할 수 있습니다.

**Supabase 연동이 필요한 경우:**

```bash
# .env.example을 복사하고 Supabase 값 입력
cp .env.example .env.local
```

**커스터마이징 시작점:**

| 목적 | 경로 |
|------|------|
| 대시보드 페이지 추가/수정 | `src/app/(main)/dashboard/` |
| 사이드바 메뉴 변경 | `src/app/(main)/dashboard/_components/sidebar/` |
| 테마 프리셋 추가 | 기존 프리셋 구조를 따라 새 프리셋 생성 |
| API 엔드포인트 추가 | `src/app/api/v1/<도메인>/<리소스>/route.ts` |
| 새 기능(feature) 추가 | `src/features/<도메인>/` |

---

## 주요 기능

- Next.js 16, TypeScript, Tailwind CSS v4, Shadcn UI 기반
- 반응형 및 모바일 최적화
- 커스터마이징 가능한 테마 프리셋 (라이트/다크 모드 + Tangerine, Brutalist 등 색상 스킴)
- 유연한 레이아웃 (접이식 사이드바, 가변 콘텐츠 너비)
- 인증 흐름 및 화면
- 사전 구축된 대시보드 (Default, CRM, Finance) — 추가 예정
- 역할 기반 접근 제어(RBAC) + 설정 기반 UI + 멀티테넌트 지원 *(계획 중)*

> [!NOTE]
> 기본 대시보드는 **shadcn neutral** 테마를 사용합니다.
> [Tweakcn](https://tweakcn.com)에서 영감받은 추가 색상 프리셋도 포함되어 있습니다:
>
> - Tangerine
> - Neo Brutalism
> - Soft Pop
>
> 기존 프리셋과 동일한 구조를 따라 새로운 프리셋을 만들 수 있습니다.

---

## 기술 스택

| 영역 | 기술 |
|------|------|
| **Core** | Next.js 16 (App Router), React 19, TypeScript 5 |
| **UI** | Tailwind CSS v4, Shadcn UI, Lucide React, Framer Motion |
| **폼/검증** | React Hook Form, Zod |
| **상태 관리** | TanStack Query (서버 상태), Zustand (UI 전역 상태) |
| **테이블/데이터** | TanStack Table |
| **백엔드** | Route Handler (`/api/v1/**`), Supabase Auth + Postgres + RLS |
| **도구/DX** | Biome, Husky |

---

## 화면 목록

### 제공 중

- Default 대시보드
- CRM 대시보드
- Finance 대시보드
- 인증 화면 (4개)

### 추가 예정

- Analytics 대시보드
- eCommerce 대시보드
- Academy 대시보드
- Logistics 대시보드
- 이메일 페이지
- 채팅 페이지
- 캘린더 페이지
- 칸반 보드
- 인보이스 페이지
- 사용자 관리
- 역할 관리

---

## 📁 프로젝트 구조

이 프로젝트는 **코로케이션(Colocation) 기반 아키텍처**를 따릅니다. 각 기능은 자체 라우트 폴더 안에 페이지, 컴포넌트, 로직을 함께 배치합니다. 공유 UI, 훅, 설정은 최상위에 둡니다.

> 구조에 대한 자세한 설명은 [Next Colocation Template](https://github.com/arhamkhnz/next-colocation-template)을 참고하세요.

### 핵심 디렉토리

```
src/
├── app/                          # 라우팅, 레이아웃, Route Handler
│   ├── (main)/
│   │   ├── auth/                 # 인증 화면 (v1, v2)
│   │   │   └── _components/     # 인증 폼 컴포넌트
│   │   └── dashboard/            # 대시보드 (default, crm, finance)
│   │       ├── _components/     # 사이드바, 헤더 등
│   │       └── layout.tsx        # 권한 가드 (멤버십 확인)
│   └── api/v1/                   # 버저닝된 API 엔드포인트
│       ├── auth/                 # 로그인, 회원가입
│       └── academy/              # 도메인별 API
├── components/ui/                # 공유 UI 컴포넌트 (shadcn)
├── features/                     # 도메인별 비즈니스 로직
│   └── <domain>/                # types, service, queries, constants
├── lib/                          # 외부 연동/인프라
│   └── supabase/                # 서버/브라우저 클라이언트, 환경변수
├── proxy.ts                      # 세션 라우팅 가드 (미들웨어)
supabase/
├── migrations/                   # DB 스키마 마이그레이션 (단일 진실 공급원)
└── seeds/                        # 시드 데이터
docs/architecture/                # 아키텍처 규칙 문서
dashboard-template-plugin/        # Claude Code 플러그인
tests/                            # 계약 테스트
```

### 계층 경계와 의존 방향

```
app  →  features  →  lib
 ↓
(역방향 의존 금지)
```

- **`app/`** — 라우팅, HTTP 진입점, 레이아웃. 얇은 어댑터 역할만 수행
- **`features/`** — 도메인 유스케이스/서비스. `app/`을 참조하지 않음
- **`lib/`** — 외부 연동(Supabase, storage). `app/`과 `features/`를 참조하지 않음
- **`components/ui/`** — 순수 UI. `lib/`만 참조 가능

이 구조는 향후 Turborepo 모노레포 전환 시 `apps/*`, `packages/*`로의 안전한 이동을 보장합니다.

---

## 🏗️ 아키텍처 규칙 요약

프로젝트의 일관성과 품질을 유지하기 위한 핵심 규칙입니다. 아래는 **MUST(필수)** 등급만 요약한 것이며, 전체 규칙은 `docs/architecture/` 문서를 참고하세요.

### API / 백엔드

| 규칙 | 내용 |
|------|------|
| API-001 | 모든 API는 `src/app/api/v1/**` 하위에 생성 |
| API-002 | `zod.safeParse` 입력 검증 + 400/401/403/500 상태코드 |
| API-003 | 목록 API는 cursor pagination 사용 (`id > cursor`, `limit + 1`) |
| API-004 | Route Handler는 얇은 어댑터, 비즈니스 로직은 `features/`·`lib/`에 위임 |

### Supabase / 데이터

| 규칙 | 내용 |
|------|------|
| SB-001 | 서버: `createSupabaseServerClient`, 브라우저: `createSupabaseBrowserClient` |
| SB-002 | 멀티테넌트 테이블은 RLS + FORCE RLS 기본 적용 |
| SB-003 | 스키마 변경은 migration-only, `(select auth.uid())` 패턴 사용 |
| DATA-001 | 데이터 접근 권한의 최종 판단은 Supabase RLS |

### 성능 / 컴포넌트

| 규칙 | 내용 |
|------|------|
| PERF-001 | 독립 I/O는 `Promise.all`로 병렬화 |
| PERF-004 | barrel import 금지, 무거운 컴포넌트는 `next/dynamic` |
| COMP-001 | boolean prop 증식 금지 — variant 컴포넌트로 분리 |
| UI-001 | 아이콘 버튼 `aria-label`, 입력 필드 `<label>`, `focus-visible` 유지 |

### 품질

| 규칙 | 내용 |
|------|------|
| QA-001 | 신규 규칙/구조 추가 시 계약 테스트 필수 |
| QA-002 | PR 전 `check + test + build` 통과 필수 |

> **전체 규칙 문서:**
> - [개발 규칙](docs/architecture/development-rules.md) — 핵심 개발 규칙 (ARCH, API, SB, DATA, PERF, QA)
> - [Next.js Best Case 규칙](docs/architecture/nextjs-best-case-rules.md) — 프론트엔드/성능/컴포넌트/접근성 규칙
> - [Supabase/Route 패턴 + 모노레포 가이드](docs/architecture/supabase-route-and-monorepo-guide.md) — DB 패턴, 모노레포 전환 규칙
> - [Turborepo 도입 규칙](docs/architecture/turborepo-adoption-rules.md) — 도입 트리거, 전환 규칙
> - [현재 구현 구조 스냅샷](docs/architecture/current-implemented-structure.md) — 실제 반영된 구조 기록

---

## 🔌 Claude Code 플러그인

이 프로젝트에는 **dashboard-template-plugin**이 포함되어 있습니다. Claude Code에서 이 플러그인을 활성화하면 위의 아키텍처 규칙이 개발 작업에 자동으로 적용됩니다.

### 빠른 설치

```bash
# 방법 1: CLI 옵션 (일회성)
claude --plugin-dir ./dashboard-template-plugin

# 방법 2: 프로젝트 설정에 영구 등록 (권장)
# .claude/settings.json에 추가:
{
  "plugins": ["./dashboard-template-plugin"]
}
```

### 슬래시 명령

| 명령 | 설명 |
|------|------|
| `/tem:checklist` | 현재 git 변경사항에 대해 AI 체크리스트 실행 |
| `/tem:review-frontend` | 프론트엔드 코드 리뷰 (읽기 전용 에이전트) |
| `/tem:review-backend` | 백엔드 코드 리뷰 (읽기 전용 에이전트) |
| `/tem:new-api <도메인>/<리소스>` | `/api/v1/` 하위에 API 라우트 스캐폴딩 |
| `/tem:new-feature <도메인>` | `src/features/` 하위에 피처 디렉토리 스캐폴딩 |
| `/tem:new-migration <설명>` | Supabase 마이그레이션 파일 스캐폴딩 |

### 에이전트

| 에이전트 | 역할 | 권한 |
|---------|------|------|
| `frontend-architect` | 프론트엔드 코드 리뷰 | 읽기 전용 |
| `backend-architect` | 백엔드 코드 리뷰 | 읽기 전용 |
| `fullstack-dev` | 기능 구현 (기본 에이전트) | 모든 도구 |

### 스킬 (자동 활성화)

| 스킬 | 트리거 조건 |
|------|------------|
| `frontend-dev` | React 컴포넌트, Next.js 페이지, UI 코드 작업 시 |
| `backend-dev` | API 라우트, Supabase, SQL, 마이그레이션 작업 시 |
| `fullstack-review` | PR 리뷰, 코드 리뷰 시 |

### 자동 가드레일 (훅)

- `/api/v1/` 외부에 API 라우트 생성 시 **자동 차단**
- `features/`·`lib/`에서 `@/app/` import 시 **자동 차단** (역방향 의존 방지)
- SQL에서 `auth.uid()` 직접 사용 시 `(select auth.uid())` 패턴 사용 **경고**

> **상세 사용법 및 예시:** [플러그인 README](dashboard-template-plugin/README.md)

---

## 테마 프리셋

> [!NOTE]
> 기본 테마는 **shadcn neutral**이며, [Tweakcn](https://tweakcn.com)에서 영감받은 추가 프리셋이 포함되어 있습니다:
>
> - Tangerine
> - Neo Brutalism
> - Soft Pop
>
> 기존 프리셋과 동일한 구조를 따라 새로운 프리셋을 쉽게 추가할 수 있습니다.

---

## 배포

### Vercel로 배포

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Farhamkhnz%2Fnext-shadcn-admin-dashboard)

_원클릭으로 자신만의 복사본을 배포할 수 있습니다._

### 로컬 실행

```bash
# 1. 저장소 클론
git clone https://github.com/arhamkhnz/next-shadcn-admin-dashboard.git

# 2. 프로젝트 디렉토리로 이동
cd next-shadcn-admin-dashboard

# 3. 의존성 설치
npm install

# 4. 개발 서버 실행
npm run dev
```

[http://localhost:3000](http://localhost:3000) 에서 앱이 실행됩니다.

---

## Supabase 환경 설정

`.env.example`을 복사한 후 Supabase 값을 입력하세요.

```bash
cp .env.example .env.local
```

---

## 포맷팅 및 린트

포맷, 린트, import 정리를 한 번에 실행:

```bash
npx @biomejs/biome check --write
```

> 사용 가능한 규칙, 수정 옵션, CLI 옵션에 대한 자세한 정보는 [Biome 문서](https://biomejs.dev/)를 참고하세요.

---

## 아키텍처 문서

| 문서 | 내용 |
|------|------|
| [개발 규칙](docs/architecture/development-rules.md) | 핵심 개발 규칙 (ARCH, API, SB, DATA, PERF, QA) |
| [Next.js Best Case 규칙](docs/architecture/nextjs-best-case-rules.md) | 프론트엔드/성능/컴포넌트/접근성 규칙 |
| [Supabase/Route 패턴 + 모노레포 가이드](docs/architecture/supabase-route-and-monorepo-guide.md) | DB 패턴, 모노레포 전환 규칙 |
| [Turborepo 도입 규칙](docs/architecture/turborepo-adoption-rules.md) | 도입 트리거, 전환 규칙 |
| [현재 구현 구조 스냅샷](docs/architecture/current-implemented-structure.md) | 실제 반영된 구조 기록 |

---

## 이전 버전

> **Next.js 15** 버전을 찾고 계신가요?
> [`archive/next15`](https://github.com/arhamkhnz/next-shadcn-admin-dashboard/tree/archive/next15) 브랜치를 확인하세요.
> 이 브랜치는 Next 16 및 React Compiler 업그레이드 이전의 설정을 포함합니다.

> **Next.js 14 + Tailwind CSS v3** 버전을 찾고 계신가요?
> [`archive/next14-tailwindv3`](https://github.com/arhamkhnz/next-shadcn-admin-dashboard/tree/archive/next14-tailwindv3) 브랜치를 확인하세요.
> 다른 색상 테마를 사용하며, 적극적으로 유지보수되지는 않지만 주요 변경사항은 반영하려 노력하고 있습니다.

---

> [!IMPORTANT]
> 이 프로젝트는 자주 업데이트됩니다. 포크나 이전 클론을 사용 중이라면 동기화 전에 최신 변경사항을 pull하세요. 일부 업데이트에는 breaking changes가 포함될 수 있습니다.

---

기여를 환영합니다. 이슈, 기능 요청을 열거나 토론을 시작해주세요.

**Happy Vibe Coding!**
