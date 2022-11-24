/* ingredientes */
INSERT INTO ingrediente(id_ingrediente,nombre,stock,u_m,fecha_exp,valor_unitario) VALUES
(1,'aceite',20,'L','2023-01-01',2000),
(2,'sal',30,'kg','2024-01-01',200),
(3,'pan',47,'kg','2022-11-29',1500),
(4,'tocino',14,'kg','2022-12-18',1500),
(5,'huevo',52,'unidad','2022-12-07',100),
(6,'queso',20,'kg','2022-12-20',10000),
(7,'cebolla morada',21,'kg','2022-12-15',500),
(8,'tomate',18,'kg','2022-12-05',900),
(9,'lechuga',29,'unidad','2022-12-09',500),
(10,'vienesa',47,'kg','2022-12-28',3500),
(11,'palta',19,'kg','2022-12-14',1500),
(12,'chucrut',29,'kg','2022-12-13',1500),
(13,'papas prefritas',21,'kg','2022-12-28',2500),
(14,'mayonesa',15,'kg','2022-12-26',2300),
(15,'ketchup',14,'kg','2022-12-13',2500),
(16,'mostaza',16,'kg','2023-12-11',2000),
(17,'carne',20,'kg','2022-12-17',9000),
(18,'pollo',25,'kg','2022-12-22',4000),
(19,'jamon',18,'kg','2023-05-14',8500),
(20,'lomo',26,'kg','2023-03-18',10000),
(21,'coca-cola',30,'L','2022-12-18',1000),
(22,'sprite',29,'L','2022-12-24',1000),
(23,'fanta',27,'L','2022-12-1',1000),
(24,'kem',28,'L','2022-12-6',1000);


/* Hamburguesa1 y Hamburguesa2*/
INSERT INTO producto(id_producto,nombre,porcentaje_ganancia,tmp_preparacion) VALUES
(1234,'Hamburguesa1',20,20),
(1235,'Hamburguesa2',20,20);

/* relacion entre producto e ingredientes*/
INSERT INTO compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES
(1234,1,1),
(1234,2,3),
(1234,3,2),
(1234,4,3),
(1234,5,0.5),
(1234,6,2),
(1234,7,0.2),
(1234,8,0.2),
(1235,1,1),
(1235,2,4),
(1235,3,3),
(1235,4,4),
(1235,5,1),
(1235,6,2),
(1235,7,0.4),
(1235,8,0.4);

/* persona */
INSERT INTO cliente(RUT,nombre,apellido) VALUES
('20123456-7','Pedro','Perez'),
('87423982-8','Adel','GARCIA'),
('51986651-K','Adonis','RODRIGUEZ'),
('42957743-8','Ajaz','GONZALEZ'),
('18864263-2','Akos','FERNANDEZ'),
('  ','Aldo','LOPEZ'),
('12786274-5','Amets','MARTINEZ'),
('84464435-3','Amaro','SANCHEZ'),
('19373328-K','Aquiles','PEREZ'),
('32947945-5','Algimantas','GOMEZ');

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
(1,1234,18),
(1,1235,13),
(2,1234,26),
(2,1235,17),
(3,1234,11),
(3,1235,31),
(4,1234,2),
(4,1235,53),
(5,1234,58),
(5,1235,53),
(6,1234,16),
(6,1235,26),
(7,1234,21),
(7,1235,65),
(8,1234,28),
(8,1235,13),
(9,1234,14),
(9,1235,23),
(10,1234,16),
(10,1235,3);

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

INSERT INTO ocupa VALUES
(1,1,'20123456-7'),
(3,3,'51986651-K'),
(4,4,'42957743-8'),
(5,5,'18864263-2'),
(8,8,'84464435-3'),
(10,10,'32947945-5');
