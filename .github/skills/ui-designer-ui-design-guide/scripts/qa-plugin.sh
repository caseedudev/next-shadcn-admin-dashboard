#!/bin/bash

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PLUGIN_ROOT/../../../.." && pwd)"

SEARCH_SCRIPT="$PROJECT_ROOT/.agents/skills/ui-designer-ui-design-guide/scripts/search.py"
if [ ! -f "$SEARCH_SCRIPT" ]; then
  SEARCH_SCRIPT="$PLUGIN_ROOT/scripts/search.py"
fi

MODE="${1:---all}"
FAILURES=0
SKIPS=0

pass() {
  printf '  ✅ %s\n' "$1"
}

fail() {
  printf '  ❌ %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

skip() {
  printf '  ⏭ %s\n' "$1"
  SKIPS=$((SKIPS + 1))
}

run_search_suite() {
  echo "[Test 1: 검색 엔진]"

  python3 "$SEARCH_SCRIPT" "minimalism clean" --domain style >/tmp/ui-qa-style.out 2>/tmp/ui-qa-style.err
  if [ $? -eq 0 ] && rg -q 'score:' /tmp/ui-qa-style.out; then pass "1.1 도메인별 스타일 검색"; else fail "1.1 도메인별 스타일 검색"; fi

  python3 "$SEARCH_SCRIPT" "fintech banking" >/tmp/ui-qa-industry.out 2>/tmp/ui-qa-industry.err
  if [ $? -eq 0 ] && rg -q 'Industry Inference|Recommended matches' /tmp/ui-qa-industry.out; then pass "1.2 산업별 추론"; else fail "1.2 산업별 추론"; fi

  python3 "$SEARCH_SCRIPT" "saas dashboard modern" --design-system >/tmp/ui-qa-ds.out 2>/tmp/ui-qa-ds.err
  if [ $? -eq 0 ] && rg -q 'Style:|Colors:|Fonts:|Rules:' /tmp/ui-qa-ds.out; then pass "1.3 디자인 시스템 생성"; else fail "1.3 디자인 시스템 생성"; fi

  python3 "$SEARCH_SCRIPT" "luxury fashion ecommerce" >/tmp/ui-qa-global.out 2>/tmp/ui-qa-global.err
  if [ $? -eq 0 ] && rg -q 'Global Search:' /tmp/ui-qa-global.out; then pass "1.4 전체 도메인 검색"; else fail "1.4 전체 도메인 검색"; fi

  python3 "$SEARCH_SCRIPT" "교육 앱 밝은" >/tmp/ui-qa-ko.out 2>/tmp/ui-qa-ko.err
  if [ $? -eq 0 ]; then pass "1.5 한국어 검색"; else fail "1.5 한국어 검색"; fi
}

run_workflow_contracts() {
  echo "[Test 2-3: Codex 가능한 워크플로우 계약 검증]"
  skip "실제 인터랙티브 Q&A는 Codex 자동화 TTY에서 불안정하므로 프롬프트 계약 검증으로 대체"

  python3 - "$PROJECT_ROOT" > /tmp/ui-qa.out 2> /tmp/ui-qa.err <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
checks = {
    root / ".codex" / "prompts" / "ui-designer-ui-analyze.md": [
        ".ui-designer/analysis.json",
        "--refresh",
    ],
    root / ".codex" / "prompts" / "ui-designer-ui-design.md": [
        "Q3-1",
        "Q3.5",
        "Q3.6",
        "go with recommendations",
        "User approval is mandatory",
        ".agents/skills/ui-designer-ui-design-guide/scripts/search.py",
    ],
    root / ".codex" / "prompts" / "ui-designer-ui-qa.md": [
        "기존 `.ui-designer/` 내용이 있으면",
        "Test 7: 엣지 케이스 및 오류 처리",
        "7.7 CSV 데이터 참조 무결성",
    ],
}

ok = True
for path, needles in checks.items():
    text = path.read_text(encoding="utf-8")
    for needle in needles:
        if needle in text:
            print(f"PASS::{path.name}::{needle}")
        else:
            ok = False
            print(f"FAIL::{path.name}::{needle}")

sys.exit(0 if ok else 1)
PY
  while IFS= read -r line; do
    case "$line" in
      PASS::*)
        pass "${line#PASS::}"
        ;;
      FAIL::*)
        fail "${line#FAIL::}"
        ;;
    esac
  done < /tmp/ui-qa.out
}

run_antipattern_suite() {
  echo "[Test 4: 안티패턴]"
  local bad_file clean_file
  bad_file="$(mktemp /tmp/ui-designer-bad-XXXXXX.tsx)"
  clean_file="$(mktemp /tmp/ui-designer-clean-XXXXXX.tsx)"

  cat >"$bad_file" <<'EOF'
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
        <div style={{ color: '#333', backgroundColor: '#fff' }}>Hardcoded colors</div>
      </div>
    </div>
  );
}
EOF

  python3 "$SEARCH_SCRIPT" --check-anti-patterns "$bad_file" >/tmp/ui-qa-bad.out 2>/tmp/ui-qa-bad.err
  if [ $? -eq 0 ] && rg -q 'generic-purple-gradient|hardcoded-white|hardcoded-black|transition-all|img-tag|inline-hardcoded-color|no-heading-hierarchy' /tmp/ui-qa-bad.out; then
    pass "4.1 bad 코드 감지"
  else
    fail "4.1 bad 코드 감지"
  fi

  cat >"$clean_file" <<'EOF'
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

  python3 "$SEARCH_SCRIPT" --check-anti-patterns "$clean_file" >/tmp/ui-qa-clean.out 2>/tmp/ui-qa-clean.err
  if [ $? -eq 0 ] && rg -q 'No anti-patterns detected|Summary: 0 HIGH, 0 MEDIUM' /tmp/ui-qa-clean.out; then
    pass "4.2 클린 파일 검사"
  else
    fail "4.2 클린 파일 검사"
  fi

  rm -f "$bad_file" "$clean_file"
}

run_persist_suite() {
  echo "[Test 5-6: 영속성 및 재사용]"
  local backup
  backup="$(mktemp -d /tmp/ui-designer-qa-backup-XXXXXX)"
  if [ -d "$PROJECT_ROOT/.ui-designer" ]; then
    cp -R "$PROJECT_ROOT/.ui-designer/." "$backup/"
  fi
  rm -rf "$PROJECT_ROOT/.ui-designer"

  python3 "$SEARCH_SCRIPT" "education saas" --design-system --persist -p "TestEduApp" >/tmp/ui-qa-persist-master.out 2>/tmp/ui-qa-persist-master.err
  if [ $? -eq 0 ] && [ -f "$PROJECT_ROOT/.ui-designer/design-system.md" ] && rg -q 'TestEduApp' "$PROJECT_ROOT/.ui-designer/design-system.md"; then
    pass "5.1 Master 저장"
  else
    fail "5.1 Master 저장"
  fi

  python3 "$SEARCH_SCRIPT" "education saas" --design-system --persist -p "TestEduApp" --page "dashboard" >/tmp/ui-qa-persist-dashboard.out 2>/tmp/ui-qa-persist-dashboard.err
  if [ $? -eq 0 ] && [ -f "$PROJECT_ROOT/.ui-designer/pages/dashboard.md" ] && rg -q 'Page override saved|Retrieval:' /tmp/ui-qa-persist-dashboard.out; then
    pass "5.2 Page override 저장"
  else
    fail "5.2 Page override 저장"
  fi

  local master_before
  master_before="$(shasum "$PROJECT_ROOT/.ui-designer/design-system.md" | awk '{print $1}')"
  python3 "$SEARCH_SCRIPT" "fintech dark professional" --design-system --persist -p "TestEduApp" --page "analytics" >/tmp/ui-qa-persist-analytics.out 2>/tmp/ui-qa-persist-analytics.err
  local analytics_status=$?
  local master_after
  master_after="$(shasum "$PROJECT_ROOT/.ui-designer/design-system.md" | awk '{print $1}')"
  if [ $analytics_status -eq 0 ] && [ -f "$PROJECT_ROOT/.ui-designer/pages/analytics.md" ] && [ "$master_before" = "$master_after" ]; then
    pass "5.3 두 번째 Page override와 Master 보존"
  else
    fail "5.3 두 번째 Page override와 Master 보존"
  fi

  local design_prompt="$PROJECT_ROOT/.codex/prompts/ui-designer-ui-design.md"
  if [ -f "$design_prompt" ] && rg -q '기존 디자인 시스템을 로드했습니다|a\) 유지|b\) 이 페이지만 다른 스타일|c\) 전체 변경' "$design_prompt"; then
    pass "6.1 Step 0.5 프롬프트 계약"
  else
    fail "6.1 Step 0.5 프롬프트 계약"
  fi

  rm -rf "$PROJECT_ROOT/.ui-designer"
  if [ -n "$(ls -A "$backup" 2>/dev/null)" ]; then
    mkdir -p "$PROJECT_ROOT/.ui-designer"
    cp -R "$backup/." "$PROJECT_ROOT/.ui-designer/"
  fi
  rm -rf "$backup"
}

run_edge_cases() {
  echo "[Test 7: 엣지 케이스]"

  if python3 "$SEARCH_SCRIPT" "" --domain style >/tmp/ui-qa-empty.out 2>/tmp/ui-qa-empty.err; then
    pass "7.1 빈 쿼리"
  else
    fail "7.1 빈 쿼리"
  fi

  if python3 "$SEARCH_SCRIPT" "test" --domain nonexistent >/tmp/ui-qa-domain.out 2>/tmp/ui-qa-domain.err; then
    fail "7.2 존재하지 않는 도메인"
  elif ! rg -q 'Traceback' /tmp/ui-qa-domain.err; then
    pass "7.2 존재하지 않는 도메인"
  else
    fail "7.2 존재하지 않는 도메인"
  fi

  if python3 "$SEARCH_SCRIPT" "modern minimalist clean dark professional enterprise dashboard with data visualization charts graphs tables sidebar navigation responsive mobile-first accessibility" --domain style >/tmp/ui-qa-long.out 2>/tmp/ui-qa-long.err; then
    pass "7.3 매우 긴 쿼리"
  else
    fail "7.3 매우 긴 쿼리"
  fi

  if python3 "$SEARCH_SCRIPT" "it's a \"test\" with <special> & chars" --domain style >/tmp/ui-qa-special.out 2>/tmp/ui-qa-special.err; then
    pass "7.4 특수문자 쿼리"
  else
    fail "7.4 특수문자 쿼리"
  fi

  if python3 "$SEARCH_SCRIPT" --check-anti-patterns /tmp/nonexistent-file-12345.tsx >/tmp/ui-qa-missing-file.out 2>/tmp/ui-qa-missing-file.err; then
    fail "7.5 존재하지 않는 파일 안티패턴 검사"
  elif rg -q 'Error: file not found' /tmp/ui-qa-missing-file.err; then
    pass "7.5 존재하지 않는 파일 안티패턴 검사"
  else
    fail "7.5 존재하지 않는 파일 안티패턴 검사"
  fi

  local page_backup
  page_backup="$(mktemp -d /tmp/ui-designer-page-backup-XXXXXX)"
  if [ -d "$PROJECT_ROOT/.ui-designer" ]; then
    cp -R "$PROJECT_ROOT/.ui-designer/." "$page_backup/"
  fi
  rm -rf "$PROJECT_ROOT/.ui-designer"
  if python3 "$SEARCH_SCRIPT" "test" --design-system --page "dashboard" >/tmp/ui-qa-page-without-persist.out 2>/tmp/ui-qa-page-without-persist.err; then
    if [ ! -e "$PROJECT_ROOT/.ui-designer/pages/dashboard.md" ] && [ ! -e "$PROJECT_ROOT/.ui-designer/design-system.md" ]; then
      pass "7.6 --persist 없이 --page"
    else
      fail "7.6 --persist 없이 --page"
      rm -rf "$PROJECT_ROOT/.ui-designer"
    fi
  else
    fail "7.6 --persist 없이 --page"
  fi
  rm -rf "$PROJECT_ROOT/.ui-designer"
  if [ -n "$(ls -A "$page_backup" 2>/dev/null)" ]; then
    mkdir -p "$PROJECT_ROOT/.ui-designer"
    cp -R "$page_backup/." "$PROJECT_ROOT/.ui-designer/"
  fi
  rm -rf "$page_backup"

  if python3 "$SEARCH_SCRIPT" --check-integrity >/tmp/ui-qa-integrity.out 2>/tmp/ui-qa-integrity.err; then
    pass "7.7 CSV 참조 무결성"
  else
    fail "7.7 CSV 참조 무결성"
  fi
}

case "$MODE" in
  --all)
    run_search_suite
    run_workflow_contracts
    run_antipattern_suite
    run_persist_suite
    run_edge_cases
    ;;
  --search)
    run_search_suite
    ;;
  --workflow)
    run_workflow_contracts
    ;;
  --antipattern)
    run_antipattern_suite
    ;;
  --persist)
    run_persist_suite
    ;;
  --edge-cases)
    run_edge_cases
    ;;
  *)
    echo "Usage: $0 [--all|--search|--workflow|--antipattern|--persist|--edge-cases]"
    exit 2
    ;;
esac

echo
echo "요약: FAIL=$FAILURES, SKIP=$SKIPS"
exit "$FAILURES"
