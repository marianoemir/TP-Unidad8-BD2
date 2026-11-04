# 1.a Qué datos viajan a la tablet (Instantánea del Catálogo)

## 1. Tabla de Sincronización de Productos

| Columna en PostgreSQL (`producto`) | ¿Viaja a la tablet (SQLite)? | Motivo / Justificación técnica |
|---|---|---|
| `id` | **Sí** | Identificador único del producto. Necesario para correlacionar los pedidos generados en la tablet con la base central. |
| `nombre` | **Sí** | Requerido para la visualización e identificación del producto por parte del mozo en la interfaz móvil. |
| `precio` | **Sí** | Permitir la lectura local del precio vigente al momento de armar la comanda sin depender de conectividad. |
| `categoria_id` / `categoria_nombre` | **Sí** | Clasificación básica para el filtrado y organización del menú en la pantalla de la tablet. |
| `activo` / `disponible` | **Sí** | Determina si el producto está disponible para la venta en el catálogo móvil. |
| `datos_sensibles_usuario` | **No** | Los datos de usuarios, credenciales, historial de compras y métricas internas no deben viajar por razones de seguridad y principio de mínimo privilegio. |
| `costo_proveedor` / `margen` | **No** | Datos financieros internos de la empresa que no son relevantes para la toma de pedidos y reducirían la privacidad si la tablet es comprometida. |
| `stock_reservado_deposito` | **No** | El control de stock centralizado se valida en PostgreSQL al procesar la cola de pedidos, no en la tablet. |

---

## 2. Definición de la Fuente de Verdad y Criterio de Sincronización

* **Fuente de Verdad (Source of Truth):** La base de datos central en **PostgreSQL** es la única fuente de verdad oficial para el catálogo de productos, precios y reglas de negocio.
* **Naturaleza en SQLite (Tablet):** La base local de la tablet almacena únicamente una **vista instantánea de solo lectura** (`read-only snapshot`) del catálogo. La tablet no tiene permisos para modificar precios ni descripciones de productos.
* **Justificación de Diseño:** Transferir solo las columnas estrictamente necesarias para la venta minimiza el tamaño del archivo `.csv` de sincronización, reduce la huella de memoria en el dispositivo móvil y protege la información financiera/sensible del negocio en caso de pérdida o extravío de la tablet.