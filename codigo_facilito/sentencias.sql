DROP DATABASE IF EXISTS  libreria_cf;
CREATE DATABASE libreria_cf;

USE libreria_cf;


CREATE TABLE IF NOT EXISTS Autores( 

Author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
Nombre VARCHAR(50) NOT NULL,
Apellido VARCHAR(25) NOT NULL,
Seudonimo VARCHAR(50) UNIQUE,
Genero ENUM('M','F')  NOT NULL, 
Fecha_nacimiento DATE NOT NULL,
Pais_origen VARCHAR(40) NOT NULL,
Fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP   

);

CREATE TABLE Libros(
    Libro_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    Author_id INT UNSIGNED NOT NULL,
    Titulo VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(250),
    Paginas INTEGER UNSIGNED,
    Fecha_publicacion DATE NOT NULL,
    Fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Author_id) REFERENCES Autores(Author_id) 
);

INSERT INTO Autores (Nombre,Apellido,Seudonimo,Genero,Fecha_nacimiento,Pais_origen) 
VALUES ('Test Autor','Test apellido','X','M','1996-02-01','Mèxico' ),
       ('Codi','Facilito','Y','M','2018-01-01','México'),
       ('Héctor','Galvan','Z','M','1990-04-09','México'), 
       ('Joanne','Rowling','J. K. Rowling','F','1965-06-30','UK'),
       ('Stephen','King','Richard bachman','M','1947-09-27','USA');


INSERT INTO Libros(Author_id,Titulo,Fecha_publicacion)
VALUES  (4,'Carrie','1974-01-01'),
        (4,'El misterio de Salmes Lot','1975-01-01'),
        (4,'El resplandor','1975-01-01'),

        (5,'HP y la piedra filosofal','1997-06-30'),
        (5,'HP y la camara secreta','1998-07-02'),
        (5,'HP y el prisionero de Azkaban','1999-07-08'),
        (5,'HP y las Reliquias de la muerte','2007-07-23');


SELECT * FROM Autores;
SELECT * FROM Libros;

