#!/usr/bin/env bash
# Tests for scripts/route: the level it reports for hand-made repos.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
route="$here/plugins/cordada/scripts/route"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail=0
level() { (cd "$1" && "$route" --level); }
expect() { if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1 (wanted level $2, got $3)"; fail=1; fi; }
map() { printf 'line\n%.0s' 1 2 3 4 5 6 7; printf 'Run ./check. Tasks: bd ready\n'; }

r="$tmp/r"; mkdir -p "$r" && git -C "$r" init -q
expect "empty repo"                     1 "$(level "$r")"
map > "$r/CLAUDE.md";                     expect "map"                   2 "$(level "$r")"
mkdir -p "$r/.claude/skills/x" && touch "$r/.claude/skills/x/SKILL.md"
                                          expect "map + skill"           3 "$(level "$r")"
mkdir "$r/check";                         expect "check is a directory"  3 "$(level "$r")"
rmdir "$r/check"; printf '#!/bin/sh\n' > "$r/check"; chmod +x "$r/check"
                                          expect "map + skill + check"   4 "$(level "$r")"
if command -v bd >/dev/null 2>&1; then
  mkdir -p "$r/.beads";                   expect "all five"              5 "$(level "$r")"
fi
mv "$r/CLAUDE.md" "$r/.claude/CLAUDE.md"; expect "map in .claude/"       "$(command -v bd >/dev/null && echo 5 || echo 4)" "$(level "$r")"
rm "$r/.claude/CLAUDE.md";                expect "gap at level 2"        1 "$(level "$r")"
(cd "$tmp" && "$route" >/dev/null 2>&1);  expect "outside git exits 2"   2 "$?"
exit $fail
