# Tareas

- [ ] **T1** `postgresql/10_snapshot_catalogo.sql`: vista `v_snapshot_movil` (centavos, lápida, fecha) y exportar a CSV (`11_exportar_snapshot.sql`).
- [ ] **T2** `movil/schema_sqlite.sql`: cuatro tablas STRICT, `PRAGMA foreign_keys = ON`, índice parcial, vista del catálogo, tabla de paso `snapshot_servidor`.
- [ ] **T3** `movil/cargar_catalogo.sql`: cargar `producto_cache` desde `snapshot_servidor` con UPSERT.
- [ ] **T4** `movil/pruebas_sqlite.sql`: borrador con COMMIT, operación con ROLLBACK, C1 (catálogo sin servidor), C7 (cantidad 0 y producto inexistente).
- [ ] **T5** `movil/semaforo.sql`: rojo / amarillo / verde sobre las solicitudes PENDIENTE (REQ-01, REQ-02, REQ-03).
- [ ] **T6** Casos C2 a C6: borradores, cambios en el servidor (`postgresql/casos/`), instantánea nueva, semáforo, resolución de C2, reenvío de C6 (REQ-04).
- [ ] **T7** `postgresql/verificar_no_cambio.sql`: pedidos y stock sin cambios antes y después.
- [ ] **T8** Informe (mapa, plan de mantenimiento, code review), bitácora de IA, DUIA y README.
