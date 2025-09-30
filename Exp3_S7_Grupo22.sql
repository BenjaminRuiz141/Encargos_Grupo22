CREATE TABLE COMPANIA 
    ( 
     id_empresa     NUMBER (2)  NOT NULL , 
     nombre_empresa VARCHAR2 (25 CHAR)  NOT NULL , 
     calle          VARCHAR2 (50)  NOT NULL , 
     numeracion     NUMBER (5)  NOT NULL , 
     renta_promedio NUMBER (10)  NOT NULL , 
     pct_aumento    NUMBER (4,3) , 
     cod_comuna     NUMBER (5)  NOT NULL , 
     cod_region     NUMBER (2)  NOT NULL 
    ) 
;

ALTER TABLE COMPANIA 
    ADD CONSTRAINT PK_COMPANIA PRIMARY KEY ( id_empresa ) ;

ALTER TABLE COMPANIA 
    ADD CONSTRAINT UN_nombre_empresa UNIQUE ( nombre_empresa ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna  NUMBER (5)  NOT NULL , 
     nombre     VARCHAR2 (25 CHAR)  NOT NULL , 
     cod_region NUMBER (2)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT PK_COMUNA PRIMARY KEY ( id_comuna, cod_region ) ;

CREATE TABLE DOMINIO 
    ( 
     cod_idioma  NUMBER (3)  NOT NULL , 
     persona_rut NUMBER (8)  NOT NULL , 
     nivel       VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE DOMINIO 
    ADD CONSTRAINT PK_DOMINIO PRIMARY KEY ( cod_idioma, persona_rut ) ;

CREATE TABLE ESTADO_CIVIL 
    ( 
     id_estado_civil VARCHAR2 (2 CHAR)  NOT NULL , 
     desc_est_civil  VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE ESTADO_CIVIL 
    ADD CONSTRAINT PK_ESTADO_CIVIL PRIMARY KEY ( id_estado_civil ) ;

CREATE TABLE GENERO 
    ( 
     id_genero   VARCHAR2 (3 CHAR)  NOT NULL , 
     desc_genero VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE GENERO 
    ADD CONSTRAINT PK_GENERO PRIMARY KEY ( id_genero ) ;

CREATE TABLE IDIOMA 
    ( 
     id_idioma     NUMBER (3) GENERATED ALWAYS AS IDENTITY START WITH 25 INCREMENT BY 3, 
     nombre_idioma VARCHAR2 (30)  NOT NULL 
    ) 
;

ALTER TABLE IDIOMA 
    ADD CONSTRAINT PK_IDIOMA PRIMARY KEY ( id_idioma ) ;

CREATE TABLE PERSONAL 
    ( 
     rut_persona        NUMBER (8)  NOT NULL , 
     dv_persona         CHAR (1 CHAR)  NOT NULL , 
     p_nombre           VARCHAR2 (25 CHAR)  NOT NULL , 
     s_nombre           VARCHAR2 (25 CHAR) , 
     p_apellido         VARCHAR2 (25 CHAR)  NOT NULL , 
     s_apellido         VARCHAR2 (25 CHAR)  NOT NULL , 
     fecha_contratacion DATE  NOT NULL , 
     fecha_nacimiento   DATE  NOT NULL , 
     email              VARCHAR2 (100 CHAR) , 
     calle              VARCHAR2 (50 CHAR)  NOT NULL , 
     numeracion         NUMBER (5)  NOT NULL , 
     sueldo             NUMBER (5)  NOT NULL , 
     rut_encargado      NUMBER (8) , 
     cod_estado_civil   VARCHAR2 (2 CHAR) , 
     cod_genero         VARCHAR2 (3 CHAR) , 
     cod_empresa        NUMBER (2)  NOT NULL , 
     cod_comuna         NUMBER (5)  NOT NULL , 
     cod_region         NUMBER (2)  NOT NULL 
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT PK_PERSONAL PRIMARY KEY ( rut_persona ) ;

CREATE TABLE REGION 
    ( 
     id_region NUMBER (2) GENERATED AS IDENTITY START WITH 7 INCREMENT BY 3, 
     nombre    VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT PK_REGION_PK PRIMARY KEY ( id_region ) ;

CREATE TABLE TITULACION 
    ( 
     persona_rut      NUMBER (8)  NOT NULL , 
     cod_titulo       VARCHAR2 (3 CHAR)  NOT NULL , 
     fecha_titulacion DATE  NOT NULL 
    ) 
;

ALTER TABLE TITULACION 
    ADD CONSTRAINT PK_TITULACION PRIMARY KEY ( cod_titulo, persona_rut ) ;

CREATE TABLE TITULO 
    ( 
     id_titulo   VARCHAR2 (3 CHAR)  NOT NULL , 
     desc_titulo VARCHAR2 (60 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE TITULO 
    ADD CONSTRAINT PK_TITULO PRIMARY KEY ( id_titulo ) ;

ALTER TABLE COMPANIA 
    ADD CONSTRAINT FK_COMPANIA_COMUNA FOREIGN KEY 
    ( 
     cod_comuna,
     cod_region
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna,
     cod_region
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT FK_COMUNA_REGION FOREIGN KEY 
    ( 
     cod_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE DOMINIO 
    ADD CONSTRAINT FK_DOMINIO_IDIOMA FOREIGN KEY 
    ( 
     cod_idioma
    ) 
    REFERENCES IDIOMA 
    ( 
     id_idioma
    ) 
;

ALTER TABLE DOMINIO 
    ADD CONSTRAINT FK_DOMINIO_PERSONAL FOREIGN KEY 
    ( 
     persona_rut
    ) 
    REFERENCES PERSONAL 
    ( 
     rut_persona
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_COMPANIA FOREIGN KEY 
    ( 
     cod_empresa
    ) 
    REFERENCES COMPANIA 
    ( 
     id_empresa
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_COMUNA FOREIGN KEY 
    ( 
     cod_comuna,
     cod_region
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna,
     cod_region
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_ESTADO_CIVIL FOREIGN KEY 
    ( 
     cod_estado_civil
    ) 
    REFERENCES ESTADO_CIVIL 
    ( 
     id_estado_civil
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_GENERO FOREIGN KEY 
    ( 
     cod_genero
    ) 
    REFERENCES GENERO 
    ( 
     id_genero
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_PERSONAL FOREIGN KEY 
    ( 
     rut_encargado
    ) 
    REFERENCES PERSONAL 
    ( 
     rut_persona
    ) 
;

ALTER TABLE TITULACION 
    ADD CONSTRAINT FK_TITULACION_PERSONAL FOREIGN KEY 
    ( 
     persona_rut
    ) 
    REFERENCES PERSONAL 
    ( 
     rut_persona
    ) 
;

ALTER TABLE TITULACION 
    ADD CONSTRAINT FK_TITULACION_TITULO FOREIGN KEY 
    ( 
     cod_titulo
    ) 
    REFERENCES TITULO 
    ( 
     id_titulo
    ) 
;

-- FIN DE GENERACION POR DATA MODELER

-- Alters despues de creacion
ALTER TABLE PERSONAL
    ADD CONSTRAINT UQ_personal_email UNIQUE (email);
    
ALTER TABLE PERSONAL
    ADD 
        CHECK (dv_persona IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K')) 
    ;
    
ALTER TABLE PERSONAL
    ADD
        CHECK (sueldo >= 450000)
    ;

-- Secuencias para Comuna y Compañia
CREATE SEQUENCE seq_comuna
  START WITH 1101
  INCREMENT BY 6
;

CREATE SEQUENCE seq_compania
  START WITH 10
  INCREMENT BY 5
;

-- Inserts
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Italiano');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ruso');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

INSERT INTO REGION (nombre) VALUES ('Arica y Parinacota');
INSERT INTO REGION (nombre) VALUES ('Antofagasta');
INSERT INTO REGION (nombre) VALUES ('Coquimbo');
INSERT INTO REGION (nombre) VALUES ('O Higgins');
INSERT INTO REGION (nombre) VALUES ('Maule');
    
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (seq_comuna.nextval, 'Sierra Gorda', 10);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (seq_comuna.nextval, 'Andacollo', 13);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (seq_comuna.nextval, 'Arica', 7);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (seq_comuna.nextval, 'Rancagua', 16);
INSERT INTO COMUNA (id_comuna, nombre, cod_region) VALUES (seq_comuna.nextval, 'Talca', 19);

INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, cod_comuna, cod_region)
    VALUES (seq_compania.nextval, 'Gatitos Company','Calle Gatos' , 1424, 43000000, 1119, 16)
    ;
    
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, cod_comuna, cod_region)
    VALUES (seq_compania.nextval, 'Marraquetas Panchita','Calle PanPan' , 1333, 99000000, 1125, 19)
    ;
    
INSERT INTO COMPANIA (id_empresa, nombre_empresa, calle, numeracion, renta_promedio, cod_comuna, cod_region, pct_aumento)
    VALUES (seq_compania.nextval, 'Martillos Armando','Calle Juan Pedro' , 1443, 23000000, 1113, 7, 0.4)
    ;


-- Selects
SELECT 
    nombre_empresa as NOMBRE,
    calle as CALLE,
    renta_promedio as "RENTA PROMEDIO",
    renta_promedio + (renta_promedio * pct_aumento) as "SIMULACION DE RENTA" FROM COMPANIA;
    
SELECT
    id_empresa as CODIGO,
    nombre_empresa as EMPRESA,
    renta_promedio as "PROM RENTA ACTUAL",
    pct_aumento * 1.15 as "PCT AUMENTADO EN 15%",
    renta_promedio * (pct_aumento * 1.15) as "RENTA AUMENTADA" FROM COMPANIA;

-- Commit...
COMMIT;
