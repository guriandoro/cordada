#!/usr/bin/env bash
# Tests for the guard hook (protect.py) and the done gate (done-gate.sh). No Claude session needed.
set -u
here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
protect="$here/plugins/cordada/skills/gear/assets/protect.py"
gate="$here/plugins/cordada/skills/checks/assets/done-gate.sh"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail=0
expect() { # expect <name> <wanted exit> <actual exit>
  if [ "$2" = "$3" ]; then echo "ok   $1"; else echo "FAIL $1 (wanted exit $2, got $3)"; fail=1; fi
}

cd "$tmp" && git init -q . && mkdir -p .claude
printf 'migrations/*   # history\n./docs/x.md\n/abs.txt\nsecret file.txt\n' > .claude/protected
guard() { printf '{"tool_input":{"file_path":"%s"}}' "$tmp/$1" | CLAUDE_PROJECT_DIR="$tmp" python3 "$protect" 2>/dev/null; echo $?; }
expect "glob in a folder"           2 "$(guard migrations/001.sql)"
expect "leading ./ in a pattern"    2 "$(guard docs/x.md)"
expect "leading / in a pattern"     2 "$(guard abs.txt)"
expect "path with a space"          2 "$(guard 'secret file.txt')"
expect "inside a climber worktree"  2 "$(guard .claude/worktrees/agent-1/migrations/001.sql)"
expect "unprotected file"           0 "$(guard src/app.py)"
echo 'not json' | CLAUDE_PROJECT_DIR="$tmp" python3 "$protect" 2>/dev/null; expect "bad input lets the edit through" 0 $?
rm .claude/protected
expect "no rules file"              0 "$(guard migrations/001.sql)"

gate_run() { printf '%s' "$1" | CLAUDE_PROJECT_DIR="$tmp" bash "$gate" 2>/dev/null; echo $?; }
expect "gate: no ./check"           0 "$(gate_run '{}')"
printf '#!/bin/sh\nexit 1\n' > check && chmod +x check
expect "gate: failing check, dirty tree" 2 "$(gate_run '{"stop_hook_active":false}')"
expect "gate: already blocked once" 0 "$(gate_run '{"stop_hook_active" : true}')"
git add -A && git -c user.name=t -c user.email=t@t commit -qm t
expect "gate: clean tree"           0 "$(gate_run '{}')"
exit $fail
