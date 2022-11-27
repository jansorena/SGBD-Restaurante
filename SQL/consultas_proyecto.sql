
-------------------CONSULTAS DE PRECIOS-----------------------------------------

-- Calcular el precio de un producto en base a los ingredientes
CREATE OR REPLACE FUNCTION precio(id_calcular INT)
RETURNS REAL AS $$
DECLARE precio_producto REAL;
BEGIN
	precio_producto := (
		SELECT sum(c.cantidad_ingrediente*i.valor_unitario*(1+(p.porcentaje_ganancia/100)))
		FROM proyecto.producto AS p, proyecto.compone AS c, proyecto.ingrediente AS i
		WHERE p.id_producto = id_calcular AND p.id_producto = c.id_producto AND c.id_ingrediente = i.id_ingrediente
	);
	RETURN precio_producto;
END
$$ LANGUAGE plpgsql;

--asigna el valor de los productos (a todos)
CREATE OR REPLACE FUNCTION precio_producto()
RETURNS VOID AS $$
BEGIN
	UPDATE proyecto.producto AS p SET valor_producto = proyecto.precio(p.id_producto);
END
$$ LANGUAGE plpgsql;

--modifica el valor de un producto si se modifica el precio de un ingrediente
CREATE OR REPLACE FUNCTION nuevo_precio_producto()
RETURNS TRIGGER AS $$
BEGIN
	IF(OLD.valor_unitario != NEW.valor_unitario) THEN
		UPDATE proyecto.producto AS p SET valor_producto = proyecto.precio(p.id_producto) WHERE p.id_producto = (SELECT id_producto FROM proyecto.compone AS c WHERE p.id_producto = c.id_producto AND c.id_ingrediente = NEW.id_ingrediente);
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER nuevo_precio_producto
AFTER UPDATE ON proyecto.ingrediente
FOR EACH ROW
EXECUTE PROCEDURE proyecto.nuevo_precio_producto();

-- Calcular precio del pedido en base a los productos
CREATE OR REPLACE FUNCTION calculo_precio_pedido(numero_pedido INT)
RETURNS REAL AS $$
DECLARE precio_pedido REAL;
BEGIN
	precio_pedido := (
		SELECT sum(t.cantidad_producto*proyecto.precio(pr.id_producto))
		FROM proyecto.pedido AS pe, proyecto.tiene AS t, proyecto.producto AS pr
		WHERE pe.id_pedido = numero_pedido AND pe.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto
		);
	RETURN precio_pedido;
END
$$ LANGUAGE plpgsql;

--se calcula el precio del pedido cada vez que se inserta en tiene
CREATE OR REPLACE FUNCTION precio_pedido()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE proyecto.pedido SET valor_pedido = (proyecto.calculo_precio_pedido(NEW.id_pedido)) WHERE id_pedido = NEW.id_pedido;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER precio_pedido
AFTER INSERT OR UPDATE ON proyecto.tiene
FOR EACH ROW
EXECUTE PROCEDURE proyecto.precio_pedido();

------------------------CONSULTAS FINANZAS ---------------------------------------------------------------------------

-- Ganancia total: Ingresos-Egresos
CREATE OR REPLACE FUNCTION ganancia(fecha DATE)
RETURNS REAL AS $$
DECLARE ganancia REAL; ingresos REAL; egresos REAL;
BEGIN
	ingresos := (
		SELECT sum(calculo_precio_pedido(pe.id_pedido))
		FROM proyecto.pedido AS pe
		WHERE pe.fecha_pedido = fecha
	);

	egresos := (
		SELECT sum(e.total)
		FROM proyecto.egreso AS e
		WHERE e.fecha_egreso = fecha
	);

	ganancia := ingresos - egresos;

	RETURN ganancia;
END
$$ LANGUAGE plpgsql;

--------------------- CONSULTAS STOCK ---------------------------------------------------

--Si el stock es menor a 10 se inserta en egreso una tupla con valor null y descripcion de lo que se debe comprar
--en compra se referencia al egreso y en actualiza se crea la tupla respectiva con estado no actualizado y cantidad null
CREATE OR REPLACE FUNCTION bajo_stock()
RETURNS TRIGGER AS $$
DECLARE
auxNombre VARCHAR(100) := NEW.nombre;
cont INT := (SELECT COUNT(*) FROM proyecto.actualiza AS a WHERE a.id_ingrediente = NEW.id_ingrediente);
BEGIN
	IF(SELECT stock
	FROM proyecto.ingrediente AS i
	WHERE i.id_ingrediente = NEW.id_ingrediente AND i.stock <= 10) <= 10 THEN
        IF (cont = 0) THEN
            INSERT INTO proyecto.egreso(id_egreso,fecha_egreso,descripcion) VALUES 
            ((SELECT MAX(id_egreso) FROM egreso)+1,CURRENT_DATE,CONCAT('Compra ',auxNombre));
            INSERT INTO proyecto.compra VALUES ((SELECT MAX(id_egreso) FROM proyecto.egreso));
            INSERT INTO proyecto.actualiza (id_ingrediente,id_egreso) VALUES (NEW.id_ingrediente,(SELECT MAX(id_egreso) FROM proyecto.egreso));
		ELSIF(cont > 0 AND ((SELECT e.total FROM egreso AS e, actualiza AS a WHERE a.id_ingrediente = NEW.id_ingrediente AND e.id_egreso = a.id_egreso)) > 0) THEN
			INSERT INTO proyecto.egreso(id_egreso,fecha_egreso,descripcion) VALUES 
            ((SELECT MAX(id_egreso) FROM egreso)+1,CURRENT_DATE,CONCAT('Compra ',auxNombre));
            INSERT INTO proyecto.compra VALUES ((SELECT MAX(id_egreso) FROM proyecto.egreso));
            INSERT INTO proyecto.actualiza (id_ingrediente,id_egreso) VALUES (NEW.id_ingrediente,(SELECT MAX(id_egreso) FROM proyecto.egreso));
        END IF;	
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER bajo_stock
AFTER UPDATE ON proyecto.ingrediente
FOR EACH ROW 
EXECUTE PROCEDURE proyecto.bajo_stock();

--si una tupla de actualiza cambia su estado a actualizado, se suma el stock comprado a el ingrediente respectivo
CREATE OR REPLACE FUNCTION actualizar_stock()
RETURNS TRIGGER AS $$
BEGIN
	IF(NEW.estado_actualiza = 'actualizado') THEN
		UPDATE proyecto.ingrediente SET stock = stock+NEW.cantidad_actualiza WHERE id_ingrediente = NEW.id_ingrediente;
		UPDATE proyecto.ingrediente SET fecha_exp = NEW.fecha_exp WHERE id_ingrediente = NEW.id_ingrediente;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock
AFTER UPDATE ON proyecto.actualiza
FOR EACH ROW 
EXECUTE PROCEDURE proyecto.actualizar_stock();


------ CONSULTAS EGRESOS -----

--se modifica el total del egreso de la tupla previamente insertada por bajo stock, si la compra asociada a actualiza cambia su estado a actualizado 
CREATE OR REPLACE FUNCTION actualizar_total_egreso_por_compra()
RETURNS TRIGGER AS $$
DECLARE
auxVal INT := (SELECT valor_unitario FROM proyecto.ingrediente AS i WHERE i.id_ingrediente = NEW.id_ingrediente);
BEGIN
	IF(NEW.estado_actualiza = 'actualizado') THEN
		UPDATE proyecto.egreso SET total = auxVal*NEW.cantidad_actualiza WHERE id_egreso = NEW.id_egreso;
	END IF;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_total_egreso_por_compra
AFTER UPDATE ON proyecto.actualiza
FOR EACH ROW 
EXECUTE PROCEDURE proyecto.actualizar_total_egreso_por_compra();

--- CONSULTAS PEDIDOS ------

--si se "crea" la boleta asociada a un pedido, este se considera como entregado, por lo que el estado es modificado a 'entregado'
CREATE OR REPLACE FUNCTION pedido_completado()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE proyecto.pedido SET estado_pedido = 'entregado' WHERE id_pedido = NEW.id_pedido;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER pedido_completado
AFTER INSERT ON proyecto.boleta
FOR EACH ROW
EXECUTE PROCEDURE proyecto.pedido_completado();

----- CONSULTAS MESAS -------

-- si se "crea" una boleta se libera la mesa asociada al pedido que ocupa dicha mesa
CREATE OR REPLACE FUNCTION liberar_mesa()
RETURNS TRIGGER AS $$
DECLARE 
auxNumMesa INT := (SELECT o.num_mesa FROM proyecto.ocupa AS o WHERE o.id_pedido = NEW.id_pedido);
BEGIN
	UPDATE proyecto.mesa SET estado_mesa = 'libre' WHERE num_mesa = auxNumMesa;
	RETURN NEW;
END 
$$ LANGUAGE plpgsql;

CREATE TRIGGER liberar_mesa
AFTER INSERT ON proyecto.boleta
FOR EACH ROW
EXECUTE PROCEDURE proyecto.liberar_mesa();

--si se inserta una tupla en ocupa, se marca como ocupada la mesa asociada a dicha tupla
CREATE OR REPLACE FUNCTION mesa_ocupada()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE proyecto.mesa SET estado_mesa = 'ocupada' WHERE num_mesa = NEW.num_mesa;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER mesa_ocupada
AFTER INSERT ON proyecto.ocupa
FOR EACH ROW
EXECUTE PROCEDURE proyecto.mesa_ocupada();

--se muestran las mesas libres
CREATE OR REPLACE VIEW mesas_libres AS
SELECT num_mesa
FROM proyecto.mesa AS m
WHERE m.estado_mesa = 'libre';

--SELECT * FROM mesas_libres;

--se muestran todos los pedidos con estado 'no entregado'
CREATE OR REPLACE VIEW pedidos_pendientes AS
SELECT p.id_pedido, c.nombre, c.RUT
FROM proyecto.pedido AS p, proyecto.cliente AS c
WHERE p.estado_pedido = 'no entregado' AND p.RUT = c.RUT;

--SELECT * FROM pedidos_pendientes;

--retorna la cantidad total vendida de un producto segun el paso por parametro de su nombre
CREATE OR REPLACE FUNCTION cantidad_vendida(VARCHAR)
RETURNS INT AS $$
DECLARE cantidad INT;
BEGIN
	cantidad :=(SELECT SUM(cantidad_producto) FROM proyecto.producto AS p, proyecto.tiene AS t WHERE p.id_producto = t.id_producto AND p.nombre = $1);
	RETURN cantidad;
END 
$$ LANGUAGE plpgsql;

--Se muestra de manera ordenada y descendente los productos mas vendidos
CREATE OR REPLACE VIEW productos_vendidos AS
SELECT nombre, cantidad_vendida(nombre)
FROM proyecto.producto
ORDER BY 2 DESC;

--SELECT * FROM productos_vendidos;

--esta funcion creo que es inutil xd
--muestra la cantidad que tiene un producto especifico de un ingrediente especifico (se pasan los nombres por parametro)
CREATE OR REPLACE FUNCTION cantidad_ingrediente_en_producto(nombreI VARCHAR,nombreP VARCHAR)
RETURNS REAL AS $$
DECLARE cantidad REAL;
BEGIN
	cantidad := (SELECT c.cantidad_ingrediente FROM proyecto.compone AS c, proyecto.ingrediente AS i, proyecto.producto AS p WHERE c.id_ingrediente = i.id_ingrediente AND c.id_producto = p.id_producto AND p.nombre = nombreP AND i.nombre = nombreI);
	RETURN cantidad;
END
$$ LANGUAGE plpgsql;

--SELECT cantidad_ingrediente_en_producto('lechuga','Hamburguesa1');

--cambia el stock y fecha de expiracion a 0 y null, respectivamente, a todo ingrediente vencido
CREATE OR REPLACE FUNCTION ingrediente_vencido()
RETURNS void AS $$
BEGIN
	UPDATE proyecto.ingrediente SET stock = 0 WHERE fecha_exp < CURRENT_DATE;
	UPDATE proyecto.ingrediente SET fecha_exp = NULL WHERE fecha_exp < CURRENT_DATE;
END
$$ LANGUAGE plpgsql;

--SELECT ingrediente_vencido();

--chequea el stock de un ingrediente es suficiente para un pedido antes que se inserte en tiene
CREATE OR REPLACE FUNCTION check_stock()
RETURNS TRIGGER AS $$
BEGIN
	IF((SELECT COUNT(*) FROM proyecto.ingrediente AS i, proyecto.producto AS p, proyecto.compone AS c
		WHERE i.id_ingrediente = c.id_ingrediente AND c.id_producto = p.id_producto AND c.cantidad_ingrediente*NEW.cantidad_producto > i.stock)) > 0
		THEN
		--DELETE FROM proyecto.en_local WHERE id_pedido = NEW.id_pedido;		
		--DELETE FROM proyecto.pedido WHERE id_pedido = NEW.id_pedido;
		RAISE EXCEPTION 'No se puede realizar el pedido por falta de stock';	
	ELSE	
		RETURN NEW;
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock
BEFORE INSERT ON proyecto.tiene
FOR EACH ROW
EXECUTE PROCEDURE proyecto.check_stock();

--se resta el stock de un ingrediente si es que si es suficiente para ser pedido
CREATE OR REPLACE FUNCTION actualizar_stock_por_pedido()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE proyecto.ingrediente AS i
	SET stock = stock - (NEW.cantidad_producto*(SELECT cantidad_ingrediente FROM proyecto.compone AS c WHERE c.id_ingrediente = i.id_ingrediente AND c.id_producto = NEW.id_producto))
	WHERE i.id_ingrediente = (SELECT id_ingrediente FROM proyecto.compone AS c WHERE c.id_ingrediente = i.id_ingrediente AND c.id_producto = NEW.id_producto);
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock_por_pedido
AFTER INSERT ON proyecto.tiene
FOR EACH ROW
EXECUTE PROCEDURE proyecto.actualizar_stock_por_pedido();

/*
INSERT INTO pedido(id_pedido,RUT) VALUES
(11,'41152666-6');
INSERT INTO tiene VALUES
(11,1235,2);
*/

--se verifica si el stock disponible es suficiente para que se realice una modificacion de la cantidad de un producto en un ingrediente
CREATE OR REPLACE FUNCTION check_stock_update()
RETURNS TRIGGER AS $$
BEGIN
	IF((SELECT COUNT(*) FROM proyecto.ingrediente AS i, proyecto.producto AS p, proyecto.compone AS c
		WHERE i.id_ingrediente = c.id_ingrediente AND c.id_producto = p.id_producto AND c.cantidad_ingrediente*(NEW.cantidad_producto - OLD.cantidad_producto) > i.stock)) > 0
		THEN
		RAISE EXCEPTION 'No se puede modificar el pedido por falta de stock';	
	ELSE	
		RETURN NEW;
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock_update
BEFORE UPDATE ON proyecto.tiene
FOR EACH ROW
EXECUTE PROCEDURE proyecto.check_stock_update();

--si se actualiza el contenido de un pedido se modifica el nuevo stock disponible del ingrediente
CREATE OR REPLACE FUNCTION actualizar_stock_por_modificacion()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE proyecto.ingrediente AS i
	SET stock = stock + ((OLD.cantidad_producto-NEW.cantidad_producto)*(SELECT cantidad_ingrediente FROM proyecto.compone AS c WHERE c.id_producto = NEW.id_producto AND c.id_ingrediente = i.id_ingrediente))
	WHERE i.id_ingrediente = (SELECT id_ingrediente FROM proyecto.compone AS c WHERE c.id_producto = NEW.id_producto AND c.id_ingrediente = i.id_ingrediente);
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_stock_por_modificacion
AFTER UPDATE ON proyecto.tiene
FOR EACH ROW
EXECUTE PROCEDURE proyecto.actualizar_stock_por_modificacion();

--UPDATE tiene SET cantidad_producto = 4 WHERE id_pedido = 1 AND id_producto = 23422;

--se asignan los valores faltantes a una boleta recien creada
CREATE OR REPLACE FUNCTION rellenar_boleta()
RETURNS TRIGGER AS $$
DECLARE
valorP INT := (SELECT valor_pedido FROM proyecto.pedido AS p WHERE id_pedido = NEW.id_pedido);
BEGIN
	NEW.total := valorP;
	NEW.valor_neto := valorP*0.81;
	NEW.iva := valorP*0.19;
	RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER rellenar_boleta
BEFORE INSERT ON proyecto.boleta
FOR EACH ROW
EXECUTE PROCEDURE proyecto.rellenar_boleta();

--si se quiere asignar a un cliente una mesa ya ocupada no se permite
CREATE OR REPLACE FUNCTION check_mesa()
RETURNS TRIGGER AS $$
BEGIN
	IF(SELECT estado_mesa FROM proyecto.mesa AS m WHERE m.num_mesa = NEW.num_mesa) = 'ocupada' THEN
		RAISE EXCEPTION 'La mesa esta ocupada';
	ELSE
		RETURN NEW;
	END IF;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_mesa
BEFORE INSERT OR UPDATE ON proyecto.ocupa
FOR EACH ROW
EXECUTE PROCEDURE proyecto.check_mesa();

/*UPDATE ocupa SET num_mesa = 4 WHERE rut = '20123456-7';
INSERT INTO ocupa values
(8,7,'12786274-5');
INSERT INTO ocupa values
(2,7,'12786274-5'); */

