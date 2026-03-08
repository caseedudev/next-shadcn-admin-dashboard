---
name: ui-qa
description: "ui-designer 플러그인 전체 기능 QA. 검색 엔진, 디자인 워크플로우, 안티패턴, 영속성 등 실제 동작 검증."
argument-hint: "[--all | --search | --workflow | --antipattern | --persist | --edge-cases]"
---

# UI Designer Plugin — 종합 QA 테스트

ui-designer 플러그인의 **모든 기능을 실제로 실행**하여 검증한다.
각 테스트는 독립적으로 실행 가능하며, `--all`로 전체를 순서대로 실행할 수 있다.

> Codex 자동화/비대화형 검증에서는 슬래시 커맨드 대신 아래 실행 스크립트를 우선 사용한다.
>
> ```bash
> bash .claude/plugins/local/ui-designer/scripts/qa-plugin.sh --all
> ```

> Codex 자동화에서는 Test 2~3의 인터랙티브 Q&A를 완전 재현하기 어렵다.
> 이 경우 같은 요구사항을 프롬프트 계약 검증으로 대체하고, 실제 셸로 돌릴 수 있는 Test 1/4/5/7은 그대로 실행한다.

> **중요**: 이 프롬프트는 검수용이다. 테스트 중 생성되는 파일(analysis.json, design-system.md 등)은
> 각 테스트 끝에 정리한다. 실제 프로젝트 파일을 수정하지 않는다.

기존 `.ui-designer/` 내용이 있으면 Test 2와 Test 5~6 실행 전에 전체 디렉토리를 임시 위치로 백업하고,
테스트 종료 후 원상 복구한다. `analysis.json`만 따로 복원하지 말고 `.ui-designer/` 전체를 기준으로 복원한다.

## Argument Parsing

- **No arguments / `--all`**: 전체 QA (Test 1~7 모두 실행)
- **`--search`**: 검색 엔진 테스트만 (Test 1)
- **`--workflow`**: 디자인 워크플로우 테스트만 (Test 2~3)
- **`--antipattern`**: 안티패턴 감지 테스트만 (Test 4)
- **`--persist`**: 디자인 시스템 영속성 테스트만 (Test 5)
- **`--edge-cases`**: 엣지 케이스 테스트만 (Test 6~7)

## 사전 준비

검색 스크립트 경로를 확인한다:

```bash
SEARCH_SCRIPT=""
if [ -f ".agents/skills/ui-designer-ui-design-guide/scripts/search.py" ]; then
  SEARCH_SCRIPT=".agents/skills/ui-designer-ui-design-guide/scripts/search.py"
elif [ -f ".claude/plugins/local/ui-designer/scripts/search.py" ]; then
  SEARCH_SCRIPT=".claude/plugins/local/ui-designer/scripts/search.py"
fi
echo "Search script: $SEARCH_SCRIPT"
```

스크립트가 없으면 나머지 테스트를 진행할 수 없으므로 중단하고 보고한다.

---

## Test 1: 검색 엔진 종합 테스트

BM25 검색 엔진의 모든 기능을 검증한다.

### 1.1 도메인별 검색 정확도

```bash
# 스타일 검색 — "minimalist"로 검색 시 minimalist 관련 스타일이 상위에 나와야 함
python3 $SEARCH_SCRIPT "minimalist clean" --domain style

# 컬러 검색 — "ocean blue"로 검색 시 파란 계열 팔레트가 나와야 함
python3 $SEARCH_SCRIPT "ocean blue" --domain color

# 폰트 검색 — "elegant serif"로 검색 시 세리프 폰트 페어링이 나와야 함
python3 $SEARCH_SCRIPT "elegant serif" --domain font
```

**검증 포인트**:
- [ ] 각 검색이 에러 없이 완료되는가?
- [ ] 검색 결과가 쿼리와 의미적으로 관련 있는가?
- [ ] BM25 스코어가 표시되는가?
- [ ] 결과가 스코어 내림차순으로 정렬되는가?

### 1.2 산업별 추론 검색

```bash
# 산업 키워드로 검색 — 산업별 추천이 나와야 함
python3 $SEARCH_SCRIPT "fintech banking"
python3 $SEARCH_SCRIPT "education e-learning"
python3 $SEARCH_SCRIPT "healthcare medical"
```

**검증 포인트**:
- [ ] 산업 키워드가 올바르게 매칭되는가?
- [ ] 추천 스타일/컬러/폰트가 산업에 적합한가?
- [ ] `industries.csv`의 추론 규칙이 올바르게 적용되는가?

### 1.3 디자인 시스템 생성

```bash
# 종합 디자인 시스템 생성
python3 $SEARCH_SCRIPT "saas dashboard modern" --design-system
```

**검증 포인트**:
- [ ] Style, Colors, Fonts, Rules 4개 섹션이 모두 출력되는가?
- [ ] 추천 스타일에 CSS 변수/설명이 포함되는가?
- [ ] 추천 컬러에 Primary/Secondary/Accent/BG hex 값이 있는가?
- [ ] 추천 폰트에 Display+Body 조합과 CDN 링크가 있는가?
- [ ] Rules에 data density, avoid 항목, principles가 있는가?

### 1.4 전체 도메인 검색 (도메인 미지정)

```bash
python3 $SEARCH_SCRIPT "luxury fashion ecommerce"
```

**검증 포인트**:
- [ ] 도메인을 지정하지 않아도 전체 검색이 동작하는가?
- [ ] 스타일/컬러/폰트/산업 결과가 혼합되어 나오는가?

### 1.5 한국어 검색

```bash
python3 $SEARCH_SCRIPT "교육 앱 밝은"
python3 $SEARCH_SCRIPT "금융 대시보드"
```

**검증 포인트**:
- [ ] 한국어 쿼리가 에러 없이 처리되는가?
- [ ] 결과가 나오는가? (0건이라도 에러가 아니면 PASS)

---

## Test 2: 프로젝트 분석 워크플로우 (`/ui-designer-ui-analyze`)

### 2.1 최초 분석

```
기존 .ui-designer/analysis.json 이 있으면 백업 후 삭제하고, /ui-designer-ui-analyze 를 실행한다.
```

**검증 포인트**:
- [ ] `.ui-designer/analysis.json`이 생성되는가?
- [ ] JSON 스키마가 올바른가? (project, routes, components, layout, style, patterns 키)
- [ ] `project.framework`가 "next.js"인가?
- [ ] `project.uiLibrary`가 "shadcn/ui"인가?
- [ ] `components.shadcn` 배열에 실제 설치된 컴포넌트가 나오는가?
- [ ] `layout.pattern`이 프로젝트 실제 구조와 일치하는가?
- [ ] `style.darkMode`가 올바르게 감지되는가?
- [ ] 결과 요약이 출력되는가?

### 2.2 재분석 (--refresh)

```
/ui-designer-ui-analyze --refresh 를 실행한다.
```

**검증 포인트**:
- [ ] 기존 파일을 무시하고 새로 분석하는가?
- [ ] `analyzedAt` 타임스탬프가 갱신되는가?

### 2.3 기존 분석 로드

```
.ui-designer/analysis.json 이 있는 상태에서 /ui-designer-ui-analyze 를 실행한다.
```

**검증 포인트**:
- [ ] 기존 분석을 로드하여 보여주는가?
- [ ] 불필요하게 재분석하지 않는가?

---

## Test 3: 디자인 워크플로우 (`/ui-designer-ui-design`)

### ⚠️ 주의: 이 테스트는 인터랙티브하다

실제 Q&A 과정을 거치므로, 각 단계에서 올바른 동작을 확인한다.
**코드 생성 단계에서는 "여기서 멈춰주세요, 검수 중입니다"라고 중단한다.**

### 3.1 페이지 유형 키워드 인식

```
/ui-designer-ui-design dashboard
```

**검증 포인트**:
- [ ] "dashboard" 키워드를 인식하여 대시보드 타입으로 시작하는가?
- [ ] Step 0에서 analysis.json을 확인하는가?
- [ ] Step 0.5에서 design-system.md를 확인하는가?

### 3.2 Q&A 형식 준수

**검증 포인트**:
- [ ] Q1부터 순서대로 질문하는가?
- [ ] 각 질문에 `> [why this matters]` 설명이 있는가?
- [ ] `★ Recommendation` 이 analysis.json 기반으로 제시되는가?
- [ ] a) b) c) d) 선택지가 제공되는가?

### 3.3 디자인 컨셉 선택 플로우 (Q3 → Q3-1 → Q3.5 → Q3.6)

Q3에서 카테고리를 선택하면:

**검증 포인트**:
- [ ] Q3: 5개 카테고리(Modern/Classic/Bold/Soft/Specialized)가 제시되는가?
- [ ] Q3-1: 선택한 카테고리 내 구체적 스타일이 제시되는가?
- [ ] Q3-1에서 `search.py --domain style`이 활용되는가?
- [ ] Q3.5: 선택한 컨셉+산업에 맞는 컬러 팔레트가 제시되는가?
- [ ] Q3.5에서 `search.py --domain color`가 활용되는가?
- [ ] Q3.6: 선택한 컨셉에 맞는 폰트 페어링이 제시되는가?
- [ ] Q3.6에서 `search.py --domain font`가 활용되는가?

### 3.4 "기존 프로젝트 스타일 유지" 분기

Q3에서 "기존 프로젝트 스타일 유지"를 선택하면:

**검증 포인트**:
- [ ] Q3-1, Q3.5, Q3.6이 건너뛰어지는가?
- [ ] 바로 유형별 질문으로 넘어가는가?

### 3.5 "go with recommendations" 처리

Q&A 중 "추천대로 해줘" 또는 "go with recommendations"라고 답하면:

**검증 포인트**:
- [ ] 모든 ★ Recommendation이 한번에 적용되는가?
- [ ] 적용된 내용이 요약되어 보이는가?

### 3.6 디자인 제안서 형식

Q&A 완료 후 디자인 제안서가 출력되면:

**검증 포인트**:
- [ ] Style System 섹션이 있는가? (디자인 컨셉, 컬러 팔레트 hex, 폰트 페어링, CDN URL)
- [ ] Layout 섹션에 ASCII skeleton이 있는가?
- [ ] Components 섹션에 shadcn 매핑이 있는가?
- [ ] File structure 섹션이 있는가?
- [ ] "승인하시겠습니까?" 확인 요청이 있는가?

### 3.7 자연어 입력 테스트

```
/ui-designer-ui-design 학생 관리 페이지를 만들고 싶어. 학생 목록, 검색, 필터링 기능이 필요해.
```

**검증 포인트**:
- [ ] 자연어를 분석하여 적절한 페이지 유형(CRUD List)을 추론하는가?
- [ ] 추론한 유형을 사용자에게 확인하는가?

---

## Test 4: 안티패턴 감지 테스트

### 4.1 검색 엔진 안티패턴 검사

```bash
# 의도적으로 안티패턴이 포함된 테스트 파일 생성
cat > /tmp/test-anti-pattern.tsx << 'EOF'
import React from 'react';

export default function BadPage() {
  return (
    <div className="bg-white text-black">
      <h3>Welcome</h3>
      <div className="bg-gradient-to-r from-purple-500 to-pink-500">
        <h1>Hero Section</h1>
      </div>
      <div className="transition-all duration-300">
        <img src="/photo.jpg" />
        <div style={{ color: '#333', backgroundColor: '#fff' }}>
          Hardcoded colors
        </div>
      </div>
    </div>
  );
}
EOF

python3 $SEARCH_SCRIPT --check-anti-patterns /tmp/test-anti-pattern.tsx
rm /tmp/test-anti-pattern.tsx
```

**검증 포인트**:
- [ ] `bg-white`, `text-black` 하드코딩 컬러가 감지되는가?
- [ ] `from-purple-500 to-pink-500` 제네릭 보라색 그래디언트가 감지되는가?
- [ ] `transition-all` 불필요한 전체 트랜지션이 감지되는가?
- [ ] `<img>` 태그 (Next.js Image 미사용)가 감지되는가?
- [ ] 인라인 스타일 하드코딩 컬러가 감지되는가?
- [ ] 제목 계층 오류 (h3 → h1)가 감지되는가?
- [ ] 각 감지 항목에 심각도(HIGH/MEDIUM/LOW)가 표시되는가?
- [ ] 대안/수정 방법이 제시되는가?

### 4.2 클린 파일 검사

```bash
cat > /tmp/test-clean.tsx << 'EOF'
import React from 'react';
import Image from 'next/image';
import { Button } from '@/components/ui/button';

export default function CleanPage() {
  return (
    <div className="bg-background text-foreground">
      <h1>Welcome</h1>
      <h2>Subtitle</h2>
      <Image src="/photo.jpg" alt="Photo description" width={400} height={300} />
      <Button variant="default">Click me</Button>
    </div>
  );
}
EOF

python3 $SEARCH_SCRIPT --check-anti-patterns /tmp/test-clean.tsx
rm /tmp/test-clean.tsx
```

**검증 포인트**:
- [ ] 안티패턴이 감지되지 않는가? (0건 또는 LOW만)
- [ ] false positive가 없는가?

---

## Test 5: 디자인 시스템 영속성 테스트

### 5.1 Master 저장

```bash
# 기존 .ui-designer 전체 백업
[ -d ".ui-designer" ] && cp -R .ui-designer /tmp/ui-designer-backup

python3 $SEARCH_SCRIPT "education saas" --design-system --persist -p "TestEduApp"
```

**검증 포인트**:
- [ ] `.ui-designer/design-system.md`가 생성되는가?
- [ ] 파일 내용에 "TestEduApp" 프로젝트명이 포함되는가?
- [ ] Industry, Style, Colors, Fonts 섹션이 모두 있는가?
- [ ] `[persist] Master saved` 메시지가 출력되는가?

### 5.2 Page Override 저장

```bash
python3 $SEARCH_SCRIPT "education saas" --design-system --persist -p "TestEduApp" --page "dashboard"
```

**검증 포인트**:
- [ ] `.ui-designer/pages/dashboard.md`가 생성되는가?
- [ ] Master와 동일한 형식이지만 별도 파일인가?
- [ ] `[persist] Page override saved` 메시지가 출력되는가?
- [ ] Retrieval hint가 출력되는가?

### 5.3 다른 쿼리로 두 번째 Page Override

```bash
python3 $SEARCH_SCRIPT "fintech dark professional" --design-system --persist -p "TestEduApp" --page "analytics"
```

**검증 포인트**:
- [ ] `.ui-designer/pages/analytics.md`가 생성되는가?
- [ ] dashboard.md와 다른 내용인가? (다른 쿼리이므로 다른 추천)
- [ ] Master 파일은 변경되지 않았는가?

### 5.4 정리

```bash
rm -rf .ui-designer
[ -d "/tmp/ui-designer-backup" ] && mv /tmp/ui-designer-backup .ui-designer
```

---

## Test 6: 디자인 시스템 재사용 플로우 (Step 0.5)

### 6.1 디자인 시스템이 있을 때 Q&A 단축

```
1. 먼저 Master 디자인 시스템을 생성한다:
   python3 $SEARCH_SCRIPT "saas modern" --design-system --persist -p "TestProject"

2. /ui-designer-ui-design dashboard 를 실행한다.

3. Step 0.5에서 기존 디자인 시스템 로드 메시지가 나오는지 확인한다.
```

**검증 포인트**:
- [ ] "기존 디자인 시스템을 로드했습니다" 메시지가 나오는가?
- [ ] 스타일/컬러/폰트 요약이 표시되는가?
- [ ] a) 유지 / b) 이 페이지만 다른 스타일 / c) 전체 변경 선택지가 있는가?
- [ ] a)를 선택하면 Q3/Q3-1/Q3.5/Q3.6이 건너뛰어지는가?

### 6.2 정리

```bash
rm -rf .ui-designer
[ -d "/tmp/ui-designer-backup" ] && mv /tmp/ui-designer-backup .ui-designer
```

---

## Test 7: 엣지 케이스 및 오류 처리

### 7.1 빈 쿼리

```bash
python3 $SEARCH_SCRIPT "" --domain style
```

**검증 포인트**:
- [ ] 에러 없이 처리되는가? (빈 결과 또는 전체 목록)
- [ ] 크래시하지 않는가?

### 7.2 존재하지 않는 도메인

```bash
python3 $SEARCH_SCRIPT "test" --domain nonexistent
```

**검증 포인트**:
- [ ] 적절한 에러 메시지가 나오는가?
- [ ] traceback 없이 깔끔하게 처리되는가?

### 7.3 매우 긴 쿼리

```bash
python3 $SEARCH_SCRIPT "modern minimalist clean dark professional enterprise dashboard with data visualization charts graphs tables sidebar navigation responsive mobile-first accessibility" --domain style
```

**검증 포인트**:
- [ ] 긴 쿼리도 에러 없이 처리되는가?
- [ ] 합리적인 결과가 반환되는가?

### 7.4 특수문자 쿼리

```bash
python3 $SEARCH_SCRIPT "it's a \"test\" with <special> & chars" --domain style
```

**검증 포인트**:
- [ ] 특수문자가 에러를 발생시키지 않는가?

### 7.5 존재하지 않는 파일 안티패턴 검사

```bash
python3 $SEARCH_SCRIPT --check-anti-patterns /tmp/nonexistent-file-12345.tsx
```

**검증 포인트**:
- [ ] 파일 미존재 에러가 적절하게 처리되는가?
- [ ] traceback 없이 사용자 친화적 메시지가 나오는가?

### 7.6 --persist 없이 --page 사용

```bash
python3 $SEARCH_SCRIPT "test" --design-system --page "dashboard"
```

**검증 포인트**:
- [ ] --persist 없이 --page를 쓰면 어떻게 되는가?
- [ ] 무시되거나 적절한 경고가 나오는가?

### 7.7 CSV 데이터 참조 무결성

```bash
# industries.csv에서 참조하는 모든 style/color/font ID가 실제로 존재하는지 확인
# 방법 1: search.py --check-integrity 사용 (권장)
python3 $SEARCH_SCRIPT --check-integrity

# 방법 2: 인라인 Python (위 방법이 실패할 경우)
python3 -c "
import csv, os

base = '.agents/skills/ui-designer-ui-design-guide/data'
if not os.path.isdir(base):
    base = '.claude/plugins/local/ui-designer/data'

def load_ids(filename, id_col='id'):
    with open(f'{base}/{filename}', encoding='utf-8') as f:
        return {row[id_col] for row in csv.DictReader(f)}

style_ids = load_ids('styles.csv')
color_ids = load_ids('colors.csv')
font_ids = load_ids('fonts.csv')

errors = []
with open(f'{base}/industries.csv', encoding='utf-8') as f:
    for row in csv.DictReader(f):
        for sid in row.get('recommended_styles','').split(','):
            sid = sid.strip()
            if sid and sid not in style_ids:
                errors.append(f'industry={row[\"id\"]}: style \"{sid}\" not found')
        for cid in row.get('recommended_colors','').split(','):
            cid = cid.strip()
            if cid and cid not in color_ids:
                errors.append(f'industry={row[\"id\"]}: color \"{cid}\" not found')
        for fid in row.get('recommended_fonts','').split(','):
            fid = fid.strip()
            if fid and fid not in font_ids:
                errors.append(f'industry={row[\"id\"]}: font \"{fid}\" not found')

if errors:
    print(f'❌ {len(errors)} reference errors:')
    for e in errors[:10]:
        print(f'  - {e}')
    if len(errors) > 10:
        print(f'  ... and {len(errors)-10} more')
else:
    print('✅ 참조 무결성 — 0 오류')
"
```

**검증 포인트**:
- [ ] 참조 오류가 0건인가?

---

## QA 결과 보고서

모든 테스트 완료 후 아래 형식으로 최종 보고서를 출력한다:

```
══════════════════════════════════════════════════════
  UI Designer Plugin — QA Test Report
══════════════════════════════════════════════════════

  Test 1: 검색 엔진          [✅ PASS | ❌ FAIL] (N/N 항목)
    1.1 도메인별 검색         ✅
    1.2 산업별 추론           ✅
    1.3 디자인 시스템 생성     ✅
    1.4 전체 도메인 검색       ✅
    1.5 한국어 검색           ✅

  Test 2: 프로젝트 분석       [✅ PASS | ❌ FAIL] (N/N 항목)
    2.1 최초 분석             ✅
    2.2 재분석 --refresh      ✅
    2.3 기존 분석 로드         ✅

  Test 3: 디자인 워크플로우    [✅ PASS | ❌ FAIL] (N/N 항목)
    3.1 페이지 유형 인식       ✅
    3.2 Q&A 형식 준수         ✅
    3.3 디자인 컨셉 플로우     ✅
    3.4 스타일 유지 분기       ✅
    3.5 추천 일괄 적용         ✅
    3.6 디자인 제안서 형식     ✅
    3.7 자연어 입력           ✅

  Test 4: 안티패턴 감지       [✅ PASS | ❌ FAIL] (N/N 항목)
    4.1 안티패턴 포함 파일     ✅
    4.2 클린 파일             ✅

  Test 5: 디자인 시스템 영속성 [✅ PASS | ❌ FAIL] (N/N 항목)
    5.1 Master 저장           ✅
    5.2 Page override         ✅
    5.3 두 번째 override      ✅

  Test 6: 디자인 시스템 재사용 [✅ PASS | ❌ FAIL] (N/N 항목)
    6.1 Q&A 단축 플로우       ✅

  Test 7: 엣지 케이스         [✅ PASS | ❌ FAIL] (N/N 항목)
    7.1 빈 쿼리              ✅
    7.2 잘못된 도메인          ✅
    7.3 긴 쿼리              ✅
    7.4 특수문자              ✅
    7.5 없는 파일             ✅
    7.6 --page without --persist  ✅
    7.7 CSV 참조 무결성       ✅

──────────────────────────────────────────────────────
  Overall: ✅ ALL PASS  |  ❌ N FAIL (상세 내용 위 참조)
══════════════════════════════════════════════════════
```

**FAIL 항목이 있으면**:
1. 정확한 에러 메시지 / 실제 동작 기록
2. 기대 동작과의 차이 설명
3. 원인 추정 (가능하면)
4. 수정 제안
