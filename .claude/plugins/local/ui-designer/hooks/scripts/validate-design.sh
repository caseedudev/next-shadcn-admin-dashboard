#!/bin/bash
# UI Design Principles auto-validation script
# Called by PostToolUse(Write|Edit) hook to detect design principle violations in .tsx/.jsx files.

FILE_PATH="$1"

# Only validate .tsx/.jsx files
if [[ ! "$FILE_PATH" =~ \.(tsx|jsx)$ ]]; then
  exit 0
fi

# Check file exists
if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

WARNINGS=""

# 1. Detect hardcoded colors (prevents dark mode breakage)
if grep -qE '(bg-white|bg-black|text-white|text-black|bg-gray-|text-gray-)' "$FILE_PATH" 2>/dev/null; then
  WARNINGS="${WARNINGS}\n⚠️ Hardcoded color detected — use CSS variables like bg-background/text-foreground instead"
fi

# 2. Detect <img> usage instead of next/image
if grep -qE '<img\s' "$FILE_PATH" 2>/dev/null; then
  WARNINGS="${WARNINGS}\n⚠️ <img> tag detected — use next/image (<Image>) instead"
fi

# 3. Detect missing aria-label on icon buttons
if grep -qE 'variant="ghost".*size="icon"' "$FILE_PATH" 2>/dev/null; then
  if ! grep -qE 'aria-label' "$FILE_PATH" 2>/dev/null; then
    WARNINGS="${WARNINGS}\n⚠️ Possible missing aria-label on icon button — check accessibility"
  fi
fi

# 4. Detect unnecessary "use client"
if grep -qE '^"use client"' "$FILE_PATH" 2>/dev/null; then
  # If no client hooks like useState/useEffect, "use client" may be unnecessary
  if ! grep -qE '(useState|useEffect|useRef|useCallback|useMemo|useReducer|useContext|onClick|onChange|onSubmit)' "$FILE_PATH" 2>/dev/null; then
    WARNINGS="${WARNINGS}\n⚠️ Possibly unnecessary \"use client\" — consider converting to Server Component"
  fi
fi

if [[ -n "$WARNINGS" ]]; then
  echo -e "[ui-designer design principles check]${WARNINGS}"
fi

exit 0
