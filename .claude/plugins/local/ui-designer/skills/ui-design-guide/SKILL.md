---
name: ui-design-guide
description: >
  This skill should be used when the user asks to "create a page", "make a UI",
  "design a layout", "add a section", "build a landing page", "create a dashboard",
  "make a settings page", "add a hero section", or mentions UI-related terms like
  "페이지 만들어줘", "UI 수정", "레이아웃 변경", "섹션 추가", "화면 구성",
  "대시보드 만들어줘", "로그인 페이지 만들어줘", "폼 추가해줘".
  Provides project-aware UI component recommendations, layout design, and code generation
  through an interactive Q&A workflow.
version: 0.1.0
---

# UI Design Guide

프로젝트 분석 데이터와 컴포넌트 카탈로그를 기반으로 UI 페이지를 설계하고 구현하는 가이드.
추상적 추천이 아닌, 현재 프로젝트의 구조/스타일/컨벤션에 맞춘 구체적 설계를 제공한다.

## 워크플로우 개요

4단계로 진행한다. 어떤 단계도 건너뛰지 않는다.

```
[0단계: 프로젝트 분석] → [1단계: 요구사항 수집] → [2단계: 설계 제안] → [3단계: 코드 생성]
```

## 0단계: 프로젝트 분석 확인

프로젝트 루트에서 `.ui-designer/analysis.json` 파일을 확인한다.

**파일이 존재하면**: 분석 데이터를 로드하고 1단계로 진행한다.

**파일이 없으면**: 사용자에게 안내한다:
> "프로젝트 UI 구조를 먼저 분석해야 합니다. `/ui-analyze`를 실행해주세요."

분석 데이터에서 확인할 항목:
- `project.framework`, `project.uiLibrary`, `project.styling` — 기술 스택
- `components.shadcn`, `components.custom` — 사용 중인 컴포넌트
- `layout.pattern` — 기존 레이아웃 구조
- `style.colors`, `style.borderRadius`, `style.darkMode` — 스타일 컨벤션
- `patterns` — 반복 사용되는 UI 패턴

## 1단계: 요구사항 수집 (인터랙티브 Q&A)

### 1.1 페이지 유형 판별

사용자 요청에서 페이지 유형을 판별한다. `references/page-templates.md`의 빠른 참조 표를 사용한다.

| 키워드 | 유형 |
|--------|------|
| landing, 랜딩, 홈페이지, hero, 마케팅 | Landing |
| dashboard, 대시보드, 현황 | Dashboard |
| settings, 설정, 환경설정 | Settings |
| login, 로그인, 회원가입, auth | Auth |
| 목록, 리스트, 게시판, CRUD | CRUD List |
| 상세, detail, 프로필 | Detail |
| pricing, 요금, 가격 | Pricing |
| form, 폼, 입력, 등록 | Form |

유형이 불명확하면 사용자에게 확인한다.

### 1.2 Q&A 진행

`references/qa-templates.md`에서 해당 유형의 질문 목록을 로드한다.

**질문 형식 규칙** (반드시 준수):
```
**Q[N]. [질문]**

> [왜 이 질문이 중요한지 1-2줄 설명]

★ **추천**: [분석 데이터 기반 추천. 추천 이유 1줄]

  a) [옵션] — [간단 설명]
  b) [옵션] — [간단 설명]
  c) [옵션] — [간단 설명]
  d) 직접 입력
```

**진행 순서**:
1. 공통 질문 (Q1~Q4: 타겟, 레이아웃 관계, 톤앤매너, 에셋)
2. 해당 유형 전용 질문

**"추천대로" 처리**:
- 사용자가 "추천대로", "추천대로 해줘", "알아서 해줘"라고 응답하면 모든 질문의 ★ 추천을 일괄 적용한다.
- 개별 질문에 "추천"이라고 답해도 해당 질문의 ★ 추천을 적용한다.

**★ 추천 작성 규칙**:
- analysis.json의 기존 프로젝트 데이터를 반영한다 (기존 스타일, 컬러, 패턴)
- 업계 일반 사례와 실무 경험을 결합한다
- 추천 이유를 1줄로 간결하게 설명한다

## 2단계: 설계 제안

모든 Q&A가 완료되면 구체적 설계안을 제시한다.

### 2.1 컴포넌트 선택

`references/component-catalog.md`에서 적합한 컴포넌트를 선택한다.

확인 사항:
- `use-when` 조건과 사용자 요구사항 매칭
- `avoid-when` 조건에 해당하지 않는지 확인
- `pairs-with`로 자연스러운 조합 구성
- `shadcn-mapping`으로 실제 구현 컴포넌트 확인

### 2.2 레이아웃 설계

`references/layout-patterns.md`에서 적합한 레이아웃 패턴을 선택한다.
`references/page-templates.md`에서 해당 유형의 표준 구성을 참조한다.

### 2.3 설계안 제시 형식

```
📋 [페이지명] 설계안

레이아웃: [패턴명] ([설명])
┌─────────────────────────┐
│ [ASCII 스켈레톤]          │
└─────────────────────────┘

컴포넌트:
 • [컴포넌트명] — [역할] (shadcn: [매핑])
 • ...

파일 구조:
 • [경로/파일명] — [역할]
 • ...

스타일:
 • 기존 프로젝트 스타일 유지: [구체적 항목]
 • 추가 스타일: [필요한 경우]
```

설계안 제시 후 **반드시 사용자 승인을 받는다**. 수정 요청이 있으면 반영 후 재제시한다.

## 3단계: 코드 생성

사용자 승인 후 코드를 생성한다.

### 3.1 생성 규칙

- analysis.json의 기존 패턴/컨벤션을 준수한다 (import 경로, 네이밍, 디렉토리 구조)
- `references/design-principles.md`의 정적 원칙을 적용한다
- 기존 프로젝트에서 사용 중인 shadcn 컴포넌트를 우선 활용한다
- 새로운 shadcn 컴포넌트가 필요하면 설치 명령을 안내한다

### 3.2 코드 검증

코드 생성 완료 후 `references/design-principles.md`의 Part 2를 참조하여 검증한다:

1. WebFetch로 Vercel Web Interface Guidelines 최신본을 가져온다
   - URL: `https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md`
2. 생성된 코드와 가이드라인을 대조한다
3. 위반 사항이 있으면 자동 수정한다
4. 검증 결과를 보고한다:
   ```
   ✅ 접근성: 시맨틱 HTML, alt 속성 포함
   ✅ 키보드: Tab 순서 논리적
   ⚠️ 수정: [수정 내용]
   ```

### 3.3 결과 제시

- 생성된 파일 목록과 변경 사항 요약
- 새로 설치해야 할 패키지/컴포넌트 안내
- 추가로 고려할 사항 (데이터 연동, API 등)

## 참조 문서

### Reference Files

설계 과정에서 필요에 따라 다음 문서를 참조한다:

- **`references/component-catalog.md`** — 58종 컴포넌트 의사결정 가이드. 컴포넌트 선택 시 use-when/avoid-when/pairs-with/shadcn-mapping 확인.
- **`references/layout-patterns.md`** — 그리드, 반응형, 섹션 배치, 6종 레이아웃 패턴, 간격 체계. 레이아웃 설계 시 참조.
- **`references/page-templates.md`** — 8종 페이지 유형별 표준 구성. 섹션 순서, ASCII 스켈레톤, shadcn 매핑, Next.js 파일 구조.
- **`references/qa-templates.md`** — 페이지 유형별 인터랙티브 질문 템플릿. Q&A 진행 시 반드시 이 형식을 따른다.
- **`references/design-principles.md`** — 시각적 계층, 일관성, 반응형, 컬러, 타이포그래피, 인터랙션 원칙 + Vercel Guidelines 검증.

### 프로젝트 분석 데이터

- **`.ui-designer/analysis.json`** — 현재 프로젝트의 라우트, 컴포넌트, 레이아웃, 스타일, 패턴 분석 결과.

## 핵심 원칙

1. **프로젝트 맥락 우선**: 추상적 추천이 아닌 analysis.json 기반 구체적 추천
2. **모호함 제거**: Q&A로 모든 불확실성을 해소한 후 설계
3. **승인 후 실행**: 설계안을 반드시 사용자에게 보여주고 승인받은 후 코드 생성
4. **일관성 유지**: 기존 프로젝트의 스타일/패턴/컨벤션과 일관되게
5. **검증 후 제출**: 생성된 코드를 디자인 원칙과 Web Interface Guidelines로 검증
