-- Limpieza para evitar errores...
DROP TABLE DETALLE_VENTA CASCADE CONSTRAINTS;
DROP TABLE VENDEDOR CASCADE CONSTRAINTS;
DROP TABLE ADMINISTRATIVO CASCADE CONSTRAINTS;

DROP TABLE EMPLEADO CASCADE CONSTRAINTS;
DROP TABLE VENTA CASCADE CONSTRAINTS;

DROP TABLE PRODUCTO CASCADE CONSTRAINTS;

DROP TABLE PROVEEDOR CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE CATEGORIA CASCADE CONSTRAINTS;
DROP TABLE MARCA CASCADE CONSTRAINTS;
DROP TABLE MEDIO_PAGO CASCADE CONSTRAINTS;
DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;

DROP SEQUENCE seq_salud;
DROP SEQUENCE seq_empleado;

COMMIT;

-- Creacion de tablas y alters

CREATE TABLE AFP (
    id_afp NUMBER (5) NOT NULL,
    nom_afp VARCHAR2(256) NOT NULL
    )
;

ALTER TABLE AFP 
    ADD CONSTRAINT PK_AFP PRIMARY KEY ( id_afp )
;

CREATE TABLE SALUD (
    id_salud NUMBER (4) NOT NULL,
    nom_salud VARCHAR2(40) NOT NULL
    )
;

ALTER TABLE SALUD
    ADD CONSTRAINT PK_SALUD PRIMARY KEY ( id_salud )
;

CREATE TABLE MEDIO_PAGO (
    id_mpago NUMBER (3) NOT NULL,
    nombre_mpago VARCHAR2(50) NOT NULL
    )
;

ALTER TABLE MEDIO_PAGO
    ADD CONSTRAINT PK_MEDIO_PAGO PRIMARY KEY ( id_mpago )
;

CREATE TABLE VENTA (
    id_venta NUMBER (4) GENERATED ALWAYS AS IDENTITY START WITH 5050 INCREMENT BY 3,
    fecha_venta DATE NOT NULL,
    total_venta NUMBER (10) NOT NULL,
    cod_mpago NUMBER (3) NOT NULL,
    cod_empleado NUMBER (4) NOT NULL
    )
;

ALTER TABLE VENTA
    ADD CONSTRAINT PK_VENTA PRIMARY KEY ( id_venta )
;

CREATE TABLE MARCA (
    id_marca NUMBER (3) NOT NULL,
    nom_marca VARCHAR2(25) NOT NULL
    )
;

ALTER TABLE MARCA
    ADD CONSTRAINT PK_MARCA PRIMARY KEY ( id_marca )
;

CREATE TABLE REGION (
    id_region NUMBER (4) NOT NULL,
    nom_region VARCHAR2(255)
    )
;

ALTER TABLE REGION
    ADD CONSTRAINT PK_REGION PRIMARY KEY ( id_region )
;

CREATE TABLE COMUNA (
    id_comuna NUMBER (4) NOT NULL,
    nom_comuna VARCHAR2 (100) NOT NULL,
    cod_region NUMBER (4) NOT NULL
    )
;

ALTER TABLE COMUNA
    ADD CONSTRAINT PK_COMUNA PRIMARY KEY ( id_comuna )
;

ALTER TABLE COMUNA
    ADD CONSTRAINT FK_COMUNA_REGION FOREIGN KEY ( cod_region ) REFERENCES REGION ( id_region )
;

CREATE TABLE PROVEEDOR (
    id_proveedor NUMBER (5) NOT NULL,
    nom_proveedor VARCHAR2 (150) NOT NULL,
    rut_proveedor VARCHAR2 (10) NOT NULL,
    telefono VARCHAR2 (10) NOT NULL,
    email VARCHAR2 (200) NOT NULL,
    direccion VARCHAR2 (200) NOT NULL,
    cod_comuna NUMBER (4) NOT NULL
    )
;

ALTER TABLE PROVEEDOR
    ADD CONSTRAINT PK_PROVEEDOR PRIMARY KEY ( id_proveedor )
;

ALTER TABLE PROVEEDOR
    ADD CONSTRAINT FK_COMUNA_PROVEEDOR FOREIGN KEY ( cod_comuna ) REFERENCES COMUNA ( id_comuna )
;

CREATE TABLE CATEGORIA (
    id_categoria NUMBER (3) NOT NULL,
    nom_categoria VARCHAR2 (255) NOT NULL
    )
;

ALTER TABLE CATEGORIA
    ADD CONSTRAINT PK_CATEGORIA PRIMARY KEY ( id_categoria )
;

CREATE TABLE PRODUCTO (
    id_producto NUMBER (4) NOT NULL,
    nom_producto VARCHAR2 (100) NOT NULL,
    precio_unitario NUMBER (8) NOT NULL,
    origen_nacional CHAR (1) NOT NULL,
    stock_minimo NUMBER (3) NOT NULL,
    activo CHAR (1) NOT NULL,
    cod_marca NUMBER (3) NOT NULL,
    cod_categoria NUMBER (3) NOT NULL,
    cod_proveedor NUMBER (5) NOT NULL
    )
;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY ( id_producto )
;

ALTER TABLE PRODUCTO 
    ADD CONSTRAINT FK_MARCA_PRODUCTO FOREIGN KEY ( cod_marca ) REFERENCES MARCA ( id_marca )
;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT FK_CATEGORIA_PRODUCTO FOREIGN KEY ( cod_categoria ) REFERENCES CATEGORIA ( id_categoria )
;

ALTER TABLE PRODUCTO
    ADD CONSTRAINT FK_PROVEEDOR_PRODUCTO FOREIGN KEY ( cod_proveedor ) REFERENCES PROVEEDOR ( id_proveedor )
;

CREATE TABLE DETALLE_VENTA (
    cod_venta NUMBER (4) NOT NULL,
    cod_producto NUMBER (4) NOT NULL,
    cantidad NUMBER (6) NOT NULL
    )
;

ALTER TABLE DETALLE_VENTA 
    ADD CONSTRAINT PK_DETALLE_VENTA PRIMARY KEY ( cod_venta, cod_producto )
;

ALTER TABLE DETALLE_VENTA
    ADD CONSTRAINT FK_DET_VENTA_VENTA FOREIGN KEY ( cod_venta ) REFERENCES VENTA ( id_venta )
;

ALTER TABLE DETALLE_VENTA
    ADD CONSTRAINT FK_DET_VENTA_PRODUCTO FOREIGN KEY ( cod_producto ) REFERENCES PRODUCTO ( id_producto )
;

CREATE TABLE EMPLEADO (
    id_empleado NUMBER (4) NOT NULL,
    rut_empleado VARCHAR2(10) NOT NULL,
    nom_empleado VARCHAR2(25) NOT NULL,
    ap_paterno VARCHAR2(25) NOT NULL,
    ap_materno VARCHAR2(25) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    sueldo_base NUMBER (10) NOT NULL,
    bono_jefatura NUMBER (10),
    activo CHAR (1) NOT NULL,
    tipo_empleado VARCHAR2(25) NOT NULL,
    cod_empleado NUMBER (4),
    cod_salud NUMBER(4) NOT NULL,
    cod_afp NUMBER (5) NOT NULL
    )
;

ALTER TABLE EMPLEADO
    ADD CONSTRAINT PK_EMPLEADO PRIMARY KEY ( id_empleado )
;

ALTER TABLE EMPLEADO
    ADD CONSTRAINT FK_SALUD_EMPLEADO FOREIGN KEY ( cod_salud ) REFERENCES SALUD ( id_salud )
;

ALTER TABLE EMPLEADO
    ADD CONSTRAINT FK_AFP_EMPLEADO FOREIGN KEY ( cod_afp ) REFERENCES AFP ( id_afp )
;

ALTER TABLE EMPLEADO
    ADD CONSTRAINT FK_EMPLEADO_EMPLEADO FOREIGN KEY ( cod_empleado ) REFERENCES EMPLEADO ( id_empleado )
;

CREATE TABLE ADMINISTRATIVO (
    id_empleado NUMBER (4) NOT NULL
    )
;

ALTER TABLE ADMINISTRATIVO 
    ADD CONSTRAINT PK_ADMINISTRATIVO PRIMARY KEY (id_empleado)
;

ALTER TABLE ADMINISTRATIVO
    ADD CONSTRAINT FK_ADMIN_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
;

CREATE TABLE VENDEDOR (
    id_empleado NUMBER (4) NOT NULL,
    comision_venta NUMBER (5,2) NOT NULL
    )
;

ALTER TABLE VENDEDOR
    ADD CONSTRAINT PK_VENDEDOR PRIMARY KEY (id_empleado)
;

ALTER TABLE VENDEDOR
    ADD CONSTRAINT FK_VENDEDOR_EMPLEADO FOREIGN KEY (id_empleado) REFERENCES EMPLEADO (id_empleado)
;

ALTER TABLE EMPLEADO
    ADD CHECK (sueldo_base > 400000);
    
ALTER TABLE VENDEDOR
    ADD CHECK (comision_venta > 0 AND comision_venta < 0.25);

ALTER TABLE PRODUCTO
    ADD CHECK (stock_minimo > 3);
    
ALTER TABLE PROVEEDOR
    ADD CONSTRAINT UQ_EMAIL UNIQUE (email);

ALTER TABLE MARCA
    ADD CONSTRAINT UQ_NOMBRE_MARCA UNIQUE (nom_marca);

ALTER TABLE DETALLE_VENTA
    ADD CHECK (cantidad > 1);
    
-- Secuencias
    
CREATE SEQUENCE seq_salud
    START WITH 2050
    INCREMENT BY 10
;

CREATE SEQUENCE seq_empleado
    START WITH 750
    INCREMENT BY 3
;

-- INSERTS

INSERT INTO REGION (id_region, nom_region) 
    VALUES (1, 'Region Metropolitana');

INSERT INTO REGION (id_region, nom_region) 
    VALUES (2, 'Valparaiso');

INSERT INTO REGION (id_region, nom_region) 
    VALUES (3, 'Biobio');

INSERT INTO REGION (id_region, nom_region) 
    VALUES (4, 'Los Lagos');

--

INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago)
    VALUES (11, 'Efectivo');

INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago)
    VALUES (12, 'Tarjeta Debito');

INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago)
    VALUES (13, 'Tarjeta Credito');

INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago)
    VALUES (14, 'Cheque');

--

INSERT INTO AFP (id_afp, nom_afp)
    VALUES (210, 'AFP Habitat');

INSERT INTO AFP (id_afp, nom_afp)
    VALUES (216, 'AFP Cuprum');

INSERT INTO AFP (id_afp, nom_afp)
    VALUES (222, 'AFP Provida');

INSERT INTO AFP (id_afp, nom_afp)
    VALUES (228, 'AFP PlanVital');

--

INSERT INTO SALUD (id_salud, nom_salud)
    VALUES (seq_salud.nextval, 'Fonasa');

INSERT INTO SALUD (id_salud, nom_salud)
    VALUES (seq_salud.nextval, 'Isapre Colmena');

INSERT INTO SALUD (id_salud, nom_salud)
    VALUES (seq_salud.nextval, 'Isapre Banmedica');

INSERT INTO SALUD (id_salud, nom_salud)
    VALUES (seq_salud.nextval, 'Isapre Cruz Blanca');

--

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
    VALUES (DATE '2023-05-12', 225990, 11, 771);

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
    VALUES (DATE '2023-10-23', 524990, 13, 777);

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
    VALUES (DATE '2023-02-17', 466990, 11, 759);

--


INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,tipo_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'11111111-1','Marcela','Gonzalez','Perez',DATE '2022-03-15',950000,80000,'S','Administrativo',2050,210);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,tipo_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'22222222-2','Jose','Muñoz','Ramirez',DATE '2021-07-10',900000,75000,'S','Administrativo',2060,216);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,bono_jefatura,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'33333333-3','Veronica','Soto','Alarcon',DATE '2020-01-05',880000,70000,'S','Vendedor',750,2060,228);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'44444444-4','Luis','Reyes','Fuentes',DATE '2023-04-01',560000,'S','Vendedor',750,2070,228);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'55555555-5','Claudia','Fernandez','Lagos',DATE '2023-04-15',600000,'S','Vendedor',753,2070,216);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'66666666-6','Carlos','Navarro','Vega',DATE '2023-05-01',610000,'S','Administrativo',753,2060,210);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'77777777-7','Javiera','Pino','Rojas',DATE '2023-05-10',650000,'S','Administrativo',750,2050,210);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'88888888-8','Diego','Mella','Contreras',DATE '2023-05-12',620000,'S','Vendedor',750,2060,216);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'99999999-9','Fernanda','Salas','Herrera',DATE '2023-05-18',570000,'S','Vendedor',753,2070,228);

INSERT INTO EMPLEADO (id_empleado,rut_empleado,nom_empleado,ap_paterno,ap_materno,fecha_contratacion,sueldo_base,activo,tipo_empleado,cod_salud,cod_afp)
    VALUES (seq_empleado.NEXTVAL,'10101010-0','Tomas','Vidal','Espinoza',DATE '2023-06-01',530000,'S','Vendedor',2050,222);
    
-- Informe 1
SELECT * FROM EMPLEADO;

SELECT 
    id_empleado AS IDENTIFICADOR,
    nom_empleado || ' ' || ap_paterno || ' ' || ap_materno AS "NOMBRE COMPLETO",
    sueldo_base AS SALARIO,
    bono_jefatura AS BONIFICACION,
    sueldo_base + bono_jefatura AS "SALARIO SIMULADO"
FROM 
    EMPLEADO
    WHERE bono_jefatura IS NOT NULL
    ORDER BY "SALARIO SIMULADO" DESC, ap_paterno DESC;

-- Informe 2
SELECT
    nom_empleado || ' ' || ap_paterno || ' ' || ap_materno AS EMPLEADO,
    sueldo_base AS SUELDO,
    sueldo_base * 0.08 AS "POSIBLE AUMENTO",
    sueldo_base * 1.08 AS "SUELDO SIMULADO"
FROM
    EMPLEADO
    WHERE sueldo_base BETWEEN 550000 AND 800000
    ORDER BY sueldo_base ASC;