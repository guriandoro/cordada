#!/usr/bin/env bash
# Stop hook (optional): the agent cannot finish a turn that changed files while ./check fails.
# Lets the stop through when nothing changed, when it already blocked once this turn, or when there is no ./check.
input="$(cat)"
root="${CLAUDE_PROJECT_DIR:-$PWD}"
cd "$root" 2>/dev/null || exit 0
[ -x ./check ] || exit 0
printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0
[ -z "$(git status --porcelain 2>/dev/null)" ] && exit 0
out="$(./check 2>&1)" && exit 0
printf './check fails, so the work is not done. Fix the cause, not the check. Last lines:\n%s\n' "$(printf '%s' "$out" | tail -15)" >&2
exit 2
