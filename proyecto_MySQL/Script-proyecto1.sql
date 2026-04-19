
CREATE DATABASE IF NOT EXISTS gaseosas_valle
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE gaseosas_valle;


CREATE TABLE IF NOT EXISTS sedes (
    id_sede                INT          NOT NULL AUTO_INCREMENT,
    nombre_sede            VARCHAR(100) NOT NULL,
    ubicacion              VARCHAR(200) NOT NULL,
    capacidad_almacenamiento INT        NOT NULL COMMENT 'Capacidad en unidades',
    encargado              VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_sede)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
    id_producto    INT            NOT NULL AUTO_INCREMENT,
    nombre         VARCHAR(100)   NOT NULL,
    categoria      VARCHAR(60)    NOT NULL,
    precio         DECIMAL(10,2)  NOT NULL,
    volumen_ml     INT            NOT NULL COMMENT 'Volumen en mililitros',
    stock_actual   INT            NOT NULL DEFAULT 0,
    stock_minimo   INT            NOT NULL DEFAULT 10,
    PRIMARY KEY (id_producto)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS clientes (
    id_cliente          INT          NOT NULL AUTO_INCREMENT,
    nombre_completo     VARCHAR(150) NOT NULL,
    identificacion      VARCHAR(20)  NOT NULL UNIQUE,
    direccion           VARCHAR(200) NOT NULL,
    telefono            VARCHAR(20)  NOT NULL,
    correo_electronico  VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_cliente)
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS auditoria_precios (
    id_auditoria   INT           NOT NULL AUTO_INCREMENT,
    id_producto    INT           NOT NULL,
    precio_anterior DECIMAL(10,2) NOT NULL,
    precio_nuevo   DECIMAL(10,2) NOT NULL,
    fecha_cambio   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_auditoria),
    CONSTRAINT fk_auditoria_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido       INT            NOT NULL AUTO_INCREMENT,
    fecha_pedido    DATE           NOT NULL,
    id_cliente      INT            NOT NULL,
    id_sede         INT            NOT NULL,
    total_sin_iva   DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    total_con_iva   DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_sede
        FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle  INT           NOT NULL AUTO_INCREMENT,
    id_pedido   INT           NOT NULL,
    id_producto INT           NOT NULL,
    cantidad    INT           NOT NULL,
    subtotal    DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id_detalle),
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

INSERT INTO sedes (nombre_sede, ubicacion, capacidad_almacenamiento, encargado) VALUES
('Sede Principal Girón',      'Calle 5 # 12-30, Girón, Santander',         5000, 'Carlos Andrés Rojas'),
('Sede Norte Bucaramanga',    'Av. Quebradaseca # 45-10, Bucaramanga',      3500, 'Luisa Fernanda Méndez'),
('Sede Sur Piedecuesta',      'Carrera 9 # 8-55, Piedecuesta, Santander',  2800, 'Jorge Iván Castillo');

INSERT INTO productos (nombre, categoria, precio, volumen_ml, stock_actual, stock_minimo) VALUES
('Coca-Cola Original',        'Cola',          2800.00,  350,  120, 20),
('Coca-Cola Zero',            'Cola',          2800.00,  350,   85, 20),
('Pepsi Regular',             'Cola',          2600.00,  350,   60, 20),
('Sprite Limón',              'Sin Cola',      2700.00,  350,   95, 20),
('Fanta Naranja',             'Sin Cola',      2700.00,  350,   40, 20),
('Postobón Uva',              'Sin Cola',      2400.00,  350,   15, 20),
('Postobón Manzana',          'Sin Cola',      2400.00,  350,   18, 20),
('Agua Crystal 600ml',        'Agua',          1800.00,  600,  200, 30),
('Agua Cristal 1500ml',       'Agua',          3200.00, 1500,  110, 25),
('Gatorade Naranja',          'Hidratante',    4500.00,  500,   50, 15),
('Gatorade Maracuyá',         'Hidratante',    4500.00,  500,   30, 15),
('Monster Energy Original',   'Energizante',   6800.00,  473,   22, 10),
('Red Bull 250ml',            'Energizante',   7500.00,  250,   8,  10),
('Coca-Cola 1.5L',            'Cola',          6500.00, 1500,   55, 15),
('Pepsi 1.5L',                'Cola',          6000.00, 1500,   35, 15);

INSERT INTO clientes (nombre_completo, identificacion, direccion, telefono, correo_electronico) VALUES
('Tienda El Buen Sabor',       '800123456-1', 'Cra 10 # 5-20, Girón',            '6077112233', 'buensabor@correo.com'),
('Supermercado Los Andes',     '900234567-2', 'Cl 15 # 22-40, Bucaramanga',       '6077445566', 'losandes@correo.com'),
('Cafetería Central Girón',    '1098765432',  'Cl 6 # 10-12, Girón',              '3155678901', 'cafcentral@gmail.com'),
('Restaurante La Fogata',      '1087654321',  'Av. Los Industriales # 3-15, Buca','3164567890', 'lafogata@hotmail.com'),
('Minimercado San José',       '1076543210',  'Cra 7 # 2-30, Piedecuesta',        '3173456789', 'sanjose@yahoo.com'),
('Distribuidora Norte SAS',    '900345678-3', 'Cl 45 # 30-10, Bucaramanga',       '6077889900', 'dnorte@empresa.com'),
('Papelería y Miscelánea Lucy','1065432109',  'Cra 12 # 8-40, Girón',             '3182345678', 'lucy.misc@gmail.com'),
('Hotel Dann Carlton BGA',     '800456789-4', 'Cl 34 # 31-24, Bucaramanga',       '6076001234', 'compras@danncarlton.com');

INSERT INTO pedidos (fecha_pedido, id_cliente, id_sede, total_sin_iva, total_con_iva) VALUES
('2025-01-10', 1, 1,  56000.00,  66640.00),
('2025-01-15', 2, 2,  84000.00,  99960.00),
('2025-02-03', 3, 1,  32400.00,  38556.00),
('2025-02-18', 4, 2,  67500.00,  80325.00),
('2025-03-05', 5, 3,  24000.00,  28560.00),
('2025-03-12', 1, 1,  45600.00,  54264.00),
('2025-03-20', 6, 2,  96000.00, 114240.00),
('2025-04-01', 7, 3,  21600.00,  25704.00),
('2025-04-10', 2, 2, 108000.00, 128520.00),
('2025-04-22', 8, 1,  75000.00,  89250.00),
('2025-05-03', 3, 1,  48000.00,  57120.00),
('2025-05-15', 1, 2,  36000.00,  42840.00);

INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES
-- Pedido 1
(1, 1, 10, 28000.00),
(1, 8, 10, 18000.00),
(1, 4,  5, 13500.00),
-- Pedido 2
(2, 14,  5, 32500.00),
(2, 10,  6, 27000.00),
(2, 9,   8, 25600.00),
-- Pedido 3
(3, 6,  10, 24000.00),
(3, 7,   5, 12000.00),
-- Pedido 4
(4, 12,  4, 27200.00),
(4, 13,  2, 15000.00),
(4, 11,  5, 22500.00),
-- Pedido 5
(5, 3,   5, 13000.00),
(5, 8,   7, 12600.00),
-- Pedido 6
(6, 1,   8, 22400.00),
(6, 2,   8, 22400.00),
-- Pedido 7
(7, 14, 10, 65000.00),
(7, 9,   5, 16000.00),
(7, 10,  4, 18000.00),
-- Pedido 8
(8, 6,   9, 21600.00),
-- Pedido 9
(9, 1,  15, 42000.00),
(9, 2,  10, 28000.00),
(9, 15,  6, 36000.00),
-- Pedido 10
(10, 12, 3, 20400.00),
(10, 13, 4, 30000.00),
(10, 10, 3, 13500.00),
-- Pedido 11
(11, 4, 10, 27000.00),
(11, 5,  8, 21600.00),
-- Pedido 12
(12, 8, 10, 18000.00),
(12, 9,  6, 19200.00);