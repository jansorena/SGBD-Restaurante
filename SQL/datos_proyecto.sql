/* ingredientes */
INSERT INTO ingrediente(id_ingrediente,nombre,stock,u_m,fecha_exp,valor_unitario) VALUES
(1,'aceite',20,'L','2023-01-01',2000),
(2,'sal',30,'kg','2024-01-01',200),
(3,'pan',50,'kg','2022-11-29',1500),
(4,'tocino',15,'kg','2022-12-18',1500),
(5,'huevo',120,'unidad','2022-12-07',100),
(6,'queso',20,'kg','2022-12-20',10000),
(7,'cebolla morada',21,'kg','2022-12-15',500),
(8,'tomate',20,'kg','2022-12-05',900),
(9,'lechuga',30,'unidad','2022-12-09',500),
(10,'vienesa',50,'kg','2022-12-28',3500),
(11,'palta',20,'kg','2022-12-14',1500),
(12,'chucrut',30,'kg','2022-12-13',1500),
(13,'papas prefritas',25,'kg','2022-12-28',2500),
(14,'mayonesa',35,'kg','2022-12-26',2300),
(15,'ketchup',25,'kg','2022-12-13',2500),
(16,'mostaza',35,'kg','2023-12-11',2000),
(17,'carne',20,'kg','2022-12-17',9000),
(18,'pollo',25,'kg','2022-12-22',4000),
(19,'jamon',20,'kg','2023-05-14',8500),
(20,'lomo',20,'kg','2023-03-18',10000),
(21,'coca-cola',30,'L','2022-12-18',1000),
(22,'sprite',30,'L','2022-12-24',1000),
(23,'fanta',30,'L','2022-12-1',1000),
(24,'kem',30,'L','2022-12-6',1000),
(25,'pan completo',50,'kg','2022-12-6',1600);

/* Hamburguesa1 y Hamburguesa2*/
INSERT INTO producto(id_producto,nombre,porcentaje_ganancia,tmp_preparacion) VALUES
(1231,'Hamburguesa1',35,15),
(1232,'Hamburguesa2',35,15),
(1233,'Hamburguesa Italiana',35,15),
(1234,'Barros Luco',35,10),

(1241,'Papas fritas chica',35,10),
(1242,'Papas fritas grande',35,10),
(1243,'Papas fritas familiar',35,10),

(1251,'Pichanga caliente para 2',35,25),
(1252,'Pichanga caliente mediana',35,25),
(1253,'Pichanga caliente familiar',35,25),

(1261,'Completo Italiano',35,25),
(1262,'Completo has',35,25),
(1263,'Completo has queso',35,25),

(23411,'coca-cola chica',35,25),
(23412,'coca-cola litro',35,25),
(23413,'coca-cola 1.5L',35,25),
(23421,'sprite chica',35,25),
(23422,'sprite litro',35,25),
(23423,'sprite 1.5L',35,25),
(23431,'fanta chica',35,25),
(23432,'fanta litro',35,25),
(23433,'fanta 1.5L',35,25),
(23441,'kem chica',35,25),
(23442,'kem litro',35,25),
(23443,'kem 1.5L',35,25);


/* relacion entre producto e ingredientes*/
INSERT INTO compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES
--Hamburguesa1
(1231,1,0.02),
(1231,2,0.03),
(1231,3,1),
(1231,4,0.08),
(1231,6,0.042),
(1231,7,0.03),
(1231,8,0.1),
(1231,9,0.05),
(1231,17,0.15),
--Hamburguesa2
(1232,1,0.02),
(1232,2,0.03),
(1232,3,1),
(1232,4,0.08),
(1232,5,1),
(1232,6,0.084),
(1232,7,0.03),
(1232,8,0.1),
(1232,9,0.05),
(1232,11,0.1),
(1232,17,0.2),
--Hamburguesa Italiana
(1233,1,0.02),
(1233,2,0.03),
(1233,3,1),
(1233,8,0.15),
(1233,11,0.15),
(1233,14,0.02),
(1233,17,0.15),
--Barros Luco
(1234,1,0.02),
(1234,2,0.03),
(1234,3,1),
(1234,17,0.15),
(1234,6,0.08),

--Papas fritas chica
(1241,1,0.1),
(1241,2,0.02),
(1241,13,0.25),
--Papas fritas grande
(1242,1,0.15),
(1242,2,0.04),
(1242,13,0.5),
--Papas fritas familiar
(1243,1,0.175),
(1243,2,0.06),
(1243,13,0.75),

--Pichanga caliente para 2
(1251,1,0.25),
(1251,2,0.12),
(1251,5,3),
(1251,6,0.25),
(1251,8,0.175),
(1251,10,0.25),
(1251,11,0.15),
(1251,13,0.3),
(1251,14,0.75),
(1251,15,0.75),
(1251,16,0.75),
(1251,17,0.15),
(1251,18,0.15),
--Pichanga caliente mediana
(1252,1,0.4),
(1252,2,0.2),
(1252,5,6),
(1252,6,0.4),
(1252,8,0.25),
(1252,10,0.5),
(1252,11,0.25),
(1252,13,0.5),
(1252,14,1.5),
(1252,15,1.5),
(1252,16,1.5),
(1252,17,0.25),
(1252,18,0.25),
--Pichanga caliente familiar
(1253,1,0.5),
(1253,2,0.35),
(1253,5,8),
(1253,6,0.6),
(1253,8,0.4),
(1253,10,0.75),
(1253,11,0.4),
(1253,13,0.65),
(1253,14,3),
(1253,15,2),
(1253,16,3),
(1253,17,0.4),
(1253,18,0.4),

--completo italiano
(1261,25,0.1),
(1261,10,0.1),
(1261,8,0.075),
(1261,11,0.075),
(1261,14,0.05),
--completo hass
(1262,25,0.1),
(1262,20,0.1),
(1262,8,0.075),
(1262,11,0.075),
(1262,14,0.05),
--completo hass
(1263,25,0.1),
(1263,20,0.1),
(1263,8,0.075),
(1263,11,0.075),
(1263,14,0.05),
(1263,6,0.1),

--coca-cola
(23411,21,0.33),
(23412,21,1),
(23413,21,1.5),
--sprite
(23421,22,0.33),
(23422,22,1),
(23423,22,1.5),
--fanta
(23431,23,0.33),
(23432,23,1),
(23433,23,1.5),
--kem
(23441,24,0.33),
(23442,24,1),
(23443,24,1.5);

/* mesa */
INSERT INTO mesa(num_mesa) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

/* trabajadores */
INSERT INTO trabajador(RUT,nombre,apellido,cargo,sueldo) VALUES
('84683876-7','Amrane','JIMENEZ','mesero','500000'),
('36967631-8','Anish','HERNANDEZ','lavaplatos','450000'),
('41535864-4','Arián','RUIZ','auxiliar de aseo','450000'),
('42472558-7','Ayun','DIAZ','gerente','850000'),
('45631924-6','Azariel','MORENO','bartender','700000'),
('37963643-8','Bagrat','MUÑOZ','portero','450000'),
('84123398-0','Bencomo','ALVAREZ','bodeguero','500000'),
('95548416-9','Bertino','ROMERO','administrador','7450000'),
('95283823-7','Candi','GUTIERREZ','cajero','450000'),
('87563488-7','Cesc','ALONSO','chef','650000');

INSERT INTO egreso VALUES
(1,CURRENT_DATE,'pago trabajador',500000),
(2,CURRENT_DATE,'pago trabajador',450000),
(3,CURRENT_DATE,'pago trabajador',450000),
(4,CURRENT_DATE,'pago trabajador',850000),
(5,CURRENT_DATE,'pago trabajador',700000),
(6,CURRENT_DATE,'pago trabajador',450000),
(7,CURRENT_DATE,'pago trabajador',500000),
(8,CURRENT_DATE,'pago trabajador',745000),
(9,CURRENT_DATE,'pago trabajador',450000),
(10,CURRENT_DATE,'pago trabajador',650000);

INSERT INTO pago_trabajador VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

/* persona */
INSERT INTO cliente(RUT,nombre,apellido) VALUES
('20123456-7','Pedro','Perez'),
('87423982-8','Adel','GARCIA'),
('51986651-K','Adonis','RODRIGUEZ'),
('42957743-8','Ajaz','GONZALEZ'),
('18864263-2','Akos','FERNANDEZ'),
('41152666-6','Aldo','LOPEZ'),
('12786274-5','Amets','MARTINEZ'),
('84464435-3','Amaro','SANCHEZ'),
('19373328-K','Aquiles','PEREZ'),
('32947945-5','Algimantas','GOMEZ');

INSERT INTO pedido (id_pedido,RUT) VALUES
(1,'20123456-7'),
(2,'87423982-8'),
(3,'51986651-K'),
(4,'42957743-8'),
(5,'18864263-2'),
(6,'41152666-6'),
(7,'12786274-5'),
(8,'84464435-3'),
(9,'19373328-K'),
(10,'32947945-5');

INSERT INTO tiene VALUES
(1,1231,2),
(1,1234,2),
(1,23422,1),
(1,1242,2),
(2,1232,2),
(2,1253,1),
(2,23413,1),
(3,1231,4),
(3,1252,4),
(4,1253,2),
(4,23433,1),
(4,23443,1),
(5,1243,2),
(5,1261,2),
(5,1262,2),
(5,1263,2),
(6,1233,2),
(6,1234,2),
(6,23422,1),
(6,1242,2),
(7,1234,2),
(7,1253,1),
(7,23413,1),
(8,1232,4),
(8,1252,4),
(9,1253,2),
(9,23433,1),
(9,23443,1),
(10,1243,2),
(10,1261,2),
(10,1262,2),
(10,1263,2);

INSERT INTO ocupa VALUES
(1,1,'20123456-7'),
(3,3,'51986651-K'),
(4,4,'42957743-8'),
(5,5,'18864263-2'),
(8,8,'84464435-3'),
(10,10,'32947945-5');

INSERT INTO boleta (id_boleta,id_pedido) VALUES
(1,1);

--update ingrediente set stock = 20 WHERE nombre = 'ketchup';