CREATE TABLE CIUDAD 
    ( 
     id_ciudad               INTEGER  NOT NULL , 
     nombre_ciu              VARCHAR2 (25 CHAR)  NOT NULL , 
     COMUNA_REGION_id_region INTEGER  NOT NULL , 
     COMUNA_id_comuna        INTEGER  NOT NULL 
    ) 
;

ALTER TABLE CIUDAD 
    ADD CONSTRAINT PK_CIUDAD PRIMARY KEY ( COMUNA_REGION_id_region, COMUNA_id_comuna, id_ciudad ) ;

CREATE TABLE COMUNA 
    ( 
     id_comuna        INTEGER GENERATED ALWAYS AS IDENTITY START WITH 1101 INCREMENT BY 1, 
     nombre_com       VARCHAR2 (25 CHAR)  NOT NULL , 
     REGION_id_region INTEGER  NOT NULL 
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT PK_COMUNA PRIMARY KEY ( REGION_id_region, id_comuna ) ;

CREATE TABLE DIAGNOSTICO 
    ( 
     cod_diagnostico INTEGER  NOT NULL , 
     nombre_dia      VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE DIAGNOSTICO 
    ADD CONSTRAINT PK_DIAGNOSTICO PRIMARY KEY ( cod_diagnostico ) ;

CREATE TABLE DIGITADOR 
    ( 
     rut_dig   INTEGER  NOT NULL , 
     dv_dig    CHAR (1 CHAR)  NOT NULL , 
     pnombre   VARCHAR2 (25 CHAR)  NOT NULL , 
     papellido VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE DIGITADOR 
    ADD 
    CHECK (dv_dig IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K')) 
;

ALTER TABLE DIGITADOR 
    ADD CONSTRAINT PK_DIGITADOR PRIMARY KEY ( rut_dig ) ;

CREATE TABLE DOSIS 
    ( 
     MEDICAMENTO_cod_med INTEGER  NOT NULL , 
     desc_dosis          VARCHAR2 (200 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE DOSIS 
    ADD CONSTRAINT PK_DOSIS PRIMARY KEY ( MEDICAMENTO_cod_med ) ;

CREATE TABLE ESPECIALIDAD 
    ( 
     id_esp     INTEGER GENERATED ALWAYS AS IDENTITY, 
     nombre_esp VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT PK_ESPECIALIDAD PRIMARY KEY ( id_esp ) ;

CREATE TABLE MEDICAMENTO 
    ( 
     cod_med           INTEGER  NOT NULL , 
     stock_disp        INTEGER  NOT NULL , 
     nombre            VARCHAR2 (25 CHAR)  NOT NULL , 
     RECETA_cod_receta INTEGER 
    ) 
;

ALTER TABLE MEDICAMENTO 
    ADD CONSTRAINT PK_MEDICAMENTO PRIMARY KEY ( cod_med ) ;

CREATE TABLE MEDICO 
    ( 
     rut_med             INTEGER  NOT NULL , 
     dv_med              CHAR (1 CHAR)  NOT NULL , 
     pnombre             VARCHAR2 (25 CHAR)  NOT NULL , 
     snombre             VARCHAR2 (25 CHAR)  NOT NULL , 
     papellido           VARCHAR2 (25 CHAR)  NOT NULL , 
     sapellido           VARCHAR2 (25 CHAR) , 
     telefono            INTEGER  NOT NULL , 
     ESPECIALIDAD_id_esp INTEGER  NOT NULL 
    ) 
;

ALTER TABLE MEDICO 
    ADD 
    CHECK (dv_med IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K')) 
;
CREATE UNIQUE INDEX MEDICO__IDX ON MEDICO 
    ( 
     ESPECIALIDAD_id_esp ASC 
    ) 
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT PK_MEDICO PRIMARY KEY ( rut_med ) ;

ALTER TABLE MEDICO 
    ADD CONSTRAINT UN_MEDICO_telefono UNIQUE ( telefono ) ;

CREATE TABLE METODO_PAGO 
    ( 
     id_metodo INTEGER  NOT NULL , 
     metodo    VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE METODO_PAGO 
    ADD CONSTRAINT PK_METODO_PAGO PRIMARY KEY ( id_metodo ) ;

CREATE TABLE PACIENTE 
    ( 
     rut_pac                        INTEGER  NOT NULL , 
     dv_pac                         CHAR (1 CHAR)  NOT NULL , 
     pnombre                        VARCHAR2 (25 CHAR)  NOT NULL , 
     snombre                        VARCHAR2 (25 CHAR) , 
     edad                           INTEGER NOT NULL,
     telefono                       INTEGER  NOT NULL , 
     calle                          VARCHAR2 (25 CHAR)  NOT NULL , 
     numeracion                     INTEGER  NOT NULL , 
     CIUDAD_COMUNA_REGION_id_region INTEGER  NOT NULL , 
     CIUDAD_COMUNA_id_comuna        INTEGER  NOT NULL , 
     CIUDAD_id_ciudad               INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PACIENTE 
    ADD 
    CHECK (dv_pac IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'K')) 
;
CREATE UNIQUE INDEX PACIENTE__IDX ON PACIENTE 
    ( 
     CIUDAD_COMUNA_REGION_id_region ASC , 
     CIUDAD_COMUNA_id_comuna ASC , 
     CIUDAD_id_ciudad ASC 
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PK_PACIENTE PRIMARY KEY ( rut_pac ) ;

CREATE TABLE PAGO 
    ( 
     RECETA_cod_receta     INTEGER  NOT NULL , 
     cod_boleta            INTEGER  NOT NULL , 
     fecha_pago            DATE  NOT NULL , 
     monto_total           INTEGER  NOT NULL , 
     monto_pagado          INTEGER  NOT NULL , 
     METODO_PAGO_id_metodo INTEGER  NOT NULL 
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT PK_PAGO PRIMARY KEY ( cod_boleta, RECETA_cod_receta ) ;

CREATE TABLE RECETA 
    ( 
     cod_receta                  INTEGER  NOT NULL , 
     observaciones               VARCHAR2 (500 CHAR) , 
     fecha_emision               DATE  NOT NULL , 
     fecha_vencimiento           DATE , 
     TIPO_RECETA_id_tipo_rec     INTEGER  NOT NULL , 
     DIGITADOR_rut_dig           INTEGER  NOT NULL , 
     DIAGNOSTICO_cod_diagnostico INTEGER  NOT NULL , 
     MEDICO_rut_med              INTEGER  NOT NULL , 
     PACIENTE_rut_pac            INTEGER  NOT NULL 
    ) 
;
CREATE UNIQUE INDEX RECETA__IDX ON RECETA 
    ( 
     DIAGNOSTICO_cod_diagnostico ASC 
    ) 
;
CREATE UNIQUE INDEX RECETA__IDXv1 ON RECETA 
    ( 
     MEDICO_rut_med ASC 
    ) 
;
CREATE UNIQUE INDEX RECETA__IDXv2 ON RECETA 
    ( 
     PACIENTE_rut_pac ASC 
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT PK_RECETA PRIMARY KEY ( cod_receta ) ;

CREATE TABLE REGION 
    ( 
     id_region  INTEGER  NOT NULL , 
     nombre_reg VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE REGION 
    ADD CONSTRAINT PK_REGION PRIMARY KEY ( id_region ) ;

CREATE TABLE TIPO_RECETA 
    ( 
     id_tipo_rec INTEGER  NOT NULL , 
     nombre      VARCHAR2 (25 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE TIPO_RECETA 
    ADD CONSTRAINT PK_TIPO_RECETA PRIMARY KEY ( id_tipo_rec ) ;

ALTER TABLE CIUDAD 
    ADD CONSTRAINT FK_CIUDAD_COMUNA FOREIGN KEY 
    ( 
     COMUNA_REGION_id_region,
     COMUNA_id_comuna
    ) 
    REFERENCES COMUNA 
    ( 
     REGION_id_region,
     id_comuna
    ) 
;

ALTER TABLE COMUNA 
    ADD CONSTRAINT FK_COMUNA_REGION FOREIGN KEY 
    ( 
     REGION_id_region
    ) 
    REFERENCES REGION 
    ( 
     id_region
    ) 
;

ALTER TABLE DOSIS 
    ADD CONSTRAINT FK_DOSIS_MEDICAMENTO FOREIGN KEY 
    ( 
     MEDICAMENTO_cod_med
    ) 
    REFERENCES MEDICAMENTO 
    ( 
     cod_med
    ) 
;

ALTER TABLE MEDICAMENTO 
    ADD CONSTRAINT FK_MEDICAMENTO_RECETA FOREIGN KEY 
    ( 
     RECETA_cod_receta
    ) 
    REFERENCES RECETA 
    ( 
     cod_receta
    )
;

ALTER TABLE MEDICO 
    ADD CONSTRAINT FK_MEDICO_ESPECIALIDAD FOREIGN KEY 
    ( 
     ESPECIALIDAD_id_esp
    ) 
    REFERENCES ESPECIALIDAD 
    ( 
     id_esp
    ) 
;

ALTER TABLE PACIENTE 
    ADD CONSTRAINT FK_PACIENTE_CIUDAD FOREIGN KEY 
    ( 
     CIUDAD_COMUNA_REGION_id_region,
     CIUDAD_COMUNA_id_comuna,
     CIUDAD_id_ciudad
    ) 
    REFERENCES CIUDAD 
    ( 
     COMUNA_REGION_id_region,
     COMUNA_id_comuna,
     id_ciudad
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT FK_PAGO_METODO_PAGO FOREIGN KEY 
    ( 
     METODO_PAGO_id_metodo
    ) 
    REFERENCES METODO_PAGO 
    ( 
     id_metodo
    ) 
;

ALTER TABLE PAGO 
    ADD CONSTRAINT FK_PAGO_RECETA FOREIGN KEY 
    ( 
     RECETA_cod_receta
    ) 
    REFERENCES RECETA 
    ( 
     cod_receta
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT FK_RECETA_DIAGNOSTICO FOREIGN KEY 
    ( 
     DIAGNOSTICO_cod_diagnostico
    ) 
    REFERENCES DIAGNOSTICO 
    ( 
     cod_diagnostico
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT FK_RECETA_DIGITADOR FOREIGN KEY 
    ( 
     DIGITADOR_rut_dig
    ) 
    REFERENCES DIGITADOR 
    ( 
     rut_dig
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT FK_RECETA_MEDICO FOREIGN KEY 
    ( 
     MEDICO_rut_med
    ) 
    REFERENCES MEDICO 
    ( 
     rut_med
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT FK_RECETA_PACIENTE FOREIGN KEY 
    ( 
     PACIENTE_rut_pac
    ) 
    REFERENCES PACIENTE 
    ( 
     rut_pac
    ) 
;

ALTER TABLE RECETA 
    ADD CONSTRAINT FK_RECETA_TIPO_RECETA FOREIGN KEY 
    ( 
     TIPO_RECETA_id_tipo_rec
    ) 
    REFERENCES TIPO_RECETA 
    ( 
     id_tipo_rec
    ) 
;

ALTER TABLE PACIENTE
    DROP COLUMN edad;
    
ALTER TABLE PACIENTE
    ADD (fecha_nacimiento DATE NOT NULL); 
    
ALTER TABLE MEDICAMENTO
    ADD (precio_uni INTEGER NOT NULL);
    
ALTER TABLE MEDICAMENTO ADD CONSTRAINT chk_med_precio_uni
  CHECK (precio_uni BETWEEN 1000 AND 2000000);

ALTER TABLE METODO_PAGO
    ADD CONSTRAINT CHK_METODO_PAGO
    CHECK (UPPER(metodo) IN ('EFECTIVO','TARJETA','TRANSFERENCIA'));
    
