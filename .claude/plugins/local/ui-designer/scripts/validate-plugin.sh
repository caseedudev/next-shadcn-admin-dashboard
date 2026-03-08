#!/bin/bash

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PLUGIN_ROOT/../../../.." && pwd)"

SEARCH_SCRIPT="$PROJECT_ROOT/.agents/skills/ui-designer-ui-design-guide/scripts/search.py"
if [ ! -f "$SEARCH_SCRIPT" ]; then
  SEARCH_SCRIPT="$PLUGIN_ROOT/scripts/search.py"
fi

MODE="${1:---full}"
FAILURES=0

rel_path() {
  python3 - "$PROJECT_ROOT" "$1" <<'PY'
from pathlib import Path
import sys
print(Path(sys.argv[2]).resolve().relative_to(Path(sys.argv[1]).resolve()))
PY
}

pass() {
  printf '  ✅ %s\n' "$1"
}

fail() {
  printf '  ❌ %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

require_success() {
  local label="$1"
  shift
  if "$@" >/tmp/ui-designer-validate.out 2>/tmp/ui-designer-validate.err; then
    pass "$label"
  else
    fail "$label"
    sed -n '1,80p' /tmp/ui-designer-validate.err
    sed -n '1,80p' /tmp/ui-designer-validate.out
  fi
}

run_structure() {
  echo "[구조 검증]"

  local required=(
    "$PLUGIN_ROOT/.claude-plugin/plugin.json"
    "$PLUGIN_ROOT/commands/ui-design.md"
    "$PLUGIN_ROOT/commands/ui-analyze.md"
    "$PLUGIN_ROOT/commands/ui-validate.md"
    "$PLUGIN_ROOT/commands/ui-qa.md"
    "$PLUGIN_ROOT/agents/ui-analyzer.md"
    "$PLUGIN_ROOT/agents/ui-consultant.md"
    "$PLUGIN_ROOT/skills/ui-design-guide/SKILL.md"
    "$PLUGIN_ROOT/hooks/hooks.json"
    "$PLUGIN_ROOT/hooks/scripts/validate-design.sh"
    "$PLUGIN_ROOT/hooks/scripts/check-anti-patterns.sh"
    "$PLUGIN_ROOT/scripts/search.py"
    "$PLUGIN_ROOT/scripts/validate-plugin.sh"
    "$PLUGIN_ROOT/scripts/qa-plugin.sh"
    "$PLUGIN_ROOT/README.md"
  )

  local path
  for path in "${required[@]}"; do
    if [ -e "$path" ]; then
      pass "$(rel_path "$path")"
    else
      fail "$(rel_path "$path")"
    fi
  done

  python3 - "$PLUGIN_ROOT" <<'PY'
import json
import sys
from pathlib import Path

plugin_root = Path(sys.argv[1])
checks = [
    plugin_root / ".claude-plugin" / "plugin.json",
    plugin_root / "commands" / "ui-design.md",
    plugin_root / "commands" / "ui-analyze.md",
    plugin_root / "commands" / "ui-validate.md",
    plugin_root / "commands" / "ui-qa.md",
    plugin_root / "agents" / "ui-analyzer.md",
    plugin_root / "agents" / "ui-consultant.md",
    plugin_root / "skills" / "ui-design-guide" / "SKILL.md",
]

for path in checks:
    text = path.read_text(encoding="utf-8")
    if path.name == "plugin.json":
        data = json.loads(text)
        assert all(key in data for key in ("name", "version", "description"))
    else:
        assert text.startswith("---\n"), f"frontmatter missing: {path}"
        assert "\nname:" in text and "\ndescription:" in text, f"invalid frontmatter: {path}"
PY
  if [ $? -eq 0 ]; then
    pass "frontmatter/json 유효성"
  else
    fail "frontmatter/json 유효성"
  fi
}

run_references() {
  echo "[레퍼런스 검증]"
  local refs=(
    component-catalog.md
    layout-patterns.md
    page-templates.md
    qa-templates.md
    design-principles.md
    external-resources.md
    design-concepts.md
    color-palettes.md
    font-pairings.md
    industry-rules.md
    anti-patterns.md
  )

  local ref
  for ref in "${refs[@]}"; do
    if [ -f "$PLUGIN_ROOT/skills/ui-design-guide/references/$ref" ]; then
      pass "$ref"
    else
      fail "$ref"
    fi
  done
}

run_data() {
  echo "[데이터 무결성]"
  python3 - "$PLUGIN_ROOT" "$SEARCH_SCRIPT" > /tmp/ui-designer-validate.out 2> /tmp/ui-designer-validate.err <<'PY'
import csv
import subprocess
import sys
from pathlib import Path

plugin_root = Path(sys.argv[1])
search_script = sys.argv[2]
data_dir = plugin_root / "data"
expected = {
    "styles.csv": 68,
    "colors.csv": 117,
    "fonts.csv": 58,
    "industries.csv": 97,
    "anti-patterns.csv": 31,
}

ok = True
for name, count in expected.items():
    path = data_dir / name
    with path.open(encoding="utf-8", newline="") as handle:
        rows = list(csv.reader(handle))
    if len(rows) == count:
        print(f"PASS::{name}::{len(rows)}")
    else:
        ok = False
        print(f"FAIL::{name}::{len(rows)}::{count}")

result = subprocess.run(
    ["python3", search_script, "--check-integrity"],
    capture_output=True,
    text=True,
)
if result.returncode == 0:
    print("PASS::integrity::0")
else:
    ok = False
    print("FAIL::integrity::1")
    print(result.stdout)
    print(result.stderr)

sys.exit(0 if ok else 1)
PY
  local status=$?
  while IFS= read -r line; do
    case "$line" in
      PASS::*)
        pass "${line#PASS::}"
        ;;
      FAIL::*)
        fail "${line#FAIL::}"
        ;;
    esac
  done < /tmp/ui-designer-validate.out
  if [ $status -ne 0 ]; then
    FAILURES=$((FAILURES + 0))
  fi
}

run_hooks() {
  echo "[훅 검증]"
  local tmp_file
  tmp_file="$(mktemp /tmp/ui-designer-hook-XXXXXX.tsx)"
  cat >"$tmp_file" <<'EOF'
"use client"
export default function Test() {
  return <button variant="ghost" size="icon"><img src="/x.png" alt="" /></button>
}
EOF

  require_success "hooks.json JSON 파싱" python3 - <<PY
import json
from pathlib import Path
json.loads(Path("$PLUGIN_ROOT/hooks/hooks.json").read_text(encoding="utf-8"))
PY

  if [ -x "$PLUGIN_ROOT/hooks/scripts/validate-design.sh" ]; then
    pass "validate-design.sh 실행 권한"
  else
    fail "validate-design.sh 실행 권한"
  fi

  if [ -x "$PLUGIN_ROOT/hooks/scripts/check-anti-patterns.sh" ]; then
    pass "check-anti-patterns.sh 실행 권한"
  else
    fail "check-anti-patterns.sh 실행 권한"
  fi

  if bash "$PLUGIN_ROOT/hooks/scripts/validate-design.sh" "$tmp_file" >/tmp/ui-designer-hook.out 2>/tmp/ui-designer-hook.err; then
    if rg -q '<img>|aria-label|use client' /tmp/ui-designer-hook.out; then
      pass "validate-design.sh 경고 출력"
    else
      fail "validate-design.sh 경고 출력"
    fi
  else
    fail "validate-design.sh 실행"
  fi

  if bash "$PLUGIN_ROOT/hooks/scripts/check-anti-patterns.sh" "$tmp_file" >/tmp/ui-designer-hook-ap.out 2>/tmp/ui-designer-hook-ap.err; then
    pass "check-anti-patterns.sh 실행"
  else
    fail "check-anti-patterns.sh 실행"
  fi

  rm -f "$tmp_file"
}

run_search() {
  echo "[검색 엔진 검증]"

  if python3 "$SEARCH_SCRIPT" "minimalism" --domain style >/tmp/ui-style.out 2>/tmp/ui-style.err && rg -q 'score:' /tmp/ui-style.out; then
    pass "style 도메인 검색"
  else
    fail "style 도메인 검색"
  fi

  if python3 "$SEARCH_SCRIPT" "blue" --domain color >/tmp/ui-color.out 2>/tmp/ui-color.err && rg -q 'primary:' /tmp/ui-color.out; then
    pass "color 도메인 검색"
  else
    fail "color 도메인 검색"
  fi

  if python3 "$SEARCH_SCRIPT" "sans serif" --domain font >/tmp/ui-font.out 2>/tmp/ui-font.err && rg -q 'Display:' /tmp/ui-font.out; then
    pass "font 도메인 검색"
  else
    fail "font 도메인 검색"
  fi

  if python3 "$SEARCH_SCRIPT" "fintech saas" --design-system >/tmp/ui-ds.out 2>/tmp/ui-ds.err && rg -q 'Style:|Colors:|Fonts:|Rules:' /tmp/ui-ds.out; then
    pass "--design-system"
  else
    fail "--design-system"
  fi

  local tmp_file
  tmp_file="$(mktemp /tmp/ui-designer-ap-XXXXXX.tsx)"
  echo '<div className="bg-white text-black bg-gradient-to-r from-purple-500"><img src="/x.png" /></div>' >"$tmp_file"
  if python3 "$SEARCH_SCRIPT" --check-anti-patterns "$tmp_file" >/tmp/ui-ap.out 2>/tmp/ui-ap.err && rg -q 'HIGH|MEDIUM' /tmp/ui-ap.out; then
    pass "--check-anti-patterns"
  else
    fail "--check-anti-patterns"
  fi
  rm -f "$tmp_file"

  if python3 "$SEARCH_SCRIPT" "education" >/tmp/ui-global.out 2>/tmp/ui-global.err && rg -q 'Global Search:|Industry Inference' /tmp/ui-global.out; then
    pass "전체 검색"
  else
    fail "전체 검색"
  fi
}

run_persist() {
  echo "[영속성 검증]"

  local backup
  backup="$(mktemp -d /tmp/ui-designer-backup-XXXXXX)"
  if [ -d "$PROJECT_ROOT/.ui-designer" ]; then
    cp -R "$PROJECT_ROOT/.ui-designer/." "$backup/"
  fi
  rm -rf "$PROJECT_ROOT/.ui-designer"

  if python3 "$SEARCH_SCRIPT" "education saas" --design-system --persist -p "ValidateProject" >/tmp/ui-persist-master.out 2>/tmp/ui-persist-master.err; then
    if [ -f "$PROJECT_ROOT/.ui-designer/design-system.md" ] && rg -q 'ValidateProject' "$PROJECT_ROOT/.ui-designer/design-system.md"; then
      pass "Master 저장"
    else
      fail "Master 저장"
    fi
  else
    fail "Master 저장"
  fi

  if python3 "$SEARCH_SCRIPT" "fintech dark professional" --design-system --persist -p "ValidateProject" --page "analytics" >/tmp/ui-persist-page.out 2>/tmp/ui-persist-page.err; then
    if [ -f "$PROJECT_ROOT/.ui-designer/pages/analytics.md" ] && rg -q 'ValidateProject' "$PROJECT_ROOT/.ui-designer/pages/analytics.md"; then
      pass "Page override 저장"
    else
      fail "Page override 저장"
    fi
  else
    fail "Page override 저장"
  fi

  rm -rf "$PROJECT_ROOT/.ui-designer"
  if [ -n "$(ls -A "$backup" 2>/dev/null)" ]; then
    mkdir -p "$PROJECT_ROOT/.ui-designer"
    cp -R "$backup/." "$PROJECT_ROOT/.ui-designer/"
  fi
  rm -rf "$backup"
}

run_sync() {
  echo "[외부 동기화]"
  python3 - "$PROJECT_ROOT" "$PLUGIN_ROOT" > /tmp/ui-designer-validate.out 2> /tmp/ui-designer-validate.err <<'PY'
import re
import sys
from pathlib import Path

project_root = Path(sys.argv[1])
plugin_root = Path(sys.argv[2])
target_root = project_root / ".agents" / "skills" / "ui-designer-ui-design-guide"

def normalize(text: str) -> str:
    pairs = [
        (r"\.claude/plugins/local/ui-designer/skills/ui-design-guide/references/", "__REFS__/"),
        (r"\.agents/skills/ui-designer-ui-design-guide/references/", "__REFS__/"),
        (r"\.github/skills/ui-designer-ui-design-guide/references/", "__REFS__/"),
        (r"\.claude/plugins/local/ui-designer/scripts/search.py", "__SEARCH__"),
        (r"\.agents/skills/ui-designer-ui-design-guide/scripts/search.py", "__SEARCH__"),
        (r"\.github/skills/ui-designer-ui-design-guide/scripts/search.py", "__SEARCH__"),
        (r"scripts/search\.py", "__SEARCH__"),
    ]
    for pattern, replacement in pairs:
        text = re.sub(pattern, replacement, text)
    return text

checks = []
checks.append((plugin_root / "skills" / "ui-design-guide" / "SKILL.md", target_root / "SKILL.md"))
checks.append((plugin_root / "scripts" / "search.py", target_root / "scripts" / "search.py"))
for src in sorted((plugin_root / "data").glob("*.csv")):
    checks.append((src, target_root / "data" / src.name))
for src in sorted((plugin_root / "skills" / "ui-design-guide" / "references").glob("*.md")):
    checks.append((src, target_root / "references" / src.name))

ok = True
for src, dest in checks:
    if not dest.exists():
        ok = False
        print(f"FAIL::{dest.relative_to(project_root)}::missing")
        continue
    if src.suffix == ".md":
        src_text = normalize(src.read_text(encoding="utf-8"))
        dest_text = normalize(dest.read_text(encoding="utf-8"))
        matched = src_text == dest_text
    else:
        matched = src.read_bytes() == dest.read_bytes()
    if matched:
        print(f"PASS::{dest.relative_to(project_root)}")
    else:
        ok = False
        print(f"FAIL::{dest.relative_to(project_root)}::diff")

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
  done < /tmp/ui-designer-validate.out
}

case "$MODE" in
  --full)
    run_structure
    run_references
    run_data
    run_hooks
    run_search
    run_persist
    run_sync
    ;;
  --data)
    run_data
    ;;
  --hooks)
    run_hooks
    ;;
  --search)
    run_search
    ;;
  --persist)
    run_persist
    ;;
  *)
    echo "Usage: $0 [--full|--data|--hooks|--search|--persist]"
    exit 2
    ;;
esac

echo
if [ "$FAILURES" -eq 0 ]; then
  echo "결과: PASS"
else
  echo "결과: FAIL ($FAILURES)"
fi

exit "$FAILURES"
