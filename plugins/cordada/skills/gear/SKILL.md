---
name: gear
description: Level 3 of Cordada, as a guide. With no project skill in the repo, it explains skills, tools and hooks, finds a procedure this repo repeats and a file to protect, and gives the prompts to ask Claude for one of each. With a project skill, it checks the skill, the script and the hook against the level's criteria and says what to fix. It writes nothing itself. Use when someone says "cordada gear", "make a skill for this repo", "turn this procedure into a skill", "add a hook to protect files", "check my skill", or keeps explaining the same steps to the agent. Needs level 2 (a CLAUDE.md) first.
argument-hint: "[guide]"
---

# gear

Level 3 of the climb. You are a guide here, not the one doing the work. The user builds the gear with Claude, in their own words, so they can do it again on any repo without this plugin.

**Don't create or edit any file during this skill.** Read, run read-only commands, explain, and check. When the user types a prompt you give them, that is a new request of theirs: follow it normally then.

## 0. Check the level below, then pick the mode

No `CLAUDE.md` (root or `.claude/`)? Stop: "Gear builds on the map, and this repo has none. Run `/cordada:map` first." Go on only if the user insists.

Your reply always starts with the mode line, word for word, before anything else, even when the check comes out clean:

- Argument is `guide`, or no `.claude/skills/*/SKILL.md` in the repo: **guide mode**. "No project skill yet, so this is the guide." (or "Guide mode, as asked.")
- A project skill exists: **check mode**. "Found the <name> skill, so I'm checking the gear. For the guide instead: `/cordada:gear guide`."

## Guide mode

**1. Why, in four short lines.** Say it in your words:
- The map says what is true. Gear makes the agent act the same way every time.
- **Skill:** a procedure written once, loaded when the request matches its description. For steps that need judgment.
- **Tool:** a script, for the step that must come out identical every run. The agent decides, the script does.
- **Hook:** a rule the harness enforces, even when the agent forgets. Level 4 (Checks) adds the check that every skill ends on.

**2. Look at the repo, read-only, a minute at most.** `CLAUDE.md`, the README, notes like `TODO.md`, `git log --oneline -20`, the layout of the code and tests. Report, naming the file where you saw it:
- **A procedure done more than twice:** up to three candidates (for example "add a module with its test file", "add a migration"), best first. Narrow and frequent beats big and rare.
- **The exact step inside it:** the part that must not vary, usually scaffolding a file layout.
- **Files to protect:** start from the "Do not" section of `CLAUDE.md`.

**3. Your turn: three prompts, one at a time.** Give each in its own code block, with the procedure and the file you found filled in. Keep each prompt to five lines at most: the user types or pastes it, and the details are theirs to add. Tell the user to wait for each to finish, and that Claude Code asks before writing under `.claude/`: approve it.

Skill:
```
Create a project skill in .claude/skills/ for <the procedure>: the steps
we follow here and how to know it's done. Write its description with the
words I'd actually type to ask for this. Then point to it from CLAUDE.md.
```

Tool:
```
Write a script in tools/ that does <the exact step>, so that part comes out
the same every time. If it creates a test, the placeholder must fail until
someone writes the real one. Run it once to prove it works, then make the
skill call it.
```

Hook:
```
Add a PreToolUse hook in .claude/settings.json that refuses Edit and Write
on <the protected file>, and says why. Prove it by piping a fake edit into
the hook command.
```

Then close with these bullets as written, with no lead-in line and nothing added:
- Read each file before accepting it. The description decides whether the skill ever loads, so check it uses your words.
- The tool's proof run creates a real module. Use one you need next (from your task list), or delete the files after.
- When all three are done, run `/cordada:gear` again to check them.

Stop there.

## Check mode

First line of the reply, as is: "Found the <name> skill, so I'm checking the gear. For the guide instead: `/cordada:gear guide`."

Read the skill, `tools/`, `.claude/settings.json` and `CLAUDE.md`. Show this table, one row per criterion: ✅, ❌ or ⚠️ (unsure), with the evidence.

| # | Criterion | How to check |
|---|---|---|
| 1 | The skill is in the repo | `.claude/skills/<name>/SKILL.md`, so it is versioned and the team gets it |
| 2 | Its description uses the words people type | Phrases like "add the X module", plus when not to use it. A bare name or a summary is ❌ |
| 3 | It ends on a check | A "done when" that can pass or fail ("the tests pass"), not a feeling |
| 4 | The map points to it | A line in `CLAUDE.md` naming the skill and when to use it. A skill that never loads does nothing |
| 5 | A tool does the exact step | A script in `tools/` that the skill calls by name. Run it with no arguments or `--help`: it should explain itself, not crash or write files |
| 6 | A scaffolded test fails until written | If the tool creates a test, its placeholder fails. A passing placeholder makes `./check` lie at level 4 |
| 7 | A hook guards the protected file | `.claude/settings.json` has a PreToolUse hook on Edit and Write. Pipe it a fake edit of the protected file and expect it refused, without touching the file |
| 8 | The rule is also in the map | The protected file and its reason are in the "Do not" of `CLAUDE.md`. The hook stops the edit tools, not a `sed` in Bash |

To test the hook (row 7), read the command in `.claude/settings.json` and pipe it the JSON a real edit sends, for example:

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"'"$PWD"'/<protected file>"}}' | CLAUDE_PROJECT_DIR="$PWD" <hook command>; echo "exit=$?"
```

Refused means exit 2, or a JSON reply with `"permissionDecision": "deny"`.

Then:
- For each ❌ or ⚠️, one fix, as a prompt to type. Don't make the change.
- **The proof:** `/clear`, then ask for the procedure in plain words (for example "add the money module from the TODO"). The skill should load, and the tool should run. If the skill does not load, its description is the bug.
- All ✅: level 3 is done. Commit it (`git add -A && git commit -m "gear"`). Next: `/cordada:checks`.
