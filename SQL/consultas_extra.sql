CREATE OR REPLACE FUNCTION ingresos_diarios(fecha DATE)
RETURNS REAL AS $$
DECLARE ingresos REAL;
BEGIN
	ingresos := (
		SELECT sum(proyecto.calculo_precio_pedido(pe.id_pedido))
		FROM proyecto.pedido AS pe
		WHERE pe.fecha_pedido = fecha
	);

	IF(ingresos IS NULL) THEN ingresos := 0;
	END IF;

	RETURN ingresos;
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ingresos_diarios(DATE fecha)
RETURNS INT AS $$
DECLARE
ingresos INT;
BEGIN
	ingresos := (SELECT SUM(total) FROM proyecto.boleta AS b WHERE b.fecha_venta = fecha);
	IF(ingresos IS NULL) THEN ingresos := 0;
	END IF;
	RETURN ingresos;
END
$$ LANGUAGE plpgsql;