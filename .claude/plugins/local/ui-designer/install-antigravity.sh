#!/bin/bash
# ui-designer Antigravity 로컬 설치 스크립트
# 사용법: bash .claude/plugins/local/ui-designer/install-antigravity.sh
# Antigravity는 .github/skills/ 디렉토리에서 프로젝트 로컬 스킬을 로드한다.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PLUGIN_NAME="ui-designer"
TARGET_DIR="$PROJECT_ROOT/.github/skills"
AG_SKILL_NAME="${PLUGIN_NAME}-ui-design-guide"
AG_SKILL_DIR=".github/skills/${AG_SKILL_NAME}"
AG_SEARCH_SCRIPT="${AG_SKILL_DIR}/scripts/search.py"

rewrite_antigravity_file() {
  local target="$1"

  python3 - "$target" "$AG_SKILL_DIR" "$AG_SEARCH_SCRIPT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
skill_dir = sys.argv[2]
search_script = sys.argv[3]

text = path.read_text(encoding="utf-8")
replacements = [
    (
        ".agents/skills/ui-designer-ui-design-guide/references/",
        f"{skill_dir}/references/",
    ),
    (
        ".agents/skills/ui-designer-ui-design-guide/scripts/search.py",
        search_script,
    ),
    (
        ".claude/plugins/local/ui-designer/skills/ui-design-guide/references/",
        f"{skill_dir}/references/",
    ),
    (
        ".claude/plugins/local/ui-designer/scripts/search.py",
        search_script,
    ),
    ("`scripts/search.py`", f"`{search_script}`"),
    ("python3 scripts/search.py", f"python3 {search_script}"),
    (
        "If the user wants a standalone analysis run instead of continuing the design workflow, point them to the environment-specific command:\n- Codex: `/ui-designer-ui-analyze`\n- Claude Code: `/ui-designer:ui-analyze`",
        "If the user wants a standalone analysis run instead of continuing the design workflow, run the same Step 0 analysis directly in the current Antigravity chat session.",
    ),
]

for before, after in replacements:
    text = text.replace(before, after)

text = text.replace(
    f"  1. `{search_script}`\n  2. `{search_script}`",
    f"  - `{search_script}`",
)

path.write_text(text, encoding="utf-8")
PY
}

sanitize_copied_skill() {
  local target_dir="$1"

  find "$target_dir" -type l -delete

  while IFS= read -r -d '' file; do
    rewrite_antigravity_file "$file"
  done < <(find "$target_dir" -type f -name '*.md' -print0)
}

echo "[$PLUGIN_NAME] Antigravity 로컬 설치 시작..."

# .github/skills 디렉토리 생성
mkdir -p "$TARGET_DIR"

# 이전 버전에서 남은 ui-designer 스킬 정리
find "$TARGET_DIR" -maxdepth 1 -mindepth 1 -type d -name "${PLUGIN_NAME}-*" -exec rm -rf {} +

# skills 복사 (심볼릭 링크 아닌 실제 복사 — antigravity symlink 미보장)
if [ -d "$SCRIPT_DIR/skills" ]; then
  for d in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    dest="$TARGET_DIR/${PLUGIN_NAME}-${name}"
    rm -rf "$dest"
    cp -R "$d" "$dest"

    if [ -d "$SCRIPT_DIR/data" ]; then
      mkdir -p "$dest/data"
      cp "$SCRIPT_DIR/data"/*.csv "$dest/data/" 2>/dev/null || true
      echo "      + data: $(ls "$dest/data"/*.csv 2>/dev/null | wc -l | tr -d ' ')개 CSV"
    fi
    if compgen -G "$SCRIPT_DIR/scripts/*" >/dev/null; then
      mkdir -p "$dest/scripts"
      cp "$SCRIPT_DIR/scripts/"* "$dest/scripts/" 2>/dev/null || true
      chmod +x "$dest/scripts/"*.sh 2>/dev/null || true
      echo "      + scripts: $(ls "$dest/scripts" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
    fi

    sanitize_copied_skill "$dest"
    echo "    + $(basename "$dest")"
  done
  count=$(ls -d "$SCRIPT_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
  echo "  skills: ${count}개 설치 → $TARGET_DIR"
else
  echo "  [경고] skills 디렉토리가 없습니다: $SCRIPT_DIR/skills"
  exit 1
fi

echo "[$PLUGIN_NAME] Antigravity 설치 완료."
