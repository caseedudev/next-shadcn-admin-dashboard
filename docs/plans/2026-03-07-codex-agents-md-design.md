# Codex CLI용 AGENTS.md 변환 설계

## 목표

dashboard-template-plugin의 아키텍처 규칙을 Codex CLI가 자동 로드하는 AGENTS.md로 변환

## 접근 방식

방식 A: 프로젝트 루트에 단일 AGENTS.md 생성

## 포함 내용

- Project Overview + Tech Stack
- Build & Test Commands
- Project Structure (ARCH-001~003)
- Frontend Rules: PERF, COMP, UI (MUST만)
- Backend Rules: API, SB, DATA (MUST만)
- Boundaries (Must/Must Not)

## 제외 항목

- SHOULD 규칙 (크기 최적화)
- 에이전트/스킬/훅 정의 (Codex 미지원)
- 외부 스킬 참조
