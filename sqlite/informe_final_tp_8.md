# Informe Técnico: Trabajo Práctico N° 8 - Bases de Datos

**Integrantes del Equipo:** Andrés, Mariano, Facundo  
**Entorno de Trabajo:** Windows 11 / Debian Linux  
**Motor de Base de Datos:** SQLite 3  
**Repositorio Git:** Branch `Andrés`  

---

## 1. Introducción y Objetivos

El presente trabajo práctico tiene como objetivo principal el diseño, implementación y validación formal de un esquema de base de datos relacional junto con sus vistas de compatibilidad correspondientes.

### Objetivos Específicos:
1. Configuración de un entorno colaborativo y estructurado de scripts SQL (`up.sql`, `down.sql`, `vistas.sql`, `verificar.sql`).
2. Definición formal del esquema relacional garantizando integridad referencial mediante claves foráneas.
3. Creación de **vistas de compatibilidad** para abstracción de datos y simplificación de reportes.
4. Validar formalmente la equivalencia entre las consultas base y la vista mediante pruebas de diferencia de conjuntos bidireccionales (`EXCEPT`).

---

## 2. Estructura del Proyecto

Para mantener una arquitectura limpia y facilitar la colaboración en el equipo, todos los componentes de la base de datos se alojan en la carpeta `/sqlite` del repositorio:

```text
TP-Unidad8-BD2/
└── sqlite/
    ├── up.sql            # Script maestro: creación de tablas y vistas
    ├── down.sql          # Script de reversión: eliminación de componentes
    ├── schema.sql        # Definición exclusiva de la estructura de tablas
    ├── vistas.sql        # Creación de vistas de compatibilidad
    ├── datos.sql         # Datos iniciales / juegos de prueba
    └── verificar.sql     # Script de validación formal bidireccional (EXCEPT)
```

---

## 3. Implementación del Esquema Relacional

### 3.1 Habilitación de Claves Foráneas
SQLite requiere habilitar explícitamente el soporte para restricciones de clave foránea en cada sesión de conexión:

```sql
PRAGMA foreign_keys = ON;
```

### 3.2 Definición de Tablas (`up.sql`)
Se definieron las tablas con claves primarias autoincrementales y relaciones explícitas:

```sql
CREATE TABLE IF NOT EXISTS categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS producto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL,
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);
```

---

## 4. Vista de Compatibilidad

Se implementó la vista `vista_compatibilidad` para desacoplar el modelo interno de almacenamiento de la interfaz de consulta de los usuarios o sistemas consumidores:

```sql
DROP VIEW IF EXISTS vista_compatibilidad;

CREATE VIEW vista_compatibilidad AS
SELECT 
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    p.precio,
    c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id;
```

---

## 5. Metodología de Validación y Verificación (`EXCEPT`)

Para garantizar que la vista `vista_compatibilidad` devuelva exactamente los mismos registros que la consulta directa (sin omitir ni duplicar registros), se aplicó una **verificación cruzada bidireccional** basada en álgebra relacional mediante el operador `EXCEPT`.

### 5.1 Script de Verificación (`verificar.sql`)

```sql
-- ==============================================================================
-- PRUEBA 1: Verificar elementos en la consulta directa que NO están en la vista
-- ==============================================================================
SELECT p.id AS producto_id, p.nombre AS producto_nombre, p.precio, c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id
EXCEPT
SELECT producto_id, producto_nombre, precio, categoria_nombre
FROM vista_compatibilidad;

-- ==============================================================================
-- PRUEBA 2: Verificar elementos en la vista que NO están en la consulta directa
-- ==============================================================================
SELECT producto_id, producto_nombre, precio, categoria_nombre
FROM vista_compatibilidad
EXCEPT
SELECT p.id AS producto_id, p.nombre AS producto_nombre, p.precio, c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id;
```

### 5.2 Resultados Obtenidos
* **Ejecución:** `sqlite3 tp8_database.db < sqlite/verificar.sql`
* **Resultado:** `0 filas devueltas` en ambas pruebas.

---

## 6. Conclusión

La arquitectura del script maestro `up.sql` y el script de reversión `down.sql` aseguran un despliegue idempotente y limpio. La verificación bidireccional con `EXCEPT` certifica matemáticamente la equivalencia entre la consulta original y la vista creada, cumpliendo satisfactoriamente con todos los requerimientos solicitados para la entrega del TP 8.