
USE gaseosas_valle;

DELIMITER $$

CREATE FUNCTION fn_calcular_total_con_iva(p_id_pedido INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_sin_iva DECIMAL(12,2) DEFAULT 0.00;
    DECLARE v_total_con_iva DECIMAL(12,2) DEFAULT 0.00;

    -- Sumar todos los subtotales del pedido
    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_total_sin_iva
    FROM detalle_pedido
    WHERE id_pedido = p_id_pedido;

    -- Aplicar IVA del 19%
    SET v_total_con_iva = v_total_sin_iva * 1.19;

    RETURN v_total_con_iva;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION fn_validar_stock(p_id_producto INT, p_cantidad INT)
RETURNS VARCHAR(200)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_stock_actual  INT          DEFAULT 0;
    DECLARE v_nombre        VARCHAR(100) DEFAULT '';
    DECLARE v_mensaje       VARCHAR(200) DEFAULT '';

    -- Obtener nombre y stock actual del producto
    SELECT nombre, stock_actual
    INTO v_nombre, v_stock_actual
    FROM productos
    WHERE id_producto = p_id_producto;

    -- Verificar si el producto existe
    IF v_nombre = '' THEN
        SET v_mensaje = 'Error: el producto solicitado no existe en el sistema.';

    -- Verificar si hay suficiente stock
    ELSEIF v_stock_actual >= p_cantidad THEN
        SET v_mensaje = CONCAT(
            'Stock disponible. Puede pedir ',
            p_cantidad,
            ' unidades de ',
            v_nombre,
            '. Stock actual: ',
            v_stock_actual
        );
    ELSE
        SET v_mensaje = CONCAT(
            'Stock insuficiente. Solo hay ',
            v_stock_actual,
            ' unidades de ',
            v_nombre,
            ' disponibles.'
        );
    END IF;

    RETURN v_mensaje;
END$$

DELIMITER ;


-- Prueba 1: Calcular total con IVA del pedido 1
SELECT fn_calcular_total_con_iva(1) AS total_con_iva_pedido_1;

-- Prueba 2: Calcular total con IVA de todos los pedidos
SELECT
    id_pedido,
    fecha_pedido,
    total_sin_iva,
    total_con_iva                          AS total_con_iva_guardado,
    fn_calcular_total_con_iva(id_pedido)   AS total_con_iva_calculado
FROM pedidos
ORDER BY id_pedido;

-- Prueba 3: Validar stock suficiente (Coca-Cola, pedir 10 unidades)
SELECT fn_validar_stock(1, 10) AS resultado;

-- Prueba 4: Validar stock insuficiente (Red Bull, pedir 20 unidades)
SELECT fn_validar_stock(13, 20) AS resultado;

-- Prueba 5: Validar producto inexistente
SELECT fn_validar_stock(99, 5) AS resultado;

-- Prueba 6: Ver validación de stock para todos los productos
SELECT
    id_producto,
    nombre,
    stock_actual,
    fn_validar_stock(id_producto, 20) AS disponibilidad_para_20_unidades
FROM productos
ORDER BY id_producto;