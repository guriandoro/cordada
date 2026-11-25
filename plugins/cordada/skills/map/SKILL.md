---
name: map
description: Level 2 of Cordada, as a guide. With no CLAUDE.md in the repo, it explains what a map is for, says what this repo is missing, and gives the prompt to ask Claude for one. With a CLAUDE.md, it checks it against the level's criteria and says what to fix. It writes nothing itself. Use when someone says "cordada map", "set up CLAUDE.md", "give Claude context on this repo", "check my CLAUDE.md", or when a repo has no CLAUDE.md or one that is stale or bloated. Not for documenting the code for humans (that is the README).
argument-hint: "[guide]"
---

# map

Level 2 of the climb. You are a guide here, not the one doing the work. The user builds the map with Claude, in their own words, so they can do it again on any repo without this plugin.

**Don't create or edit any file during this skill.** Read, run read-only commands, explain, and check. When the user types the prompt you give them, that is a new request of theirs: follow it normally then.

## 0. Pick the mode, and say it

Your reply always starts with the mode line below, before anything else. The user needs to know what the skill decided.

Look for `CLAUDE.md` at the root, then `.claude/CLAUDE.md`.

- Argument is `guide`, or no `CLAUDE.md` found: **guide mode**. First line: "No CLAUDE.md yet, so this is the guide." (or "Guide mode, as asked.")
- `CLAUDE.md` found: **check mode**. First line: "Found CLAUDE.md (<N> lines), so I'm checking it. For the guide instead: `/cordada:map guide`."

## Guide mode

**1. Why, in three short lines.** Say it in your words:
- Every session starts from zero. Without a map you explain how to test, what not to touch and the house rules again, each time.
- Level 3 (Gear) builds on it: skills and hooks point back to the map.
- What belongs: facts that change what the agent does. If removing a line would change nothing, the line goes.

**2. Look at the repo, read-only, a minute at most.** README, manifest (`pyproject.toml`, `package.json`, `Makefile`, ...), CI config, the tests folder, notes like `TODO.md`, `git log --oneline -10`, and `AGENTS.md` if there is one. Then report two short lists, up to five items each, naming the file where you saw it:
- **An agent can work this out alone:** for example the test command in the README.
- **An agent can't know unless someone writes it down:** what must not be touched and why, the conventions a reviewer enforces, rules hidden in notes (for example a "don't touch X" line inside a TODO list), what the project is for.

**3. Your turn.** Give the prompt in a code block. Keep it short: add at most one line naming the hidden rules you saw, so the user remembers to confirm them.

```
Write a CLAUDE.md for this repo, under 40 lines: what it is and for whom,
how to run the tests, what must never be touched and why, and the
conventions a reviewer here enforces, each with its reason.
Ask me whatever you can't find in the repo. No current bugs or to-dos in it.
```

Then close with these bullets as written, with no lead-in line and nothing added:
- Use your own words if you like. Answer its questions: you know the project, it doesn't.
- Read the file before accepting it. A guess written as a rule misleads every later session.
- Optional, if there is time: "Start `docs/decisions.md` with one entry per decision someone might later want to undo: context, decision, why. Point to it from CLAUDE.md."
- When it's done, run `/cordada:map` again to check it.

Stop there.

**Empty repo** (no code, no README): skip step 2. Change the prompt to "Interview me, then write a short CLAUDE.md: what this will be and for whom, the stack, how I'll know a change is good, what's off limits." Say the map will be thin, and to come back after the first real work.

## Check mode

Read the file and the repo, then show this table, one row per criterion: ✅, ❌ or ⚠️ (unsure), with the line or the missing piece as evidence.

| # | Criterion | How to check |
|---|---|---|
| 1 | Says what the project is and for whom | One or two sentences near the top |
| 2 | Has the test command, and it runs | Run it once. Failing tests are fine, a command that does not run is not. Note how long it took |
| 3 | Every "don't" has its reason | "Don't edit X" alone is ❌. "Don't edit X: Y imports it by name" is ✅ |
| 4 | Conventions are this repo's rules | Rules a reviewer here enforces. Generic advice ("write clean code") is ❌ |
| 5 | No state | No current bugs, failing tests, to-dos or history. They are stale within the hour |
| 6 | No guesses passed off as rules | A rule that nothing in the repo supports gets ⚠️: "Did you tell it this, or did it guess?" |
| 7 | Short | Under 60 lines, and each line would change what an agent does |
| 8 | Decisions log (nice to have) | `docs/decisions.md` exists and the map points to it |

Then:
- For each ❌ or ⚠️, one fix, as a prompt to type or a line to change. Don't make the change.
- **The proof:** `/clear`, then ask "how do I run the tests, and what must I not touch?" It should answer from the map without opening other files. The `/clear` matters: this session already knows the repo.
- All of 1 to 7 ✅: level 2 is done. Commit it (`git add -A && git commit -m "map"`). Next: `/cordada:gear`.
