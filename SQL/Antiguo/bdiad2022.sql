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
-- Name: actividad_final; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA actividad_final;


ALTER SCHEMA actividad_final OWNER TO bdi2022ad;

--
-- Name: autos; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA autos;


ALTER SCHEMA autos OWNER TO bdi2022ad;

--
-- Name: cine; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA cine;


ALTER SCHEMA cine OWNER TO bdi2022ad;

--
-- Name: empleados; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA empleados;


ALTER SCHEMA empleados OWNER TO bdi2022ad;

--
-- Name: lab3; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA lab3;


ALTER SCHEMA lab3 OWNER TO bdi2022ad;

--
-- Name: locales_y_votantes; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA locales_y_votantes;


ALTER SCHEMA locales_y_votantes OWNER TO bdi2022ad;

--
-- Name: negocio; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA negocio;


ALTER SCHEMA negocio OWNER TO bdi2022ad;

--
-- Name: numeros; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA numeros;


ALTER SCHEMA numeros OWNER TO bdi2022ad;

--
-- Name: proyecto; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA proyecto;


ALTER SCHEMA proyecto OWNER TO bdi2022ad;

--
-- Name: renta_equipos; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA renta_equipos;


ALTER SCHEMA renta_equipos OWNER TO bdi2022ad;

--
-- Name: test; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO bdi2022ad;

--
-- Name: test2; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA test2;


ALTER SCHEMA test2 OWNER TO bdi2022ad;

--
-- Name: universidad; Type: SCHEMA; Schema: -; Owner: bdi2022ad
--

CREATE SCHEMA universidad;


ALTER SCHEMA universidad OWNER TO bdi2022ad;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: rellenar_datos(); Type: FUNCTION; Schema: numeros; Owner: bdi2022ad
--

CREATE FUNCTION numeros.rellenar_datos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.cuadrado := power(NEW.numero,2);
    NEW.cubo := power(NEW.numero,3);
    NEW.raiz2 := sqrt(NEW.numero);
    NEW.raiz3 := sqrt(NEW.numero);
RETURN NEW;
END
$$;


ALTER FUNCTION numeros.rellenar_datos() OWNER TO bdi2022ad;

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

--
-- Name: es_par(integer); Type: FUNCTION; Schema: public; Owner: bdi2022ad
--

CREATE FUNCTION public.es_par(numero integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE resultado TEXT;
BEGIN
-- Se calcula el módulo 2 con la función MOD
IF MOD(numero, 2) = 0 THEN -- La comparación se hace con un solo signo =
resultado := 'El número es Par';
ELSE
resultado := 'El número es Impar';
END IF;
RETURN resultado;
END
$$;


ALTER FUNCTION public.es_par(numero integer) OWNER TO bdi2022ad;

--
-- Name: rellenar_datos(); Type: FUNCTION; Schema: public; Owner: bdi2022ad
--

CREATE FUNCTION public.rellenar_datos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- NEW: Nuevo valor insertado
NEW.cuadrado := power(NEW.numero,2);
NEW.cubo := power(NEW.numero,3);
NEW.raiz2 := sqrt(NEW.numero);
NEW.raiz3 := cbrt(NEW.numero);
RETURN NEW;
END
$$;


ALTER FUNCTION public.rellenar_datos() OWNER TO bdi2022ad;

--
-- Name: contar_reserva(); Type: FUNCTION; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE FUNCTION renta_equipos.contar_reserva() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF(
        SELECT COUNT(*)
        FROM renta_equipos.reserva as r
        WHERE r.id_cliente = NEW.id_cliente) = 2
    THEN 
    RAISE EXCEPTION 'hehe no se puede';
    ELSE 
        RETURN NEW;
    END IF;
END
$$;


ALTER FUNCTION renta_equipos.contar_reserva() OWNER TO bdi2022ad;

--
-- Name: funcion_stock(); Type: FUNCTION; Schema: test2; Owner: bdi2022ad
--

CREATE FUNCTION test2.funcion_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(
		SELECT p.stock
		FROM producto as p
		WHERE NEW.id_producto = p.id_producto
		) < 5
	THEN
		INSERT INTO renovar_stock(id_producto,stock_actual) VALUES
		(NEW.id_producto,NEW.stock);

	END IF;
	RETURN NEW;
END
$$;


ALTER FUNCTION test2.funcion_stock() OWNER TO bdi2022ad;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: administrativo; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.administrativo (
    rut character varying(10) NOT NULL,
    nombre character varying(45) NOT NULL,
    fecha_nacimiento date,
    ciudad character varying(40) DEFAULT 'Concepción'::character varying,
    jornada character varying(25),
    CONSTRAINT administrativo_fecha_nacimiento_check CHECK ((fecha_nacimiento > '1900-01-01'::date)),
    CONSTRAINT administrativo_jornada_check CHECK (((jornada)::text = ANY ((ARRAY['completa'::character varying, 'medio tiempo'::character varying])::text[])))
);


ALTER TABLE actividad_final.administrativo OWNER TO bdi2022ad;

--
-- Name: asignatura; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.asignatura (
    codigo_asignatura integer NOT NULL,
    nombre character varying(40),
    creditos integer DEFAULT 2 NOT NULL,
    CONSTRAINT asignatura_creditos_check CHECK ((creditos > 1))
);


ALTER TABLE actividad_final.asignatura OWNER TO bdi2022ad;

--
-- Name: estudiante; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.estudiante (
    matricula integer NOT NULL,
    rut character varying(10),
    nombre character varying(40),
    carrera character varying(40),
    mail character varying(40)
);


ALTER TABLE actividad_final.estudiante OWNER TO bdi2022ad;

--
-- Name: tiene; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.tiene (
    matricula integer NOT NULL,
    codigo_asignatura integer NOT NULL
);


ALTER TABLE actividad_final.tiene OWNER TO bdi2022ad;

--
-- Name: asignaturas_mas_3_creditos; Type: VIEW; Schema: actividad_final; Owner: bdi2022ad
--

CREATE VIEW actividad_final.asignaturas_mas_3_creditos AS
 SELECT e.nombre,
    e.matricula,
    e.carrera
   FROM actividad_final.estudiante e,
    actividad_final.tiene t,
    actividad_final.asignatura a
  WHERE ((e.matricula = t.matricula) AND (t.codigo_asignatura = a.codigo_asignatura) AND (a.creditos >= 3));


ALTER TABLE actividad_final.asignaturas_mas_3_creditos OWNER TO bdi2022ad;

--
-- Name: docente; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.docente (
    rut character varying(10) NOT NULL,
    nombre character varying(40),
    mail character varying(40)
);


ALTER TABLE actividad_final.docente OWNER TO bdi2022ad;

--
-- Name: imparte; Type: TABLE; Schema: actividad_final; Owner: bdi2022ad
--

CREATE TABLE actividad_final.imparte (
    rut character varying(10) NOT NULL,
    codigo_asignatura integer NOT NULL
);


ALTER TABLE actividad_final.imparte OWNER TO bdi2022ad;

--
-- Name: propietario; Type: TABLE; Schema: autos; Owner: bdi2022ad
--

CREATE TABLE autos.propietario (
    rut character varying(9) NOT NULL,
    nombre character varying(45),
    apellido character varying(45),
    ciudad character varying(20)
);


ALTER TABLE autos.propietario OWNER TO bdi2022ad;

--
-- Name: vehiculo; Type: TABLE; Schema: autos; Owner: bdi2022ad
--

CREATE TABLE autos.vehiculo (
    patente character varying(6) NOT NULL,
    marca character varying(15),
    modelo character varying(20),
    rut character varying(9),
    kilometraje integer
);


ALTER TABLE autos.vehiculo OWNER TO bdi2022ad;

--
-- Name: actor; Type: TABLE; Schema: cine; Owner: bdi2022ad
--

CREATE TABLE cine.actor (
    id_actor integer NOT NULL,
    nombre character varying(50),
    apellido character varying(50),
    nacimiento date,
    nacionalidad character varying(50)
);


ALTER TABLE cine.actor OWNER TO bdi2022ad;

--
-- Name: participa; Type: TABLE; Schema: cine; Owner: bdi2022ad
--

CREATE TABLE cine.participa (
    id_pelicula integer NOT NULL,
    id_actor integer NOT NULL
);


ALTER TABLE cine.participa OWNER TO bdi2022ad;

--
-- Name: pelicula; Type: TABLE; Schema: cine; Owner: bdi2022ad
--

CREATE TABLE cine.pelicula (
    id_pelicula integer NOT NULL,
    nombre character varying(50) NOT NULL,
    genero character varying(50),
    estreno integer NOT NULL,
    duracion integer NOT NULL,
    id_director integer,
    CONSTRAINT pelicula_duracion_check CHECK ((duracion > 45)),
    CONSTRAINT pelicula_estreno_check CHECK (((estreno >= 1900) AND (estreno <= 2022)))
);


ALTER TABLE cine.pelicula OWNER TO bdi2022ad;

--
-- Name: actores_accion; Type: VIEW; Schema: cine; Owner: bdi2022ad
--

CREATE VIEW cine.actores_accion AS
 SELECT a.id_actor,
    a.nombre,
    a.apellido,
    a.nacimiento,
    a.nacionalidad
   FROM cine.actor a,
    cine.participa par,
    cine.pelicula pel
  WHERE (((pel.genero)::text = 'acciÃ³n'::text) AND (pel.id_pelicula = par.id_pelicula) AND (a.id_actor = par.id_actor));


ALTER TABLE cine.actores_accion OWNER TO bdi2022ad;

--
-- Name: director; Type: TABLE; Schema: cine; Owner: bdi2022ad
--

CREATE TABLE cine.director (
    id_director integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50),
    nacimiento character varying(50),
    nacionalidad character varying(50)
);


ALTER TABLE cine.director OWNER TO bdi2022ad;

--
-- Name: empleados; Type: TABLE; Schema: empleados; Owner: bdi2022ad
--

CREATE TABLE empleados.empleados (
    id_empleado integer NOT NULL,
    nombre character varying(40),
    id_jefe integer
);


ALTER TABLE empleados.empleados OWNER TO bdi2022ad;

--
-- Name: actores_accion; Type: VIEW; Schema: lab3; Owner: bdi2022ad
--

CREATE VIEW lab3.actores_accion AS
 SELECT a.id_actor,
    a.nombre,
    a.apellido,
    a.nacimiento,
    a.nacionalidad
   FROM cine.actor a,
    cine.participa par,
    cine.pelicula pel
  WHERE (((pel.genero)::text = 'acciÃ³n'::text) AND (pel.id_pelicula = par.id_pelicula) AND (a.id_actor = par.id_actor));


ALTER TABLE lab3.actores_accion OWNER TO bdi2022ad;

--
-- Name: administrativo; Type: TABLE; Schema: lab3; Owner: bdi2022ad
--

CREATE TABLE lab3.administrativo (
    rut character varying(10) NOT NULL,
    nombre character varying(45) NOT NULL,
    fecha_nacimiento date,
    ciudad character varying(40) DEFAULT 'Concepción'::character varying,
    jornada character varying(25),
    CONSTRAINT administrativo_fecha_nacimiento_check CHECK ((fecha_nacimiento > '1900-01-01'::date)),
    CONSTRAINT administrativo_jornada_check CHECK (((jornada)::text = ANY ((ARRAY['completa'::character varying, 'medio tiempo'::character varying])::text[])))
);


ALTER TABLE lab3.administrativo OWNER TO bdi2022ad;

--
-- Name: local; Type: TABLE; Schema: locales_y_votantes; Owner: bdi2022ad
--

CREATE TABLE locales_y_votantes.local (
    nombre character varying(50) NOT NULL,
    comuna character varying(50),
    "región" character varying(50),
    cantidad_mesas integer
);


ALTER TABLE locales_y_votantes.local OWNER TO bdi2022ad;

--
-- Name: mesa; Type: TABLE; Schema: locales_y_votantes; Owner: bdi2022ad
--

CREATE TABLE locales_y_votantes.mesa (
    numero integer NOT NULL,
    cantidad_votantes integer,
    nombre_local character varying(50)
);


ALTER TABLE locales_y_votantes.mesa OWNER TO bdi2022ad;

--
-- Name: vocal; Type: TABLE; Schema: locales_y_votantes; Owner: bdi2022ad
--

CREATE TABLE locales_y_votantes.vocal (
    rut_vocal character varying(50) NOT NULL,
    numero_mesa integer
);


ALTER TABLE locales_y_votantes.vocal OWNER TO bdi2022ad;

--
-- Name: vota_en; Type: TABLE; Schema: locales_y_votantes; Owner: bdi2022ad
--

CREATE TABLE locales_y_votantes.vota_en (
    rut_votante character varying(50) NOT NULL,
    numero_mesa integer NOT NULL
);


ALTER TABLE locales_y_votantes.vota_en OWNER TO bdi2022ad;

--
-- Name: votante; Type: TABLE; Schema: locales_y_votantes; Owner: bdi2022ad
--

CREATE TABLE locales_y_votantes.votante (
    rut character varying(50) NOT NULL,
    nombre character varying(50),
    apellido character varying(50),
    fecha_nacimiento date,
    edad integer
);


ALTER TABLE locales_y_votantes.votante OWNER TO bdi2022ad;

--
-- Name: contacto; Type: TABLE; Schema: negocio; Owner: bdi2022ad
--

CREATE TABLE negocio.contacto (
    id_contacto integer NOT NULL,
    id_empresa integer,
    nombre character varying(40),
    email character varying(50)
);


ALTER TABLE negocio.contacto OWNER TO bdi2022ad;

--
-- Name: empresa; Type: TABLE; Schema: negocio; Owner: bdi2022ad
--

CREATE TABLE negocio.empresa (
    id_empresa integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE negocio.empresa OWNER TO bdi2022ad;

--
-- Name: numeros; Type: TABLE; Schema: numeros; Owner: bdi2022ad
--

CREATE TABLE numeros.numeros (
    numero integer NOT NULL,
    cuadrado integer,
    cubo integer,
    raiz2 real,
    raiz3 real
);


ALTER TABLE numeros.numeros OWNER TO bdi2022ad;

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
-- Name: arriendo; Type: TABLE; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE TABLE renta_equipos.arriendo (
    id_arriendo integer NOT NULL,
    fecha_arriendo date,
    id_cliente integer,
    id_inventario integer
);


ALTER TABLE renta_equipos.arriendo OWNER TO bdi2022ad;

--
-- Name: cliente; Type: TABLE; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE TABLE renta_equipos.cliente (
    id_cliente integer NOT NULL,
    nombre character varying(20),
    apellido character varying(20)
);


ALTER TABLE renta_equipos.cliente OWNER TO bdi2022ad;

--
-- Name: inventario; Type: TABLE; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE TABLE renta_equipos.inventario (
    id_inventario integer NOT NULL,
    nombre_equipo character varying(30)
);


ALTER TABLE renta_equipos.inventario OWNER TO bdi2022ad;

--
-- Name: reserva; Type: TABLE; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE TABLE renta_equipos.reserva (
    id_cliente integer NOT NULL,
    id_inventario integer NOT NULL,
    fecha_reserva date NOT NULL
);


ALTER TABLE renta_equipos.reserva OWNER TO bdi2022ad;

--
-- Name: arriendo; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.arriendo (
    id_arriendo integer NOT NULL,
    fecha_arriendo date,
    id_cliente integer,
    id_inventario integer
);


ALTER TABLE test2.arriendo OWNER TO bdi2022ad;

--
-- Name: asignatura; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.asignatura (
    id_asignatura integer NOT NULL,
    nombre character varying(50),
    creditos character varying(50)
);


ALTER TABLE test2.asignatura OWNER TO bdi2022ad;

--
-- Name: cliente; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.cliente (
    id_cliente integer NOT NULL,
    nombre character varying(50),
    apellido character varying(50)
);


ALTER TABLE test2.cliente OWNER TO bdi2022ad;

--
-- Name: inventario; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.inventario (
    id_inventario integer NOT NULL,
    nombre_equipo character varying(50)
);


ALTER TABLE test2.inventario OWNER TO bdi2022ad;

--
-- Name: prerequisito; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.prerequisito (
    id_asignatura integer NOT NULL,
    id_asignatura_prerequisito integer NOT NULL
);


ALTER TABLE test2.prerequisito OWNER TO bdi2022ad;

--
-- Name: producto; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.producto (
    id_producto integer NOT NULL,
    nombre_producto character varying(50),
    descripcion character varying(50),
    stock integer
);


ALTER TABLE test2.producto OWNER TO bdi2022ad;

--
-- Name: renovar_stock; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.renovar_stock (
    id_producto integer NOT NULL,
    stock_actual integer NOT NULL
);


ALTER TABLE test2.renovar_stock OWNER TO bdi2022ad;

--
-- Name: reserva; Type: TABLE; Schema: test2; Owner: bdi2022ad
--

CREATE TABLE test2.reserva (
    id_cliente integer NOT NULL,
    id_inventario integer NOT NULL,
    fecha_reserva date NOT NULL
);


ALTER TABLE test2.reserva OWNER TO bdi2022ad;

--
-- Name: reservas; Type: VIEW; Schema: test2; Owner: bdi2022ad
--

CREATE VIEW test2.reservas AS
 SELECT c.nombre,
    c.apellido,
    i.nombre_equipo,
    r.fecha_reserva
   FROM test2.cliente c,
    test2.reserva r,
    test2.inventario i
  WHERE ((c.id_cliente = r.id_cliente) AND (r.id_inventario = i.id_inventario))
  ORDER BY r.fecha_reserva;


ALTER TABLE test2.reservas OWNER TO bdi2022ad;

--
-- Name: asignatura; Type: TABLE; Schema: universidad; Owner: bdi2022ad
--

CREATE TABLE universidad.asignatura (
    codigo_asignatura integer NOT NULL,
    nombre character varying(30),
    creditos integer
);


ALTER TABLE universidad.asignatura OWNER TO bdi2022ad;

--
-- Name: docente; Type: TABLE; Schema: universidad; Owner: bdi2022ad
--

CREATE TABLE universidad.docente (
    rut character varying(10) NOT NULL,
    nombre character varying(30),
    mail character varying(30)
);


ALTER TABLE universidad.docente OWNER TO bdi2022ad;

--
-- Name: estudiante; Type: TABLE; Schema: universidad; Owner: bdi2022ad
--

CREATE TABLE universidad.estudiante (
    matricula integer NOT NULL,
    rut character varying(10),
    nombre character varying(30),
    carrera character varying(30),
    mail character varying(30)
);


ALTER TABLE universidad.estudiante OWNER TO bdi2022ad;

--
-- Name: imparte; Type: TABLE; Schema: universidad; Owner: bdi2022ad
--

CREATE TABLE universidad.imparte (
    rut_d character varying(10) NOT NULL,
    codigo_asignatura_a integer NOT NULL
);


ALTER TABLE universidad.imparte OWNER TO bdi2022ad;

--
-- Name: tiene; Type: TABLE; Schema: universidad; Owner: bdi2022ad
--

CREATE TABLE universidad.tiene (
    matricula_e integer NOT NULL,
    codigo_asignatura integer NOT NULL
);


ALTER TABLE universidad.tiene OWNER TO bdi2022ad;

--
-- Data for Name: administrativo; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.administrativo VALUES ('6412894', 'Felipe Figueroa', '2000-12-31', 'Concepción', 'completa');


--
-- Data for Name: asignatura; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.asignatura VALUES (503307, 'Bases de Datos I', 3);
INSERT INTO actividad_final.asignatura VALUES (504850, 'Programacion I', 3);
INSERT INTO actividad_final.asignatura VALUES (650480, 'Estadistica', 2);
INSERT INTO actividad_final.asignatura VALUES (684201, 'Estructuras de Datos', 3);
INSERT INTO actividad_final.asignatura VALUES (784098, 'Quimica I', 2);
INSERT INTO actividad_final.asignatura VALUES (503541, 'Fisica I', 2);
INSERT INTO actividad_final.asignatura VALUES (503354, 'Optimizacion I', 2);
INSERT INTO actividad_final.asignatura VALUES (417067, 'Logica', 2);
INSERT INTO actividad_final.asignatura VALUES (503308, 'Sistemas Operativos', 2);
INSERT INTO actividad_final.asignatura VALUES (505480, 'Termodinamica', 3);
INSERT INTO actividad_final.asignatura VALUES (405163, 'Calculo III', 4);


--
-- Data for Name: docente; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.docente VALUES ('8965745-1', 'Felipe Solar', 'fsolar@udec.cl');
INSERT INTO actividad_final.docente VALUES ('10252365-4', 'Adriana Burgos', 'aburgos@udec.cl');
INSERT INTO actividad_final.docente VALUES ('9584556-0', 'Leandro Mora', 'lmora@udec.cl');
INSERT INTO actividad_final.docente VALUES ('11454748-2', 'Elisa Sanchez', 'esanchez@udec.cl');
INSERT INTO actividad_final.docente VALUES ('9658401-5', 'Omar Gutierrez', 'ogutierrez@udec.cl');
INSERT INTO actividad_final.docente VALUES ('13254778-1', 'Romina Castillo', 'rcastillo@udec.cl');
INSERT INTO actividad_final.docente VALUES ('9968854-4', 'Pablo Arriagada', 'parriagada@udec.cl');
INSERT INTO actividad_final.docente VALUES ('11587958-3', 'Mario Martinez', 'mmartinez@udec.cl');
INSERT INTO actividad_final.docente VALUES ('10454871-1', 'Catalina Correa', 'ccorrea@udec.cl');
INSERT INTO actividad_final.docente VALUES ('9852416-5', 'Natalia Gonzalez', 'ngonzalez@udec.cl');


--
-- Data for Name: estudiante; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.estudiante VALUES (2017401626, '20345698-5', 'Juan Perez', 'Ingenieria Civil', 'jperez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2018502896, '21265501-k', 'Jorge Llanos', 'Ingenieria Civil Informatica', 'jllanos@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2017129874, '20665850-4', 'Julieta Rodriguez', 'Ingenieria Civil 
Mecanica', 'jurodriguez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019852634, '19850634-7', 'Julio Hernandez', 'Ingenieria Civil 
Informatica', 'jhernandez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2020459637, '21584687-8', 'Andrea Barra', 'Biologia Marina', 'abarra@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2020459153, '20544889-7', 'Viviana Lopez', 'Ingenieria Civil 
Informatica', 'vlopez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2021568435, '21145668-2', 'Francisco Castro', 'Ingenieria Civil 
Matematica', 'fcastro@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2017589144, '20657881-1', 'Alejandro Fuentalba', 'Ingenieria Civil 
Informatica', 'afuentalba@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2018962452, '21554682-0', 'Ernesto Serrano', 'Derecho', 'eserrano@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019625050, '20960588-1', 'Antonio Millar', 'Ingenieria Civil 
Industrial', 'amillar@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2020152305, '18985640-k', 'Camilo Torres', 'Ingenieria Civil Quimica', 'ctorres@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2021698351, '20325148-6', 'Elizabeth Perez', 'Ingenieria Civil 
Informatica', 'jperez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2021596750, '21348569-7', 'Rosa Rozas', 'Ingenieria Civil Electronica', 'rorozas@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2021784585, '20369696-8', 'Camila Palacios', 'Pedagogia en Ingles', 'cpalacios@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2020158895, '20954752-0', 'Violeta Marin', 'Educacion Fisica', 'vmarin@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019835204, '19854474-3', 'Nicole San Martin', 'Fisica', 'nsanmartin@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019696985, '18505476-1', 'Patricio Fernandez', 'Ingenieria Civil 
Informatica', 'pfernandez@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019655054, '20785854-5', 'Valentina Rios', 'Ingenieria Civil en 
Telecomunicaciones', 'vrios@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2017925563, '18699845-4', 'Ignacio Rubilar', 'Quimica', 'irubilar@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019650581, '16852046-2', 'Isabel Flores', 'Ingenieria Civil 
Informatica', 'iflores@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019962505, '17894458-4', 'Ana Fritz', 'Pedagogia en Matematica', 'afritz@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2018744522, '19015746-3', 'Loreto Contreras', 'Auditoria', 'lcontreras@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2019012535, '21253648-0', 'Ivonne Inostroza', 'Ingenieria Civil 
Informatica', 'iinostroza@udec.cl');
INSERT INTO actividad_final.estudiante VALUES (2021456504, '19745623-k', 'Catherine Gallegos', 'Ingenieria Civil', 'cgallegos@udec.cl');


--
-- Data for Name: imparte; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.imparte VALUES ('8965745-1', 503307);
INSERT INTO actividad_final.imparte VALUES ('11587958-3', 684201);
INSERT INTO actividad_final.imparte VALUES ('11587958-3', 504850);
INSERT INTO actividad_final.imparte VALUES ('10252365-4', 650480);
INSERT INTO actividad_final.imparte VALUES ('9584556-0', 784098);
INSERT INTO actividad_final.imparte VALUES ('11454748-2', 503541);
INSERT INTO actividad_final.imparte VALUES ('9658401-5', 503354);
INSERT INTO actividad_final.imparte VALUES ('13254778-1', 417067);
INSERT INTO actividad_final.imparte VALUES ('9968854-4', 503308);
INSERT INTO actividad_final.imparte VALUES ('10454871-1', 505480);
INSERT INTO actividad_final.imparte VALUES ('9852416-5', 405163);


--
-- Data for Name: tiene; Type: TABLE DATA; Schema: actividad_final; Owner: bdi2022ad
--

INSERT INTO actividad_final.tiene VALUES (2017401626, 503307);
INSERT INTO actividad_final.tiene VALUES (2017401626, 503308);
INSERT INTO actividad_final.tiene VALUES (2018502896, 504850);
INSERT INTO actividad_final.tiene VALUES (2018502896, 684201);
INSERT INTO actividad_final.tiene VALUES (2018502896, 417067);
INSERT INTO actividad_final.tiene VALUES (2017129874, 503541);
INSERT INTO actividad_final.tiene VALUES (2017129874, 505480);
INSERT INTO actividad_final.tiene VALUES (2019852634, 405163);
INSERT INTO actividad_final.tiene VALUES (2019852634, 503308);
INSERT INTO actividad_final.tiene VALUES (2019852634, 503307);
INSERT INTO actividad_final.tiene VALUES (2020459637, 784098);
INSERT INTO actividad_final.tiene VALUES (2020459637, 503541);
INSERT INTO actividad_final.tiene VALUES (2020459637, 650480);
INSERT INTO actividad_final.tiene VALUES (2020459153, 650480);
INSERT INTO actividad_final.tiene VALUES (2020459153, 504850);
INSERT INTO actividad_final.tiene VALUES (2020459153, 684201);
INSERT INTO actividad_final.tiene VALUES (2020459153, 784098);
INSERT INTO actividad_final.tiene VALUES (2021568435, 503307);
INSERT INTO actividad_final.tiene VALUES (2021568435, 684201);
INSERT INTO actividad_final.tiene VALUES (2021568435, 650480);
INSERT INTO actividad_final.tiene VALUES (2017589144, 503541);
INSERT INTO actividad_final.tiene VALUES (2017589144, 503307);
INSERT INTO actividad_final.tiene VALUES (2018962452, 417067);
INSERT INTO actividad_final.tiene VALUES (2018962452, 504850);
INSERT INTO actividad_final.tiene VALUES (2018962452, 503308);
INSERT INTO actividad_final.tiene VALUES (2019625050, 503307);
INSERT INTO actividad_final.tiene VALUES (2019625050, 650480);
INSERT INTO actividad_final.tiene VALUES (2019625050, 504850);
INSERT INTO actividad_final.tiene VALUES (2020152305, 405163);
INSERT INTO actividad_final.tiene VALUES (2020152305, 784098);
INSERT INTO actividad_final.tiene VALUES (2021698351, 417067);
INSERT INTO actividad_final.tiene VALUES (2021698351, 504850);
INSERT INTO actividad_final.tiene VALUES (2021596750, 405163);
INSERT INTO actividad_final.tiene VALUES (2021596750, 417067);
INSERT INTO actividad_final.tiene VALUES (2021784585, 503307);
INSERT INTO actividad_final.tiene VALUES (2021784585, 505480);
INSERT INTO actividad_final.tiene VALUES (2021784585, 784098);
INSERT INTO actividad_final.tiene VALUES (2020158895, 503354);
INSERT INTO actividad_final.tiene VALUES (2020158895, 504850);
INSERT INTO actividad_final.tiene VALUES (2019835204, 505480);
INSERT INTO actividad_final.tiene VALUES (2019835204, 650480);
INSERT INTO actividad_final.tiene VALUES (2019696985, 503308);
INSERT INTO actividad_final.tiene VALUES (2019696985, 503307);
INSERT INTO actividad_final.tiene VALUES (2019655054, 505480);
INSERT INTO actividad_final.tiene VALUES (2019655054, 684201);
INSERT INTO actividad_final.tiene VALUES (2019655054, 784098);
INSERT INTO actividad_final.tiene VALUES (2017925563, 503354);
INSERT INTO actividad_final.tiene VALUES (2017925563, 650480);
INSERT INTO actividad_final.tiene VALUES (2019650581, 405163);
INSERT INTO actividad_final.tiene VALUES (2019650581, 503307);
INSERT INTO actividad_final.tiene VALUES (2019962505, 503541);
INSERT INTO actividad_final.tiene VALUES (2019962505, 417067);
INSERT INTO actividad_final.tiene VALUES (2018744522, 650480);
INSERT INTO actividad_final.tiene VALUES (2018744522, 684201);
INSERT INTO actividad_final.tiene VALUES (2018744522, 504850);
INSERT INTO actividad_final.tiene VALUES (2019012535, 503308);
INSERT INTO actividad_final.tiene VALUES (2019012535, 503354);
INSERT INTO actividad_final.tiene VALUES (2021456504, 650480);
INSERT INTO actividad_final.tiene VALUES (2021456504, 684201);
INSERT INTO actividad_final.tiene VALUES (2021456504, 784098);


--
-- Data for Name: propietario; Type: TABLE DATA; Schema: autos; Owner: bdi2022ad
--

INSERT INTO autos.propietario VALUES ('8738936-0', 'Diego', 'Muñoz', 'Valparaíso');
INSERT INTO autos.propietario VALUES ('5986345-8', 'María', 'Peña', 'Concepción');
INSERT INTO autos.propietario VALUES ('8766932-0', 'Abraham', 'Pérez', 'Puerto Varas');
INSERT INTO autos.propietario VALUES ('4857362-1', 'Cecilia', 'Rojas', 'Santiago');


--
-- Data for Name: vehiculo; Type: TABLE DATA; Schema: autos; Owner: bdi2022ad
--

INSERT INTO autos.vehiculo VALUES ('GTSJ57', 'Suzuki', 'Swift', '5986345-8', 95863);
INSERT INTO autos.vehiculo VALUES ('JVTR99', 'Renault', 'Duster', '5986345-8', 65320);
INSERT INTO autos.vehiculo VALUES ('LKPT25', 'Toyota', 'Yaris', '4857362-1', 4528);
INSERT INTO autos.vehiculo VALUES ('HPTT25', 'Nissan', 'NP300', '4857362-1', 103698);


--
-- Data for Name: actor; Type: TABLE DATA; Schema: cine; Owner: bdi2022ad
--

INSERT INTO cine.actor VALUES (0, 'Mark', 'Hamill', '1951-09-25', 'Estados Unidos');
INSERT INTO cine.actor VALUES (1, 'Harrison', 'Ford', '1942-07-13', 'Estados Unidos');
INSERT INTO cine.actor VALUES (2, 'Carrie', 'Fisher', '1956-10-21', 'Estados Unidos');
INSERT INTO cine.actor VALUES (3, 'Mattew', 'McConaughey', '1969-11-04', 'Estados Unidos');
INSERT INTO cine.actor VALUES (4, 'Anne', 'Hathaway', '1982-11-12', 'Estados Unidos');
INSERT INTO cine.actor VALUES (5, 'Michael', 'Caine', '1933-03-14', 'Reino Unido');
INSERT INTO cine.actor VALUES (6, 'Barry', 'Keoghan', '1992-10-17', 'Irlanda');
INSERT INTO cine.actor VALUES (7, 'Harvey', 'Keitel', '1939-05-13', 'Estados Unidos');
INSERT INTO cine.actor VALUES (8, 'Tim', 'Roth', '1961-05-14', 'Reino Unido');
INSERT INTO cine.actor VALUES (9, 'Michael', 'Madsen', '1957-09-25', 'Estados Unidos');
INSERT INTO cine.actor VALUES (10, 'Guy', 'Pearce', '1967-10-05', 'Reino Unido');
INSERT INTO cine.actor VALUES (11, 'Carrie-Anne', 'Moss', '1967-08-21', 'CanadÃ¡');
INSERT INTO cine.actor VALUES (12, 'Uma', 'Thurman', '1970-04-29', 'Estados Unidos');
INSERT INTO cine.actor VALUES (13, 'Samuel L.', 'Jackson', '1948-12-21', 'Estados Unidos');
INSERT INTO cine.actor VALUES (14, 'Daryl', 'Hannah', '1960-12-03', 'Estados Unidos');
INSERT INTO cine.actor VALUES (15, 'Christian', 'Bale', '1974-01-30', 'Reino Unido');
INSERT INTO cine.actor VALUES (16, 'Ewan', 'McGregor', '1971-03-31', 'Reino Unido');
INSERT INTO cine.actor VALUES (17, 'Liam', 'Neeson', '1952-06-07', 'Reino Unido');
INSERT INTO cine.actor VALUES (18, 'Natalie', 'Portman', '1981-06-09', 'Estados Unidos');
INSERT INTO cine.actor VALUES (19, 'Keanu', 'Reeves', '1964-09-02', 'CanadÃ¡');
INSERT INTO cine.actor VALUES (20, 'Patrick', 'Swayze', '1952-08-18', 'Estados Unidos');


--
-- Data for Name: director; Type: TABLE DATA; Schema: cine; Owner: bdi2022ad
--

INSERT INTO cine.director VALUES (0, 'Quentin', 'Tarantino', '27/03/1963', 'Estados Unidos');
INSERT INTO cine.director VALUES (1, 'George', 'Lucas', '14/03/1944', 'Estados Unidos');
INSERT INTO cine.director VALUES (2, 'Christopher', 'Nolan', '30/07/1970', 'Reino Unido');
INSERT INTO cine.director VALUES (3, 'Kathryn', 'Bigelow', '27/11/1951', 'Estados Unidos');


--
-- Data for Name: participa; Type: TABLE DATA; Schema: cine; Owner: bdi2022ad
--

INSERT INTO cine.participa VALUES (0, 7);
INSERT INTO cine.participa VALUES (0, 8);
INSERT INTO cine.participa VALUES (0, 9);
INSERT INTO cine.participa VALUES (1, 7);
INSERT INTO cine.participa VALUES (1, 8);
INSERT INTO cine.participa VALUES (1, 12);
INSERT INTO cine.participa VALUES (1, 13);
INSERT INTO cine.participa VALUES (2, 12);
INSERT INTO cine.participa VALUES (2, 13);
INSERT INTO cine.participa VALUES (2, 14);
INSERT INTO cine.participa VALUES (3, 0);
INSERT INTO cine.participa VALUES (3, 1);
INSERT INTO cine.participa VALUES (3, 2);
INSERT INTO cine.participa VALUES (4, 13);
INSERT INTO cine.participa VALUES (4, 16);
INSERT INTO cine.participa VALUES (4, 17);
INSERT INTO cine.participa VALUES (4, 18);
INSERT INTO cine.participa VALUES (5, 11);
INSERT INTO cine.participa VALUES (5, 10);
INSERT INTO cine.participa VALUES (6, 15);
INSERT INTO cine.participa VALUES (6, 5);
INSERT INTO cine.participa VALUES (7, 5);
INSERT INTO cine.participa VALUES (7, 4);
INSERT INTO cine.participa VALUES (7, 3);
INSERT INTO cine.participa VALUES (8, 6);
INSERT INTO cine.participa VALUES (9, 15);
INSERT INTO cine.participa VALUES (9, 5);
INSERT INTO cine.participa VALUES (9, 17);
INSERT INTO cine.participa VALUES (10, 19);
INSERT INTO cine.participa VALUES (10, 20);


--
-- Data for Name: pelicula; Type: TABLE DATA; Schema: cine; Owner: bdi2022ad
--

INSERT INTO cine.pelicula VALUES (0, 'Reservoir Dogs', 'crimen', 1992, 99, 0);
INSERT INTO cine.pelicula VALUES (1, 'Pulp Fiction', 'crimen', 1994, 154, 0);
INSERT INTO cine.pelicula VALUES (2, 'Kill Bill: vol 1', 'acciÃ³n', 2003, 111, 0);
INSERT INTO cine.pelicula VALUES (3, 'Star Wars', 'fantasÃ-a', 1977, 121, 1);
INSERT INTO cine.pelicula VALUES (4, 'Star Wars: Episode I', 'fantasÃ-a', 1999, 136, 1);
INSERT INTO cine.pelicula VALUES (5, 'Memento', 'thriller', 2000, 113, 2);
INSERT INTO cine.pelicula VALUES (6, 'The Prestige', 'misterio', 2006, 130, 2);
INSERT INTO cine.pelicula VALUES (7, 'Interstellar', 'ciencia ficciÃ³n', 2014, 169, 2);
INSERT INTO cine.pelicula VALUES (8, 'Dunkirk', 'drama', 2017, 106, 2);
INSERT INTO cine.pelicula VALUES (9, 'Batman Begins', 'acciÃ³n', 2005, 140, 2);
INSERT INTO cine.pelicula VALUES (10, 'Point Break', 'acciÃ³n', 1991, 122, 3);


--
-- Data for Name: empleados; Type: TABLE DATA; Schema: empleados; Owner: bdi2022ad
--

INSERT INTO empleados.empleados VALUES (1, 'María', NULL);
INSERT INTO empleados.empleados VALUES (2, 'Juan', 1);
INSERT INTO empleados.empleados VALUES (3, 'Marcela', 1);
INSERT INTO empleados.empleados VALUES (4, 'Marcos', 3);
INSERT INTO empleados.empleados VALUES (5, 'Isabel', 3);
INSERT INTO empleados.empleados VALUES (6, 'Diego', 1);
INSERT INTO empleados.empleados VALUES (7, 'Ignacio', 6);
INSERT INTO empleados.empleados VALUES (8, 'Maricela', 6);
INSERT INTO empleados.empleados VALUES (9, 'Cecilia', 6);
INSERT INTO empleados.empleados VALUES (10, 'Cristian', 9);
INSERT INTO empleados.empleados VALUES (11, 'Juana', 6);
INSERT INTO empleados.empleados VALUES (12, 'Elias', 1);
INSERT INTO empleados.empleados VALUES (13, 'Rene', 1);
INSERT INTO empleados.empleados VALUES (14, 'Pedro', 13);


--
-- Data for Name: administrativo; Type: TABLE DATA; Schema: lab3; Owner: bdi2022ad
--



--
-- Data for Name: local; Type: TABLE DATA; Schema: locales_y_votantes; Owner: bdi2022ad
--

INSERT INTO locales_y_votantes.local VALUES ('Quintero', 'Quintero', 'Valparaíso', 35);
INSERT INTO locales_y_votantes.local VALUES ('Buchupureo', 'Cobquecura', 'Ñuble', 28);
INSERT INTO locales_y_votantes.local VALUES ('Salamanca', 'Salamanca', 'Coquimbo', 19);


--
-- Data for Name: mesa; Type: TABLE DATA; Schema: locales_y_votantes; Owner: bdi2022ad
--

INSERT INTO locales_y_votantes.mesa VALUES (1, 1850, 'Quintero');
INSERT INTO locales_y_votantes.mesa VALUES (2, 24500, 'Buchupureo');
INSERT INTO locales_y_votantes.mesa VALUES (3, 101000, 'Salamanca');


--
-- Data for Name: vocal; Type: TABLE DATA; Schema: locales_y_votantes; Owner: bdi2022ad
--

INSERT INTO locales_y_votantes.vocal VALUES ('11231444-5', 3);


--
-- Data for Name: vota_en; Type: TABLE DATA; Schema: locales_y_votantes; Owner: bdi2022ad
--

INSERT INTO locales_y_votantes.vota_en VALUES ('11231444-5', 3);
INSERT INTO locales_y_votantes.vota_en VALUES ('18456123-7', 3);
INSERT INTO locales_y_votantes.vota_en VALUES ('4321890-K', 3);


--
-- Data for Name: votante; Type: TABLE DATA; Schema: locales_y_votantes; Owner: bdi2022ad
--

INSERT INTO locales_y_votantes.votante VALUES ('11231444-5', 'Megumi', 'Sepúlveda', '1990-12-14', 31);
INSERT INTO locales_y_votantes.votante VALUES ('18456123-7', 'Violet', 'Martinez', '1890-01-23', 132);
INSERT INTO locales_y_votantes.votante VALUES ('4321890-K', 'Rimuru', 'Contreras', '1980-09-18', 41);


--
-- Data for Name: contacto; Type: TABLE DATA; Schema: negocio; Owner: bdi2022ad
--

INSERT INTO negocio.contacto VALUES (3, 2, 'Jeff Bezos', 'bigboss@amazon.com');


--
-- Data for Name: empresa; Type: TABLE DATA; Schema: negocio; Owner: bdi2022ad
--

INSERT INTO negocio.empresa VALUES (2, 'Amazon');


--
-- Data for Name: numeros; Type: TABLE DATA; Schema: numeros; Owner: bdi2022ad
--

INSERT INTO numeros.numeros VALUES (1, 1, 1, 1, 1);
INSERT INTO numeros.numeros VALUES (2, 4, 8, 1.41421354, 1.41421354);
INSERT INTO numeros.numeros VALUES (4, 16, 64, 2, 2);
INSERT INTO numeros.numeros VALUES (27, 729, 19683, 5.19615221, 5.19615221);


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
-- Data for Name: arriendo; Type: TABLE DATA; Schema: renta_equipos; Owner: bdi2022ad
--



--
-- Data for Name: cliente; Type: TABLE DATA; Schema: renta_equipos; Owner: bdi2022ad
--

INSERT INTO renta_equipos.cliente VALUES (1, 'Jack', 'Johnson');
INSERT INTO renta_equipos.cliente VALUES (2, 'John', 'Jackson');
INSERT INTO renta_equipos.cliente VALUES (3, 'Bender', 'Rodríguez');
INSERT INTO renta_equipos.cliente VALUES (4, 'Philip', 'Fry');
INSERT INTO renta_equipos.cliente VALUES (5, 'Turanga', 'Leela');
INSERT INTO renta_equipos.cliente VALUES (6, 'Amy', 'Wong');
INSERT INTO renta_equipos.cliente VALUES (7, 'Jon', 'Zoidberg');
INSERT INTO renta_equipos.cliente VALUES (8, 'Hermes', 'Conrad');


--
-- Data for Name: inventario; Type: TABLE DATA; Schema: renta_equipos; Owner: bdi2022ad
--

INSERT INTO renta_equipos.inventario VALUES (1, 'Taladro Percutor');
INSERT INTO renta_equipos.inventario VALUES (2, 'Mezcladora');
INSERT INTO renta_equipos.inventario VALUES (3, 'Generador 1500W');
INSERT INTO renta_equipos.inventario VALUES (4, 'Generador 2000W');
INSERT INTO renta_equipos.inventario VALUES (5, 'Motosierra');
INSERT INTO renta_equipos.inventario VALUES (6, 'Soldadora');


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: renta_equipos; Owner: bdi2022ad
--

INSERT INTO renta_equipos.reserva VALUES (3, 5, '2022-09-20');
INSERT INTO renta_equipos.reserva VALUES (3, 6, '2022-09-21');
INSERT INTO renta_equipos.reserva VALUES (1, 3, '2022-09-19');
INSERT INTO renta_equipos.reserva VALUES (2, 2, '2022-09-22');
INSERT INTO renta_equipos.reserva VALUES (8, 6, '2022-09-18');
INSERT INTO renta_equipos.reserva VALUES (1, 3, '2022-09-28');


--
-- Data for Name: arriendo; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--



--
-- Data for Name: asignatura; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--

INSERT INTO test2.asignatura VALUES (1, 'Base', '2');
INSERT INTO test2.asignatura VALUES (2, 'Teoria', '3');
INSERT INTO test2.asignatura VALUES (3, 'Arquitectura', '4');


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--



--
-- Data for Name: inventario; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--



--
-- Data for Name: prerequisito; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--

INSERT INTO test2.prerequisito VALUES (2, 1);
INSERT INTO test2.prerequisito VALUES (3, 2);


--
-- Data for Name: producto; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--

INSERT INTO test2.producto VALUES (1, 'martillo', 'algo', 4);


--
-- Data for Name: renovar_stock; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--

INSERT INTO test2.renovar_stock VALUES (1, 4);


--
-- Data for Name: reserva; Type: TABLE DATA; Schema: test2; Owner: bdi2022ad
--



--
-- Data for Name: asignatura; Type: TABLE DATA; Schema: universidad; Owner: bdi2022ad
--



--
-- Data for Name: docente; Type: TABLE DATA; Schema: universidad; Owner: bdi2022ad
--



--
-- Data for Name: estudiante; Type: TABLE DATA; Schema: universidad; Owner: bdi2022ad
--



--
-- Data for Name: imparte; Type: TABLE DATA; Schema: universidad; Owner: bdi2022ad
--



--
-- Data for Name: tiene; Type: TABLE DATA; Schema: universidad; Owner: bdi2022ad
--



--
-- Name: administrativo administrativo_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.administrativo
    ADD CONSTRAINT administrativo_pkey PRIMARY KEY (rut);


--
-- Name: asignatura asignatura_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.asignatura
    ADD CONSTRAINT asignatura_pkey PRIMARY KEY (codigo_asignatura);


--
-- Name: docente docente_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY (rut);


--
-- Name: estudiante estudiante_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (matricula);


--
-- Name: imparte imparte_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.imparte
    ADD CONSTRAINT imparte_pkey PRIMARY KEY (rut, codigo_asignatura);


--
-- Name: tiene tiene_pkey; Type: CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.tiene
    ADD CONSTRAINT tiene_pkey PRIMARY KEY (matricula, codigo_asignatura);


--
-- Name: propietario propietario_pkey; Type: CONSTRAINT; Schema: autos; Owner: bdi2022ad
--

ALTER TABLE ONLY autos.propietario
    ADD CONSTRAINT propietario_pkey PRIMARY KEY (rut);


--
-- Name: vehiculo vehiculo_pkey; Type: CONSTRAINT; Schema: autos; Owner: bdi2022ad
--

ALTER TABLE ONLY autos.vehiculo
    ADD CONSTRAINT vehiculo_pkey PRIMARY KEY (patente);


--
-- Name: actor actor_pkey; Type: CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (id_actor);


--
-- Name: director director_pkey; Type: CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.director
    ADD CONSTRAINT director_pkey PRIMARY KEY (id_director);


--
-- Name: participa participa_pkey; Type: CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.participa
    ADD CONSTRAINT participa_pkey PRIMARY KEY (id_pelicula, id_actor);


--
-- Name: pelicula pelicula_pkey; Type: CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.pelicula
    ADD CONSTRAINT pelicula_pkey PRIMARY KEY (id_pelicula);


--
-- Name: empleados empleados_pkey; Type: CONSTRAINT; Schema: empleados; Owner: bdi2022ad
--

ALTER TABLE ONLY empleados.empleados
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (id_empleado);


--
-- Name: administrativo administrativo_pkey; Type: CONSTRAINT; Schema: lab3; Owner: bdi2022ad
--

ALTER TABLE ONLY lab3.administrativo
    ADD CONSTRAINT administrativo_pkey PRIMARY KEY (rut);


--
-- Name: local local_pkey; Type: CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.local
    ADD CONSTRAINT local_pkey PRIMARY KEY (nombre);


--
-- Name: mesa mesa_pkey; Type: CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.mesa
    ADD CONSTRAINT mesa_pkey PRIMARY KEY (numero);


--
-- Name: vocal vocal_pkey; Type: CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vocal
    ADD CONSTRAINT vocal_pkey PRIMARY KEY (rut_vocal);


--
-- Name: vota_en vota_en_pkey; Type: CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vota_en
    ADD CONSTRAINT vota_en_pkey PRIMARY KEY (rut_votante, numero_mesa);


--
-- Name: votante votante_pkey; Type: CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.votante
    ADD CONSTRAINT votante_pkey PRIMARY KEY (rut);


--
-- Name: contacto contacto_pkey; Type: CONSTRAINT; Schema: negocio; Owner: bdi2022ad
--

ALTER TABLE ONLY negocio.contacto
    ADD CONSTRAINT contacto_pkey PRIMARY KEY (id_contacto);


--
-- Name: empresa empresa_pkey; Type: CONSTRAINT; Schema: negocio; Owner: bdi2022ad
--

ALTER TABLE ONLY negocio.empresa
    ADD CONSTRAINT empresa_pkey PRIMARY KEY (id_empresa);


--
-- Name: numeros numeros_pkey; Type: CONSTRAINT; Schema: numeros; Owner: bdi2022ad
--

ALTER TABLE ONLY numeros.numeros
    ADD CONSTRAINT numeros_pkey PRIMARY KEY (numero);


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
-- Name: arriendo arriendo_pkey; Type: CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.arriendo
    ADD CONSTRAINT arriendo_pkey PRIMARY KEY (id_arriendo);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);


--
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- Name: reserva reserva_pkey; Type: CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.reserva
    ADD CONSTRAINT reserva_pkey PRIMARY KEY (id_cliente, id_inventario, fecha_reserva);


--
-- Name: arriendo arriendo_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.arriendo
    ADD CONSTRAINT arriendo_pkey PRIMARY KEY (id_arriendo);


--
-- Name: asignatura asignatura_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.asignatura
    ADD CONSTRAINT asignatura_pkey PRIMARY KEY (id_asignatura);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);


--
-- Name: inventario inventario_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);


--
-- Name: prerequisito prerequisito_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.prerequisito
    ADD CONSTRAINT prerequisito_pkey PRIMARY KEY (id_asignatura, id_asignatura_prerequisito);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);


--
-- Name: renovar_stock renovar_stock_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.renovar_stock
    ADD CONSTRAINT renovar_stock_pkey PRIMARY KEY (id_producto, stock_actual);


--
-- Name: reserva reserva_pkey; Type: CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.reserva
    ADD CONSTRAINT reserva_pkey PRIMARY KEY (id_cliente, id_inventario, fecha_reserva);


--
-- Name: asignatura asignatura_pkey; Type: CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.asignatura
    ADD CONSTRAINT asignatura_pkey PRIMARY KEY (codigo_asignatura);


--
-- Name: docente docente_pkey; Type: CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.docente
    ADD CONSTRAINT docente_pkey PRIMARY KEY (rut);


--
-- Name: estudiante estudiante_pkey; Type: CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.estudiante
    ADD CONSTRAINT estudiante_pkey PRIMARY KEY (matricula);


--
-- Name: imparte imparte_pkey; Type: CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.imparte
    ADD CONSTRAINT imparte_pkey PRIMARY KEY (rut_d, codigo_asignatura_a);


--
-- Name: tiene tiene_pkey; Type: CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.tiene
    ADD CONSTRAINT tiene_pkey PRIMARY KEY (matricula_e, codigo_asignatura);


--
-- Name: numeros rellenar_datos; Type: TRIGGER; Schema: numeros; Owner: bdi2022ad
--

CREATE TRIGGER rellenar_datos BEFORE INSERT OR UPDATE ON numeros.numeros FOR EACH ROW EXECUTE PROCEDURE numeros.rellenar_datos();


--
-- Name: reserva contar_reserva; Type: TRIGGER; Schema: renta_equipos; Owner: bdi2022ad
--

CREATE TRIGGER contar_reserva BEFORE INSERT ON renta_equipos.reserva FOR EACH ROW EXECUTE PROCEDURE renta_equipos.contar_reserva();


--
-- Name: producto funcion_stock; Type: TRIGGER; Schema: test2; Owner: bdi2022ad
--

CREATE TRIGGER funcion_stock AFTER UPDATE ON test2.producto FOR EACH ROW EXECUTE PROCEDURE test2.funcion_stock();


--
-- Name: imparte imparte_codigo_asignatura_fkey; Type: FK CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.imparte
    ADD CONSTRAINT imparte_codigo_asignatura_fkey FOREIGN KEY (codigo_asignatura) REFERENCES actividad_final.asignatura(codigo_asignatura);


--
-- Name: imparte imparte_rut_fkey; Type: FK CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.imparte
    ADD CONSTRAINT imparte_rut_fkey FOREIGN KEY (rut) REFERENCES actividad_final.docente(rut);


--
-- Name: tiene tiene_codigo_asignatura_fkey; Type: FK CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.tiene
    ADD CONSTRAINT tiene_codigo_asignatura_fkey FOREIGN KEY (codigo_asignatura) REFERENCES actividad_final.asignatura(codigo_asignatura);


--
-- Name: tiene tiene_matricula_fkey; Type: FK CONSTRAINT; Schema: actividad_final; Owner: bdi2022ad
--

ALTER TABLE ONLY actividad_final.tiene
    ADD CONSTRAINT tiene_matricula_fkey FOREIGN KEY (matricula) REFERENCES actividad_final.estudiante(matricula);


--
-- Name: vehiculo vehiculo_rut_fkey; Type: FK CONSTRAINT; Schema: autos; Owner: bdi2022ad
--

ALTER TABLE ONLY autos.vehiculo
    ADD CONSTRAINT vehiculo_rut_fkey FOREIGN KEY (rut) REFERENCES autos.propietario(rut);


--
-- Name: participa participa_id_actor_fkey; Type: FK CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.participa
    ADD CONSTRAINT participa_id_actor_fkey FOREIGN KEY (id_actor) REFERENCES cine.actor(id_actor) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: participa participa_id_pelicula_fkey; Type: FK CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.participa
    ADD CONSTRAINT participa_id_pelicula_fkey FOREIGN KEY (id_pelicula) REFERENCES cine.pelicula(id_pelicula) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: pelicula pelicula_id_director_fkey; Type: FK CONSTRAINT; Schema: cine; Owner: bdi2022ad
--

ALTER TABLE ONLY cine.pelicula
    ADD CONSTRAINT pelicula_id_director_fkey FOREIGN KEY (id_director) REFERENCES cine.director(id_director) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: empleados empleados_id_jefe_fkey; Type: FK CONSTRAINT; Schema: empleados; Owner: bdi2022ad
--

ALTER TABLE ONLY empleados.empleados
    ADD CONSTRAINT empleados_id_jefe_fkey FOREIGN KEY (id_jefe) REFERENCES empleados.empleados(id_empleado);


--
-- Name: mesa mesa_nombre_local_fkey; Type: FK CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.mesa
    ADD CONSTRAINT mesa_nombre_local_fkey FOREIGN KEY (nombre_local) REFERENCES locales_y_votantes.local(nombre);


--
-- Name: vocal vocal_numero_mesa_fkey; Type: FK CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vocal
    ADD CONSTRAINT vocal_numero_mesa_fkey FOREIGN KEY (numero_mesa) REFERENCES locales_y_votantes.mesa(numero);


--
-- Name: vocal vocal_rut_vocal_fkey; Type: FK CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vocal
    ADD CONSTRAINT vocal_rut_vocal_fkey FOREIGN KEY (rut_vocal) REFERENCES locales_y_votantes.votante(rut);


--
-- Name: vota_en vota_en_numero_mesa_fkey; Type: FK CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vota_en
    ADD CONSTRAINT vota_en_numero_mesa_fkey FOREIGN KEY (numero_mesa) REFERENCES locales_y_votantes.mesa(numero);


--
-- Name: vota_en vota_en_rut_votante_fkey; Type: FK CONSTRAINT; Schema: locales_y_votantes; Owner: bdi2022ad
--

ALTER TABLE ONLY locales_y_votantes.vota_en
    ADD CONSTRAINT vota_en_rut_votante_fkey FOREIGN KEY (rut_votante) REFERENCES locales_y_votantes.votante(rut);


--
-- Name: contacto contacto_id_empresa_fkey; Type: FK CONSTRAINT; Schema: negocio; Owner: bdi2022ad
--

ALTER TABLE ONLY negocio.contacto
    ADD CONSTRAINT contacto_id_empresa_fkey FOREIGN KEY (id_empresa) REFERENCES negocio.empresa(id_empresa) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: arriendo arriendo_id_cliente_fkey; Type: FK CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.arriendo
    ADD CONSTRAINT arriendo_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES renta_equipos.cliente(id_cliente);


--
-- Name: arriendo arriendo_id_inventario_fkey; Type: FK CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.arriendo
    ADD CONSTRAINT arriendo_id_inventario_fkey FOREIGN KEY (id_inventario) REFERENCES renta_equipos.inventario(id_inventario);


--
-- Name: reserva reserva_id_cliente_fkey; Type: FK CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.reserva
    ADD CONSTRAINT reserva_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES renta_equipos.cliente(id_cliente);


--
-- Name: reserva reserva_id_inventario_fkey; Type: FK CONSTRAINT; Schema: renta_equipos; Owner: bdi2022ad
--

ALTER TABLE ONLY renta_equipos.reserva
    ADD CONSTRAINT reserva_id_inventario_fkey FOREIGN KEY (id_inventario) REFERENCES renta_equipos.inventario(id_inventario);


--
-- Name: arriendo arriendo_id_cliente_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.arriendo
    ADD CONSTRAINT arriendo_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES test2.cliente(id_cliente) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: arriendo arriendo_id_inventario_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.arriendo
    ADD CONSTRAINT arriendo_id_inventario_fkey FOREIGN KEY (id_inventario) REFERENCES test2.inventario(id_inventario);


--
-- Name: prerequisito prerequisito_id_asignatura_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.prerequisito
    ADD CONSTRAINT prerequisito_id_asignatura_fkey FOREIGN KEY (id_asignatura) REFERENCES test2.asignatura(id_asignatura);


--
-- Name: prerequisito prerequisito_id_asignatura_prerequisito_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.prerequisito
    ADD CONSTRAINT prerequisito_id_asignatura_prerequisito_fkey FOREIGN KEY (id_asignatura_prerequisito) REFERENCES test2.asignatura(id_asignatura);


--
-- Name: renovar_stock renovar_stock_id_producto_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.renovar_stock
    ADD CONSTRAINT renovar_stock_id_producto_fkey FOREIGN KEY (id_producto) REFERENCES test2.producto(id_producto);


--
-- Name: reserva reserva_id_cliente_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.reserva
    ADD CONSTRAINT reserva_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES test2.cliente(id_cliente);


--
-- Name: reserva reserva_id_inventario_fkey; Type: FK CONSTRAINT; Schema: test2; Owner: bdi2022ad
--

ALTER TABLE ONLY test2.reserva
    ADD CONSTRAINT reserva_id_inventario_fkey FOREIGN KEY (id_inventario) REFERENCES test2.inventario(id_inventario);


--
-- Name: imparte imparte_codigo_asignatura_a_fkey; Type: FK CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.imparte
    ADD CONSTRAINT imparte_codigo_asignatura_a_fkey FOREIGN KEY (codigo_asignatura_a) REFERENCES universidad.asignatura(codigo_asignatura);


--
-- Name: imparte imparte_rut_d_fkey; Type: FK CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.imparte
    ADD CONSTRAINT imparte_rut_d_fkey FOREIGN KEY (rut_d) REFERENCES universidad.docente(rut);


--
-- Name: tiene tiene_codigo_asignatura_fkey; Type: FK CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.tiene
    ADD CONSTRAINT tiene_codigo_asignatura_fkey FOREIGN KEY (codigo_asignatura) REFERENCES universidad.asignatura(codigo_asignatura);


--
-- Name: tiene tiene_matricula_e_fkey; Type: FK CONSTRAINT; Schema: universidad; Owner: bdi2022ad
--

ALTER TABLE ONLY universidad.tiene
    ADD CONSTRAINT tiene_matricula_e_fkey FOREIGN KEY (matricula_e) REFERENCES universidad.estudiante(matricula);


--
-- PostgreSQL database dump complete
--