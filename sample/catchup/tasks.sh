#!/usr/bin/env bash
# Level 5 catch-up: the TODO items as beads tasks with dependencies, as /cordada:rope would leave them.
# Run from the sample repo root, after `bd init`. Needs bd.
set -euo pipefail
new() { bd create "$1" -p "$2" -d "$3" --acceptance "$4" --silent; }
expenses=$(new "Read expenses CSV into rows" 1 \
  "Goal: read a CSV like gastos/asado.csv (who, what, amount) into rows with the amount as integer cents, so balances can be computed from them. A bad row fails with its line number. Files: vaquita/expenses.py, tests/test_expenses.py." \
  "./check passes, and reading gastos/asado.csv gives 6 rows, Ana's carne as 4500000 cents, and a row with a non-numeric amount raises an error naming its line")
money=$(new "Format money for display" 2 \
  "Goal: show integer cents as pesos the way we print them: 123450 is \"\$ 1.234,50\", 5000 is \"\$ 50,00\". Files: vaquita/money.py, tests/test_money.py." \
  "./check passes, and 123450 gives \"\$ 1.234,50\" and 5000 gives \"\$ 50,00\"")
balances=$(new "Balances from rows" 2 \
  "Goal: from the expense rows, how much each person is owed (+) or owes (-); everyone in the file shares equally, using split_cents so no cent is lost. Files: vaquita/balances.py, tests/test_balances.py." \
  "./check passes, and the balances of gastos/asado.csv add up to exactly 0 cents")
transfers=$(new "Transfers from balances" 2 \
  "Goal: from the balances, who pays whom, with as few transfers as possible. Files: vaquita/transfers.py, tests/test_transfers.py." \
  "./check passes, and applying the transfers to the balances leaves everyone at zero, with no more transfers than people minus one")
report=$(new "report command" 2 \
  "Goal: python3 -m vaquita report gastos/asado.csv prints what each person paid, their balance, and who pays whom. Files: vaquita/report.py, vaquita/__main__.py, tests/test_report.py." \
  "./check passes, and running the command on gastos/asado.csv prints each person's paid amount, balance and the transfers, with money formatted")
html=$(new "HTML report" 3 \
  "Goal: python3 -m vaquita html gastos/asado.csv writes report.html, the same content as report, as a page you open in the browser. Files: vaquita/html.py, vaquita/__main__.py, tests/test_html.py." \
  "./check passes, and python3 -m vaquita html gastos/asado.csv writes report.html containing each person's paid amount, balance and the transfers")
readme=$(new "README usage section" 3 \
  "Goal: document how to run report once it works. Files: README.md." \
  "./check passes, and the README usage section shows the report command on gastos/asado.csv with its real output")
bd dep add "$balances" "$expenses" -t blocks >/dev/null
bd dep add "$transfers" "$balances" -t blocks >/dev/null
for d in "$expenses" "$money" "$balances" "$transfers"; do bd dep add "$report" "$d" -t blocks >/dev/null; done
bd dep add "$html" "$report" -t blocks >/dev/null
bd dep add "$readme" "$report" -t blocks >/dev/null
