#!/usr/bin/env bash
# Create a fresh copy of the sample repo to practise on.
# Usage: sample/create.sh [target-dir] [--level 2|3|4|5]     (default: ./vaquita, level 1)
#   --level N  catch up: the repo starts with levels 2..N already in place, committed,
#              as if you had run map, gear, checks (and the first goal) and rope yourself.
#              Level 5 needs bd (beads).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="vaquita"; level=1
while [ $# -gt 0 ]; do
  case "$1" in
    --level) level="${2:-}"; shift 2 ;;
    --level=*) level="${1#--level=}"; shift ;;
    -h|--help) sed -n '2,5p' "$0"; exit 0 ;;
    *) target="$1"; shift ;;
  esac
done
case "$level" in 1|2|3|4|5) ;; *) echo "error: --level must be 2, 3, 4 or 5." >&2; exit 1 ;; esac
[ "$level" -lt 5 ] || command -v bd >/dev/null || { echo "error: --level 5 needs bd (beads): brew install beads" >&2; exit 1; }

if [ -e "$target" ]; then
  echo "error: $target already exists. Pick another directory or remove it." >&2
  exit 1
fi
command -v git >/dev/null || { echo "error: git is not installed." >&2; exit 1; }

mkdir -p "$target"
cp -R "$here/template/." "$target/"
cd "$target"
git init -q -b main 2>/dev/null || { git init -q && git symbolic-ref HEAD refs/heads/main; }
# No git identity on this machine? Set one for this sample repo only, so the commits between steps work.
git config user.name >/dev/null 2>&1 || git config --local user.name "cordada workshop"
git config user.email >/dev/null 2>&1 || git config --local user.email "workshop@example.invalid"
git add -A && git commit -q -m "vaquita: starting point"

c="$here/catchup"
if [ "$level" -ge 2 ]; then
  cp "$c/CLAUDE.map.md" CLAUDE.md; mkdir -p docs; cp "$c/docs/decisions.md" docs/
  git add -A && git commit -q -m "level 2: map (catch-up)"
fi
if [ "$level" -ge 3 ]; then
  mkdir -p .claude/hooks tools
  cp -R "$c/dot-claude/." .claude/
  cp "$here/../plugins/cordada/skills/gear/assets/protect.py" .claude/hooks/protect.py
  cp "$c/tools/new_module.py" tools/
  cat "$c/CLAUDE.gear.md" >> CLAUDE.md
  git add -A && git commit -q -m "level 3: gear (catch-up)"
fi
if [ "$level" -ge 4 ]; then
  cp "$c/check" check
  cat "$c/CLAUDE.checks.md" >> CLAUDE.md
  cp "$c/vaquita/split.py" vaquita/split.py
  git add -A && git commit -q -m "level 4: checks, split bug fixed (catch-up)"
fi

if [ "$level" -ge 5 ]; then
  bd init -p vaq --non-interactive --skip-agents --skip-hooks >/dev/null 2>&1
  "$c/tasks.sh"
  cat "$c/CLAUDE.rope.md" >> CLAUDE.md
  echo 'Tasks live in beads (`bd`); see the Tasks section of CLAUDE.md.' > TODO.md
  printf '.claude/worktrees/\n' >> .gitignore
  git add -A && git commit -q -m "level 5: rope (catch-up)"
fi

plugin="$(cd "$here/.." && pwd)/plugins/cordada"
echo "Sample repo ready in: $(pwd)"
echo "It is vaquita: it splits shared expenses (an asado) and says who pays whom."
case "$level" in
  1|2|3) echo "Two tests fail on purpose, and TODO.md lists what is left to build." ;;
  4) echo "The split bug is fixed, and TODO.md lists what is left to build." ;;
  5) echo "The split bug is fixed, and the rest of the work is in beads: run bd ready." ;;
esac
[ "$level" -ge 2 ] && echo "Caught up to level $level: the earlier levels are already in place and committed."
echo "Next: cd $target && claude --plugin-dir $plugin"
