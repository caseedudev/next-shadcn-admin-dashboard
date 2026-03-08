---
name: ui-designer-ui-validate
description: "ui-designer 플러그인 검수. 구조, 데이터 무결성, 훅, 검색 엔진, 디자인 시스템 영속성을 종합 검증."
argument-hint: "[--full | --data | --hooks | --search | --persist]"
---

# UI Designer Plugin Validation

ui-designer 플러그인의 모든 구성 요소를 검증한다.

> Codex 자동화/비대화형 검증에서는 슬래시 커맨드 대신 아래 실행 스크립트를 우선 사용한다.
>
> ```bash
> bash .claude/plugins/local/ui-designer/scripts/validate-plugin.sh --full
> ```

## Argument Parsing

- **No arguments / `--full`**: 전체 검증 (1~6 모두 실행)
- **`--data`**: 데이터 무결성만 검증 (Step 3)
- **`--hooks`**: 훅 스크립트만 검증 (Step 4)
- **`--search`**: 검색 엔진만 검증 (Step 5)
- **`--persist`**: 디자인 시스템 영속성만 검증 (Step 6)

## Validation Steps

### 공통 경로 해석

아래 검증 단계에서 사용할 경로를 먼저 정한다.

```bash
PLUGIN_ROOT=".claude/plugins/local/ui-designer"
SEARCH_SCRIPT=""

if [ -f ".agents/skills/ui-designer-ui-design-guide/scripts/search.py" ]; then
  SEARCH_SCRIPT=".agents/skills/ui-designer-ui-design-guide/scripts/search.py"
elif [ -f "$PLUGIN_ROOT/scripts/search.py" ]; then
  SEARCH_SCRIPT="$PLUGIN_ROOT/scripts/search.py"
fi
```

### Step 1: 구조 검증

플러그인 디렉토리 구조를 확인한다.

**필수 파일 체크리스트**:

| 경로 | 역할 |
|------|------|
| `.claude-plugin/plugin.json` | 매니페스트 |
| `commands/ui-design.md` | UI 설계 커맨드 |
| `commands/ui-analyze.md` | UI 분석 커맨드 |
| `commands/ui-validate.md` | 이 검증 커맨드 |
| `agents/ui-analyzer.md` | 분석 에이전트 |
| `agents/ui-consultant.md` | 컨설턴트 에이전트 |
| `skills/ui-design-guide/SKILL.md` | 디자인 가이드 스킬 |
| `hooks/hooks.json` | 훅 설정 |
| `hooks/scripts/validate-design.sh` | 디자인 검증 훅 |
| `hooks/scripts/check-anti-patterns.sh` | 안티패턴 검사 훅 |
| `.agents/skills/ui-designer-ui-design-guide/scripts/search.py` | BM25 검색 엔진 |
| `README.md` | 문서 |

**검증 방법**:
1. 각 파일 존재 여부 확인
2. `plugin.json`을 JSON으로 파싱하여 `name`, `version`, `description` 필드 확인
3. `SKILL.md` frontmatter에 `name`, `description` 필드 확인
4. 커맨드 `.md` 파일에 frontmatter `name`, `description` 필드 확인
5. 에이전트 `.md` 파일에 frontmatter `name`, `description` 필드 확인

**출력 형식**:
```
[구조 검증]
  ✅ plugin.json — name: ui-designer, version: 0.2.0
  ✅ commands/ui-design.md — frontmatter 유효
  ✅ commands/ui-analyze.md — frontmatter 유효
  ✅ commands/ui-validate.md — frontmatter 유효
  ✅ agents/ui-analyzer.md — frontmatter 유효
  ✅ agents/ui-consultant.md — frontmatter 유효
  ✅ skills/ui-design-guide/SKILL.md — frontmatter 유효
  ✅ hooks/hooks.json — JSON 유효
  ✅ hooks/scripts/validate-design.sh — 실행 권한 확인
  ✅ hooks/scripts/check-anti-patterns.sh — 실행 권한 확인
  ✅ scripts/search.py — 실행 권한 확인
  ✅ README.md — 존재
  결과: 12/12 PASS
```

### Step 2: 레퍼런스 파일 검증

`skills/ui-design-guide/references/` 디렉토리의 11개 파일 존재 여부를 확인한다.

**필수 레퍼런스**:
- `component-catalog.md`, `layout-patterns.md`, `page-templates.md`
- `qa-templates.md`, `design-principles.md`, `external-resources.md`
- `design-concepts.md`, `color-palettes.md`, `font-pairings.md`
- `industry-rules.md`, `anti-patterns.md`

**출력 형식**:
```
[레퍼런스 검증]
  ✅ 11/11 레퍼런스 파일 존재
  결과: PASS
```

### Step 3: 데이터 무결성 검증

CSV 데이터 파일의 무결성을 확인한다.

**검증 항목**:
1. `data/` 디렉토리에 5개 CSV 존재 확인: `styles.csv`, `colors.csv`, `fonts.csv`, `industries.csv`, `anti-patterns.csv`
2. 각 CSV의 행 수가 기대값과 일치하는지 확인:
   - styles: 67 + 헤더 = 68행
   - colors: 116 + 헤더 = 117행
   - fonts: 57 + 헤더 = 58행
   - industries: 96 + 헤더 = 97행
   - anti-patterns: 30 + 헤더 = 31행
3. **참조 무결성**: `industries.csv`에서 참조하는 style/color/font ID가 실제 CSV에 존재하는지 확인
   ```bash
   python3 <search_script> --check-integrity
   ```
   (스크립트에 해당 기능이 없으면 수동으로 확인)

**출력 형식**:
```
[데이터 무결성]
  ✅ styles.csv — 68행 (67 스타일)
  ✅ colors.csv — 117행 (116 팔레트)
  ✅ fonts.csv — 58행 (57 페어링)
  ✅ industries.csv — 97행 (96 규칙)
  ✅ anti-patterns.csv — 31행 (30 패턴)
  ✅ 참조 무결성 — 0 오류
  결과: PASS
```

### Step 4: 훅 검증

훅 스크립트가 올바르게 동작하는지 확인한다.

**검증 방법**:
1. `hooks.json` JSON 파싱 및 구조 확인
2. 각 훅 스크립트 실행 권한(`chmod +x`) 확인
3. 테스트 파일로 각 훅을 실행하여 동작 확인:

```bash
# validate-design.sh 테스트 — 하드코딩 컬러 감지
echo 'export default function Test() { return <div className="bg-white text-black">test</div> }' > /tmp/test-hook.tsx
bash "$PLUGIN_ROOT/hooks/scripts/validate-design.sh" /tmp/test-hook.tsx

# check-anti-patterns.sh 테스트 — 안티패턴 감지
bash "$PLUGIN_ROOT/hooks/scripts/check-anti-patterns.sh" /tmp/test-hook.tsx
rm /tmp/test-hook.tsx
```

4. 각 훅이 문제를 올바르게 감지하면 PASS, 아니면 FAIL

**출력 형식**:
```
[훅 검증]
  ✅ hooks.json — 유효한 PostToolUse 설정
  ✅ validate-design.sh — 하드코딩 컬러 감지 정상
  ✅ check-anti-patterns.sh — 안티패턴 감지 정상
  결과: PASS
```

### Step 5: 검색 엔진 검증

`$SEARCH_SCRIPT`의 핵심 기능을 테스트한다.

**테스트 케이스**:

```bash
# 1. 도메인별 검색
python3 $SEARCH_SCRIPT "minimalist" --domain style    # 스타일 검색
python3 $SEARCH_SCRIPT "blue" --domain color          # 컬러 검색
python3 $SEARCH_SCRIPT "sans serif" --domain font     # 폰트 검색

# 2. 디자인 시스템 생성
python3 $SEARCH_SCRIPT "fintech saas" --design-system

# 3. 안티패턴 검사 (테스트 파일 필요)
echo '<div className="bg-white text-black bg-gradient-to-r from-purple-500">' > /tmp/test-ap.tsx
python3 $SEARCH_SCRIPT --check-anti-patterns /tmp/test-ap.tsx
rm /tmp/test-ap.tsx

# 4. 전체 검색 (도메인 미지정)
python3 $SEARCH_SCRIPT "education"
```

**검증 기준**:
- 각 검색이 0개 이상의 결과를 반환하고 에러 없이 완료
- `--design-system`이 Style/Colors/Fonts/Rules 4개 섹션을 모두 출력
- `--check-anti-patterns`이 감지 결과를 출력

**출력 형식**:
```
[검색 엔진 검증]
  ✅ style 도메인 검색 — N건 반환
  ✅ color 도메인 검색 — N건 반환
  ✅ font 도메인 검색 — N건 반환
  ✅ --design-system — 4개 섹션 정상 출력
  ✅ --check-anti-patterns — 감지 정상
  ✅ 전체 검색 — N건 반환
  결과: PASS
```

### Step 6: 디자인 시스템 영속성 검증

`--persist` 플래그의 계층형 저장을 테스트한다.

**테스트 순서**:

```bash
# 1. Master 저장
python3 $SEARCH_SCRIPT "education saas" --design-system --persist -p "TestProject"
# 확인: .ui-designer/design-system.md 존재, "TestProject" 포함

# 2. 페이지 오버라이드 저장
python3 $SEARCH_SCRIPT "education saas" --design-system --persist -p "TestProject" --page "dashboard"
# 확인: .ui-designer/pages/dashboard.md 존재

# 3. 정리
rm -rf .ui-designer/design-system.md .ui-designer/pages/
```

**검증 기준**:
- Master 파일이 `.ui-designer/design-system.md`에 정상 생성
- 페이지 오버라이드가 `.ui-designer/pages/dashboard.md`에 정상 생성
- 각 파일에 프로젝트명과 디자인 시스템 정보가 포함

**출력 형식**:
```
[영속성 검증]
  ✅ Master 저장 — .ui-designer/design-system.md 생성
  ✅ Page override 저장 — .ui-designer/pages/dashboard.md 생성
  ✅ 정리 완료
  결과: PASS
```

### Step 7: 외부 동기화 검증

소스 파일과 외부 동기화 타겟이 일치하는지 확인한다.

**비교 대상**:

| 소스 | 타겟 | 비교 방법 |
|------|------|----------|
| `skills/ui-design-guide/SKILL.md` | `.agents/skills/ui-designer-ui-design-guide/SKILL.md` | diff |
| `skills/ui-design-guide/references/*` | `.agents/skills/ui-designer-ui-design-guide/references/*` | diff |
| `data/*.csv` | `.agents/skills/ui-designer-ui-design-guide/data/*.csv` | diff |
| `.agents/skills/ui-designer-ui-design-guide/scripts/search.py` | `.agents/skills/ui-designer-ui-design-guide/scripts/search.py` | diff |

경로는 프로젝트 루트 기준. 소스 경로 앞에 `.claude/plugins/local/ui-designer/`를 붙인다.

**출력 형식**:
```
[외부 동기화]
  ✅ SKILL.md — 동기화 일치
  ✅ references/ (11 files) — 동기화 일치
  ✅ data/ (5 files) — 동기화 일치
  ✅ scripts/search.py — 동기화 일치
  결과: PASS
```

## Final Report

모든 Step을 종합한 최종 보고서를 출력한다.

```
════════════════════════════════════════════
  UI Designer Plugin Validation Report
════════════════════════════════════════════

  구조 검증:     ✅ PASS (12/12)
  레퍼런스:      ✅ PASS (11/11)
  데이터 무결성:  ✅ PASS (5/5 CSV, 참조 0 오류)
  훅:           ✅ PASS (2/2 스크립트)
  검색 엔진:     ✅ PASS (6/6 테스트)
  영속성:        ✅ PASS (Master + Page)
  외부 동기화:    ✅ PASS (4/4 diff)

  Overall: ✅ ALL PASS
════════════════════════════════════════════
```

FAIL이 있으면 해당 항목의 상세 오류를 함께 출력한다.
