# 3.c Code Review con IA de los Scripts de la Cursada

## Contexto y Metodología
El análisis de los scripts SQL del proyecto se realizó de manera sistemática sobre una rama dedicada (`review-final`), utilizando la herramienta **OpenCode** configurada en el **agente Plan** (modo de solo lectura sin modificación de archivos).

Siguiendo las directivas del proyecto y el protocolo de seguridad, **ningún hallazgo de la IA se dio por cierto sin verificación previa**. Cada observación fue sometida a pruebas empíricas en los motores correspondientes (PostgreSQL 16 y SQLite 3.54) mediante ejecución de scripts, pruebas de restricciones o análisis de planes de ejecución (`EXPLAIN`).

---

## Tabla de Hallazgos y Decisiones

| ID | Unidad / Archivo | Descripción del Hallazgo | Comprobación en el Motor | Decisión y Fundamento |
| :--- | :--- | :--- | :--- | :--- |
| **H36** | **Unidad 8**<br>`movil/pruebas_sqlite.sql` | **COMMIT tras error (Commit parcial):** El CLI de SQLite no realiza `ROLLBACK` automático ante un fallo de restricción. Un `COMMIT` posterior en el script confirma las inserciones previas válidas, dejando la base en estado inconsistente. | **Ejecución CLI:** Se ejecutó `pruebas_sqlite.sql` en una base SQLite limpia. Ante el fallo `FOREIGN KEY constraint failed`, el `COMMIT` posterior ejecutó con éxito dejando 1 fila en `pedido_borrador` y `cola_sync`, pero 0 en `item_borrador`. | **ACEPTADO / DOCUMENTADO:**<br>Se documenta el comportamiento del motor en el CLI. En aplicaciones reales o scripts de prueba debe manejarse un `ROLLBACK` explícito o bandera `-bail` para evitar commits parciales no deseados. |
| **H01** | **Unidad 1**<br>`postgresql/10_snapshot_catalogo.sql` vs `heredado/base_heredada/objects.sql` | **Discrepancia de contrato entre vista y Stored Procedure:** La vista `v_snapshot_catalogo` descarta productos de categorías eliminadas (`p.eliminado OR c.eliminado`), mientras que `sp_crear_pedido` solo valida `p.eliminado`. Si se da de baja una categoría, la tablet rechaza el borrador localmente, pero el servidor aceptaría un pedido directo. | **Prueba en PG:** Se ejecutó `UPDATE categoria SET eliminado=TRUE WHERE id=5;` y luego `CALL sp_crear_pedido(...)` con un producto de esa categoría. El servidor procesó la venta sin errores, confirmando la asimetría de validación. | **ACEPTADO / DOCUMENTADO:**<br>Se acepta el hallazgo como una diferencia de diseño de contrato entre el backend heredado y la capa móvil. Se documenta para el informe sin alterar el Stored Procedure heredado. |
| **H04** | **Unidad 1**<br>`heredado/base_heredada/schema.sql` | **Falta de índice por `producto_id` en `detalle_pedido`:** La tabla posee un índice compuesto `UNIQUE (pedido_id, producto_id)`. Las consultas que filtran solo por `producto_id` (como agregaciones o productos sin ventas) no pueden aprovechar este índice. | **Plan de consulta:** Se ejecutó `EXPLAIN ANALYZE SELECT * FROM detalle_pedido WHERE producto_id = 1;` en PostgreSQL. Se verificó que el plan realiza un *Sequential Scan* en lugar de un *Index Scan*. | **DESCARTADO CON FUNDAMENTO:**<br>A pesar de que el impacto en rendimiento sobre tablas con alto volumen es real, la restricción explícita de diseño del proyecto (*.kiro/steering/conventions.md*) establece: *"No se agregan índices en este TP"*. Se descarta la modificación del esquema estructural heredado. |

---

## Resumen de Criterios Cumplidos
- **Cantidad de hallazgos:** 3 hallazgos analizados y fundamentados.
- **Diversidad de unidades:** Unidad 8 (SQLite/Móvil) y Unidad 1 (PostgreSQL/Base heredada).
- **Verificación empírica:** Todos los casos fueron verificados mediante el CLI de SQLite o el planificador/procedimientos de PostgreSQL.
- **Caso descartado:** Hallazgo H04 descartado fundadamente en cumplimiento con las reglas del proyecto.