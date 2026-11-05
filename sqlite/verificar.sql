-- 1. Verificar si hay elementos en la consulta original que NO están en la vista
SELECT p.id AS producto_id, p.nombre AS producto_nombre, p.precio, c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id
EXCEPT
SELECT producto_id, producto_nombre, precio, categoria_nombre
FROM vista_compatibilidad;

-- 2. Verificar si hay elementos en la vista que NO están en la consulta original (control inverso)
SELECT producto_id, producto_nombre, precio, categoria_nombre
FROM vista_compatibilidad
EXCEPT
SELECT p.id AS producto_id, p.nombre AS producto_nombre, p.precio, c.nombre AS categoria_nombre
FROM producto p
JOIN categoria c ON p.categoria_id = c.id;