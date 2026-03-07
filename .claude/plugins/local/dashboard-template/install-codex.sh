#!/bin/bash
# dashboard-template Codex 로컬 설치 스크립트
# 사용법: bash .claude/plugins/local/dashboard-template/install-codex.sh
# 프로젝트 로컬 .codex/prompts, .agents/skills 에 설치한다.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PLUGIN_NAME="dashboard-template"
PROMPTS_DIR="$PROJECT_ROOT/.codex/prompts"
SKILLS_DIR="$PROJECT_ROOT/.agents/skills"
LOCAL_AUTH_FILE="$PROJECT_ROOT/.codex/auth.json"
GLOBAL_AUTH_FILE="$HOME/.codex/auth.json"

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
    count=$((count + 1))
  done
  echo "  skills: ${count}개 설치 → $SKILLS_DIR"
fi

echo "[$PLUGIN_NAME] Codex 로컬 설치 완료."
echo "  사용 전: CODEX_HOME=\"$PROJECT_ROOT/.codex\" codex"
echo "  커맨드 예시: /dashboard-template-new-feature, /dashboard-template-new-api"
