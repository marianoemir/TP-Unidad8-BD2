# 3.b Plan de Mantenimiento de la Base de Datos

Este plan complementa y extiende las directrices de mantenimiento de la Unidad 6, adaptándose a los requerimientos de la arquitectura distribuida del sistema **Food Store** (servidor PostgreSQL central y terminales móviles SQLite).

## 1. Estrategia de Respaldos (Backups) y Pruebas de Restauración
* **Respaldo Periódico:** Se programan respaldos automáticos diarios de la base de datos transaccional en PostgreSQL (`foodstore_u8`) utilizando herramientas nativas de volcado (`pg_dump`).
* **Pruebas de Restauración:** Semanalmente se valida la integridad de los respaldos mediante una prueba de restauración en un entorno de pruebas aislado (`staging`), verificando que los conteos de registros coincidan con los estados esperados.

## 2. Comportamiento Operativo ante Restauraciones en el Servidor Central
* **Impacto en las Tablets:** Si se realiza una restauración de un respaldo antiguo de PostgreSQL en el servidor central, se puede producir una desincronización de los identificadores (`IDs`) o catálogos respecto a las terminales SQLite.
* **Mitigación:** Las tablets operan con una instantánea de solo lectura y almacenan los pedidos en una cola transaccional local. Ante una restauración del servidor, las terminales validarán sus registros pendientes contra el estado actual del servidor mediante restricciones de unicidad e integridad referencial, evitando duplicar comandas o rechazar operaciones huérfanas de forma descontrolada.

## 3. Monitoreo y Revisión de Solicitudes en Estado Conflictivo
* **Frecuencia y Responsables:** El equipo técnico realiza una revisión diaria de la cola de sincronización para auditar los registros que queden retenidos en los estados `CONFLICTO` o `RECHAZADO`.
* **Criterio de Resolución:** Se evalúa si el conflicto se debió a un desfasaje de precios o stock agotado, aplicando la intervención manual necesaria para reintentar la transacción o descartarla de manera segura sin corromper la integridad de PostgreSQL.