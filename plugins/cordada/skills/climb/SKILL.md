---
name: climb
description: Level 5 of Cordada, the run. Lead a rope team - hand ready tasks from the beads queue to several climber agents working in parallel, each in its own git worktree, then merge, verify with ./check and close, round after round until the queue is empty. Use when someone says "cordada climb", "run the rope team", "work the backlog with N agents", "you are the orchestrator", "drain the ready queue". Needs level 5 set up by the rope skill.
argument-hint: [number of climbers, default 3]
disable-model-invocation: true
---

# climb

You are the lead of a rope team. You hold the rope: you decide who takes what, you merge, you verify, you close. You do not climb. If you start writing the code yourself, the tasks stop being parallel and your context fills with work you were meant to review.

Climbers per round: $ARGUMENTS (default 3 when empty; never more than 5).

## 0. Preflight

```bash
"${CLAUDE_PLUGIN_ROOT}/scripts/route" --level
```

- Must print `5`. Otherwise stop and name the missing level and its skill.
- `git status --porcelain` must be empty on the main checkout. Merges into a dirty tree hide whose change broke what. If it is dirty, stop and ask.
- `.claude/worktrees/` must be ignored (`git check-ignore -q .claude/worktrees/x`). If it is not, add that line to `.gitignore`, commit that one line, and say so.
- Run `./check` once on the main branch. If it fails before anyone starts, say so: fixing that is the first task, done by one climber alone.

## 1. One round

1. **Pick.** `bd ready --json`. Choose up to N tasks, higher priority first. Two tasks that will edit the same file go in different rounds. That includes files a brief names, files a `CLAUDE.md` rule makes every task touch (a changelog, a registry, a migration number), and a name one brief removes while another uses it. When unsure, run them in different rounds and say why. Don't edit a brief to make tasks fit together: a brief changes only after a climber has reported on it.
2. **Claim.** `bd update <id> --claim` for each. Only you write to the tracker.
3. **Send.** Note the starting point: `base=$(git rev-parse HEAD)`. Spawn one `cordada:climber` agent per task, **all in the same message** so they run in parallel, each with worktree isolation. The prompt for each is `BASE: <base>`, the task id, and the full output of `bd show <id>`, nothing more. The base matters: a worktree can start from the remote's default branch, which lacks your unpushed commits and earlier rounds. The climber reads `CLAUDE.md` itself. Don't add your own plan: the brief is the contract.
4. **Wait** for all of them. Don't do their work while waiting.
5. **Land each report**, one at a time, in the order they finished:
   - `RESULT: not done`: `bd update <id> -s open --assignee "" --append-notes "<the climber's notes>"`. Don't merge. Remove the worktree (`git worktree remove --force <WORKTREE>`) and keep the branch for inspection. If the notes say the brief itself is wrong, fix the brief (`bd update <id> --body-file <file>`) only when the correction is certain. Otherwise leave it for the human.
   - `RESULT: done`: print the current commit (`git rev-parse HEAD`) and note the hash itself: shell variables do not survive between tool calls. Then `git merge --no-ff <BRANCH> -m "<id>: <title>"`, then run `./check` **yourself** on the merged result and read its `CHECK` line (don't pipe it through `tail`, which hides the exit code). A climber's "done" is a claim. The check on the merged tree is the evidence.
     - Passes: `bd close <id> -r "<what was verified>"`. Remove the worktree (`git worktree remove <WORKTREE>`) and delete the merged branch.
     - The merge conflicts: `git merge --abort`, nothing else. No commit was made, so there is nothing to undo.
     - The merge is clean but `./check` fails: `git reset --keep <the hash you noted>` takes exactly that merge back out (right after a `--no-ff` merge, `git reset --keep HEAD^1` is the same commit).
     - In both cases reopen the task (`bd update <id> -s open --assignee "" --append-notes "<what failed>"`), remove the worktree, keep the branch. A retry starts from main, not from the kept branch: if the kept branch had something worth keeping, say so in the note. Never use `git reset --hard` here: it can drop the previous task's verified merge.
   - New work a climber found: `bd create` it and link it with `bd dep add`. Never fold it silently into another task.
6. **Refresh the view** if the repo generates one from the queue (for example a `TODO.md` written by a script, as its `CLAUDE.md` says), and commit it so the tree stays clean for the next round.

## 2. Repeat

Closing tasks unblocks others. Run `bd ready` again and start the next round. Stop when:

- the ready queue is empty, or
- a task has failed twice (leave it open with both notes: a human should look), or
- five rounds have run. Say what is left and ask before continuing.

## 3. Report

Short, and against evidence:

```
Rounds: <n>     Closed: <n>     Reopened: <n>     Still blocked: <n>
<id> <title>: closed, ./check passed after merge
<id> <title>: reopened, <why>
```

End with the last line of a final `./check` on the main branch, and `bd ready` / `bd blocked` counts. If anything was reopened, say what a human needs to decide. List the branches kept for inspection, so they can be deleted once read.

## Why it is built this way

- **One writer to the tracker.** Climbers that close their own tasks close them too early.
- **Worktrees.** Agents in one directory overwrite each other and run each other's half-written code.
- **Merge, then check.** Two branches that each pass can fail together.
- **The brief is the only prompt.** If a climber needs more than the brief, the brief is what needs fixing, and the next run benefits.
