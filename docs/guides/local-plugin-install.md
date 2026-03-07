# 로컬 플러그인 설치 가이드

Claude Code는 GitHub 기반 마켓플레이스 플러그인만 공식 지원한다.
로컬 플러그인은 심볼릭 링크 방식으로 `.claude/` 디렉토리에 등록하여 사용한다.
Codex는 전역 디렉토리 대신 프로젝트 루트 `.codex/prompts/`와 `.agents/skills/`에 설치하고, `CODEX_HOME="$PWD/.codex" codex`로 실행하는 방식을 권장한다.

## 구조

```
.claude/
├── plugins/local/                  # 플러그인 원본 저장소
│   └── {plugin-name}/
│       ├── .claude-plugin/
│       │   └── plugin.json         # 플러그인 메타데이터
│       ├── commands/               # 슬래시 커맨드 (.md)
│       ├── skills/                 # 스킬 디렉토리
│       ├── agents/                 # 에이전트 (.md)
│       ├── hooks/                  # 훅 설정
│       └── install.sh              # 설치 스크립트
├── commands/                       # ← 심볼릭 링크 대상
│   └── {plugin-name}/              # 서브디렉토리 = prefix
│       └── *.md                    # → /{plugin-name}:{command} 형태
├── skills/                         # ← 심볼릭 링크 대상
│   └── {plugin-name}-{skill-name}  # prefix 포함 이름
└── agents/                         # ← 심볼릭 링크 대상
    └── *.md
```

## 설치 방법

### 1. install.sh 실행 (권장)

```bash
bash .claude/plugins/local/{plugin-name}/install.sh
```

### install.sh 작성 템플릿

새 로컬 플러그인을 만들 때, 아래 템플릿으로 `install.sh`를 작성한다.
`PLUGIN_NAME`과 `PLUGIN_REL`만 플러그인에 맞게 변경하면 된다.

```bash
#!/bin/bash
# {plugin-name} 로컬 설치 스크립트
# 사용법: bash .claude/plugins/local/{plugin-name}/install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
CLAUDE_DIR="$PROJECT_ROOT/.claude"
PLUGIN_NAME="{plugin-name}"              # ← 플러그인 이름 (prefix로 사용됨)
PLUGIN_REL="plugins/local/{plugin-name}" # ← .claude/ 기준 상대경로

echo "[$PLUGIN_NAME] 로컬 플러그인 설치 시작..."

# commands 심볼릭 링크 — 서브디렉토리로 prefix 부여
if [ -d "$SCRIPT_DIR/commands" ]; then
  mkdir -p "$CLAUDE_DIR/commands/$PLUGIN_NAME"
  for f in "$SCRIPT_DIR/commands"/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    ln -sf "../../$PLUGIN_REL/commands/$name" "$CLAUDE_DIR/commands/$PLUGIN_NAME/$name"
  done
  echo "  commands: $(ls "$CLAUDE_DIR/commands/$PLUGIN_NAME" | wc -l | tr -d ' ')개 등록"
fi

# skills 심볼릭 링크 — {plugin-name}-{skill-name} 형태로 prefix 부여
if [ -d "$SCRIPT_DIR/skills" ]; then
  mkdir -p "$CLAUDE_DIR/skills"
  for d in "$SCRIPT_DIR/skills"/*/; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    ln -sf "../$PLUGIN_REL/skills/$name" "$CLAUDE_DIR/skills/${PLUGIN_NAME}-${name}"
  done
  echo "  skills: $(ls -d "$SCRIPT_DIR/skills"/*/ 2>/dev/null | wc -l | tr -d ' ')개 등록"
fi

# agents 심볼릭 링크 — 원본 파일명 그대로
if [ -d "$SCRIPT_DIR/agents" ]; then
  mkdir -p "$CLAUDE_DIR/agents"
  for f in "$SCRIPT_DIR/agents"/*.md; do
    [ -f "$f" ] || continue
    name=$(basename "$f")
    ln -sf "../$PLUGIN_REL/agents/$name" "$CLAUDE_DIR/agents/$name"
  done
  echo "  agents: $(ls "$SCRIPT_DIR/agents"/*.md 2>/dev/null | wc -l | tr -d ' ')개 등록"
fi

echo "[$PLUGIN_NAME] 설치 완료. Claude Code를 재시작하세요."
```

**핵심 포인트:**
- `PLUGIN_NAME` — 슬래시 커맨드 prefix 및 스킬 prefix로 사용된다
- `PLUGIN_REL` — `.claude/` 기준 상대경로. 심볼릭 링크 대상 경로에 사용된다
- commands는 서브디렉토리(`commands/$PLUGIN_NAME/`)로 prefix 부여
- skills는 링크 이름에 `${PLUGIN_NAME}-` prefix 부여
- agents는 원본 파일명 그대로 링크
- `chmod +x install.sh`로 실행 권한을 부여한다

---

### 2. AI가 직접 설치하는 경우

아래 절차를 따른다.

#### Step 1: 플러그인 디렉토리 확인

```bash
ls .claude/plugins/local/{plugin-name}/
```

commands/, skills/, agents/ 중 존재하는 디렉토리를 파악한다.

#### Step 2: commands 심볼릭 링크

commands는 **서브디렉토리**로 묶어서 슬래시 커맨드에 prefix를 부여한다.

```bash
mkdir -p .claude/commands/{plugin-name}
ln -sf "../../plugins/local/{plugin-name}/commands/foo.md" \
       ".claude/commands/{plugin-name}/foo.md"
```

결과: `/{plugin-name}:foo` 슬래시 커맨드가 등록된다.

#### Step 3: skills 심볼릭 링크

skills는 디렉토리 단위로 심볼릭 링크한다. **반드시 `{plugin-name}-` prefix를 붙인다.**

```bash
ln -sf "../plugins/local/{plugin-name}/skills/{skill-name}" \
       ".claude/skills/{plugin-name}-{skill-name}"
```

결과: `{plugin-name}-{skill-name}` 스킬이 등록된다.

#### Step 4: agents 심볼릭 링크

agents는 개별 `.md` 파일을 심볼릭 링크한다.

```bash
ln -sf "../plugins/local/{plugin-name}/agents/foo.md" \
       ".claude/agents/foo.md"
```

#### Step 5: 검증

```bash
ls -la .claude/commands/{plugin-name}/
ls -la .claude/skills/ | grep {plugin-name}
ls -la .claude/agents/
```

모든 링크가 유효한 파일을 가리키는지 확인한다.

## Codex 로컬 설치

Codex용 설치 스크립트는 전역 `~/.codex`, `~/.agents`를 수정하지 않고 프로젝트 내부에만 설치해야 한다.

### install-codex.sh 동작 원칙

- `commands/*.md`를 프로젝트 루트 `.codex/prompts/`로 복사한다
- 프롬프트 frontmatter의 `name:`은 `{plugin-name}-{command}` 형태로 다시 쓴다
- `model:`, `color:` 같은 Claude 전용 frontmatter는 제거한다
- `skills/*/`는 `.agents/skills/{plugin-name}-{skill-name}/`로 복사한다
- 글로벌 `~/.codex/auth.json`이 있으면 로컬 `.codex/auth.json`으로 연결해 로그인 상태를 재사용한다
- 설치 후 Codex는 반드시 `CODEX_HOME="$PWD/.codex" codex`로 실행한다

### Codex 설치/검증 예시

```bash
bash .claude/plugins/local/{plugin-name}/install-codex.sh
CODEX_HOME="$PWD/.codex" codex

ls .codex/prompts/
ls .agents/skills/ | grep {plugin-name}
```

## 심볼릭 링크 경로 규칙

**상대경로를 사용한다.** 링크 대상 경로는 링크 파일의 위치를 기준으로 한다.

| 링크 위치 | 깊이 | 상대경로 prefix |
|-----------|------|----------------|
| `.claude/commands/{plugin}/` | 2단계 | `../../plugins/local/...` |
| `.claude/skills/` | 1단계 | `../plugins/local/...` |
| `.claude/agents/` | 1단계 | `../plugins/local/...` |

## SKILL.md description 작성 규칙

스킬의 `SKILL.md` frontmatter `description`은 다음 규칙을 따른다:

**작성 규칙:**
- **한글로 작성**한다
- **1줄로 간략하게** 이 스킬이 무엇인지만 소개한다
- 형식: `"[스킬이 하는 일]을 [어떻게] 한다."` 또는 `"[대상] 관련 [규칙]을 자동 적용한다."`

**작성 금지:**
- 트리거 키워드 나열 금지 (`"API 라우트 생성", "라우트 핸들러 작성", ...` 등)
- README 참조 안내 금지 (`"자세한 내용은 README.md 참고"` 등)
- 상세 사용법, 워크플로우 설명 금지
- 스킬 동작에 직접 필요하지 않은 부가 설명 금지

**좋은 예:**
```yaml
description: "API 라우트, Supabase, 마이그레이션 등 백엔드 개발 시 API/SB/DATA 규칙을 자동 적용한다."
description: "UI 페이지 설계 및 구현 가이드. 프로젝트 분석 기반 컴포넌트 추천, 레이아웃 설계, 코드 생성을 제공한다."
description: "PR 리뷰, 코드 감사 시 전체 아키텍처 규칙을 종합 검증한다."
```

**나쁜 예:**
```yaml
# 트리거 키워드 나열 — 금지
description: >
  "API 라우트 생성", "라우트 핸들러 작성", "Supabase 마이그레이션 추가",
  "RLS 정책 설정", "SQL 쿼리 작성" 등 백엔드 작업 시 사용한다...

# README 참조 안내 — 금지
description: "백엔드 개발 규칙 적용. 자세한 내용은 README.md를 참고한다."

# 부가 설명 — 금지
description: "백엔드 개발 스킬. frontend-dev 스킬과 함께 사용하면 효과적이다."
```

## Naming Convention

| 리소스 | 링크/파일 이름 | 예시 |
|--------|----------------|------|
| Claude commands | `{command}.md` (서브디렉토리가 prefix 역할) | `commands/ui-designer/ui-design.md` → `/ui-designer:ui-design` |
| Codex prompts | `{plugin-name}-{command}.md` | `.codex/prompts/ui-designer-ui-design.md` → `/ui-designer-ui-design` |
| Claude/Codex skills | `{plugin-name}-{skill-name}` | `.agents/skills/dashboard-template-backend-dev` |
| agents | `{agent}.md` (원본 파일명 그대로) | `agents/frontend-architect.md` |

## 제거 방법

```bash
# 특정 플러그인 전체 제거
rm -rf .claude/commands/{plugin-name}
rm -f .claude/skills/{plugin-name}-*
rm -f .claude/agents/{agent-name}.md
```

원본 파일은 `.claude/plugins/local/` 에 그대로 유지된다.

## 주의사항

- `settings.json`의 `enabledPlugins`에 등록할 필요 없다 (마켓플레이스 플러그인만 해당)
- 원본 파일 수정 시 심볼릭 링크를 통해 자동 반영된다
- 플러그인의 `hooks/`는 이 방식으로 등록되지 않는다. 필요 시 `.claude/settings.json`의 `hooks` 섹션에 직접 추가한다
- Claude Code 재시작 후 슬래시 커맨드가 반영된다
- Codex는 재시작보다 `CODEX_HOME="$PWD/.codex" codex`로 해당 프로젝트를 다시 여는 편이 확실하다
- 각 플러그인의 상세 사용법은 해당 플러그인의 `README.md`를 참조한다

## 트러블슈팅

### `extraKnownMarketplaces`의 `file://` URL은 `.git`으로 끝나야 한다

`~/.claude/settings.json`의 `extraKnownMarketplaces`에 로컬 git 레포를 등록할 때, URL이 `.git`으로 끝나지 않으면 마켓플레이스 로드 에러가 발생한다.

```diff
  "local-marketplace": {
    "source": {
      "source": "git",
-     "url": "file:///Users/me/.claude/plugins/local-marketplace"
+     "url": "file:///Users/me/.claude/plugins/local-marketplace.git"
    }
  }
```

> **참고**: 이 가이드의 심볼릭 링크 방식을 사용하면 `extraKnownMarketplaces` 등록 자체가 필요 없다. 이 이슈는 마켓플레이스 방식으로 설치를 시도하는 경우에만 해당된다.
