# Gaseosas del Valle S.A. - Base de Datos Relacional

## Descripcion
Base de datos relacional en MySQL para gestionar productos, clientes, pedidos y sedes de la empresa Gaseosas del Valle S.A. El proyecto reemplaza el manejo en hojas de calculo. Se uso Aiven.io como servidor en la nube y DBeaver Community para ejecutar los scripts.

---

## Archivos del proyecto

| Archivo | Contenido |
|---|---|
| `database.sql` | Tablas, relaciones y datos de prueba |
| `functions.sql` | Funciones de IVA y validacion de stock |
| `triggers.sql` | Triggers de stock y auditoria de precios |
| `views_and_queries.sql` | Vistas y 8 consultas analiticas |

---

## Tablas

- sedes: puntos de distribucion de la empresa
- productos: catalogo de bebidas con precios y stock
- clientes: informacion de contacto de cada cliente
- pedidos: cabecera de cada venta registrada
- detalle_pedido: productos incluidos en cada pedido
- auditoria_precios: historial de cambios de precio

---

## Funciones

- fn_calcular_total_con_iva(id_pedido): suma los subtotales del pedido y aplica el 19% de IVA
- fn_validar_stock(id_producto, cantidad): verifica si hay stock suficiente antes de confirmar un pedido

---

## Triggers

- tr_actualizar_stock: descuenta el stock automaticamente cuando se inserta un detalle de pedido
- tr_auditar_cambio_precio: guarda en auditoria_precios el precio anterior y el nuevo cada vez que se actualiza un precio

---

## Vistas

- vista_resumen_pedidos_por_sede: total de pedidos y ventas agrupados por sede
- vista_productos_bajo_stock: productos con stock_actual menor o igual al stock_minimo
- vista_clientes_activos: clientes que tienen al menos un pedido registrado

---

## Orden de ejecucion

1. database.sql
2. functions.sql
3. triggers.sql
4. views_and_queries.sql

En DBeaver: seleccionar todo con Ctrl + A y ejecutar con Ctrl + Alt + X.

---

## Tecnologias usadas

- MySQL 8.x
- Aiven.io
- DBeaver Community
- Draw.io
- GitHub