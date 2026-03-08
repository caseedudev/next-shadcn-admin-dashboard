#!/bin/bash

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PLUGIN_ROOT/../../../.." && pwd)"

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

run_prompt_contracts() {
  echo "[프롬프트 계약 검증]"

  if python3 - "$PLUGIN_ROOT" > /tmp/dashboard-qa.out 2> /tmp/dashboard-qa.err <<'PY'
from pathlib import Path
import sys

plugin_root = Path(sys.argv[1])
checks = {
    "checklist.md": [
        "git diff --name-only HEAD",
        "docs/architecture/development-rules.md",
        "docs/architecture/nextjs-best-case-rules.md",
        "## Checklist Results",
    ],
    "review-frontend.md": [
        "PERF-001~004",
        "COMP-001~004",
        "UI-001~004",
        "Put findings first",
    ],
    "review-backend.md": [
        "API-001~004",
        "SB-001~004",
        "DATA-001~006",
        "Put findings first",
    ],
    "new-api.md": [
        "src/app/api/v1/<domain>/<resource>/route.ts",
        "safeParse",
        "limit + 1",
        "createSupabaseServerClient",
    ],
    "new-feature.md": [
        "src/features/<domain>/",
        "Feature depends on `lib` only",
    ],
    "new-migration.md": [
        "FORCE ROW LEVEL SECURITY",
        "(select auth.uid())",
        "auth.users(id)",
    ],
    "init-project.md": [
        "docs/domain/project.md",
        "docs/domain/glossary.md",
        "project-template.md",
        "glossary-template.md",
    ],
}

ok = True
for filename, needles in checks.items():
    text = (plugin_root / "commands" / filename).read_text(encoding="utf-8")
    for needle in needles:
        if needle in text:
            print(f"PASS::{filename}::{needle}")
        else:
            ok = False
            print(f"FAIL::{filename}::{needle}")

sys.exit(0 if ok else 1)
PY
  then
    :
  fi

  while IFS= read -r line; do
    case "$line" in
      PASS::*)
        pass "${line#PASS::}"
        ;;
      FAIL::*)
        fail "${line#FAIL::}"
        ;;
    esac
  done < /tmp/dashboard-qa.out
}

run_skill_contracts() {
  echo "[스킬 계약 검증]"

  if python3 - "$PLUGIN_ROOT" > /tmp/dashboard-qa-skills.out 2> /tmp/dashboard-qa-skills.err <<'PY'
from pathlib import Path
import sys

plugin_root = Path(sys.argv[1])
checks = {
    "frontend-dev/SKILL.md": [
        "Promise.all",
        "No barrel imports",
        "transition: all",
    ],
    "backend-dev/SKILL.md": [
        "createSupabaseServerClient",
        "RLS + FORCE RLS",
        "(select auth.uid())",
    ],
    "fullstack-review/SKILL.md": [
        "Identify changed files",
        "Report findings",
    ],
    "project-init/SKILL.md": [
        "docs/domain/project.md",
        "docs/domain/glossary.md",
    ],
}

ok = True
for rel, needles in checks.items():
    text = (plugin_root / "skills" / rel).read_text(encoding="utf-8")
    for needle in needles:
        if needle in text:
            print(f"PASS::{rel}::{needle}")
        else:
            ok = False
            print(f"FAIL::{rel}::{needle}")

sys.exit(0 if ok else 1)
PY
  then
    :
  fi

  while IFS= read -r line; do
    case "$line" in
      PASS::*)
        pass "${line#PASS::}"
        ;;
      FAIL::*)
        fail "${line#FAIL::}"
        ;;
    esac
  done < /tmp/dashboard-qa-skills.out
}

run_installed_contracts() {
  echo "[Codex 설치물 계약 검증]"

  local prompt="$PROJECT_ROOT/.codex/prompts/dashboard-template-new-api.md"
  if [ ! -f "$prompt" ]; then
    skip "install-codex.sh 실행 전이라 설치물 검증 생략"
    return
  fi

  local prompts=(
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-checklist.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-review-frontend.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-review-backend.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-api.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-feature.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-new-migration.md"
    "$PROJECT_ROOT/.codex/prompts/dashboard-template-init-project.md"
  )

  local item
  for item in "${prompts[@]}"; do
    if [ -f "$item" ] && rg -q '^name: dashboard-template-' "$item"; then
      pass "${item#$PROJECT_ROOT/}"
    else
      fail "${item#$PROJECT_ROOT/}"
    fi
  done
}

case "$MODE" in
  --all)
    run_prompt_contracts
    run_skill_contracts
    run_installed_contracts
    ;;
  --prompts)
    run_prompt_contracts
    ;;
  --skills)
    run_skill_contracts
    ;;
  --codex)
    run_installed_contracts
    ;;
  *)
    echo "Usage: $0 [--all|--prompts|--skills|--codex]"
    exit 2
    ;;
esac

echo
echo "요약: FAIL=$FAILURES, SKIP=$SKIPS"
exit "$FAILURES"
