# Supabase 로컬 개발 환경 가이드

## 사전 요구사항

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) 설치 및 실행
- Supabase CLI: `npm install -g supabase` 또는 `brew install supabase/tap/supabase`

## 빠른 시작

### 1. 로컬 Supabase 시작

```bash
supabase start
```

첫 실행 시 Docker 이미지를 다운로드하므로 시간이 걸릴 수 있다.
완료되면 로컬 서비스 URL과 키가 출력된다.

### 2. 환경변수 설정

```bash
cp .env.local.example .env.local
```

`supabase start` 출력의 `API URL`, `anon key`, `service_role key`로 `.env.local`을 업데이트한다.

### 3. 마이그레이션 적용

```bash
supabase db reset
```

이 명령은 로컬 DB를 초기화하고 `supabase/migrations/*.sql`을 순서대로 적용한 뒤 `supabase/seeds/*.sql`을 실행한다.

주의: 시드 실행 전에 `auth.users`에 테스트 사용자가 필요하다. Supabase Dashboard(http://127.0.0.1:54323)에서 수동 생성하거나, 시드 스크립트 실행 전에 아래 SQL로 생성한다:

```sql
-- Supabase Dashboard > SQL Editor에서 실행
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_user_meta_data)
VALUES (
  'a0000000-0000-0000-0000-000000000001',
  'owner@example.com',
  crypt('password123', gen_salt('bf')),
  now(),
  '{"full_name": "Test Owner"}'::jsonb
);
```

### 4. 개발 서버 시작

```bash
npm run dev
```

### 5. 로컬 대시보드

- Supabase Studio: http://127.0.0.1:54323
- Inbucket (이메일 확인): http://127.0.0.1:54324
- 앱: http://localhost:3000

## 마이그레이션 관리

### 새 마이그레이션 생성

```bash
supabase migration new <migration_name>
```

`supabase/migrations/` 아래에 타임스탬프 기반 SQL 파일이 생성된다.

### 마이그레이션 적용 확인

```bash
supabase db diff
```

로컬 DB와 마이그레이션 파일 간 차이를 확인한다.

## 종료

```bash
supabase stop
```

데이터를 유지하려면 `supabase stop`만, 완전 초기화는 `supabase stop --no-backup`을 사용한다.

## 문제 해결

| 증상 | 해결 |
|------|------|
| `supabase start` 실패 | Docker Desktop이 실행 중인지 확인 |
| 포트 충돌 | `supabase/config.toml`에서 포트 변경 |
| 시드 실패 | `auth.users`에 owner 계정이 있는지 확인 |
| 마이그레이션 순서 오류 | `supabase db reset`으로 전체 재적용 |
