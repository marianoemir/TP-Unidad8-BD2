# 9. Documentación Individual de Uso y Análisis (DUIA)

**Autor:** Facundo  
**Rol/Tareas:** Code Review de scripts (3.c), Verificación de Entorno H0, Revisión Cruzada de Semáforo (F2).

---

## 1. Análisis Técnico y Reflexión sobre los Motores (PostgreSQL vs. SQLite)

Durante el desarrollo del trabajo práctico y el análisis de la arquitectura híbrida (servidor central en PostgreSQL y clientes móviles aislados en SQLite), se evidenciaron importantes diferencias de comportamiento y de filosofía de diseño entre ambos motores de bases de datos:

1. **Garantía de Tipado Estricto vs. Flexibilidad Creada:**
   * **PostgreSQL** impone un chequeo riguroso de tipos desde su definición estándar.
   * **SQLite**, por defecto, utiliza *Type Affinity*, lo que permite almacenar valores de distintos tipos en una misma columna. Sin embargo, la habilitación de la directiva `STRICT` en el esquema móvil (`schema_sqlite.sql`) fue fundamental para igualar las exigencias del servidor, garantizando que errores de conversión o datos mal formados sean rechazados en la tablet antes del intento de sincronización.

2. **Manejo de Transacciones y Control de Errores en CLI:**
   * En PostgreSQL, un error dentro de un bloque transaccional inhabilita las sentencias posteriores hasta ejecutar un `ROLLBACK`.
   * En el CLI de SQLite, los errores en sentencias individuales (como violaciones de clave foránea o `CHECK`) no abortan automáticamente el bloque completo a menos que se configure explícitamente el modo `-bail`. Como se detectó en el Code Review (Hallazgo H36), un `COMMIT` posterior a una falla confirma los registros previos válidos, lo que resalta la necesidad de implementar manejadores transaccionales estrictos en la capa de aplicación móvil.

3. **Restricciones de Integridad y Claves Foráneas:**
   * Mientras que en PostgreSQL las referencias por Foreign Key están activas de manera predeterminada, en SQLite requieren ser habilitadas explícitamente mediante `PRAGMA foreign_keys = ON;`. La comprobación de este `PRAGMA` al inicio de cada sesión resultó crítica para asegurar la integridad referencial en el dispositivo móvil.

---

## 2. Evaluación de la Lógica del Semáforo y Reglas de Negocio (F2)

El análisis del script `movil/semaforo.sql` permitió comprender la estrategia de sincronización asíncrona entre la tablet y el servidor:

* **Evaluación Local Desconectada:** La capacidad del semáforo para clasificar borradores en `PENDIENTE`, `CONFLICTO` o `RECHAZADO` utilizando únicamente la instantánea local (`producto_cache`) resuelve eficazmente la operabilidad en escenarios sin conectividad.
* **Precedencia de Alertas:** Se constató el correcto orden de jerarquía de las reglas (rojo sobre amarillo). Las inconsistencias críticas, como la falta de stock o la variación de precios por encima del umbral tolera, son correctamente priorizadas impidiendo el envío de solicitudes inviables.
* **Asimetría de Validaciones (Hallazgo H01):** Se identificó una oportunidad de mejora en la alineación de contratos: la vista móvil descarta ítems pertenecientes a categorías inactivas, pero el Stored Procedure del servidor permite su alta directiva. Documentar estas discrepancias resulta clave para mantener la consistencia del sistema global.

---

## 3. Conclusiones Personales

La experiencia práctica confirmó que la interacción con herramientas de asistencia basadas en IA (como el agente Plan de OpenCode) potencia la capacidad de auditoría de código, pero **no reemplaza la verificación empírica en el motor real**. La validación de cada hallazgo mediante consultas, planes de ejecución y pruebas unitarias negativas garantizó un aprendizaje profundo sobre la consistencia de datos, el rendimiento de índices y la arquitectura de bases de datos distribuidas.