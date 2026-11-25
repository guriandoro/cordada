# Cordada route card

Each level leaves one thing in your repo. The next level needs it. Each skill guides you (what is missing, the prompt to type) and then checks what you built. It never writes the files: you can do every level without the plugin.

| Level | Ask yourself | Proof you are there | Skill | On Monday, in your own repo |
|---|---|---|---|---|
| 1. Prompt | Does your ask have a goal, the limits, a check for "done", and where to stop? | Nothing in the repo. Your asks pass the four parts. | `/cordada:brief <your prompt>` | Check your next ask before you send it. Fix the gaps in your own words. |
| 2. Context | Does a fresh session know how to test and what not to touch, without you telling it? | `CLAUDE.md` (under 60 lines), every "don't" with its reason | `/cordada:map` | Ask Claude for a `CLAUDE.md`: how to test, what not to touch and why, the rules a reviewer enforces. Then `/clear` and ask "how do I run the tests, and what must I not touch?" |
| 3. Harness | Is there a procedure you no longer explain, and a file the agent cannot edit by mistake? | A skill in `.claude/skills/` the map points to, a script in `tools/`, a guard hook | `/cordada:gear` | Take the procedure you explained three times this month. Ask for a skill, a script for its exact step, and a hook for the file to protect. Try the skill after `/clear`. |
| 4. Loop | Can the agent tell by itself whether its work is done? | `./check` (exit 0 = good) and a "Done means" in `CLAUDE.md` that forbids weakening it | `/cordada:checks` | Ask for `./check`. Commit. Then `/goal ./check prints CHECK PASSED and no test was deleted, skipped or changed; or stop after 15 turns` |
| 5. Graph | Can several agents take work from one queue without you handing it out? | A local beads database with dependencies; `bd ready` lists what can start | `/cordada:rope`, then `/cordada:climb` | `bd init`, write two tasks as briefs, `bd dep add`, then ask Claude to move the rest. Commit. Watch `/cordada:climb 2` once before trusting it. |

## Find your level

- Your level is the highest one with **no gap below it**. A `./check` without a `CLAUDE.md` is still level 1.
- Name the artifact you are missing. Add that one first. No shortcuts.
- Ask the repo, read-only:

```
/cordada:route
```

It lists what the repo has, and prints "You are at level N. Next: /cordada:<skill>".

Run a level's skill once to be guided, and again when you are done to be checked. `/cordada:<skill> guide` forces the guide.

Load the plugin: `/plugin marketplace add guriandoro/cordada` then `/plugin install cordada@cordada`, or from a clone `claude --plugin-dir cordada/plugins/cordada`.

Commit after each level and `/clear` before the next. Behind on the sample? `cordada/sample/create.sh vaquita-3 --level 3` (2 to 5). Repo: `https://github.com/guriandoro/cordada`
