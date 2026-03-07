# Frontend Agents (Dashboard Template Plugin)

> 이 문서는 프로젝트의 프론트엔드 관련 에이전트를 안내합니다.
> 실제 에이전트 정의는 `.claude/plugins/local/dashboard-template/agents/`에 있습니다.

## frontend-architect (읽기 전용)

| 항목 | 값 |
|------|-----|
| **파일** | `.claude/plugins/local/dashboard-template/agents/frontend-architect.md` |
| **역할** | React/Next.js 코드 리뷰 |
| **도구** | `Read`, `Grep`, `Glob`, `Bash` |
| **모델** | inherit |
| **색상** | cyan |
| **적용 규칙** | PERF-001~004, COMP-001~004, UI-001~004 |

코드를 수정하지 않고 리뷰만 수행한다.

**호출 방법:**
```
Claude Code: /dashboard-template:review-frontend
Codex: /dashboard-template-review-frontend
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

프론트엔드 구현이 필요한 경우 이 에이전트가 담당한다.

**자동 트리거 예시:**
```
"CRM 대시보드 페이지 만들어줘"
→ fullstack-dev 에이전트 자동 선택
```
