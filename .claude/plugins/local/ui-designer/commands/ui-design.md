---
name: ui-design
description: "UI 페이지 설계 및 구현. 페이지 유형 또는 자연어 설명으로 시작."
argument-hint: "[landing|dashboard|settings|auth|crud|detail|pricing|form] 또는 자유 설명"
---

# UI Design 워크플로우

UI 페이지를 설계하고 구현하는 전체 워크플로우를 실행한다.

## 인자 파싱

사용자 인자를 분석한다:

- **유형 키워드** (landing, dashboard, settings, auth, crud, detail, pricing, form):
  해당 유형의 워크플로우를 즉시 시작한다.
- **자연어 설명** ("학원 SaaS Hero 섹션", "상품 비교 결제 페이지"):
  설명을 분석하여 적합한 페이지 유형을 판별하고, 사용자에게 확인한다.
- **인자 없음**: 어떤 페이지를 만들고 싶은지 대화형으로 질문한다.

## 실행 순서

### 1. 프로젝트 분석 확인

`.ui-designer/analysis.json` 파일을 확인한다.

- **존재하면**: 분석 데이터를 로드한다.
- **없으면**: ui-analyzer 서브에이전트를 호출하여 자동으로 분석을 실행한다.
  분석 완료 후 결과를 사용자에게 간단히 요약한다.

### 2. 인터랙티브 Q&A

ui-design-guide 스킬의 `references/qa-templates.md`에서 해당 유형의 질문 목록을 로드한다.

**질문 형식** (반드시 준수):
```
**Q[N]. [질문]**

> [설명]

★ **추천**: [추천 + 이유]

  a) [옵션] — [설명]
  b) [옵션] — [설명]
  c) [옵션] — [설명]
  d) 직접 입력
```

진행 순서:
1. 공통 질문 (타겟, 레이아웃 관계, 톤앤매너, 에셋)
2. 해당 유형 전용 질문

"추천대로" 응답 시 모든 ★ 추천을 일괄 적용한다.

### 3. 설계안 생성 및 제시

Q&A 완료 후 ui-consultant 서브에이전트를 호출하여 설계안을 생성한다.

설계안에 포함할 항목:
- 레이아웃 패턴 (ASCII 스켈레톤)
- 선택한 컴포넌트 목록 (shadcn 매핑 포함)
- Next.js 파일 구조
- 기존 프로젝트 스타일과의 일관성 설명

**반드시 사용자 승인을 받는다.** 수정 요청이 있으면 반영 후 재제시한다.

### 4. 코드 생성

승인된 설계안을 기반으로 코드를 생성한다.

- analysis.json의 기존 패턴/컨벤션 준수
- `references/design-principles.md`의 원칙 적용
- 생성 완료 후 Vercel Web Interface Guidelines로 검증
- 검증 결과와 변경 사항 요약을 사용자에게 보고

## 참조 리소스

이 커맨드는 ui-design-guide 스킬의 references/ 문서를 참조한다:
- `references/component-catalog.md` — 컴포넌트 선택
- `references/layout-patterns.md` — 레이아웃 설계
- `references/page-templates.md` — 페이지 표준 구성
- `references/qa-templates.md` — Q&A 질문 템플릿
- `references/design-principles.md` — 디자인 원칙 + 검증
