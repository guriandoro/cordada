---
name: brief
description: Level 1 of Cordada, as a guide. With no argument, it explains what a brief is (goal, constraints, done when, out of scope), shows a weak and a strong ask using this repo, and asks the user to write their own. With a prompt as the argument, it checks that prompt against the four parts and says what is missing, without rewriting it. It writes nothing and does not start the work. Use when someone says "cordada brief", "check my prompt", "is this prompt clear enough", "how do I write a good task for an agent", or pastes a rough ask and wants feedback before work starts.
argument-hint: "[the prompt you want checked]"
---

# brief

Level 1 of the climb. You are a guide here, not the one doing the work. The user writes the brief in their own words, so the habit stays with them on any repo, without this plugin.

**The first line of every reply is the mode line from step 0, even when the prompt is already good.**

**Don't create or edit any file, don't rewrite the user's prompt for them, and don't start the work.** Read, explain, and check. When the user sends their improved prompt as a normal message, that is a new request of theirs: follow it normally then.

The argument: $ARGUMENTS

## 0. Pick the mode, and say it

Level 1 leaves no file, so the mode comes from the argument. Your reply always starts with the mode line, word for word, before anything else:

- No argument, or the argument is `guide`: **guide mode**. "No prompt to check, so this is the guide."
- Anything else: **check mode**. "Checking your prompt against the four parts of a brief."

## Guide mode

**1. Why, in three short lines.** Say it in your words:
- The agent does what you ask, not what you meant. Whatever you leave out, it guesses.
- A brief has four parts: **goal** (the outcome, not the activity), **constraints** (what must not change), **done when** (a check someone can run), **out of scope** (the nearest thing you are not asking for).
- The same shape comes back at level 5 as every task description in the queue, read by an agent with nobody to ask.

**2. Look at the repo, read-only, a minute at most.** README, `TODO.md` or wherever open work lives, the tests. Pick one real open item.

**3. Show a weak and a strong ask for that item.** Two short code blocks. The weak one is how people usually type it (for example "add balances"). The strong one has the four parts in plain sentences, five lines at most, with a done-when that names a command and what to see. Under them, one line per part saying what the weak one left the agent to guess.

**4. Your turn.** Close with these bullets as written, with no lead-in line and nothing added:
- Pick something you would ask an agent for today, here or in your own repo, and write it the way you normally would.
- Run `/cordada:brief <your prompt>` to check it. You'll get what is missing, not a rewrite: the fix is yours.
- Good enough? Send it as a normal message, and the work starts.

Stop there.

## Check mode

Your reply begins exactly like this, mode line first, then the table:

```
Checking your prompt against the four parts of a brief.

| # | Part | | Evidence |
```

Read the files the prompt points to, so you judge it against the real repo. Any number you cite from a file (rows, people, totals) you count with a command first: a wrong fact in a check teaches the opposite of the level. Then show this table, one row per part: ✅, ❌ or ⚠️ (vague), with the words from the prompt as evidence, or what is missing.

A part can be carried by the repo instead of the prompt: rules in `CLAUDE.md`, a "Done means" with `./check`, a project skill for the procedure, a task in the queue (`bd show`) with its own goal and scope. Look for those first. When the repo carries a part, mark it ✅ and name the file or task that carries it. The prompt only needs what the repo does not already say.

| # | Part | ✅ when |
|---|---|---|
| 1 | Goal | It names an outcome someone can see ("the shares add up to the total"), not just an activity ("look at split.py") |
| 2 | Constraints | It says what must not change, where that matters here (tests, a public interface, a protected file). If the map already covers it, ✅ and say so |
| 3 | Done when | A check someone can run or observe: a command and its expected result. "Works correctly" is ❌. If the repo has `./check`, it should name it |
| 4 | Out of scope | It names the nearest thing not being asked for, when there is an obvious one. A small, clear ask may not need it: then ✅ and say why |

Then:
- For each ❌ or ⚠️, one question that would fill it, in the user's terms ("How will you know the shares are right? Which command?"). Don't write the answer for them.
- One line on what the agent would probably have guessed for the biggest gap, so the risk is concrete.
- Close: "Fix it in your words, run `/cordada:brief` on it again if you like, then send it as a normal message." Next level, if the repo has no `CLAUDE.md`: `/cordada:map`.
