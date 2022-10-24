/* ingredientes */
INSERT INTO ingrediente(id_ingrediente,nombre,stock,u_m,fecha_exp,valor_unitario) VALUES
(1,'pan',50,'unidad','2022-10-25',200),
(2,'tocino',400,'unidad','2022-10-25',300),
(3,'huevo',34,'unidad','2022-10-25',100),
(4,'queso',56,'unidad','2022-10-25',150),
(5,'carne',200,'kg','2022-10-25',2000),
(6,'cebolla morada',100,'unidad','2022-10-25',400),
(7,'tomate',30,'kg','2022-10-25',800),
(8,'lechuga',28,'kg','2022-10-25',1000);

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
INSERT INTO persona(RUT,nombre,apellido) VALUES
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
INSERT INTO trabajador(RUT,cargo,sueldo) VALUES
('20123456-7','mesero','500000'),
('87423982-8','lavaplatos','450000'),
('51986651-K','auxiliar de aseo','450000'),
('42957743-8','gerente','850000'),
('18864263-2','bartender','700000'),
('41152666-6','portero','450000'),
('12786274-5','bodeguero','500000'),
('84464435-3','administrador','7450000'),
('19373328-K','cajero','450000'),
('32947945-5','chef','650000');

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
(10,CURRENT_DATE,'pago trabajador',650000),

INSERTO INTO pago_trabajador VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);

INSERT INTO cliente(RUT) VALUES
('20123456-7'),
('87423982-8'),
('51986651-K'),
('42957743-8'),
('18864263-2'),
('41152666-6'),
('12786274-5'),
('84464435-3'),
('19373328-K'),
('32947945-5');

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
(1,1234,258),
(1,1235,283),
(2,1234,396),
(2,1235,257),
(3,1234,271),
(3,1235,381),
(4,1234,202),
(4,1235,353),
(5,1234,158),
(5,1235,253),
(6,1234,116),
(6,1235,126),
(7,1234,221),
(7,1235,285),
(8,1234,178),
(8,1235,173),
(9,1234,314),
(9,1235,173),
(10,1234,376),
(10,1235,353);


