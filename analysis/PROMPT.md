
```
[$vercel-react-best-practices](/Users/freelife/.agents/skills/vercel-react-best-practices/SKILL.md)
이 프로젝트를 분석해서 기본 next.js 보일러플레이트에서 어떤 부분이 추가 되어있는지 
어떤 모듈과 어떤 컴포넌트들이 추가되어있는지 이 템플릿 프로젝트로 개발을 시작하면 어떤 점이 좋은지 분석해서 analysis 디렉토리에 분석된 정보를 문서로 정리해줘
```

```
[$superpowers-lab](/Users/freelife/.codex/skills/superpowers-lab/SKILL.md)
이 Template 로 OpenSpec 을 사용해서 Claude Code 로 학원용 SaaS 서비스 개발을 시작하려고 하는데 
이 Template 는 shadcn/ui, zustand, Supabase 이런 best 구성 설정들이 모두 포함되어있는지 확인해줘 
그리고 아이콘 패키지는 어떤걸 사용중이야? Lucide 는 아니야?
여기에 어떤 구성을 추가하면 좋을지 [$vercel-react-best-practices](/Users/freelife/.agents/skills/vercel-react-best-practices/SKILL.md) 스킬로 검토해줘
```

사용 스킬: Superpowers Lab(요청된 스킬 컨텍스트 반영), Vercel React Best Practices(성능/구조 관점 점검).

확인 결과 요약입니다.

1. 포함 여부
    - shadcn/ui: 포함됨. components.json + src/components/ui에 56개 UI 컴포넌트가 구성되어 있습니다.  
        근거: [components.json](app://-/index.html?hostId=local#), [src/components/ui](app://-/index.html?hostId=local#)
    - zustand: 포함되고 실제 사용 중입니다.  
        근거: [package.json](app://-/index.html?hostId=local#), [preferences-store.ts](app://-/index.html?hostId=local#), [preferences-provider.tsx](app://-/index.html?hostId=local#)
    - Supabase: 현재 **미포함**입니다. 의존성/코드에서 @supabase/*, supabase 사용 흔적이 없습니다.  
        근거: [package.json](app://-/index.html?hostId=local#)
2. 아이콘 패키지
    - 메인은 **Lucide 맞습니다**. lucide-react를 광범위하게 사용 중입니다.
    - 추가로 브랜드 아이콘용 simple-icons도 사용합니다.  
        근거: [package.json](app://-/index.html?hostId=local#), [simple-icon.tsx](app://-/index.html?hostId=local#)
3. 학원용 SaaS 시작 시 추가 추천 (Vercel Best Practices 기준)
    - Supabase SSR 정식 도입:
        - @supabase/supabase-js, @supabase/ssr 추가
        - 서버 액션/라우트 핸들러에서 인증 검증 강제 (server-auth-actions)
        - 멀티테넌트 + RLS 정책(학원/지점/강사/학생 권한)
    - 데이터 접근 계층 분리:
        - DB 접근 함수를 React.cache()로 요청 내 dedup (server-cache-react)
        - 독립 조회는 Promise.all 병렬화 (async-parallel)
    - 대시보드 번들 최적화:
        - 차트/대형 테이블를 next/dynamic으로 지연 로드 (bundle-dynamic-imports)
        - 사용하지 않는 페이지 기능은 조건부 로드 (bundle-conditional)
    - Suspense 스트리밍 적용:
        - KPI 카드/차트/리스트를 경계 분리해 초기 응답 가속 (async-suspense-boundaries)
    - 현재 미사용 의존성 정리:
        - @tanstack/react-query, axios는 아직 사용 흔적이 없어
        - 실제 사용할 계획이 없으면 제거해 번들/복잡도 축소 (bundle-*)
    - 클라이언트 저장소 스키마 버저닝:
        - 현재 preference 저장 로직에 버전 키 도입 (client-localstorage-schema)

원하면 다음 단계로, 제가 이 템플릿에 맞춰 “OpenSpec + Supabase + RLS + App Router” 초기 골격(폴더/환경변수/클라이언트 생성/auth 가드)까지 바로 세팅해드릴게요.


```
이 템플릿의 UI는 shadcn/ui, tailwindCSS 기반으로 마음대로 수정하고 관련된 컴포넌트나 UI 추가해서 적용해도되지?
```

네, 됩니다. 이 템플릿은 원래 그 용도로 쓰는 구조예요.

- shadcn/ui 컴포넌트는 “프로젝트 내부 코드”라서 자유롭게 수정/복제/확장 가능합니다.
- Tailwind CSS 기반이라 클래스/토큰/CSS 변수(globals.css, 프리셋 CSS)도 원하는 대로 바꿔도 됩니다.
- 새 UI 컴포넌트 추가해서 페이지에 붙이는 것도 문제없습니다.

권장만 드리면:

- 공통 재사용 컴포넌트는 /Users/freelife/vibe/templates/next-shadcn-admin-dashboard/src/components/ui에,
- 도메인 전용 컴포넌트는 각 라우트의 _components에 두면 유지보수가 편합니다.
- upstream 템플릿 업데이트를 받을 계획이면, 많이 커스텀한 파일은 충돌 가능성만 염두에 두면 됩니다.