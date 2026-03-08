# 외부 UI 리소스 가이드

ui-designer 플러그인이 참조하는 외부 리소스 목록과 사용 정책.

## 아이콘 정책

### 기본: Lucide (필수)

특별한 요청이 없으면 **항상 Lucide 아이콘을 사용**한다.

- 패키지: `lucide-react`
- 공식 사이트: https://lucide.dev/
- 설치: `npx shadcn@latest add [component]` 시 자동 포함 (shadcn/ui 기본 의존성)
- 사용: `import { IconName } from 'lucide-react'`

### 대안 아이콘 (사용자가 명시적으로 요청한 경우에만)

| 라이브러리 | 패키지 | 사용 시기 |
|-----------|--------|----------|
| Radix Icons | `@radix-ui/react-icons` | Radix 원본 디자인 필요 시 |
| Heroicons | `@heroicons/react` | Tailwind UI 기반 디자인 시 |
| Phosphor Icons | `@phosphor-icons/react` | 다양한 weight 옵션 필요 시 |

---

## 외부 템플릿 & 블록 리소스

### 특수 페이지용 외부 리소스 (사용자가 직접 탐색 후 적용 요청)

| 사이트 | URL | 특징 | 적합한 경우 |
|--------|-----|------|------------|
| Vercel Templates | https://vercel.com/templates | Next.js 공식 템플릿 | 풀 페이지 구조 참고 |
| shadcnblocks | https://www.shadcnblocks.com/ | shadcn 기반 섹션 블록 | 랜딩 섹션 조합 |
| shadcn/ui Blocks | https://ui.shadcn.com/blocks | 공식 블록 컬렉션 | 표준 UI 패턴 |
| shadcnui-blocks | https://www.shadcnui-blocks.com/ | 커뮤니티 블록 | 다양한 변형 |

### batchtool 리소스 (선택적 리서치)

| 사이트 | URL | 특징 | 리서치 시기 |
|--------|-----|------|------------|
| shadcn batchtool | https://shadcn.batchtool.com/ | shadcn 확장 컴포넌트 | UI 설계 구조 참고 필요 시 |

사용자가 원하는 UI를 위 사이트에서 직접 찾은 후 URL 또는 컴포넌트 이름을 제공하면 프로젝트 맥락에 맞게 구현한다.
