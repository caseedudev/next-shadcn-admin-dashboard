ui-designer local plugin 을 수정하고 싶어 

ui-designer-ui-research 외부 UI 리소스를 리서치하여 프로젝트에 맞는 템플릿, 블록, 컴포넌트를 추천하는 부분은 제거 하고 필요하다면 직접 제시할 거야
ui-designer-ui-template-scout, ui-designer-ui-component-scout 는 ui-designer 스킬에서 제거해줘 

ui-designer local plugin 에서 ui-designer-ui-research, ui-designer-ui-template-scout, ui-designer-ui-component-scout 를 이용해 외부 UI 리소스를 리서치하여 프로젝트에 맞는 템플릿, 블록, 컴포넌트를 추천하는 부분은 토큰 소모도 심하고 designer 정확도도 많이 떨어지지 않아?
이 부분은 제거하는게 좋을지 plugin-dev로 검토해줘.

---

대신 아래의 스킬들을 분석한다음 이 스킬들을 적극 활용해서 UI design 에 대해서 전혀 모르는 사람도 이 Plugin 만 사용하면 
UI Designer 을 잘 하고 추천/제안을 적극적으로 잘 할 수 있도록 ui-designer local plugin 을 개선해줘

- https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design
- web-design-guidelines

최대한 적극적인 질문과 추천/제안을 제시하고 Plugin 사용자의 선택과 답변을 통해 AI 멋대로 추상적인 판단을 하는 것 또는 모호한 선택의 간극을 줄이고 사용자가 제안해주는 내용을 선택하는 것 만으로도 완벽한 UI Design 을 완성할 수 있도록 도울 수 있는 Plugin 으로 개선시키고 싶어

아래와 같이 굉장히 다양한 디자인 컨셉도 제안해서 훨씬 풍부하고 스타일리쉬하고 명확한 UI Design 을 할 수 있도록 해줘

디자인 컨셉 Glassmorphism, Monochrome

plugin-dev 스킬을 통해 Claude Code 에 완벽히 동작하는 plugin 을 계획하고 만들어주고 .codex, .agnet, AGENTS.md 도 업데이트해서 codex, antigravity 에서도 잘 적용해서 사용할 수 있도록 해줘

---

ClaudeCode 용 ui-designer local plugin 을 수정했는데 설치해서 잘 사용할 수 있는지 직접 설치해서 테스트 실행 하면서 
아래의 기능들이 모두 제대로 설치되고 동작하는지 검증하고 문제가 있는 부분 파악해서 계획을 세우고 수정/보완 해줘 

사용 가능한 ui-designer 커맨드 정리:                                                                                                                                   
                                               
  ┌──────────────────────────┬────────────────────────────────────────────────────┐                                                                                                
  │          커맨드          │                        용도                        │
  ├──────────────────────────┼────────────────────────────────────────────────────┤
  │ /ui-designer-ui-analyze  │ 프로젝트 UI 구조 분석 → .ui-designer/analysis.json │
  ├──────────────────────────┼────────────────────────────────────────────────────┤
  │ /ui-designer-ui-design   │ UI 페이지 설계 및 구현 (전체 워크플로우)           │
  ├──────────────────────────┼────────────────────────────────────────────────────┤
  │ /ui-designer-ui-validate │ 플러그인 구조/데이터/동기화 검증 (7 Step)          │
  ├──────────────────────────┼────────────────────────────────────────────────────┤
  │ /ui-designer-ui-qa       │ 전체 기능 QA (7 Test, 체크리스트 포함)             │
  └──────────────────────────┴────────────────────────────────────────────────────┘

  QA 프롬프트 특히 살펴볼 부분:

  - Test 1.2 (산업별 추론): industries.csv ID 참조가 올바르게 동작하는지 — 이전에 531개 ID 불일치를 수정한 부분
  - Test 3.3 (디자인 컨셉 Q3→Q3-1→Q3.5→Q3.6): search.py가 각 단계에서 올바르게 호출되는지
  - Test 4.1 (안티패턴): 의도적 bad 코드에서 모든 패턴이 감지되는지
  - Test 5 (영속성): --persist Master + Page override 계층형 저장
  - Test 7.7 (CSV 참조 무결성): industries→styles/colors/fonts 교차 참조 0 오류 확인

  Codex에서 실행: CODEX_HOME=".codex" codex 후 /ui-designer-ui-qa --all