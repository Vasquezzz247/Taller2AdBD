CREATE TABLE EMPLEADO (
	carnet CHAR(8) PRIMARY KEY,
	nombre VARCHAR2(256),
	correo VARCHAR2(256),
	id_tipo_empleado INT -- 0: administrativo, 1: coordinador, 2: docente
);

CREATE TABLE MATERIA (
	id INT PRIMARY KEY,
	nombre VARCHAR2(64),
	creditos INT,
	correlativo INT
);

CREATE TABLE ESTUDIANTE (
	carnet CHAR(8) PRIMARY KEY,
	nombre VARCHAR2(256),
	correo VARCHAR2(256)
);

CREATE TABLE EVALUACION (
	id INT PRIMARY KEY,
	titulo VARCHAR2(64),
	porcentaje FLOAT
);

CREATE TABLE SECCION (
	id INT PRIMARY KEY,
	carnet_empleado CHAR(8),
	id_materia INT, 
	correlativo INT,
	ciclo INT, 
	annio INT
);

ALTER TABLE SECCION ADD FOREIGN KEY (carnet_empleado) REFERENCES EMPLEADO (carnet);
ALTER TABLE SECCION ADD FOREIGN KEY (id_materia) REFERENCES MATERIA (id);


CREATE TABLE LISTA_ESTUDIANTES (
	carnet_estudiante CHAR(8),
	id_seccion INT
);

ALTER TABLE LISTA_ESTUDIANTES ADD PRIMARY KEY (carnet_estudiante, id_seccion);
ALTER TABLE LISTA_ESTUDIANTES ADD FOREIGN KEY (carnet_estudiante) REFERENCES ESTUDIANTE (carnet);
ALTER TABLE LISTA_ESTUDIANTES ADD FOREIGN KEY (id_seccion) REFERENCES SECCION (id);

CREATE TABLE NOTA (
	id INT PRIMARY KEY,
	carnet_estudiante CHAR(8),
	id_evaluacion INT,
	id_seccion INT,
	nota_obtenida FLOAT 
);
ALTER TABLE NOTA ADD FOREIGN KEY (carnet_estudiante) REFERENCES ESTUDIANTE (carnet);
ALTER TABLE NOTA ADD FOREIGN KEY (id_evaluacion) REFERENCES EVALUACION (id);
ALTER TABLE NOTA ADD FOREIGN KEY (id_seccion) REFERENCES SECCION (id);