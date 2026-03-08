# 산업별 디자인 추론 규칙

> 96개 산업/제품 유형별 추천 스타일, 컬러, 폰트, 안티패턴.
> CSV 검색 엔진이 없는 환경(Codex, Antigravity)에서 참조하는 마크다운 폴백.
> 검색 엔진 사용 가능 시: `python3 scripts/search.py "query" --domain industry`

---

## 빠른 찾기

| 산업 | 한국어 | 추천 스타일 (1순위) | 데이터 밀도 |
|------|--------|------------------|-----------|
| SaaS | SaaS 일반 | minimalism | medium |
| Micro SaaS | 마이크로 SaaS | minimalism | low |
| E-commerce | 전자상거래 | flat-design | high |
| Luxury E-commerce | 럭셔리 전자상거래 | minimalism | low |
| Service Landing | 서비스 랜딩 | minimalism | low |
| B2B Service | B2B 서비스 | minimalism | medium |
| Financial Dashboard | 금융 대시보드 | flat-design | high |
| Analytics Dashboard | 분석 대시보드 | flat-design | high |
| Medical App | 의료 앱 | minimalism | medium |
| Education App | 교육 앱 | flat-design | medium |
| Creative Agency | 크리에이티브 에이전시 | brutalism | low |
| Portfolio | 포트폴리오 | minimalism | low |
| Gaming | 게임 | cyberpunk | medium |
| Government | 정부/공공 | flat-design | medium |
| Fintech | 핀테크 | minimalism | high |
| Social Media | 소셜 미디어 | flat-design | medium |
| Productivity | 생산성 도구 | minimalism | high |
| Design System | 디자인 시스템 | minimalism | high |
| AI Product | AI 제품 | glassmorphism | medium |
| NFT/Web3 | NFT/웹3 | cyberpunk | medium |
| Creator Economy | 크리에이터 이코노미 | glassmorphism | low |
| Sustainability | 지속가능성/ESG | minimalism | medium |
| Remote Work | 원격 근무 | minimalism | medium |
| Mental Health | 정신 건강 | soft-ui | low |
| Pet Tech | 펫테크 | flat-design | medium |
| Smart Home | 스마트홈/IoT | glassmorphism | medium |
| EV/Energy | EV/충전 | minimalism | medium |
| Subscription Box | 구독 박스 | flat-design | low |
| Podcast | 팟캐스트 | minimalism | low |
| Dating App | 데이팅 앱 | glassmorphism | low |
| Micro Credentials | 마이크로자격증 | flat-design | medium |
| Knowledge Base | 나레지베이스 | minimalism | high |
| Hyperlocal | 하이퍼로컬 | flat-design | medium |
| Beauty/Spa | 뷰티/스파 | minimalism | low |
| Luxury Brand | 럭셔리 브랜드 | minimalism | low |
| Restaurant | 레스토랑 | minimalism | low |
| Fitness | 피트니스 | flat-design | medium |
| Real Estate | 부동산 | minimalism | high |
| Travel | 여행 | minimalism | medium |
| Hotel | 호텔 | minimalism | low |
| Wedding/Event | 결혼/이벤트 | editorial | low |
| Legal | 법률 | minimalism | medium |
| Insurance | 보험 | flat-design | medium |
| Banking | 은행 | minimalism | high |
| Online Learning | 온라인 학습 | flat-design | medium |
| Nonprofit | 비영리 | minimalism | low |
| Music Streaming | 음악 스트리밍 | dark-mode | medium |
| Video Streaming | 비디오 스트리밍 | dark-mode | medium |
| Job Board | 채용 | flat-design | high |
| Marketplace | 마켓플레이스 | flat-design | high |
| Logistics | 물류 | flat-design | high |
| AgriTech | 농업기술 | flat-design | medium |
| Construction | 건설 | flat-design | medium |
| Automotive | 자동차 | minimalism | medium |
| Photo Studio | 사진 스튜디오 | minimalism | low |
| Coworking | 코워킹 | minimalism | low |
| Cleaning | 청소 서비스 | flat-design | low |
| Home Service | 가정 서비스 | flat-design | low |
| Childcare | 보육 | soft-ui | low |
| Elderly Care | 노인 요양 | minimalism | low |
| Clinic | 의료 클리닉 | minimalism | medium |
| Pharmacy | 약국 | flat-design | medium |
| Dental | 치과 | minimalism | low |
| Veterinary | 수의과 | flat-design | low |
| Florist | 꽃집 | minimalism | low |
| Bakery/Cafe | 베이커리/카페 | minimalism | low |
| Coffee Shop | 커피숍 | minimalism | low |
| Brewery/Winery | 양조장/와이너리 | editorial | low |
| Airline | 항공사 | minimalism | high |
| News Media | 뉴스 미디어 | editorial | high |
| Magazine/Blog | 매거진/블로그 | editorial | medium |
| Freelance | 프리랜서 | minimalism | low |
| Consulting | 컨설팅 | minimalism | medium |
| Marketing Agency | 마케팅 에이전시 | glassmorphism | low |
| Event Management | 이벤트 관리 | flat-design | medium |
| Conference | 컨퍼런스 | minimalism | medium |
| Membership | 멤버십 | minimalism | low |
| Newsletter | 뉴스레터 | editorial | low |
| Digital Products | 디지털 제품 | minimalism | low |
| Church/Religion | 교회/종교 | minimalism | low |
| Sports | 스포츠 | bold-contrast | high |
| Museum | 박물관 | editorial | low |
| Theater | 극장 | editorial | low |
| Language Learning | 언어 학습 | flat-design | medium |
| Coding Bootcamp | 코딩 부트캠프 | minimalism | medium |
| Cybersecurity | 사이버보안 | dark-mode | high |
| Dev Tools | 개발자 도구 | dark-mode | high |
| Biotech | 바이오테크 | minimalism | high |
| Space Tech | 우주 기술 | dark-mode | medium |
| Architecture | 건축/인테리어 | minimalism | low |
| Quantum Computing | 양자 컴퓨팅 | dark-mode | high |
| Biohacking | 바이오해킹 | dark-mode | medium |
| Drone Fleet | 드론 관리 | flat-design | high |
| Generative Art | 생성 미술 | dark-mode | low |
| Spatial Computing | 공간 컴퓨팅 | glassmorphism | medium |
| Climate Tech | 기후 기술 | minimalism | high |

---

## SaaS (SaaS 일반)

- **추천 스타일**: minimalism, flat-design, glassmorphism, material
- **추천 컬러**: saas-trust, saas-neutral, saas-accent
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: brutalism, heavy-textures, ornamental-borders, serif-heavy
- **데이터 밀도**: medium
- **핵심 원칙**:
  - clarity > decoration
  - consistent-spacing
  - single-primary-cta
  - progressive-disclosure
  - scannable-hierarchy

---

## Micro SaaS (마이크로 SaaS)

- **추천 스타일**: minimalism, flat-design, glassmorphism
- **추천 컬러**: micro-saas-fresh, saas-trust, micro-saas-pop
- **추천 폰트**: modern-geometric, rounded-friendly, system-clean
- **피해야 할 것**: over-engineering, complex-navigation, enterprise-bloat, heavy-imagery
- **데이터 밀도**: low
- **핵심 원칙**:
  - simplicity-first
  - one-core-action
  - fast-onboarding
  - value-upfront
  - lightweight-feel

---

## E-commerce (전자상거래)

- **추천 스타일**: flat-design, minimalism, material, skeuomorphism
- **추천 컬러**: ecommerce-warm, ecommerce-trust, ecommerce-sale
- **추천 폰트**: humanist-sans, modern-geometric, rounded-friendly
- **피해야 할 것**: cluttered-layout, auto-play-audio, hidden-prices, tiny-product-images
- **데이터 밀도**: high
- **핵심 원칙**:
  - product-first
  - frictionless-checkout
  - trust-signals
  - clear-pricing
  - responsive-grid

---

## Luxury E-commerce (럭셔리 전자상거래)

- **추천 스타일**: minimalism, editorial, art-deco, glassmorphism
- **추천 컬러**: luxury-gold, luxury-noir, luxury-ivory
- **추천 폰트**: editorial-serif, luxury-display, modern-geometric
- **피해야 할 것**: discount-badges, neon-colors, cluttered-grids, cheap-stock-photos
- **데이터 밀도**: low
- **핵심 원칙**:
  - whitespace-is-luxury
  - typography-hierarchy
  - restrained-palette
  - hero-imagery
  - subtle-animations

---

## Service Landing (서비스 랜딩)

- **추천 스타일**: minimalism, flat-design, glassmorphism, gradient-mesh
- **추천 컬러**: landing-vibrant, landing-trust, landing-warm
- **추천 폰트**: modern-geometric, humanist-sans, rounded-friendly
- **피해야 할 것**: wall-of-text, no-cta, multiple-equal-ctas, stock-photo-overload
- **데이터 밀도**: low
- **핵심 원칙**:
  - single-purpose
  - above-fold-value
  - social-proof
  - clear-cta
  - scannable-sections

---

## B2B Service (B2B 서비스)

- **추천 스타일**: minimalism, flat-design, material, corporate
- **추천 컬러**: b2b-professional, b2b-trust, b2b-navy
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: playful-illustrations, neon-colors, informal-tone, heavy-animations
- **데이터 밀도**: medium
- **핵심 원칙**:
  - credibility-first
  - data-driven-proof
  - clear-roi
  - professional-tone
  - structured-layout

---

## Financial Dashboard (금융 대시보드)

- **추천 스타일**: flat-design, minimalism, material, data-viz
- **추천 컬러**: finance-dark, finance-trust, finance-green
- **추천 폰트**: system-clean, tech-mono, modern-geometric
- **피해야 할 것**: decorative-elements, low-contrast, ambiguous-charts, playful-colors
- **데이터 밀도**: high
- **핵심 원칙**:
  - data-accuracy
  - real-time-clarity
  - information-hierarchy
  - consistent-metrics
  - zero-ambiguity

---

## Analytics Dashboard (분석 대시보드)

- **추천 스타일**: flat-design, data-viz, minimalism, material
- **추천 컬러**: analytics-blue, analytics-dark, analytics-multi
- **추천 폰트**: tech-mono, system-clean, modern-geometric
- **피해야 할 것**: decorative-fonts, heavy-borders, 3d-effects, inconsistent-scales
- **데이터 밀도**: high
- **핵심 원칙**:
  - data-ink-ratio
  - consistent-axes
  - drill-down-clarity
  - comparative-layouts
  - alert-hierarchy

---

## Medical App (의료 앱)

- **추천 스타일**: minimalism, flat-design, material, soft-ui
- **추천 컬러**: medical-calm, medical-trust, medical-clean
- **추천 폰트**: humanist-sans, system-clean, rounded-friendly
- **피해야 할 것**: aggressive-red, tiny-fonts, complex-animations, dark-only
- **데이터 밀도**: medium
- **핵심 원칙**:
  - accessibility-first
  - calming-colors
  - clear-typography
  - trust > flash
  - error-prevention

---

## Education App (교육 앱)

- **추천 스타일**: flat-design, minimalism, material, illustration
- **추천 컬러**: education-bright, education-calm, education-warm
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: monotone-palette, dense-text, no-visual-feedback, complex-navigation
- **데이터 밀도**: medium
- **핵심 원칙**:
  - engagement > decoration
  - progress-visibility
  - bite-sized-content
  - encouraging-feedback
  - intuitive-flow

---

## Creative Agency (크리에이티브 에이전시)

- **추천 스타일**: brutalism, glassmorphism, gradient-mesh, editorial, experimental
- **추천 컬러**: agency-bold, agency-neon, agency-mono
- **추천 폰트**: display-creative, editorial-serif, tech-mono
- **피해야 할 것**: corporate-blandness, stock-photos, template-feel, conservative-layout
- **데이터 밀도**: low
- **핵심 원칙**:
  - portfolio-impact
  - visual-storytelling
  - brand-personality
  - creative-risk
  - memorable-experience

---

## Portfolio (포트폴리오)

- **추천 스타일**: minimalism, brutalism, editorial, glassmorphism
- **추천 컬러**: portfolio-mono, portfolio-accent, portfolio-dark
- **추천 폰트**: editorial-serif, display-creative, modern-geometric
- **피해야 할 것**: cluttered-layout, competing-elements, autoplay-everything, over-designed
- **데이터 밀도**: low
- **핵심 원칙**:
  - work-speaks
  - clean-navigation
  - intentional-whitespace
  - personality-through-detail
  - fast-loading

---

## Gaming (게임)

- **추천 스타일**: cyberpunk, neon-dark, gradient-mesh, glassmorphism, immersive
- **추천 컬러**: gaming-neon, gaming-dark, gaming-fire
- **추천 폰트**: display-creative, tech-mono, modern-geometric
- **피해야 할 것**: corporate-feel, pastel-colors, minimal-imagery, static-layouts
- **데이터 밀도**: medium
- **핵심 원칙**:
  - immersion-first
  - dynamic-energy
  - community-driven
  - bold-typography
  - responsive-interactions

---

## Government (정부/공공)

- **추천 스타일**: flat-design, minimalism, material, accessible
- **추천 컬러**: gov-blue, gov-neutral, gov-accessible
- **추천 폰트**: system-clean, humanist-sans, modern-geometric
- **피해야 할 것**: trendy-effects, dark-mode-only, small-fonts, complex-interactions
- **데이터 밀도**: medium
- **핵심 원칙**:
  - accessibility-aaa
  - plain-language
  - predictable-navigation
  - high-contrast
  - mobile-first

---

## Fintech (핀테크)

- **추천 스타일**: minimalism, glassmorphism, flat-design, gradient-mesh
- **추천 컬러**: fintech-dark, fintech-trust, fintech-green
- **추천 폰트**: modern-geometric, system-clean, tech-mono
- **피해야 할 것**: playful-illustrations, low-contrast-numbers, ambiguous-icons, slow-animations
- **데이터 밀도**: high
- **핵심 원칙**:
  - trust-through-clarity
  - real-time-feedback
  - secure-feel
  - precision-typography
  - progressive-complexity

---

## Social Media (소셜 미디어)

- **추천 스타일**: flat-design, material, glassmorphism, minimalism
- **추천 컬러**: social-vibrant, social-gradient, social-dark
- **추천 폰트**: rounded-friendly, modern-geometric, humanist-sans
- **피해야 할 것**: information-overload, no-empty-states, tiny-touch-targets, complex-onboarding
- **데이터 밀도**: medium
- **핵심 원칙**:
  - content-first
  - thumb-friendly
  - instant-feedback
  - addictive-patterns
  - identity-expression

---

## Productivity (생산성 도구)

- **추천 스타일**: minimalism, flat-design, material, soft-ui
- **추천 컬러**: productivity-calm, productivity-focus, productivity-neutral
- **추천 폰트**: system-clean, modern-geometric, humanist-sans
- **피해야 할 것**: decorative-elements, aggressive-colors, complex-menus, animation-heavy
- **데이터 밀도**: high
- **핵심 원칙**:
  - reduce-friction
  - keyboard-first
  - customizable-density
  - consistent-patterns
  - zero-distraction

---

## Design System (디자인 시스템)

- **추천 스타일**: minimalism, flat-design, material
- **추천 컬러**: design-sys-neutral, design-sys-blue, design-sys-spectrum
- **추천 폰트**: system-clean, tech-mono, modern-geometric
- **피해야 할 것**: inconsistent-spacing, decorative-fonts, arbitrary-colors, undocumented-patterns
- **데이터 밀도**: high
- **핵심 원칙**:
  - consistency-is-king
  - token-driven
  - composable-components
  - documented-decisions
  - version-controlled

---

## AI Product (AI 제품)

- **추천 스타일**: glassmorphism, gradient-mesh, minimalism, aurora, dark-mode
- **추천 컬러**: ai-purple, ai-gradient, ai-dark
- **추천 폰트**: modern-geometric, tech-mono, system-clean
- **피해야 할 것**: retro-design, heavy-skeuomorphism, static-feel, cluttered-dashboards
- **데이터 밀도**: medium
- **핵심 원칙**:
  - intelligent-defaults
  - transparent-process
  - progressive-results
  - ambient-feedback
  - trust-through-explanation

---

## NFT/Web3 (NFT/웹3)

- **추천 스타일**: cyberpunk, glassmorphism, gradient-mesh, neon-dark, dark-mode
- **추천 컬러**: web3-neon, web3-dark, web3-gradient
- **추천 폰트**: display-creative, tech-mono, modern-geometric
- **피해야 할 것**: corporate-conservative, light-only, traditional-layout, stock-photography
- **데이터 밀도**: medium
- **핵심 원칙**:
  - community-identity
  - wallet-first
  - provenance-clarity
  - dynamic-visuals
  - decentralized-ethos

---

## Creator Economy (크리에이터 이코노미)

- **추천 스타일**: glassmorphism, minimalism, flat-design, gradient-mesh
- **추천 컬러**: creator-vibrant, creator-warm, creator-pastel
- **추천 폰트**: rounded-friendly, modern-geometric, display-creative
- **피해야 할 것**: enterprise-complexity, monochrome-only, dense-tables, formal-tone
- **데이터 밀도**: low
- **핵심 원칙**:
  - creator-personality
  - monetization-clarity
  - audience-first
  - easy-customization
  - visual-brand

---

## Sustainability (지속가능성/ESG)

- **추천 스타일**: minimalism, organic, flat-design, earth-tone
- **추천 컬러**: eco-green, eco-earth, eco-ocean
- **추천 폰트**: humanist-sans, modern-geometric, rounded-friendly
- **피해야 할 것**: aggressive-neon, dark-heavy, industrial-feel, disposable-aesthetic
- **데이터 밀도**: medium
- **핵심 원칙**:
  - earth-tones
  - natural-imagery
  - transparent-impact
  - hopeful-tone
  - data-backed-claims

---

## Remote Work (원격 근무)

- **추천 스타일**: minimalism, flat-design, glassmorphism, material
- **추천 컬러**: remote-calm, remote-blue, remote-warm
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: information-overload, always-on-indicators, complex-settings, cold-sterile
- **데이터 밀도**: medium
- **핵심 원칙**:
  - async-first
  - presence-without-pressure
  - organized-channels
  - minimal-notifications
  - human-connection

---

## Mental Health (정신 건강)

- **추천 스타일**: soft-ui, minimalism, organic, illustration
- **추천 컬러**: mental-calm, mental-sage, mental-lavender
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: aggressive-red, harsh-contrast, clinical-sterile, gamification-heavy
- **데이터 밀도**: low
- **핵심 원칙**:
  - calming-first
  - judgment-free
  - gentle-onboarding
  - breathing-room
  - safe-space-feel

---

## Pet Tech (펫테크)

- **추천 스타일**: flat-design, minimalism, illustration, rounded
- **추천 컬러**: pet-warm, pet-playful, pet-nature
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: clinical-feel, monochrome, harsh-angles, complex-data-tables
- **데이터 밀도**: medium
- **핵심 원칙**:
  - warmth > efficiency
  - pet-personality
  - visual-delight
  - simple-tracking
  - community-feel

---

## Smart Home (스마트홈/IoT)

- **추천 스타일**: glassmorphism, dark-mode, minimalism, flat-design
- **추천 컬러**: iot-dark, iot-blue, iot-accent
- **추천 폰트**: modern-geometric, system-clean, tech-mono
- **피해야 할 것**: cluttered-controls, inconsistent-states, tiny-touch-targets, retro-design
- **데이터 밀도**: medium
- **핵심 원칙**:
  - glanceable-status
  - one-tap-control
  - ambient-awareness
  - consistent-device-ui
  - real-time-feedback

---

## EV/Energy (EV/충전)

- **추천 스타일**: minimalism, glassmorphism, flat-design, gradient-mesh
- **추천 컬러**: ev-green, ev-dark, ev-electric
- **추천 폰트**: modern-geometric, system-clean, tech-mono
- **피해야 할 것**: retro-aesthetic, warm-tones-only, complex-charts, ornamental-design
- **데이터 밀도**: medium
- **핵심 원칙**:
  - real-time-status
  - range-clarity
  - eco-indicators
  - map-integration
  - charging-simplicity

---

## Subscription Box (구독 박스)

- **추천 스타일**: flat-design, minimalism, illustration, playful
- **추천 컬러**: sub-box-warm, sub-box-pastel, sub-box-bold
- **추천 폰트**: rounded-friendly, humanist-sans, display-creative
- **피해야 할 것**: enterprise-seriousness, data-heavy, monochrome, complex-pricing
- **데이터 밀도**: low
- **핵심 원칙**:
  - unboxing-excitement
  - visual-preview
  - flexible-plans
  - surprise-delight
  - easy-management

---

## Podcast (팟캐스트)

- **추천 스타일**: minimalism, flat-design, dark-mode, glassmorphism
- **추천 컬러**: podcast-dark, podcast-warm, podcast-accent
- **추천 폰트**: modern-geometric, rounded-friendly, humanist-sans
- **피해야 할 것**: cluttered-player, tiny-controls, complex-navigation, information-overload
- **데이터 밀도**: low
- **핵심 원칙**:
  - audio-first
  - discoverable-content
  - minimal-player
  - episode-hierarchy
  - seamless-playback

---

## Dating App (데이팅 앱)

- **추천 스타일**: glassmorphism, gradient-mesh, flat-design, minimalism
- **추천 컬러**: dating-warm, dating-gradient, dating-bold
- **추천 폰트**: rounded-friendly, modern-geometric, humanist-sans
- **피해야 할 것**: clinical-ui, aggressive-monetization-ui, complex-profiles, cold-colors
- **데이터 밀도**: low
- **핵심 원칙**:
  - warmth > efficiency
  - profile-impact
  - swipe-friendly
  - safety-signals
  - authentic-feel

---

## Micro Credentials (마이크로자격증)

- **추천 스타일**: flat-design, minimalism, material, gamification
- **추천 컬러**: credential-blue, credential-gold, credential-trust
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: playful-overload, complex-navigation, inconsistent-badges, dark-mode-only
- **데이터 밀도**: medium
- **핵심 원칙**:
  - achievement-visibility
  - progress-clarity
  - credential-value
  - structured-paths
  - verifiable-trust

---

## Knowledge Base (나레지베이스)

- **추천 스타일**: minimalism, flat-design, material
- **추천 컬러**: kb-neutral, kb-blue, kb-clean
- **추천 폰트**: system-clean, humanist-sans, tech-mono
- **피해야 할 것**: decorative-elements, complex-animations, hidden-search, poor-hierarchy
- **데이터 밀도**: high
- **핵심 원칙**:
  - search-first
  - scannable-headings
  - clear-hierarchy
  - interlinked-content
  - version-clarity

---

## Hyperlocal (하이퍼로컬)

- **추천 스타일**: flat-design, minimalism, material, map-centric
- **추천 컬러**: hyperlocal-warm, hyperlocal-green, hyperlocal-community
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: generic-stock, global-feel, complex-filters, corporate-tone
- **데이터 밀도**: medium
- **핵심 원칙**:
  - location-first
  - community-trust
  - real-time-relevance
  - simple-discovery
  - neighborhood-identity

---

## Beauty/Spa (뷰티/스파)

- **추천 스타일**: minimalism, soft-ui, glassmorphism, editorial
- **추천 컬러**: beauty-rose, beauty-nude, beauty-gold
- **추천 폰트**: editorial-serif, modern-geometric, luxury-display
- **피해야 할 것**: harsh-neon, industrial-feel, data-heavy, aggressive-cta
- **데이터 밀도**: low
- **핵심 원칙**:
  - sensory-appeal
  - aspirational-imagery
  - soft-palette
  - booking-simplicity
  - before-after-clarity

---

## Luxury Brand (럭셔리 브랜드)

- **추천 스타일**: minimalism, editorial, art-deco, cinematic
- **추천 컬러**: luxury-noir, luxury-gold, luxury-cream
- **추천 폰트**: luxury-display, editorial-serif, modern-geometric
- **피해야 할 것**: discount-banners, cluttered-layout, cheap-fonts, bright-neon
- **데이터 밀도**: low
- **핵심 원칙**:
  - less-is-more
  - heritage-storytelling
  - typographic-excellence
  - curated-imagery
  - sensory-digital

---

## Restaurant (레스토랑)

- **추천 스타일**: minimalism, editorial, warm-tone, illustration
- **추천 컬러**: restaurant-warm, restaurant-dark, restaurant-earthy
- **추천 폰트**: editorial-serif, humanist-sans, display-creative
- **피해야 할 것**: stock-food-photos, complex-menus, auto-play-music, tiny-text
- **데이터 밀도**: low
- **핵심 원칙**:
  - appetite-appeal
  - menu-clarity
  - reservation-ease
  - atmosphere-through-design
  - mobile-optimized

---

## Fitness (피트니스)

- **추천 스타일**: flat-design, minimalism, bold-contrast, gradient-mesh
- **추천 컬러**: fitness-energy, fitness-dark, fitness-neon
- **추천 폰트**: modern-geometric, display-creative, system-clean
- **피해야 할 것**: passive-imagery, muted-palette, complex-signup, serif-heavy
- **데이터 밀도**: medium
- **핵심 원칙**:
  - motivation-through-design
  - progress-tracking
  - bold-energy
  - action-oriented-cta
  - community-proof

---

## Real Estate (부동산)

- **추천 스타일**: minimalism, flat-design, material, glassmorphism
- **추천 컬러**: realestate-trust, realestate-warm, realestate-navy
- **추천 폰트**: modern-geometric, humanist-sans, system-clean
- **피해야 할 것**: flashy-animations, neon-colors, cluttered-listings, tiny-photos
- **데이터 밀도**: high
- **핵심 원칙**:
  - photo-first
  - search-driven
  - map-integration
  - trust-signals
  - comparison-ease

---

## Travel (여행)

- **추천 스타일**: minimalism, glassmorphism, gradient-mesh, immersive
- **추천 컬러**: travel-blue, travel-warm, travel-vibrant
- **추천 폰트**: modern-geometric, humanist-sans, rounded-friendly
- **피해야 할 것**: text-heavy, corporate-blandness, tiny-thumbnails, complex-booking
- **데이터 밀도**: medium
- **핵심 원칙**:
  - destination-immersion
  - visual-storytelling
  - date-picker-ease
  - price-transparency
  - inspiration > information

---

## Hotel (호텔)

- **추천 스타일**: minimalism, editorial, glassmorphism, luxury-minimal
- **추천 컬러**: hotel-warm, hotel-gold, hotel-neutral
- **추천 폰트**: editorial-serif, modern-geometric, humanist-sans
- **피해야 할 것**: cluttered-rates, auto-play-video, aggressive-popups, neon-colors
- **데이터 밀도**: low
- **핵심 원칙**:
  - ambiance-first
  - booking-simplicity
  - room-gallery
  - amenity-clarity
  - location-context

---

## Wedding/Event (결혼/이벤트)

- **추천 스타일**: editorial, minimalism, soft-ui, art-nouveau
- **추천 컬러**: wedding-blush, wedding-gold, wedding-sage
- **추천 폰트**: editorial-serif, luxury-display, modern-geometric
- **피해야 할 것**: dark-themes, industrial-feel, aggressive-colors, data-heavy
- **데이터 밀도**: low
- **핵심 원칙**:
  - emotional-elegance
  - date-prominence
  - gallery-beauty
  - timeline-clarity
  - vendor-trust

---

## Legal (법률)

- **추천 스타일**: minimalism, flat-design, material, corporate
- **추천 컬러**: legal-navy, legal-trust, legal-neutral
- **추천 폰트**: system-clean, modern-geometric, humanist-sans
- **피해야 할 것**: playful-design, bright-neon, casual-fonts, heavy-animations
- **데이터 밀도**: medium
- **핵심 원칙**:
  - authority-trust
  - clear-language
  - structured-content
  - credential-display
  - contact-accessibility

---

## Insurance (보험)

- **추천 스타일**: flat-design, minimalism, material, illustration
- **추천 컬러**: insurance-trust, insurance-blue, insurance-safe
- **추천 폰트**: humanist-sans, modern-geometric, system-clean
- **피해야 할 것**: complex-jargon-ui, dark-themes, aggressive-red, playful-overload
- **데이터 밀도**: medium
- **핵심 원칙**:
  - trust > flash
  - plain-language
  - comparison-clarity
  - quote-simplicity
  - reassuring-tone

---

## Banking (은행)

- **추천 스타일**: minimalism, flat-design, material, corporate
- **추천 컬러**: banking-navy, banking-trust, banking-gold
- **추천 폰트**: system-clean, modern-geometric, humanist-sans
- **피해야 할 것**: trendy-effects, neon-colors, casual-design, experimental-layout
- **데이터 밀도**: high
- **핵심 원칙**:
  - security-feel
  - transaction-clarity
  - account-overview
  - accessibility-first
  - consistent-patterns

---

## Online Learning (온라인 학습)

- **추천 스타일**: flat-design, minimalism, material, gamification
- **추천 컬러**: learning-blue, learning-warm, learning-progress
- **추천 폰트**: rounded-friendly, modern-geometric, humanist-sans
- **피해야 할 것**: wall-of-text, monotone-design, complex-navigation, no-progress-indicator
- **데이터 밀도**: medium
- **핵심 원칙**:
  - progress-motivation
  - bite-sized-modules
  - visual-variety
  - completion-reward
  - accessible-content

---

## Nonprofit (비영리)

- **추천 스타일**: minimalism, flat-design, warm-tone, illustration
- **추천 컬러**: nonprofit-warm, nonprofit-earth, nonprofit-hope
- **추천 폰트**: humanist-sans, modern-geometric, rounded-friendly
- **피해야 할 것**: corporate-coldness, aggressive-donation-pressure, dark-themes, complex-forms
- **데이터 밀도**: low
- **핵심 원칙**:
  - impact-storytelling
  - donation-ease
  - transparency
  - emotional-connection
  - mission-clarity

---

## Music Streaming (음악 스트리밍)

- **추천 스타일**: dark-mode, glassmorphism, minimalism, gradient-mesh
- **추천 컬러**: music-dark, music-gradient, music-accent
- **추천 폰트**: modern-geometric, system-clean, rounded-friendly
- **피해야 할 것**: bright-white-ui, cluttered-controls, tiny-album-art, complex-menus
- **데이터 밀도**: medium
- **핵심 원칙**:
  - album-art-focus
  - playback-simplicity
  - discovery-flow
  - queue-management
  - genre-identity

---

## Video Streaming (비디오 스트리밍)

- **추천 스타일**: dark-mode, minimalism, immersive, glassmorphism
- **추천 컬러**: video-dark, video-red, video-neutral
- **추천 폰트**: system-clean, modern-geometric, humanist-sans
- **피해야 할 것**: bright-backgrounds, cluttered-thumbnails, complex-categories, tiny-player
- **데이터 밀도**: medium
- **핵심 원칙**:
  - content-immersion
  - thumbnail-impact
  - continue-watching
  - minimal-chrome
  - binge-friendly

---

## Job Board (채용)

- **추천 스타일**: flat-design, minimalism, material
- **추천 컬러**: job-trust, job-blue, job-professional
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: playful-design, complex-application, hidden-salary, dark-mode-only
- **데이터 밀도**: high
- **핵심 원칙**:
  - search-efficiency
  - filter-clarity
  - application-simplicity
  - company-credibility
  - salary-transparency

---

## Marketplace (마켓플레이스)

- **추천 스타일**: flat-design, minimalism, material, glassmorphism
- **추천 컬러**: marketplace-trust, marketplace-warm, marketplace-accent
- **추천 폰트**: modern-geometric, humanist-sans, system-clean
- **피해야 할 것**: cluttered-listings, hidden-pricing, complex-checkout, inconsistent-cards
- **데이터 밀도**: high
- **핵심 원칙**:
  - discovery-first
  - trust-signals
  - filter-efficiency
  - seller-credibility
  - comparison-ease

---

## Logistics (물류)

- **추천 스타일**: flat-design, minimalism, material, data-viz
- **추천 컬러**: logistics-blue, logistics-dark, logistics-neutral
- **추천 폰트**: system-clean, tech-mono, modern-geometric
- **피해야 할 것**: decorative-design, complex-animations, playful-colors, serif-fonts
- **데이터 밀도**: high
- **핵심 원칙**:
  - tracking-clarity
  - status-visibility
  - map-integration
  - eta-prominence
  - operational-efficiency

---

## AgriTech (농업기술)

- **추천 스타일**: flat-design, minimalism, earth-tone, data-viz
- **추천 컬러**: agri-green, agri-earth, agri-sky
- **추천 폰트**: humanist-sans, modern-geometric, system-clean
- **피해야 할 것**: urban-neon, dark-heavy, complex-interfaces, abstract-imagery
- **데이터 밀도**: medium
- **핵심 원칙**:
  - field-data-clarity
  - weather-integration
  - seasonal-awareness
  - offline-friendly
  - practical-simplicity

---

## Construction (건설)

- **추천 스타일**: flat-design, material, minimalism, industrial
- **추천 컬러**: construction-orange, construction-navy, construction-earth
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: delicate-design, pastel-colors, complex-animations, thin-fonts
- **데이터 밀도**: medium
- **핵심 원칙**:
  - project-timeline
  - safety-visibility
  - progress-tracking
  - document-access
  - field-friendly

---

## Automotive (자동차)

- **추천 스타일**: minimalism, dark-mode, glassmorphism, cinematic
- **추천 컬러**: auto-dark, auto-silver, auto-racing
- **추천 폰트**: modern-geometric, display-creative, system-clean
- **피해야 할 것**: cluttered-specs, retro-web, cheap-gradients, playful-fonts
- **데이터 밀도**: medium
- **핵심 원칙**:
  - vehicle-showcase
  - configurator-flow
  - spec-clarity
  - test-drive-cta
  - premium-feel

---

## Photo Studio (사진 스튜디오)

- **추천 스타일**: minimalism, editorial, dark-mode, masonry
- **추천 컬러**: photo-dark, photo-neutral, photo-accent
- **추천 폰트**: editorial-serif, modern-geometric, display-creative
- **피해야 할 것**: busy-backgrounds, competing-elements, heavy-text, neon-overlays
- **데이터 밀도**: low
- **핵심 원칙**:
  - images-speak
  - minimal-chrome
  - gallery-flow
  - portfolio-impact
  - booking-ease

---

## Coworking (코워킹)

- **추천 스타일**: minimalism, flat-design, glassmorphism, playful
- **추천 컬러**: cowork-warm, cowork-bright, cowork-neutral
- **추천 폰트**: modern-geometric, rounded-friendly, humanist-sans
- **피해야 할 것**: corporate-coldness, complex-pricing, dark-only, heavy-stock-photos
- **데이터 밀도**: low
- **핵심 원칙**:
  - space-showcase
  - pricing-transparency
  - community-vibe
  - booking-ease
  - location-clarity

---

## Cleaning (청소 서비스)

- **추천 스타일**: flat-design, minimalism, friendly, illustration
- **추천 컬러**: cleaning-fresh, cleaning-blue, cleaning-green
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: dark-themes, complex-ui, aggressive-design, tiny-text
- **데이터 밀도**: low
- **핵심 원칙**:
  - trust-signals
  - booking-simplicity
  - pricing-clarity
  - before-after
  - service-checklist

---

## Home Service (가정 서비스)

- **추천 스타일**: flat-design, minimalism, material, friendly
- **추천 컬러**: home-warm, home-trust, home-blue
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: complex-forms, dark-themes, aggressive-animations, corporate-feel
- **데이터 밀도**: low
- **핵심 원칙**:
  - service-clarity
  - instant-booking
  - trust-badges
  - provider-profiles
  - pricing-upfront

---

## Childcare (보육)

- **추천 스타일**: soft-ui, illustration, minimalism, rounded
- **추천 컬러**: childcare-warm, childcare-pastel, childcare-safe
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: dark-themes, aggressive-design, complex-navigation, adult-centric
- **데이터 밀도**: low
- **핵심 원칙**:
  - safety-first
  - warm-welcoming
  - parent-trust
  - age-appropriate
  - simple-communication

---

## Elderly Care (노인 요양)

- **추천 스타일**: minimalism, flat-design, accessible, soft-ui
- **추천 컬러**: elderly-calm, elderly-warm, elderly-trust
- **추천 폰트**: humanist-sans, system-clean, rounded-friendly
- **피해야 할 것**: tiny-fonts, low-contrast, complex-gestures, trendy-animations
- **데이터 밀도**: low
- **핵심 원칙**:
  - large-text
  - high-contrast
  - simple-navigation
  - warmth > efficiency
  - accessibility-aaa

---

## Clinic (의료 클리닉)

- **추천 스타일**: minimalism, flat-design, material, clean
- **추천 컬러**: clinic-clean, clinic-trust, clinic-calm
- **추천 폰트**: humanist-sans, system-clean, modern-geometric
- **피해야 할 것**: dark-themes, aggressive-red, playful-design, complex-forms
- **데이터 밀도**: medium
- **핵심 원칙**:
  - trust-through-cleanliness
  - appointment-ease
  - doctor-profiles
  - patient-portal
  - accessible-information

---

## Pharmacy (약국)

- **추천 스타일**: flat-design, minimalism, material, clean
- **추천 컬러**: pharmacy-green, pharmacy-trust, pharmacy-clean
- **추천 폰트**: humanist-sans, system-clean, rounded-friendly
- **피해야 할 것**: dark-themes, aggressive-design, complex-animations, playful-fonts
- **데이터 밀도**: medium
- **핵심 원칙**:
  - medication-clarity
  - search-first
  - prescription-ease
  - safety-warnings
  - health-information

---

## Dental (치과)

- **추천 스타일**: minimalism, soft-ui, flat-design, clean
- **추천 컬러**: dental-clean, dental-blue, dental-fresh
- **추천 폰트**: humanist-sans, rounded-friendly, modern-geometric
- **피해야 할 것**: dark-themes, aggressive-red, clinical-sterile, complex-forms
- **데이터 밀도**: low
- **핵심 원칙**:
  - smile-focused
  - appointment-ease
  - treatment-clarity
  - before-after
  - calming-atmosphere

---

## Veterinary (수의과)

- **추천 스타일**: flat-design, illustration, minimalism, friendly
- **추천 컬러**: vet-warm, vet-green, vet-care
- **추천 폰트**: rounded-friendly, humanist-sans, modern-geometric
- **피해야 할 것**: clinical-sterile, dark-themes, aggressive-design, complex-medical-jargon
- **데이터 밀도**: low
- **핵심 원칙**:
  - pet-friendly-tone
  - emergency-visibility
  - appointment-ease
  - species-specific
  - compassionate-design

---

## Florist (꽃집)

- **추천 스타일**: minimalism, editorial, organic, watercolor
- **추천 컬러**: florist-blush, florist-green, florist-cream
- **추천 폰트**: editorial-serif, humanist-sans, modern-geometric
- **피해야 할 것**: dark-heavy, industrial-feel, aggressive-cta, data-tables
- **데이터 밀도**: low
- **핵심 원칙**:
  - visual-beauty
  - seasonal-showcase
  - occasion-browsing
  - delivery-clarity
  - gift-messaging

---

## Bakery/Cafe (베이커리/카페)

- **추천 스타일**: minimalism, warm-tone, editorial, illustration
- **추천 컬러**: bakery-warm, bakery-cream, bakery-brown
- **추천 폰트**: editorial-serif, humanist-sans, rounded-friendly
- **피해야 할 것**: dark-corporate, neon-colors, complex-navigation, data-heavy
- **데이터 밀도**: low
- **핵심 원칙**:
  - appetite-appeal
  - menu-simplicity
  - atmosphere-warmth
  - order-ease
  - artisan-feel

---

## Coffee Shop (커피숍)

- **추천 스타일**: minimalism, warm-tone, editorial, artisan
- **추천 컬러**: coffee-brown, coffee-cream, coffee-dark
- **추천 폰트**: editorial-serif, humanist-sans, modern-geometric
- **피해야 할 것**: neon-bright, corporate-sterile, complex-menus, aggressive-design
- **데이터 밀도**: low
- **핵심 원칙**:
  - cozy-atmosphere
  - menu-clarity
  - origin-story
  - order-ahead
  - loyalty-simplicity

---

## Brewery/Winery (양조장/와이너리)

- **추천 스타일**: editorial, minimalism, artisan, dark-mode
- **추천 컬러**: brewery-amber, brewery-dark, brewery-earth
- **추천 폰트**: editorial-serif, display-creative, humanist-sans
- **피해야 할 것**: corporate-feel, neon-colors, childish-design, complex-checkout
- **데이터 밀도**: low
- **핵심 원칙**:
  - craft-storytelling
  - product-showcase
  - tasting-notes
  - age-verification
  - venue-ambiance

---

## Airline (항공사)

- **추천 스타일**: minimalism, flat-design, material, corporate
- **추천 컬러**: airline-sky, airline-trust, airline-navy
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: complex-booking, hidden-fees-ui, dark-only, experimental-layout
- **데이터 밀도**: high
- **핵심 원칙**:
  - booking-efficiency
  - fare-comparison
  - seat-selection
  - status-clarity
  - mobile-boarding

---

## News Media (뉴스 미디어)

- **추천 스타일**: editorial, minimalism, flat-design, typographic
- **추천 컬러**: news-neutral, news-red, news-dark
- **추천 폰트**: editorial-serif, system-clean, modern-geometric
- **피해야 할 것**: autoplay-video, popup-overload, clickbait-layout, complex-navigation
- **데이터 밀도**: high
- **핵심 원칙**:
  - headline-hierarchy
  - readability-first
  - section-clarity
  - breaking-news-prominence
  - source-credibility

---

## Magazine/Blog (매거진/블로그)

- **추천 스타일**: editorial, minimalism, masonry, typographic
- **추천 컬러**: magazine-neutral, magazine-accent, magazine-warm
- **추천 폰트**: editorial-serif, modern-geometric, humanist-sans
- **피해야 할 것**: cluttered-sidebar, popup-heavy, tiny-text, ad-overload
- **데이터 밀도**: medium
- **핵심 원칙**:
  - reading-experience
  - visual-storytelling
  - category-navigation
  - author-identity
  - share-ability

---

## Freelance (프리랜서)

- **추천 스타일**: minimalism, brutalism, editorial, glassmorphism
- **추천 컬러**: freelance-mono, freelance-accent, freelance-warm
- **추천 폰트**: modern-geometric, editorial-serif, display-creative
- **피해야 할 것**: corporate-template, cluttered-layout, stock-photos, generic-feel
- **데이터 밀도**: low
- **핵심 원칙**:
  - personal-brand
  - work-showcase
  - skill-clarity
  - contact-ease
  - authentic-personality

---

## Consulting (컨설팅)

- **추천 스타일**: minimalism, flat-design, corporate, material
- **추천 컬러**: consulting-navy, consulting-trust, consulting-gold
- **추천 폰트**: modern-geometric, system-clean, editorial-serif
- **피해야 할 것**: playful-design, neon-colors, casual-fonts, experimental-layout
- **데이터 밀도**: medium
- **핵심 원칙**:
  - authority-credibility
  - case-study-impact
  - expertise-clarity
  - thought-leadership
  - contact-prominence

---

## Marketing Agency (마케팅 에이전시)

- **추천 스타일**: glassmorphism, gradient-mesh, minimalism, bold-contrast
- **추천 컬러**: agency-gradient, agency-bold, agency-dark
- **추천 폰트**: modern-geometric, display-creative, humanist-sans
- **피해야 할 것**: conservative-layout, monochrome-only, text-heavy, dated-design
- **데이터 밀도**: low
- **핵심 원칙**:
  - results-showcase
  - creative-proof
  - case-studies
  - team-personality
  - bold-first-impression

---

## Event Management (이벤트 관리)

- **추천 스타일**: flat-design, minimalism, material, illustration
- **추천 컬러**: event-vibrant, event-warm, event-dark
- **추천 폰트**: modern-geometric, rounded-friendly, humanist-sans
- **피해야 할 것**: monochrome, complex-forms, tiny-text, corporate-sterile
- **데이터 밀도**: medium
- **핵심 원칙**:
  - date-prominence
  - visual-excitement
  - ticket-ease
  - lineup-clarity
  - countdown-urgency

---

## Conference (컨퍼런스)

- **추천 스타일**: minimalism, flat-design, bold-contrast, glassmorphism
- **추천 컬러**: conference-bold, conference-dark, conference-accent
- **추천 폰트**: modern-geometric, display-creative, system-clean
- **피해야 할 것**: cluttered-agenda, hidden-speakers, complex-registration, dated-design
- **데이터 밀도**: medium
- **핵심 원칙**:
  - speaker-showcase
  - schedule-clarity
  - registration-flow
  - venue-info
  - networking-tools

---

## Membership (멤버십)

- **추천 스타일**: minimalism, flat-design, glassmorphism, material
- **추천 컬러**: membership-warm, membership-gold, membership-trust
- **추천 폰트**: modern-geometric, humanist-sans, rounded-friendly
- **피해야 할 것**: complex-tier-tables, hidden-benefits, aggressive-upsell, dark-only
- **데이터 밀도**: low
- **핵심 원칙**:
  - tier-comparison
  - benefit-clarity
  - upgrade-incentive
  - community-value
  - easy-management

---

## Newsletter (뉴스레터)

- **추천 스타일**: editorial, minimalism, typographic, flat-design
- **추천 컬러**: newsletter-clean, newsletter-accent, newsletter-warm
- **추천 폰트**: editorial-serif, modern-geometric, humanist-sans
- **피해야 할 것**: complex-signup, cluttered-archives, no-preview, aggressive-popups
- **데이터 밀도**: low
- **핵심 원칙**:
  - subscribe-simplicity
  - content-preview
  - frequency-clarity
  - author-trust
  - archive-browsability

---

## Digital Products (디지털 제품)

- **추천 스타일**: minimalism, glassmorphism, flat-design, gradient-mesh
- **추천 컬러**: digital-vibrant, digital-dark, digital-accent
- **추천 폰트**: modern-geometric, tech-mono, display-creative
- **피해야 할 것**: physical-product-ui, complex-checkout, shipping-references, heavy-stock-photos
- **데이터 밀도**: low
- **핵심 원칙**:
  - instant-access
  - preview-quality
  - license-clarity
  - download-simplicity
  - product-showcase

---

## Church/Religion (교회/종교)

- **추천 스타일**: minimalism, warm-tone, flat-design, soft-ui
- **추천 컬러**: church-warm, church-gold, church-sage
- **추천 폰트**: humanist-sans, editorial-serif, modern-geometric
- **피해야 할 것**: dark-aggressive, neon-colors, complex-navigation, commercial-feel
- **데이터 밀도**: low
- **핵심 원칙**:
  - welcoming-warmth
  - event-calendar
  - sermon-access
  - community-connection
  - accessible-information

---

## Sports (스포츠)

- **추천 스타일**: bold-contrast, flat-design, dark-mode, dynamic
- **추천 컬러**: sports-energy, sports-dark, sports-team
- **추천 폰트**: display-creative, modern-geometric, system-clean
- **피해야 할 것**: passive-design, muted-colors, serif-heavy, complex-navigation
- **데이터 밀도**: high
- **핵심 원칙**:
  - live-scores
  - team-identity
  - stats-clarity
  - schedule-prominence
  - fan-engagement

---

## Museum (박물관)

- **추천 스타일**: editorial, minimalism, art-deco, immersive
- **추천 컬러**: museum-neutral, museum-dark, museum-accent
- **추천 폰트**: editorial-serif, modern-geometric, display-creative
- **피해야 할 것**: cluttered-layout, commercial-feel, stock-photos, aggressive-cta
- **데이터 밀도**: low
- **핵심 원칙**:
  - collection-showcase
  - visit-planning
  - exhibition-narrative
  - cultural-respect
  - accessibility-first

---

## Theater (극장)

- **추천 스타일**: editorial, dark-mode, minimalism, art-deco
- **추천 컬러**: theater-dark, theater-gold, theater-red
- **추천 폰트**: editorial-serif, display-creative, modern-geometric
- **피해야 할 것**: bright-corporate, cluttered-layout, stock-photos, complex-booking
- **데이터 밀도**: low
- **핵심 원칙**:
  - show-showcase
  - seat-selection
  - dramatic-imagery
  - season-calendar
  - booking-ease

---

## Language Learning (언어 학습)

- **추천 스타일**: flat-design, minimalism, gamification, illustration
- **추천 컬러**: language-bright, language-warm, language-fun
- **추천 폰트**: rounded-friendly, modern-geometric, humanist-sans
- **피해야 할 것**: text-walls, complex-grammar-tables, monochrome, no-audio-integration
- **데이터 밀도**: medium
- **핵심 원칙**:
  - gamified-progress
  - bite-sized-lessons
  - streak-motivation
  - native-audio
  - cultural-context

---

## Coding Bootcamp (코딩 부트캠프)

- **추천 스타일**: minimalism, dark-mode, flat-design, tech-modern
- **추천 컬러**: bootcamp-dark, bootcamp-accent, bootcamp-neon
- **추천 폰트**: tech-mono, modern-geometric, system-clean
- **피해야 할 것**: corporate-conservative, pastel-only, complex-curriculum, no-code-examples
- **데이터 밀도**: medium
- **핵심 원칙**:
  - career-outcome
  - curriculum-clarity
  - student-success
  - hands-on-preview
  - community-proof

---

## Cybersecurity (사이버보안)

- **추천 스타일**: dark-mode, minimalism, flat-design, tech-modern
- **추천 컬러**: cyber-dark, cyber-green, cyber-navy
- **추천 폰트**: tech-mono, system-clean, modern-geometric
- **피해야 할 것**: playful-design, bright-pastels, casual-fonts, decorative-elements
- **데이터 밀도**: high
- **핵심 원칙**:
  - threat-visualization
  - alert-hierarchy
  - dashboard-density
  - real-time-monitoring
  - severity-coding

---

## Dev Tools (개발자 도구)

- **추천 스타일**: dark-mode, minimalism, flat-design, brutalism
- **추천 컬러**: devtools-dark, devtools-mono, devtools-accent
- **추천 폰트**: tech-mono, system-clean, modern-geometric
- **피해야 할 것**: marketing-fluff, stock-photos, complex-signup, non-technical-ui
- **데이터 밀도**: high
- **핵심 원칙**:
  - code-first
  - documentation-clarity
  - api-reference
  - quick-start
  - developer-empathy

---

## Biotech (바이오테크)

- **추천 스타일**: minimalism, flat-design, glassmorphism, scientific
- **추천 컬러**: biotech-blue, biotech-green, biotech-clean
- **추천 폰트**: modern-geometric, system-clean, humanist-sans
- **피해야 할 것**: playful-design, dark-gaming, aggressive-neon, casual-tone
- **데이터 밀도**: high
- **핵심 원칙**:
  - data-integrity
  - research-clarity
  - pipeline-visualization
  - publication-trust
  - scientific-rigor

---

## Space Tech (우주 기술)

- **추천 스타일**: dark-mode, glassmorphism, immersive, gradient-mesh
- **추천 컬러**: space-dark, space-blue, space-accent
- **추천 폰트**: tech-mono, modern-geometric, display-creative
- **피해야 할 것**: bright-corporate, playful-fonts, cluttered-layout, retro-web
- **데이터 밀도**: medium
- **핵심 원칙**:
  - awe-inspiration
  - mission-timeline
  - telemetry-clarity
  - visualization-impact
  - frontier-feel

---

## Architecture (건축/인테리어)

- **추천 스타일**: minimalism, editorial, masonry, glassmorphism
- **추천 컬러**: arch-neutral, arch-warm, arch-mono
- **추천 폰트**: editorial-serif, modern-geometric, display-creative
- **피해야 할 것**: cluttered-layout, neon-colors, cheap-stock, complex-navigation
- **데이터 밀도**: low
- **핵심 원칙**:
  - project-showcase
  - spatial-photography
  - material-detail
  - clean-grid
  - portfolio-narrative

---

## Quantum Computing (양자 컴퓨팅)

- **추천 스타일**: dark-mode, glassmorphism, gradient-mesh, minimalism
- **추천 컬러**: quantum-dark, quantum-purple, quantum-blue
- **추천 폰트**: tech-mono, modern-geometric, system-clean
- **피해야 할 것**: playful-illustration, bright-corporate, casual-design, retro-style
- **데이터 밀도**: high
- **핵심 원칙**:
  - complexity-simplification
  - visualization-first
  - research-credibility
  - technical-precision
  - educational-layers

---

## Biohacking (바이오해킹)

- **추천 스타일**: dark-mode, minimalism, tech-modern, glassmorphism
- **추천 컬러**: biohack-dark, biohack-neon, biohack-bio
- **추천 폰트**: tech-mono, modern-geometric, system-clean
- **피해야 할 것**: conservative-corporate, pastel-soft, traditional-medical, complex-forms
- **데이터 밀도**: medium
- **핵심 원칙**:
  - data-tracking
  - protocol-clarity
  - metric-visualization
  - self-experiment
  - community-evidence

---

## Drone Fleet (드론 관리)

- **추천 스타일**: flat-design, dark-mode, minimalism, data-viz
- **추천 컬러**: drone-dark, drone-sky, drone-alert
- **추천 폰트**: system-clean, tech-mono, modern-geometric
- **피해야 할 것**: decorative-design, playful-fonts, complex-animations, retro-style
- **데이터 밀도**: high
- **핵심 원칙**:
  - map-centric
  - fleet-status
  - mission-planning
  - telemetry-real-time
  - alert-priority

---

## Generative Art (생성 미술)

- **추천 스타일**: dark-mode, glassmorphism, gradient-mesh, experimental, immersive
- **추천 컬러**: genart-dark, genart-gradient, genart-vibrant
- **추천 폰트**: display-creative, tech-mono, modern-geometric
- **피해야 할 것**: corporate-template, stock-photos, conservative-layout, text-heavy
- **데이터 밀도**: low
- **핵심 원칙**:
  - art-first
  - parameter-exploration
  - gallery-immersion
  - process-transparency
  - collector-experience

---

## Spatial Computing (공간 컴퓨팅)

- **추천 스타일**: glassmorphism, dark-mode, gradient-mesh, immersive
- **추천 컬러**: spatial-dark, spatial-blue, spatial-gradient
- **추천 폰트**: modern-geometric, tech-mono, system-clean
- **피해야 할 것**: flat-2d-heavy, retro-web, cluttered-chrome, text-walls
- **데이터 밀도**: medium
- **핵심 원칙**:
  - depth-awareness
  - gesture-friendly
  - spatial-hierarchy
  - immersive-preview
  - minimal-chrome

---

## Climate Tech (기후 기술)

- **추천 스타일**: minimalism, flat-design, data-viz, earth-tone
- **추천 컬러**: climate-green, climate-blue, climate-earth
- **추천 폰트**: modern-geometric, humanist-sans, system-clean
- **피해야 할 것**: greenwashing-aesthetic, dark-gaming, neon-heavy, playful-overload
- **데이터 밀도**: high
- **핵심 원칙**:
  - impact-metrics
  - data-transparency
  - actionable-insights
  - hopeful-urgency
  - scientific-backing
