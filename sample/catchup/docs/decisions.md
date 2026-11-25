# Decisions

Append-only. One entry per decision that someone might later want to undo.

## Money in integer cents
**Context:** splitting $ 10.000 between 3 with floats left a cent missing.
**Decision:** every amount is an integer number of cents. Pesos appear only when reading a file and when printing.
**Why:** integers add up exactly. Revisit only if we need currencies with other subunits.

## Standard library only
**Context:** the tool runs on friends' laptops.
**Decision:** no third-party dependencies.
**Why:** nothing to install. Revisit only if a dependency saves real work.
