
USE gaseosas_valle;


DELIMITER $$

CREATE TRIGGER tr_actualizar_stock
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    -- Descontar del stock la cantidad vendida
    UPDATE productos
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER tr_auditar_cambio_precio
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
    -- Solo registrar si el precio realmente cambió
    IF OLD.precio <> NEW.precio THEN
        INSERT INTO auditoria_precios (
            id_producto,
            precio_anterior,
            precio_nuevo,
            fecha_cambio
        ) VALUES (
            OLD.id_producto,
            OLD.precio,
            NEW.precio,
            NOW()
        );
    END IF;
END$$

DELIMITER ;

-- Ver stock actual antes de insertar
SELECT id_producto, nombre, stock_actual
FROM productos
WHERE id_producto IN (1, 4);


INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal)
VALUES (12, 1, 5, 14000.00);

-- Verificar que el stock se descontó automáticamente
SELECT id_producto, nombre, stock_actual
FROM productos
WHERE id_producto = 1;


SELECT id_producto, nombre, precio
FROM productos
WHERE id_producto = 1;


UPDATE productos
SET precio = 3000.00
WHERE id_producto = 1;

SELECT
    ap.id_auditoria,
    p.nombre           AS producto,
    ap.precio_anterior,
    ap.precio_nuevo,
    ap.fecha_cambio
FROM auditoria_precios ap
JOIN productos p ON ap.id_producto = p.id_producto
ORDER BY ap.fecha_cambio DESC;


UPDATE productos SET precio = 3200.00 WHERE id_producto = 1;
UPDATE productos SET precio = 2900.00 WHERE id_producto = 14;


SELECT
    ap.id_auditoria,
    p.nombre           AS producto,
    ap.precio_anterior,
    ap.precio_nuevo,
    (ap.precio_nuevo - ap.precio_anterior) AS diferencia,
    ap.fecha_cambio
FROM auditoria_precios ap
JOIN productos p ON ap.id_producto = p.id_producto
ORDER BY ap.fecha_cambio DESC;