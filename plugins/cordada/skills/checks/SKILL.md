---
name: checks
description: Level 4 of Cordada, as a guide. With no ./check in the repo, it explains loops and checks, says what "good" means here and what fails today, and gives the prompts to ask Claude for ./check and a definition of done, then to loop until it passes. With a ./check, it checks the script, the definition of done and that no test was weakened, and says what to fix. It writes nothing itself. Use when someone says "cordada checks", "set up a definition of done", "let it run until the tests pass", "make the agent verify its own work", "check my ./check", or when the agent reports work as finished that is not. Needs levels 2 and 3 first.
argument-hint: "[guide]"
---

# checks

Level 4 of the climb. You are a guide here, not the one doing the work. The user builds the check with Claude, in their own words, so they can do it again on any repo without this plugin.

**Don't create or edit any file during this skill.** Read, run read-only commands, explain, and check. Running the tests and `./check` is fine. When the user types a prompt you give them, that is a new request of theirs: follow it normally then.

## 0. Check the levels below, then pick the mode

No `CLAUDE.md`? Stop: "Checks builds on the map, and this repo has none. Run `/cordada:map` first." No `.claude/skills/*/SKILL.md`? Say in one line that level 3 is missing and `/cordada:gear` adds it, then go on: checks doesn't depend on it.

Your reply always starts with the mode line, word for word, before anything else:

- Argument is `guide`, or no `check` file at the repo root: **guide mode**. "No ./check yet, so this is the guide." (or "Guide mode, as asked.")
- `./check` exists: **check mode**. "Found ./check, so I'm checking it. For the guide instead: `/cordada:checks guide`."

## Guide mode

**1. Why, in four short lines.** Say it in your words:
- A loop is a goal plus a check the agent can run by itself. Without the check it stops after one try, and you are the only verifier.
- One command, `./check`, in every repo: exit 0 means good. No agent has to guess what "done" means here.
- The check has to be guarded too: an agent told only "make it pass" will sometimes edit the test.
- Level 5 (Rope) needs it: whoever merges the agents' work runs `./check` before closing a task.

**2. Look at the repo, read-only, a minute at most.** `CLAUDE.md`, CI config, linter or type checker config, the project skill's "done when". Run the test command once. Report, naming the file where you saw it:
- **What "good" means here:** the test command, and any linter, type checker or build that is already configured. Only what a command can decide. A linter nobody configured is not a check.
- **What fails today:** the failing tests, by name and file, and nothing more. Don't say why they fail or where the bug is: finding the cause is the loop's job, and a hint here would do part of it.

**3. Your turn: two steps.** Give each prompt in its own code block, filled in with what you found, five lines at most.

The check and the definition of done:
```
Write ./check: an executable script at the repo root that runs <the tests>
and <other checks, if any>, keeps going after a failure, and ends with
CHECK PASSED or CHECK FAILED. Run it once. Then add "Done means" to CLAUDE.md:
./check passes, and never weaken a check or a test to make it pass.
```

Commit first (`git add -A && git commit -m "checks"`), so you can see exactly what the loop changes and undo it. Then the loop:
```
/goal ./check prints CHECK PASSED and no test was deleted, skipped or changed; or stop after 15 turns
```

Then close with these bullets as written, with no lead-in line and nothing added:
- `./check` should fail the first time. That is fine: a failing check is the first goal.
- The goal is judged from the conversation, so the agent has to run `./check` and show it. If your version has no `/goal`, type: "Fix what ./check reports. Run it after each change until it passes. Don't touch the tests."
- When it passes, run `/cordada:checks` again to check the work.

Stop there.

## Check mode

First line of the reply, as is: "Found ./check, so I'm checking it. For the guide instead: `/cordada:checks guide`."

Read `./check`, `CLAUDE.md` and the project skill. Run `./check` once and time it.

For row 7, first find where this repo's tests live: a folder (`tests/`, `test/`, `spec/`) or files next to the code (`*_test.go`, `test_*.py`, `*_test.py`, `*.test.ts`, `*.spec.js`, ...). Build the list of paths with `git ls-files`, and say which pattern you used. Then look at what changed in those paths since just before `./check` was added: `git log --oneline -- <paths>` and `git diff <first commit that has ./check>~1 -- <paths>` (or against the working tree if nothing is committed). Look for deleted tests, skips added (`t.Skip`, `@skip`, `.skip(`, `xit(`, ...) and changed expected values. If you can't tell where the tests are, row 7 is ⚠️, not ✅.

Show this table, one row per criterion: ✅, ❌ or ⚠️ (unsure), with the evidence.

| # | Criterion | How to check |
|---|---|---|
| 1 | One command at the root | `./check` exists and is executable |
| 2 | It runs what "good" means here | The test command from `CLAUDE.md`, plus every linter or build already configured. Nothing invented |
| 3 | One run shows everything | It keeps going after a failed step, and ends with `CHECK PASSED` or `CHECK FAILED` that matches its exit code |
| 4 | Fast enough to run every time | Under a minute. Slower: split the slow part into `./check --full` |
| 5 | The map names it | `CLAUDE.md` says done means `./check` passes, run before saying a task is finished |
| 6 | The map guards it | `CLAUDE.md` says never to weaken a check or a test to make it pass |
| 7 | No test was weakened | No test deleted, skipped or with a changed expected value since level 3. New tests are fine |
| 8 | It passes now | `CHECK PASSED`. If not, the loop is the next step, not a failure of this level |
| 9 | Gear points to it (nice to have) | The project skill's "done when" is `./check` |

Then:
- For each ❌ or ⚠️, one fix, as a prompt to type. Row 8 failing: give the `/goal` line from the guide. Don't make the change.
- Rows 1 to 7 ✅: level 4 is done. Commit what is left (`git add -A && git commit -m "checks"`). Next: `/cordada:rope`.
- One line, optional for later: a Stop hook can refuse to end a turn that changed files while `./check` fails. Ask Claude for it when the check is fast and you want it enforced, not just written down.
