---
name: route
description: Show which Cordada levels this repo has (Map, Gear, Checks, Rope) and which one to add next. Use when someone asks "what level is this repo", "where am I on the mountain", "what's my next Cordada level", "cordada status", or before running any other Cordada skill. Read-only.
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/route:*)
---

# route

Run the bundled script and paste its full output into your reply, table included, exactly as printed:

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/route"
```

Then add at most three lines:

- What the next level gives them, in one sentence.
- If the script printed a "Note:" about a gap, say plainly that the levels above the gap will not work well until the gap is filled, and name the skill that fills it.
- Nothing else. Don't start the next level unless asked.

The levels, for reference:

| Level | Artifact | Skill | What it leaves in the repo |
|---|---|---|---|
| 1 Prompt | Brief | `/cordada:brief` | Nothing. A habit: goal, constraints, done |
| 2 Context | Map | `/cordada:map` | `CLAUDE.md`, `docs/decisions.md` |
| 3 Harness | Gear | `/cordada:gear` | A project skill, a tool script, a guard hook |
| 4 Loop | Checks | `/cordada:checks` | `./check` and a definition of done |
| 5 Graph | Rope | `/cordada:rope`, then `/cordada:climb` | A task database with dependencies |
