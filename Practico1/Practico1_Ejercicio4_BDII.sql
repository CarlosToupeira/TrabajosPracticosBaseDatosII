CREATE DATABASE IF NOT EXISTS prueba_indices;
USE prueba_indices;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    email VARCHAR(100),
    ciudad VARCHAR(50),
    edad INT
);

/*Insertar 100,000 registros (función hecha por IA)*/

DELIMITER $$

CREATE PROCEDURE insertar_clientes()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100000 DO
        INSERT INTO clientes (nombre, apellido, email, ciudad, edad)
        VALUES (
            CONCAT('Nombre', i),
            CONCAT('Apellido', i),
            CONCAT('nombre', i, '@correo.com'),
            ELT(1 + RAND() * 4, 'Buenos Aires', 'Córdoba', 'Rosario', 'Mendoza'),
            FLOOR(18 + RAND() * 63)
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL insertar_clientes();


/*Ejercicio 4.A: Indices de rendimiento*/
/*Consulta sin índice*/
EXPLAIN SELECT * FROM clientes WHERE ciudad = 'Buenos Aires';

/*El secuential scan debe recorrer toda la tabla para terminar*/


/*Ejercicio 4.B: Indices de rendimiento*/
/*Consulta con índice*/

CREATE INDEX indice_ciudad ON clientes(ciudad);

EXPLAIN SELECT * FROM clientes WHERE ciudad = 'Buenos Aires';

/*
El índice permite que la consulta sea más eficiente, 
ya que el motor de la base de datos puede buscar directamente en el índice en lugar de escanear toda la tabla
*/