
## Done means
- `./check` passes. Run it before saying a task is finished and show its last line.
- Never make `./check` pass by weakening it: no deleted, skipped or loosened tests. If a check is wrong, stop and say so.
- New behaviour comes with a test that fails without it.
