# Next Shadcn Admin Dashboard 기술 스택 정리

### 주요 기술스택
- **프론트엔드:** Next.js 16(App Router) + React 19 + TypeScript 기반으로 구성된 관리자 대시보드 템플릿입니다.
- **UI 컴포넌트:** shadcn/ui 중심 구조이며, 내부적으로 Radix UI와 Base UI를 함께 활용합니다.
- **스타일링:** Tailwind CSS v4를 기반으로 `class-variance-authority`, `clsx`, `tailwind-merge`, `tw-animate-css`를 사용해 일관된 스타일 시스템을 구성합니다.
- **상태/테마:** Zustand로 사용자 선호도(테마/레이아웃/폰트)를 관리하고, `next-themes` 및 쿠키 기반 동기화로 SSR/CSR 테마 일관성을 유지합니다.
- **폼/검증:** React Hook Form + Zod + `@hookform/resolvers` 조합으로 폼 상태와 유효성 검증을 처리합니다.
- **데이터 테이블/인터랙션:** TanStack Table + dnd-kit으로 정렬/페이징/드래그 가능한 테이블 UX를 제공합니다.
- **차트/시각화:** Recharts를 사용해 대시보드 차트 컴포넌트를 구성합니다.
- **아이콘:** Lucide React를 주 아이콘 라이브러리로 사용하며, Simple Icons도 일부 함께 사용합니다.
- **개발 도구:** Biome(린트/포맷), Husky + lint-staged(커밋 전 검사), React Compiler(`next.config.mjs`)를 적용했습니다.
- **배포/인프라:** Vercel 원클릭 배포를 전제로 한 Next.js 템플릿 구조입니다.

### UI/스타일링
- **TailwindCSS v4:** 유틸리티 기반 스타일링과 CSS 변수 기반 테마 확장을 지원합니다.
- **shadcn/ui:** `src/components/ui`에 재사용 가능한 UI 컴포넌트 세트가 구축되어 있습니다.
- **Radix UI / Base UI:** 접근성과 상호작용 품질을 높이기 위한 프리미티브 컴포넌트 레이어로 사용됩니다.
- **tw-animate-css:** UI 전환 애니메이션 유틸리티를 제공합니다.
- **Lucide React:** 전반적인 네비게이션/액션 아이콘에 사용됩니다.

### 상태 관리
- **Zustand:** 테마 모드, 프리셋, 폰트, 레이아웃 등 사용자 선호도 전역 상태를 관리합니다.
- **React Context + Provider 패턴:** Zustand 스토어를 앱 트리에 주입하고 화면 전반에서 일관되게 사용합니다.
- **참고:** `@tanstack/react-query`는 의존성에 포함되어 있으나 현재 소스 코드 import 기준 사용 흔적은 없습니다.

### 폼 처리
- **React Hook Form:** 로그인/회원가입 등 폼 상태 관리에 사용됩니다.
- **Zod:** 스키마 기반 입력 검증 및 타입 안정성을 제공합니다.
- **@hookform/resolvers:** React Hook Form과 Zod를 연결합니다.

### 라우팅
- **Next.js App Router:** route group 기반으로 대시보드/인증 화면을 구조화합니다.
- **리다이렉트 설정:** `/dashboard` → `/dashboard/default` 리다이렉트를 `next.config.mjs`에서 관리합니다.
- **Server Actions:** 쿠키 기반 사용자 선호도 저장/조회 로직에 활용됩니다.

### 백엔드/DB/인증
- **백엔드:** 별도 Nest.js/Express 서버 없이 Next.js 앱 중심 템플릿입니다.
- **DB/ORM/BaaS:** Supabase, Prisma, Drizzle 등은 현재 프로젝트에 기본 포함되어 있지 않습니다.
- **인증:** 로그인/회원가입 UI 화면은 제공되지만, 외부 인증 서비스(NextAuth/Auth0/Clerk) 연동은 기본 내장되어 있지 않습니다.

### 배포·인프라
- **Vercel:** README 기준 원클릭 배포가 가능합니다.
- **빌드/런타임:** Next.js 표준 `dev/build/start` 스크립트를 사용합니다.
- **운영 최적화:** Production 환경에서 `removeConsole` 설정을 사용합니다.

### 기타 도구
- **TypeScript:** 전체 코드베이스 타입 안정성 확보.
- **Biome:** 포맷/린트/정적 점검 통합 도구.
- **Husky + lint-staged:** 커밋 단계 품질 게이트 구성.
- **date-fns / Sonner / Vaul / Recharts 등:** 날짜 처리, 토스트, 드로어, 시각화 등 실무 UI 기능을 보강합니다.
- **참고:** `axios`도 의존성에는 있으나 현재 소스 코드 import 기준 사용 흔적은 없습니다.
