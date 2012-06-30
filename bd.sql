CREATE TABLE sare_regiones(
  id number(11),
  numero_region varchar2(4) NOT NULL,
  nombre_region varchar2(255) NOT NULL,
  capital_region varchar2(255),
  CONSTRAINT sare_regiones_pk PRIMARY KEY (id)
);

CREATE TABLE sare_provincias(
  id number(11),
  id_region number(11) NOT NULL,
  nombre_provincia varchar2(255) NOT NULL,
  capital_provincia varchar2(255),
  CONSTRAINT sare_provincias_pk PRIMARY KEY (id),
  CONSTRAINT sare_provincias_fk_regiones FOREIGN KEY (id_region) REFERENCES sare_regiones
);

CREATE TABLE sare_comunas(
  id number(11),
  id_provincia number(11) NOT NULL,
  id_region number(11) NOT NULL,
  nombre_comuna varchar2(255) NOT NULL,
  CONSTRAINT sare_comunas_pk PRIMARY KEY (id),
  CONSTRAINT sare_comunas_fk_provincias FOREIGN KEY (id_provincia) REFERENCES sare_provincias,
  CONSTRAINT sare_comunas_fk_regiones FOREIGN KEY (id_region) REFERENCES sare_regiones  
);

CREATE TABLE sare_establecimientos(
	codigo number(4),
	nombre varchar2(255) NOT NULL,
	direccion varchar2(255),
	estado number(1) DEFAULT 1,
	id_comuna number(11) NOT NULL,
	CONSTRAINT sare_est_pk PRIMARY KEY (codigo),
	CONSTRAINT sare_est_fk_comunas FOREIGN KEY (id_comuna) REFERENCES sare_comunas,
	CONSTRAINT sare_est_ck_estado CHECK (estado IN (0, 1))
);

CREATE TABLE sare_usuarios(
	rut number(8),
	nombres varchar2(200) NOT NULL,
	apaterno varchar2(200) NOT NULL,
	amaterno varchar2(200) NOT NULL,
	permiso number(1) NOT NULL,
	username varchar2(100) NOT NULL,
	passwd char(64) NOT NULL,
	email varchar2(200) NOT NULL,
	estado number(1) DEFAULT 1,
	CONSTRAINT sare_usuarios_pk PRIMARY KEY (rut),
	CONSTRAINT sare_usuarios_uq_username UNIQUE (username),
	CONSTRAINT sare_usuarios_uq_email UNIQUE (email),
	CONSTRAINT sare_usuarios_ck_permiso CHECK (permiso IN (1, 2, 3, 4)),
	CONSTRAINT sare_usuarios_ck_estado CHECK (estado IN (0, 1))
);

CREATE TABLE sare_alumnos(
	rut number(8),
	sexo char(1),
	direccion varchar2(200),
	CONSTRAINT alumnos_pk PRIMARY KEY (rut),
	CONSTRAINT alumnos_fk_usuarios FOREIGN KEY (rut) REFERENCES sare_usuarios,
	CONSTRAINT alumnos_ck_sexo CHECK (sexo in ('m', 'f'))
);

CREATE TABLE sare_administrativos(
	rut number(8),
	cargo varchar2(200),
	codigo_estab number(4),
	CONSTRAINT administrativos_pk PRIMARY KEY (rut),
	CONSTRAINT administrativos_fk_usuarios FOREIGN KEY (rut) REFERENCES sare_usuarios,
	CONSTRAINT administrativos_fk_estab FOREIGN KEY (codigo_estab) REFERENCES sare_establecimientos
);

CREATE TABLE sare_profesores(
	rut number(8),
	telefono number(8),
	CONSTRAINT profesores_pk PRIMARY KEY (rut),
	CONSTRAINT profesores_fk_usuarios FOREIGN KEY (rut) REFERENCES sare_usuarios
);

-- PROCEDIMIENTOS ALMACENADOS --

create or replace
PROCEDURE sp_usuario_adm_insert
(
  P_Rut           In Number,
  P_Nombres       In Varchar2,
  P_Apaterno      In Varchar2,
  p_AMATERNO      IN VARCHAR2,
  P_Permiso       In Number,
  P_Username      In Varchar2,
  P_Passwd        In Varchar2,
  P_Email         In Varchar2,
  P_Estado        In Number,
  P_Codigo_Estab  In number,
  p_CARGO         IN VARCHAR2
)
AS
BEGIN
  INSERT INTO SARE_USUARIOS 
  VALUES(
    p_RUT, 
    p_NOMBRES, 
    p_APATERNO,
    p_AMATERNO,
    p_PERMISO, 
    p_USERNAME, 
    p_PASSWD, 
    p_EMAIL,
    p_ESTADO
  );
  Commit;
  INSERT INTO SARE_ADMINISTRATIVOS
  Values(
    P_RUT,
    P_CARGO,
    p_CODIGO_ESTAB
  );
  COMMIT;
End Sp_Usuario_Adm_Insert ;

create or replace
PROCEDURE sp_usuario_prof_insert
(
  p_RUT       IN NUMBER,
  p_NOMBRES   IN VARCHAR2,
  p_APATERNO  IN VARCHAR2,
  p_AMATERNO  IN VARCHAR2,
  p_PERMISO   IN NUMBER,
  p_USERNAME  IN VARCHAR2,
  p_PASSWD    IN VARCHAR2,
  P_Email     In Varchar2,
  P_ESTADO    In Number,
  p_TELEFONO  IN CHAR
)
AS
BEGIN
  INSERT INTO SARE_USUARIOS 
  VALUES(
    p_RUT, 
    p_NOMBRES, 
    p_APATERNO,
    p_AMATERNO,
    p_PERMISO, 
    p_USERNAME, 
    p_PASSWD, 
    p_EMAIL,
    p_ESTADO
  );
  Commit;
  INSERT INTO SARE_PROFESORES
  VALUES(
    P_Rut,
    p_TELEFONO
  );
  Commit;
END sp_usuario_prof_insert ;

create or replace
PROCEDURE sp_usuario_alumno_insert
(
  p_RUT       IN NUMBER,
  p_NOMBRES   IN VARCHAR2,
  p_APATERNO  IN VARCHAR2,
  p_AMATERNO  IN VARCHAR2,
  p_PERMISO   IN NUMBER,
  p_USERNAME  IN VARCHAR2,
  p_PASSWD    IN VARCHAR2,
  p_EMAIL     IN VARCHAR2,
  p_ESTADO    IN NUMBER,
  p_SEXO      IN CHAR,
  p_DIRECCION IN VARCHAR2
)
AS
BEGIN
  INSERT INTO SARE_USUARIOS 
  VALUES(
    p_RUT, 
    p_NOMBRES, 
    p_APATERNO,
    p_AMATERNO,
    p_PERMISO, 
    p_USERNAME, 
    p_PASSWD, 
    p_EMAIL,
    p_ESTADO
  );
  COMMIT;
  INSERT INTO SARE_ALUMNOS
  VALUES(
    p_RUT,
    p_SEXO,
    p_DIRECCION
  );
  COMMIT;
END sp_usuario_alumno_insert ;

CREATE OR REPLACE
PROCEDURE sp_usuario_adm_update
(
  p_RUT       		IN NUMBER,
  p_NOMBRES   		IN VARCHAR2,
  p_APATERNO  		IN VARCHAR2,
  p_AMATERNO  		IN VARCHAR2,
  p_PERMISO   		IN NUMBER,
  p_USERNAME  		IN VARCHAR2,
  p_PASSWD    		IN VARCHAR2,
  p_EMAIL     		IN VARCHAR2,
  p_ESTADO    		IN NUMBER,
  p_CODIGO_ESTAB    IN NUMBER,
  p_CARGO 			IN VARCHAR2
)
AS
BEGIN
  UPDATE SARE_USUARIOS 
  SET
    RUT 		= 	p_RUT, 
    NOMBRES 	= 	p_NOMBRES, 
    APATERNO 	= 	p_APATERNO,
    AMATERNO 	= 	p_AMATERNO,
    PERMISO 	= 	p_PERMISO, 
    USERNAME 	= 	p_USERNAME, 
    PASSWD 		= 	p_PASSWD, 
    EMAIL 		= 	p_EMAIL,
    ESTADO 		= 	p_ESTADO
  WHERE RUT 	= 	p_RUT;
  COMMIT;
  
  UPDATE SARE_ADMINISTRATIVOS
  SET
    RUT 			= 	p_RUT,
    CODIGO_ESTAB	= 	p_CODIGO_ESTAB,
    CARGO 			= 	p_CARGO
  WHERE RUT 		= 	p_RUT;
  COMMIT;
  
END sp_usuario_adm_update ;

CREATE OR REPLACE
PROCEDURE sp_usuario_prof_update
(
  p_RUT     	IN NUMBER,
  p_NOMBRES 	IN VARCHAR2,
  p_APATERNO	IN VARCHAR2,
  p_AMATERNO	IN VARCHAR2,
  p_PERMISO 	IN NUMBER,
  p_USERNAME	IN VARCHAR2,
  p_PASSWD  	IN VARCHAR2,
  p_EMAIL   	IN VARCHAR2,
  p_ESTADO  	IN NUMBER,
  p_TELEFONO    IN NUMBER
)
AS
BEGIN
  UPDATE SARE_USUARIOS 
  SET
    RUT 		= 	p_RUT, 
    NOMBRES 	= 	p_NOMBRES, 
    APATERNO 	= 	p_APATERNO,
    AMATERNO 	= 	p_AMATERNO,
    PERMISO 	= 	p_PERMISO, 
    USERNAME 	= 	p_USERNAME, 
    PASSWD 		= 	p_PASSWD, 
    EMAIL 		= 	p_EMAIL,
    ESTADO 		= 	p_ESTADO
  WHERE RUT 	= 	p_RUT;
  COMMIT;
  
  UPDATE SARE_PROFESORES
  SET
    RUT 		= 	p_RUT,
    TELEFONO	= 	p_TELEFONO
  WHERE RUT 	= 	p_RUT;
  COMMIT;
  
END sp_usuario_prof_update ;

CREATE OR REPLACE
PROCEDURE sp_usuario_alumno_update
(
  p_RUT       IN NUMBER,
  p_NOMBRES   IN VARCHAR2,
  p_APATERNO  IN VARCHAR2,
  p_AMATERNO  IN VARCHAR2,
  p_PERMISO   IN NUMBER,
  p_USERNAME  IN VARCHAR2,
  p_PASSWD    IN VARCHAR2,
  p_EMAIL     IN VARCHAR2,
  p_ESTADO    IN NUMBER,
  p_SEXO      IN CHAR,
  p_DIRECCION IN VARCHAR2
)
AS
BEGIN
  UPDATE SARE_USUARIOS 
  SET
    RUT 		= 	p_RUT, 
    NOMBRES 	= 	p_NOMBRES, 
    APATERNO 	= 	p_APATERNO,
    AMATERNO 	= 	p_AMATERNO,
    PERMISO 	= 	p_PERMISO, 
    USERNAME 	= 	p_USERNAME, 
    PASSWD 		= 	p_PASSWD, 
    EMAIL 		= 	p_EMAIL,
    ESTADO 		= 	p_ESTADO
  WHERE RUT 	= 	p_RUT;
  COMMIT;
  
  UPDATE SARE_ALUMNOS
  SET
    RUT 		= 	p_RUT,
    SEXO 		= 	p_SEXO,
    DIRECCION 	= 	p_DIRECCION
  WHERE RUT 	= 	p_RUT;
  COMMIT;
  
END sp_usuario_alumno_update ;



-- D A T O S   R E G I O N E S

INSERT INTO sare_regiones VALUES(1,'I','Tarapacá','Iquique');
INSERT INTO sare_regiones VALUES(2,'II','Antofagasta','Antofagasta');
INSERT INTO sare_regiones VALUES(3,'III','Atacama','Copiapó');
INSERT INTO sare_regiones VALUES(4,'IV','Coquimbo','La Serena');
INSERT INTO sare_regiones VALUES(5,'V','Valparaíso','Valparaíso');
INSERT INTO sare_regiones VALUES(6,'VI','Libertador General Bernardo OHiggins','Rancagua');
INSERT INTO sare_regiones VALUES(7,'VII','Maule','Talca');
INSERT INTO sare_regiones VALUES(8,'VIII','Biobío','Concepción');
INSERT INTO sare_regiones VALUES(9,'IX','La Araucanía','Temuco');
INSERT INTO sare_regiones VALUES(10,'X','Los Lagos','Puerto Montt');
INSERT INTO sare_regiones VALUES(11,'XI','Aisén del General Carlos Ibáñez del Campo','Coihaique');
INSERT INTO sare_regiones VALUES(12,'XII','Magallanes y de la Antártica Chilena','Punta Arenas');
INSERT INTO sare_regiones VALUES(13,'RM','Región Metropolitana de Santiago','Santiago');
INSERT INTO sare_regiones VALUES(14,'XIV','De los Ríos','Valdivia');
INSERT INTO sare_regiones VALUES(15,'XV','Arica Parinacota','Arica');

-- D A T O S   P R O V I N C I A S

INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(1,1,'Iquique','Iquique');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(1,53,'Tamarugal','Pozo Almonte');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(2,4,'Antofagasta','Antofagasta');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(2,5,'El Loa','Calama');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(2,6,'Tocopilla','Tocopilla');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(3,7,'Chañaral','Chañaral');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(3,8,'Copiapó','Copiapó');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(3,9,'Huasco','Vallenar');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(4,10,'Choapa','Illapel');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(4,11,'Elqui','Coquimbo');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(4,12,'Limarí','Ovalle');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,13,'Isla de Pascua','Hanga Roa');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,14,'Los Andes','Los Andes');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,15,'Petorca','La Ligua');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,16,'Quillota','Quillota');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,17,'San Antonio','San Antonio');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,18,'San Felipe de Aconcagua','San Felipe');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(5,19,'Valparaíso','Valparaíso');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(6,26,'Cachapoal','Rancagua');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(6,27,'Cardenal Caro','Pichilemu');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(6,28,'Colchagua','San Fernando');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(7,29,'Cauquenes','Cauquenes');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(7,30,'Curicó','Curicó');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(7,31,'Linares','Linares');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(7,32,'Talca','Talca');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(8,33,'Arauco','Lebu');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(8,34,'Biobío','Los Ángeles');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(8,35,'Concepción','Concepción');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(8,36,'Ñuble','Chillán');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(9,37,'Cautín','Temuco');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(9,38,'Malleco','Angol');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(10,40,'Chiloé','Castro');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(10,41,'Llanquihue','Puerto Montt');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(10,42,'Osorno','Osorno');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(10,43,'Palena','Chaitén');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(11,44,'Aisén','Puerto Aisén');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(11,45,'Capitán Prat','Cochrane');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(11,46,'Coihaique','Coihaique');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(11,47,'General Carrera','Chile Chico');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(12,48,'Antártica Chilena','Puerto Williams');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(12,49,'Magallanes','Punta Arenas');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(12,50,'Tierra del Fuego','Porvenir');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(12,51,'Última Esperanza','Puerto Natales');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,20,'Chacabuco','Colina');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,21,'Cordillera','Puente Alto');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,22,'Maipo','San Bernardo');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,23,'Melipilla','Melipilla');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,24,'Santiago','Santiago');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(13,25,'Talagante','Talagante');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(14,39,'Valdivia','Valdivia');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(14,52,'Ranco','La Unión');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(15,2,'Arica','Arica');
INSERT INTO sare_provincias (id_region,id,nombre_provincia,capital_provincia) VALUES(15,3,'Parinacota','Putre');

--D A T O S   C O M U N A S

INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,1,1,'Alto Hospicio');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,1,2,'Iquique');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,53,3,'Camiña');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,53,4,'Colchane');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,53,5,'Huara');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,53,6,'Pica');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(1,53,7,'Pozo Almonte');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,4,12,'Antofagasta');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,4,13,'Mejillones');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,4,14,'Sierra Gorda');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,4,15,'Taltal');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,5,16,'Calama');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,5,17,'Ollagüe');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,5,18,'San Pedro de Atacama');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,6,19,'María Elena');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(2,6,20,'Tocopilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,7,21,'Chañaral');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,7,22,'Diego de Almagro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,8,23,'Caldera');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,8,24,'Copiapó');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,8,25,'Tierra Amarilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,9,26,'Alto del Carmen');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,9,27,'Freirina');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,9,28,'Huasco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(3,9,29,'Vallenar');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,10,30,'Canela');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,10,31,'Illapel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,10,32,'Los Vilos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,10,33,'Salamanca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,34,'Andacollo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,35,'Coquimbo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,36,'La Higuera');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,37,'La Serena');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,38,'Paihuano');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,11,39,'Vicuña');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,12,40,'Combarbalá');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,12,41,'Monte Patria');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,12,42,'Ovalle');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,12,43,'Punitaqui');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(4,12,44,'Río Hurtado');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,13,45,'Isla de Pascua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,14,46,'Calle Larga');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,14,47,'Los Andes');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,14,48,'Rinconada');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,14,49,'San Esteban');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,15,50,'Cabildo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,15,51,'La Ligua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,15,52,'Papudo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,15,53,'Petorca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,15,54,'Zapallar');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,55,'Hijuelas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,56,'La Calera');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,57,'La Cruz');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,58,'Limache');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,59,'Nogales');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,60,'Olmué');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,16,61,'Quillota');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,62,'Alga rrobo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,63,'Cartagena');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,64,'El Quisco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,65,'El Tabo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,66,'San Antonio');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,17,67,'Santo Domingo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,68,'Catemu');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,69,'Llaillay');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,70,'Panquehue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,71,'Putaendo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,72,'San Felipe');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,18,73,'Santa María');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,74,'Casablanca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,75,'Concón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,76,'Juan Fernández');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,77,'Puchuncaví');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,78,'Quilpué');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,79,'Quintero');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,80,'Valparaíso');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,81,'Villa Alemana');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(5,19,82,'Viña del Mar');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,135,'Codegua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,136,'Coínco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,137,'Coltauco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,138,'Doñihue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,139,'Graneros');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,140,'Las Cabras');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,141,'Machalí');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,142,'Malloa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,143,'Mostazal');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,144,'Olivar');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,145,'Peumo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,146,'Pichidegua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,147,'Quin ta de Tilcoco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,148,'Rancagua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,149,'Rengo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,150,'Requínoa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,26,151,'San Vicente de Tagua Tagua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,152,'La Estrella');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,153,'Litueche');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,154,'Marchihue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,155,'Navidad');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,156,'Paredones');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,27,157,'Pichilemu');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,158,'Chépica');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,159,'Chimbarongo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,160,'Lolol');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,161,'Nancagua');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,162,'Palmilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,163,'Peralillo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,164,'Placilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,165,'Pumanque');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,166,'San Fernando');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(6,28,167,'Santa Cruz');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,29,168,'Cauquenes');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,29,169,'Chanco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,29,170,'Pelluhue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,171,'Curicó');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,172,'Hualañé');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,173,'Licantén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,174,'Molina');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,175,'Rauco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,176,'Romeral');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,177,'Sagrada Familia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,178,'Teno');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,30,179,'Vichuquén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,180,'Colbún');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,181,'Linares');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,182,'Longaví');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,183,'Parral');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,184,'Retiro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,185,'San Javier');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,186,'Villa Alegre');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,31,187,'Yerbas Buenas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,188,'Constitución');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,189,'Curepto');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,190,'Empedrado');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,191,'Maule');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,192,'Pelarco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,193,'Pencahue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,194,'Río Claro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,195,'San Clemente');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,196,'San Rafael');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(7,32,197,'Talca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,198,'Arauco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,199,'Cañete');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,200,'Contulmo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,201,'Curanilahue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,202,'Lebu');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,203,'Los Álamos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,33,204,'Tirúa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,205,'Alto Biobío');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,206,'Antuco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,207,'Cabrero');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,208,'Laja');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,209,'Los Ángeles');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,210,'Mulchén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,211,'Nacimiento');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,212,'Negrete');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,213,'Quilaco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,214,'Quilleco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,215,'San Rosendo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,216,'Santa Bárbara');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,217,'Tucapel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,34,218,'Yumbel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,219,'Chiguayante');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,220,'Concepción');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,221,'Coronel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,222,'Florida');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,223,'Hualpén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,224,'Hualqui');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,225,'Lota');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,226,'Penco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,227,'San Pedro de la Paz');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,228,'Santa Juana');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,229,'Talcahuano');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,35,230,'Tomé');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,231,'Bulnes');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,232,'Chillán');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,233,'Chillán Viejo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,234,'Cobquecura');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,235,'Coelemu');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,236,'Coihueco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,237,'El Carmen');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,238,'Ninhue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,239,'Ñiquén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,240,'Pemuco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,241,'Pinto');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,242,'Portezuelo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,243,'Quillón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,244,'Quirihue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,245,'Ránquil');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,246,'San Carlos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,247,'San Fabián');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,248,'San Ignacio');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,249,'San Nicolás');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,250,'Treguaco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(8,36,251,'Yungay');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,252,'Carahue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,253,'Cholchol');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,254,'Cunco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,255,'Curarrehue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,256,'Freire');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,257,'Galvarino');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,258,'Gorbea');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,259,'Lautaro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,260,'Loncoche');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,261,'Melipeuco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,262,'Nueva Imperial');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,263,'Padre Las Casas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,264,'Perquenco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,265,'Pitrufquén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,266,'Pucón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,267,'Saavedra');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,268,'Temuco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,269,'Teodoro Schmidt');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,270,'Toltén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,271,'Vilcún');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,37,272,'Villarrica');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,273,'Angol');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,274,'Collipulli');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,275,'Curacautín');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,276,'Ercilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,277,'Lonquimay');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,278,'Los Sauces');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,279,'Lumaco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,280,'Purén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,281,'Renaico');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,282,'Traiguén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(9,38,283,'Victoria');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,296,'Ancud');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,297,'Castro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,298,'Chonchi');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,299,'Curaco de Vélez');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,300,'Dalcahue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,301,'Puqueldón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,302,'Queilén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,303,'Quemchi');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,304,'Quellón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,40,305,'Quinchao');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,306,'Calbuco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,307,'Cochamó');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,308,'Fresia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,309,'Frutillar');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,310,'Llanquihue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,311,'Los Muermos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,312,'Maullín');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,313,'Puerto Montt');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,41,314,'Puerto Varas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,315,'Osorno');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,316,'Puerto Octay');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,317,'Purranque');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,318,'Puyehue');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,319,'Río Negro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,320,'San Juan de la Costa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,42,321,'San Pablo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,43,322,'Chaitén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,43,323,'Futaleufú');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,43,324,'Hualaihué');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(10,43,325,'Palena');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,44,326,'Aisén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,44,327,'Cisnes');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,44,328,'Guaitecas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,45,329,'Cochrane');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,45,330,'OHiggins');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,45,331,'Tortel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,46,332,'Coihaique');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,46,333,'Lago Verde');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,47,334,'Chile Chico');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(11,47,335,'Río Ibañez');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,48,336,'Antártica');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,48,337,'Cabo de Hornos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,49,338,'Laguna Blanca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,49,339,'Punta Arenas');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,49,340,'Río Verde');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,49,341,'San Gregorio');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,50,342,'Porvenir');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,50,343,'Primavera');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,50,344,'Timaukel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,51,345,'Puerto Natales');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(12,51,346,'Torres del Paine');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,20,83,'Colina');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,20,84,'Lampa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,20,85,'Tiltil');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,21,86,'Pirque');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,21,87,'Puente Alto');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,21,88,'San José de Maipo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,22,89,'Buin');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,22,90,'Calera de Tango');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,22,91,'Paine');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,22,92,'San Bernardo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,23,93,'Alhué');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,23,94,'Curacaví');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,23,95,'María Pinto');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,23,96,'Melipilla');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,23,97,'San Pedro');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,98,'Cerrillos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,99,'Cerro Navia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,100,'Conchalí');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,101,'El Bosque');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,102,'Estación Central');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,103,'Huechuraba');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,104,'Independencia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,105,'La Cisterna');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,106,'La Granja');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,107,'La Florida');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,108,'La Pintana');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,109,'La Reina');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,110,'Las Condes');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,111,'Lo Barnechea');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,112,'Lo Espejo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,113,'Lo Prado');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,114,'Macul');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,115,'Maipú');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,116,'Ñuñoa');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,117,'Pedro Aguirre Cerda');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,118,'Peñalolén');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,119,'Providencia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,120,'Pudahuel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,121,'Quilicura');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,122,'Quinta Normal');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,123,'Recoleta');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,124,'Renca');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,125,'San Miguel');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,126,'San Joaquín');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,127,'San Ramón');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,128,'Santiago');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,24,129,'Vitacura');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,25,130,'El Monte');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,25,131,'Isla de Maipo');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,25,132,'Padre Hurtado');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,25,133,'Peñaflor');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(13,25,134,'Talagante');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,284,'Corral');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,285,'Lanco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,286,'Los Lagos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,287,'Máfil');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,288,'Paillaco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,289,'Panguipulli');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,290,'San José de la Mariquina');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,39,291,'Valdivia');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,52,292,'Futrono');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,52,293,'La Unión');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,52,294,'Lago Ranco');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(14,52,295,'Río Bueno');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(15,2,8,'Arica');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(15,2,9,'Camarones');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(15,3,10,'General Lagos');
INSERT INTO sare_comunas(id_region,id_provincia,id,nombre_comuna) VALUES(15,3,11,'Putre');