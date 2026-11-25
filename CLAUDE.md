# Cordada: instructions for agents

Cordada is a Claude Code plugin that takes a repo up five levels of AI engineering, one skill per level: Brief, Map, Gear, Checks, Rope. It is also the material for a 90-minute workshop. Start from `README.md`.

## Commands
- Validate the plugin: `claude plugin validate plugins/cordada` (a few seconds).
- Try a change on the sample: `sample/create.sh /tmp/vaquita && cd /tmp/vaquita && claude --plugin-dir <repo>/plugins/cordada`.
- Where a repo stands: `plugins/cordada/scripts/route` (read-only, run inside any git repo).
- Check the attendee's machine: `./preflight.sh` (read-only).

## Layout
- `plugins/cordada/skills/<level>/SKILL.md`: one skill per level, plus `route` and `climb`. Assets a skill copies into a repo live in that skill's `assets/`.
- `plugins/cordada/agents/climber.md`: the worker that `climb` sends out.
- `sample/template/`: the practice repo. Its failing tests and markdown TODO are deliberate. Don't fix them here.
- `workshop/`: the route card and the prerequisites for attendees. `*.es.*` files are the Spanish versions.

## Conventions
- Level skills are guides, not doers: explain the level, say what this repo is missing, give the prompt to ask Claude, then check the result against a criteria table shown to the user. The mode comes from what is on disk, and the first line says which. They write nothing themselves. `route` is read-only; `climb` is the one doer.
- Every skill checks the levels below it first and says what is missing. That is the point of the project: no shortcuts.
- Skills must work on any repo, not only the sample. Examples from the sample are marked as examples.
- A skill never commits, pushes or deletes the user's work. The one exception is `bd init`, which commits `.beads/` itself, and the skill says so.
- Test a skill change in a fresh session on a fresh sample, headless is fine: `claude -p "/cordada:<skill>" --plugin-dir plugins/cordada --permission-mode acceptEdits --allowedTools "Bash Read Edit Write Glob Grep Skill Agent"`. Writes under `.claude/` always need a person's approval, so in a headless run gear stops at that point: build the level-3 files by hand or run gear interactively.
- Docs: short sentences, plain words, bullets, no em dashes.
- Measured numbers are reported straight, including where the simple path wins.

## Do not
- Put anything from a company's internal systems in this repo: case numbers, customer names, internal hosts or URLs.
- Edit the English docs when only the Spanish ones need a change, or the reverse. Both are kept.

## Decisions
Record decisions and their why in `docs/decisions.md`. Read it before changing an approach.
