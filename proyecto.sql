CREATE SCHEMA proyecto;

CREATE TABLE persona(
RUT    VARCHAR(100) PRIMARY KEY,
nombre VARCHAR(100),
apellido VARCHAR(100));

CREATE TABLE cliente(
RUT VARCHAR(100) PRIMARY KEY REFERENCES persona(RUT));

CREATE TABLE trabajador(
RUT VARCHAR(100) PRIMARY KEY REFERENCES persona(RUT));

CREATE TABLE mesa(
num_mesa INT PRIMARY KEY,
estado_mesa VARCHAR(100));

CREATE TABLE pedido(
id_pedido INT PRIMARY KEY,
valor_pedido INT,
estado_pedido VARCHAR(100),
fecha_pedido DATE,
RUT VARCHAR(100) REFERENCES cliente(RUT));

CREATE TABLE en_local(
id_pedido INT PRIMARY KEY REFERENCES pedido(id_pedido));

CREATE TABLE fuera_local(
id_pedido INT PRIMARY KEY REFERENCES pedido(id_pedido));

CREATE TABLE producto(
id_producto INT PRIMARY KEY,
valor_producto INT,
porcentaje_ganancia INT,
tmp_preparacion INT);

CREATE TABLE boleta(
id_boleta INT PRIMARY KEY,
total INT,
valor_neto INT,
iva INT,
id_pedido INT REFERENCES pedido(id_pedido),
fecha_venta DATE);

CREATE TABLE ingrediente(
id_ingrediente INT PRIMARY KEY,
stock INT,
u_m VARCHAR(100),
fecha_exp DATE,
valor_unitario INT);

CREATE TABLE egreso(
id_egreso INT PRIMARY KEY,
fecha_egreso DATE,
descripcion VARCHAR(100),
total INT);

CREATE TABLE compra(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso));

CREATE TABLE pago_trabajador(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso));

CREATE TABLE otro_egreso(
id_egreso INT PRIMARY KEY REFERENCES egreso(id_egreso));

CREATE TABLE proveedor(
id_proveedor INT PRIMARY KEY,
nombre VARCHAR(100),
empresa VARCHAR(100),
num_contacto VARCHAR(100));

CREATE TABLE ocupa(
num_mesa INT REFERENCES mesa(num_mesa),
id_pedido INT REFERENCES pedido(id_pedido),
RUT INT REFERENCES cliente(RUT)
PRIMARY KEY(num_mesa,id_pedido,RUT));

CREATE TABLE tiene(
id_pedido INT REFERENCES pedido(id_pedido),
id_producto INT REFERENCES producto(id_producto),
cantidad_producto INT,
PRIMARY KEY (id_pedido,id_producto));

CREATE TABLE compone(
id_producto INT REFERENCES producto(id_producto),
id_ingrediente INT REFERENCES ingrediente(id_ingrediente),
cantidad_ingrediente INT,
PRIMARY KEY (id_producto,id_ingrediente));

CREATE TABLE actualiza(
id_ingrediente INT REFERENCES ingrediente(id_ingrediente),
id_egreso INT REFERENCES compra(id_egreso),
fecha_actualiza DATE,
cantidad_actualiza INT,
PRIMARY KEY(id_ingrediente,id_egreso));

CREATE TABLE transaccion(
id_proveedor INT REFERENCES proveedor(id_proveedor),
id_egreso INT REFERENCES compra(id_egreso),
PRIMARY KEY (id_proveedor,id_egreso));


