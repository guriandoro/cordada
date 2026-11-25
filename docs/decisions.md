# Decisions

Append-only. One entry per decision that someone might later want to undo.

## 2026-11-19: One skill per level, shipped as a plugin
**Context:** each level has to reach an attendee's own repo, and people fall behind during a workshop.
**Decision:** one skill per level in a Claude Code plugin. Each skill installs its level into the repo you are in and checks the levels below first.
**Why:** git tags per level were simpler, but catching up by checking out a tag replaces the attendee's own work. Skills also work on a real repo the next Monday.

## 2026-11-19: Teach by example, report measurements straight
**Context:** a test showed one bare prompt building the whole sample in about a minute, faster and cheaper than the five levels.
**Decision:** no staged failure in the workshop. Build each level in front of the room. Keep the measured comparison as a pros and cons slide, including where the bare prompt wins.
**Why:** the sample is a toy, and the claim is about long-lived projects. People should learn, not watch a point being proven.

## 2026-11-19: Only the lead writes to the task list
**Context:** in a rope team, several agents work at once.
**Decision:** climbers never claim or close tasks. The lead claims, merges, runs `./check` on the merged tree, then closes.
**Why:** a climber's "done" is a claim. Two branches that each pass can fail together.

## 2026-11-24: Skills guide and check, they don't do the work
**Context:** the skills wrote each level's files in the background. Attendees learned to repeat commands, not to climb.
**Decision:** each level's skill explains the level, says what is missing in this repo, gives the prompt to ask Claude, and checks the result against a criteria list it shows. It picks guide or check from what is on disk and says which. It writes nothing unless asked. `climb` stays a doer, shown by the speaker.
**Why:** people should be able to do every level without the plugin. Visible criteria double as the route card.

## 2026-11-24: The sample is vaquita, a shared-expense splitter
**Context:** the hike planner's bug (longitude in radians) needed explaining before it taught anything.
**Decision:** the sample splits an asado's expenses and says who pays whom. Its bug: the shares don't add up to the total.
**Why:** everyone has split a bill. The bug is obvious on sight, and "money is integer cents" is a real rule with a reason for the map.

## 2026-11-24: The climb stops after five rounds and asks
**Context:** a climb drains the ready queue round by round, and climbers file new work as they find it.
**Decision:** stop when the queue is empty, a task failed twice, or five rounds have run. At five, say what is left and ask before continuing.
**Why:** a human checkpoint between batches of agent changes, a cap on work nobody asked for, and a bound on cost and time. Five is a judgment call, enough for a small queue; tune it on a real project. The level-5 sample is wired to drain in five.
