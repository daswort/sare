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

CREATE TABLE sare_administrativos(
	rut_adm number(8),
	cargo varchar2(200),
	codigo_estab number(4),
	CONSTRAINT administrativos_pk PRIMARY KEY (rut_adm),
	CONSTRAINT administrativos_fk_usuarios FOREIGN KEY (rut_adm) REFERENCES sare_usuarios,
	CONSTRAINT administrativos_fk_estab FOREIGN KEY (codigo_estab) REFERENCES sare_establecimientos
);

CREATE TABLE sare_profesores(
	rut_prof number(8),
	telefono number(8),
	CONSTRAINT profesores_pk PRIMARY KEY (rut_prof),
	CONSTRAINT profesores_fk_usuarios FOREIGN KEY (rut_prof) REFERENCES sare_usuarios
);

CREATE TABLE sare_alumnos(
	rut_alum number(8),
	sexo char(1),
	direccion varchar2(200),
	CONSTRAINT alumnos_pk PRIMARY KEY (rut_alum),
	CONSTRAINT alumnos_fk_usuarios FOREIGN KEY (rut_alum) REFERENCES sare_usuarios,
	CONSTRAINT alumnos_ck_sexo CHECK (sexo in ('m', 'f'))
);

CREATE TABLE sare_cursos(
	grado number(1),
	letra char(1),
	nivel char(1),
	CONSTRAINT cursos_pk PRIMARY KEY (grado, letra, nivel),
	CONSTRAINT cursos_ck_grado CHECK (grado >= 0),
	CONSTRAINT cursos_ck_nivel CHECK (nivel IN ('b', 'm'))
);

CREATE TABLE sare_matriculas(
	profe_jefe number(8),
	codigo_estab number(4),
	grado_curso number(1),
	letra_curso char(1),
	nivel_curso char(1),
	anio_matricula number(4),
	rut_alum number(8),
	CONSTRAINT matriculas_pk PRIMARY KEY (profe_jefe, codigo_estab, grado_curso, letra_curso, nivel_curso, anio_matricula, rut_alum),
	CONSTRAINT matriculas_fk_establecimientos FOREIGN KEY (codigo_estab) REFERENCES sare_establecimientos,
	CONSTRAINT matriculas_fk_cursos FOREIGN KEY (grado_curso, letra_curso, nivel_curso) REFERENCES sare_cursos,
	CONSTRAINT matriculas_fk_profesores FOREIGN KEY (profe_jefe) REFERENCES sare_profesores,
	CONSTRAINT matriculas_fk_alumnos FOREIGN KEY (rut_alum) REFERENCES sare_alumnos
);

CREATE TABLE sare_asignaturas(
  codigo varchar2(5),
  nombre varchar2(200) NOT NULL,
  CONSTRAINT asignaturas_pk PRIMARY KEY (codigo)
);

CREATE TABLE sare_unidades(
  codigo_asig varchar2(5),
  codigo_unid number(2),
  nombre varchar2(200) NOT NULL,
  CONSTRAINT unidades_pk PRIMARY KEY (codigo_asig, codigo_unid),
  CONSTRAINT unidades_fk_asig FOREIGN KEY (codigo_asig) REFERENCES sare_asignaturas
);

CREATE TABLE sare_clases(
  rut_prof number(8),
  codigo_asig varchar2(5),
  codigo_unid number(2),
  anio_clase number(4) NOT NULL,
  grado_curso number(1),
  letra_curso char(1),
  nivel_curso char(1), 
  CONSTRAINT clases_pk PRIMARY KEY (rut_prof, codigo_asig, codigo_unid, grado_curso, letra_curso, nivel_curso),
  CONSTRAINT clases_fk_prof FOREIGN KEY (rut_prof) REFERENCES sare_profesores,
  CONSTRAINT clases_fk_unid FOREIGN KEY (codigo_asig, codigo_unid) REFERENCES sare_unidades,
  CONSTRAINT clases_fk_cursos FOREIGN KEY (grado_curso, letra_curso, nivel_curso) REFERENCES sare_cursos
);

CREATE TABLE sare_evaluaciones(
  rut_alum number(8),
  rut_prof number(8),
  codigo_asig varchar2(5),
  codigo_unid number(2),
  grado_curso number(1),
  letra_curso char(1),
  nivel_curso char(1), 
  fecha_eval date NOT NULL,
  puntaje_unid number(3) NOT NULL,
  CONSTRAINTS eval_pk PRIMARY KEY (rut_alum, rut_prof, codigo_asig, codigo_unid, grado_curso, letra_curso, nivel_curso),
  CONSTRAINTS eval_fk_alum FOREIGN KEY (rut_alum) REFERENCES sare_alumnos,
  CONSTRAINTS eval_fk_clas FOREIGN KEY (rut_prof, codigo_asig, codigo_unid, grado_curso, letra_curso, nivel_curso) REFERENCES sare_clases
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
    RUT_ALUM	= 	p_RUT,
    SEXO 		= 	p_SEXO,
    DIRECCION 	= 	p_DIRECCION
  WHERE RUT_ALUM = 	p_RUT;
  COMMIT;
  
END sp_usuario_alumno_update ;



-- I N S E R T   R E G I O N E S

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

-- I N S E R T   P R O V I N C I A S

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

-- I N S E R T   C O M U N A S

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

-- I N S E R T   C U R S O S

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(5,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(6,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(7,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'a','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'b','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'c','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'d','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'e','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'f','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'g','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'h','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'i','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'j','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'k','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'l','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'m','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'n','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'o','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'p','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'q','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'r','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'s','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'t','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'u','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'v','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'w','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'x','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'y','b');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(8,'z','b');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'a','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'b','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'c','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'d','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'e','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'f','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'g','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'h','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'i','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'j','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'k','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'l','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'m','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'n','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'o','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'p','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'q','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'r','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'s','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'t','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'u','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'v','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'w','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'x','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'y','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(1,'z','m');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'a','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'b','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'c','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'d','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'e','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'f','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'g','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'h','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'i','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'j','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'k','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'l','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'m','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'n','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'o','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'p','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'q','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'r','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'s','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'t','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'u','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'v','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'w','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'x','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'y','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(2,'z','m');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'a','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'b','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'c','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'d','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'e','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'f','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'g','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'h','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'i','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'j','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'k','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'l','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'m','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'n','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'o','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'p','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'q','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'r','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'s','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'t','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'u','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'v','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'w','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'x','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'y','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(3,'z','m');

INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'a','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'b','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'c','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'d','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'e','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'f','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'g','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'h','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'i','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'j','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'k','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'l','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'m','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'n','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'o','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'p','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'q','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'r','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'s','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'t','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'u','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'v','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'w','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'x','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'y','m');
INSERT INTO sare_cursos(grado,letra,nivel) VALUES(4,'z','m');

-- I N S E R T   A S I G N A T U R A S

INSERT INTO sare_asignaturas VALUES ('LEN1B', 'Lenguaje 1° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN2B', 'Lenguaje 2° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN3B', 'Lenguaje 3° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN4B', 'Lenguaje 4° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN5B', 'Lenguaje 5° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN6B', 'Lenguaje 6° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN7B', 'Lenguaje 7° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN8B', 'Lenguaje 8° Básico');
INSERT INTO sare_asignaturas VALUES ('LEN1M', 'Lenguaje 1° Medio');
INSERT INTO sare_asignaturas VALUES ('LEN2M', 'Lenguaje 2° Medio');
INSERT INTO sare_asignaturas VALUES ('LEN3M', 'Lenguaje 3° Medio');
INSERT INTO sare_asignaturas VALUES ('LEN4M', 'Lenguaje 4° Medio');
INSERT INTO sare_asignaturas VALUES ('MAT1B', 'Matemáticas 1° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT2B', 'Matemáticas 2° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT3B', 'Matemáticas 3° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT4B', 'Matemáticas 4° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT5B', 'Matemáticas 5° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT6B', 'Matemáticas 6° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT7B', 'Matemáticas 7° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT8B', 'Matemáticas 8° Básico');
INSERT INTO sare_asignaturas VALUES ('MAT1M', 'Matemáticas 1° Medio');
INSERT INTO sare_asignaturas VALUES ('MAT2M', 'Matemáticas 2° Medio');
INSERT INTO sare_asignaturas VALUES ('MAT3M', 'Matemáticas 3° Medio');
INSERT INTO sare_asignaturas VALUES ('MAT4M', 'Matemáticas 4° Medio');
INSERT INTO sare_asignaturas VALUES ('HIS1B', 'Historia 1° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS2B', 'Historia 2° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS3B', 'Historia 3° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS4B', 'Historia 4° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS5B', 'Historia 5° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS6B', 'Historia 6° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS7B', 'Historia 7° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS8B', 'Historia 8° Básico');
INSERT INTO sare_asignaturas VALUES ('HIS1M', 'Historia 1° Medio');
INSERT INTO sare_asignaturas VALUES ('HIS2M', 'Historia 2° Medio');
INSERT INTO sare_asignaturas VALUES ('HIS3M', 'Historia 3° Medio');
INSERT INTO sare_asignaturas VALUES ('HIS4M', 'Historia 4° Medio');


INSERT INTO sare_unidades VALUES ('LEN1B',1, 'Conocimiento de sí mismo e ingreso al mundo de la lectura y escritura');
INSERT INTO sare_unidades VALUES ('LEN1B',2, 'Comunicación con los demás a través del tiempo y del espacio');

INSERT INTO sare_unidades VALUES ('LEN2B',1, 'El lenguaje como medio para conocer y valorar el entorno');
INSERT INTO sare_unidades VALUES ('LEN2B',2, 'Manejo de la lengua y conocimientos elementales sobre la misma');
INSERT INTO sare_unidades VALUES ('LEN2B',3, 'El lenguaje y la vida');
INSERT INTO sare_unidades VALUES ('LEN2B',4, 'Manejo de la lengua y conocimientos elementales sobre la misma');

INSERT INTO sare_unidades VALUES ('LEN3B',1, 'Comunicación oral');
INSERT INTO sare_unidades VALUES ('LEN3B',2, 'Lectura');
INSERT INTO sare_unidades VALUES ('LEN3B',3, 'Escritura');
INSERT INTO sare_unidades VALUES ('LEN3B',4, 'Manejo de la lengua y conocimientos elementales sobre la misma');

INSERT INTO sare_unidades VALUES ('LEN4B',1, 'Comunicación oral');
INSERT INTO sare_unidades VALUES ('LEN4B',2, 'Lectura');
INSERT INTO sare_unidades VALUES ('LEN4B',3, 'Escritura');
INSERT INTO sare_unidades VALUES ('LEN4B',4, 'Manejo de la lengua y conocimientos elementales sobre la misma');

INSERT INTO sare_unidades VALUES ('LEN5B',1, 'Textos argumentativos');
INSERT INTO sare_unidades VALUES ('LEN5B',2, 'Textos narrativos literarios');
INSERT INTO sare_unidades VALUES ('LEN5B',3, 'Textos informativos');
INSERT INTO sare_unidades VALUES ('LEN5B',4, 'Textos poéticos');
INSERT INTO sare_unidades VALUES ('LEN5B',5, 'Textos normativos');
INSERT INTO sare_unidades VALUES ('LEN5B',6, 'Textos dramáticos ');
INSERT INTO sare_unidades VALUES ('LEN5B',7, 'Textos publicitarios');

INSERT INTO sare_unidades VALUES ('LEN6B',1, 'Comunicación oral');
INSERT INTO sare_unidades VALUES ('LEN6B',2, 'Comunicación escrita');
INSERT INTO sare_unidades VALUES ('LEN6B',3, 'Dramatización');
INSERT INTO sare_unidades VALUES ('LEN6B',4, 'Los medios de comunicación masiva');
INSERT INTO sare_unidades VALUES ('LEN6B',5, 'Conocimiento del lenguaje');

INSERT INTO sare_unidades VALUES ('LEN7B',1, 'Comunicación oral');
INSERT INTO sare_unidades VALUES ('LEN7B',2, 'Comunicación escrita');
INSERT INTO sare_unidades VALUES ('LEN7B',3, 'Dramatización');
INSERT INTO sare_unidades VALUES ('LEN7B',4, 'Los medios de comunicación masiva');
INSERT INTO sare_unidades VALUES ('LEN7B',5, 'Conocimiento del lenguaje');

INSERT INTO sare_unidades VALUES ('LEN8B',1, 'Comunicación oral');
INSERT INTO sare_unidades VALUES ('LEN8B',2, 'Comunicación escrita');
INSERT INTO sare_unidades VALUES ('LEN8B',3, 'Dramatización');
INSERT INTO sare_unidades VALUES ('LEN8B',4, 'Los medios de comunicación masiva');
INSERT INTO sare_unidades VALUES ('LEN8B',5, 'Conocimiento del lenguaje');

/*
Lenguaje Medio
*/
INSERT INTO sare_unidades VALUES ('LEN1M',1, 'La comunicación dialógica');
INSERT INTO sare_unidades VALUES ('LEN1M',2, 'Comunicación verbal y comunicación no verbal');
INSERT INTO sare_unidades VALUES ('LEN1M',3, 'Contexto sociocultural de la comunicación');

INSERT INTO sare_unidades VALUES ('LEN2M',1, 'El discurso expositivo como medio de intercambio de informaciones y conocimientos');
INSERT INTO sare_unidades VALUES ('LEN2M',2, 'La variedad del mundo y de lo humano comunicada por la literatura y los medios de comunicación');

INSERT INTO sare_unidades VALUES ('LEN3M',1, 'La argumentación');
INSERT INTO sare_unidades VALUES ('LEN3M',2, 'La literatura como fuente de argumentos (modelos y valores) para la vida personal y social');

INSERT INTO sare_unidades VALUES ('LEN4M',1, 'Discursos emitidos en situaciones públicas de enunciación');
INSERT INTO sare_unidades VALUES ('LEN4M',2, 'Análisis de textos literarios y no literarios referidos a temas contemporáneos');


/*
Matematica Basica
*/
INSERT INTO sare_unidades VALUES ('MAT1B',1, 'Los números');
INSERT INTO sare_unidades VALUES ('MAT1B',2, 'Operaciones aritméticas');
INSERT INTO sare_unidades VALUES ('MAT1B',3, 'Formas y espacio');
INSERT INTO sare_unidades VALUES ('MAT1B',4, 'Resolución de problemas');

INSERT INTO sare_unidades VALUES ('MAT2B',1, 'Los números');
INSERT INTO sare_unidades VALUES ('MAT2B',2, 'Operaciones aritméticas');
INSERT INTO sare_unidades VALUES ('MAT2B',3, 'Formas y espacio');
INSERT INTO sare_unidades VALUES ('MAT2B',4, 'Resolución de problemas');

INSERT INTO sare_unidades VALUES ('MAT3B',1, 'Números naturales');
INSERT INTO sare_unidades VALUES ('MAT3B',2, 'Formas y espacio');
INSERT INTO sare_unidades VALUES ('MAT3B',3, 'Resolución de problemas');


INSERT INTO sare_unidades VALUES ('MAT4B',1, 'Números racionales');
INSERT INTO sare_unidades VALUES ('MAT4B',2, 'Formas y espacio');
INSERT INTO sare_unidades VALUES ('MAT4B',3, 'Resolución de problemas');

INSERT INTO sare_unidades VALUES ('MAT5B',1, 'Tiempo y programaciones');
INSERT INTO sare_unidades VALUES ('MAT5B',2, 'Grandes números');
INSERT INTO sare_unidades VALUES ('MAT5B',3, 'Multiplicación y múltiplos');
INSERT INTO sare_unidades VALUES ('MAT5B',4, 'Divisiones y divisores');
INSERT INTO sare_unidades VALUES ('MAT5B',5, 'Geometría');

INSERT INTO sare_unidades VALUES ('MAT6B',1, 'Números naturales en la vida cotidiana ');
INSERT INTO sare_unidades VALUES ('MAT6B',2, 'Multiplicación de fracciones y división de fracciones');
INSERT INTO sare_unidades VALUES ('MAT6B',3, 'Fracciones y decimales en la vida cotidiana');
INSERT INTO sare_unidades VALUES ('MAT6B',4, 'Números decimales');
INSERT INTO sare_unidades VALUES ('MAT6B',5, 'Geometría');

INSERT INTO sare_unidades VALUES ('MAT7B',1, 'Números decimales en la vida cotidiana');
INSERT INTO sare_unidades VALUES ('MAT7B',2, 'Geometría: prismas, pirámides y triángulos');
INSERT INTO sare_unidades VALUES ('MAT7B',3, 'Sistemas de numeración en la historia y actuales');
INSERT INTO sare_unidades VALUES ('MAT7B',4, 'Relaciones de proporcionalidad');
INSERT INTO sare_unidades VALUES ('MAT7B',5, 'Potencias en la geometría y en los números');

INSERT INTO sare_unidades VALUES ('MAT8B',1, 'Polígonos, circunferencias, áreas y perímetros');
INSERT INTO sare_unidades VALUES ('MAT8B',2, 'Relaciones proporcionales');
INSERT INTO sare_unidades VALUES ('MAT8B',3, 'Números positivos y negativos. Ecuaciones');
INSERT INTO sare_unidades VALUES ('MAT8B',4, 'Potencias');
INSERT INTO sare_unidades VALUES ('MAT8B',5, 'Volumen');

/*
Matematica Medio
*/
INSERT INTO sare_unidades VALUES ('MAT1M',1, 'Números');
INSERT INTO sare_unidades VALUES ('MAT1M',2, 'Lenguaje algebraico');
INSERT INTO sare_unidades VALUES ('MAT1M',3, 'Transformaciones isométricas');
INSERT INTO sare_unidades VALUES ('MAT1M',4, 'Variaciones proporcionales');

INSERT INTO sare_unidades VALUES ('MAT2M',1, 'Nociones de probabilidades');
INSERT INTO sare_unidades VALUES ('MAT2M',2, 'Semejanza de figuras planas');
INSERT INTO sare_unidades VALUES ('MAT2M',3, 'Las fracciones en lenguaje algebraico');
INSERT INTO sare_unidades VALUES ('MAT2M',4, 'La circunferencia y sus ángulos');
INSERT INTO sare_unidades VALUES ('MAT2M',5, 'Ecuación de la recta y otras funciones, modelos de situaciones diarias');
INSERT INTO sare_unidades VALUES ('MAT2M',6, 'Sistemas de ecuaciones lineales');

INSERT INTO sare_unidades VALUES ('MAT3M',1, 'Las funciones cuadrática y raíz cuadrada');
INSERT INTO sare_unidades VALUES ('MAT3M',2, 'Inecuaciones lineales');
INSERT INTO sare_unidades VALUES ('MAT3M',3, 'Más sobre triángulos rectángulos');
INSERT INTO sare_unidades VALUES ('MAT3M',4, 'Otro paso en el estudio de las probabilidades');


INSERT INTO sare_unidades VALUES ('MAT4M',1, 'Estadística y probabilidad');
INSERT INTO sare_unidades VALUES ('MAT4M',2, 'Funciones potencia, logarítmica y exponencial');
INSERT INTO sare_unidades VALUES ('MAT4M',3, 'Geometría');


/*
Historia
*/

INSERT INTO sare_unidades VALUES ('HIS1B',1, 'Agrupaciones e instituciones sociales próximas');
INSERT INTO sare_unidades VALUES ('HIS1B',2, 'Diversidad del entorno local');
INSERT INTO sare_unidades VALUES ('HIS1B',3, 'Identidad corporal');
INSERT INTO sare_unidades VALUES ('HIS1B',4, 'Legado cultural nacional');
INSERT INTO sare_unidades VALUES ('HIS1B',5, 'Orientación en el espacio-tiempo');
INSERT INTO sare_unidades VALUES ('HIS1B',6, 'Reconocimiento de unidades de medidas convencionales');
INSERT INTO sare_unidades VALUES ('HIS1B',7, 'Sentido del pasado');

INSERT INTO sare_unidades VALUES ('HIS2B',1, 'Agrupaciones e instituciones sociales próximas');
INSERT INTO sare_unidades VALUES ('HIS2B',2, 'Profesiones, oficios y otras actividades laborales');
INSERT INTO sare_unidades VALUES ('HIS2B',3, 'Diversidad del entorno local');
INSERT INTO sare_unidades VALUES ('HIS2B',4, 'Interacción biológica en el entorno');

INSERT INTO sare_unidades VALUES ('HIS3B',1, 'El Universo');
INSERT INTO sare_unidades VALUES ('HIS3B',2, 'Ubicación y representación espacial');
INSERT INTO sare_unidades VALUES ('HIS3B',3, 'Principios básicos de clasificación');
INSERT INTO sare_unidades VALUES ('HIS3B',4, 'Interacción entre seres vivos y ambiente');
INSERT INTO sare_unidades VALUES ('HIS3B',5, 'Actividades de la vida comunitaria');

INSERT INTO sare_unidades VALUES ('HIS4B',1, 'Zonas climáticas de la Tierra');
INSERT INTO sare_unidades VALUES ('HIS4B',2, 'Culturas originarias de Chile');
INSERT INTO sare_unidades VALUES ('HIS4B',3, 'Pueblos nómades y sedentarios');
INSERT INTO sare_unidades VALUES ('HIS4B',4, 'Principios básicos de clasificación');
INSERT INTO sare_unidades VALUES ('HIS4B',5, 'Interacción entre seres vivos y ambiente');
INSERT INTO sare_unidades VALUES ('HIS4B',6, 'Los estados de la materia y la vida');

INSERT INTO sare_unidades VALUES ('HIS5B',1, 'Sistema de coordenadas geográficas y mapas');
INSERT INTO sare_unidades VALUES ('HIS5B',2, 'América precolombina');
INSERT INTO sare_unidades VALUES ('HIS5B',3, 'Expansión europea, descubrimiento de América y conquista de América');
INSERT INTO sare_unidades VALUES ('HIS5B',4, 'Relación sociedad-paisaje');

INSERT INTO sare_unidades VALUES ('HIS6B',1, 'El territorio de Chile, sus principales características geográfico-físicas y su organización administrativa');
INSERT INTO sare_unidades VALUES ('HIS6B',2, 'La Independencia y la formación del Estado nacional');
INSERT INTO sare_unidades VALUES ('HIS6B',3, 'Definiciones territoriales y cambios políticos y sociales a fines del siglo XIX');
INSERT INTO sare_unidades VALUES ('HIS6B',4, 'Chile en el siglo XX');
INSERT INTO sare_unidades VALUES ('HIS6B',5, 'Economía y vida cotidiana');

INSERT INTO sare_unidades VALUES ('HIS7B',1, 'La Tierra como sistema');
INSERT INTO sare_unidades VALUES ('HIS7B',2, 'De los albores de la humanidad a las culturas clásicas del mediterráneo');
INSERT INTO sare_unidades VALUES ('HIS7B',3, 'El mundo occidental: de la Época medieval a la moderna');
INSERT INTO sare_unidades VALUES ('HIS7B',4, 'Dos revoluciones conforman el mundo contemporáneo');

INSERT INTO sare_unidades VALUES ('HIS8B',1, 'La humanidad en los inicios de un nuevo siglo');
INSERT INTO sare_unidades VALUES ('HIS8B',2, 'Procesos políticos que marcaron el siglo XX');
INSERT INTO sare_unidades VALUES ('HIS8B',3, 'Problemas del mundo actual y esfuerzos por superarlos: la pobreza');
INSERT INTO sare_unidades VALUES ('HIS8B',4, 'Derechos y deberes que conlleva la vida en sociedad');

INSERT INTO sare_unidades VALUES ('HIS1M',1, 'Entorno natural y comunidad regional');
INSERT INTO sare_unidades VALUES ('HIS1M',2, 'Territorio regional y nacional ');
INSERT INTO sare_unidades VALUES ('HIS1M',3, 'Organización política');
INSERT INTO sare_unidades VALUES ('HIS1M',4, 'Organización económica');

INSERT INTO sare_unidades VALUES ('HIS2M',1, 'conociendo la Historia de Chile');
INSERT INTO sare_unidades VALUES ('HIS2M',2, 'Construcción de una identidad mestiza');
INSERT INTO sare_unidades VALUES ('HIS2M',3, 'La creación de una nación');
INSERT INTO sare_unidades VALUES ('HIS2M',4, 'La sociedad finisecular: auge y crisis del liberalismo');
INSERT INTO sare_unidades VALUES ('HIS2M',5, 'El siglo XX: la búsqueda del desarrollo económico y de la justicia social');

INSERT INTO sare_unidades VALUES ('HIS3M',1, 'La diversidad de civilizaciones');
INSERT INTO sare_unidades VALUES ('HIS3M',2, 'La herencia clásica: Grecia y Roma como raíces de la civilización occidental');
INSERT INTO sare_unidades VALUES ('HIS3M',3, 'La Europa medieval y el cristianismo');
INSERT INTO sare_unidades VALUES ('HIS3M',4, 'El humanismo y el desarrollo del pensamiento científico');
INSERT INTO sare_unidades VALUES ('HIS3M',5, 'La era de las revoluciones y la conformación del mundo contemporáneo ');


INSERT INTO sare_unidades VALUES ('HIS4M',1, 'Antecedentes históricos para la comprensión del orden mundial actual');
INSERT INTO sare_unidades VALUES ('HIS4M',2, 'América Latina contemporánea');
INSERT INTO sare_unidades VALUES ('HIS4M',3, 'El mundo actual ');
