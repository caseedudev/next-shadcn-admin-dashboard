#!/bin/bash
# dashboard-template Antigravity 로컬 설치 스크립트
# 사용법: bash .claude/plugins/local/dashboard-template/install-antigravity.sh
# Antigravity는 .github/skills/ 디렉토리에서 프로젝트 로컬 스킬을 로드한다.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PLUGIN_NAME="dashboard-template"
TARGET_DIR="$PROJECT_ROOT/.github/skills"

echo "[$PLUGIN_NAME] Antigravity 로컬 설치 시작..."

# .github/skills 디렉토리 생성
mkdir -p "$TARGET_DIR"

# skills 복사 (심볼릭 링크 아닌 실제 복사 — antigravity symlink 미보장)
if [ -d "$SCRIPT_DIR/skills" ]; then
  for d in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    dest="$TARGET_DIR/${PLUGIN_NAME}-${name}"
    rm -rf "$dest"
    cp -R "$d" "$dest"
    echo "    + $(basename "$dest")"
  done
  count=$(ls -d "$SCRIPT_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')
  echo "  skills: ${count}개 설치 → $TARGET_DIR"
else
  echo "  [경고] skills 디렉토리가 없습니다: $SCRIPT_DIR/skills"
  exit 1
fi

echo "[$PLUGIN_NAME] Antigravity 설치 완료."
