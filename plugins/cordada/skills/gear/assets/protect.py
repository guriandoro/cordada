#!/usr/bin/env python3
"""PreToolUse guard: refuse edits to paths listed in .claude/protected.

Reads the hook JSON on stdin. Exit 2 with a reason on stderr refuses the edit.
Any other problem lets the edit through: a broken guard must not block work.
"""
import fnmatch
import json
import os
import sys


def main():
    try:
        event = json.load(sys.stdin)
    except Exception:
        return 0
    path = (event.get("tool_input") or {}).get("file_path")
    root = os.environ.get("CLAUDE_PROJECT_DIR") or event.get("cwd") or os.getcwd()
    rules_file = os.path.join(root, ".claude", "protected")
    if not path or not os.path.isfile(rules_file):
        return 0
    rel = os.path.relpath(os.path.realpath(path), os.path.realpath(root))
    # A subagent working in .claude/worktrees/<name>/ edits a copy of the repo: match the path inside it.
    parts = rel.split(os.sep)
    if parts[:2] == [".claude", "worktrees"] and len(parts) > 3:
        rel = os.path.join(*parts[3:])
    with open(rules_file, encoding="utf-8") as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            pattern, _, reason = line.partition("#")
            pattern = pattern.strip()
            pattern = pattern[2:] if pattern.startswith("./") else pattern.lstrip("/")
            if fnmatch.fnmatch(rel, pattern) or fnmatch.fnmatch(os.path.basename(rel), pattern):
                why = reason.strip() or "listed in .claude/protected"
                sys.stderr.write(
                    f"Refused: {rel} is protected ({why}). "
                    "Don't work around this. Tell the user what you needed to change and why.\n"
                )
                return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
