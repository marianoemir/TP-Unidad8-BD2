# Bitácora de uso de IA — TP N.º 8

> **BORRADOR para completar.** Las entradas 1 y 2 describen lo que pasó en la preparación del TP; confirmá cada dato
> y corregí lo que no sea exacto. La entrada 3 es una plantilla: completala con tu uso real de **Kiro** y **OpenCode**
> (el enunciado pide que el spec se escriba en Kiro y que el esquema y la simulación se generen con OpenCode
> a partir de las tareas). Lo que no hiciste, no lo anotes.

Formato de cada entrada: **qué se pidió · qué se aceptó · qué se descartó y por qué · cómo se comprobó**.

## Entrada 1 — NotebookLM: kit de la cátedra (código de referencia)

- **Qué se pidió:** el código del `kit_u8_campus` mencionado en el apunte (esquema, snapshot, simulador).
- **Qué se aceptó:** el SQL del esquema SQLite, la vista `v_snapshot_movil` y la transacción del borrador, después de
  compararlos con el apunte de la Unidad 8 (parada 3, 4 y 5): coincidían.
- **Qué se descartó y por qué:** el `simulador_sync.py`. Comparaba el resultado de `fetchone()` (una tupla) con el texto
  `'PENDIENTE'`, así que siempre daba "ya evaluada" y **nunca evaluaba nada**; importaba `psycopg2` sin usarlo, no tenía las
  opciones `--dsn` ni `--reset` que su propio texto describía, y nombraba una tabla `registro_sync` que no existe en el esquema.
  Además ese archivo no estaba en el campus: la IA lo reconstruyó a partir del apunte. El semáforo se escribió en SQL puro.
- **Cómo se comprobó:** lectura del código contra la lógica de la parada 6 y contra las tablas del esquema.

## Entrada 2 — Claude: armado del repo, esquema, semáforo y casos

- **Qué se pidió:** clasificar qué scripts de las Unidades 1 a 7 se reutilizan y armar el repo del TP8; borrador de
  `schema_sqlite.sql`, `semaforo.sql` y los casos C2 a C6.
- **Qué se aceptó:** el esquema del apunte con los agregados (CHECK de motivo, `evaluada_en`, tabla de paso
  `snapshot_servidor`); el semáforo con `LEFT JOIN` y tratamiento explícito del producto inexistente; la recarga del
  catálogo con `ON CONFLICT DO UPDATE`.
- **Alternativas evaluadas y descartadas (decisiones de diseño, no propuestas de la IA):** `INSERT OR REPLACE` para recargar el catálogo (borra la fila y falla con la clave foránea
  activa si un borrador la usa; además perdería la lápida de C4); un `UNIQUE` simple sobre `cola_sync.id_local` (impediría
  reenviar tras un CONFLICTO: se mantiene el índice parcial).
- **Cómo se comprobó:** se corrió todo de punta a punta sobre PostgreSQL 16 y SQLite 3.45 (C1 a C7, casos borde: producto
  inexistente, rojo + amarillo en el mismo borrador, borrador sin ítems, dos pendientes del mismo borrador) y se verificó
  con `postgresql/verificar_no_cambio.sql` que pedidos y stock no cambiaron. **Repetí la corrida en tu máquina** y
  guardá las salidas como evidencia.

## Entrada 3 — OpenCode / Kiro (completar)

- **Qué se pidió:**
- **Qué se aceptó:**
- **Qué se descartó y por qué:**
- **Cómo se comprobó:**

> El code review de la consigna 3.c (agente Plan sobre `heredado/`) va en el informe como tabla de hallazgos con su
> decisión; acá anotá el prompt que usaste y cómo lo revisaste.
