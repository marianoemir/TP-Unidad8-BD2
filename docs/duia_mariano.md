# Declaración de Uso de IA (DUIA) — Mariano Chirino

**Integrante:** Mariano Chirino (Grupo 10)
**Materia:** Base de Datos II (UTN) — Unidad 8, TP N.º 8
**Proyecto Integrador:** Food Store
**Alcance:** consignas 1 y 2 (base de la tablet en SQLite, instantánea, semáforo, casos C2 a C6), spec en Kiro (4.a) y armado del repositorio
**Herramientas:** Claude (chat), NotebookLM y Kiro. *(Confirmar: si usaste OpenCode en este TP, agregarlo acá.)*

> Esta declaración cubre únicamente lo que hice y usé yo. Andrés Fabre y Facundo Quiroga
> declaran su propio uso de IA en `duia_andres.md` y `duia_facundo.md`.

---

## Registro de interacciones y decisiones con IA

### Consignas 1 y 2 — base de la tablet y sincronización

| Herramienta | Para qué se usó | Se aceptó / se descartó — por qué |
|---|---|---|
| NotebookLM | Resumir el apunte y pedir el código del `kit_u8_campus`, que no estaba en el campus | **Aceptado:** el SQL del esquema SQLite, `v_snapshot_movil` y la transacción del borrador, después de contrastarlos con las paradas 3, 4 y 5 del apunte: coincidían. **Descartado:** `simulador_sync.py`. Comparaba el resultado de `fetchone()` (una tupla) con el texto `'PENDIENTE'`, así que nunca habría evaluado nada; importaba `psycopg2` sin usarlo y nombraba una tabla `registro_sync` que no existe en el esquema. La IA lo había reconstruido, porque ese archivo no estaba en el campus. El semáforo se escribió en SQL puro. |
| Claude | Clasificar qué scripts de las Unidades 1 a 7 se reutilizan y armar la estructura del repo | **Aceptado:** `heredado/` con los scripts sin modificar. **Descartado:** ejecutar `pedidos_de_prueba.sql` y `carga_masiva.sql` (cambiarían el stock de los casos C3 y C5). Se cambió el usuario con nombre real de `data.sql` por uno inventado. |
| Claude | Borrador de `schema_sqlite.sql`, `cargar_catalogo.sql`, `pruebas_sqlite.sql`, `semaforo.sql` y los casos C2 a C6 | **Aceptado**, después de leerlo y correrlo. Alternativas que se evaluaron y se dejaron de lado (decisiones de diseño, no propuestas de la IA): `INSERT OR REPLACE` para recargar el catálogo (borra la fila y falla con la clave foránea activa) y un `UNIQUE` simple sobre `cola_sync.id_local` (impediría reenviar tras un `CONFLICTO`). Se aceptó el `UPSERT` y el índice parcial `ux_cola_una_pendiente`. Se aceptó el tratamiento explícito del producto inexistente en el `LEFT JOIN` (con `NULL`, un producto que no existe pasaría como verde). |
| Claude | Guiar la corrida en mi máquina con PowerShell | `sqlite3` no se reconocía después de instalarlo con `winget`: no creó el acceso directo en `WinGet\Links`. Se resolvió agregando al PATH la carpeta real del paquete. Se descartó la contraseña de `postgres` escrita en pantalla: se cambió a entrada oculta. |

### Consigna 4.a — spec en Kiro

| Herramienta | Para qué se usó | Se aceptó / se descartó — por qué |
|---|---|---|
| Kiro | Generar `requirements.md`, `design.md` y `tasks.md` | **Se escribió después de los scripts, no antes** (el enunciado pide lo contrario). **Corregido en `requirements.md`:** el criterio 4 del Requisito 3 decía que el semáforo marca `eliminado = 1` en `producto_cache`; eso lo hace la recarga del catálogo, no el semáforo. **Corregido en `design.md`:** exportaba con `COPY producto` en lugar de la vista `v_snapshot_movil`; inventaba un transporte "llave USB / correo"; tenía invertida la fila de los booleanos y decía que la transacción hace rollback sola. **Descartado:** las pruebas de propiedades con Hypothesis (alcance de más: el TP no exige Python) y el límite de 255 caracteres en `motivo`, que el semáforo no impone. |
| Claude | Revisar lo que generó Kiro contra los scripts y las evidencias | Detectó los errores anteriores y que la tabla de pruebas del diseño no mencionaba `pruebas_sqlite.sql` (C1 y C7). Se corrigió. |

### Revisión del trabajo de un compañero (PR #1 de Andrés Fabre)

| Herramienta | Para qué se usó | Se aceptó / se descartó — por qué |
|---|---|---|
| Claude | Revisar el pull request: clonar la rama, leer los archivos y probar los scripts | **Descartado del PR:** la carpeta `sqlite/` y los dos `tp8_database.db` (un esquema de ejemplo con `precio REAL`, sin `STRICT` ni centavos, que acepta texto como precio: no es el esquema del TP), y el `movil/foodstore_movil.db` vacío, que habría pisado la base con la evidencia de los casos. **Corregido:** 1.a, 3.a y 3.b tenían columnas inexistentes, ubicaban la cola en PostgreSQL, describían MongoDB como metadatos de productos y daban autoridad local a SQLite; se reescribieron contra el esquema real y `v_snapshot_movil`, y cada archivo lo aclara. Se verificó cada dato contra `schema.sql` y `esquema_documental.md`. |

---

## Verificación sobre el motor real

Todo se probó en mi máquina (Windows PowerShell 5.1): PostgreSQL 17.10 con la base de pruebas `foodstore_u8`, armada desde cero con los scripts de `heredado/`, y SQLite 3.54.1.

1. Corrida completa de C1 a C7 con las salidas guardadas en `evidencias/01` a `12`.
2. Prueba de que PostgreSQL no cambió: `verificar_no_cambio.sql` antes y después, con la misma huella de stock `89f8351d0162e23ef1473f32b05ce221`.
3. Pendiente de correr y guardar como evidencia: `postgresql/verificar_vista_snapshot.sql` y `movil/verificar_vistas_tablet.sql` (Paso 5 del protocolo de seguridad). *(Marcar como hecho cuando estén en `evidencias/`.)*

Ninguna propuesta de la IA se incorporó sin leerla y correrla.

## Resumen de decisiones

| Aspecto | Resultado |
|---|---|
| Semáforo | SQL puro: rojo gana sobre amarillo; solo evalúa `PENDIENTE`; el producto que falta en la instantánea es rojo |
| Recarga del catálogo | `INSERT … ON CONFLICT DO UPDATE`; la lápida conserva la fila |
| Reenvío de una solicitud | `UUID` como clave primaria; índice parcial para permitir reenviar solo tras un `CONFLICTO` |
| Código de la cátedra | No se usó: el `kit_u8_campus` no estaba disponible |
| Spec de Kiro | Posterior al código; declarado |
