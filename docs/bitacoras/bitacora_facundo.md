# Bitácora Individual de Trabajo (TP8)
**Integrante:** Facundo  
**Rama de trabajo:** `review-final`  
**Entorno de trabajo:** PostgreSQL `foodstore_u8` (Servidor) y SQLite `foodstore_movil.db` (Móvil)

---

## 1. Verificación del Entorno e Hito H0

* **Entorno Python y SQLite CLI:**
  - Se verificó el entorno Python local ejecutando `python -c "import sqlite3; print(sqlite3.sqlite_version)"`, confirmando la versión **3.54.1** (cumpliendo con el estándar superior a 3.37 necesario para la directiva `STRICT`).
  - Se configuró la base de datos de la tablet `foodstore_movil.db` dentro del directorio `movil/` aplicando el esquema estricto (`schema_sqlite.sql`).
  - Se importó con éxito el catálogo inicial desde `servidor_snapshot.csv` utilizando el script `cargar_catalogo.sql`.

* **Pruebas de Integridad y Restricciones:**
  - Se corrieron las pruebas automatizadas (`pruebas_sqlite.sql`).
  - Se validó la respuesta `integrity_check | ok`.
  - Se constataron los fallos controlados esperados para pruebas negativas (`FOREIGN KEY constraint failed`, `CHECK constraint failed`, `cannot store TEXT value in INTEGER column`), confirmando que la base SQLite rechaza datos corruptos o de formato incorrecto.

---

## 2. Code Review de Scripts (Consigna 3.c)

* **Metodología:**
  - Se creó y seleccionó la rama `review-final`.
  - Se analizó el conjunto de scripts mediante el agente Plan de **OpenCode** para la inspección estática del código.
  - Cada observación fue re-evaluada y comprobada empíricamente en el motor correspondiente antes de determinar su resolución.

* **Hallazgos Principales:**
  1. **H36 (Unidad 8 - `movil/pruebas_sqlite.sql`):** Se identificó que el CLI de SQLite no ejecuta un `ROLLBACK` automático ante un fallo de restricción, provocando que el `COMMIT` subsecuente genere transacciones parciales. Decisión: *Aceptado y documentado*.
  2. **H01 (Unidad 1 - `postgresql/10_snapshot_catalogo.sql` vs `heredado/base_heredada/objects.sql`):** Se detectó asimetría entre la vista de snapshot y el procedimiento almacenado `sp_crear_pedido` respecto a categorías dadas de baja. Decisión: *Aceptado y documentado*.
  3. **H04 (Unidad 1 - `heredado/base_heredada/schema.sql`):** Se observó la ausencia de índice por `producto_id` en `detalle_pedido`. Decisión: *Descartado con fundamento* debido a la convención estricta del proyecto de no alterar índices en la base heredada.

* **Registro:** Se volcó el detalle completo de la evaluación en `docs/partes/3c_code_review.md`.

---

## 3. Revisión del Semáforo y Casos de Prueba Propios (Tarea F2)

* **Casos Estándar C2 a C6:**
  - Se verificó el funcionamiento del script `movil/semaforo.sql` procesando solicitudes pendientes y evaluando estados de sincronización (`PENDIENTE`, `RECHAZADO`, `CONFLICTO`).

* **Prueba de Caso Propio:**
  - Se ensayó la inserción de un borrador de prueba respetando las restricciones de tipo `STRICT` (UUID de 36 caracteres, `usuario_id_servidor`, `forma_pago` y captura de `precio_centavos_visto`).
  - Se corroboró que el motor aplica correctamente las restricciones de no-nulidad (`NOT NULL constraint failed: item_borrador.precio_centavos_visto`) asegurando la consistencia de los datos guardados en la tablet antes de ser procesados por la lógica del semáforo.
  - Se validó el procesamiento ordenado de la cola de sincronización devolviendo las salidas esperadas.

---

## 4. Próximos Pasos

* Unificar los aportes individuales en el documento final.
* Elaborar la sección **DUIA** (Documentación Individual de Uso y Análisis) integrando las reflexiones técnicas alcanzadas durante la práctica.