#!/usr/bin/env bash
# Local MkDocs helper: build / serve / install.
# Run from the repo root.
#
# Usage:
#   bash tools/docs.sh install   # create .venv-docs and install requirements
#   bash tools/docs.sh build     # build the static site (matches what the GH Action does)
#   bash tools/docs.sh serve     # live-reload dev server on http://localhost:8000
#   bash tools/docs.sh clean     # remove site/ and the README→index.md copies
#
# All commands transparently rename README.md → index.md (in CI we mv; here we
# cp so the source tree keeps its README.md). The clean command undoes that.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
VENV="$REPO_ROOT/.venv-docs"
PY_WIN="$VENV/Scripts/python.exe"
PY_NIX="$VENV/bin/python"

cd "$REPO_ROOT"

py() {
  if [[ -x "$PY_WIN" ]]; then "$PY_WIN" "$@";
  elif [[ -x "$PY_NIX" ]]; then "$PY_NIX" "$@";
  else echo "venv missing — run: bash tools/docs.sh install" >&2; exit 1; fi
}

prepare_indexes() {
  # Mirror each README.md to index.md in the same folder, only if missing.
  # MkDocs reads index.md as the section landing page.
  find dev-wiki -name "README.md" -print0 | while IFS= read -r -d '' f; do
    d="$(dirname "$f")"
    if [[ ! -f "$d/index.md" ]]; then
      cp "$f" "$d/index.md"
    fi
  done
}

cleanup_indexes() {
  # Remove the index.md copies created by prepare_indexes (only the ones whose
  # content matches the sibling README.md, to avoid clobbering hand-edited files).
  find dev-wiki -name "index.md" -print0 | while IFS= read -r -d '' f; do
    d="$(dirname "$f")"
    if [[ -f "$d/README.md" ]] && cmp -s "$f" "$d/README.md"; then
      rm "$f"
    fi
  done
}

cmd="${1:-help}"
case "$cmd" in
  install)
    if [[ ! -d "$VENV" ]]; then
      python -m venv "$VENV"
    fi
    py -m pip install --quiet --disable-pip-version-check -r requirements-docs.txt
    echo "venv ready at $VENV"
    py -m mkdocs --version
    ;;
  build)
    prepare_indexes
    py -m mkdocs build
    cleanup_indexes
    echo "built into ./site"
    ;;
  serve)
    prepare_indexes
    trap cleanup_indexes EXIT
    py -m mkdocs serve --dev-addr 127.0.0.1:8000
    ;;
  clean)
    cleanup_indexes
    rm -rf site
    echo "cleaned site/ and README→index copies"
    ;;
  help|--help|-h)
    sed -n '2,15p' "$0" | sed 's/^# *//'
    ;;
  *)
    echo "unknown command: $cmd" >&2
    sed -n '2,15p' "$0" | sed 's/^# *//' >&2
    exit 2
    ;;
esac
