-- sqlite/vistas.sql
PRAGMA foreign_keys = ON;

DROP VIEW IF EXISTS vista_compatibilidad;

CREATE VIEW vista_compatibilidad AS
SELECT 
    p.id AS producto_id,
    p.nombre AS producto_nombre,
    p.precio,
    c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id;