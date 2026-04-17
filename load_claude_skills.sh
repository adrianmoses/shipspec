#!/usr/bin/env bash
#
# Copy every top-level skill directory (one containing a SKILL.md)
# into ~/.claude/skills/, overwriting any previous copy.
#
set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST_DIR"

shopt -s nullglob
found=0
for skill_md in "$SRC_DIR"/*/SKILL.md; do
  skill_dir="$(dirname "$skill_md")"
  name="$(basename "$skill_dir")"
  rm -rf "$DEST_DIR/$name"
  cp -R "$skill_dir" "$DEST_DIR/"
  echo "loaded: $name -> $DEST_DIR/$name"
  found=$((found + 1))
done

if [ "$found" -eq 0 ]; then
  echo "no skills found in $SRC_DIR (looked for */SKILL.md)" >&2
  exit 1
fi

echo "done: $found skill(s) loaded"
