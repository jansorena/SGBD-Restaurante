INSERT INTO ingrediente(id_ingrediente,nombre,stock,u_m,fecha_exp,valor_unitario) VALUES
(1,'pan',50,'unidad','2022-10-25',200),
(2,'tocino',400,'unidad','2022-10-25',300),
(3,'huevo',34,'unidad','2022-10-25',100),
(4,'queso',56,'unidad','2022-10-25',150),
(5,'carne',200,'kg','2022-10-25',2000),
(6,'cebolla morada',100,'unidad','2022-10-25',400),
(7,'tomate',30,'kg','2022-10-25',800),
(8,'lechuga',28,'kg','2022-10-25',1000);

INSERT INTO producto(id_producto,nombre,porcentaje_ganancia,tmp_preparacion) VALUES
(1234,'Hamburguesa1',20,20),
(1235,'Hamburguesa2',20,20);

INSERT INTO compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES
(1234,1,1),
(1234,2,3),
(1234,3,2),
(1234,4,3),
(1234,5,0.5),
(1234,6,2),
(1234,7,0.2),
(1234,8,0.2);

INSERT INTO compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES
(1235,1,1),
(1235,2,4),
(1235,3,3),
(1235,4,4),
(1235,5,1),
(1235,6,2),
(1235,7,0.4),
(1235,8,0.4);

INSERT INTO persona(RUT,nombre,apellido) VALUES
('20123456-7','Pedro','Perez');
('87423982-8','Adel','GARCIA'),
('51986651-K','Adonis','RODRIGUEZ'),
('42957743-8','Ajaz','GONZALEZ'),
('18864263-2','Akos','FERNANDEZ'),
('41152666-6','Aldo','LOPEZ'),
('12786274-5','Amets','MARTINEZ'),
('84464435-3','Amaro','SANCHEZ'),
('19373328-K','Aquiles','PEREZ'),
('32947945-5','Algimantas','GOMEZ'),
('66888264-1','Alpidio','MARTIN'),
('84683876-7','Amrane','JIMENEZ'),
('36967631-8','Anish','HERNANDEZ'),
('41535864-4','Arián','RUIZ'),
('42472558-7','Ayun','DIAZ'),
('45631924-6','Azariel','MORENO'),
('37963643-8','Bagrat','MUÑOZ'),
('84123398-0','Bencomo','ALVAREZ'),
('95548416-9','Bertino','ROMERO'),
('95283823-7','Candi','GUTIERREZ'),
('87563488-7','Cesc','ALONSO'),
('87874461-6','Cirino','NAVARRO'),
('77849479-5','Crisólogo','TORRES'),
('65918422-2','Cruz','DOMINGUEZ'),
('13762541-5','Danilo','RAMOS'),
('32419686-2','Dareck','VAZQUEZ'),
('31377333-7','Dariel','RAMIREZ'),
('39173196-9','Darin','GIL'),
('69596628-8','Delmiro','SERRANO'),
('87677354-6','Damen','MORALES'),
('66891354-7','Dilan','MOLINA'),
('73621968-9','Dipa','BLANCO'),
('76578936-2','Doménico','SUAREZ'),
('88236257-4','Drago','CASTRO'),
('39674321-3','Edivaldo','ORTEGA'),
('76452915-4','Elvis','DELGADO'),
('51643674-3','Elyan','ORTIZ'),
('96233317-6','Emeric','MARIN'),
('19846816-9','Engracio','RUBIO'),
('63936314-7','Ensa','NUÑEZ'),
('23792175-5','Eñaut','SANZ'),
('64422656-5','Eleazar','MEDINA'),
('91454132-8','Eros','IGLESIAS'),
('88922587-4','Eufemio','CASTILLO'),
('65164261-2','Feiyang','CORTES'),
('89845895-4','Fiorenzo','GARRIDO'),
('22414496-2','Foudil','SANTOS'),
('17145658-4','Galo','GUERRERO'),
('61174452-8','Gastón','LOZANO'),
('55558345-1','Giulio','CANO'),
('34248453-0','Gautam','MENDEZ'),
('16337476-5','Gentil','CRUZ'),
('44922165-6','Gianni','PRIETO'),
('56669647-9','Gianluca','FLORES'),
('56378913-1','Giorgio','HERRERA'),
('58719293-4','Gourav','PEÑA'),
('49567577-7','Grober','LEON'),
('68934546-8','Guido','MARQUEZ'),
('93923958-8','Guifre','CABRERA'),
('31134255-K','Guim','GALLEGO'),
('95787687-0','Hermes','CALVO'),
('73745291-3','Inge','VIDAL'),
('35188373-1','Irai','CAMPOS'),
('44786211-5','Iraitz','REYES'),
('22736664-8','Iyad','VEGA'),
('45173784-8','Iyán','FUENTES'),
('11596521-2','Jeremías','CARRASCO'),
('46185264-5','Joao','DIEZ'),
('43191396-8','Jun','AGUILAR'),
('84749134-5','Khaled','CABALLERO'),
('47718419-7','Leónidas','NIETO'),
('68767641-6','Lier','SANTANA'),
('55455446-6','Lionel','PASCUAL'),
('51136752-2','Lisandro','HERRERO'),
('59888131-6','Lucián','VARGAS'),
('17467511-2','Mael','GIMENEZ'),
('51248665-7','Misael','MONTERO'),
('23274772-2','Moad','HIDALGO'),
('23446376-4','Munir','LORENZO'),
('62282745-K','Nael','SANTIAGO'),
('56961847-9','Najim','IBAÑEZ'),
('13676943-K','Neo','DURAN'),
('19124851-1','Neil','BENITEZ'),
('99885682-5','Nikita','FERRER'),
('53644557-9','Nilo','ARIAS'),
('55455729-5','Otto','MORA'),
('88238869-7','Pep','CARMONA'),
('22144786-7','Policarpo','VICENTE'),
('91472582-8','Radu','ROJAS'),
('31232623-K','Ramsés','SOTO'),
('18464958-6','Rómulo','CRESPO'),
('94114474-8','Roy','ROMAN'),
('79475485-3','Severo','PASTOR'),
('49792933-4','Sidi','VELASCO'),
('86866673-0','Simeón','PARRA'),
('77113681-8','Taha','SAEZ'),
('66659144-5','Tao','MOYA'),
('56296514-9','Vadim','BRAVO'),
('59754716-1','Vincenzo','SOLER'),
('65236287-7','Zaid','GALLARDO'),
('51441465-3','Zigor','RIVERA');

INSERT INTO trabajador(RUT,cargo,sueldo) VALUES
('87423982-8','chef','650000'),
('51986651-K','chef','650000'),
('42957743-8','chef','650000'),
('18864263-2','chef','650000'),
('41152666-6','chef','650000'),
('88236257-4','chef','650000'),
('12786274-5','cajero','450000'),
('84464435-3','cajero','450000'),
('19373328-K','mesero','500000'),
('32947945-5','mesero','500000'),
('66888264-1','mesero','500000'),
('84683876-7','mesero','500000'),
('36967631-8','mesero','500000'),
('41535864-4','mesero','500000'),
('42472558-7','mesero','500000'),
('45631924-6','mesero','500000'),
('37963643-8','lavaplatos','450000'),
('84123398-0','lavaplatos','450000'),
('95548416-9','lavaplatos','450000'),
('95283823-7','lavaplatos','450000'),
('87563488-7','auxiliar de aseo','450000'),
('87874461-6','auxiliar de aseo','450000'),
('77849479-5','auxiliar de aseo','450000'),
('65918422-2','auxiliar de aseo','450000'),
('13762541-5','gerente','850000'),
('32419686-2','bartender','700000'),
('31377333-7','bartender','700000'),
('39173196-9','portero','450000'),
('69596628-8','portero','450000'),
('87677354-6','bodeguero','500000'),
('66891354-7','bodeguero','500000'),
('73621968-9','bodeguero','500000'),
('76578936-2','bodeguero','500000'),
('39674321-3','administrador','700000'),
('76452915-4','administrador','700000');

INSERT INTO cliente(RUT) VALUES
('20.123.456-7');

INSERT INTO pedido (id_pedido,RUT) VALUES
(1,'20.123.456-7');

INSERT INTO tiene VALUES
(1,1234,3),
(1,1235,2)
(2,1234,236),
(2,1235,241),
(3,1234,275),
(3,1235,112),
(4,1234,287),
(4,1235,172),
(5,1234,357),
(5,1235,290),
(6,1234,174),
(6,1235,373),
(7,1234,342),
(7,1235,339),
(8,1234,284),
(8,1235,223),
(9,1234,283),
(9,1235,388),
(10,1234,124),
(10,1235,166),
(11,1234,163),
(11,1235,324);

/* Precio Hamburguesa */

CREATE OR REPLACE FUNCTION precio(nombre_producto TEXT)
RETURNS REAL AS $$
DECLARE precio_producto REAL;
BEGIN
	precio_producto := (
		SELECT sum(i.valor_unitario*c.cantidad_ingrediente*(1+p.porcentaje_ganancia/100))
		FROM producto as p, compone as c, ingrediente as i
		WHERE p.nombre = nombre_producto AND p.id_producto = c.id_producto AND c.id_ingrediente = i.id_ingrediente
	);
	RETURN precio_producto;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION precio_pedido(numero_pedido INT)
RETURNS REAL AS $$
DECLARE precio_pedido REAL;
BEGIN
	precio_pedido := (
		SELECT sum(t.cantidad_producto*precio(pr.nombre))
		FROM pedido as pe, tiene as t, producto as pr
		WHERE pe.id_pedido = numero_pedido AND pe.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto
		);
	RETURN precio_pedido;
END
$$ LANGUAGE plpgsql;

SELECT precio('Hamburguesa');
SELECT precio_pedido(1);


