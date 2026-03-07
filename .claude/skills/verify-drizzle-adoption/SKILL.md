# Drizzle ORM 도입 검증

## 목적

Drizzle ORM 보조 계층이 프로젝트 아키텍처 규칙에 맞게 구성되었는지 검증한다.

## Workflow

### Check 1: Drizzle 계층 파일 존재 확인

**도구:** Glob
**패턴:** `src/lib/drizzle/**/*.ts`
**PASS 기준:** 다음 4개 파일이 모두 존재
- `src/lib/drizzle/env.ts`
- `src/lib/drizzle/schema.ts`
- `src/lib/drizzle/client.ts`
- `src/lib/drizzle/index.ts`

### Check 2: server-only 보안 경계

**도구:** Grep
**패턴:** `import "server-only"` in `src/lib/drizzle/client.ts`, `src/lib/drizzle/env.ts`
**PASS 기준:** 두 파일 모두 `server-only` import가 존재
**FAIL 시:** 클라이언트 번들에 DB 연결 정보가 유출될 수 있음

### Check 3: 환경변수 검증 함수

**도구:** Read `src/lib/drizzle/env.ts`
**PASS 기준:**
- `DATABASE_URL` 환경변수를 읽고 검증하는 함수가 존재
- 누락 시 명시적 에러를 throw

### Check 4: 스키마-마이그레이션 동기화

**도구:** Read `src/lib/drizzle/schema.ts`, Grep `supabase/migrations/*.sql`
**PASS 기준:**
- `supabase/migrations/` 내 `create table` 문의 테이블 이름이 `schema.ts`의 `pgTable()` 호출에 모두 매핑됨
- 현재 대상: `academies`, `academy_members`, `academy_enrollments`

### Check 5: 커넥션 설정 안전성

**도구:** Read `src/lib/drizzle/client.ts`
**PASS 기준:**
- `max` 값이 10 이하 (서버리스 환경 커넥션 과다 방지)
- `connect_timeout` 설정 존재
- drizzle 인스턴스가 schema를 포함하여 생성됨 (`drizzle(sql, { schema })`)

### Check 6: 공개 API (index.ts) 구조

**도구:** Read `src/lib/drizzle/index.ts`
**PASS 기준:**
- `db` export 존재
- schema re-export 존재 (`export * from "./schema"`)
- 내부 구현(`env.ts`, `client.ts` 내부)을 직접 노출하지 않음

### Check 7: drizzle.config.ts 설정

**도구:** Read `drizzle.config.ts`
**PASS 기준:**
- `schema` 경로가 `./src/lib/drizzle/schema.ts`를 가리킴
- `dialect`가 `postgresql`
- `DIRECT_DATABASE_URL` 환경변수 사용 (Pooler가 아닌 Direct 연결)

### Check 8: .env.example 환경변수 등록

**도구:** Read `.env.example`
**PASS 기준:**
- `DATABASE_URL` 항목 존재
- `DIRECT_DATABASE_URL` 항목 존재

### Check 9: 아키텍처 문서 일관성

**도구:** Grep
**PASS 기준:**
- `docs/architecture/development-rules.md`에 `Drizzle ORM` 언급 존재
- `docs/architecture/nextjs-best-case-rules.md`에 `Drizzle` 언급 및 `DATA-003` 섹션 존재
- `docs/architecture/current-implemented-structure.md`에 `Drizzle ORM 보조 계층` 섹션 존재
- `docs/architecture/turborepo-adoption-rules.md`에 `infra-drizzle` 언급 존재
- `docs/architecture/supabase-route-and-monorepo-guide.md`에 `infra-drizzle` 언급 존재

### Check 10: 계약 테스트 존재

**도구:** Glob
**패턴:** `tests/drizzle-adoption-contract.test.mjs`
**PASS 기준:** 파일이 존재하고, `npm run test` 실행 시 통과

### Check 11: 사용 경계 위반 탐지

**도구:** Grep
**패턴:** `from "@/lib/drizzle"` 또는 `from "../drizzle"` in `src/app/api/v1/**/*.ts`
**PASS 기준:** 공개 사용자 API 라우트에서 Drizzle 직접 import가 없음
**FAIL 시:** DATA-003 사용 경계 위반 — Drizzle은 내부 운영/배치/리포트 쿼리 전용

## Exceptions

다음은 위반이 아닙니다:

1. **관리자 전용 API에서의 Drizzle 사용** — `src/app/api/v1/admin/**` 또는 `src/app/api/internal/**` 경로는 내부 운영 API로 허용
2. **테스트 파일에서의 Drizzle import** — `tests/**`, `*.test.*` 파일은 검사 대상 제외
3. **drizzle-kit push/migrate 미사용** — 이는 의도된 설계 (마이그레이션은 Supabase SQL이 단일 진실 공급원)

## Related Files

| File | Purpose |
|------|---------|
| `src/lib/drizzle/env.ts` | DATABASE_URL 환경변수 검증 |
| `src/lib/drizzle/schema.ts` | 기존 Supabase 테이블의 TypeScript 스키마 |
| `src/lib/drizzle/client.ts` | postgres.js + Drizzle 인스턴스 팩토리 |
| `src/lib/drizzle/index.ts` | 공개 API |
| `drizzle.config.ts` | drizzle-kit introspect 전용 설정 |
| `.env.example` | 환경변수 템플릿 |
| `supabase/migrations/*.sql` | 스키마 단일 진실 공급원 |
| `docs/architecture/development-rules.md` | 스택 고정값 |
| `docs/architecture/nextjs-best-case-rules.md` | DATA-003 Drizzle 사용 경계 |
| `docs/architecture/current-implemented-structure.md` | 구조 스냅샷 |
| `tests/drizzle-adoption-contract.test.mjs` | 계약 테스트 |
