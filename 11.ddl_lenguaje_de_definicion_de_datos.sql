/***************************************************************************************************
DDL: Lenguaje de Definici�n de Datos
****************************************************************************************************
Objetos de la base de datos:

- Table(Tabla): Unidad b�sica de almacenamiento, compuesto por filas.
- View(Vista):  Representan l�gicamente un subconjunto de datos de una o m�s tablas.
- Sequence(Secuencia): Genera valores num�ricos.
- Index(�ndice): Mejora el desempe�o de algunas consultas.
- Synonym(Sin�nimo): Ofrece crear nombres alternativos para un objeto.
*/

/* Ejemplo 01: Opci�n DEFAULT
******************************************************
- Especifica un valor por default para una columna durante el insert.
  hire_date DATE DEFAULT SYSDATE,...
- Valores literales, expresiones o funciones SQL pueden ser usados.
- Otro nombre de columna o pseudocolumna no pueden ser utilizados.
- El tipo de dato por DEFAULT debe coincidir con el tipo de dato de una columna.
- No debe ser una palabra reservada de Oracle Server.
*/
CREATE TABLE aaa(
  id NUMBER(6),
  col_a DATE DEFAULT SYSDATE,
  col_b VARCHAR2(25) DEFAULT 'Sin asignar',
  col_c NUMBER(2) DEFAULT 0
);

SELECT * 
FROM aaa;

INSERT INTO aaa
VALUES(1, TO_DATE('MAY 10, 2018', 'MON DD, YYYY'), 'Delimar', 10);

INSERT INTO aaa(id, col_a)
VALUES(2, TO_DATE('MAY 10, 2018', 'MON DD, YYYY'));

INSERT INTO aaa(id)
VALUES(3);

INSERT INTO aaa(id, col_a, col_b)
VALUES(4, TO_DATE('MAY 10, 2018', 'MON DD, YYYY'), NULL);

/* Ejemplo 02: Tipos de datos y restricciones
******************************************************
Tipos de datos:

- VARCHAR2(size): Cadena de caracteres de longitud variable
- CHAR(size): Cadena de caracteres de longitud fija.
- NUMBER(p, s): Almacena n�meros fijos y puntos flotantes.
- DATE: Almacena un punto en el tiempo (fecha y hora).
- LONG: Cadena de caracteres de lon gitud variable (Max 2GB).
- CLOB: Almacena datos de tipo car�cter (Max 4GB).
- RAW y LONG RAW: Almacena cadenas binarias de ancho variable.
- BLOB y BFILE: Almacena bloques grandes de datos no estructurados, de tipo binario o de car�cter.
- ROWID: Almacena una direcci�n �nica de cada fila de la tabla de la base de datos.
- TIMESTAMP: Fecha y hora con fracci�n de segundos.
- INTERVAL YEAR TO MONTH: Almacena un intervalo de a�os en meses
- INTERVAL DAY TO SECOND: Almacena un intervalo de d�as, minutos y segundos.

Restricciones (Constraints):

- NOT NULL    :
- UNIQUE      :
- CHECK       :
- PRIMARY KEY :
- FOREING KEY :

- Se puede otorgar un nombre a los constraints o el servidor de Oracle genera un 
  nombre usando el formato SYS_Cn.
- �Cu�ndo se pueden crear los constraints?
  * En el mismo momento de la creaci�n de la tabla.
  * Despu�s de la creaci�n de la tabla.
- Se define una restricci�n a nivel de columna o a nivel de tabla
- Para ver una restricci�n se hace a trav�s del diccionario de datos.
*/

-- PK a nivel de columna
CREATE TABLE bbb(
  bbb_id NUMBER(6) CONSTRAINT bbb_id_pk PRIMARY KEY,
  col_a VARCHAR2(20)
);

-- PK a niv�s de tabla
CREATE TABLE ccc(
  ccc_id NUMBER(6),
  col_a VARCHAR2(20),
  CONSTRAINT ccc_id_pk PRIMARY KEY(ccc_id)
);

-- NOT NULL
CREATE TABLE ddd(
  ddd_id NUMBER(6),
  col_a VARCHAR2(20) NOT NULL
);

-- UNIQUE
CREATE TABLE eee(
  eee_id NUMBER(6),
  col_a VARCHAR2(20) NOT NULL,
  col_b NUMBER(2) UNIQUE,
  CONSTRAINT eee_id_pk PRIMARY KEY(eee_id)
);

-- CHECK
CREATE TABLE fff(
  fff_id NUMBER(6), 
  col_a VARCHAR2(20) NOT NULL,
  salario NUMBER(2) 
  CONSTRAINT fff_salario CHECK (salario > 0)
);

/*
- FOREIGN KEY: Define la columna en la tabla secundaria en el nivel de restricci�n de tabla.
- REFERENCES: Identifica la tabla y columna en la tabla padre o primaria.
- ON DELETE CASCADE: Cuando se elimina una fila de la tabla principal elimina 
  las filas dependientes en la tabla secundaria
- ON DELETE SET NULL: Convertir los valores de las claves for�neas dependientes en null.
*/
CREATE TABLE supplier(
  supplier_id NUMERIC(10) NOT NULL,
  supplier_name VARCHAR2(50) NOT NULL,
  contact_name VARCHAR2(50),
  CONSTRAINT supplier_pk PRIMARY KEY(supplier_id)
);
CREATE TABLE products(
  product_id NUMERIC(10) NOT NULL,
  supplier_id NUMERIC(10) NOT NULL,
  CONSTRAINT fk_supplier FOREIGN KEY(supplier_id) REFERENCES supplier(supplier_id)
);

/* Ejemplo 03: Tabla que hace referencia a s� misma
******************************************************
*/
-- Primera forma
CREATE TABLE persona(
  id NUMBER(3) NOT NULL CONSTRAINT id_pk PRIMARY KEY,
  nombre VARCHAR2(20) CONSTRAINT nombre_nn NOT NULL,
  cargo VARCHAR2(20) CONSTRAINT cargo_nn NOT NULL,
  idJefe NUMBER(3) CONSTRAINT idJefe_fk REFERENCES persona(id)  
);

-- Segunda forma
CREATE TABLE persona(
  id NUMBER(3) NOT NULL CONSTRAINT id_pk PRIMARY KEY,
  nombre VARCHAR2(20) CONSTRAINT nombre_nn NOT NULL,
  cargo VARCHAR2(20) CONSTRAINT cargo_nn NOT NULL,
  idJefe NUMBER(3),
  CONSTRAINT idJefe_fk FOREIGN KEY(idJefe) REFERENCES persona(id)  
);

/* Ejemplo 04: Crear tabla con subConsultas
******************************************************
*/
CREATE TABLE dept80 
AS
SELECT employee_id, last_name, salary*12 SAL_anual, hire_date
FROM employees
WHERE department_id = 80;

SELECT *
FROM dept80;

/* Ejemplo 05: Sentencia ALTER TABLE
******************************************************
- Agregar una nueva columna.
- Modificar la definici�n de una columna existente.
- Definir un valor por default para la nueva columna.
- Elimina una columna.
- Renombrar una columna.
- Cambiar el status de una tabla.

Tablas de solo lectura (read only), por defecto se crean de lectura y escritura:

ALTER TABLE table_name READ ONLY;
ALTER TABLE table_name READ WRITE; (default)

- Se puede colocar una tabla en modo de "S�lo lectura" para prevenir los cambios
  de DDL o DML durante un mantenimiento.
*/
ALTER TABLE dept80
ADD col_a NUMBER(6);

ALTER TABLE dept80 READ ONLY;

/* 
Como en la instrucci�n anterior hicimos un alter de la tabla dept80 a READ ONLY,
cuando ejecutemos la instrucci�n de abajo nos mostrar� el siguiente error:

SQL Error: ORA-12081: update operation not allowed on table "HR"."DEPT80"
12081. 00000 -  "update operation not allowed on table \"%s\".\"%s\""
*Cause:    An attempt was made to update a read-only materialized view.
*/
DELETE FROM dept80 
WHERE employee_id = 145;

-- Volvemos a colocar la tabla a READ y WRITE
ALTER TABLE dept80 READ WRITE;



/* Ejemplo 06: Eliminando una tabla
******************************************************
Elimina la estructura de la tabla incluyendo los datos que se encuentran 
almacenados en ella.
*/
DROP TABLE dept80;


