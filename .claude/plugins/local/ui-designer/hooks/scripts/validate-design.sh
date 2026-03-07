#!/bin/bash
# UI Design Principles 자동 검증 스크립트
# PostToolUse(Write|Edit) 훅에서 호출되어 .tsx/.jsx 파일의 디자인 원칙 위반을 검출한다.

FILE_PATH="$1"

# .tsx/.jsx 파일만 검증
if [[ ! "$FILE_PATH" =~ \.(tsx|jsx)$ ]]; then
  exit 0
fi

# 파일 존재 확인
if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

WARNINGS=""

# 1. 하드코딩된 컬러 검출 (다크 모드 깨짐 방지)
if grep -qE '(bg-white|bg-black|text-white|text-black|bg-gray-|text-gray-)' "$FILE_PATH" 2>/dev/null; then
  WARNINGS="${WARNINGS}\n⚠️ 하드코딩된 컬러 발견 — bg-background/text-foreground 등 CSS 변수 사용 권장"
fi

# 2. next/image 대신 <img> 사용 검출
if grep -qE '<img\s' "$FILE_PATH" 2>/dev/null; then
  WARNINGS="${WARNINGS}\n⚠️ <img> 태그 발견 — next/image (<Image>) 사용 권장"
fi

# 3. 아이콘 버튼에 aria-label 누락 검출
if grep -qE 'variant="ghost".*size="icon"' "$FILE_PATH" 2>/dev/null; then
  if ! grep -qE 'aria-label' "$FILE_PATH" 2>/dev/null; then
    WARNINGS="${WARNINGS}\n⚠️ 아이콘 버튼에 aria-label 누락 가능성 — 접근성 확인 필요"
  fi
fi

# 4. 과도한 "use client" 검출
if grep -qE '^"use client"' "$FILE_PATH" 2>/dev/null; then
  # useState/useEffect 등 클라이언트 훅이 없으면 불필요한 "use client"
  if ! grep -qE '(useState|useEffect|useRef|useCallback|useMemo|useReducer|useContext|onClick|onChange|onSubmit)' "$FILE_PATH" 2>/dev/null; then
    WARNINGS="${WARNINGS}\n⚠️ 불필요한 \"use client\" 가능성 — 서버 컴포넌트로 전환 검토"
  fi
fi

if [[ -n "$WARNINGS" ]]; then
  echo -e "[ui-designer 디자인 원칙 검증]${WARNINGS}"
fi

exit 0
