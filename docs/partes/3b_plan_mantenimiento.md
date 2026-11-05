# 3.b · Plan de mantenimiento (agregado al plan de la Unidad 6)

> Las frecuencias de respaldo se ajustan a las del plan de la Unidad 6.

**1. ¿Qué se respalda y cómo se prueba la restauración?**
Se respalda la **fuente de verdad**: la base PostgreSQL (`foodstore`) con `pg_dump`, con fecha y hora en el nombre y fuera del repo (diario, y siempre antes de un cambio estructural).
La restauración se prueba **cada semana** en una base descartable, creada aparte (nunca sobre la real): se restaura el volcado y se corre `postgresql/verificar_no_cambio.sql`;
si los pedidos, los detalles, el stock total y la huella de stock coinciden con los de la base original, el respaldo sirve.
MongoDB se puede regenerar desde PostgreSQL con la exportación de la Unidad 7. La base de la tablet no se respalda como fuente: la lista de precios se regenera con una instantánea nueva.
Lo único que existe solo en la tablet son los borradores que todavía no se enviaron, por eso se copia el archivo `foodstore_movil.db` antes de actualizar el catálogo.

**2. Si se restaura un respaldo viejo de PostgreSQL, ¿qué hacen las tablets?**
Las tablets quedan con datos «del futuro»: precios, stock y bajas que el servidor restaurado ya no tiene. Por eso **no envían nada con esa lista**: primero
**vuelven a descargar el catálogo** (instantánea nueva → recarga de `producto_cache`) y recién ahí se corre el semáforo sobre las solicitudes `PENDIENTE`.
Como el UUID de cada solicitud no cambia, reenviarlas no duplica pedidos, y como `SIMULADO_APROBADO` nunca fue una venta, la restauración no deja ventas falsas en las tablets.

**3. ¿Cada cuánto y quién revisa las solicitudes en `CONFLICTO` o `RECHAZADO`?**
Se revisan **al volver la señal y al cierre de cada jornada de feria**. Las revisa el **vendedor a cargo de la tablet, junto con el administrador (rol `ADMIN`)**:
ante un `CONFLICTO` se le pregunta al cliente si acepta el precio nuevo y, si acepta, se actualiza el borrador y se genera una solicitud nueva;
ante un `RECHAZADO` se corrige el borrador o se avisa que el producto no está disponible, sin stock o dado de baja. Nada se resuelve desde la tablet contra el servidor.

---
*Versión corregida por Mariano Chirino tras revisar el borrador de Andrés Fabre (PR #1): se agregó la descarga del catálogo tras restaurar un respaldo viejo y se nombró quién revisa la cola.*
