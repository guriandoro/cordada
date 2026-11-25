# Antes del workshop (jueves 2026-11-26, 90 minutos)

**Traé:** una laptop (macOS o Linux; en Windows, usá WSL) y tu propia cuenta de Claude Code. No damos cuentas.

**Instalá:**
- git y Python 3.9 o posterior.
- Claude Code (https://code.claude.com/docs). Abrí `claude` una vez e iniciá sesión.
- Opcional, para el nivel 5: beads (`bd`). macOS: `brew install beads`. Otras plataformas: https://github.com/steveyegge/beads

**Probá, el día anterior (5 minutos):**

```bash
git clone https://github.com/guriandoro/cordada
cordada/preflight.sh
cordada/sample/create.sh vaquita
```

`preflight.sh` solo lee; no instala nada. Cada línea tendría que decir OK. Un WARN en `bd` significa que podés hacer los niveles 1 a 4. Si una línea dice MISSING, te muestra cómo arreglarlo.

`vaquita` divide los gastos de un asado entre amigos y dice quién le paga a quién. Dos tests fallan a propósito y hay un TODO. Hoy escalamos todos ese; tu repo queda para el lunes. ¿Te quedás atrás el día del workshop? `cordada/sample/create.sh vaquita-3 --level 3` te da un repo que ya está en el nivel 2 a 5, con commit (el 5 necesita `bd`).

**¿Sin laptop o sin cuenta de Claude?** Vení igual. Sumate con alguien que tenga, o seguí la pantalla del speaker: cada paso corre en vivo en el proyector. La tarjeta de ruta te la llevás igual.
