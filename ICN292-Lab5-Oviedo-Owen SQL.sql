-- Crear base de datos
CREATE DATABASE andesbike;
USE andesbike;

-- Creación de tablas
Create Table tiendas (
id_tienda INT AUTO_INCREMENT Not NULL,
nom_tienda Varchar(40) Not Null,
comuna Varchar(40) NOT NULL,
Primary key (id_tienda)
);

Create Table empleado (
id_empleado INT AUTO_INCREMENT Not Null,
nom_empleado Varchar(40) Not Null,
id_tienda INT,
fecha Date,
Primary Key (id_empleado),
FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

Create Table bicicletas (
id_bicicleta INT AUTO_INCREMENT Not Null,
modelo Varchar(40) NOT NULL,
categoria ENUM('Eléctrica','Infantil','Montaña','Ruta','Urbana') NOT NULL,
precio DECIMAL(10,2) NOT NULL,
PRIMARY KEY (id_bicicleta)
);

CREATE TABLE ventas (
id_venta INT AUTO_INCREMENT NOT NULL,
id_empleado INT NOT NULL,
id_bicicleta INT NOT NULL,
fecha DATE NOT NULL,
cantidad INT NOT NULL,
PRIMARY KEY (id_venta),
FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
FOREIGN KEY (id_bicicleta) REFERENCES bicicletas(id_bicicleta)
);


-- Insertar información:
INSERT INTO tiendas (nom_tienda, comuna) 
VALUES
('Andes Providencia', 'Providencia'),
('Andes Maipú', 'Maipú'),
('Andes Concepción ', 'Concepción'),
('Andes La Serena', 'La Serena');
-- Visualizar tabla tiendas
SELECT * FROM tiendas;

INSERT INTO empleado (nom_empleado, id_tienda, fecha) 
VALUES
('Camila Ortiz', 1, '2024-06-20'),
('Diego Fuentes ', 1, '2024-01-15'),
('Javiera Soto', 2, '2023-07-24'),
('Matías Herrera', 2, '2024-01-15'),
('Paula Riquelme', 3, '2022-11-02'),
('Ignacio Vera', 3, '2024-08-19'),
('Fernanda Lillo', 1, '2025-02-03'),
('Rubén Castro', NULL, '2025-06-10');
SELECT * FROM empleado;

INSERT INTO bicicletas (modelo, categoria, precio) 
VALUES
('Cordillera 29', 'Montaña', 549990.00),
(' Ruta Austral', 'Ruta', 899990.00),
('Urbana Pro', 'Urbana', 329990.00),
('Pequeño Andes', 'Infantil', 149990.00),
('Volt City', 'Eléctrica', 1249990.00),
('Trail Master', 'Montaña', 749990.00),
('Urbana Lite', 'Urbana', 229990.00),
('Sprint R7', 'Ruta', 1099990.00);
SELECT * FROM bicicletas;

INSERT INTO ventas (id_empleado, id_bicicleta, fecha, cantidad) 
VALUES
( 1, 1, '2025-03-04', 2),
( 1, 3, '2025-03-18', 1),
( 1, 5, '2025-04-02', 1),
( 2, 2, '2025-03-04', 1),
( 2, 1, '2025-04-11', 3),
( 2, 7, '2025-05-06', 2),
( 3, 4, '2025-03-21', 4),
( 3, 3, '2025-04-15', 2),
( 3, 6, '2025-05-20', 1),
( 4, 1, '2025-03-27', 1),
( 4, 5, '2025-05-09', 2),
( 5, 2, '2025-04-08', 1),
( 5, 6, '2025-04-23', 2),
( 5, 4, '2025-06-02', 5),
( 6, 3, '2025-05-13', 3),
( 6, 7, '2025-06-17', 1),
( 6, 1, '2025-06-24', 2),
( 1, 6, '2025-06-30', 1);
SELECT * FROM ventas;

-- Consultas:
-- Consuta 1:
SELECT e.nom_empleado, COUNT(v.id_venta) AS cantidad
FROM empleado AS e
LEFT JOIN ventas AS v ON v.id_empleado = e.id_empleado
GROUP BY e.nom_empleado, e.id_empleado
ORDER BY cantidad DESC, e.nom_empleado;

-- Consuta 2:
SELECT t.nom_tienda, COUNT(v.id_empleado) AS Cantidad_de_ventas, SUM(v.cantidad) AS Cantidad_de_unidades
FROM ventas AS v
RIGHT JOIN empleado AS e ON v.id_empleado = e.id_empleado
RIGHT JOIN tiendas AS t ON t.id_tienda = e.id_tienda
GROUP BY t.nom_tienda
ORDER BY Cantidad_de_unidades DESC;

-- Consuta 3:
SELECT t.nom_tienda, e.nom_empleado
FROM tiendas AS t
LEFT JOIN empleado AS e ON e.id_tienda = t.id_tienda
WHERE nom_empleado IS NULL;

-- Consuta 4:
SELECT b.modelo
FROM bicicletas AS b
LEFT JOIN ventas AS v ON v.id_bicicleta = b.id_bicicleta AND v.fecha BETWEEN '2025-06-01' AND '2025-06-30'
WHERE v.fecha IS NULL;

-- Verificación de los modelos que no deben estar:
SELECT b.modelo, v.fecha
FROM bicicletas AS b
LEFT JOIN ventas AS v ON v.id_bicicleta = b.id_bicicleta
WHERE v.fecha BETWEEN '2025-06-01' AND '2025-06-30';


-- Consulta 5:
SELECT t.nom_tienda, e.nom_empleado, COUNT(v.id_venta) AS Cantidad_de_ventas
FROM  empleado AS e
LEFT JOIN ventas AS v ON v.id_empleado = e.id_empleado
LEFT JOIN tiendas AS t ON t.id_tienda = e.id_tienda
GROUP BY t.nom_tienda, e.nom_empleado
HAVING COUNT(v.id_venta) = 0;

-- Consulta 6:
SELECT e.nom_empleado, j.nom_empleado, e.fecha, j.fecha, t.nom_tienda
FROM empleado AS e
JOIN empleado AS j ON e.id_tienda = j.id_tienda AND e.fecha <= j.fecha AND e.id_empleado < j.id_empleado
JOIN tiendas AS t ON e.id_tienda = t.id_tienda;

-- Consulta 7:
SELECT t.nom_tienda, SUM(b.precio * v.cantidad) AS Monto_total 
FROM ventas AS v
JOIN bicicletas AS b ON b.id_bicicleta = v.id_bicicleta
JOIN empleado AS e ON e.id_empleado = v.id_empleado
JOIN tiendas AS t ON t.id_tienda = e.id_tienda
WHERE b.categoria IN ('Montaña', 'Ruta') 
GROUP BY t.nom_tienda
HAVING Monto_total > 2000000
ORDER BY Monto_total DESC;

-- Consulta 8:
SELECT modelo, precio
FROM bicicletas
WHERE precio > (SELECT AVG(precio) FROM bicicletas)
ORDER BY precio DESC;

-- Valor promedio 
SELECT AVG(precio) AS valor_promedio FROM bicicletas;

-- Consulta 9:
SELECT e.nom_empleado,  AVG(v.cantidad) AS Promedio
FROM empleado AS e
LEFT JOIN ventas AS v ON v.id_empleado = e.id_empleado
GROUP BY e.nom_empleado
HAVING Promedio > (SELECT AVG(cantidad) FROM ventas)
ORDER BY Promedio DESC, e.nom_empleado ASC;

-- Consulta 10:
SELECT e.nom_empleado,  IF(SUM(v.cantidad * b.precio) IS NULL, 0 , SUM(v.cantidad * b.precio)) AS Monto
FROM empleado AS e
LEFT JOIN ventas AS v ON v.id_empleado = e.id_empleado
LEFT JOIN bicicletas AS b ON b.id_bicicleta = v.id_bicicleta
GROUP BY e.nom_empleado
ORDER BY Monto DESC;




