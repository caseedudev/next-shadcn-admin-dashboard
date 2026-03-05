# Next.js 기본 보일러플레이트 대비 템플릿 분석

## 0) 분석 기준
- 비교 기준: `create-next-app` 기반의 기본 Next.js 16(App Router + TS) 초기 상태
- 분석 대상: `/Users/freelife/vibe/templates/next-shadcn-admin-dashboard`
- 관점: 구조 확장, 추가 모듈/컴포넌트, 실무 시작 이점, Vercel React Best Practices 적합성

---

## 1) 기본 Next.js 보일러플레이트 대비 추가된 핵심

### 1-1. 앱 구조/라우팅 확장
- 단순 `app/page.tsx` 중심 구조가 아니라, route group 기반으로 분리된 대시보드/인증 구조:
  - `src/app/(main)/dashboard/*`
  - `src/app/(main)/auth/*`
  - `src/app/(external)/page.tsx` (루트 진입 시 `/dashboard/default` 리다이렉트)
- 사전 구성 페이지:
  - 대시보드 3종: Default, CRM, Finance
  - 인증 화면 4종: Login v1/v2, Register v1/v2
  - `not-found`, `unauthorized`, `coming-soon` 등 운영형 페이지 포함
- 라우팅 편의:
  - `next.config.mjs`에서 `/dashboard -> /dashboard/default` 리다이렉트 정의

### 1-2. 테마/레이아웃/폰트 선호도 시스템
- 기본 Next.js에는 없는 “사용자 선호도 상태 계층”이 추가됨:
  - 선호도 타입/기본값/저장전략: `src/lib/preferences/preferences-config.ts`
  - Zustand 스토어: `src/stores/preferences/preferences-store.ts`
  - Provider + DOM 상태 동기화: `src/stores/preferences/preferences-provider.tsx`
  - SSR/CSR 초기 플리커 방지 부트 스크립트: `src/scripts/theme-boot.tsx`
  - 서버 쿠키 액션: `src/server/server-actions.ts`
- 테마 프리셋 자동 생성 파이프라인:
  - 프리셋 CSS: `src/styles/presets/*.css`
  - 생성 스크립트: `src/scripts/generate-theme-presets.ts`
  - 생성 결과 반영 위치: `src/lib/preferences/theme.ts`

### 1-3. UI 시스템 확장 (shadcn 기반 커스텀 레이어)
- `src/components/ui`에 **56개** UI 컴포넌트가 사전 탑재됨.
- 특히 기본 보일러플레이트에 없는 고급 조합:
  - 사이드바 시스템(`sidebar.tsx`): 변형(inset/sidebar/floating), 접기 모드(icon/offcanvas), 모바일 sheet 대응
  - 차트 래퍼(`chart.tsx`): Recharts + 테마 변수 연동
  - 폼 래퍼(`form.tsx`): React Hook Form 필드 접근성/에러 처리 패턴 공통화
  - 토스트(`sonner.tsx`), 드로어(`drawer.tsx`), 커맨드(`command.tsx`) 등 포함

### 1-4. 데이터 표시/조작 컴포넌트
- `src/components/data-table`에 **7개** 컴포넌트로 테이블 패턴이 캡슐화됨:
  - 정렬, 컬럼 표시/숨김, 페이지네이션, 행 선택
  - DnD 행 재정렬(`@dnd-kit`) 지원
- 페이지 단에서는 훅(`src/hooks/use-data-table-instance.ts`)으로 테이블 인스턴스를 표준화해 재사용성 확보

### 1-5. DX(개발경험) 기본 셋업
- Biome 기반 포맷/린트/정렬: `biome.json`
- Husky + lint-staged 사전검증:
  - `.husky/pre-commit`에서 프리셋 생성 + staged 파일 검사 자동화
- React Compiler 활성화:
  - `next.config.mjs`의 `reactCompiler: true`

---

## 2) 추가 모듈(패키지) 분석

`package.json` 기준 의존성은 `dependencies 31개`, `devDependencies 14개`.

### 2-1. 기본 보일러플레이트 대비 주요 추가 의존성
- UI/스타일: `radix-ui`, `@base-ui/react`, `lucide-react`, `class-variance-authority`, `tailwind-merge`, `tw-animate-css`, `next-themes`, `sonner`, `vaul`
- 폼/검증: `react-hook-form`, `@hookform/resolvers`, `zod`
- 데이터 테이블/상호작용: `@tanstack/react-table`, `@dnd-kit/*`
- 시각화: `recharts`, `react-day-picker`, `embla-carousel-react`, `react-resizable-panels`, `input-otp`
- 상태/유틸: `zustand`, `cmdk`, `simple-icons`, `date-fns`
- 프레임워크 최신화: `next@16`, `react@19`, `react-dom@19`

### 2-2. 현재 코드 기준 사용 상태 메모
- 실제 사용 확인됨: `react-hook-form`, `zod`, `@tanstack/react-table`, `@dnd-kit/*`, `recharts`, `date-fns`, `zustand`, `next-themes` 등
- 현재 소스 기준 사용 흔적 없음(향후 확장 대비 가능성):
  - `@tanstack/react-query`
  - `axios`

---

## 3) 추가 컴포넌트 분석

### 3-1. 공통 컴포넌트 레이어
- `src/components/ui/*`: 디자인 시스템 레벨 컴포넌트 56개
- `src/components/data-table/*`: 테이블 패턴 7개
- `src/components/simple-icon.tsx`: 브랜드 아이콘 렌더링 보조

### 3-2. 기능(도메인) 컴포넌트 레이어
- 대시보드 전용 컴포넌트(차트/카드/테이블/사이드바): `src/app/(main)/dashboard/**/_components/*` (31개)
- 인증 폼/소셜 버튼/레이아웃 변형: `src/app/(main)/auth/**`

### 3-3. 기본 보일러플레이트와의 실질적 차이
- 기본 보일러플레이트는 “페이지 골격 + 최소 스타일” 수준
- 이 템플릿은 “관리자 제품의 UI/UX 패턴 묶음”이 이미 준비됨:
  - 사이드바/헤더/검색 다이얼로그/유저 스위처
  - 카드/차트/데이터테이블 대시보드 패턴
  - 인증 화면 2가지 스타일
  - 테마·폰트·레이아웃 개인화

---

## 4) Vercel React Best Practices 관점 평가

### 4-1. 잘 적용된 부분
- `async-parallel`: 대시보드 레이아웃에서 쿠키 기반 선호도 조회를 `Promise.all`로 병렬 처리
  - 파일: `src/app/(main)/dashboard/layout.tsx`
- `rendering-hydration-no-flicker` 취지 반영:
  - `<head>`에서 `ThemeBootScript`로 hydration 전 theme/layout attribute 적용
  - 파일: `src/app/layout.tsx`, `src/scripts/theme-boot.tsx`
- `server-serialization`/경계 분리:
  - 레이아웃(서버)과 상호작용 UI(클라이언트)를 명확히 분리
- `server-hoist-static-io` 취지 부합:
  - `next/font`를 모듈 레벨에서 선언하고 CSS variable로 주입
  - 파일: `src/lib/fonts/registry.ts`

### 4-2. 개선 여지
- `bundle-conditional`, `bundle-dynamic-imports` 관점:
  - 대형 차트/테이블 컴포넌트는 필요 시 `next/dynamic` 도입 여지 있음
- `bundle` 관점:
  - 현재 미사용 패키지(`@tanstack/react-query`, `axios`)는 초기 번들/의존성 관리 측면에서 정리 후보

---

## 5) 이 템플릿으로 개발 시작 시 좋은 점

1. **초기 구축 시간 단축**
- 인증/대시보드/사이드바/테이블/차트가 이미 연결되어 있어 “기능 개발”에 바로 진입 가능

2. **일관된 UI 시스템 확보**
- shadcn 기반 공통 컴포넌트와 토큰(CSS 변수) 중심 구조라 화면 추가 시 일관성 유지가 쉬움

3. **개인화/운영 기능이 기본 탑재**
- 라이트/다크 + 프리셋 + 폰트 + 레이아웃 선호도 저장까지 기본 제공

4. **확장하기 좋은 파일 구조**
- route 단위 co-location 구조로 기능별 컴포넌트/스키마/데이터를 붙여 확장 가능

5. **현대 스택 기반**
- Next.js 16 + React 19 + Tailwind v4 + Biome + React Compiler 조합으로 최신 생태계에 맞춤

---

## 6) 참고 파일(근거)
- 설정/메타: `package.json`, `next.config.mjs`, `components.json`, `biome.json`
- 루트/테마: `src/app/layout.tsx`, `src/app/globals.css`, `src/scripts/theme-boot.tsx`
- 선호도 저장: `src/lib/preferences/*`, `src/stores/preferences/*`, `src/server/server-actions.ts`
- 대시보드 레이아웃: `src/app/(main)/dashboard/layout.tsx`
- 데이터테이블: `src/components/data-table/*`, `src/hooks/use-data-table-instance.ts`
- 인증/대시보드 페이지: `src/app/(main)/auth/*`, `src/app/(main)/dashboard/*`
