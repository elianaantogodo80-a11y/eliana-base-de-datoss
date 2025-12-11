CREATE TABLE mesas (
id SERIAL PRIMARY KEY,
numero INT NOT NULL UNIQUE,
capacidad INT NOT NULL,
activa BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE clientes (
id SERIAL PRIMARY KEY,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
telefono VARCHAR(20),
email VARCHAR(100),
activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE empleados (
id SERIAL PRIMARY KEY,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
cargo VARCHAR(50) NOT NULL DEFAULT 'mesero',
activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE comandas (
id SERIAL PRIMARY KEY,
id_mesa INT NOT NULL,
id_cliente INT,
id_mesero INT,
fecha_apertura TIMESTAMP,
fecha_cierre TIMESTAMP,
estado VARCHAR(20) NOT NULL DEFAULT 'abierta',
total_final NUMERIC(10,2) DEFAULT 0,

CONSTRAINT fk_comanda_mesa FOREIGN KEY (id_mesa)
REFERENCES mesas(id)ON DELETE RESTRICT ON UPDATE CASCADE,

CONSTRAINT fk_comanda_cliente FOREIGN KEY (id_cliente)
REFERENCES clientes(id) ON DELETE SET NULL ON UPDATE CASCADE,

CONSTRAINT fk_comanda_mesero FOREIGN KEY (id_mesero)
REFERENCES empleados(id)ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE productos (
id SERIAL PRIMARY KEY,
nombre VARCHAR(100) NOT NULL UNIQUE,
categoria VARCHAR(50) NOT NULL,
precio NUMERIC(10,2) NOT NULL,
activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE detalle_comanda (
id SERIAL PRIMARY KEY,
id_comanda INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
precio_unitario NUMERIC(10,2) NOT NULL,

CONSTRAINT fk_detalle_comanda FOREIGN KEY (id_comanda)
REFERENCES comandas(id) ON DELETE CASCADE ON UPDATE CASCADE,

CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto)
REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE pagos (
id SERIAL PRIMARY KEY,
id_comanda INT NOT NULL,
fecha TIMESTAMP,
metodo VARCHAR(20) NOT NULL,
monto NUMERIC(10,2) NOT NULL,

CONSTRAINT fk_pago_comanda FOREIGN KEY (id_comanda)
REFERENCES comandas(id) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO mesas (numero, capacidad) VALUES
(1, 4),
(2, 2),
(3, 6);

INSERT INTO clientes (nombres, apellidos, telefono, email) VALUES
('Juan', 'Pérez', '0414-1111111', 'juanperez@mail.com'),
('María', 'Gómez', '0412-2222222', 'mariagomez@mail.com'),
('Carlos', 'Soto', '0416-3333333', 'carlossoto@mail.com');

INSERT INTO empleados (nombres, apellidos, cargo) VALUES
('Ana', 'Rojas', 'mesero'),
('Luis', 'Martínez', 'mesero'),
('Pedro', 'Ramírez', 'cajero');

INSERT INTO productos (nombre, categoria, precio) VALUES
('Pizza Margarita', 'Comida', 8.50),
('Hamburguesa Clásica', 'Comida', 6.00),
('Coca-Cola 350ml', 'Bebida', 1.50),
('Jugo Natural', 'Bebida', 2.00),
('Tiramisú', 'Postre', 4.00);

INSERT INTO comandas (id_mesa, id_cliente, id_mesero, fecha_apertura, estado) VALUES
(1, 1, 1, CURRENT_TIMESTAMP - INTERVAL '2 hours', 'abierta'),
(2, 2, 2, CURRENT_TIMESTAMP - INTERVAL '1 hour', 'abierta'),
(3, 3, 1, CURRENT_TIMESTAMP - INTERVAL '3 hours', 'cerrada');

INSERT INTO detalle_comanda (id_comanda, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 8.50), -- 2 Pizzas Margarita
(1, 3, 3, 1.50); -- 3 Coca-Cola

INSERT INTO detalle_comanda (id_comanda, id_producto, cantidad, precio_unitario) VALUES
(2, 2, 1, 6.00), -- 1 Hamburguesa
(2, 4, 2, 2.00); -- 2 Jugos Naturales

INSERT INTO detalle_comanda (id_comanda, id_producto, cantidad, precio_unitario) VALUES
(3, 1, 1, 8.50), -- 1 Pizza Margarita
(3, 5, 2, 4.00); -- 2 Tiramisú

INSERT INTO pagos (id_comanda, fecha, metodo, monto) VALUES
(3, CURRENT_TIMESTAMP - INTERVAL '30 minutes', 'tarjeta', 16.50);

SELECT * FROM mesas;

SELECT * FROM clientes;

SELECT * FROM empleados;

SELECT * FROM comandas;

SELECT * FROM productos;

SELECT * FROM detalle_comanda;

SELECT * FROM pagos;

SELECT
    c.id AS comanda,
    cl.nombres || ' ' || cl.apellidos AS cliente,
    m.numero AS mesa,
    e.nombres || ' ' || e.apellidos AS mesero,
    c.fecha_apertura,
    c.estado,
    p.nombre AS producto,
    dc.cantidad,
    dc.precio_unitario,
    (dc.cantidad * dc.precio_unitario) AS subtotal
FROM comandas c
JOIN clientes cl ON c.id_cliente = cl.id
JOIN mesas m ON c.id_mesa = m.id
JOIN empleados e ON c.id_mesero = e.id
JOIN detalle_comanda dc ON c.id = dc.id_comanda
JOIN productos p ON dc.id_producto = p.id
WHERE c.id = 1;



