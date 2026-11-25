---
name: rope
description: Level 5 of Cordada, as a guide. With no task database in the repo, it explains why several agents need a shared queue, reads the markdown TODO for what depends on what, and walks the user through beads by hand - init, writing tasks as briefs, wiring dependencies - then gives the prompt to move the rest. With a beads database, it checks the tasks, the dependencies and the rules in CLAUDE.md, and says what to fix. It writes nothing itself. Use when someone says "cordada rope", "set up beads", "set up tasks for agents", "migrate my TODO to beads", "check my task list", "I want to run several agents on this repo". Needs levels 2 to 4 first. Running the agents is the climb skill.
argument-hint: "[guide]"
---

# rope

Level 5 of the climb, the setup half. You are a guide here, not the one doing the work. The user runs `bd` with their own hands, because seeing the queue form is the lesson, and then asks Claude for the rest in their own words.

**Don't create or edit any file, and don't run any `bd` command that writes, during this skill.** Read-only `bd` commands (`bd where`, `bd list`, `bd show`, `bd ready`, `bd blocked`, `bd dep tree`, `bd dolt remote list`) are fine. When the user types a command or prompt you give them, that is theirs: follow it normally then.

## 0. Check the levels below, then pick the mode

Needs `./check` and a `CLAUDE.md` that names it. If either is missing, stop and say why it matters here, then offer the skill:
- No map: every agent starts from zero, all at once.
- No check: nobody can tell whether a task an agent closed is done. With several agents, that is the main way things go wrong.

Then `command -v bd`. Missing: stop and give the install line (`brew install beads` on macOS; other platforms: https://github.com/steveyegge/beads). Don't install anything yourself.

Your reply always starts with the mode line, word for word, before anything else:

- Argument is `guide`, or no `.beads/` in the repo: **guide mode**. "No task database yet, so this is the guide." (or "Guide mode, as asked.")
- `.beads/` exists: **check mode**. "Found a beads database, so I'm checking the rope. For the guide instead: `/cordada:rope guide`."

## Guide mode

**1. Why, in four short lines.** Say it in your words:
- Several agents can only work at once if one shared list answers, without you: what is ready, what is taken, what unblocks what.
- A markdown TODO answers none of that once two agents edit it. GitHub issues work when people share the queue. beads (`bd`) is made for local agents: dependencies, a ready queue, claims.
- Each task is a brief (level 1 again): goal, files it touches, done when. The agent that picks it up has nobody to ask.
- The rest of the rope is a lead that hands out ready tasks and runs `./check` before closing each one. That is `/cordada:climb`.

**2. Look at the repo, read-only, a minute at most.** The markdown TODO (or wherever open work lives), `CLAUDE.md`, `git remote -v`. Report:
- **Open items:** how many, and which are already done (those don't move).
- **What needs what:** the dependencies you can read from the items ("needs everything else first", one module reading another's output).
- **Collisions:** two items that would edit the same file. They can't run in the same round.
- **A git remote**, if there is one: the database must stay local (see step 3).

**3. Your turn: three steps.** Shell commands are given without the leading `!`, each alone in its own code block, on one line, complete and ready to paste. Tell the user once: "Type `!` first (the prompt switches to shell mode), then paste the line and press Enter." Never put `...` or `<...>` in a command: the only fill-ins allowed are ids that only exist after an earlier command, written in capitals (`EXPENSES_ID`), with one line saying where to copy them from.

Step A, the database, with a short prefix from the repo name:
```
bd init -p <prefix> --non-interactive --skip-agents --skip-hooks
```
(Fill in the prefix yourself before showing it.) Say why the flags: `--skip-agents` and `--skip-hooks` stop beads from writing its own agent instructions and git hooks, because the map is already the one place for instructions. `bd init` makes a commit of its own for `.beads/`. If the repo has a git remote, add three more commands, one block each, so task data never gets pushed: `bd dolt remote remove origin`, `bd config set dolt.local-only true`, `bd config set backup.enabled false`.

Step B, two tasks and one dependency. Pick two open items where the second needs the first. Write both as complete briefs with this repo's values: goal, files it touches, and a done-when that names `./check` plus one thing to observe. Say the user may change the wording before sending: it is their plan. Then, one block each:

```
bd create "<first item>" -p 1 -d "Goal: <goal>. Files: <files>." --acceptance "./check passes, and <observable>"
```
```
bd create "<second item>" -p 2 -d "Goal: <goal>. Files: <files>." --acceptance "./check passes, and <observable>"
```
```
bd dep add SECOND_ID FIRST_ID -t blocks
```
```
bd ready
```
(Fill in every `<...>` yourself, and name the two ids after the items, for example `BALANCES_ID` and `EXPENSES_ID`.) Say: each `bd create` prints the new task's id, like `vaq-6ye`; put those in the `bd dep add` line. `bd dep add A B -t blocks` means A needs B first; it confirms with "A depends on B (blocks)". `bd ready` should list the first task and not the second, and `bd blocked` shows why.

Step C, the rest, a prompt for Claude (five lines at most):
```
Move the other open items of TODO.md into beads, written like mine: goal,
files, and done-when with ./check. Wire what needs what with bd dep add.
Replace TODO.md with one line saying tasks live in beads. Add a Tasks section
to CLAUDE.md: bd ready to find work, close only after ./check passes. Fix any
skill or line that still says to edit TODO.md.
```

Then close with these bullets as written, with no lead-in line and nothing added:
- Read `bd ready` and `bd blocked` when it is done. The graph is the plan, and it is yours: fix a wrong dependency with `bd dep remove`.
- Numbers in a "done when" must come from the TODO or from arithmetic you can check. A wrong expected value stops the agent that picks it up.
- When it's done, run `/cordada:rope` again to check it.

Stop there.

## Check mode

First line of the reply, as is: "Found a beads database, so I'm checking the rope. For the guide instead: `/cordada:rope guide`."

Run `bd where`, `bd list -n 0`, `bd ready`, `bd blocked`, `bd show` on at least three tasks, `bd dolt remote list`. Read `CLAUDE.md` and the TODO file if it still exists. Show this table, one row per criterion: ✅, ❌ or ⚠️ (unsure), with the evidence.

| # | Criterion | How to check |
|---|---|---|
| 1 | The database is this repo's | `bd where` points inside this repo |
| 2 | It stays local | `bd dolt remote list` lists nothing |
| 3 | One source of truth | Every open TODO item is a task, and the markdown no longer lists work to do (gone, a pointer, or generated) |
| 4 | Each task is a brief | Goal, files it touches, and a done-when that names `./check` plus something specific to observe |
| 5 | The order is wired | `bd blocked` shows what needs what. Nothing in `bd ready` needs an unfinished task |
| 6 | Ready tasks don't collide | No two ready tasks name the same file |
| 7 | No invented numbers | Every expected value in a done-when comes from the TODO or from arithmetic shown in the task |
| 8 | The map names it | `CLAUDE.md` says tasks live in beads, `bd ready` to find work, close only after `./check` passes |

Then:
- For each ❌ or ⚠️, one fix, as a prompt to type or a complete shell command. Shell commands follow the same rule as the guide: no leading `!`, one per code block, ready to paste, and the line "Type `!` first, then paste" once. Don't make the change.
- All ✅: level 5 is set up. Commit it, in its own code block: `git add -A && git commit -m "rope"`.
- Next: `/cordada:climb` sends a rope team of agents over the ready queue. It needs a clean tree, and it is worth watching once before trusting it with real work.
