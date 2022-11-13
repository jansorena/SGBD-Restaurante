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
