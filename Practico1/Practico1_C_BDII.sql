CREATE DATABASE empresa;

USE empresa;

CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100),
    telefono VARCHAR(20)
);

/*Ejercicio 8: Seguridad y Auditoría*/

CREATE TABLE auditoria_clientes (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    operacion VARCHAR(10),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nombre_anterior VARCHAR(100),
    correo_anterior VARCHAR(100),
    telefono_anterior VARCHAR(20)
);



/*Operacion para insertar|añadir clientes*/

DELIMITER $$

CREATE TRIGGER auditoria_insert
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_clientes (id_cliente, operacion)
    VALUES (NEW.id, 'INSERT');
END$$

DELIMITER ;



/*Operacion para actualizar clientes*/

DELIMITER $$

CREATE TRIGGER auditoria_update
BEFORE UPDATE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_clientes (
        id_cliente, operacion,
        nombre_anterior, correo_anterior, telefono_anterior
    ) VALUES (
        OLD.id, 'UPDATE',
        OLD.nombre, OLD.correo, OLD.telefono
    );
END$$

DELIMITER ;



/*Operacion para eliminar clientes*/

DELIMITER $$

CREATE TRIGGER auditoria_delete
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_clientes (
        id_cliente, operacion,
        nombre_anterior, correo_anterior, telefono_anterior
    ) VALUES (
        OLD.id, 'DELETE',
        OLD.nombre, OLD.correo, OLD.telefono
    );
END$$

DELIMITER ;



/*Simulacion de la auditoría*/

/*Insertar cliente*/
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Juan Pérez', 'juan@mail.com', '123456789');

/*Actualizar cliente*/
UPDATE clientes SET correo = 'juan.perez@gmail.com' WHERE id = 1;

/*Eliminar cliente*/
DELETE FROM clientes WHERE id = 1;

/*Consultar auditoría*/
SELECT * FROM auditoria_clientes;



/*Ejercicio 9: Backup y Restore de una base de datos*/

/*
Para empezar a realizar un backup de la base de datos "empresa", 
se puede utilizar el comando mysqldump desde la línea de comandos de MySQL:

mysqldump -u [(usuario) o (root)] -p empresa > backup_empresa.sql

Este comando crea un archivo SQL con toda la estructura y datos de la base de datos "empresa".
*/

/*Luego de guardar el backup, se simula la perdida de datos mediante el codigo de sql:*/
DROP DATABASE empresa;

/*
Como ultimo paso restauraremos la base de datos desde el backup creado anteriormente. 
Pero primero se crea nuevamente la base de datos:
*/
CREATE DATABASE empresa;

/*
Luego de haber creado nuevamente la base de datos,
se restaura la base de datos desde el archivo backup_empresa.sql mediante la consola de MySQL:
mysql -u [(usuario) o (root)] -p empresa < backup_empresa.sql
*/

/*Como paso final queda verificar si el backup se restauro como se debe mediante la muestra de las tablas:*/

USE empresa;

SELECT * FROM clientes;

SELECT * FROM auditoria_clientes;