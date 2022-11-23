/* ingredientes */
INSERT INTO ingrediente(id_ingrediente,nombre,stock,u_m,fecha_exp,valor_unitario) VALUES
(1,'pan',50,'unidad','2022-10-25',200),
(2,'tocino',400,'unidad','2022-10-25',300),
(3,'huevo',34,'unidad','2022-10-25',100),
(4,'queso',56,'unidad','2022-10-25',150),
(5,'carne',200,'kg','2022-10-25',2000),
(6,'cebolla morada',100,'unidad','2022-10-25',400),
(7,'tomate',30,'kg','2022-10-25',800),
(8,'lechuga',28,'kg','2022-10-25',1000),
(9,'aceite',20,'L','2022-10-25',2500);

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
('41152666-6','Aldo','LOPEZ'),
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