-- ==============================================================================
-- TRABAJO PRÁCTICO N° 8 - SCRIPT DE MIGRACIÓN Y CONFIGURACIÓN MAESTRA (up.sql)
-- ==============================================================================

-- 1. Habilitar la verificación de claves foráneas en SQLite
PRAGMA foreign_keys = ON;

-- 2. Creación de Tablas Principales
CREATE TABLE IF NOT EXISTS categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS producto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL,
    categoria_id INTEGER,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Creación de Vistas de Compatibilidad
DROP VIEW IF EXISTS vista_compatibilidad;

CREATE VIEW vista_compatibilidad AS
SELECT 
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    p.precio,
    c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id;