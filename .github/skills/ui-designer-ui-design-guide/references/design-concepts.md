# 디자인 컨셉 카탈로그

> 67개 디자인 스타일을 5개 카테고리로 분류.
> CSV 검색 엔진이 없는 환경(Codex, Antigravity)에서 참조하는 마크다운 폴백.
> 검색 엔진 사용 가능 시: `python3 .github/skills/ui-designer-ui-design-guide/scripts/search.py "query" --domain style`

---

## 빠른 선택 가이드

| 원하는 느낌 | 카테고리 | 대표 스타일 | 난이도 |
|------------|---------|-----------|--------|
| 최신 트렌드, 세련됨 | 🔮 모던/트렌드 | Glassmorphism, Bento Grid | Medium |
| 검증된 안정감 | ✨ 클래식/정제 | Minimalism, Swiss Design | Low |
| 강렬한 개성 | 🔥 대담/실험적 | Brutalism, Cyberpunk | High |
| 부드럽고 따뜻한 | 🌿 부드러운/유기적 | Neumorphism, Pastel | Medium |
| 목적 특화 | 🏢 특수/산업 | Dashboard-Dense, Editorial | Varies |

---

## 🔮 모던/트렌드 (Modern) — 15개

### Glassmorphism (글래스모피즘)
- **느낌**: Frosted glass effect with transparency and blur creating depth and layered interfaces.
- **CSS**: `backdrop-filter:blur(16px); background:rgba(255,255,255,0.15); border:1px solid rgba(255,255,255,0.2); border-radius:16px; box-shadow:0 8px 32px rgba(0,0,0,0.1)`
- **적합 산업**: saas, fintech, ai-product, portfolio
- **피할 산업**: government, healthcare
- **조합 스타일**: frosted-layers, mesh-gradient, floating-ui
- **난이도**: medium

### Bento Grid (벤토 그리드)
- **느낌**: Grid-based layout inspired by Japanese bento boxes with varied card sizes creating visual hierarchy.
- **CSS**: `display:grid; grid-template-columns:repeat(auto-fit, minmax(200px, 1fr)); gap:16px; border-radius:24px; padding:16px`
- **적합 산업**: saas, ai-product, portfolio, dashboard-dense
- **피할 산업**: legal, retro-pixel
- **조합 스타일**: minimalism, 3d-cards, dashboard-dense
- **난이도**: medium

### Aurora UI (오로라 UI)
- **느낌**: Subtle animated gradient backgrounds mimicking northern lights with soft color transitions.
- **CSS**: `background:linear-gradient(135deg, #667eea, #764ba2, #6B8DD6, #8E37D7); animation:aurora 8s ease infinite; filter:blur(0); background-size:400% 400%`
- **적합 산업**: ai-product, creative-agency, portfolio, saas
- **피할 산업**: government, legal, manufacturing
- **조합 스타일**: mesh-gradient, gradient-blur, soft-gradient
- **난이도**: high

### Mesh Gradient (메시 그라디언트)
- **느낌**: Complex multi-point gradient meshes creating organic color blends as backgrounds and accents.
- **CSS**: `background:conic-gradient(from 45deg, #12c2e9, #c471ed, #f64f59); background-blend-mode:overlay; border-radius:20px; filter:saturate(1.2)`
- **적합 산업**: creative-agency, ai-product, portfolio, saas
- **피할 산업**: legal, government
- **조합 스타일**: aurora-ui, glassmorphism, gradient-blur
- **난이도**: medium

### AI Native (AI 네이티브)
- **느낌**: Design language built around AI interactions with streaming text and conversational UI.
- **CSS**: `animation:pulse 2s cubic-bezier(0.4,0,0.6,1) infinite; border-radius:24px; background:linear-gradient(to right, #1a1a2e, #16213e); color:#e2e8f0; font-family:Inter, system-ui`
- **적합 산업**: ai-product, saas, education, fintech
- **피할 산업**: manufacturing, retail
- **조합 스타일**: terminal-hacker, minimalism, dark-mode-first
- **난이도**: high

### Floating UI (플로팅 UI)
- **느낌**: Elevated card-based design with prominent shadows and floating elements creating depth perception.
- **CSS**: `box-shadow:0 20px 60px rgba(0,0,0,0.12); border-radius:20px; transform:translateY(-2px); transition:all 0.3s ease; background:#ffffff`
- **적합 산업**: saas, ecommerce, portfolio, education
- **피할 산업**: terminal-hacker, grunge
- **조합 스타일**: glassmorphism, 3d-cards, soft-gradient
- **난이도**: medium

### Gradient Blur (그라디언트 블러)
- **느낌**: Blurred gradient backgrounds with crisp foreground content for striking visual contrast.
- **CSS**: `backdrop-filter:blur(40px) saturate(180%); background:rgba(255,255,255,0.08); border:1px solid rgba(255,255,255,0.1); mask-image:linear-gradient(black, transparent)`
- **적합 산업**: ai-product, creative-agency, saas, portfolio
- **피할 산업**: healthcare, legal
- **조합 스타일**: glassmorphism, aurora-ui, mesh-gradient
- **난이도**: medium

### Frosted Layers (프로스티드 레이어)
- **느낌**: Multiple stacked translucent layers with varying blur levels creating dimensional interfaces.
- **CSS**: `backdrop-filter:blur(24px); background:rgba(255,255,255,0.1); border:1px solid rgba(255,255,255,0.15); z-index:auto; box-shadow:inset 0 0 0 1px rgba(255,255,255,0.1)`
- **적합 산업**: saas, ai-product, creative-agency
- **피할 산업**: government, manufacturing
- **조합 스타일**: glassmorphism, gradient-blur, floating-ui
- **난이도**: high

### Neon Glow (네온 글로우)
- **느낌**: Dark backgrounds with vibrant neon-colored elements featuring glow effects and light bleeding.
- **CSS**: `box-shadow:0 0 20px rgba(0,255,136,0.5); color:#00ff88; background:#0a0a0a; text-shadow:0 0 10px currentColor; border:1px solid rgba(0,255,136,0.3)`
- **적합 산업**: gaming, entertainment, nightlife, creative-agency
- **피할 산업**: healthcare, education, government
- **조합 스타일**: cyberpunk, terminal-hacker, dark-mode-first
- **난이도**: medium

### Holographic (홀로그래픽)
- **느낌**: Iridescent rainbow shimmer effects mimicking holographic materials with angle-dependent color shifts.
- **CSS**: `background:linear-gradient(135deg, #ff0080, #7928ca, #ff0080, #00d4ff); background-size:200% 200%; filter:brightness(1.1); mix-blend-mode:screen; animation:hologram 3s ease infinite`
- **적합 산업**: creative-agency, fashion, entertainment, portfolio
- **피할 산업**: healthcare, legal, fintech
- **조합 스타일**: neon-glow, cyberpunk, vaporwave
- **난이도**: high

### Kinetic Typography (키네틱 타이포그래피)
- **느낌**: Typography-driven design where text itself is the primary visual element with motion and scale.
- **CSS**: `font-size:clamp(3rem, 8vw, 8rem); font-weight:900; letter-spacing:-0.04em; line-height:0.9; mix-blend-mode:difference`
- **적합 산업**: creative-agency, portfolio, entertainment, media
- **피할 산업**: healthcare, fintech
- **조합 스타일**: typographic, brutalism, parallax-depth
- **난이도**: high

### Parallax Depth (패럴랙스 뎁스)
- **느낌**: Multi-layer scrolling with different speeds creating immersive depth and spatial experiences.
- **CSS**: `transform:translate3d(0,0,0); perspective:1000px; will-change:transform; transform-style:preserve-3d; backface-visibility:hidden`
- **적합 산업**: creative-agency, portfolio, entertainment, real-estate
- **피할 산업**: ecommerce, dashboard-dense
- **조합 스타일**: 3d-cards, floating-ui, kinetic-typography
- **난이도**: high

### Morphing Shapes (모핑 셰이프)
- **느낌**: Organic blob-like shapes that animate and morph creating dynamic fluid backgrounds.
- **CSS**: `border-radius:30% 70% 70% 30% / 30% 30% 70% 70%; animation:morph 8s ease-in-out infinite; filter:blur(0); background:linear-gradient(45deg, #405de6, #833ab4)`
- **적합 산업**: creative-agency, ai-product, portfolio
- **피할 산업**: healthcare, legal, government
- **조합 스타일**: liquid-design, aurora-ui, organic
- **난이도**: high

### Liquid Design (리퀴드 디자인)
- **느낌**: Fluid responsive layouts with smooth transitions and water-like motion effects throughout.
- **CSS**: `transition:all 0.6s cubic-bezier(0.23,1,0.32,1); border-radius:50%; overflow:hidden; transform:scale(1); animation:liquid 6s ease infinite`
- **적합 산업**: creative-agency, portfolio, entertainment
- **피할 산업**: fintech, legal
- **조합 스타일**: morphing-shapes, organic, soft-gradient
- **난이도**: high

### 3D Cards (3D 카드)
- **느낌**: Card components with perspective transforms and hover-triggered 3D rotation effects.
- **CSS**: `transform:perspective(1000px) rotateX(0) rotateY(0); transition:transform 0.5s ease; box-shadow:0 25px 50px rgba(0,0,0,0.15); border-radius:16px; transform-style:preserve-3d`
- **적합 산업**: ecommerce, portfolio, saas, education
- **피할 산업**: accessibility-first, newspaper
- **조합 스타일**: floating-ui, bento-grid, parallax-depth
- **난이도**: medium

---

## ✨ 클래식/정제 (Classic) — 12개

### Minimalism (미니멀리즘)
- **느낌**: Stripped-down design focusing on essential elements with maximum whitespace and restrained color.
- **CSS**: `max-width:680px; margin:0 auto; color:#1a1a1a; font-family:system-ui, -apple-system; line-height:1.7; letter-spacing:0.01em`
- **적합 산업**: portfolio, saas, fintech, luxury, education
- **피할 산업**: gaming, entertainment
- **조합 스타일**: whitespace-heavy, swiss-design, typographic
- **난이도**: low

### Swiss Design (스위스 디자인)
- **느낌**: International typographic style with strong grids mathematical precision and sans-serif type.
- **CSS**: `font-family:Helvetica Neue, Arial, sans-serif; display:grid; grid-template-columns:repeat(12, 1fr); gap:20px; font-weight:700; text-transform:uppercase`
- **적합 산업**: corporate, fintech, education, portfolio
- **피할 산업**: gaming, nightlife
- **조합 스타일**: grid-strict, minimalism, typographic
- **난이도**: medium

### Corporate Clean (코퍼레이트 클린)
- **느낌**: Professional polished design with clear hierarchy neutral colors and trustworthy appearance.
- **CSS**: `font-family:Inter, system-ui; color:#1e293b; background:#f8fafc; border:1px solid #e2e8f0; border-radius:8px; box-shadow:0 1px 3px rgba(0,0,0,0.08)`
- **적합 산업**: fintech, healthcare, saas, enterprise, government
- **피할 산업**: gaming, creative-agency
- **조합 스타일**: minimalism, flat-design, whitespace-heavy
- **난이도**: low

### Flat Design (플랫 디자인)
- **느낌**: Two-dimensional design without shadows or gradients using bold colors and simple shapes.
- **CSS**: `box-shadow:none; border-radius:4px; background:#3498db; color:#ffffff; border:none; font-weight:600`
- **적합 산업**: saas, education, ecommerce, startup
- **피할 산업**: luxury, creative-agency
- **조합 스타일**: material-design, minimalism, corporate-clean
- **난이도**: low

### Material Design (머티리얼 디자인)
- **느낌**: Google's design system with subtle shadows elevation layers and meaningful motion.
- **CSS**: `box-shadow:0 2px 4px rgba(0,0,0,0.12); border-radius:8px; transition:box-shadow 0.2s; font-family:Roboto, sans-serif; letter-spacing:0.01em`
- **적합 산업**: saas, education, ecommerce, enterprise
- **피할 산업**: luxury, creative-agency
- **조합 스타일**: flat-design, corporate-clean, floating-ui
- **난이도**: medium

### Monochrome (모노크롬)
- **느낌**: Single-color palette design using only shades tints and tones of one hue for sophisticated unity.
- **CSS**: `color:#111111; background:#fafafa; border:1px solid #e0e0e0; filter:grayscale(0); accent-color:#333333`
- **적합 산업**: portfolio, luxury, editorial, photography
- **피할 산업**: gaming, ecommerce, children
- **조합 스타일**: minimalism, typographic, editorial-clean
- **난이도**: low

### Whitespace Heavy (여백 중심)
- **느낌**: Design dominated by generous whitespace letting content breathe with ample padding and margins.
- **CSS**: `padding:clamp(2rem, 5vw, 6rem); margin-bottom:clamp(3rem, 8vh, 8rem); line-height:1.8; max-width:720px; letter-spacing:0.02em`
- **적합 산업**: luxury, portfolio, editorial, education
- **피할 산업**: dashboard-dense, gaming
- **조합 스타일**: minimalism, swiss-design, scandinavian
- **난이도**: low

### Strict Grid (엄격한 그리드)
- **느낌**: Rigid grid-based layout with mathematical precision and consistent spacing throughout.
- **CSS**: `display:grid; grid-template-columns:repeat(12, 1fr); gap:24px; align-items:start; padding:24px`
- **적합 산업**: corporate, fintech, news, education
- **피할 산업**: creative-agency, gaming
- **조합 스타일**: swiss-design, typographic, editorial-clean
- **난이도**: medium

### Typographic (타이포그래픽)
- **느낌**: Typography-first design where typeface selection size and spacing drive the entire visual system.
- **CSS**: `font-family:Playfair Display, Georgia, serif; font-size:clamp(1rem, 1.5vw, 1.25rem); line-height:1.6; letter-spacing:-0.02em; font-feature-settings:'kern' 1, 'liga' 1`
- **적합 산업**: editorial, portfolio, education, luxury
- **피할 산업**: gaming, children
- **조합 스타일**: swiss-design, minimalism, editorial-clean
- **난이도**: medium

### Editorial Clean (에디토리얼 클린)
- **느낌**: Clean publication-style design with clear reading hierarchy and refined serif typography.
- **CSS**: `font-family:Georgia, Times New Roman, serif; max-width:65ch; line-height:1.75; color:#2d2d2d; margin-bottom:1.5em`
- **적합 산업**: media, blog, education, luxury
- **피할 산업**: gaming, saas
- **조합 스타일**: typographic, whitespace-heavy, scandinavian
- **난이도**: low

### Scandinavian (스칸디나비안)
- **느낌**: Nordic-inspired design with natural tones soft curves functional simplicity and warmth.
- **CSS**: `background:#f5f0eb; color:#2c2c2c; border-radius:12px; font-family:system-ui, sans-serif; padding:24px; border:1px solid #e5ddd3`
- **적합 산업**: lifestyle, ecommerce, wellness, portfolio
- **피할 산업**: gaming, cyberpunk
- **조합 스타일**: minimalism, organic, warm-earth
- **난이도**: low

### Japanese Minimal (일본식 미니멀)
- **느낌**: Wabi-sabi inspired design with asymmetric balance natural textures and reverence for emptiness.
- **CSS**: `font-family:Noto Sans JP, system-ui; background:#faf8f5; color:#333; padding:clamp(2rem, 6vw, 8rem); border-left:2px solid #c4a882; letter-spacing:0.05em`
- **적합 산업**: luxury, hospitality, wellness, portfolio, food
- **피할 산업**: gaming, nightlife
- **조합 스타일**: minimalism, whitespace-heavy, organic
- **난이도**: medium

---

## 🔥 대담/실험적 (Bold) — 15개

### Brutalism (브루탈리즘)
- **느낌**: Raw unpolished web design with bold typography harsh colors and intentionally crude aesthetics.
- **CSS**: `border:3px solid #000; font-family:monospace; font-size:clamp(1rem, 3vw, 2rem); background:#ff0; color:#000; text-transform:uppercase`
- **적합 산업**: creative-agency, art, portfolio, startup
- **피할 산업**: healthcare, fintech, government
- **조합 스타일**: neon-brutalism, anti-design, punk
- **난이도**: low

### Maximalism (맥시멀리즘)
- **느낌**: More-is-more approach with layered textures rich colors mixed patterns and visual abundance.
- **CSS**: `background:repeating-linear-gradient(45deg, #ff6b6b, #ff6b6b 10px, #feca57 10px, #feca57 20px); mix-blend-mode:multiply; filter:saturate(1.3); font-weight:900; text-decoration:underline wavy`
- **적합 산업**: creative-agency, fashion, entertainment, art
- **피할 산업**: healthcare, fintech, corporate
- **조합 스타일**: memphis, pop-art, psychedelic
- **난이도**: high

### Cyberpunk (사이버펑크)
- **느낌**: Futuristic dystopian aesthetic with neon accents on dark backgrounds glitch effects and tech motifs.
- **CSS**: `background:#0d0221; color:#00ff41; text-shadow:0 0 8px rgba(0,255,65,0.6); border:1px solid #ff00ff; font-family:JetBrains Mono, monospace; box-shadow:0 0 15px rgba(255,0,255,0.3)`
- **적합 산업**: gaming, entertainment, tech-startup, ai-product
- **피할 산업**: healthcare, education, government
- **조합 스타일**: neon-glow, glitch-art, terminal-hacker
- **난이도**: medium

### Vaporwave (베이퍼웨이브)
- **느낌**: Retro-internet aesthetic with pastel gradients roman busts pixel art and 80s/90s nostalgia.
- **CSS**: `background:linear-gradient(180deg, #ff71ce, #01cdfe, #05ffa1); color:#b967ff; font-family:MS PGothic, monospace; text-shadow:2px 2px #ff6ac1; filter:saturate(1.5)`
- **적합 산업**: entertainment, art, fashion, music
- **피할 산업**: healthcare, fintech, legal
- **조합 스타일**: y2k-aesthetic, retro-futurism, holographic
- **난이도**: medium

### Retro Futurism (레트로 퓨처리즘)
- **느낌**: Past visions of the future combining vintage aesthetics with futuristic optimism and chrome.
- **CSS**: `background:linear-gradient(135deg, #2d1b69, #11998e); font-family:Orbitron, sans-serif; letter-spacing:0.1em; border:2px solid #f7971e; text-transform:uppercase`
- **적합 산업**: entertainment, gaming, creative-agency, media
- **피할 산업**: healthcare, legal
- **조합 스타일**: vaporwave, neon-glow, cyberpunk
- **난이도**: medium

### Memphis (멤피스)
- **느낌**: 1980s Italian design movement with bold geometric shapes primary colors squiggles and patterns.
- **CSS**: `background:#ffde59; border:4px solid #000; border-radius:0; font-weight:900; box-shadow:8px 8px 0 #000; transform:rotate(-1deg)`
- **적합 산업**: children, entertainment, food, creative-agency
- **피할 산업**: healthcare, fintech, legal
- **조합 스타일**: pop-art, maximalism, y2k-aesthetic
- **난이도**: medium

### Pop Art (팝아트)
- **느낌**: Warhol-inspired design with bold outlines halftone dots primary colors and comic-book energy.
- **CSS**: `border:4px solid #000; background:#ff3333; color:#fff000; font-family:Impact, sans-serif; font-weight:900; text-transform:uppercase; letter-spacing:0.05em`
- **적합 산업**: entertainment, fashion, food, retail
- **피할 산업**: healthcare, fintech, government
- **조합 스타일**: memphis, maximalism, brutalism
- **난이도**: medium

### Grunge (그런지)
- **느낌**: Distressed worn textures with rough edges torn paper effects and underground aesthetic.
- **CSS**: `background:#1a1a1a; color:#d4c5a9; font-family:Courier New, monospace; text-shadow:1px 1px 0 rgba(0,0,0,0.8); border:2px dashed #555; filter:contrast(1.1)`
- **적합 산업**: music, art, portfolio, nightlife
- **피할 산업**: healthcare, fintech, education
- **조합 스타일**: punk, glitch-art, anti-design
- **난이도**: medium

### Glitch Art (글리치 아트)
- **느낌**: Digital corruption aesthetic with RGB splitting distortion artifacts and broken visual effects.
- **CSS**: `text-shadow:2px 0 #ff0000, -2px 0 #00ff00; animation:glitch 0.3s infinite; clip-path:polygon(0 0, 100% 0, 100% 100%, 0 100%); mix-blend-mode:screen; filter:contrast(1.2)`
- **적합 산업**: entertainment, gaming, art, creative-agency
- **피할 산업**: healthcare, education, fintech
- **조합 스타일**: cyberpunk, neon-glow, anti-design
- **난이도**: high

### Neon Brutalism (네온 브루탈리즘)
- **느낌**: Brutalist foundations with neon color accents combining raw structure with electric vibrancy.
- **CSS**: `border:3px solid #000; background:#a6ff00; box-shadow:6px 6px 0 #000; font-family:monospace; font-weight:800; border-radius:0`
- **적합 산업**: startup, creative-agency, portfolio, art
- **피할 산업**: healthcare, fintech, government
- **조합 스타일**: brutalism, punk, pop-art
- **난이도**: low

### Anti-Design (안티 디자인)
- **느낌**: Deliberately breaking design conventions with clashing elements misalignment and visual chaos.
- **CSS**: `transform:rotate(-2deg); font-size:clamp(0.8rem, 4vw, 3rem); mix-blend-mode:difference; border:none; cursor:crosshair; overflow:visible`
- **적합 산업**: art, creative-agency, fashion, portfolio
- **피할 산업**: healthcare, fintech, government, education
- **조합 스타일**: brutalism, glitch-art, punk
- **난이도**: medium

### Acid Graphics (애시드 그래픽스)
- **느낌**: Rave culture inspired visuals with warped typography chromatic aberration and psychedelic motifs.
- **CSS**: `filter:hue-rotate(90deg) saturate(2); background:linear-gradient(to bottom, #000, #1a0033); color:#39ff14; font-family:monospace; text-shadow:0 0 12px currentColor`
- **적합 산업**: music, entertainment, art, nightlife
- **피할 산업**: healthcare, education, government
- **조합 스타일**: psychedelic, cyberpunk, neon-glow
- **난이도**: high

### Y2K Aesthetic (Y2K 에스테틱)
- **느낌**: Year 2000 digital nostalgia with chrome effects bubble shapes translucency and techno-optimism.
- **CSS**: `background:linear-gradient(135deg, #c0c0c0, #e8e8e8, #c0c0c0); border:2px solid #87ceeb; border-radius:20px; font-family:Tahoma, sans-serif; box-shadow:inset 0 2px 4px rgba(255,255,255,0.8)`
- **적합 산업**: fashion, entertainment, retail, creative-agency
- **피할 산업**: healthcare, fintech, legal
- **조합 스타일**: vaporwave, holographic, memphis
- **난이도**: medium

### Psychedelic (사이키델릭)
- **느낌**: Mind-bending visuals with swirling patterns extreme color saturation and optical illusions.
- **CSS**: `background:conic-gradient(#ff0055, #ff8800, #ffff00, #00ff55, #0088ff, #8800ff, #ff0055); animation:spin 10s linear infinite; filter:saturate(2) contrast(1.2); mix-blend-mode:hard-light`
- **적합 산업**: entertainment, music, art, nightlife
- **피할 산업**: healthcare, fintech, education, government
- **조합 스타일**: acid-graphics, maximalism, vaporwave
- **난이도**: high

### Punk (펑크)
- **느낌**: DIY cut-and-paste aesthetic with ransom-note typography safety pins and rebellious energy.
- **CSS**: `font-family:Courier New, monospace; transform:rotate(-1deg) skew(-1deg); border:2px solid #ff0033; background:#1a1a1a; color:#ff0033; text-decoration:line-through`
- **적합 산업**: music, art, fashion, nightlife
- **피할 산업**: healthcare, fintech, government, education
- **조합 스타일**: brutalism, grunge, anti-design
- **난이도**: low

---

## 🌿 부드러운/유기적 (Soft) — 12개

### Neumorphism (뉴모피즘)
- **느낌**: Soft extruded UI elements that appear to push out from the background using subtle shadow pairs.
- **CSS**: `background:#e0e5ec; box-shadow:8px 8px 16px #b8bec7, -8px -8px 16px #ffffff; border-radius:16px; border:none; color:#6b7280`
- **적합 산업**: saas, wellness, portfolio, lifestyle
- **피할 산업**: ecommerce, dashboard-dense, accessibility-first
- **조합 스타일**: claymorphism, soft-gradient, rounded-friendly
- **난이도**: medium

### Claymorphism (클레이모피즘)
- **느낌**: 3D clay-like UI elements with inflated appearance inner shadows and playful dimensional quality.
- **CSS**: `background:linear-gradient(135deg, #f5f7fa, #c3cfe2); border-radius:24px; box-shadow:8px 8px 16px rgba(0,0,0,0.1), inset -4px -4px 8px rgba(0,0,0,0.05), inset 4px 4px 8px rgba(255,255,255,0.9); border:none`
- **적합 산업**: children, education, lifestyle, wellness
- **피할 산업**: fintech, legal, government
- **조합 스타일**: neumorphism, rounded-friendly, cotton-candy
- **난이도**: medium

### Organic (오가닉)
- **느낌**: Natural freeform shapes with earth-tone palettes irregular curves and nature-derived patterns.
- **CSS**: `border-radius:30% 70% 60% 40% / 50% 40% 70% 50%; background:#f4ede4; color:#3d3027; font-family:Georgia, serif; padding:clamp(1.5rem, 4vw, 3rem); border:1px solid #d4c4b0`
- **적합 산업**: wellness, food, lifestyle, beauty, cosmetics
- **피할 산업**: fintech, gaming, tech
- **조합 스타일**: nature-inspired, warm-earth, scandinavian
- **난이도**: medium

### Pastel Dream (파스텔 드림)
- **느낌**: Soft muted color palette with gentle gradients and dreamy light-filled atmosphere.
- **CSS**: `background:linear-gradient(135deg, #ffecd2, #fcb69f); color:#5c4033; border-radius:20px; box-shadow:0 4px 20px rgba(252,182,159,0.3); font-family:Quicksand, sans-serif`
- **적합 산업**: lifestyle, beauty, wedding, children, education
- **피할 산업**: fintech, gaming, tech
- **조합 스타일**: soft-gradient, cotton-candy, rounded-friendly
- **난이도**: low

### Watercolor (수채화)
- **느낌**: Paint-bleed effects with soft edges color washes and artistic hand-painted quality.
- **CSS**: `background:radial-gradient(ellipse, rgba(173,216,230,0.4), rgba(255,182,193,0.3), transparent); filter:blur(0.5px); mix-blend-mode:multiply; opacity:0.9; border-radius:50% 40% 60% 50%`
- **적합 산업**: art, wedding, lifestyle, beauty, portfolio
- **피할 산업**: fintech, gaming, tech
- **조합 스타일**: hand-drawn, pastel-dream, organic
- **난이도**: high

### Soft Gradient (소프트 그라디언트)
- **느낌**: Gentle subtle gradients with smooth color transitions creating calm and approachable interfaces.
- **CSS**: `background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius:16px; color:#ffffff; box-shadow:0 4px 20px rgba(102,126,234,0.25); transition:all 0.3s ease`
- **적합 산업**: saas, wellness, education, lifestyle, ecommerce
- **피할 산업**: government, legal
- **조합 스타일**: glassmorphism, pastel-dream, aurora-ui
- **난이도**: low

### Rounded Friendly (라운드 프렌들리)
- **느낌**: Extra-rounded corners and circular elements creating playful approachable and warm interfaces.
- **CSS**: `border-radius:9999px; padding:12px 24px; background:#6366f1; color:#ffffff; font-weight:600; box-shadow:0 4px 14px rgba(99,102,241,0.3)`
- **적합 산업**: children, education, lifestyle, wellness, saas
- **피할 산업**: fintech, legal, government
- **조합 스타일**: claymorphism, pastel-dream, cotton-candy
- **난이도**: low

### Cotton Candy (코튼 캔디)
- **느낌**: Ultra-soft pink and blue palette with fluffy cloud-like elements and whimsical lightness.
- **CSS**: `background:linear-gradient(135deg, #fbc2eb, #a6c1ee); border-radius:24px; color:#4a3f6b; box-shadow:0 8px 30px rgba(251,194,235,0.3); font-family:Quicksand, sans-serif`
- **적합 산업**: children, beauty, wedding, lifestyle
- **피할 산업**: fintech, legal, government, gaming
- **조합 스타일**: pastel-dream, rounded-friendly, claymorphism
- **난이도**: low

### Nature Inspired (자연 영감)
- **느낌**: Design drawing from natural elements with earth tones leaf shapes and organic textures.
- **CSS**: `background:#f0ebe3; color:#3c5233; border:1px solid #a8b5a0; border-radius:12px; font-family:Lora, Georgia, serif; box-shadow:0 2px 8px rgba(60,82,51,0.1)`
- **적합 산업**: wellness, food, hospitality, real-estate, travel
- **피할 산업**: gaming, tech, fintech
- **조합 스타일**: organic, warm-earth, scandinavian
- **난이도**: low

### Hand Drawn (핸드 드로잉)
- **느낌**: Sketch-like quality with wobbly lines imperfect shapes and illustration-driven visual language.
- **CSS**: `border:2px solid #333; border-radius:255px 15px 225px 15px / 15px 225px 15px 255px; font-family:Caveat, cursive; background:#fffef5; box-shadow:2px 3px 0 #333`
- **적합 산업**: children, education, portfolio, creative-agency, food
- **피할 산업**: fintech, corporate, legal
- **조합 스타일**: watercolor, organic, cozy-comfort
- **난이도**: medium

### Warm Earth (웜 어스)
- **느낌**: Rich earth-toned palette with terracotta amber and olive creating grounded warm aesthetics.
- **CSS**: `background:#f5ebe0; color:#5c4033; border:1px solid #c8a882; border-radius:8px; font-family:DM Serif Display, Georgia, serif; accent-color:#bc6c25`
- **적합 산업**: hospitality, food, wellness, real-estate, lifestyle
- **피할 산업**: gaming, tech, cyberpunk
- **조합 스타일**: organic, nature-inspired, scandinavian
- **난이도**: low

### Cozy Comfort (코지 컴포트)
- **느낌**: Warm inviting design evoking comfort with soft textures rounded shapes and homey color palettes.
- **CSS**: `background:#fdf6ee; color:#4a3728; border-radius:16px; font-family:Nunito, sans-serif; box-shadow:0 4px 12px rgba(74,55,40,0.08); padding:24px; border:1px solid #e8d5c0`
- **적합 산업**: food, lifestyle, hospitality, wellness, children
- **피할 산업**: gaming, tech, fintech
- **조합 스타일**: warm-earth, rounded-friendly, nature-inspired
- **난이도**: low

---

## 🏢 특수/산업 (Specialty) — 13개

### Skeuomorphism (스큐어모피즘)
- **느낌**: Real-world material mimicry with realistic textures shadows gradients and physical metaphors.
- **CSS**: `background:linear-gradient(180deg, #f7f7f7, #d7d7d7); border:1px solid #aaa; box-shadow:inset 0 1px 0 rgba(255,255,255,0.8), 0 2px 4px rgba(0,0,0,0.2); border-radius:8px; text-shadow:0 1px 0 rgba(255,255,255,0.8)`
- **적합 산업**: education, entertainment, utility, creative-agency
- **피할 산업**: startup, ai-product
- **조합 스타일**: material-design, 3d-cards, neumorphism
- **난이도**: high

### Editorial Magazine (에디토리얼 매거진)
- **느낌**: Magazine-style layout with dramatic typography pull quotes and sophisticated image treatment.
- **CSS**: `font-family:Playfair Display, Georgia, serif; font-size:clamp(2rem, 5vw, 4rem); line-height:1.2; column-count:2; column-gap:40px; letter-spacing:-0.03em`
- **적합 산업**: media, fashion, luxury, editorial, blog
- **피할 산업**: saas, gaming
- **조합 스타일**: typographic, editorial-clean, whitespace-heavy
- **난이도**: medium

### Dashboard Dense (대시보드 덴스)
- **느낌**: Information-rich interfaces optimized for data density with compact spacing and efficient layouts.
- **CSS**: `display:grid; grid-template-columns:repeat(auto-fill, minmax(280px, 1fr)); gap:12px; font-size:13px; font-family:Inter, system-ui; padding:12px; line-height:1.4`
- **적합 산업**: fintech, saas, enterprise, analytics, healthcare
- **피할 산업**: creative-agency, portfolio
- **조합 스타일**: bento-grid, data-viz-first, corporate-clean
- **난이도**: medium

### Data Viz First (데이터 비즈 퍼스트)
- **느낌**: Design centered around data visualization with chart-optimized layouts and analytical color schemes.
- **CSS**: `font-family:IBM Plex Sans, system-ui; color:#334155; background:#f1f5f9; stroke-width:2; fill:none; stroke-linecap:round; font-variant-numeric:tabular-nums`
- **적합 산업**: analytics, fintech, healthcare, saas, enterprise
- **피할 산업**: fashion, entertainment, children
- **조합 스타일**: dashboard-dense, corporate-clean, minimalism
- **난이도**: medium

### Terminal Hacker (터미널 해커)
- **느낌**: Command-line inspired interface with monospace fonts dark backgrounds and green-on-black text.
- **CSS**: `font-family:JetBrains Mono, Fira Code, monospace; background:#0c0c0c; color:#00ff41; line-height:1.5; letter-spacing:0.05em; border:1px solid #1a3a1a; text-shadow:0 0 5px rgba(0,255,65,0.3)`
- **적합 산업**: developer-tools, ai-product, cybersecurity, education
- **피할 산업**: fashion, children, hospitality
- **조합 스타일**: cyberpunk, neon-glow, dark-mode-first
- **난이도**: low

### Retro Pixel (레트로 픽셀)
- **느낌**: 8-bit and 16-bit gaming aesthetic with pixel art chunky pixels and nostalgic game interfaces.
- **CSS**: `font-family:Press Start 2P, monospace; image-rendering:pixelated; background:#2c2137; color:#f0d988; border:4px solid #f0d988; box-shadow:4px 4px 0 #000; letter-spacing:0.1em`
- **적합 산업**: gaming, entertainment, children, education
- **피할 산업**: fintech, healthcare, luxury
- **조합 스타일**: y2k-aesthetic, memphis, punk
- **난이도**: medium

### Luxury Minimal (럭셔리 미니멀)
- **느낌**: High-end minimalism with premium feel using gold accents fine typography and lavish whitespace.
- **CSS**: `font-family:Didot, Bodoni MT, Georgia, serif; letter-spacing:0.2em; color:#1a1a1a; background:#faf9f6; border-bottom:1px solid #c9b58b; text-transform:uppercase; font-weight:300`
- **적합 산업**: luxury, fashion, hospitality, real-estate, jewelry
- **피할 산업**: gaming, children, tech
- **조합 스타일**: minimalism, whitespace-heavy, monochrome
- **난이도**: medium

### Dark Mode First (다크 모드 퍼스트)
- **느낌**: Design built primarily for dark backgrounds with optimized contrast and reduced eye strain.
- **CSS**: `background:#0f172a; color:#e2e8f0; border:1px solid #1e293b; box-shadow:0 4px 20px rgba(0,0,0,0.4); accent-color:#818cf8; border-radius:12px`
- **적합 산업**: developer-tools, ai-product, saas, gaming, entertainment
- **피할 산업**: children, wedding
- **조합 스타일**: terminal-hacker, ai-native, cyberpunk
- **난이도**: low

### Accessibility First (접근성 퍼스트)
- **느낌**: WCAG AAA compliant design with high contrast clear focus states and screen-reader optimized markup.
- **CSS**: `color:#000000; background:#ffffff; font-size:clamp(1rem, 1.2vw, 1.25rem); line-height:1.8; outline:3px solid #0000ff; outline-offset:2px; font-family:Atkinson Hyperlegible, system-ui`
- **적합 산업**: government, healthcare, education, enterprise, fintech
- **피할 산업**: creative-agency, gaming
- **조합 스타일**: high-contrast, corporate-clean, flat-design
- **난이도**: medium

### High Contrast (하이 콘트라스트)
- **느낌**: Maximum contrast design with stark black-white palette and bold color accents for visibility.
- **CSS**: `color:#000000; background:#ffffff; border:3px solid #000000; font-weight:700; font-size:1.125rem; letter-spacing:0.02em`
- **적합 산업**: government, healthcare, education, accessibility
- **피할 산업**: creative-agency, luxury, fashion
- **조합 스타일**: accessibility-first, brutalism, monochrome
- **난이도**: low

### Newspaper (뉴스페이퍼)
- **느낌**: Traditional broadsheet layout with multi-column text serif headlines and ruled dividers.
- **CSS**: `font-family:Times New Roman, Georgia, serif; column-count:3; column-gap:30px; column-rule:1px solid #ccc; line-height:1.55; color:#1a1a1a; text-align:justify`
- **적합 산업**: news, media, blog, editorial
- **피할 산업**: gaming, saas, ai-product
- **조합 스타일**: editorial-clean, typographic, grid-strict
- **난이도**: medium

### Blueprint (블루프린트)
- **느낌**: Technical drawing aesthetic with grid backgrounds cyan-on-blue palette and engineering precision.
- **CSS**: `background:#1e3a5f; color:#87ceeb; font-family:Courier New, monospace; border:1px solid rgba(135,206,235,0.3); background-image:linear-gradient(rgba(135,206,235,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(135,206,235,0.1) 1px, transparent 1px); background-size:20px 20px`
- **적합 산업**: architecture, engineering, developer-tools, education
- **피할 산업**: fashion, hospitality, children
- **조합 스타일**: wireframe-live, terminal-hacker, grid-strict
- **난이도**: medium

### Wireframe Live (와이어프레임 라이브)
- **느낌**: Functional interface styled as a living wireframe with sketch-like borders and placeholder aesthetics.
- **CSS**: `border:2px dashed #999; border-radius:4px; font-family:Balsamiq Sans, Comic Sans MS, cursive; background:#ffffff; color:#333; box-shadow:none; padding:16px`
- **적합 산업**: developer-tools, education, portfolio, startup
- **피할 산업**: luxury, fashion, hospitality
- **조합 스타일**: blueprint, hand-drawn, flat-design
- **난이도**: low
