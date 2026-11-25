---
name: add-module
description: Add a new module to vaquita/ with its test file, following this repo's layout. Use when asked to "add the X module", "create vaquita/X.py", "implement X from TODO.md", or to start any new piece of vaquita. Not for changing an existing module.
---

# add-module

Every module in `vaquita/` has its own test file. This keeps the two in step.

## Steps
1. Scaffold both files: `python3 tools/new_module.py <name> "<one-line purpose>"`. It refuses to overwrite.
2. Write the tests first in `tests/test_<name>.py`, with values checked by hand. Replace the failing placeholder.
3. Implement `vaquita/<name>.py` until the tests pass. Money in integer cents. Standard library only.
4. Don't touch `vaquita/__init__.py`.

## Done when
`./check` passes (or the test command in `CLAUDE.md` before level 4), including the new test file.
