# Backend Agents (Dashboard Template Plugin)

> 이 문서는 프로젝트의 백엔드 관련 에이전트를 안내합니다.
> 실제 에이전트 정의는 `.claude/plugins/local/dashboard-template/agents/`에 있습니다.

## backend-architect (읽기 전용)

| 항목 | 값 |
|------|-----|
| **파일** | `.claude/plugins/local/dashboard-template/agents/backend-architect.md` |
| **역할** | API 라우트, SQL 마이그레이션, RLS 정책 리뷰 |
| **도구** | `Read`, `Grep`, `Glob`, `Bash` |
| **모델** | inherit |
| **색상** | yellow |
| **적용 규칙** | API-001~004, SB-001~004, DATA-001~006 |

코드를 수정하지 않고 리뷰만 수행한다.

**호출 방법:**
```
Claude Code: /dashboard-template:review-backend
Codex: /dashboard-template-review-backend
```

Codex에서는 별도 에이전트를 설치하지 않고, 동일 규칙을 읽는 로컬 프롬프트가 리뷰를 수행한다.

## fullstack-dev (구현 에이전트)

| 항목 | 값 |
|------|-----|
| **파일** | `.claude/plugins/local/dashboard-template/agents/fullstack-dev.md` |
| **역할** | 프론트엔드 + 백엔드 기능 구현 |
| **도구** | 모든 도구 |
| **모델** | inherit |
| **색상** | green |
| **적용 규칙** | PERF, COMP, UI, API, SB, DATA 전체 |

백엔드 구현이 필요한 경우 이 에이전트가 담당한다.

**자동 트리거 예시:**
```
"학생 테이블 마이그레이션이랑 API 만들어줘"
→ fullstack-dev 에이전트 자동 선택
```
