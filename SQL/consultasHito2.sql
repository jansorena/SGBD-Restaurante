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

CREATE OR REPLACE FUNCTION ganancia(fecha DATE)
RETURNS REAL AS $$
DECLARE ganancia REAL; ingresos REAL; egresos REAL;
BEGIN

	ingresos := (
		SELECT sum(precio_pedido(pe.id_pedido))
		FROM pedido as pe
		WHERE pe.fecha_pedido = fecha
	);

	egresos := (
		SELECT sum(e.total)
		FROM egreso as e
		WHERE e.fecha_egreso = fecha
	);

	ganancia := ingresos - egresos;

	RETURN ganancia;
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION bajo_stock()
RETURNS TRIGGER AS $$
DECLARE
auxNombre VARCHAR(100) := NEW.nombre;
BEGIN
	IF(SELECT stock
	FROM ingrediente AS i
	WHERE i.id_ingrediente = NEW.id_ingrediente AND
		i.u_m = 'unidad' AND
		i.stock <= 20) <= 20 THEN
        IF(SELECT COUNT(*) FROM actualiza AS a WHERE a.id_ingrediente = NEW.id_ingrediente) = 0 THEN
            INSERT INTO egreso(id_egreso,fecha_egreso,descripcion) VALUES 
            ((SELECT MAX(id_egreso) FROM egreso)+1,CURRENT_DATE,CONCAT('Compra ',auxNombre));
            INSERT INTO compra VALUES ((SELECT MAX(id_egreso) FROM egreso));
            INSERT INTO actualiza (id_ingrediente,id_egreso) VALUES (NEW.id_ingrediente,(SELECT MAX(id_egreso) FROM egreso));
        END IF;
	ELSIF(SELECT stock
	FROM ingrediente AS i
	WHERE i.id_ingrediente = NEW.id_ingrediente AND
		i.u_m = 'kg' AND
		i.stock <= 5) <= 5 THEN
        IF(SELECT COUNT(*) FROM actualiza AS a WHERE a.id_ingrediente = NEW.id_ingrediente) = 0 THEN
	        INSERT INTO egreso(id_egreso,fecha_egreso,descripcion) VALUES 
	        ((SELECT MAX(id_egreso) FROM egreso)+1,CURRENT_DATE,CONCAT('Compra ',auxNombre));
	        INSERT INTO compra VALUES ((SELECT MAX(id_egreso) FROM egreso));
	        INSERT INTO actualiza (id_ingrediente,id_egreso) VALUES (NEW.id_ingrediente,(SELECT MAX(id_egreso) FROM egreso));
        END IF;
	ELSIF(SELECT stock
	FROM ingrediente AS i
	WHERE i.id_ingrediente = NEW.id_ingrediente AND
		i.u_m = 'L' AND
		i.stock <= 3) <= 3 THEN
            IF(SELECT COUNT(*) FROM actualiza AS a WHERE a.id_ingrediente = NEW.id_ingrediente) = 0 THEN
            INSERT INTO egreso(id_egreso,fecha_egreso,descripcion) VALUES 
	        ((SELECT MAX(id_egreso) FROM egreso)+1,CURRENT_DATE,CONCAT('Compra ',auxNombre));
	        INSERT INTO compra VALUES ((SELECT MAX(id_egreso) FROM egreso));
	        INSERT INTO actualiza (id_ingrediente,id_egreso) VALUES (NEW.id_ingrediente,(SELECT MAX(id_egreso) FROM egreso));
        END IF;
	END IF;

	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER bajo_stock
AFTER UPDATE ON ingrediente
FOR EACH ROW 
EXECUTE PROCEDURE bajo_stock();

UPDATE ingrediente
SET stock = 15
WHERE id_ingrediente = 3;

/*CREATE OR REPLACE FUNCTION actualiza_actualizado()
RETURNS TRIGGER AS $$
BEGIN
	IF(SELECT cantidad_actualiza FROM actualiza AS a WHERE a.id_egreso = NEW.id_egreso AND a.cantidad_actualiza >= 1) >= 1   THEN
		NEW.estado_actualiza := 'actualizado';
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualiza_actualizado
AFTER UPDATE ON actualiza
FOR EACH ROW 
EXECUTE PROCEDURE actualiza_actualizado();*/

CREATE OR REPLACE FUNCTION actualizar_stock()
RETURNS TRIGGER AS $$
BEGIN
	IF(NEW.estado_actualiza = 'actualizado') THEN
		UPDATE ingrediente SET stock = stock+NEW.cantidad_actualiza WHERE id_ingrediente = NEW.id_ingrediente;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock
AFTER UPDATE ON actualiza
FOR EACH ROW 
EXECUTE PROCEDURE actualizar_stock();

CREATE OR REPLACE FUNCTION actualizar_total_egreso_por_compra()
RETURNS TRIGGER AS $$
DECLARE
auxVal INT := (SELECT valor_unitario FROM ingrediente AS i WHERE i.id_ingrediente = NEW.id_ingrediente);
BEGIN
	IF(NEW.estado_actualiza = 'actualizado') THEN
		UPDATE egreso SET total = auxVal*NEW.cantidad_actualiza WHERE id_egreso = NEW.id_egreso;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_total_egreso_por_compra
AFTER UPDATE ON actualiza
FOR EACH ROW 
EXECUTE PROCEDURE actualizar_total_egreso_por_compra();

UPDATE actualiza 
SET cantidad_actualiza = 20, estado_actualiza = 'actualizado' 
WHERE id_egreso = 14;

CREATE OR REPLACE FUNCTION pedido_completado()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE pedido SET estado_pedido = 'entregado' WHERE id_pedido = NEW.id_pedido;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER pedido_completado
AFTER INSERT ON boleta
FOR EACH ROW
EXECUTE PROCEDURE pedido_completado();

CREATE OR REPLACE FUNCTION liberar_mesa()
RETURNS TRIGGER AS $$
DECLARE 
auxNumMesa INT := (SELECT o.num_mesa FROM ocupa AS o WHERE o.id_pedido = NEW.id_pedido);
BEGIN
	UPDATE mesa SET estado_mesa = 'libre' WHERE num_mesa = auxNumMesa;
	RETURN NEW;
END 
$$ LANGUAGE plpgsql;

CREATE TRIGGER liberar_mesa
AFTER INSERT ON boleta
FOR EACH ROW
EXECUTE PROCEDURE liberar_mesa();

SELECT precio('Hamburguesa1');
SELECT precio_pedido(1);
SELECT ganancia(CURRENT_DATE);

