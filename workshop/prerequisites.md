# Before the workshop (Thursday 2026-11-26, 90 minutes)

**Bring:** a laptop (macOS or Linux; on Windows, use WSL) and your own Claude Code account. We don't provide accounts.

**Install:**
- git and Python 3.9 or later.
- Claude Code (https://code.claude.com/docs). Start `claude` once and sign in.
- Optional, for level 5: beads (`bd`). macOS: `brew install beads`. Other platforms: https://github.com/steveyegge/beads

**Check, the day before (5 minutes):**

```bash
git clone https://github.com/guriandoro/cordada
cordada/preflight.sh
cordada/sample/create.sh vaquita
```

`preflight.sh` only reads; it installs nothing. Every line should say OK. A WARN on `bd` means you can do levels 1 to 4. If a line says MISSING, it prints the fix.

`vaquita` splits the cost of an asado among friends and says who pays whom. Two tests fail on purpose and there is a TODO. Today we all climb it; your own repo is for Monday. Fall behind on the day? `cordada/sample/create.sh vaquita-3 --level 3` gives a repo already at level 2 to 5, committed (5 needs `bd`).

**No laptop or no Claude account?** Come anyway. Pair up with someone who has one, or follow the speaker's screen: every step runs live on the projector. You keep the route card either way.
