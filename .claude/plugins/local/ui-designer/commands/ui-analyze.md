---
name: ui-analyze
description: "현재 프로젝트의 UI 구조를 분석하고 .ui-designer/analysis.json에 저장."
argument-hint: "[--refresh]"
---

# UI Analyze

현재 프로젝트의 UI 구조를 체계적으로 분석하고 `.ui-designer/analysis.json`에 저장한다.

## 실행 조건

- **인자 없음**: `.ui-designer/analysis.json`이 이미 존재하면 기존 분석 결과를 보여준다. 없으면 새로 분석한다.
- **--refresh**: 기존 분석을 무시하고 새로 분석한다.

## 분석 절차

ui-analyzer 서브에이전트를 호출하여 다음 항목을 분석한다:

### 1. 프로젝트 기본 정보
- `package.json` 확인 → 프레임워크, UI 라이브러리, 스타일링 도구 판별
- Next.js App Router / Pages Router 구분

### 2. 라우트 맵
- `app/` 디렉토리 스캔 → 모든 라우트 경로 수집
- 각 라우트의 페이지 유형 판별 (dashboard, settings, auth 등)
- 라우트 그룹 구조 분석 ((dashboard), (marketing) 등)

### 3. 컴포넌트 인벤토리
- `components/ui/` 스캔 → 설치된 shadcn/ui 컴포넌트 목록
- `components/` 전체 스캔 → 커스텀 컴포넌트 목록
- 각 컴포넌트의 사용 빈도 (import 횟수)

### 4. 레이아웃 패턴
- `layout.tsx` 파일 분석 → 사이드바/헤더/콘텐츠 구조
- 사이드바 너비, 헤더 높이, 콘텐츠 영역 설정
- 접을 수 있는 사이드바 여부

### 5. 스타일 컨벤션
- `tailwind.config.ts` 분석 → 커스텀 컬러, 브레이크포인트, 폰트
- `globals.css` 분석 → CSS 변수 (--primary, --radius 등)
- 다크 모드 지원 여부
- border-radius, 간격 패턴

### 6. 반복 UI 패턴
- 데이터 표시 패턴 (테이블, 카드, 리스트)
- 폼 패턴 (카드 래핑, 섹션 구분)
- 네비게이션 패턴 (사이드바 그룹, 탭)

## 결과 저장

분석 결과를 `.ui-designer/analysis.json`에 저장한다:

```json
{
  "analyzedAt": "ISO 8601 datetime",
  "project": {
    "framework": "next.js",
    "uiLibrary": "shadcn/ui",
    "styling": "tailwind"
  },
  "routes": [
    { "path": "/dashboard", "type": "dashboard", "components": ["Card", "Table"] }
  ],
  "components": {
    "shadcn": ["Button", "Card", "Table", "Sidebar", "Dialog"],
    "custom": ["ThemeSwitch", "SearchInput"]
  },
  "layout": {
    "pattern": "sidebar-header-content",
    "sidebar": { "width": "w-64", "collapsible": true },
    "header": { "fixed": true, "height": "h-16" },
    "content": { "maxWidth": "max-w-7xl", "padding": "p-6" }
  },
  "style": {
    "colors": { "primary": "hsl(...)", "radius": "0.5rem" },
    "borderRadius": "rounded-lg",
    "darkMode": true
  },
  "patterns": {
    "dataDisplay": "table-with-toolbar",
    "forms": "card-wrapped-sections",
    "navigation": "sidebar-with-groups"
  }
}
```

## 결과 출력

분석 완료 후 사용자에게 요약을 보여준다:

```
프로젝트 분석 완료

기술 스택: Next.js + shadcn/ui + Tailwind CSS
라우트: [N]개 페이지 발견
shadcn 컴포넌트: [N]개 설치됨
레이아웃: [패턴 설명]
스타일: [주요 특징]

분석 결과가 .ui-designer/analysis.json에 저장되었습니다.
이제 /ui-design 으로 UI 설계를 시작할 수 있습니다.
```
