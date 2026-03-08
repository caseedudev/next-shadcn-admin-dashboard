#!/bin/bash

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PLUGIN_ROOT/../../../.." && pwd)"

MODE="${1:---full}"
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

rel_path() {
  python3 - "$PROJECT_ROOT" "$1" <<'PY'
from pathlib import Path
import sys
print(Path(sys.argv[2]).resolve().relative_to(Path(sys.argv[1]).resolve()))
PY
}

run_structure() {
  echo "[구조 검증]"

  local required=(
    "$PLUGIN_ROOT/.claude-plugin/plugin.json"
    "$PLUGIN_ROOT/README.md"
    "$PLUGIN_ROOT/install.sh"
    "$PLUGIN_ROOT/install-codex.sh"
    "$PLUGIN_ROOT/install-antigravity.sh"
    "$PLUGIN_ROOT/hooks/hooks.json"
    "$PLUGIN_ROOT/commands/checklist.md"
    "$PLUGIN_ROOT/commands/init-project.md"
    "$PLUGIN_ROOT/commands/new-api.md"
    "$PLUGIN_ROOT/commands/new-feature.md"
    "$PLUGIN_ROOT/commands/new-migration.md"
    "$PLUGIN_ROOT/commands/review-frontend.md"
    "$PLUGIN_ROOT/commands/review-backend.md"
    "$PLUGIN_ROOT/skills/frontend-dev/SKILL.md"
    "$PLUGIN_ROOT/skills/backend-dev/SKILL.md"
    "$PLUGIN_ROOT/skills/fullstack-review/SKILL.md"
    "$PLUGIN_ROOT/skills/project-init/SKILL.md"
    "$PLUGIN_ROOT/agents/frontend-architect.md"
    "$PLUGIN_ROOT/agents/backend-architect.md"
    "$PLUGIN_ROOT/agents/fullstack-dev.md"
    "$PLUGIN_ROOT/scripts/validate-plugin.sh"
    "$PLUGIN_ROOT/scripts/qa-plugin.sh"
  )

  local path
  for path in "${required[@]}"; do
    if [ -e "$path" ]; then
      pass "$(rel_path "$path")"
    else
      fail "$(rel_path "$path")"
    fi
  done

  if python3 - "$PLUGIN_ROOT" <<'PY'
import json
import sys
from pathlib import Path

plugin_root = Path(sys.argv[1])
plugin = json.loads((plugin_root / ".claude-plugin" / "plugin.json").read_text(encoding="utf-8"))
assert all(key in plugin for key in ("name", "version", "description"))

for path in list((plugin_root / "commands").glob("*.md")) + list((plugin_root / "agents").glob("*.md")) + list((plugin_root / "skills").glob("*/SKILL.md")):
    text = path.read_text(encoding="utf-8")
    assert text.startswith("---\n"), f"frontmatter missing: {path}"
    assert "\nname:" in text and "\ndescription:" in text, f"invalid frontmatter: {path}"
PY
  then
    pass "plugin.json/frontmatter 유효성"
  else
    fail "plugin.json/frontmatter 유효성"
  fi
}

run_hooks() {
  echo "[훅 구조 검증]"

  if python3 - "$PLUGIN_ROOT" > /tmp/dashboard-hooks.out 2> /tmp/dashboard-hooks.err <<'PY'
import json
import sys
from pathlib import Path

plugin_root = Path(sys.argv[1])
hooks = json.loads((plugin_root / "hooks" / "hooks.json").read_text(encoding="utf-8"))
pre = hooks["hooks"]["PreToolUse"]
post = hooks["hooks"]["PostToolUse"]
assert len(pre) == 2
assert len(post) == 2
for item in pre + post:
    assert item["hooks"][0]["type"] == "command"
    assert item["hooks"][0]["command"]
print("ok")
PY
  then
    pass "hooks.json 구조"
  else
    fail "hooks.json 구조"
  fi
}

run_hook_behavior() {
  echo "[훅 동작 검증]"

  local pre_api_cmd pre_arch_cmd post_api_cmd post_sql_cmd
  pre_api_cmd="$(python3 - "$PLUGIN_ROOT" <<'PY'
import json, sys
from pathlib import Path
hooks = json.loads((Path(sys.argv[1]) / "hooks" / "hooks.json").read_text(encoding="utf-8"))
print(hooks["hooks"]["PreToolUse"][0]["hooks"][0]["command"])
PY
)"
  pre_arch_cmd="$(python3 - "$PLUGIN_ROOT" <<'PY'
import json, sys
from pathlib import Path
hooks = json.loads((Path(sys.argv[1]) / "hooks" / "hooks.json").read_text(encoding="utf-8"))
print(hooks["hooks"]["PreToolUse"][1]["hooks"][0]["command"])
PY
)"
  post_api_cmd="$(python3 - "$PLUGIN_ROOT" <<'PY'
import json, sys
from pathlib import Path
hooks = json.loads((Path(sys.argv[1]) / "hooks" / "hooks.json").read_text(encoding="utf-8"))
print(hooks["hooks"]["PostToolUse"][0]["hooks"][0]["command"])
PY
)"
  post_sql_cmd="$(python3 - "$PLUGIN_ROOT" <<'PY'
import json, sys
from pathlib import Path
hooks = json.loads((Path(sys.argv[1]) / "hooks" / "hooks.json").read_text(encoding="utf-8"))
print(hooks["hooks"]["PostToolUse"][1]["hooks"][0]["command"])
PY
)"

  if printf '%s\n' '{"tool_input":{"file_path":"src/app/api/test/route.ts"}}' | bash -lc "$pre_api_cmd" >/tmp/dashboard-pre-api.out 2>/tmp/dashboard-pre-api.err; then
    fail "API 경로 차단"
  elif [ $? -eq 2 ] && rg -q 'API routes MUST be created under src/app/api/v1' /tmp/dashboard-pre-api.err; then
    pass "API 경로 차단"
  else
    fail "API 경로 차단"
  fi

  local temp_feature="$PROJECT_ROOT/src/features/hook_validation_tmp.ts"
  mkdir -p "$(dirname "$temp_feature")"
  cat > "$temp_feature" <<'EOF'
import { Page } from '@/app/dashboard/page'
export const temp = Page
EOF
  if printf '%s\n' '{"tool_input":{"file_path":"src/features/hook_validation_tmp.ts"}}' | bash -lc "$pre_arch_cmd" >/tmp/dashboard-pre-arch.out 2>/tmp/dashboard-pre-arch.err; then
    fail "역방향 import 차단"
  elif [ $? -eq 2 ] && rg -q '\[ARCH-002\]' /tmp/dashboard-pre-arch.err; then
    pass "역방향 import 차단"
  else
    fail "역방향 import 차단"
  fi
  rm -f "$temp_feature"
  rmdir "$PROJECT_ROOT/src/features" 2>/dev/null || true

  if printf '%s\n' '{"tool_input":{"file_path":"src/app/api/test/route.ts"}}' | bash -lc "$post_api_cmd" >/tmp/dashboard-post-api.out 2>/tmp/dashboard-post-api.err; then
    if rg -q '\[API-001\] WARNING' /tmp/dashboard-post-api.err; then
      pass "API 경로 경고"
    else
      fail "API 경로 경고"
    fi
  else
    fail "API 경로 경고"
  fi

  local temp_sql="$PROJECT_ROOT/supabase/migrations/99999999999999_hook_validation_tmp.sql"
  cat > "$temp_sql" <<'EOF'
create policy "tmp" on items for select using (user_id = auth.uid());
EOF
  if printf '%s\n' "{\"tool_input\":{\"file_path\":\"${temp_sql#$PROJECT_ROOT/}\"}}" | bash -lc "$post_sql_cmd" >/tmp/dashboard-post-sql.out 2>/tmp/dashboard-post-sql.err; then
    if rg -q '\[SB-003\] WARNING' /tmp/dashboard-post-sql.err; then
      pass "auth.uid() 경고"
    else
      fail "auth.uid() 경고"
    fi
  else
    fail "auth.uid() 경고"
  fi
  rm -f "$temp_sql"
}

run_codex_install() {
  echo "[Codex 설치물 검증]"

  local prompts=(
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-checklist.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-review-frontend.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-review-backend.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-api.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-feature.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-migration.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-init-project.md"
  )

  local missing=0
  local prompt
  for prompt in "${prompts[@]}"; do
    if [ -f "$prompt" ]; then
      pass "$(rel_path "$prompt")"
    else
      missing=1
      fail "$(rel_path "$prompt")"
    fi
  done

  local skills=(
    "$PROJECT_ROOT/.agents/skills/dashboard-template-frontend-dev"
    "$PROJECT_ROOT/.agents/skills/dashboard-template-backend-dev"
    "$PROJECT_ROOT/.agents/skills/dashboard-template-fullstack-review"
    "$PROJECT_ROOT/.agents/skills/dashboard-template-project-init"
  )
  local skill
  for skill in "${skills[@]}"; do
    if [ -d "$skill" ]; then
      pass "$(rel_path "$skill")"
    else
      missing=1
      fail "$(rel_path "$skill")"
    fi
  done

  if [ "$missing" -ne 0 ]; then
    skip "설치물 비교는 install-codex.sh 실행 후 재시도 권장"
    return
  fi

  if python3 - "$PROJECT_ROOT" "$PLUGIN_ROOT" > /tmp/dashboard-codex-sync.out 2> /tmp/dashboard-codex-sync.err <<'PY'
from pathlib import Path
import sys

project_root = Path(sys.argv[1])
plugin_root = Path(sys.argv[2])

source_commands = sorted((plugin_root / "commands").glob("*.md"))
for src in source_commands:
    target = project_root / ".codex" / "prompts" / f"dashboard-template-{src.stem}.md"
    text = target.read_text(encoding="utf-8")
    assert f"name: dashboard-template-{src.stem}" in text
    assert "model:" not in text
    assert "color:" not in text
    print(f"PASS::{target.relative_to(project_root)}")

for src in sorted((plugin_root / "skills").glob("*/SKILL.md")):
    target = project_root / ".agents" / "skills" / f"dashboard-template-{src.parent.name}" / "SKILL.md"
    assert src.read_text(encoding="utf-8") == target.read_text(encoding="utf-8")
    print(f"PASS::{target.relative_to(project_root)}")
PY
  then
    while IFS= read -r line; do
      case "$line" in
        PASS::*)
          pass "${line#PASS::}"
          ;;
      esac
    done < /tmp/dashboard-codex-sync.out
  else
    fail "Codex 설치물 동기화"
  fi
}

case "$MODE" in
  --full)
    run_structure
    run_hooks
    run_hook_behavior
    run_codex_install
    ;;
  --structure)
    run_structure
    ;;
  --hooks)
    run_hooks
    run_hook_behavior
    ;;
  --codex)
    run_codex_install
    ;;
  *)
    echo "Usage: $0 [--full|--structure|--hooks|--codex]"
    exit 2
    ;;
esac

echo
echo "요약: FAIL=$FAILURES, SKIP=$SKIPS"
exit "$FAILURES"
