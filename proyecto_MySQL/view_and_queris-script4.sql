
USE gaseosas_valle;

CREATE OR REPLACE VIEW vista_resumen_pedidos_por_sede AS
SELECT
    s.id_sede,
    s.nombre_sede,
    s.ubicacion,
    s.encargado,
    COUNT(p.id_pedido)      AS total_pedidos,
    SUM(p.total_sin_iva)    AS ventas_sin_iva,
    SUM(p.total_con_iva)    AS ventas_con_iva
FROM sedes s
LEFT JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede, s.ubicacion, s.encargado
ORDER BY total_pedidos DESC;

-- Consultar la vista
SELECT * FROM vista_resumen_pedidos_por_sede;

CREATE OR REPLACE VIEW vista_productos_bajo_stock AS
SELECT
    id_producto,
    nombre,
    categoria,
    precio,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS unidades_faltantes
FROM productos
WHERE stock_actual <= stock_minimo
ORDER BY unidades_faltantes DESC;

-- Consultar la vista
SELECT * FROM vista_productos_bajo_stock;


CREATE OR REPLACE VIEW vista_clientes_activos AS
SELECT
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo_electronico,
    COUNT(p.id_pedido)   AS total_pedidos,
    SUM(p.total_con_iva) AS total_comprado_con_iva
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre_completo,
    c.identificacion,
    c.telefono,
    c.correo_electronico
ORDER BY total_pedidos DESC;

-- Consultar la vista
SELECT * FROM vista_clientes_activos;

SELECT
    id_producto,
    nombre,
    categoria,
    stock_actual,
    stock_minimo,
    (stock_minimo - stock_actual) AS unidades_faltantes
FROM productos
WHERE stock_actual <= stock_minimo
ORDER BY unidades_faltantes DESC;

SELECT
    p.id_pedido,
    p.fecha_pedido,
    c.nombre_completo   AS cliente,
    s.nombre_sede       AS sede,
    p.total_sin_iva,
    p.total_con_iva
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN sedes    s ON p.id_sede    = s.id_sede
WHERE p.fecha_pedido BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY p.fecha_pedido ASC;


SELECT
    pr.id_producto,
    pr.nombre,
    pr.categoria,
    SUM(dp.cantidad)    AS total_unidades_vendidas,
    SUM(dp.subtotal)    AS total_ingresos
FROM productos pr
JOIN detalle_pedido dp ON pr.id_producto = dp.id_producto
GROUP BY pr.id_producto, pr.nombre, pr.categoria
ORDER BY total_unidades_vendidas DESC;


SELECT
    c.id_cliente,
    c.nombre_completo,
    c.telefono,
    COUNT(p.id_pedido)   AS cantidad_pedidos,
    SUM(p.total_con_iva) AS total_gastado
FROM clientes c
LEFT JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.telefono
ORDER BY cantidad_pedidos DESC;

SELECT
    id_cliente,
    nombre_completo,
    identificacion,
    telefono,
    correo_electronico
FROM clientes
WHERE nombre_completo LIKE '%super%'
   OR nombre_completo LIKE '%Super%';

-- Buscar por nombre parcial genérico (patrón flexible)
SELECT
    id_cliente,
    nombre_completo,
    identificacion,
    direccion,
    telefono
FROM clientes
WHERE nombre_completo LIKE '%mercado%'
   OR nombre_completo LIKE '%tienda%'
   OR nombre_completo LIKE '%distribui%';

SELECT
    id_producto,
    nombre,
    categoria,
    precio,
    volumen_ml,
    stock_actual
FROM productos
WHERE categoria IN ('Energizante', 'Hidratante', 'Agua')
ORDER BY categoria, precio DESC;



SELECT
    c.id_cliente,
    c.nombre_completo,
    c.telefono,
    c.correo_electronico,
    COUNT(p.id_pedido) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre_completo, c.telefono, c.correo_electronico
HAVING COUNT(p.id_pedido) = (
    -- Subconsulta: obtener el máximo de pedidos entre todos los clientes
    SELECT MAX(conteo)
    FROM (
        SELECT COUNT(id_pedido) AS conteo
        FROM pedidos
        GROUP BY id_cliente
    ) AS conteos
);


SELECT
    s.nombre_sede,
    s.ubicacion,
    s.encargado,
    COUNT(p.id_pedido)   AS total_pedidos,
    SUM(p.total_sin_iva) AS suma_sin_iva,
    SUM(p.total_con_iva) AS suma_con_iva,
    AVG(p.total_con_iva) AS promedio_por_pedido
FROM sedes s
JOIN pedidos p ON s.id_sede = p.id_sede
GROUP BY s.id_sede, s.nombre_sede, s.ubicacion, s.encargado
ORDER BY suma_con_iva DESC;