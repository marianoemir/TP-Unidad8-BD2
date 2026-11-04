# 3.a Mapa de la Capa de Datos (PostgreSQL, MongoDB y SQLite)

El sistema **Food Store** implementa una arquitectura de persistencia políglota y distribuida, donde cada motor de base de datos cumple un rol especializado, gestionando dominios de información específicos y estableciendo claras jerarquías de autoridad (*Source of Truth*).

## 1. Tabla de Motores, Dominios y Jerarquía de Autoridad

| Motor de Base de Datos | Componente / Entorno | ¿Qué información almacena? | Fuente de Verdad / ¿Quién manda? |
|---|---|---|---|
| **PostgreSQL** | Servidor Central / Relacional | Gestión transaccional principal: usuarios, catálogo maestro de productos, pedidos oficiales, estados de la cola de sincronización y vistas de compatibilidad. | **Es la fuente de verdad definitiva** para las reglas de negocio, stock, precios oficiales y transacciones financieras del sistema. |
| **MongoDB** | Servidor de Catálogo / Documental (Unidad 7) | Almacenamiento flexible de metadatos de productos, descripciones extendidas, especificaciones técnicas y atributos semiestructurados orientados a documentos. | **Fuente de verdad secundaria o complementaria** para la capa de presentación web y enriquecimiento de fichas de artículos. |
| **SQLite** | Dispositivo Móvil / Tablet | Instantánea local de solo lectura del catálogo de productos y almacenamiento temporal de comandas o pedidos pendientes generados en el salón. | **Autoridad local transitoria**. No manda sobre los datos maestros; sus movimientos de venta operan bajo una cola de sincronización que debe ser validada y consolidada por PostgreSQL. |

---

## 2. Descripción de la Integración y Flujo de Datos

* **De PostgreSQL a SQLite (Sincronización Descendente):** Periódicamente, el servidor central exporta una instantánea optimizada del catálogo de productos (generada mediante vistas en PostgreSQL) para que las tablets operen de manera autónoma en el salón sin dependencia estricta de la red local.
* **De SQLite a PostgreSQL (Sincronización Ascendente / Cola):** Los pedidos recolectados en la tablet se registran localmente en una cola transaccional. Al restablecerse la conectividad, estos registros se envían al servidor central, donde PostgreSQL procesa, valida restricciones e integra los pedidos de forma definitiva.
* **Rol de MongoDB:** Actúa de forma desacoplada para gestionar la flexibilidad documental heredada de la Unidad 7, permitiendo consultar atributos variables de los artículos sin impactar el modelo relacional rígido del núcleo transaccional.