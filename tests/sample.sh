#!/usr/bin/env bash
# Tests for sample/create.sh: each catch-up level is committed, clean, and at the level route reports.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
route="$here/plugins/cordada/scripts/route"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail=0
expect() { if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1 (wanted $2, got $3)"; fail=1; fi; }
levels="1 2 3 4"; command -v bd >/dev/null && levels="$levels 5"
for n in $levels; do
  d="$tmp/t$n"
  if [ "$n" = 1 ]; then "$here/sample/create.sh" "$d" >/dev/null; else "$here/sample/create.sh" "$d" --level "$n" >/dev/null; fi
  expect "level $n: route" "$n" "$(cd "$d" && "$route" --level)"
  expect "level $n: clean tree" "0" "$(git -C "$d" status --porcelain | wc -l | tr -d ' ')"
done
(cd "$tmp/t1" && python3 -m unittest discover -s tests >/dev/null 2>&1); expect "level 1: tests fail on purpose" "1" "$?"
(cd "$tmp/t4" && ./check >/dev/null 2>&1); expect "level 4: ./check passes" "0" "$?"
if [ -d "$tmp/t5" ]; then
  expect "level 5: two tasks ready" "2" "$(cd "$tmp/t5" && bd ready --json 2>/dev/null | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
  expect "level 5: five tasks blocked" "5" "$(cd "$tmp/t5" && bd blocked --json 2>/dev/null | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
fi
expect "level 3: guard refuses vaquita/__init__.py" "2" "$(cd "$tmp/t3" && printf '{"tool_input":{"file_path":"%s"}}' "$PWD/vaquita/__init__.py" | CLAUDE_PROJECT_DIR="$PWD" python3 .claude/hooks/protect.py 2>/dev/null; echo $?)"
"$here/sample/create.sh" "$tmp/t1" >/dev/null 2>&1; expect "refuses an existing folder" "1" "$?"
exit $fail
