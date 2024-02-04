/***************************************************************************************************
Sentencia SELECT
****************************************************************************************************
*/
/* Ejemplo 01
******************************************************
*/
SELECT *
FROM departments;

SELECT department_name AS "name", location_id
FROM departments;

/* Ejemplo 02
******************************************************
Expresiones aritméticas
*/
SELECT last_name, salary, salary + 30 AS "suma 30"
FROM employees;

SELECT last_name, salary, 12*(salary +100)
FROM employees;

/* Ejemplo 03
******************************************************
Valores NULL en expresiones aritméticas
*/
SELECT * 
FROM employees;

SELECT last_name, commission_pct, 12 * salary * commission_pct
FROM employees;

/* Ejemplo 04
******************************************************
Alias de columnas
*/
SELECT last_name AS "apellido", commission_pct comision
FROM employees;

/* Ejemplo 05
******************************************************
Operador de concatenación ||

- Vincula columnas o caracteres a otra columna.
- Es representada por dos barras verticales ||.
- Crea una columna resultado que es una expresión de caracteres.
*/
SELECT last_name || ' is a ' || job_id || ' ' || salary 
FROM employees;

/* Ejemplo 06
******************************************************
Operador Quote (q)

- Funciona para establecer tu propio marcador de citas
- Se puede seleccionar cualquier delimitador
- Incrementa el uso y la lectura
- Para usar una comilla simple dentro de una cadena
- También se puede usar dos comillas simples, luego en el resultado
  saldrá solo una comilla simple. Ejemplo: 
*/
SELECT 'Asi saldra''s este ejemplo' 
FROM dual;

SELECT last_name, last_name || q'[Departments's Manager id: ]' || manager_id AS "department and manager"
FROM employees;

/* Ejemplo 07
******************************************************
Cláusula DISTINCT
*/
SELECT DISTINCT department_id
FROM employees;

/* Ejemplo 08
******************************************************
Mostrar la estructra de una tabla
*/
DESCRIBE employees;
DESCRIBE departments;

/* Ejemplo 09
******************************************************
Tabla DUAL

La tabla DUAL es una tabla especial de una sola columna presente de manera
predeterminada en todas las instalaciones de base de datos de Oracle. Se utiliza
para seleccionar una seudocolumna como SYSDATE o USER. La tabla tiene una 
sola columna VARCHAR2(1) LLAMADA DUMMY que tiene un valor de 'X'.

Se usa para hacer pruebas.
*/
SELECT *
FROM dual;

SELECT 1 + 1 
FROM dual;

SELECT 1
FROM dual;

SELECT SYSDATE
FROM dual;

SELECT USER
FROM dual;
