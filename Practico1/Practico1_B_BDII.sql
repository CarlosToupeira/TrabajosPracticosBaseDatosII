CREATE DATABASE ventas;

USE ventas;

/*Base de datos con ventas mensuales por producto*/

/*Tabla de Productos*/
CREATE TABLE productos (
id_producto INT AUTO_INCREMENT PRIMARY KEY,
nombre_producto VARCHAR(100) NOT NULL,
categoria VARCHAR(50),
precio_unidad INT(10) NOT NULL
);

/*Tabla de Ventas*/
CREATE TABLE ventas (
id_venta INT AUTO_INCREMENT PRIMARY KEY,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
total INT(10) NOT NULL,
fecha_venta DATE NOT NULL,
FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Productos
INSERT INTO productos (nombre_producto, categoria, precio_unidad) VALUES
('Laptop', 'Tecnología', 1000.00),
('Smartphone', 'Tecnología', 800.00),
('Auriculares', 'Accesorios', 150.00),
('Mochila', 'Accesorios', 60.00),
('Tablet', 'Tecnología', 500.00);

-- Ventas (con distintas fechas)
INSERT INTO ventas (id_producto, cantidad, total, fecha_venta) VALUES
(1, 5, 5000.00, '2025-01-10'),
(2, 10, 8000.00, '2025-01-12'),
(3, 20, 3000.00, '2025-01-15'),
(1, 2, 2000.00, '2025-02-03'),
(4, 15, 900.00, '2025-02-10'),
(2, 5, 4000.00, '2025-02-12'),
(5, 7, 3500.00, '2025-03-01');

/*Ejercicio 5.A: Indices de rendimiento*/
/*Diseño de una consulta para ver multiples campos por indices y rendimiento*/
SELECT productos.nombre_producto, ventas.fecha_venta, ventas.cantidad, ventas.total FROM ventas JOIN productos ON ventas.id_producto = productos.id_producto
WHERE productos.categoria = 'Accesorios' AND ventas.fecha_venta BETWEEN '2025-01-01' AND '2025-02-11' AND ventas.cantidad >=16;

/*Ejercicio 5.B: Indices de rendimiento*/
/*Crear diferentes indices por rendimiento*/
CREATE INDEX indx_categoria ON productos(categoria);
CREATE INDEX indx_fecha_cantidad ON ventas(fecha_venta, cantidad);
CREATE INDEX indx_todo ON ventas(fecha_venta, cantidad, id_producto);

/*Ejercicio 6.A: Vistas*/
/*Crear una vista que resuma ventas mensuales por producto*/
CREATE VIEW resumen_ventas_mensuales AS
SELECT productos.id_producto, productos.nombre_producto, MONTH(ventas.fecha_venta) AS mes, YEAR(ventas.fecha_venta) AS anio, SUM(ventas.cantidad) AS total_unidades, SUM(ventas.total) AS total_ventas FROM ventas JOIN productos ON ventas.id_producto = productos.id_producto
GROUP BY productos.id_producto, mes, anio;

/*Ejercicio 6.B: Vistas*/
/*Consultar para que se devuelva los 5 productos mas vendidos*/
SELECT nombre_producto, SUM(total_unidades) AS unidades_totales FROM resumen_ventas_mensuales GROUP BY nombre_producto ORDER BY unidades_totales DESC limit 5;

/*Por si cargo mal algun dato*/
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;

/*Ejercicio 7 Gestion de permisos*/
CREATE USER 'analista'@'localhost' IDENTIFIED BY 'usuario_analista';

GRANT SELECT ON ventas.productos TO 'analista'@'localhost';
GRANT SELECT ON ventas.ventas TO 'analista'@'localhost';

SHOW GRANTS FOR 'analista'@'localhost';

/*Conectarse al usuario por simbolo del sistema (CMD) o powershell o cliente*/
/*mysql -u analista -p*/

SELECT * FROM ventas;

/*Probar un INSERT desde el usuario analista*/
INSERT INTO productos (nombre_producto, categoria, precio_unitario)
VALUES ('Impresora', 'Tecnología', 300.00);

/*Resultado luego del INSERT del usuario analista*/
/*ERROR 1142 (42000): INSERT command denied to user 'analista'@'localhost' for table 'productos'*/
/*Esto sucede porque el usuario solamente tiene permisos para leer tablas por lo que no puede modificar, eliminar ni añadir datos*/