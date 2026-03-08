# 제네릭 AI 안티패턴 가이드

> AI가 생성하는 코드에서 흔히 발견되는 30개 안티패턴과 대안.
> Anthropic의 frontend-design 플러그인의 "제네릭 AI 미학 거부" 철학 기반.
> CSV 검색 엔진이 없는 환경(Codex, Antigravity)에서 참조하는 마크다운 폴백.
> 검색 엔진 사용 가능 시: `python3 scripts/search.py --check-anti-patterns <file>`

---

## 심각도 범례

- 🔴 **HIGH**: 즉시 수정 필요. 디자인 품질에 심각한 영향
- 🟡 **MEDIUM**: 권장 수정. 개선하면 품질 향상
- 🟢 **LOW**: 참고 사항. 컨텍스트에 따라 허용 가능

---

## 요약 테이블

| # | 이름 | 카테고리 | 심각도 |
|---|------|---------|--------|
| 1 | Generic Purple Gradient (보라색 그래디언트 남용) | color | 🔴 HIGH |
| 2 | Hardcoded White Background (하드코딩 흰색) | color | 🔴 HIGH |
| 3 | Hardcoded Black Text (하드코딩 검정) | color | 🔴 HIGH |
| 4 | Neon on Light Background (밝은 배경에 네온) | color | 🟡 MEDIUM |
| 5 | Rainbow Color Overload (무지개 색 남용) | color | 🟡 MEDIUM |
| 6 | Low Contrast Text (낮은 대비 텍스트) | color | 🔴 HIGH |
| 7 | Default Blue-500 (기본 blue-500) | color | 🟡 MEDIUM |
| 8 | No Dark Mode Support (다크모드 미대응) | color | 🟡 MEDIUM |
| 9 | Generic Inter Only (Inter 기본 폰트) | typography | 🟡 MEDIUM |
| 10 | Excessive Bold Text (전체 볼드) | typography | 🟡 MEDIUM |
| 11 | Tiny Important Text (중요 텍스트 너무 작음) | typography | 🟡 MEDIUM |
| 12 | Missing Heading Hierarchy (제목 계층 없음) | typography | 🔴 HIGH |
| 13 | Inconsistent Font Sizes (폰트 크기 불일치) | typography | 🟡 MEDIUM |
| 14 | Wall of Text (텍스트 벽) | typography | 🟢 LOW |
| 15 | System Font Only (시스템 폰트만 사용) | typography | 🟢 LOW |
| 16 | Symmetric Hero Layout (좌우 대칭 Hero) | layout | 🟡 MEDIUM |
| 17 | Everything Centered (전부 중앙 정렬) | layout | 🟡 MEDIUM |
| 18 | No Visual Hierarchy (시각 계층 없음) | layout | 🔴 HIGH |
| 19 | Padding Inconsistency (패딩 불일치) | layout | 🟡 MEDIUM |
| 20 | No Responsive Breakpoints (반응형 없음) | layout | 🔴 HIGH |
| 21 | Sidebar Too Wide (사이드바 과도) | layout | 🟢 LOW |
| 22 | Content Too Narrow (콘텐츠 너무 좁음) | layout | 🟡 MEDIUM |
| 23 | Grid Overuse (그리드 남용) | layout | 🟢 LOW |
| 24 | Transition All Abuse (transition-all 남용) | animation | 🟡 MEDIUM |
| 25 | Too Many Animations (애니메이션 과다) | animation | 🟡 MEDIUM |
| 26 | No Reduced Motion Support (모션 감소 미대응) | animation | 🔴 HIGH |
| 27 | Jarring Entrance Animation (급격한 등장) | animation | 🟡 MEDIUM |
| 28 | Lorem Ipsum Left In (Lorem ipsum 방치) | general | 🔴 HIGH |
| 29 | Missing Empty State (빈 상태 없음) | general | 🔴 HIGH |
| 30 | No Loading State (로딩 상태 없음) | general | 🔴 HIGH |

---

## 컬러 안티패턴 (8개)

### 🔴 Generic Purple Gradient (보라색 그래디언트 남용)

- **탐지 패턴**: `bg-gradient-to-r from-purple.*to-pink|from-violet.*to-fuchsia`
- **문제**: Purple-to-pink gradients are the most overused AI-generated design pattern. They signal zero design intent and make every app look identical.
- **대안**: Use brand-specific gradient tokens or subtle single-hue gradients with CSS variables

---

### 🔴 Hardcoded White Background (하드코딩 흰색)

- **탐지 패턴**: `bg-white[^""]*""[^>]*>`
- **문제**: Hardcoded bg-white without dark: variant breaks dark mode and couples your UI to a specific theme. Always use semantic color tokens.
- **대안**: Use bg-background or bg-card semantic tokens from your design system

---

### 🔴 Hardcoded Black Text (하드코딩 검정)

- **탐지 패턴**: `text-black[^""]*""[^>]*>`
- **문제**: Hardcoded text-black without dark: variant breaks dark mode and ignores accessibility contrast requirements across themes.
- **대안**: Use text-foreground or text-muted-foreground semantic tokens

---

### 🟡 Neon on Light Background (밝은 배경에 네온)

- **탐지 패턴**: `text-(lime|green|cyan|emerald)-(300|400).*bg-(white|gray-50|slate-50)`
- **문제**: Neon/bright accent colors on light backgrounds create poor contrast ratios and strain readability.
- **대안**: Use darker shade variants (600-700) for text on light backgrounds or reserve neon for dark themes only

---

### 🟡 Rainbow Color Overload (무지개 색 남용)

- **탐지 패턴**: `(text|bg|border)-(red|orange|yellow|green|blue|purple|pink)-.*(text|bg|border)-(red|orange|yellow|green|blue|purple|pink)-.*(text|bg|border)-(red|orange|yellow|green|blue|purple|pink)-`
- **문제**: Using 5+ distinct color families in one component creates visual chaos and undermines brand coherence.
- **대안**: Limit palette to 2-3 color families max per component and derive shades from CSS custom properties

---

### 🔴 Low Contrast Text (낮은 대비 텍스트)

- **탐지 패턴**: `text-(gray|slate|zinc)-(300|400).*bg-(white|gray-50|slate-50)|text-(gray|slate|zinc)-(300|400)[^""]*""`
- **문제**: Light gray text on white or near-white backgrounds fails WCAG AA contrast requirements and is unreadable for many users.
- **대안**: Use text-muted-foreground (min 4.5:1 contrast) or check with WCAG contrast checker before shipping

---

### 🟡 Default Blue-500 (기본 blue-500)

- **탐지 패턴**: `(bg|text|border)-blue-500`
- **문제**: Using raw Tailwind blue-500 instead of semantic tokens makes theming impossible and screams default template.
- **대안**: Define primary color as a CSS variable (--primary) and use bg-primary/text-primary tokens

---

### 🟡 No Dark Mode Support (다크모드 미대응)

- **탐지 패턴**: `(bg|text)-(white|black|gray-[0-9]+).*""[^""]*$`
- **문제**: Components without any dark: variants break in dark mode and show you skipped half the design work.
- **대안**: Add dark: variants for all color utilities or use semantic tokens that auto-adapt

---

## 타이포그래피 안티패턴 (7개)

### 🟡 Generic Inter Only (Inter 기본 폰트)

- **탐지 패턴**: `font-family:.*Inter[^,]*[;"']|fontFamily.*['"]Inter['"]`
- **문제**: Inter is the default AI-generated font choice. Add at least a custom display/heading font to create visual identity.
- **대안**: Configure a distinctive display font pairing in tailwind.config and use font-heading/font-body tokens

---

### 🟡 Excessive Bold Text (전체 볼드)

- **탐지 패턴**: `(font-bold|font-semibold).*(font-bold|font-semibold).*(font-bold|font-semibold)`
- **문제**: When everything is bold nothing stands out. Over-bolding flattens visual hierarchy and fatigues readers.
- **대안**: Use font-bold sparingly for emphasis only; rely on font-size and color for hierarchy instead

---

### 🟡 Tiny Important Text (중요 텍스트 너무 작음)

- **탐지 패턴**: `text-xs[^""]*>(Price|Total|Error|Warning|Amount|Status|Balance)`
- **문제**: Important information like prices or error messages in text-xs is hard to read and signals low importance to users.
- **대안**: Use text-sm minimum for actionable or critical information; reserve text-xs for tertiary metadata only

---

### 🔴 Missing Heading Hierarchy (제목 계층 없음)

- **탐지 패턴**: `<h[3-6][> ]`
- **문제**: Skipping h1/h2 and jumping to h3/h4 without an h1/h2 present breaks document outline for screen readers and harms SEO.
- **대안**: Always start with h1 then h2 before using h3+; use a HeadingLevel context provider if needed

---

### 🟡 Inconsistent Font Sizes (폰트 크기 불일치)

- **탐지 패턴**: `text-(sm|base|lg)[^""]*>.*</.*>.*text-(sm|base|lg)[^""]*>.*</`
- **문제**: Same-role elements with different text sizes create visual noise and undermine design system consistency.
- **대안**: Define text size tokens per role (body/caption/label) in your design system and apply consistently

---

### 🟢 Wall of Text (텍스트 벽)

- **탐지 패턴**: `<p[^>]*class=""[^""]*"">[^<][^<][^<][^<][^<][^<][^<][^<][^<][^<]`
- **문제**: Long paragraphs without max-w-prose width constraints are unreadable. Limit line length to 45-75 characters.
- **대안**: Add max-w-prose (65ch) to text containers and break content into digestible paragraphs

---

### 🟢 System Font Only (시스템 폰트만 사용)

- **탐지 패턴**: `className=""[^""]*font-sans[^""]*""`
- **문제**: Relying solely on font-sans with no custom font configuration results in a generic look indistinguishable from any template.
- **대안**: Add a custom font in next/font and extend fontFamily in tailwind.config.ts

---

## 레이아웃 안티패턴 (8개)

### 🟡 Symmetric Hero Layout (좌우 대칭 Hero)

- **탐지 패턴**: `grid-cols-2.*hero|hero.*grid-cols-2|<section.*grid.*cols-2.*<img`
- **문제**: The 50/50 text-left image-right hero is the most cliched AI layout. Break symmetry to create visual interest.
- **대안**: Try asymmetric layouts (60/40 split) or full-bleed hero with overlapping elements for more visual interest

---

### 🟡 Everything Centered (전부 중앙 정렬)

- **탐지 패턴**: `(text-center.*\n.*){4,}|text-center.*text-center.*text-center.*text-center`
- **문제**: Centering every element creates a monotonous layout with poor readability for body text.
- **대안**: Left-align body text and use center only for headings or CTA sections; vary alignment for hierarchy

---

### 🔴 No Visual Hierarchy (시각 계층 없음)

- **탐지 패턴**: `(gap-4.*gap-4.*gap-4|space-y-4.*space-y-4.*space-y-4)`
- **문제**: Uniform spacing and sizing across all elements makes nothing stand out. Vary scale to guide the eye.
- **대안**: Vary spacing (gap-2/gap-6/gap-12) and element sizes to create clear primary/secondary/tertiary hierarchy

---

### 🟡 Padding Inconsistency (패딩 불일치)

- **탐지 패턴**: `p-[0-9]+.*p-[0-9]+.*p-[0-9]+`
- **문제**: Mixing p-4 p-6 p-8 on sibling elements at the same hierarchy level creates visual jitter and feels unpolished.
- **대안**: Define spacing tokens (sm/md/lg) and use consistent padding for same-level container elements

---

### 🔴 No Responsive Breakpoints (반응형 없음)

- **탐지 패턴**: `grid-cols-[0-9]+[^""]*""[^>]*>`
- **문제**: Grid layouts without sm:/md:/lg: responsive breakpoints break on mobile and show the layout was only tested at one size.
- **대안**: Add md: and lg: breakpoint variants for grid columns and padding; test at 375px/768px/1280px

---

### 🟢 Sidebar Too Wide (사이드바 과도)

- **탐지 패턴**: `(w-80|w-96|w-\[3[2-9][0-9]|w-\[4[0-9][0-9]).*sidebar|sidebar.*(w-80|w-96)`
- **문제**: Sidebars wider than 288px steal too much horizontal space from main content on standard laptop screens.
- **대안**: Keep sidebar width at w-64 (256px) max and use collapsible sidebar for extra content

---

### 🟡 Content Too Narrow (콘텐츠 너무 좁음)

- **탐지 패턴**: `max-w-(xs|sm).*main|main.*max-w-(xs|sm)`
- **문제**: Main content constrained to max-w-sm (384px) or smaller wastes screen space and forces excessive scrolling.
- **대안**: Use max-w-4xl or max-w-6xl for main content areas; reserve max-w-sm for cards or modals only

---

### 🟢 Grid Overuse (그리드 남용)

- **탐지 패턴**: `grid grid-cols-1 [^""]*gap`
- **문제**: Using grid-cols-1 for single-column layouts adds unnecessary complexity. Use flex-col or simple block layout.
- **대안**: Use flex for single-row layouts; reserve CSS grid for actual 2D grid patterns

---

## 애니메이션 안티패턴 (4개)

### 🟡 Transition All Abuse (transition-all 남용)

- **탐지 패턴**: `transition-all`
- **문제**: transition-all animates every CSS property including layout-triggering ones causing janky performance.
- **대안**: Use transition-colors or transition-opacity or transition-transform for the specific property animating

---

### 🟡 Too Many Animations (애니메이션 과다)

- **탐지 패턴**: `(animate-|motion-)(bounce|pulse|spin|ping|fade|slide|scale).*(animate-|motion-)(bounce|pulse|spin|ping|fade|slide|scale).*(animate-|motion-)(bounce|pulse|spin|ping|fade|slide|scale)`
- **문제**: Pages with 5+ simultaneous animations feel chaotic and distract from content. Animate with purpose.
- **대안**: Limit to 1-2 animations per viewport; use animation only to convey meaning not decoration

---

### 🔴 No Reduced Motion Support (모션 감소 미대응)

- **탐지 패턴**: `animate-(bounce|pulse|spin|ping|fade|slide|scale)`
- **문제**: Animations without prefers-reduced-motion check cause motion sickness for vestibular disorder users. Verify motion-reduce is paired.
- **대안**: Wrap animations in motion-safe: or add @media (prefers-reduced-motion: reduce) fallbacks

---

### 🟡 Jarring Entrance Animation (급격한 등장)

- **탐지 패턴**: `duration-(75|100)[^0-9]`
- **문제**: Ultra-fast entrance animations (75-100ms) appear as jarring flashes rather than smooth transitions.
- **대안**: Use duration-200 minimum for entrance animations; 300-500ms feels natural for most UI transitions

---

## 일반 안티패턴 (3개)

### 🔴 Lorem Ipsum Left In (Lorem ipsum 방치)

- **탐지 패턴**: `[Ll]orem [Ii]psum|dolor sit amet|consectetur adipiscing`
- **문제**: Lorem ipsum in production signals incomplete work and prevents testing real content layout edge cases.
- **대안**: Replace with real or realistic content; use faker/seed data for development placeholders

---

### 🔴 Missing Empty State (빈 상태 없음)

- **탐지 패턴**: `\.map\([^)]*=>`
- **문제**: Data lists using .map() without a corresponding empty state check show blank voids that confuse users.
- **대안**: Add explicit empty state UI with illustration and CTA when data array is empty (items.length === 0)

---

### 🔴 No Loading State (로딩 상태 없음)

- **탐지 패턴**: `(useQuery|useSWR|fetch\(|axios\.)`
- **문제**: Async data fetching calls without corresponding loading/skeleton state cause layout shifts and leave users staring at empty screens.
- **대안**: Add Skeleton components or loading spinners while async data is in flight; use Suspense boundaries
