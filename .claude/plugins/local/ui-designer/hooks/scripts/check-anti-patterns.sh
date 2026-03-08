#!/bin/bash
# Anti-pattern detection hook for ui-designer plugin
# Runs after Write/Edit on UI-related files (.tsx, .jsx, .css, .scss)

FILE="$1"
PLUGIN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SEARCH_PY="$PLUGIN_ROOT/scripts/search.py"

# Only check UI-related files
case "$FILE" in
  *.tsx|*.jsx|*.css|*.scss) ;;
  *) exit 0 ;;
esac

# If search.py exists and file exists, run anti-pattern check
if [ -f "$SEARCH_PY" ] && [ -f "$FILE" ]; then
  result=$(python3 "$SEARCH_PY" --check-anti-patterns "$FILE" 2>/dev/null)
  # Only print if there are HIGH severity findings
  if echo "$result" | grep -q "🔴 HIGH"; then
    echo "$result"
  fi
fi

exit 0
