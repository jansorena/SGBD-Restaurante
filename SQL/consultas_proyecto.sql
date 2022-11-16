
-- Calcular el precio de un producto en base a los ingredientes
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

-- Calcular precio del pedido en base a los productos
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

-- Ganancia total: Ingresos-Egresos
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

/*
SELECT precio('Hamburguesa1');
SELECT precio_pedido(1);
SELECT ganancia(CURRENT_DATE);
*/

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

CREATE OR REPLACE FUNCTION mesa_ocupada()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE mesa SET estado_mesa = 'ocupada' WHERE num_mesa = NEW.num_mesa;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER mesa_ocupada
AFTER INSERT ON ocupa
FOR EACH ROW
EXECUTE PROCEDURE mesa_ocupada();

CREATE OR REPLACE VIEW mesas_libres AS
SELECT num_mesa
FROM mesa AS m
WHERE m.estado_mesa = 'libre';

SELECT * FROM mesas_libres;

CREATE OR REPLACE VIEW pedidos_pendientes AS
SELECT p.id_pedido, ps.nombre, c.RUT
FROM pedido AS p, cliente AS c, persona AS ps
WHERE p.estado_pedido = 'no entregado' AND p.RUT = c.RUT AND c.RUT = ps.RUT;

SELECT * FROM pedidos_pendientes;

CREATE OR REPLACE FUNCTION cantidad_vendida(VARCHAR)
RETURNS INT AS $$
DECLARE cantidad INT;
BEGIN
	cantidad :=(SELECT SUM(cantidad_producto) FROM producto AS p, tiene AS t WHERE p.id_producto = t.id_producto AND p.nombre = $1);
	RETURN cantidad;
END 
$$ LANGUAGE plpgsql;

CREATE OR REPLACE VIEW productos_vendidos AS
SELECT nombre, cantidad_vendida(nombre)
FROM producto
ORDER BY 2 DESC;

SELECT * FROM productos_vendidos;

CREATE OR REPLACE FUNCTION cantidad_ingrediente_en_producto(nombreI VARCHAR,nombreP VARCHAR)
RETURNS REAL AS $$
DECLARE cantidad REAL;
BEGIN
	cantidad := (SELECT c.cantidad_ingrediente FROM compone AS c, ingrediente AS i, producto AS p WHERE c.id_ingrediente = i.id_ingrediente AND c.id_producto = p.id_producto AND p.nombre = nombreP AND i.nombre = nombreI);
	RETURN cantidad;
END
$$ LANGUAGE plpgsql

SELECT cantidad_ingrediente_en_producto('lechuga','Hamburguesa1');