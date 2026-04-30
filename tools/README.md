# Wiki Tools

Maintenance scripts for the wiki. All commands assume the repo root as the working directory and operate on `dev-wiki/`.

## Requirements

- Python 3.10+ (for `wiki.py`).
- Bash + Git (for hook scripts).

No external Python deps — `wiki.py` uses standard library only.

## Commands

### `wiki.py status` — progress dashboard

Counts topics by frontmatter status (`stub`, `draft`, `wip`, `reviewed`, `stable`) per section.

```bash
python tools/wiki.py status
```

Sample output:

```
=== Wiki Status Dashboard ===

Section                                stub    draft   wip   reviewed   stable   TOTAL
--------------------------------------  ------  ------- -----  ---------- -------- ------
01_Foundations                          12      0       0     0          0        12
02_Architecture                         15      0       0     0          0        15
...
TOTAL                                   337     0       0     0          0        337

Progress: 0/337 (0.0%) reviewed or stable
```

### `wiki.py next [SECTION]` — pick a stub to tackle

Picks 10 random stubs to write next. Optional section filter.

```bash
python tools/wiki.py next                 # 10 stubs from anywhere
python tools/wiki.py next 02_Architecture # 10 stubs only from Architecture
```

### `wiki.py lint` — frontmatter validation

Validates that every topic README has correct YAML frontmatter:
- Required keys present (`title`, `section`, `status`, `difficulty`, `tags`, `prerequisites`, `related`, `last_updated`, `reading_time_min`).
- `status` is one of `stub | draft | wip | reviewed | stable`.
- `difficulty` is one of `beginner | intermediate | advanced`.
- `last_updated` matches `YYYY-MM-DD`.
- `tags` is a YAML list.
- `title` matches the folder name (with underscores → spaces).

Exits with non-zero if any errors found.

```bash
python tools/wiki.py lint
```

### `wiki.py links` — broken-link detector

Walks every markdown file under `dev-wiki/` and verifies that relative links resolve to existing files or directories. Skips external URLs, anchors, mailto, and wiki-style `[[...]]` placeholders.

```bash
python tools/wiki.py links
```

### `wiki.py touch <file>` — refresh last_updated

Updates the `last_updated:` frontmatter field of one or more files to today's date. Used by the pre-commit hook.

```bash
python tools/wiki.py touch dev-wiki/01_Foundations/SOLID/README.md
```

## Local MkDocs build

Test the site locally before pushing — saves the round-trip through GitHub Actions.

```bash
bash tools/docs.sh install   # one-time: create .venv-docs and install deps
bash tools/docs.sh build     # build static site to ./site
bash tools/docs.sh serve     # live-reload dev server on http://localhost:8000
bash tools/docs.sh clean     # remove site/ and the README→index.md copies
```

The script transparently mirrors `README.md` → `index.md` (the same step the GitHub Action does), then undoes it on cleanup so the source tree stays untouched.

## Git hooks

### `tools/install_hooks.sh`

Installs the `pre-commit` hook into `.git/hooks/`. Run once after cloning the repo.

```bash
bash tools/install_hooks.sh
```

### `tools/hooks/pre-commit`

Whenever you commit, the hook updates `last_updated:` on every staged `dev-wiki/.../README.md` so the timestamp stays accurate without manual edits. The updated files are re-staged automatically.

To skip the hook for a single commit (rarely needed):

```bash
git commit --no-verify
```

## Suggested workflow

1. Pick a stub: `python tools/wiki.py next`
2. Write content. Use [00_Index/CONVENTIONS.md](../dev-wiki/00_Index/CONVENTIONS.md) for guidance.
3. Lint before commit: `python tools/wiki.py lint`
4. Check links: `python tools/wiki.py links`
5. Commit — the hook refreshes `last_updated` automatically.
6. See progress: `python tools/wiki.py status`
