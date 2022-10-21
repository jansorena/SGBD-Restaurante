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
(1234,'Hamburguesa',20,20);

INSERT INTO compone(id_producto,id_ingrediente,cantidad_ingrediente) VALUES
(1234,1,1),
(1234,2,3),
(1234,3,2),
(1234,4,3),
(1234,5,0.5),
(1234,6,2),
(1234,7,0.2),
(1234,8,0.2);

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


SELECT precio('Hamburguesa');
