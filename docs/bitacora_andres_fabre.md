# Bitácora Individual de Trabajo e Interacción con IA

**Integrante:** Andrés Fabre  
**Proyecto:** TP N.º 8 — Food Store (Capa de datos y entorno móvil)  
**Entorno de Trabajo:** Windows 11 / PowerShell / CLI `psql` / CLI `sqlite3`  
**Rama Git:** `Andrés`  

---

## 1. Registro de Actividades y Decisiones Técnicas

### Sesión 1: Configuración de Entorno y Verificación Inicial (H0)
- **Actividad:** Configuración del entorno de trabajo local en Windows 11 para interactuar con PostgreSQL 16 y SQLite 3.37+.
- **Acciones:**
  - Creación de la estructura de trabajo local.
  - Comprobación de conectividad a PostgreSQL y verificación del CLI de SQLite.
  - Validación de la arquitectura de scripts maestro (`up.sql`), reversión (`down.sql`) y pruebas formalizadas con el operador `EXCEPT`.

### Sesión 2: Redacción de Entregables Documentales (A1, A2, A3)
- **Actividad:** Elaboración de los tres documentos conceptuales asignados a la rama individual en `docs/partes/`.
- **Acciones:**
  - **1.a (`1a_datos_que_viajan.md`):** Definición de la matriz de sincronización del catálogo de productos hacia la tablet (SQLite). Identificación de PostgreSQL como la única fuente de verdad (*Source of Truth*) y justificación de la exclusión de datos financieros, stock central y datos de usuarios.
  - **3.a (`3a_mapa_capa_de_datos.md`):** Mapeo de la persistencia políglota integrando PostgreSQL (núcleo transaccional relacional), MongoDB (catálogo documental heredado de la U7) y SQLite (instantánea local y cola de sincronización de solo lectura/comandas).
  - **3.b (`3b_plan_mantenimiento.md`):** Extensión del plan de mantenimiento de la U6, detallando periodicidad de respaldos (`pg_dump`), protocolo de atenuación ante restauración de backups antiguos de PostgreSQL en tablets y frecuencia de auditoría sobre la cola en estados `CONFLICTO` / `RECHAZADO`.

### Sesión 3: Revisión Cruzada de las Consignas 1 y 2 (A4)
- **Actividad:** Ejecución del protocolo de pruebas cruzadas sobre los scripts oficiales subidos por Mariano a la rama `main`.
- **Acciones:**
  - Actualización del repositorio desde `main`.
  - Recreación limpia de la base de la tablet mediante `del movil\foodstore_movil.db` y posterior ejecución de `movil/schema_sqlite.sql`.
  - Ejecución de `postgresql/verificar_vista_snapshot.sql`: confirmación de match exacto 16/16 filas entre la tabla y la vista, 0 discrepancias (`EXCEPT`), y estructura de 7 columnas validada.
  - Ejecución de `postgresql/verificar_no_cambio.sql`: confirmación de conservación de estado base (**6 pedidos, 13 detalles, stock total 454 y hash MD5 `89f8351d0162e23ef1473f32b05ce221`**), demostrando la ausencia de modificaciones indeseadas en la base central.

---

## 2. Registro de Interacciones con la Inteligencia Artificial (IA)

| Fecha / Hito | Herramienta / Agente | Solicitud / Prompt Promedio | Respuesta / Propuesta de la IA | Decisión y Justificación (Aceptado / Descartado) |
|---|---|---|---|---|
| **04/11/2026 (H0)** | Gemini (Asistente de Código) | Consolidador de scripts SQL maestros para SQLite con verificación de vistas. | Propuso una secuencia con `PRAGMA foreign_keys = ON`, `CREATE TABLE` y `EXCEPT`. | **Aceptado parcialmente.** Permitió validar el concepto de pruebas de equivalencia de conjuntos antes de la integración oficial. |
| **04/11/2026 (A1, A2, A3)** | Gemini (Asistente de Código) | Redactar de forma concisa los entregables 1.a, 3.a y 3.b para la carpeta `docs/partes/`. | Generó las tablas de sincronización, el mapa políglota y las cláusulas del plan de mantenimiento. | **Aceptado totalmente.** Coincidía de forma precisa con el modelo relacional/documental acordado en el equipo y la plantilla del práctico. |
| **04/11/2026 (A4)** | Gemini (Asistente de Código) | Diagnóstico de error `table producto_cache already exists` al ejecutar `schema_sqlite.sql`. | Explicó que el archivo `.db` ya existía previamente y sugirió eliminar el archivo con `del` antes de correr el script CLI. | **Aceptado.** Se eliminó el archivo en Windows 11, permitiendo una reconstrucción limpia y exitosa de la base de la tablet. |
| **04/11/2026 (A4)** | Gemini (Asistente de Código) | Interpretación del resultado de `verificar_no_cambio.sql` (impresión del hash MD5 `89f835...`). | Explicó el significado técnico del MD5 y la coincidencia de los conteos 6/13/454. | **Aceptado.** Confirmó de manera cuantitativa que la revisión cruzada A4 sobre los scripts de Mariano fue superada exitosamente. |

---

## 3. Reflexión y Auto-evaluación

El flujo de trabajo colaborativo mediante ramas Git en Windows 11 permitió un desarrollo ágil y sin interferencias entre las consignas del motor central (Mariano) y la capa de documentación/mapa de datos (Andrés). El uso de la IA facilitó acelerar el armado de la estructura en Markdown y la depuración rápida de errores de entorno en SQLite/PostgreSQL, siempre manteniendo el control humano mediante la validación directa en la consola de comandos.