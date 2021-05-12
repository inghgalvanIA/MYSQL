CREATE TABLE IF NOT EXISTS books (
    book_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    author_id INTEGER UNSIGNED,
    title VARCHAR(100) NOT NULL,
    year_book INTEGER UNSIGNED NOT NULL DEFAULT 1900,
    language_book VARCHAR(3) NOT NULL DEFAULT 'esp' COMMENT 'ISO 639-1 LENGUAJE',
    cover_url VARCHAR(500),
    price_book DOUBLE(6,2) NOT NULL DEFAULT 10.0,
    sellable TINYINT(1) DEFAULT 1,
    copies INTEGER NOT NULL DEFAULT 1,
    descriotion TEXT
);

CREATE TABLE IF NOt EXISTS authors (
    author_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(100) NOT NULL,
    nationality VARCHAR(3)   
);

CREATE TABLE IF NOT EXISTS clients (
    client_id INTEGER UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(60) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    birthdate DATETIME,
    gender ENUM('M','F','ND') NOT NULL,
    active TINYINT(1) NOT NULL DEFAULT 1,
    create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP  ON UPDATE CURRENT_TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS operations(
    operation_id INTEGER UNSIGNED NOT NULL  AUTO_INCREMENT,
    book_id ,
    client_id,
    operation_type,
    creates_at,
    update_at,
    finshed TINYINT(1) NOT NULL
);

INSERT INTO authors (name_author,nationality) VALUES ('Juan Rulfo','MEX');

INSERT INTO authors(name_author,nationality) VALUES ('Gabriel Garcia Màrquez','COL');

INSERT INTO authors (name_author,nationality) VALUES ('Juan Gabriel Vasquez','COL');

VALUES (NULL, ‘Juan Rulfo’, ‘MEX’);

INSERT INTO authors (name_author,nationality) VALUES 
    ('Julio Cortazar','ARG'),
    ('Isabel allende', 'CHI'),
    ('Octavio Paz', 'MEX');

INSERT INTO authors (author_id,name_author,nationality) VALUES ('7','Pablo Neruda','CHI');

INSERT INTO `clients`(client_id, name_client, email, birthdate, gender, active) VALUES
	(1,'Maria Dolores Gomez','Maria Dolores.95983222J@random.names','1971-06-06','F',1),
	(2,'Adrian Fernandez','Adrian.55818851J@random.names','1970-04-09','M',1),
	(3,'Maria Luisa Marin','Maria Luisa.83726282A@random.names','1957-07-30','F',1),
	(4,'Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1);

    select * from clients where client_id = 4;

    select * from clients where client_id = 4\G

INSERT INTO clients (name_client, email, birthdate, gender, active) values ('Pedro Sanchez','Pedro.78522059J@random.names','1992-01-31','M',1)
ON DUPLICATE KEY UPDATE  activate = VALUES(activate);

INSERT INTO books(title, author_id) VALUES('El laberitno de la soledad',6)

select * from authors where name_author = 'Octavio Paz'

select * from books\G

INSERT INTO books (title,author_id,year_book)
VALUES ('Vuelta al laberinto de la soledad',
    (SELECT author_id FROM authors
    WHERE name_author = 'Octavio Paz'
    LIMIT 1
    ), 1960
);

--nos arroje los clientes
SELECT name FROM clients;

-- nos arroja columnas name, email y gender
SELECT name, email, gender FROM clients;

--nnos arrojara las columnas simepre y cuando genero sea m
SELECT name,email,gender FROM clients WHERE gender = 'M';

--nos arroja el tiempo actuañ
SELECT NOW();

--obtener la edad ccon la resta de año actuaal , año nacimeinto cliente
SELECT name, email, YEAR(NOW()) - YEAR(birthdate) FROM clients;

--filtrar por elnombre name que tenga Lop en su nombre
SELECT name, email, YEAR(NOW()) - YEAR(birthdate) AS edad, gender
FROM clients
WHERE gender='F'
    AND name LIKE '%Lop%';

--sumar toda la tupla de cada tabla
SELECT COUNT(*) FROM books;

--solo seleccionar las primeras 5 tuplas

SELECT * FROM authors WHERE author_id > 0 and author_id <= 5;

SELECT * FROM books WHERE author_id BETWEEN 1 AND 5;

-- Listar todos los autores con ID entre 1 y 5 con los filtro mayor y menor igual
SELECT * FROM authors WHERE author_id > 0 AND author_id <= 5;

-- Listar todos los autores con ID entre 1 y 5 con el filtro BETWEEN
SELECT * FROM authors WHERE author_id BETWEEN 1 AND 5;

-- Listar los libros con filtro de author_id entre 1 y 5
SELECT book_id, author_id, title FROM books WHERE author_id BETWEEN 1 AND 5;

-- Listar nombre y titulo de libros mediante el JOIN de las tablas books y authors
SELECT b.book_id, a.name, a.author_id, b.title
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
WHERE a.author_id BETWEEN 1 AND 5;

-- Listar transactions con detalle de nombre, titulo y tipo. Con los filtro genero = F y tipo = Vendido.
-- Haciendo join entre transactions, books y clients.
SELECT c.name, b.title, t.type
FROM transactions AS t
JOIN books AS b
  ON t.book_id = b.book_id
JOIN clients AS c
  ON t.client_id = c.client_id
WHERE c.gender = 'F'
  AND t.type = 'sell';

-- Listar transactions con detalle de nombre, titulo, autoor y tipo. Con los filtro genero = M y de tipo = Vendido y Devuelto.
-- Haciendo join entre transactions, books, clients y authors.
SELECT c.name, b.title, a.name, t.type
FROM transactions AS t
JOIN books AS b
  ON t.book_id = b.book_id
JOIN clients AS c
  ON t.client_id = c.client_id
JOIN authors AS a
  ON b.author_id = a.author_id
WHERE c.gender = 'M'
  AND t.type IN ('sell', 'lend');

   Uso del JOIN implícito
SELECT b.title, a.name
FROM authors AS a, books AS b
WHERE a.author_id = b.author_id
LIMIT 10;

-- Uso del JOIN explícito
SELECT b.title, a.name
FROM books AS b
INNER JOIN authors AS a
  ON a.author_id = b.author_id
LIMIT 10;

--  JOIN y order by (por defecto es ASC)
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a
JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id DESC;

-- LEFT JOIN para traer datos incluso que no existen, como el caso del author_id = 4 que no tene ningún libro registrado.
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a
LEFT JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id;

-- Contar número de libros tiene un autor.
-- Con COUNT (contar), es necesario tener un GROUP BY (agrupado por un criterio)
SELECT a.author_id, a.name, a.nationality, COUNT(b.book_id)
FROM authors AS a
LEFT JOIN books AS b
  ON b.author_id = a.author_id
WHERE a.author_id BETWEEN 1 AND 5
GROUP BY a.author_id

--seleccion solo las diferentes opciones de nacionalidad

SELECT DISTINCT nationality FROM authors;

--nacionalidades ordenadas en ascendente

SELECT DISTINCT nationality FROM authors ORDER BY nationality;

--contar el numeor de veces que se repite una nacionalidad

SELECT nationality, COUNT(author_id) AS c_authors
FROM authors
GROUP BY nationality
ORDER BY c_authors DESC nationality;

-- 1. ¿Qué nacionalidades hay?
-- Mediante la clausula DISTINCT trae solo los elementos distintos
SELECT DISTINCT nationality 
FROM authors
ORDER BY 1;

-- 2. ¿Cuántos escritores hay de cada nacionalidad?
-- IS NOT NULL para traer solo los valores diferentes de nulo
-- NOT IN para traer valores que no sean los declarados (RUS y AUT)
SELECT nationality, COUNT(author_id) AS c_authors
FROM authors
WHERE nationality IS NOT NULL
	AND nationality NOT IN ('RUS','AUT')
GROUP BY nationality
ORDER BY c_authors DESC, nationality ASC;

-- 4. ¿Cuál es el promedio/desviación standard del precio de libros?
SELECT a.nationality,  
  AVG(b.price) AS promedio, 
  STDDEV(b.price) AS std 
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
GROUP BY a.nationality
ORDER BY promedio DESC;

-- 5. ¿Cuál es el promedio/desviación standard del precio de libros por nacionalidad?
-- Agrupar por la columna pivot
SELECT a.nationality,
  COUNT(b.book_id) AS libros,  
  AVG(b.price) AS promedio, 
  STDDEV(b.price) AS std 
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
GROUP BY a.nationality
ORDER BY libros DESC;

-- 6. ¿Cuál es el precio máximo/mínimo de un libro?
SELECT nationality, MAX(price), MIN(price)
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
GROUP BY nationality;

-- 7. ¿cómo quedaría el reporte de préstamos?
-- CONCAT: para concatenar en cadenas de texto.
-- TO_DAYS: recibe un timestamp ó un datetime
SELECT c.name, t.type, b.title, 
  CONCAT(a.name, " (", a.nationality, ")") AS autor,
  TO_DAYS(NOW()) - TO_DAYS(t.created_at)
FROM transactions AS t
LEFT JOIN clients AS c
  ON c.client_id = t.client_id
LEFT JOIN books AS b
  ON b.book_id = t.book_id
LEFT JOIN authors AS a
  ON b.author_id = a.author_id;

  --Borrar 

  DELETE FROM authors WHERE author_id = 16 LIMIT 30;

  --ACTUALIZAR

  UPDATE clients
  SET active = 0
  WHERE client_id IN (1,6,8,12,90)
  OR NAME LIKE %Lopez%