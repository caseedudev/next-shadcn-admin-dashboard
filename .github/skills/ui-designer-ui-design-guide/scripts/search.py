#!/usr/bin/env python3
"""BM25 search engine for ui-designer plugin CSV data.

Provides ranked search across design system data (styles, colors, fonts,
industries, anti-patterns) using BM25 scoring algorithm.
"""

import argparse
import csv
import math
import os
import re
import sys
from collections import Counter
from pathlib import Path

# ── Constants ──────────────────────────────────────────────────────────────

BM25_K1 = 1.5
BM25_B = 0.75
DEFAULT_TOP = 5

DOMAIN_FILES = {
    "style": "styles.csv",
    "color": "colors.csv",
    "font": "fonts.csv",
    "industry": "industries.csv",
    "anti-pattern": "anti-patterns.csv",
}

DATA_DIR = Path(__file__).resolve().parent.parent / "data"

# ── Tokenizer ─────────────────────────────────────────────────────────────


def tokenize(text: str) -> list[str]:
    """Lowercase tokenization splitting on non-alphanumeric characters."""
    if not text:
        return []
    return [t for t in re.split(r"[^a-z0-9가-힣]+", text.lower()) if t]


# ── CSV Loader ─────────────────────────────────────────────────────────────


def load_csv(filepath: Path) -> list[dict]:
    """Load a CSV file and return a list of row dicts."""
    if not filepath.exists():
        print(f"Error: CSV file not found: {filepath}", file=sys.stderr)
        sys.exit(1)
    with open(filepath, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        return list(reader)


def row_to_text(row: dict) -> str:
    """Concatenate all field values of a row into a single searchable string."""
    return " ".join(v for v in row.values() if v)


# ── BM25 Engine ────────────────────────────────────────────────────────────


class BM25:
    """BM25 ranking over a corpus of tokenized documents."""

    def __init__(self, corpus: list[list[str]], k1: float = BM25_K1, b: float = BM25_B):
        self.k1 = k1
        self.b = b
        self.corpus = corpus
        self.n = len(corpus)
        self.doc_lens = [len(doc) for doc in corpus]
        self.avgdl = sum(self.doc_lens) / self.n if self.n else 1.0

        # Document frequency for each term
        self.df: dict[str, int] = {}
        for doc in corpus:
            seen = set(doc)
            for term in seen:
                self.df[term] = self.df.get(term, 0) + 1

        # Term frequency per document
        self.tf: list[dict[str, int]] = [dict(Counter(doc)) for doc in corpus]

    def _idf(self, term: str) -> float:
        df = self.df.get(term, 0)
        return math.log((self.n - df + 0.5) / (df + 0.5) + 1.0)

    def score(self, query_tokens: list[str]) -> list[float]:
        scores = [0.0] * self.n
        for term in query_tokens:
            idf = self._idf(term)
            for i in range(self.n):
                tf = self.tf[i].get(term, 0)
                dl = self.doc_lens[i]
                numerator = tf * (self.k1 + 1)
                denominator = tf + self.k1 * (1 - self.b + self.b * dl / self.avgdl)
                scores[i] += idf * numerator / denominator
        return scores


# ── Search Functions ───────────────────────────────────────────────────────


def search_domain(
    domain: str,
    query: str,
    top: int = DEFAULT_TOP,
    category: str | None = None,
) -> list[tuple[dict, float]]:
    """Search a single domain CSV and return top-N results with scores."""
    filepath = DATA_DIR / DOMAIN_FILES[domain]
    rows = load_csv(filepath)

    if category:
        rows = [r for r in rows if r.get("category", "").lower() == category.lower()]
        if not rows:
            print(f"Warning: no rows match category '{category}'", file=sys.stderr)
            return []

    corpus = [tokenize(row_to_text(row)) for row in rows]
    if not corpus:
        return []

    bm25 = BM25(corpus)
    query_tokens = tokenize(query)
    scores = bm25.score(query_tokens)

    ranked = sorted(enumerate(scores), key=lambda x: x[1], reverse=True)
    results = []
    for idx, sc in ranked[:top]:
        if sc > 0:
            results.append((rows[idx], sc))
    return results


def search_all_domains(query: str, top: int = DEFAULT_TOP, fmt: str = "plain") -> None:
    """Search all domains and print a combined report."""
    print(f'Global Search: "{query}"\n')

    industry_results = search_domain("industry", query, top=top)
    if industry_results:
        print("=== Industry Inference ===\n")
        print_results(industry_results, "industry", query, fmt)

        best_industry = industry_results[0][0]
        print("Recommended matches from top industry:\n")
        for domain, field in (
            ("style", "recommended_styles"),
            ("color", "recommended_colors"),
            ("font", "recommended_fonts"),
        ):
            rows = search_by_ids(domain, best_industry.get(field, ""))
            if not rows:
                continue

            if len(rows) == 1:
                ranked_rows = [(rows[0], 1.0)]
            else:
                corpus = [tokenize(row_to_text(row)) for row in rows]
                bm25 = BM25(corpus)
                scores = bm25.score(tokenize(query))
                ranked_rows = sorted(
                    zip(rows, scores, strict=False),
                    key=lambda item: item[1],
                    reverse=True,
                )
                ranked_rows = [(row, score) for row, score in ranked_rows if score > 0] or [
                    (rows[0], 1.0)
                ]

            print_results(ranked_rows[:top], domain, query, fmt)

    for domain in ("style", "color", "font"):
        print_results(search_domain(domain, query, top=top), domain, query, fmt)


def check_integrity() -> None:
    """Validate cross references in industries.csv against styles/colors/fonts."""
    id_sets: dict[str, set[str]] = {}
    for domain in ("style", "color", "font"):
        rows = load_csv(DATA_DIR / DOMAIN_FILES[domain])
        id_sets[domain] = {row.get("id", "") for row in rows if row.get("id")}

    errors: list[tuple[str, str, str]] = []
    industries = load_csv(DATA_DIR / DOMAIN_FILES["industry"])
    refs = (
        ("recommended_styles", "style"),
        ("recommended_colors", "color"),
        ("recommended_fonts", "font"),
    )

    for industry in industries:
        industry_id = industry.get("id", "?")
        for field, domain in refs:
            raw_ids = [item.strip() for item in industry.get(field, "").split(",") if item.strip()]
            for target_id in raw_ids:
                candidates = id_sets[domain]
                if target_id in candidates:
                    continue
                if any(candidate.startswith(target_id) for candidate in candidates):
                    continue
                errors.append((industry_id, field, target_id))

    if errors:
        print(f"Integrity check failed: {len(errors)} invalid reference(s).\n")
        for industry_id, field, target_id in errors:
            print(f"- {industry_id}: {field} -> {target_id}")
        sys.exit(1)

    print("Integrity check passed: 0 invalid references.")


def search_by_id(domain: str, target_id: str) -> dict | None:
    """Find a single row by its id field."""
    filepath = DATA_DIR / DOMAIN_FILES[domain]
    rows = load_csv(filepath)
    for row in rows:
        if row.get("id", "") == target_id:
            return row
    return None


def search_by_ids(domain: str, id_list: str) -> list[dict]:
    """Find rows matching any of the comma-separated ids.

    Uses exact match first, then falls back to prefix matching for ids
    that don't have an exact counterpart (e.g. 'fintech-dark' matches
    'fintech-dark-premium').
    """
    filepath = DATA_DIR / DOMAIN_FILES[domain]
    rows = load_csv(filepath)
    ids = [i.strip() for i in id_list.split(",") if i.strip()]

    exact = {r.get("id", "") for r in rows}
    results: list[dict] = []
    seen_ids: set[str] = set()

    for target_id in ids:
        if target_id in exact:
            # Exact match
            for r in rows:
                rid = r.get("id", "")
                if rid == target_id and rid not in seen_ids:
                    results.append(r)
                    seen_ids.add(rid)
        else:
            # Prefix fallback: target_id is a prefix of actual id
            for r in rows:
                rid = r.get("id", "")
                if rid.startswith(target_id) and rid not in seen_ids:
                    results.append(r)
                    seen_ids.add(rid)

    return results


# ── Formatters ─────────────────────────────────────────────────────────────


def format_row_plain(row: dict, score: float, index: int) -> str:
    """Format a single search result row as plain text."""
    lines = [f"  [{index}] (score: {score:.3f})"]
    for k, v in row.items():
        if v:
            lines.append(f"      {k}: {v}")
    return "\n".join(lines)


def format_row_markdown(row: dict, score: float, index: int) -> str:
    """Format a single search result row as markdown."""
    lines = [f"### {index}. {row.get('name', row.get('id', '?'))} (score: {score:.3f})", ""]
    for k, v in row.items():
        if v and k not in ("name",):
            lines.append(f"- **{k}**: {v}")
    lines.append("")
    return "\n".join(lines)


def print_results(results: list[tuple[dict, float]], domain: str, query: str, fmt: str) -> None:
    """Print search results in the requested format."""
    if not results:
        print(f"No results found for '{query}' in {domain}.")
        return

    if fmt == "markdown":
        print(f"## Search: \"{query}\" in {domain}\n")
        for i, (row, sc) in enumerate(results, 1):
            print(format_row_markdown(row, sc, i))
    else:
        print(f'Search: "{query}" in {domain}\n')
        for i, (row, sc) in enumerate(results, 1):
            print(format_row_plain(row, sc, i))
        print()


# ── Design System ──────────────────────────────────────────────────────────


def build_design_system(
    query: str,
    fmt: str = "plain",
    persist: bool = False,
    project_name: str | None = None,
    page_name: str | None = None,
) -> None:
    """Build a full design system recommendation from a query."""
    # 1. Find best matching industry
    industry_results = search_domain("industry", query, top=1)
    if not industry_results:
        print(f"Error: no matching industry for '{query}'", file=sys.stderr)
        sys.exit(1)

    industry = industry_results[0][0]

    # 2. Find top style from recommended_styles
    rec_styles = industry.get("recommended_styles", "")
    style = None
    if rec_styles:
        style_rows = search_by_ids("style", rec_styles)
        if style_rows:
            # BM25 rank within the recommended styles
            corpus = [tokenize(row_to_text(r)) for r in style_rows]
            bm25 = BM25(corpus)
            scores = bm25.score(tokenize(query))
            best_idx = max(range(len(scores)), key=lambda i: scores[i])
            style = style_rows[best_idx]
        if not style:
            style = style_rows[0] if style_rows else None

    # 3. Find top color from recommended_colors
    rec_colors = industry.get("recommended_colors", "")
    color = None
    if rec_colors:
        color_rows = search_by_ids("color", rec_colors)
        if color_rows:
            corpus = [tokenize(row_to_text(r)) for r in color_rows]
            bm25 = BM25(corpus)
            scores = bm25.score(tokenize(query))
            best_idx = max(range(len(scores)), key=lambda i: scores[i])
            color = color_rows[best_idx]
        if not color:
            color = color_rows[0] if color_rows else None

    # 4. Find top font from recommended_fonts
    rec_fonts = industry.get("recommended_fonts", "")
    font = None
    if rec_fonts:
        font_rows = search_by_ids("font", rec_fonts)
        if font_rows:
            corpus = [tokenize(row_to_text(r)) for r in font_rows]
            bm25 = BM25(corpus)
            scores = bm25.score(tokenize(query))
            best_idx = max(range(len(scores)), key=lambda i: scores[i])
            font = font_rows[best_idx]
        if not font:
            font = font_rows[0] if font_rows else None

    # 5. Anti-patterns
    anti_patterns_str = industry.get("anti_patterns", "")

    if fmt == "markdown":
        md = _print_design_system_md(query, industry, style, color, font, anti_patterns_str, project_name)
    else:
        _print_design_system_ascii(query, industry, style, color, font, anti_patterns_str)
        md = None

    # --persist: save design system to .ui-designer/
    if persist:
        if md is None:
            md = _format_design_system_md(query, industry, style, color, font, anti_patterns_str, project_name)
        _persist_design_system(md, page_name)


def _print_design_system_ascii(
    query: str,
    industry: dict,
    style: dict | None,
    color: dict | None,
    font: dict | None,
    anti_patterns: str,
) -> None:
    width = 55
    sep = "═" * width

    print(f"\n═══ Design System: {query} ═══\n")

    # Industry
    print(f"Industry: {industry.get('name', '?')} ({industry.get('name_ko', '')})\n")

    # Style
    if style:
        desc = style.get("description", "")
        snippet = (desc[:80] + "...") if len(desc) > 80 else desc
        print(f"Style:    {style.get('name', '?')} ({style.get('category', '')})")
        print(f"          {snippet}\n")
        css_vars = style.get("css_variables", "")
        if css_vars:
            css_preview = css_vars.replace(";", "; ")
            css_preview = (css_preview[:110] + "...") if len(css_preview) > 110 else css_preview
            print(f"          CSS: {css_preview}\n")

    # Colors
    if color:
        print(f"Colors:   {color.get('name', '?')}")
        print(f"          Primary: {color.get('primary', '?')} | Secondary: {color.get('secondary', '?')} | Accent: {color.get('accent', '?')}")
        print(f"          BG: {color.get('background', '?')} | Dark BG: {color.get('dark_bg', '?')}\n")

    # Fonts
    if font:
        print(f"Fonts:    {font.get('name', '?')}")
        print(f"          Display: {font.get('display_font', '?')} {font.get('display_weight', '')}")
        print(f"          Body: {font.get('body_font', '?')} {font.get('body_weight', '')}")
        print(f"          CDN: {font.get('cdn_url', '?')}\n")

    # Rules
    data_density = industry.get("data_density", "?")
    key_principles = industry.get("key_principles", "")
    print(f"Rules:    Data density: {data_density}")
    if anti_patterns:
        print(f"          ⚠ Avoid: {anti_patterns}")
    if key_principles:
        print(f"          ✓ Principles: {key_principles}")

    print(f"\n{sep}\n")


def _format_design_system_md(
    query: str,
    industry: dict,
    style: dict | None,
    color: dict | None,
    font: dict | None,
    anti_patterns: str,
    project_name: str | None = None,
) -> str:
    """Format design system as markdown string."""
    lines: list[str] = []
    title = project_name or query
    lines.append(f"# Design System: {title}\n")
    lines.append(f"## Industry\n\n**{industry.get('name', '?')}** ({industry.get('name_ko', '')})\n")

    if style:
        desc = style.get("description", "")
        snippet = (desc[:80] + "...") if len(desc) > 80 else desc
        lines.append(f"## Style\n\n**{style.get('name', '?')}** ({style.get('category', '')})")
        lines.append(f"\n> {snippet}\n")
        css_vars = style.get("css_variables", "")
        if css_vars:
            lines.append("```css")
            for rule in css_vars.split(";"):
                rule = rule.strip()
                if rule:
                    lines.append(f"  {rule};")
            lines.append("```\n")

    if color:
        lines.append(f"## Colors\n\n**{color.get('name', '?')}**\n")
        lines.append("| Role | Hex |")
        lines.append("|------|-----|")
        for role in ("primary", "secondary", "accent", "background", "text", "border", "cta"):
            val = color.get(role, "")
            if val:
                lines.append(f"| {role.title()} | `{val}` |")
        lines.append("")
        lines.append("**Dark Mode:**\n")
        lines.append("| Role | Hex |")
        lines.append("|------|-----|")
        for role in ("dark_primary", "dark_bg", "dark_text"):
            val = color.get(role, "")
            if val:
                label = role.replace("dark_", "").title()
                lines.append(f"| {label} | `{val}` |")
        lines.append(f"\n- **Mood**: {color.get('mood', '?')}")
        lines.append(f"- **Pairs with**: {color.get('pairs_with_style', '?')}\n")

    if font:
        lines.append(f"## Fonts\n\n**{font.get('name', '?')}**\n")
        lines.append(f"- Display: {font.get('display_font', '?')} ({font.get('display_weight', '')})")
        lines.append(f"- Body: {font.get('body_font', '?')} ({font.get('body_weight', '')})")
        lines.append(f"- Mood: {font.get('style_mood', '?')}")
        lines.append(f"- CDN: `{font.get('cdn_url', '?')}`\n")

    lines.append("## Rules\n")
    lines.append(f"- **Data density**: {industry.get('data_density', '?')}")
    if anti_patterns:
        lines.append(f"- **Avoid**: {anti_patterns}")
    if industry.get("key_principles"):
        lines.append(f"- **Principles**: {industry.get('key_principles', '')}")
    lines.append("")

    return "\n".join(lines)


def _print_design_system_md(
    query: str,
    industry: dict,
    style: dict | None,
    color: dict | None,
    font: dict | None,
    anti_patterns: str,
    project_name: str | None = None,
) -> str:
    md = _format_design_system_md(query, industry, style, color, font, anti_patterns, project_name)
    print(md)
    return md


# ── Persist ───────────────────────────────────────────────────────────


def _persist_design_system(md_content: str, page_name: str | None = None) -> None:
    """Save design system to .ui-designer/ with optional page override."""
    # Find project root (walk up from DATA_DIR until .ui-designer or .git found)
    project_root = DATA_DIR.parent.parent
    # If running from .agents/skills or .claude/plugins, walk up further
    for _ in range(6):
        if (project_root / ".git").exists() or (project_root / "package.json").exists():
            break
        project_root = project_root.parent

    ui_dir = project_root / ".ui-designer"
    ui_dir.mkdir(exist_ok=True)

    if page_name:
        # Page-specific override
        pages_dir = ui_dir / "pages"
        pages_dir.mkdir(exist_ok=True)
        target = pages_dir / f"{page_name}.md"
        target.write_text(md_content, encoding="utf-8")
        print(f"\n[persist] Page override saved → {target.relative_to(project_root)}")

        # Also ensure MASTER exists
        master = ui_dir / "design-system.md"
        if not master.exists():
            master.write_text(md_content, encoding="utf-8")
            print(f"[persist] Master created → {master.relative_to(project_root)}")
    else:
        # Master design system
        target = ui_dir / "design-system.md"
        target.write_text(md_content, encoding="utf-8")
        print(f"\n[persist] Master saved → {target.relative_to(project_root)}")

    # Print retrieval hint
    if page_name:
        print(f"[persist] Retrieval: page '{page_name}' overrides Master. Read page file first, fallback to Master.")
    else:
        print("[persist] Retrieval: read .ui-designer/design-system.md. Check .ui-designer/pages/ for page overrides.")


# ── Anti-Pattern Checker ───────────────────────────────────────────────────


def check_anti_patterns(filepath: str) -> None:
    """Check a file against all anti-pattern detection rules."""
    target = Path(filepath)
    if not target.exists():
        print(f"Error: file not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    try:
        content_lines = target.read_text(encoding="utf-8").splitlines()
    except Exception as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        sys.exit(1)

    anti_csv = DATA_DIR / DOMAIN_FILES["anti-pattern"]
    patterns = load_csv(anti_csv)

    counts = {"high": 0, "medium": 0, "low": 0}
    findings: list[str] = []

    for pat in patterns:
        rule = pat.get("detection_rule", "")
        if not rule:
            continue

        severity = pat.get("severity", "medium").lower()
        matches_found: list[tuple[int, str]] = []

        for line_no, line in enumerate(content_lines, 1):
            try:
                if re.search(rule, line):
                    matches_found.append((line_no, line.strip()))
            except re.error:
                # Skip invalid regex patterns
                continue

        if matches_found:
            counts[severity] = counts.get(severity, 0) + 1
            icon = {"high": "🔴 HIGH", "medium": "🟡 MEDIUM", "low": "🔵 LOW"}.get(
                severity, "⚪ UNKNOWN"
            )
            finding_lines = [
                f"{icon}: {pat.get('id', '?')} ({pat.get('name_ko', pat.get('name', ''))})"
            ]
            for ln, text in matches_found[:5]:  # Cap at 5 examples per pattern
                truncated = (text[:70] + "...") if len(text) > 70 else text
                finding_lines.append(f"   Line {ln}: {truncated}")
            alt = pat.get("alternative", "")
            if alt:
                alt_snippet = (alt[:80] + "...") if len(alt) > 80 else alt
                finding_lines.append(f"   → Alternative: {alt_snippet}")
            findings.append("\n".join(finding_lines))

    builtin_patterns = [
        {
            "id": "img-tag",
            "name": "HTML img tag",
            "name_ko": "<img> 태그 사용",
            "severity": "medium",
            "rule": r"<img\s",
            "alternative": "Use next/image (<Image>) for optimized loading, sizing, and accessibility",
        },
        {
            "id": "inline-hardcoded-color",
            "name": "Inline hardcoded color",
            "name_ko": "인라인 스타일 하드코딩 컬러",
            "severity": "high",
            "rule": r"style=\{\{[^}]*?(?:color|backgroundColor|borderColor)\s*:\s*['\"](?:#[0-9a-fA-F]{3,8}|white|black|gray|grey|red|blue|green)[^'\"]*['\"]",
            "alternative": "Move colors into semantic CSS variables or Tailwind design tokens instead of inline literals",
        },
    ]

    for pat in builtin_patterns:
        matches_found: list[tuple[int, str]] = []
        for line_no, line in enumerate(content_lines, 1):
            if re.search(pat["rule"], line):
                matches_found.append((line_no, line.strip()))

        if not matches_found:
            continue

        severity = pat["severity"]
        counts[severity] = counts.get(severity, 0) + 1
        icon = {"high": "🔴 HIGH", "medium": "🟡 MEDIUM", "low": "🔵 LOW"}.get(
            severity, "⚪ UNKNOWN"
        )
        finding_lines = [f"{icon}: {pat['id']} ({pat['name_ko']})"]
        for ln, text in matches_found[:5]:
            truncated = (text[:70] + "...") if len(text) > 70 else text
            finding_lines.append(f"   Line {ln}: {truncated}")
        finding_lines.append(f"   → Alternative: {pat['alternative']}")
        findings.append("\n".join(finding_lines))

    # Output
    print(f"\nAnti-Pattern Check: {filepath}\n")
    if findings:
        print("\n\n".join(findings))
    else:
        print("✅ No anti-patterns detected.")
    print(f"\nSummary: {counts['high']} HIGH, {counts['medium']} MEDIUM, {counts['low']} LOW\n")


# ── CLI ────────────────────────────────────────────────────────────────────


def main() -> None:
    parser = argparse.ArgumentParser(
        description="BM25 search engine for ui-designer plugin design system data."
    )
    parser.add_argument("query", nargs="?", default=None, help="Search query string")
    parser.add_argument(
        "--domain",
        choices=list(DOMAIN_FILES.keys()),
        help="Data domain to search (style, color, font, industry, anti-pattern)",
    )
    parser.add_argument("--top", type=int, default=DEFAULT_TOP, help="Number of top results (default: 5)")
    parser.add_argument("--category", help="Filter by category (for styles)")
    parser.add_argument("--design-system", action="store_true", help="Generate full design system recommendation")
    parser.add_argument("--persist", action="store_true", help="Save design system to .ui-designer/ (use with --design-system)")
    parser.add_argument("-p", "--project", help="Project name for design system header")
    parser.add_argument("--page", help="Page name for page-specific override (use with --persist)")
    parser.add_argument("--check-anti-patterns", metavar="FILE", help="Check a file for anti-patterns")
    parser.add_argument(
        "--check-integrity",
        action="store_true",
        help="Validate industries.csv references against styles/colors/fonts",
    )
    parser.add_argument(
        "--format",
        choices=["plain", "markdown"],
        default="plain",
        help="Output format (default: plain)",
    )

    args = parser.parse_args()

    # --check-anti-patterns mode
    if args.check_anti_patterns:
        check_anti_patterns(args.check_anti_patterns)
        return

    if args.check_integrity:
        check_integrity()
        return

    # Validate query is present for other modes
    if args.query is None:
        parser.error("query is required (unless using --check-anti-patterns or --check-integrity)")

    # --design-system mode
    if args.design_system:
        build_design_system(
            args.query,
            fmt=args.format,
            persist=args.persist,
            project_name=args.project,
            page_name=args.page,
        )
        return

    # --domain search mode
    if not args.domain:
        search_all_domains(args.query, top=args.top, fmt=args.format)
        return

    results = search_domain(args.domain, args.query, top=args.top, category=args.category)
    print_results(results, args.domain, args.query, args.format)


if __name__ == "__main__":
    main()
