/***************************************************************************************************
Otros objetos de esquema: vistas, secuencias, índices, sinónimos
****************************************************************************************************
*/
/* Ejemplo 01: Vistas
******************************************************
Es una consulta que se presenta como una tabla (virtual) a partir de un 
conjunto de tablas en una base de datos relacional. Las vistas tienen la
misma estructura que una tabla: filas y columnas. La única diferencia es
que sólo se almacena de ellas la definición, no los datos.

VENTAJAS
- Para restringir el acceso a datos.
- Para crear consultas complejas fácilmente.
- Proveer datos independientes.
- Presentar diferentes vistas de los mismos datos.

TIPOS DE VISTAS
   
CARACTERÍSTICAS            SIMPLES     COMPUESTA
-------------------------------------------------
Número de tablas           Una         Una o más
Contiene funciones         No          Sí
Contiene datos agrupados   No          Sí
Operaciones DML a
través de la vista         Sí          No siempre

SINTAXIS DE LA VISTA
Se puede incrustar un subquery en la sentencia CREATE VIEW
  
  CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW view
  [(alias[, alias]...)]
  AS subquery
  [WITH CHECK OPTION [CONSTRAINT constraint]]
  [WITH READ ONLY [CONSTRAINT constraint]];
  
FORCE: Crea la vista así exista o no existan las tablas a las que se hace referencia en la vista.
NOFORCE (default): Crea la vista solo si las tablas a las que se hace referencia existen.
  
El subquery puede contener sintaxis complejas de la sentencia SELECT.

Lineamientos de las operaciones DML en una vista:

- Usualmente las operaciones DML pueden ejecutarse sobre vistas simples.
- No se puede ELIMINAR FILAS si la vista contiene:
  * Funciones de grupo.
  * La cláusula GROUP BY.
  * La palabra DISTINCT.
  * La pseudocolumna ROWNUM.
  * Las columnas estan definidas por expresiones. (Ejm. Salary * 12)
  * Si existen columnas definidas como NOT NULL y no están 
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
(id_number, name, sal, department_id) -- Nombre que tendrán las columnas de la vista
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

/* Ejemplo 02: Cláusula: WITH CHECK OPTION
******************************************************
Puede asegurar que una operación DML sobre la vista está en dominio de la misma
vista, usando la cláusula WITH CHECK OPTION.

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
- Se puede asegurar que ninguna operación DML ocurra agregando la opción 
  WITH READ ONLY en la definición de la vista.
- Cualquier intento de realizar una operación DML sobre una fila en Oracle, 
  el resultado sería un error.
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
- Puede automáticamente generar valores únicos.
- Es un objeto compartido.
- Su valor puede ser utilizado como clave primaria.
- Reemplaza el código de aplicación.
- Acelera la eficiencia de acceso a los valores de secuencia cuando está
  almacenado en caché.
  
  CREATE SEQUENCE sequence
  [INCREMENT BY n]
  [START WITH n]
  [{MAXVALUE n | NOMAXVALUE}]
  [{MINVALUE n| NOMINVALUE}]
  [{CICLE | NOCYCLE(Por defecto)}]
  [{CACHE n| NOCACHE(Por defecto)}];

NEXTVAL y CURRVAL
-----------------
- NEXTVAL: Retorna el próximo valor disponible de la secuencia. Este retorna
           un valor único cada vez que es referenciado, así sea para diferentes usuarios.
- CURRVAL: Obtiene el valor actual de la secuencia.

NOTA: NEXTVAL debe ser usado por la secuencia antes de que sea un valor 
      contenido en el CURRVAL.
      
Directrices de la secuencia:

- Debe ser propietario o tener el privilegio de ALTER para la secuencia.
- Solo los números que pueden ser futura secuencia pueden ser modificados.
- La secuencia debe ser eliminada y recreada para reinicar la secuencia en un
  número diferente.
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

-- Si hacemos uso del NEXTVAL así sea solo para ver el valor, este va a incrementar.
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

/* Ejemplo 05: Índices
******************************************************
- Es un objeto de esquema.
- Es usado por el Oracle Server para acelerar la búsqueda de los datos usando
  un apuntador.
- Puede reducir las entradas y salidas (I/O) usando un método para localizar
  datos rápidamente.
- Es dependiente sobre la tabla que fue creado el índice.
- Es usado y mantenido automáticamente por Oracle.

¿CUÁNDO SE CREAN LOS ÍNDICES?
-----------------------------
- AUTOMÁTICAMENTE: Clave primaria o una restricción única.
- MANUALMENTE: Definidos por el usuario.

La cláusula BITMAP significa índice como mapa de bits

CREATE [UNIQUE][BITMAP]INDEX index
ON table (column[, column]...);
*/
CREATE INDEX emp_name_idx
ON  employees(last_name);

/*
Eliminar un índice
------------------
- Para eliminar un índice, se realiza a través de la sentencia DROP INDEX.
  
  DROP INDEX index;

- Además se debe ser propietario del índice o tener el privilegio DROP ANY INDEX.

  DROP INDEX emp_last_name_idx;

NOTA: Un ídice no se puede alterar
*/
DROP INDEX emp_name_idx;


/* Ejemplo 02: Sinónimos
******************************************************
- Simplificar el acceso a los objetos creando sinónimos (otro nombre para un objeto).
- Con los sinónimos se puede: 
  * Crear una referencia más sencilla a una tabla que es propiedad de otro usuario.
  * Acortar los nombres de los objetos que son largos.
  
  CREATE [PUBLIC] SYNONYM synonym
  FROM object;  
*/
-- Creamos un sinónimo(d_sum) para la vista(dept_sum_vu)
CREATE SYNONYM d_sum
FOR dept_sum_vu;

-- Como el nombre de la vista es largo: dept_sum_vu
SELECT * 
FROM dept_sum_vu;

-- Con el sinónimo solo lo llamaremos: d_sum
SELECT * 
FROM d_sum;--Obtenemos lo mismo

DROP SYNONYM d_sum;