# vaquita: instructions for agents

Splits the cost of a shared meal or trip among friends: reads who paid what, reports each person's balance and who pays whom. Python 3.9 or later, standard library only.

## Commands
- Test: `python3 -m unittest discover -s tests` (under a second)

## Layout
- `vaquita/`: one module per concern. `TODO.md` names the planned modules.
- `tests/`: one `test_<module>.py` per module in `vaquita/`.
- `gastos/`: sample expense files in CSV (`who,what,amount`, amount in pesos with a dot for decimals).

## Conventions
- Money is integer cents everywhere. Convert at the edges only: when reading a file and when printing. Floats lose cents.
- Shares and balances must add up exactly: no cent created or lost.
- Standard library only: no third-party dependencies, so it runs on anyone's laptop.
- Every new module gets its own test file in `tests/`.

## Do not
- Edit `vaquita/__init__.py`: the release script reads `__version__` from it.
- Change a test's expected value to make it pass: the tests are the spec, a failing one means the code is wrong.

## Decisions
Record decisions and their why in `docs/decisions.md`. Read it before changing an approach.
