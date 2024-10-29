/***************************************************************************************************
Otros objetos de esquema: vistas, secuencias, �ndices, sin�nimos
****************************************************************************************************
*/
/* Ejemplo 01: Vistas
******************************************************
Es una consulta que se presenta como una tabla (virtual) a partir de un 
conjunto de tablas en una base de datos relacional. Las vistas tienen la
misma estructura que una tabla: filas y columnas. La �nica diferencia es
que s�lo se almacena de ellas la definici�n, no los datos.

VENTAJAS
- Para restringir el acceso a datos.
- Para crear consultas complejas f�cilmente.
- Proveer datos independientes.
- Presentar diferentes vistas de los mismos datos.

TIPOS DE VISTAS
   
CARACTER�STICAS            SIMPLES     COMPUESTA
-------------------------------------------------
N�mero de tablas           Una         Una o m�s
Contiene funciones         No          S�
Contiene datos agrupados   No          S�
Operaciones DML a
trav�s de la vista         S�          No siempre

SINTAXIS DE LA VISTA
Se puede incrustar un subquery en la sentencia CREATE VIEW
  
  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW view
  [(alias[, alias]...)]
  AS subquery
  [WITH CHECK OPTION [CONSTRAINT constraint]]
  [WITH READ ONLY [CONSTRAINT constraint]];
  
FORCE: Crea la vista as� exista o no existan las tablas a las que se hace referencia en la vista.
NOFORCE (default): Crea la vista solo si las tablas a las que se hace referencia existen.
  
El subquery puede contener sintaxis complejas de la sentencia SELECT.

Lineamientos de las operaciones DML en una vista:

- Usualmente las operaciones DML pueden ejecutarse sobre vistas simples.
- No se puede ELIMINAR FILAS si la vista contiene:
  * Funciones de grupo.
  * La cl�usula GROUP BY.
  * La palabra DISTINCT.
  * La pseudocolumna ROWNUM.
  * Las columnas estan definidas por expresiones. (Ejm. Salary * 12)
  * Si existen columnas definidas como NOT NULL y no est�n 
    seleccionadas en la vista.
*/
CREATE VIEW empvu80
AS
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id = 80;

SELECT *
FROM empvu80;
--------------------------------------------------------------------------------
CREATE VIEW salvu50
AS
SELECT employee_id ID_NUMBER, salary * 12 ANN_SALARY
FROM employees
WHERE department_id = 50;

SELECT *
FROM salvu50;
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW empvu80
(id_number, name, sal, department_id) -- Nombre que tendr�n las columnas de la vista
AS
SELECT employee_id, first_name || ' ' || last_name, salary, department_id
FROM employees
WHERE department_id = 80;

SELECT id_number, name, sal, department_id
FROM empvu80;
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW dept_sum_vu
(name, minsal, maxsal, avgsal)
AS
SELECT d.department_name, MIN(e.salary), MAX(e.salary), AVG(e.salary)
FROM  employees e
    JOIN departments d ON (e.department_id = d.department_id)
GROUP BY d.department_name;

SELECT * 
FROM dept_sum_vu;

/* Ejemplo 02: Cl�usula: WITH CHECK OPTION
******************************************************
Puede asegurar que una operaci�n DML sobre la vista est� en dominio de la misma
vista, usando la cl�usula WITH CHECK OPTION.

Cualquier intento de INSERT o UPDATE de fila con un department_id
diferente de 20, falla por que viola el constraint WITH CHECK OPTION.
*/
CREATE OR REPLACE VIEW empvu20
AS
SELECT * 
FROM employees
WHERE department_id = 20;
WITH CHECK OPTION CONSTRAINT empvu20_ck;

/* Ejemplo 03: Negar operaciones DML
******************************************************
- Se puede asegurar que ninguna operaci�n DML ocurra agregando la opci�n 
  WITH READ ONLY en la definici�n de la vista.
- Cualquier intento de realizar una operaci�n DML sobre una fila en Oracle, 
  el resultado ser�a un error.
*/
CREATE OR REPLACE VIEW empvu10
(employee_number, employee_name, job_title)
AS
SELECT employee_id, last_name, job_id
FROM employees
WHERE department_id = 10
WITH READ ONLY;

/* Ejemplo 04: Secuencias
******************************************************
- Puede autom�ticamente generar valores �nicos.
- Es un objeto compartido.
- Su valor puede ser utilizado como clave primaria.
- Reemplaza el c�digo de aplicaci�n.
- Acelera la eficiencia de acceso a los valores de secuencia cuando est�
  almacenado en cach�.
  
  CREATE SEQUENCE sequence
  [INCREMENT BY n]
  [START WITH n]
  [{MAXVALUE n | NOMAXVALUE}]
  [{MINVALUE n| NOMINVALUE}]
  [{CICLE | NOCYCLE(Por defecto)}]
  [{CACHE n| NOCACHE(Por defecto)}];

NEXTVAL y CURRVAL
-----------------
- NEXTVAL: Retorna el pr�ximo valor disponible de la secuencia. Este retorna
           un valor �nico cada vez que es referenciado, as� sea para diferentes usuarios.
- CURRVAL: Obtiene el valor actual de la secuencia.

NOTA: NEXTVAL debe ser usado por la secuencia antes de que sea un valor 
      contenido en el CURRVAL.
      
Directrices de la secuencia:

- Debe ser propietario o tener el privilegio de ALTER para la secuencia.
- Solo los n�meros que pueden ser futura secuencia pueden ser modificados.
- La secuencia debe ser eliminada y recreada para reinicar la secuencia en un
  n�mero diferente.
- Para eliminar una secuencia, se debe usar la secuencia DROP.
  
  DROP SEQUENCE dept_deptid_seq;
*/
CREATE SEQUENCE dept_depid_seq
INCREMENT BY 10
START WITH 520
MAXVALUE 9999
NOCACHE
NOCYCLE;

INSERT INTO departments(department_id, department_name, location_id)
VALUES(dept_depid_seq.NEXTVAL, 'DBA', 2500);

INSERT INTO departments(department_id, department_name, location_id)
VALUES(dept_depid_seq.NEXTVAL, 'DBA', 1800);

-- Si hacemos uso del NEXTVAL as� sea solo para ver el valor, este va a incrementar.
SELECT dept_depid_seq.CURRVAL, dept_depid_seq.NEXTVAL
FROM dual;

INSERT INTO departments(department_id, department_name, location_id)
VALUES(dept_depid_seq.NEXTVAL, 'Otra secuencia', 1800);

-- Alter sequence
ALTER SEQUENCE dept_depid_seq
INCREMENT BY 20
MAXVALUE 999999
NOCACHE
NOCYCLE;

INSERT INTO departments(department_id, department_name, location_id)
VALUES(dept_depid_seq.NEXTVAL, 'Otra secuencia', 1800);

-- Drop sequence
DROP SEQUENCE dept_depid_seq;

/* Ejemplo 05: �ndices
******************************************************
- Es un objeto de esquema.
- Es usado por el Oracle Server para acelerar la b�squeda de los datos usando
  un apuntador.
- Puede reducir las entradas y salidas (I/O) usando un m�todo para localizar
  datos r�pidamente.
- Es dependiente sobre la tabla que fue creado el �ndice.
- Es usado y mantenido autom�ticamente por Oracle.

�CU�NDO SE CREAN LOS �NDICES?
-----------------------------
- AUTOM�TICAMENTE: Clave primaria o una restricci�n �nica.
- MANUALMENTE: Definidos por el usuario.

La cl�usula BITMAP significa �ndice como mapa de bits

CREATE [UNIQUE][BITMAP]INDEX index
ON table (column[, column]...);
*/
CREATE INDEX emp_name_idx
ON  employees(last_name);

/*
Eliminar un �ndice
------------------
- Para eliminar un �ndice, se realiza a trav�s de la sentencia DROP INDEX.
  
  DROP INDEX index;

- Adem�s se debe ser propietario del �ndice o tener el privilegio DROP ANY INDEX.

  DROP INDEX emp_last_name_idx;

NOTA: Un �dice no se puede alterar
*/
DROP INDEX emp_name_idx;


/* Ejemplo 02: Sin�nimos
******************************************************
- Simplificar el acceso a los objetos creando sin�nimos (otro nombre para un objeto).
- Con los sin�nimos se puede: 
  * Crear una referencia m�s sencilla a una tabla que es propiedad de otro usuario.
  * Acortar los nombres de los objetos que son largos.
  
  CREATE [PUBLIC] SYNONYM synonym
  FROM object;  
*/
-- Creamos un sin�nimo(d_sum) para la vista(dept_sum_vu)
CREATE SYNONYM d_sum
FOR dept_sum_vu;

-- Como el nombre de la vista es largo: dept_sum_vu
SELECT * 
FROM dept_sum_vu;

-- Con el sin�nimo solo lo llamaremos: d_sum
SELECT * 
FROM d_sum;--Obtenemos lo mismo

DROP SYNONYM d_sum;