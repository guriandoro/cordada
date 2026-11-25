# Tarjeta de ruta de Cordada

Cada nivel deja una cosa en tu repo. El nivel siguiente la necesita. Cada skill te guía (qué falta, el prompt para escribir) y después chequea lo que armaste. Nunca escribe los archivos: podés hacer cada nivel sin el plugin.

| Nivel | Preguntate | Prueba de que llegaste | Skill | El lunes, en tu repo |
|---|---|---|---|---|
| 1. Prompt | ¿Tu pedido tiene un objetivo, los límites, un chequeo de "listo" y dónde parar? | Nada en el repo. Tus pedidos pasan las cuatro partes. | `/cordada:brief <tu prompt>` | Chequeá tu próximo pedido antes de mandarlo. Arreglá los huecos con tus palabras. |
| 2. Context | ¿Una sesión nueva sabe cómo testear y qué no tocar, sin que se lo digas? | `CLAUDE.md` (menos de 60 líneas), cada "no" con su razón | `/cordada:map` | Pedile a Claude un `CLAUDE.md`: cómo testear, qué no tocar y por qué, las reglas que exige un revisor. Después `/clear` y preguntá: "¿cómo corro los tests, y qué no tengo que tocar?" |
| 3. Harness | ¿Hay un procedimiento que ya no explicás, y un archivo que el agente no puede editar por error? | Un skill en `.claude/skills/` al que apunta el mapa, un script en `tools/`, un hook de protección | `/cordada:gear` | Tomá el procedimiento que explicaste tres veces este mes. Pedí un skill, un script para su paso exacto, y un hook para el archivo a proteger. Probá el skill después de `/clear`. |
| 4. Loop | ¿El agente puede saber solo si su trabajo está listo? | `./check` (exit 0 = bien) y un "Done means" en `CLAUDE.md` que prohíbe debilitarlo | `/cordada:checks` | Pedí `./check`. Commit. Después `/goal ./check prints CHECK PASSED and no test was deleted, skipped or changed; or stop after 15 turns` |
| 5. Graph | ¿Varios agentes pueden tomar trabajo de una cola sin que vos lo repartas? | Una base beads local con dependencias; `bd ready` lista lo que puede empezar | `/cordada:rope`, después `/cordada:climb` | `bd init`, escribí dos tareas como briefs, `bd dep add`, después pedile a Claude que mueva el resto. Commit. Mirá `/cordada:climb 2` una vez antes de confiarle trabajo. |

## Encontrá tu nivel

- Tu nivel es el más alto **sin ningún hueco abajo**. Un `./check` sin `CLAUDE.md` sigue siendo nivel 1.
- Nombrá el artefacto que te falta. Agregá ese primero. Sin atajos.
- Preguntale al repo, solo lectura:

```
/cordada:route
```

Lista lo que tiene el repo, e imprime "You are at level N. Next: /cordada:<skill>".

Corré el skill de un nivel una vez para que te guíe, y otra vez cuando terminaste para que te chequee. `/cordada:<skill> guide` fuerza la guía.

Cargá el plugin: `/plugin marketplace add guriandoro/cordada` y después `/plugin install cordada@cordada`, o desde un clon `claude --plugin-dir cordada/plugins/cordada`.

Commit después de cada nivel y `/clear` antes del siguiente. ¿Atrasado en el ejemplo? `cordada/sample/create.sh vaquita-3 --level 3` (de 2 a 5). Repo: `https://github.com/guriandoro/cordada`

![Código QR a github.com/guriandoro/cordada](qr-cordada.png)

Escaneá para ir al repo: el plugin, el ejemplo y esta tarjeta.
