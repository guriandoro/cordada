# TODO

Loose notes, in no particular order. Update when something is done (we forget).

- [ ] fix the split bug, two tests fail (the shares don't add up to the total)
- [ ] `report` command: `python3 -m vaquita report gastos/asado.csv` prints what each person paid, their balance, and who pays whom. Needs everything else first
- [ ] read an expenses file (CSV like `gastos/asado.csv`: who, what, amount) into rows. Amounts become integer cents. Bad rows should fail with the line number. `vaquita/expenses.py`
- [ ] balances: from the expense rows, how much each person is owed (+) or owes (-). Everyone in the file shares equally. Balances must add up to zero. `vaquita/balances.py`
- [ ] transfers: from the balances, who pays whom, with as few transfers as possible. `vaquita/transfers.py`
- [ ] show money nicely: 123450 cents is "$ 1.234,50", 5000 is "$ 50,00". `vaquita/money.py`
- [ ] HTML report: same as `report` but writes `report.html`, a page you open in the browser. `vaquita/html.py`
- [ ] usage section in the README once `report` works
- [ ] every new module gets its own test file in `tests/`. don't touch `vaquita/__init__.py`
