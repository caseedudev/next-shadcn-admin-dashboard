#!/bin/bash
# ui-designer Codex 로컬 설치 스크립트
# 사용법: bash .claude/plugins/local/ui-designer/install-codex.sh
# 프로젝트 로컬 .codex/prompts, .agents/skills 에 설치한다.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PLUGIN_NAME="ui-designer"
PROMPTS_DIR="$PROJECT_ROOT/.codex/prompts"
SKILLS_DIR="$PROJECT_ROOT/.agents/skills"
LOCAL_AUTH_FILE="$PROJECT_ROOT/.codex/auth.json"
GLOBAL_AUTH_FILE="$HOME/.codex/auth.json"
CODEX_SKILL_NAME="${PLUGIN_NAME}-ui-design-guide"
CODEX_SKILL_DIR=".agents/skills/${CODEX_SKILL_NAME}"
CODEX_SEARCH_SCRIPT="${CODEX_SKILL_DIR}/scripts/search.py"

rewrite_prompt() {
  local src="$1"
  local dest="$2"
  local command_name="$3"

  awk -v command_name="$command_name" '
    BEGIN {
      in_frontmatter = 0
    }

    NR == 1 && $0 == "---" {
      in_frontmatter = 1
      print
      next
    }

    in_frontmatter && $0 == "---" {
      print
      in_frontmatter = 0
      next
    }

    in_frontmatter {
      if ($0 ~ /^name:/) {
        print "name: " command_name
        next
      }

      if ($0 ~ /^(model|color):/) {
        next
      }

      print
      next
    }

    {
      print
    }
  ' "$src" > "$dest"
}

rewrite_codex_file() {
  local target="$1"

  python3 - "$target" "$CODEX_SKILL_DIR" "$CODEX_SEARCH_SCRIPT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
skill_dir = sys.argv[2]
search_script = sys.argv[3]

text = path.read_text(encoding="utf-8")
replacements = [
    (
        ".claude/plugins/local/ui-designer/skills/ui-design-guide/references/",
        f"{skill_dir}/references/",
    ),
    ("`scripts/search.py`", f"`{search_script}`"),
    ("python3 scripts/search.py", f"python3 {search_script}"),
]

for before, after in replacements:
    text = text.replace(before, after)

path.write_text(text, encoding="utf-8")
PY
}

sanitize_copied_skill() {
  local target_dir="$1"

  find "$target_dir" -type l -delete

  while IFS= read -r -d '' file; do
    rewrite_codex_file "$file"
  done < <(find "$target_dir" -type f -name '*.md' -print0)
}

echo "[$PLUGIN_NAME] Codex 로컬 설치 시작..."

mkdir -p "$PROMPTS_DIR"
mkdir -p "$SKILLS_DIR"

if [ ! -e "$LOCAL_AUTH_FILE" ] && [ -f "$GLOBAL_AUTH_FILE" ]; then
  ln -sf "$GLOBAL_AUTH_FILE" "$LOCAL_AUTH_FILE"
  echo "  auth: 글로벌 로그인 정보를 로컬 CODEX_HOME에 연결 → $LOCAL_AUTH_FILE"
elif [ ! -e "$LOCAL_AUTH_FILE" ]; then
  echo "  [안내] 로컬 CODEX_HOME에 auth.json이 없습니다."
  echo "         필요 시: CODEX_HOME=\"$PROJECT_ROOT/.codex\" codex login"
fi

if [ -d "$SCRIPT_DIR/commands" ]; then
  count=0
  for f in "$SCRIPT_DIR/commands"/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f" .md)
    command_name="${PLUGIN_NAME}-${name}"
    dest="$PROMPTS_DIR/${command_name}.md"
    if [ -f "$dest" ]; then
      echo "  [갱신] $(basename "$dest")"
    else
      echo "  [신규] $(basename "$dest")"
    fi
    rewrite_prompt "$f" "$dest" "$command_name"
    rewrite_codex_file "$dest"
    count=$((count + 1))
  done
  echo "  prompts: ${count}개 설치 → $PROMPTS_DIR"
else
  echo "  [경고] commands 디렉토리가 없습니다: $SCRIPT_DIR/commands"
  exit 1
fi

if [ -d "$SCRIPT_DIR/skills" ]; then
  count=0
  for d in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    dest="$SKILLS_DIR/${PLUGIN_NAME}-${name}"
    rm -rf "$dest"
    cp -R "$d" "$dest"

    # data/ 및 scripts/ 복사 (검색 엔진 + Codex 검증 스크립트 지원)
    if [ -d "$SCRIPT_DIR/data" ]; then
      mkdir -p "$dest/data"
      cp "$SCRIPT_DIR/data"/*.csv "$dest/data/" 2>/dev/null || true
      echo "    + data: $(ls "$dest/data"/*.csv 2>/dev/null | wc -l | tr -d ' ')개 CSV"
    fi
    if compgen -G "$SCRIPT_DIR/scripts/*" >/dev/null; then
      mkdir -p "$dest/scripts"
      cp "$SCRIPT_DIR/scripts/"* "$dest/scripts/" 2>/dev/null || true
      chmod +x "$dest/scripts/"*.sh 2>/dev/null || true
      echo "    + scripts: $(ls "$dest/scripts" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]*$//')"
    fi

    sanitize_copied_skill "$dest"

    count=$((count + 1))
  done
  echo "  skills: ${count}개 설치 → $SKILLS_DIR"
fi

echo "[$PLUGIN_NAME] Codex 로컬 설치 완료."
echo "  사용 전: CODEX_HOME=\"$PROJECT_ROOT/.codex\" codex"
echo "  커맨드 예시: /ui-designer-ui-analyze, /ui-designer-ui-design, /ui-designer-ui-validate, /ui-designer-ui-qa"
