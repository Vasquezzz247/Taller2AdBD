--correr este script
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

--Tarea 2, Creacion de espacios de trabajo

--tablespace para administradores
CREATE TABLESPACE t_dbadmin
DATAFILE 'C:\demo\t_dbadmin.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 10M
MAXSIZE UNLIMITED;

--tablespace para empleados (Administrativos, coordinadores, docentes
CREATE TABLESPACE t_empleados
DATAFILE 'C:\demo\t_empleados.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 10M
MAXSIZE UNLIMITED;

--Tablespace para estudiantes
CREATE TABLESPACE t_estudiantes
DATAFILE 'C:\demo\t_estudiantes.dbf'
SIZE 10M
AUTOEXTEND ON
NEXT 10M
MAXSIZE UNLIMITED;

--Creacion de usuario administrador, udbamdin
CREATE USER udbadmin
IDENTIFIED BY admin0
DEFAULT TABLESPACE t_dbadmin
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON t_dbadmin;

-- Asignar privilegios al usuario
GRANT CONNECT, CREATE TABLE TO udbadmin;

-- Aplicar la función de verificación de contraseña
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
ALTER PROFILE DEFAULT LIMIT PASSWORD_REUSE_MAX UNLIMITED;
ALTER PROFILE DEFAULT LIMIT PASSWORD_REUSE_TIME UNLIMITED;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LOCK_TIME UNLIMITED;
ALTER PROFILE DEFAULT LIMIT PASSWORD_GRACE_TIME UNLIMITED;
ALTER USER udbadmin PROFILE DEFAULT;

--Conectar como el usuario udbadmin
CONNECT udbadmin
--CONNECT c##udbadmin

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

--Tarea 3, creacion de roles correspondientes a los roles de trabajo

--conectar a usuario SYS
CONNECT SYS AS SYSDBA


--Crear rol administrativo
CREATE ROLE administrativo;
GRANT CREATE SESSION TO administrativo;
GRANT INSERT, SELECT, DELETE, UPDATE ON EMPLEADO TO administrativo;
GRANT INSERT, SELECT, DELETE, UPDATE ON ESTUDIANTE TO administrativo;

--Crear rol coordinador
CREATE ROLE coordinador;
GRANT CREATE SESSION TO coordinador;
GRANT SELECT, UPDATE ON ESTUDIANTE TO coordinador;
GRANT INSERT, SELECT, DELETE, UPDATE ON MATERIA TO coordinador;
GRANT INSERT, SELECT, DELETE, UPDATE ON SECCION TO coordinador;
GRANT INSERT, SELECT, DELETE, UPDATE ON LISTA_ESTUDIANTES TO coordinador;
GRANT SELECT ON EVALUACION TO coordinador;
GRANT SELECT ON NOTA TO coordinador;
--GRANT SELECT ON EMPLEADO TO coordinador WHERE id_tipo_empleado = 2;

--Crear rol doncente
CREATE ROLE docente;
GRANT CREATE SESSION TO docente;
GRANT INSERT, SELECT, DELETE, UPDATE ON EVALUACION TO docente;
GRANT INSERT, SELECT, DELETE, UPDATE ON NOTA TO docente;
GRANT SELECT ON ESTUDIANTE TO docente;
GRANT SELECT ON SECCION TO docente;
GRANT SELECT ON LISTA_ESTUDIANTES TO docente;

--Crear rol estudiante
CREATE ROLE estudiante;
GRANT CREATE SESSION TO estudiante;

--Tarea 5, Creacion de usuarios

DECLARE
    v_password VARCHAR2(20);
BEGIN
    DBMS_RANDOM.STRING('A', 10);
END;
/

-- Asignar Tablespace, Cuota y Rol a usuarios
DECLARE
    v_password VARCHAR2(20);
BEGIN
    --Usuario administrativo
    v_password := 'contraseña_administrativo'; 
    EXECUTE IMMEDIATE 'CREATE USER usuario_admin IDENTIFIED BY ' || v_password;
    EXECUTE IMMEDIATE 'ALTER USER usuario_admin DEFAULT TABLESPACE t_dbadmin QUOTA UNLIMITED ON t_dbadmin';
    EXECUTE IMMEDIATE 'GRANT administrativo TO usuario_admin';

    --Usuario coordinador
    v_password := 'contraseña_coordinador';
    EXECUTE IMMEDIATE 'CREATE USER usuario_coord IDENTIFIED BY ' || v_password;
    EXECUTE IMMEDIATE 'ALTER USER usuario_coord DEFAULT TABLESPACE t_empleados QUOTA UNLIMITED ON t_empleados';
    EXECUTE IMMEDIATE 'GRANT coordinador TO usuario_coord';

    --Usuario docente
    v_password := 'contraseña_docente';
    EXECUTE IMMEDIATE 'CREATE USER usuario_docente IDENTIFIED BY ' || v_password;
    EXECUTE IMMEDIATE 'ALTER USER usuario_docente DEFAULT TABLESPACE t_empleados QUOTA UNLIMITED ON t_empleados';
    EXECUTE IMMEDIATE 'GRANT docente TO usuario_docente';

    --Usuario estudiante
    v_password := 'contraseña_estudiante';
    EXECUTE IMMEDIATE 'CREATE USER usuario_estudiante IDENTIFIED BY ' || v_password;
    EXECUTE IMMEDIATE 'ALTER USER usuario_estudiante DEFAULT TABLESPACE t_estudiantes QUOTA UNLIMITED ON t_estudiantes';
    EXECUTE IMMEDIATE 'GRANT estudiante TO usuario_estudiante';
END;
/









