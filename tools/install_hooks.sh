#!/usr/bin/env bash
# Install the wiki git hooks into .git/hooks/.
# Re-run this whenever hooks change.

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
src_dir="$repo_root/tools/hooks"
dst_dir="$repo_root/.git/hooks"

if [[ ! -d "$dst_dir" ]]; then
  echo "Error: $dst_dir not found. Are you running this from a git repo?" >&2
  exit 1
fi

for hook in "$src_dir"/*; do
  name="$(basename "$hook")"
  cp "$hook" "$dst_dir/$name"
  chmod +x "$dst_dir/$name"
  echo "installed: $name"
done

echo ""
echo "Hooks installed in $dst_dir"
