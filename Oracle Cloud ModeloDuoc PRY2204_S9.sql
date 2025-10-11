DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE PLANTA CASCADE CONSTRAINTS;
DROP TABLE MAQUINA CASCADE CONSTRAINTS;
DROP TABLE TIPO_MAQUINA CASCADE CONSTRAINTS;
DROP TABLE JEFE_TURNO CASCADE CONSTRAINTS;
DROP TABLE CERTIFICACION CASCADE CONSTRAINTS;
DROP TABLE OPERARIO CASCADE CONSTRAINTS;
DROP TABLE TECNICO CASCADE CONSTRAINTS;
DROP TABLE PERSONAL CASCADE CONSTRAINTS;
DROP TABLE ORDEN_MANTENCION CASCADE CONSTRAINTS;
DROP TABLE AFP CASCADE CONSTRAINTS;
DROP TABLE SALUD CASCADE CONSTRAINTS;
DROP TABLE TURNO CASCADE CONSTRAINTS;
DROP TABLE ASIGNACION_TURNO CASCADE CONSTRAINTS;
DROP SEQUENCE sq_region;

CREATE TABLE AFP 
    ( 
     id_afp INTEGER  NOT NULL , 
     nombre VARCHAR2 (100 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE AFP 
    ADD CONSTRAINT PK_AFP PRIMARY KEY ( id_afp ) ;

CREATE TABLE ASIGNACION_TURNO 
    ( 
     id_personal      INTEGER  NOT NULL , 
     id_turno         INTEGER  NOT NULL , 
     id_planta_actual INTEGER  NOT NULL , 
     id_tipo_maquina  INTEGER  NOT NULL , 
     rol_desempeñado  VARCHAR2 (50)  NOT NULL , 
     fecha_asignacion DATE  NOT NULL 
    ) 
;

CREATE TABLE CERTIFICACION 
    ( 
     id_certificacion INTEGER  NOT NULL , 
     nombre           VARCHAR2 (150)  NOT NULL 
    ) 
;

ALTER TABLE CERTIFICACION 
    ADD CONSTRAINT PK_CERTIFICACION PRIMARY KEY ( id_certificacion ) ;

CREATE TABLE COMUNA 
    ( 
     id_region INTEGER  NOT NULL , 
     id_comuna INTEGER GENERATED AS IDENTITY START WITH 1050 INCREMENT BY 5 , 
     nombre    VARCHAR2 (255 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT PK_COMUNA PRIMARY KEY ( id_comuna ) ;

CREATE TABLE JEFE_TURNO 
    ( 
     id_personal      INTEGER  NOT NULL , 
     id_planta INTEGER  NOT NULL , 
     max_operarios    INTEGER  NOT NULL 
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT PK_JEFE_TURNO PRIMARY KEY ( id_personal ) ;

CREATE TABLE MAQUINA 
    ( 
     id_planta       INTEGER  NOT NULL , 
     id_tipo_maquina INTEGER  NOT NULL , 
     num_maquina     INTEGER  NOT NULL , 
     nombre          VARCHAR2 (50 CHAR)  NOT NULL , 
     estado_activo   NUMBER  NOT NULL 
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT PK_MAQUINA PRIMARY KEY ( id_planta, id_tipo_maquina ) ;

CREATE TABLE OPERARIO 
    ( 
     id_personal       INTEGER  NOT NULL , 
     categoria_proceso VARCHAR2 (50 CHAR)  NOT NULL , 
     id_certificacion  INTEGER , 
     hora_estandar     INTEGER DEFAULT 8  NOT NULL 
    ) 
;

ALTER TABLE OPERARIO 
    ADD 
    CHECK (categoria_proceso IN ('caliente', 'frio', 'inspeccion')) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT PK_OPERARIO PRIMARY KEY ( id_personal ) ;

CREATE TABLE ORDEN_MANTENCION 
    ( 
     id_personal      INTEGER  NOT NULL , 
     id_planta_actual INTEGER  NOT NULL , 
     id_tipo_maquina  INTEGER  NOT NULL , 
     fecha_programada DATE  NOT NULL , 
     fecha_ejecucion  DATE , 
     desc_trabajo     VARCHAR2 (255 CHAR)  NOT NULL 
    ) 
;

CREATE TABLE PERSONAL 
    ( 
     id_personal        INTEGER  NOT NULL , 
     rut                VARCHAR2 (8 CHAR)  NOT NULL , 
     dv_rut             CHAR (1 CHAR)  NOT NULL , 
     fecha_contratacion DATE  NOT NULL , 
     sueldo_base        INTEGER  NOT NULL , 
     estado_activo      NUMBER DEFAULT 1  NOT NULL , 
     id_afp             INTEGER  NOT NULL , 
     id_salud           INTEGER  NOT NULL , 
     id_jefe            INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT PK_PERSONAL PRIMARY KEY ( id_personal ) ;

CREATE TABLE PLANTA 
    ( 
     id_planta INTEGER  NOT NULL , 
     nombre    VARCHAR2 (80 CHAR)  NOT NULL , 
     direccion VARCHAR2 (255 CHAR)  NOT NULL , 
     id_comuna INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT PK_PLANTA PRIMARY KEY ( id_planta ) ;

CREATE TABLE REGION 
    ( 
     id_region INTEGER  NOT NULL , 
     nombre    VARCHAR2 (255 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT PK_REGION PRIMARY KEY ( id_region ) ;
    
ALTER TABLE COMUNA
    ADD CONSTRAINT FK_REGION_COMUNA FOREIGN KEY ( id_region ) REFERENCES REGION (id_region);

CREATE TABLE SALUD 
    ( 
     id_salud INTEGER  NOT NULL , 
     nombre   VARCHAR2 (100 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE SALUD 
    ADD CONSTRAINT PK_SALUD PRIMARY KEY ( id_salud ) ;

CREATE TABLE TECNICO 
    ( 
     id_personal       INTEGER  NOT NULL , 
     id_certificacion  INTEGER , 
     especialidad      VARCHAR2 (50 CHAR)  NOT NULL , 
     tiempo_estandar   INTEGER  NOT NULL , 
     nivel_certificado VARCHAR2 (50 CHAR) 
    ) 
;

ALTER TABLE TECNICO 
    ADD 
    CHECK (especialidad IN ('electrica', 'instrumentacion', 'mecanica')) 
;

ALTER TABLE TECNICO 
    ADD CHECK ( id_certificacion IS NULL AND nivel_certificado IS NULL) 
;

ALTER TABLE TECNICO 
    ADD CONSTRAINT PK_TECNICO PRIMARY KEY ( id_personal ) ;

CREATE TABLE TIPO_MAQUINA 
    ( 
     id_tipo_maquina INTEGER  NOT NULL , 
     nombre          VARCHAR2 (50)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_MAQUINA 
    ADD CONSTRAINT PK_TIPO_MAQUINA PRIMARY KEY ( id_tipo_maquina ) ;

CREATE TABLE TURNO 
    ( 
     id_turno     INTEGER  NOT NULL , 
     nombre       VARCHAR2 (25 CHAR)  NOT NULL , 
     hora_inicio  CHAR (5 CHAR)  NOT NULL , 
     hora_termino CHAR (5 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE TURNO 
    ADD CONSTRAINT PK_TURNO PRIMARY KEY ( id_turno ) ;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT FK_ASIGNACION_TURNO_MAQUINA FOREIGN KEY 
    ( 
     id_planta_actual,
     id_tipo_maquina
    ) 
    REFERENCES MAQUINA 
    ( 
     id_planta,
     id_tipo_maquina
    ) 
;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT FK_ASIGNACION_TURNO_PERSONAL FOREIGN KEY 
    ( 
     id_personal
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE ASIGNACION_TURNO 
    ADD CONSTRAINT FK_ASIGNACION_TURNO_TURNO FOREIGN KEY 
    ( 
     id_turno
    ) 
    REFERENCES TURNO 
    ( 
     id_turno
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT FK_JEFE_TURNO_PERSONAL FOREIGN KEY 
    ( 
     id_personal
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE JEFE_TURNO 
    ADD CONSTRAINT FK_JEFE_TURNO_PLANTA FOREIGN KEY 
    ( 
     id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT FK_MAQUINA_PLANTA FOREIGN KEY 
    ( 
     id_planta
    ) 
    REFERENCES PLANTA 
    ( 
     id_planta
    ) 
;

ALTER TABLE MAQUINA 
    ADD CONSTRAINT FK_MAQUINA_TIPO_MAQUINA FOREIGN KEY 
    ( 
     id_tipo_maquina
    ) 
    REFERENCES TIPO_MAQUINA 
    ( 
     id_tipo_maquina
    ) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT FK_OPERARIO_CERTIFICACION FOREIGN KEY 
    ( 
     id_certificacion
    ) 
    REFERENCES CERTIFICACION 
    ( 
     id_certificacion
    ) 
;

ALTER TABLE OPERARIO 
    ADD CONSTRAINT FK_OPERARIO_PERSONAL FOREIGN KEY 
    ( 
     id_personal
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE ORDEN_MANTENCION 
    ADD CONSTRAINT FK_ORDEN_MANTENCION_MAQUINA FOREIGN KEY 
    ( 
     id_planta_actual,
     id_tipo_maquina
    ) 
    REFERENCES MAQUINA 
    ( 
     id_planta,
     id_tipo_maquina
    ) 
;

ALTER TABLE ORDEN_MANTENCION 
    ADD CONSTRAINT FK_ORDEN_MANTENCION_PERSONAL FOREIGN KEY 
    ( 
     id_personal
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_AFP FOREIGN KEY 
    ( 
     id_afp
    ) 
    REFERENCES AFP 
    ( 
     id_afp
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_PERSONAL FOREIGN KEY 
    ( 
     id_jefe
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE PERSONAL 
    ADD CONSTRAINT FK_PERSONAL_SALUD FOREIGN KEY 
    ( 
     id_salud
    ) 
    REFERENCES SALUD 
    ( 
     id_salud
    ) 
;

ALTER TABLE PLANTA 
    ADD CONSTRAINT FK_PLANTA_COMUNA FOREIGN KEY 
    ( 
     id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     id_comuna
    ) 
;

ALTER TABLE TECNICO 
    ADD CONSTRAINT FK_TECNICO_CERTIFICACION FOREIGN KEY 
    ( 
     id_certificacion
    ) 
    REFERENCES CERTIFICACION 
    ( 
     id_certificacion
    ) 
;

ALTER TABLE TECNICO 
    ADD CONSTRAINT FK_TECNICO_PERSONAL FOREIGN KEY 
    ( 
     id_personal
    ) 
    REFERENCES PERSONAL 
    ( 
     id_personal
    ) 
;

ALTER TABLE ORDEN_MANTENCION
    ADD CHECK (fecha_ejecucion <= fecha_programada);
    
ALTER TABLE REGION
    ADD CONSTRAINT UQ_NOMBRE_REGION UNIQUE (nombre);
    
ALTER TABLE SALUD
ADD CONSTRAINT UQ_NOMBRE_SALUD UNIQUE (nombre);
    
ALTER TABLE AFP
ADD CONSTRAINT UQ_NOMBRE_AFP UNIQUE (nombre);
    
ALTER TABLE TIPO_MAQUINA
ADD CONSTRAINT UQ_NOMBRE_T_MAQUINA UNIQUE (nombre);
    
ALTER TABLE TURNO
ADD CONSTRAINT UQ_NOMBRE_TURNO UNIQUE (nombre);

CREATE SEQUENCE sq_region
    START WITH 21 INCREMENT BY 1;

INSERT 
    INTO REGION (id_region, nombre)
    VALUES (sq_region.nextval, 'Region de Valparaiso');
    
INSERT 
    INTO REGION (id_region, nombre)
    VALUES (sq_region.nextval, 'Region Metropolitana');
    
INSERT
    INTO COMUNA (nombre, id_region)
    VALUES ('Quilpue', 21);
    
INSERT
    INTO COMUNA (nombre, id_region)
    VALUES ('Maipu', 22);
    
INSERT
    INTO PLANTA (id_planta, nombre, direccion, id_comuna)
    VALUES (45, 'Planta Oriente', 'Camino Industrial 1234', 1050);
    
INSERT
    INTO PLANTA (id_planta, nombre, direccion, id_comuna)
    VALUES (46, 'Planta Costa', 'Av. Vidrieras 890', 1055);
    
INSERT 
    INTO TURNO (id_turno, nombre , hora_inicio, hora_termino)
    VALUES (0715, 'Mañana', '07:00', '15:00');
    
INSERT 
    INTO TURNO (id_turno, nombre , hora_inicio, hora_termino)
    VALUES (2307, 'Noche', '23:00', '07:00');
    
INSERT 
    INTO TURNO (id_turno, nombre , hora_inicio, hora_termino)
    VALUES (1523, 'Tarde', '15:00', '23:00');
    
SELECT 
    SUBSTR(TRIM(nombre), 1, 1) || id_turno || '-' || nombre AS TURNO,
    hora_inicio AS ENTRADA,
    hora_termino AS SALIDA
FROM
    TURNO
ORDER BY ENTRADA DESC;

SELECT 
    nombre || ' ' || '(' || SUBSTR(TRIM(nombre), 1, 1) || id_turno || ')'  AS TURNO,
    hora_inicio AS ENTRADA,
    hora_termino AS SALIDA
FROM
    TURNO
WHERE hora_inicio BETWEEN '06:00' AND '15:00'
ORDER BY ENTRADA ASC;
