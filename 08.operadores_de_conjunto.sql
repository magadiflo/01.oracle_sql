/***************************************************************************************************
Operadores de conjunto
****************************************************************************************************
- Las expresiones en la lista del SELECT deben coincidir en número.
- El tipo de dato de cada columna en el segundo query debe coincidir con el 
  tipo de datos de las columnas correspondientes del primer query.
- Los paréntesis pueden ser usados para alterar la secuencia de ejecución.
- La cláusula ORDER BY puede aplicarse, y de ser así, debe estar al final de
  la última sentencia.
- El operador UNION elimina automáticamente las filas duplicadas, excepto
  con el operador UNION ALL.
- Los nombres de las columnas que aparecen en el primer query, son los 
  que aparecen en la consulta resultante.
*/

/* Ejemplo 01: Set Operators: UNION / UNION ALL 
******************************************************
UNION, retorna la unión de ambas consultas, pero elimina duplicados.
UNION ALL, retorna la unión de ambas consultas incluyendo los duplicados.
*/
SELECT employee_id, job_id
FROM employees
UNION
SELECT employee_id, job_id
FROM job_history;

SELECT employee_id, job_id, department_id
FROM employees
UNION ALL
SELECT employee_id, job_id, department_id
FROM job_history
ORDER BY employee_id;

-- Matching coincidencia de columnas
SELECT * FROM departments;
SELECT * FROM locations;

-- Como no existe el campo department_name en locations, implementamos el 
-- TO_CHAR(NULL) para igualar los campos, lo mismo ocurre con el campo state_province,
-- este campo no existe en la tabla departments, así que lo solucionamos con el 
-- TO_CHAR(NULL)
SELECT location_id, department_name "Departamento", TO_CHAR(NULL) "localización"
FROM departments
UNION
SELECT location_id, TO_CHAR(NULL) "Departamento", state_province
FROM locations;

-- Como no existe el campo salary en job_history, le colocamos 0
SELECT employee_id, job_id, salary
FROM employees
UNION
SELECT employee_id, job_id, 0
FROM job_history;

/* Ejemplo 02: Set Operators: INTERSECT / MINUS
******************************************************
INTERSECT, retorna datos comunes entre dos consultas.
MINUS, retorna datos que existen en la primera consulta pero que no existen en la segunda consulta.
*/
SELECT employee_id, job_id
FROM employees
INTERSECT
SELECT employee_id, job_id
FROM job_history;

SELECT department_id
FROM departments d
MINUS
SELECT department_id
FROM employees e
ORDER BY department_id;

SELECT l.location_id, l.city, l.street_address
FROM locations l
MINUS
SELECT d.location_id, l2.city, l2.street_address
FROM departments d 
	INNER JOIN locations l2 ON(d.location_id = l2.location_id);

/* Ejemplo 03: Cláusula ORDER BY con operaciones de conjunto
************************************************************
- La clausula ORDER BY puede aparecer solo una vez al final del query compuesto.
- Los querys que son componentes no pueden tener clausulas ORDER BY de manera 
  individual.
- La cláusula ORDER BY solo reconoce las columnas del primer query.
- Por defecto, la primera columna del primer query es usado para ordenar 
  la salida de manera ascendente.
*/
SELECT employee_id, job_id, salary
FROM employees
UNION
SELECT employee_id, job_id, 0
FROM job_history
ORDER BY 3;
