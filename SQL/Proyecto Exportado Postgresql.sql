--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.15 (Ubuntu 10.15-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: proyecto; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA proyecto;


ALTER SCHEMA proyecto OWNER TO bdi2022ad;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: ganancia(date); Type: FUNCTION; Schema: proyecto; Owner: bdi2022ad
--

CREATE FUNCTION proyecto.ganancia(fecha date) RETURNS real
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION proyecto.ganancia(fecha date) OWNER TO bdi2022ad;

--
-- Name: precio(text); Type: FUNCTION; Schema: proyecto; Owner: bdi2022ad
--

CREATE FUNCTION proyecto.precio(nombre_producto text) RETURNS real
    LANGUAGE plpgsql
    AS $$
DECLARE precio_producto REAL;
BEGIN
	precio_producto := (
		SELECT sum(i.valor_unitario*c.cantidad_ingrediente*(1+p.porcentaje_ganancia/100))
		FROM producto as p, compone as c, ingrediente as i
		WHERE p.nombre = nombre_producto AND p.id_producto = c.id_producto AND c.id_ingrediente = i.id_ingrediente
	);
	RETURN precio_producto;
END
$$;


ALTER FUNCTION proyecto.precio(nombre_producto text) OWNER TO bdi2022ad;

--
-- Name: precio_pedido(integer); Type: FUNCTION; Schema: proyecto; Owner: bdi2022ad
--

CREATE FUNCTION proyecto.precio_pedido(numero_pedido integer) RETURNS real
    LANGUAGE plpgsql
    AS $$
DECLARE precio_pedido REAL;
BEGIN
	precio_pedido := (
		SELECT sum(t.cantidad_producto*precio(pr.nombre))
		FROM pedido as pe, tiene as t, producto as pr
		WHERE pe.id_pedido = numero_pedido AND pe.id_pedido = t.id_pedido AND t.id_producto = pr.id_producto
		);
	RETURN precio_pedido;
END
$$;


ALTER FUNCTION proyecto.precio_pedido(numero_pedido integer) OWNER TO bdi2022ad;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: actualiza; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.actualiza (
    id_ingrediente integer NOT NULL,
    id_egreso integer NOT NULL,
    fecha_actualiza date DEFAULT CURRENT_DATE,
    cantidad_actualiza integer
);


ALTER TABLE proyecto.actualiza OWNER TO bdi2022ad;

--
-- Name: boleta; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.boleta (
    id_boleta integer NOT NULL,
    total integer,
    valor_neto integer,
    iva integer,
    id_pedido integer,
    fecha_venta date DEFAULT CURRENT_DATE
);


ALTER TABLE proyecto.boleta OWNER TO bdi2022ad;

--
-- Name: cliente; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.cliente (
    rut character varying(100) NOT NULL
);


ALTER TABLE proyecto.cliente OWNER TO bdi2022ad;

--
-- Name: compone; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.compone (
    id_producto integer NOT NULL,
    id_ingrediente integer NOT NULL,
    cantidad_ingrediente double precision
);


ALTER TABLE proyecto.compone OWNER TO bdi2022ad;

--
-- Name: compra; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.compra (
    id_egreso integer NOT NULL
);


ALTER TABLE proyecto.compra OWNER TO bdi2022ad;

--
-- Name: egreso; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.egreso (
    id_egreso integer NOT NULL,
    fecha_egreso date DEFAULT CURRENT_DATE,
    descripcion character varying(100),
    total integer
);


ALTER TABLE proyecto.egreso OWNER TO bdi2022ad;

--
-- Name: en_local; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.en_local (
    id_pedido integer NOT NULL
);


ALTER TABLE proyecto.en_local OWNER TO bdi2022ad;

--
-- Name: fuera_local; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.fuera_local (
    id_pedido integer NOT NULL
);


ALTER TABLE proyecto.fuera_local OWNER TO bdi2022ad;

--
-- Name: ingrediente; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.ingrediente (
    id_ingrediente integer NOT NULL,
    nombre character varying(100),
    stock integer,
    u_m character varying(100),
    fecha_exp date,
    valor_unitario integer
);


ALTER TABLE proyecto.ingrediente OWNER TO bdi2022ad;

--
-- Name: mesa; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.mesa (
    num_mesa integer NOT NULL,
    estado_mesa character varying(100),
    CONSTRAINT mesa_estado_mesa_check CHECK (((estado_mesa)::text = ANY ((ARRAY['libre'::character varying, 'ocupada'::character varying])::text[])))
);


ALTER TABLE proyecto.mesa OWNER TO bdi2022ad;

--
-- Name: ocupa; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.ocupa (
    num_mesa integer NOT NULL,
    id_pedido integer NOT NULL,
    rut character varying(100) NOT NULL
);


ALTER TABLE proyecto.ocupa OWNER TO bdi2022ad;

--
-- Name: otro_egreso; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.otro_egreso (
    id_egreso integer NOT NULL
);


ALTER TABLE proyecto.otro_egreso OWNER TO bdi2022ad;

--
-- Name: pago_trabajador; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.pago_trabajador (
    id_egreso integer NOT NULL
);


ALTER TABLE proyecto.pago_trabajador OWNER TO bdi2022ad;

--
-- Name: pedido; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.pedido (
    id_pedido integer NOT NULL,
    valor_pedido integer,
    estado_pedido character varying(100) DEFAULT 'no entregado'::character varying,
    fecha_pedido date DEFAULT CURRENT_DATE,
    rut character varying(100),
    CONSTRAINT pedido_estado_pedido_check CHECK (((estado_pedido)::text = ANY ((ARRAY['entregado'::character varying, 'no entregado'::character varying])::text[])))
);


ALTER TABLE proyecto.pedido OWNER TO bdi2022ad;

--
-- Name: persona; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.persona (
    rut character varying(100) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL
);


ALTER TABLE proyecto.persona OWNER TO bdi2022ad;

--
-- Name: producto; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.producto (
    id_producto integer NOT NULL,
    nombre character varying(100),
    valor_producto integer,
    porcentaje_ganancia integer DEFAULT 20,
    tmp_preparacion integer
);


ALTER TABLE proyecto.producto OWNER TO bdi2022ad;

--
-- Name: proveedor; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.proveedor (
    id_proveedor integer NOT NULL,
    nombre character varying(100),
    empresa character varying(100),
    num_contacto character varying(100)
);


ALTER TABLE proyecto.proveedor OWNER TO bdi2022ad;

--
-- Name: tiene; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.tiene (
    id_pedido integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad_producto integer
);


ALTER TABLE proyecto.tiene OWNER TO bdi2022ad;

--
-- Name: trabajador; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.trabajador (
    rut character varying(100) NOT NULL,
    cargo character varying(30),
    sueldo integer
);


ALTER TABLE proyecto.trabajador OWNER TO bdi2022ad;

--
-- Name: transaccion; Type: TABLE; Schema: proyecto; Owner: bdi2022ad
--

CREATE TABLE proyecto.transaccion (
    id_proveedor integer NOT NULL,
    id_egreso integer NOT NULL
);


ALTER TABLE proyecto.transaccion OWNER TO bdi2022ad;

--
-- Data for Name: actualiza; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: boleta; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: cliente; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.cliente VALUES ('20123456-7');
INSERT INTO proyecto.cliente VALUES ('87423982-8');
INSERT INTO proyecto.cliente VALUES ('51986651-K');
INSERT INTO proyecto.cliente VALUES ('42957743-8');
INSERT INTO proyecto.cliente VALUES ('18864263-2');
INSERT INTO proyecto.cliente VALUES ('41152666-6');
INSERT INTO proyecto.cliente VALUES ('12786274-5');
INSERT INTO proyecto.cliente VALUES ('84464435-3');
INSERT INTO proyecto.cliente VALUES ('19373328-K');
INSERT INTO proyecto.cliente VALUES ('32947945-5');


--
-- Data for Name: compone; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.compone VALUES (1234, 1, 1);
INSERT INTO proyecto.compone VALUES (1234, 2, 3);
INSERT INTO proyecto.compone VALUES (1234, 3, 2);
INSERT INTO proyecto.compone VALUES (1234, 4, 3);
INSERT INTO proyecto.compone VALUES (1234, 5, 0.5);
INSERT INTO proyecto.compone VALUES (1234, 6, 2);
INSERT INTO proyecto.compone VALUES (1234, 7, 0.200000000000000011);
INSERT INTO proyecto.compone VALUES (1234, 8, 0.200000000000000011);
INSERT INTO proyecto.compone VALUES (1235, 1, 1);
INSERT INTO proyecto.compone VALUES (1235, 2, 4);
INSERT INTO proyecto.compone VALUES (1235, 3, 3);
INSERT INTO proyecto.compone VALUES (1235, 4, 4);
INSERT INTO proyecto.compone VALUES (1235, 5, 1);
INSERT INTO proyecto.compone VALUES (1235, 6, 2);
INSERT INTO proyecto.compone VALUES (1235, 7, 0.400000000000000022);
INSERT INTO proyecto.compone VALUES (1235, 8, 0.400000000000000022);


--
-- Data for Name: compra; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: egreso; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.egreso VALUES (1, '2022-10-24', 'pago trabajador', 500000);
INSERT INTO proyecto.egreso VALUES (2, '2022-10-24', 'pago trabajador', 450000);
INSERT INTO proyecto.egreso VALUES (3, '2022-10-24', 'pago trabajador', 450000);
INSERT INTO proyecto.egreso VALUES (4, '2022-10-24', 'pago trabajador', 850000);
INSERT INTO proyecto.egreso VALUES (5, '2022-10-24', 'pago trabajador', 700000);
INSERT INTO proyecto.egreso VALUES (6, '2022-10-24', 'pago trabajador', 450000);
INSERT INTO proyecto.egreso VALUES (7, '2022-10-24', 'pago trabajador', 500000);
INSERT INTO proyecto.egreso VALUES (8, '2022-10-24', 'pago trabajador', 745000);
INSERT INTO proyecto.egreso VALUES (9, '2022-10-24', 'pago trabajador', 450000);
INSERT INTO proyecto.egreso VALUES (10, '2022-10-24', 'pago trabajador', 650000);


--
-- Data for Name: en_local; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: fuera_local; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: ingrediente; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.ingrediente VALUES (1, 'pan', 50, 'unidad', '2022-10-25', 200);
INSERT INTO proyecto.ingrediente VALUES (2, 'tocino', 400, 'unidad', '2022-10-25', 300);
INSERT INTO proyecto.ingrediente VALUES (3, 'huevo', 34, 'unidad', '2022-10-25', 100);
INSERT INTO proyecto.ingrediente VALUES (4, 'queso', 56, 'unidad', '2022-10-25', 150);
INSERT INTO proyecto.ingrediente VALUES (5, 'carne', 200, 'kg', '2022-10-25', 2000);
INSERT INTO proyecto.ingrediente VALUES (6, 'cebolla morada', 100, 'unidad', '2022-10-25', 400);
INSERT INTO proyecto.ingrediente VALUES (7, 'tomate', 30, 'kg', '2022-10-25', 800);
INSERT INTO proyecto.ingrediente VALUES (8, 'lechuga', 28, 'kg', '2022-10-25', 1000);


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: ocupa; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: otro_egreso; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: pago_trabajador; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.pago_trabajador VALUES (1);
INSERT INTO proyecto.pago_trabajador VALUES (2);
INSERT INTO proyecto.pago_trabajador VALUES (3);
INSERT INTO proyecto.pago_trabajador VALUES (4);
INSERT INTO proyecto.pago_trabajador VALUES (5);
INSERT INTO proyecto.pago_trabajador VALUES (6);
INSERT INTO proyecto.pago_trabajador VALUES (7);
INSERT INTO proyecto.pago_trabajador VALUES (8);
INSERT INTO proyecto.pago_trabajador VALUES (9);
INSERT INTO proyecto.pago_trabajador VALUES (10);


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.pedido VALUES (1, NULL, 'no entregado', '2022-10-24', '20123456-7');
INSERT INTO proyecto.pedido VALUES (2, NULL, 'no entregado', '2022-10-24', '87423982-8');
INSERT INTO proyecto.pedido VALUES (3, NULL, 'no entregado', '2022-10-24', '51986651-K');
INSERT INTO proyecto.pedido VALUES (4, NULL, 'no entregado', '2022-10-24', '42957743-8');
INSERT INTO proyecto.pedido VALUES (5, NULL, 'no entregado', '2022-10-24', '18864263-2');
INSERT INTO proyecto.pedido VALUES (6, NULL, 'no entregado', '2022-10-24', '41152666-6');
INSERT INTO proyecto.pedido VALUES (7, NULL, 'no entregado', '2022-10-24', '12786274-5');
INSERT INTO proyecto.pedido VALUES (8, NULL, 'no entregado', '2022-10-24', '84464435-3');
INSERT INTO proyecto.pedido VALUES (9, NULL, 'no entregado', '2022-10-24', '19373328-K');
INSERT INTO proyecto.pedido VALUES (10, NULL, 'no entregado', '2022-10-24', '32947945-5');


--
-- Data for Name: persona; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.persona VALUES ('20123456-7', 'Pedro', 'Perez');
INSERT INTO proyecto.persona VALUES ('87423982-8', 'Adel', 'GARCIA');
INSERT INTO proyecto.persona VALUES ('51986651-K', 'Adonis', 'RODRIGUEZ');
INSERT INTO proyecto.persona VALUES ('42957743-8', 'Ajaz', 'GONZALEZ');
INSERT INTO proyecto.persona VALUES ('18864263-2', 'Akos', 'FERNANDEZ');
INSERT INTO proyecto.persona VALUES ('41152666-6', 'Aldo', 'LOPEZ');
INSERT INTO proyecto.persona VALUES ('12786274-5', 'Amets', 'MARTINEZ');
INSERT INTO proyecto.persona VALUES ('84464435-3', 'Amaro', 'SANCHEZ');
INSERT INTO proyecto.persona VALUES ('19373328-K', 'Aquiles', 'PEREZ');
INSERT INTO proyecto.persona VALUES ('32947945-5', 'Algimantas', 'GOMEZ');


--
-- Data for Name: producto; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.producto VALUES (1234, 'Hamburguesa1', NULL, 20, 20);
INSERT INTO proyecto.producto VALUES (1235, 'Hamburguesa2', NULL, 20, 20);


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Data for Name: tiene; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.tiene VALUES (1, 1234, 18);
INSERT INTO proyecto.tiene VALUES (1, 1235, 13);
INSERT INTO proyecto.tiene VALUES (2, 1234, 26);
INSERT INTO proyecto.tiene VALUES (2, 1235, 17);
INSERT INTO proyecto.tiene VALUES (3, 1234, 11);
INSERT INTO proyecto.tiene VALUES (3, 1235, 31);
INSERT INTO proyecto.tiene VALUES (4, 1234, 2);
INSERT INTO proyecto.tiene VALUES (4, 1235, 53);
INSERT INTO proyecto.tiene VALUES (5, 1234, 58);
INSERT INTO proyecto.tiene VALUES (5, 1235, 53);
INSERT INTO proyecto.tiene VALUES (6, 1234, 16);
INSERT INTO proyecto.tiene VALUES (6, 1235, 26);
INSERT INTO proyecto.tiene VALUES (7, 1234, 21);
INSERT INTO proyecto.tiene VALUES (7, 1235, 65);
INSERT INTO proyecto.tiene VALUES (8, 1234, 28);
INSERT INTO proyecto.tiene VALUES (8, 1235, 13);
INSERT INTO proyecto.tiene VALUES (9, 1234, 14);
INSERT INTO proyecto.tiene VALUES (9, 1235, 23);
INSERT INTO proyecto.tiene VALUES (10, 1234, 16);
INSERT INTO proyecto.tiene VALUES (10, 1235, 3);


--
-- Data for Name: trabajador; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--

INSERT INTO proyecto.trabajador VALUES ('20123456-7', 'mesero', 500000);
INSERT INTO proyecto.trabajador VALUES ('87423982-8', 'lavaplatos', 450000);
INSERT INTO proyecto.trabajador VALUES ('51986651-K', 'auxiliar de aseo', 450000);
INSERT INTO proyecto.trabajador VALUES ('42957743-8', 'gerente', 850000);
INSERT INTO proyecto.trabajador VALUES ('18864263-2', 'bartender', 700000);
INSERT INTO proyecto.trabajador VALUES ('41152666-6', 'portero', 450000);
INSERT INTO proyecto.trabajador VALUES ('12786274-5', 'bodeguero', 500000);
INSERT INTO proyecto.trabajador VALUES ('84464435-3', 'administrador', 7450000);
INSERT INTO proyecto.trabajador VALUES ('19373328-K', 'cajero', 450000);
INSERT INTO proyecto.trabajador VALUES ('32947945-5', 'chef', 650000);


--
-- Data for Name: transaccion; Type: TABLE DATA; Schema: proyecto; Owner: bdi2022ad
--



--
-- Name: actualiza actualiza_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.actualiza
    ADD CONSTRAINT actualiza_pkey PRIMARY KEY (id_ingrediente, id_egreso);


--
-- Name: boleta boleta_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.boleta
    ADD CONSTRAINT boleta_pkey PRIMARY KEY (id_boleta);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (rut);


--
-- Name: compone compone_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.compone
    ADD CONSTRAINT compone_pkey PRIMARY KEY (id_producto, id_ingrediente);


--
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_egreso);


--
-- Name: egreso egreso_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.egreso
    ADD CONSTRAINT egreso_pkey PRIMARY KEY (id_egreso);


--
-- Name: en_local en_local_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.en_local
    ADD CONSTRAINT en_local_pkey PRIMARY KEY (id_pedido);


--
-- Name: fuera_local fuera_local_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.fuera_local
    ADD CONSTRAINT fuera_local_pkey PRIMARY KEY (id_pedido);


--
-- Name: ingrediente ingrediente_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.ingrediente
    ADD CONSTRAINT ingrediente_pkey PRIMARY KEY (id_ingrediente);


--
-- Name: mesa mesa_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (num_mesa);


--
-- Name: ocupa ocupa_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.ocupa
    ADD CONSTRAINT ocupa_pkey PRIMARY KEY (num_mesa, id_pedido, rut);


--
-- Name: otro_egreso otro_egreso_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.otro_egreso
    ADD CONSTRAINT otro_egreso_pkey PRIMARY KEY (id_egreso);


--
-- Name: pago_trabajador pago_trabajador_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.pago_trabajador
    ADD CONSTRAINT pago_trabajador_pkey PRIMARY KEY (id_egreso);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (rut);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);


--
-- Name: tiene tiene_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.tiene
    ADD CONSTRAINT tiene_pkey PRIMARY KEY (id_pedido, id_producto);


--
-- Name: trabajador trabajador_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.trabajador
    ADD CONSTRAINT trabajador_pkey PRIMARY KEY (rut);


--
-- Name: transaccion transaccion_pkey; Type: CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.transaccion
    ADD CONSTRAINT transaccion_pkey PRIMARY KEY (id_proveedor, id_egreso);


--
-- Name: actualiza actualiza_id_egreso_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.actualiza
    ADD CONSTRAINT actualiza_id_egreso_fkey FOREIGN KEY (id_egreso) REFERENCES proyecto.compra(id_egreso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: actualiza actualiza_id_ingrediente_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.actualiza
    ADD CONSTRAINT actualiza_id_ingrediente_fkey FOREIGN KEY (id_ingrediente) REFERENCES proyecto.ingrediente(id_ingrediente) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: boleta boleta_id_pedido_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.boleta
    ADD CONSTRAINT boleta_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES proyecto.pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cliente cliente_rut_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.cliente
    ADD CONSTRAINT cliente_rut_fkey FOREIGN KEY (rut) REFERENCES proyecto.persona(rut) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: compone compone_id_ingrediente_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.compone
    ADD CONSTRAINT compone_id_ingrediente_fkey FOREIGN KEY (id_ingrediente) REFERENCES proyecto.ingrediente(id_ingrediente) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: compone compone_id_producto_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.compone
    ADD CONSTRAINT compone_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES proyecto.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: compra compra_id_egreso_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.compra
    ADD CONSTRAINT compra_id_egreso_fkey FOREIGN KEY (id_egreso) REFERENCES proyecto.egreso(id_egreso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: en_local en_local_id_pedido_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.en_local
    ADD CONSTRAINT en_local_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES proyecto.pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fuera_local fuera_local_id_pedido_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.fuera_local
    ADD CONSTRAINT fuera_local_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES proyecto.pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ocupa ocupa_id_pedido_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.ocupa
    ADD CONSTRAINT ocupa_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES proyecto.pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ocupa ocupa_num_mesa_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.ocupa
    ADD CONSTRAINT ocupa_num_mesa_fkey FOREIGN KEY (num_mesa) REFERENCES proyecto.mesa(num_mesa) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: ocupa ocupa_rut_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.ocupa
    ADD CONSTRAINT ocupa_rut_fkey FOREIGN KEY (rut) REFERENCES proyecto.cliente(rut) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: otro_egreso otro_egreso_id_egreso_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.otro_egreso
    ADD CONSTRAINT otro_egreso_id_egreso_fkey FOREIGN KEY (id_egreso) REFERENCES proyecto.egreso(id_egreso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pago_trabajador pago_trabajador_id_egreso_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.pago_trabajador
    ADD CONSTRAINT pago_trabajador_id_egreso_fkey FOREIGN KEY (id_egreso) REFERENCES proyecto.egreso(id_egreso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pedido pedido_rut_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.pedido
    ADD CONSTRAINT pedido_rut_fkey FOREIGN KEY (rut) REFERENCES proyecto.cliente(rut) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tiene tiene_id_pedido_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.tiene
    ADD CONSTRAINT tiene_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES proyecto.pedido(id_pedido) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: tiene tiene_id_producto_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.tiene
    ADD CONSTRAINT tiene_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES proyecto.producto(id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: trabajador trabajador_rut_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.trabajador
    ADD CONSTRAINT trabajador_rut_fkey FOREIGN KEY (rut) REFERENCES proyecto.persona(rut) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transaccion transaccion_id_egreso_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.transaccion
    ADD CONSTRAINT transaccion_id_egreso_fkey FOREIGN KEY (id_egreso) REFERENCES proyecto.compra(id_egreso) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: transaccion transaccion_id_proveedor_fkey; Type: FK CONSTRAINT; Schema: proyecto; Owner: bdi2022ad
--

ALTER TABLE ONLY proyecto.transaccion
    ADD CONSTRAINT transaccion_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES proyecto.proveedor(id_proveedor) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--