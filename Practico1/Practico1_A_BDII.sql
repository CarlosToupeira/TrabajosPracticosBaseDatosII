CREATE DATABASE universidad;

USE universidad;

/*Base de Datos de una Universidad*/

/*Tabla para los estudiantes*/

CREATE TABLE estudiantes (
id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50),
apellido VARCHAR(50),
fecha_nacimiento DATE NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL
);

/*Tabla para los cursos*/

CREATE TABLE cursos (
id_curso INT AUTO_INCREMENT PRIMARY KEY,
nombre_curso VARCHAR(100) NOT NULL
);

/*Tabla para las matriculas que relaciona los estudiantes con los cursos*/

CREATE TABLE matriculas (
id_matricula INT AUTO_INCREMENT PRIMARY KEY,
id_estudiante INT NOT NULL,
id_curso INT NOT NULL,
fecha_matricula DATE DEFAULT(CURRENT_DATE),
FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE CASCADE,
FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE CASCADE
);

/*Datos insertados por IA*/

-- Insertar estudiantes
INSERT INTO estudiantes (nombre, apellido, fecha_nacimiento, email) VALUES
('Juan', 'Pérez', '2000-05-14', 'juan.perez@example.com'),
('María', 'Gómez', '1999-08-22', 'maria.gomez@example.com');

-- Insertar cursos
INSERT INTO cursos (nombre_curso) VALUES
('Matemáticas'),
('Historia');

-- Inscribir estudiantes en cursos (matriculación)
INSERT INTO matriculas (id_estudiante, id_curso) VALUES
(1, 1), -- Juan Pérez en Matemáticas
(2, 2); -- María Gómez en Historia

/*Ejercicio 1: Reglas de Integridad*/
/*Si se elimina un estudiante con cursos inscritos se va a perder la referencia y su orden en las claves*/
/*Los mecanismos que se pueden implementar es eliminar en cascada (ON DELETE CASCADE) o en restrinccion (ON DELETE RESTRICT) desde la clave foránea en la tabla de matriculas*/

DROP TABLE matriculas;

CREATE TABLE matriculas (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante) ON DELETE RESTRICT,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso) ON DELETE RESTRICT
);

INSERT INTO matriculas (id_estudiante, id_curso) VALUES (999, 1);

/*Ejercicio 2: Implementacion de restricciones*/
/*
Cuando se inserta un dato que rompa las restricciones, falla mostrando el siguiente error:
INSERT INTO matriculas (id_estudiante, id_curso) VALUES (999, 1)
Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails (`universidad`.`matriculas`, CONSTRAINT `matriculas_ibfk_1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiantes` (`id_estudiante`) ON DELETE RESTRICT)
Lo que quiere decir que no se puede agregar o actualizar la fila debido a una falla en la clave foranea ya que hubo una restriccion que no se cumplio
*/