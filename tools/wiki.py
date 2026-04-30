#!/usr/bin/env python3
"""
Wiki management CLI.

Subcommands:
  status   Status dashboard — counts topics by status across sections.
  next     Suggest next stubs to write (optional filter by section).
  lint     Validate YAML frontmatter on every topic README.
  links    Find broken relative markdown links.
  touch    Update last_updated frontmatter for a given file.

All commands operate on the dev-wiki/ tree relative to the repository root.

Usage:
  python tools/wiki.py status
  python tools/wiki.py next [SECTION]
  python tools/wiki.py lint
  python tools/wiki.py links
  python tools/wiki.py touch <path/to/README.md>
"""

from __future__ import annotations

import argparse
import datetime as dt
import os
import random
import re
import sys
from collections import defaultdict
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
WIKI_ROOT = REPO_ROOT / "dev-wiki"

ALLOWED_STATUS = {"stub", "draft", "wip", "reviewed", "stable"}
ALLOWED_DIFFICULTY = {"beginner", "intermediate", "advanced"}
REQUIRED_FRONTMATTER_KEYS = {
    "title",
    "section",
    "status",
    "difficulty",
    "tags",
    "prerequisites",
    "related",
    "last_updated",
    "reading_time_min",
}

EXCLUDED_TOP_DIRS = {"00_Index", "17_Real_World", "18_Snippets", "19_ADR", "99_Resources", "assets"}


# --------------------------------------------------------------------------- #
# Frontmatter parsing
# --------------------------------------------------------------------------- #

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)


def parse_frontmatter(text: str) -> dict | None:
    """Parse YAML frontmatter (minimal, no deps). Returns None if not present."""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return None
    body = m.group(1)
    out: dict[str, str | list] = {}
    for line in body.splitlines():
        line = line.rstrip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            continue
        key, _, val = line.partition(":")
        key = key.strip()
        val = val.strip()
        # Inline list: [a, b, c]
        if val.startswith("[") and val.endswith("]"):
            inner = val[1:-1].strip()
            items = [x.strip() for x in inner.split(",") if x.strip()] if inner else []
            out[key] = items
        else:
            out[key] = val
    return out


def iter_topic_readmes() -> list[Path]:
    """Yield every leaf-topic README.md (skipping category READMEs and special dirs)."""
    readmes = []
    for path in WIKI_ROOT.rglob("README.md"):
        # Skip Playground READMEs
        if "Playground" in path.parts:
            continue
        # Only include files that have YAML frontmatter (i.e., topic-level READMEs).
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        if text.startswith("---"):
            readmes.append(path)
    return sorted(readmes)


def topic_section(path: Path) -> str:
    """Extract the top-level section (e.g. '01_Foundations') from a topic README path."""
    rel = path.relative_to(WIKI_ROOT)
    return rel.parts[0]


# --------------------------------------------------------------------------- #
# status
# --------------------------------------------------------------------------- #

def cmd_status(_args: argparse.Namespace) -> int:
    """Dashboard: count topics by status across sections."""
    by_section: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    totals: dict[str, int] = defaultdict(int)

    for path in iter_topic_readmes():
        text = path.read_text(encoding="utf-8")
        fm = parse_frontmatter(text) or {}
        status = str(fm.get("status", "unknown"))
        section = topic_section(path)
        by_section[section][status] += 1
        totals[status] += 1

    statuses = ["stub", "draft", "wip", "reviewed", "stable"]
    headers = ["Section"] + statuses + ["TOTAL"]
    widths = [38, 6, 7, 5, 10, 8, 7]

    print("=== Wiki Status Dashboard ===\n")
    print("  ".join(h.ljust(w) for h, w in zip(headers, widths)))
    print("  ".join("-" * w for w in widths))

    grand_total = 0
    for section in sorted(by_section.keys()):
        counts = by_section[section]
        row_total = sum(counts.values())
        grand_total += row_total
        row = [section] + [str(counts.get(s, 0)) for s in statuses] + [str(row_total)]
        print("  ".join(c.ljust(w) for c, w in zip(row, widths)))

    print("  ".join("-" * w for w in widths))
    total_row = ["TOTAL"] + [str(totals.get(s, 0)) for s in statuses] + [str(grand_total)]
    print("  ".join(c.ljust(w) for c, w in zip(total_row, widths)))

    reviewed_or_stable = totals.get("reviewed", 0) + totals.get("stable", 0)
    if grand_total > 0:
        pct = reviewed_or_stable / grand_total * 100
        print(f"\nProgress: {reviewed_or_stable}/{grand_total} ({pct:.1f}%) reviewed or stable")
    return 0


# --------------------------------------------------------------------------- #
# next
# --------------------------------------------------------------------------- #

def cmd_next(args: argparse.Namespace) -> int:
    """Suggest stubs to tackle next."""
    section_filter = args.section
    candidates: list[Path] = []
    for path in iter_topic_readmes():
        text = path.read_text(encoding="utf-8")
        fm = parse_frontmatter(text) or {}
        if str(fm.get("status", "")) != "stub":
            continue
        if section_filter and topic_section(path) != section_filter:
            continue
        candidates.append(path)

    if not candidates:
        print("No stubs found." if section_filter else "All topics done!")
        return 0

    print(f"=== Next stubs ({len(candidates)} total{f' in {section_filter}' if section_filter else ''}) ===\n")

    # Show 10 random suggestions to avoid always picking the same first ones.
    sample_size = min(10, len(candidates))
    sample = random.sample(candidates, sample_size)
    for p in sample:
        rel = p.parent.relative_to(WIKI_ROOT)
        print(f"  - {rel}")

    if len(candidates) > sample_size:
        print(f"\n  ... and {len(candidates) - sample_size} more.")
    print("\nFilter by section: python tools/wiki.py next <SECTION_NAME>")
    return 0


# --------------------------------------------------------------------------- #
# lint
# --------------------------------------------------------------------------- #

def cmd_lint(_args: argparse.Namespace) -> int:
    """Validate frontmatter across every topic README."""
    errors: list[str] = []
    files_checked = 0

    for path in iter_topic_readmes():
        files_checked += 1
        text = path.read_text(encoding="utf-8")
        fm = parse_frontmatter(text)
        rel = path.relative_to(REPO_ROOT)

        if fm is None:
            errors.append(f"{rel}: no YAML frontmatter found")
            continue

        # Required keys
        missing = REQUIRED_FRONTMATTER_KEYS - set(fm.keys())
        for key in sorted(missing):
            errors.append(f"{rel}: missing frontmatter key '{key}'")

        # Status enum
        status = str(fm.get("status", ""))
        if status and status not in ALLOWED_STATUS:
            errors.append(f"{rel}: invalid status '{status}' (allowed: {sorted(ALLOWED_STATUS)})")

        # Difficulty enum
        difficulty = str(fm.get("difficulty", ""))
        if difficulty and difficulty not in ALLOWED_DIFFICULTY:
            errors.append(
                f"{rel}: invalid difficulty '{difficulty}' (allowed: {sorted(ALLOWED_DIFFICULTY)})"
            )

        # last_updated format
        last_updated = str(fm.get("last_updated", ""))
        if last_updated and not re.match(r"^\d{4}-\d{2}-\d{2}$", last_updated):
            errors.append(f"{rel}: last_updated '{last_updated}' must be YYYY-MM-DD")

        # tags must be a list
        tags = fm.get("tags")
        if tags is not None and not isinstance(tags, list):
            errors.append(f"{rel}: tags must be a YAML list, got {type(tags).__name__}")

        # title must match folder name (with underscores → spaces)
        title = str(fm.get("title", ""))
        expected = path.parent.name.replace("_", " ")
        if title and title != expected:
            errors.append(f"{rel}: title '{title}' should be '{expected}' (matches folder name)")

    print(f"Linted {files_checked} topic READMEs.\n")
    if errors:
        print(f"Errors ({len(errors)}):")
        for e in errors:
            print(f"  {e}")
        return 1
    print("OK — no frontmatter errors.")
    return 0


# --------------------------------------------------------------------------- #
# links
# --------------------------------------------------------------------------- #

LINK_RE = re.compile(r"\[([^\]]*)\]\(([^)]+)\)")
FENCED_BLOCK_RE = re.compile(r"```.*?```", re.DOTALL)
INLINE_CODE_RE = re.compile(r"`[^`\n]*`")


def _strip_code(text: str) -> str:
    """Replace fenced code blocks and inline code with whitespace of equal length.

    Keeping byte offsets stable means line numbers reported by LINK_RE.finditer()
    still match the original file.
    """
    def blank(match: re.Match[str]) -> str:
        return "".join("\n" if c == "\n" else " " for c in match.group(0))

    text = FENCED_BLOCK_RE.sub(blank, text)
    text = INLINE_CODE_RE.sub(blank, text)
    return text


def cmd_links(_args: argparse.Namespace) -> int:
    """Walk every .md file under dev-wiki/ and check relative links resolve."""
    broken: list[str] = []
    checked = 0

    for path in WIKI_ROOT.rglob("*.md"):
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        scrubbed = _strip_code(text)
        for m in LINK_RE.finditer(scrubbed):
            target = m.group(2).strip()
            # Skip external, anchors, mailto, wikilinks (those aren't markdown links anyway).
            if target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            # Strip anchor / query
            target_clean = target.split("#", 1)[0].split("?", 1)[0]
            if not target_clean:
                continue
            checked += 1
            resolved = (path.parent / target_clean).resolve()
            # If link points to a directory, that's fine (folder navigation works).
            if resolved.exists():
                continue
            # Try with implicit README.md or index.md.
            if resolved.is_dir() or (resolved / "README.md").exists() or (resolved / "index.md").exists():
                continue
            # If it's a "/" path (folder), it's already handled above when the dir exists.
            line_no = text.count("\n", 0, m.start()) + 1
            broken.append(
                f"{path.relative_to(REPO_ROOT)}:{line_no}: [{m.group(1)}]({target}) -> not found"
            )

    print(f"Checked {checked} relative links.\n")
    if broken:
        print(f"Broken ({len(broken)}):")
        for b in broken:
            print(f"  {b}")
        return 1
    print("OK — no broken links.")
    return 0


# --------------------------------------------------------------------------- #
# touch
# --------------------------------------------------------------------------- #

def cmd_touch(args: argparse.Namespace) -> int:
    """Update the last_updated frontmatter field for one or more files."""
    today = dt.date.today().isoformat()
    updated = 0
    for filename in args.files:
        path = Path(filename).resolve()
        if not path.exists():
            print(f"skip (not found): {filename}", file=sys.stderr)
            continue
        text = path.read_text(encoding="utf-8")
        if not text.startswith("---"):
            continue  # no frontmatter, nothing to touch
        new_text, count = re.subn(
            r"^(last_updated:\s*)\S+",
            rf"\g<1>{today}",
            text,
            count=1,
            flags=re.MULTILINE,
        )
        if count and new_text != text:
            path.write_text(new_text, encoding="utf-8")
            updated += 1
            print(f"touched: {path.relative_to(REPO_ROOT) if REPO_ROOT in path.parents else path}")
    if updated == 0:
        print("Nothing to update.")
    return 0


# --------------------------------------------------------------------------- #
# Entrypoint
# --------------------------------------------------------------------------- #

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="wiki", description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)

    sub.add_parser("status", help="Dashboard of topics by status").set_defaults(func=cmd_status)

    p_next = sub.add_parser("next", help="Suggest next stubs to write")
    p_next.add_argument("section", nargs="?", default=None, help="Filter by section name (e.g. 02_Architecture)")
    p_next.set_defaults(func=cmd_next)

    sub.add_parser("lint", help="Validate frontmatter").set_defaults(func=cmd_lint)
    sub.add_parser("links", help="Find broken relative links").set_defaults(func=cmd_links)

    p_touch = sub.add_parser("touch", help="Update last_updated to today")
    p_touch.add_argument("files", nargs="+", help="Markdown file(s) to update")
    p_touch.set_defaults(func=cmd_touch)

    return p


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
