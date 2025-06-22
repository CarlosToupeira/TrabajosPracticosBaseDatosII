/*Ejercicio 3: Concurrencia*/

CREATE DATABASE banco;
USE banco;

CREATE TABLE cuentas (
    id INT PRIMARY KEY,
    titular VARCHAR(50),
    saldo DECIMAL(10,2)
);

INSERT INTO cuentas (id, titular, saldo)
VALUES (1, 'Romina', 1000.00);

/*Nivel de aislamiento Read committed*/

/*Primer transaccion Read committed*/
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

SELECT saldo FROM cuentas WHERE id = 1;

UPDATE cuentas SET saldo = saldo + 100 WHERE id = 1;

/*No hacer commit hasta la segunda transaccion*/

COMMIT;

/*Segunda transaccion Read committed*/
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

SELECT saldo FROM cuentas WHERE id = 1;

UPDATE cuentas SET saldo = saldo + 50 WHERE id = 1;

/*Ahora hacemos COMMIT*/

COMMIT;

/*Comportamiento Read committed*/

/*
Podrías terminar con saldo= 1150, si la segunda transacción sobrescribe el valor inicial (1000 + 50), 
y luego la primera agrega 100 más a ese mismo 1000 (llevándolo a 1100), se pierde un update
*/


/*Nivel de aislamiento Serializable*/

/*Primer transaccion con Serializable*/

SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;

SELECT saldo FROM cuentas WHERE id = 1;

UPDATE cuentas SET saldo = saldo + 100 WHERE id = 1;

/*No hacer commit hasta la segunda transaccion*/

COMMIT;

/*Segunda transaccion Serializable*/
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

SELECT saldo FROM cuentas WHERE id = 1;

UPDATE cuentas SET saldo = saldo + 50 WHERE id = 1;

/*Ahora hacemos COMMIT*/

COMMIT;


/*Verifica el resultado*/

SELECT * FROM cuentas;



/*Comportamiento Serializable*/

/*
En este caso, la segunda transacción no puede leer el saldo actualizado por la primera transacción hasta que esta última haga commit.
Por lo tanto, la segunda transacción verá el saldo original (1000) y podrá actualizarlo a 1050 sin interferencias.
Esto garantiza que las transacciones se ejecuten de manera aislada, evitando problemas de concurrencia y evitar que se lea el mismo valor.
*/