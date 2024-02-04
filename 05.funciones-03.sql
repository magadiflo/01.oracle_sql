/***************************************************************************************************
Funciones 03
****************************************************************************************************/

/* Ejemplo 01: AVG y SUM
******************************************************
*/
SELECT SUM(salary) 
FROM Employees;

SELECT SUM(DISTINCT salary) 
FROM Employees;

SELECT SUM(commission_pct) 
FROM employees;

SELECT AVG(salary) 
FROM employees;

SELECT AVG(DISTINCT salary) 
FROM employees;

SELECT AVG(commission_pct) 
FROM employees;

/* Ejemplo 02: MIN y MAX
******************************************************
Se puede usar con datos numéricos, caracteres y tipo de fecha:
    SELECT MIN(commission_pct) 
    FROM employees;
*/
SELECT MIN(start_date), MAX(end_date)
  FROM job_history;
  
SELECT MIN(commission_pct), MAX(commission_pct)
  FROM employees;
  
SELECT MIN(job_id), MAX(job_id)
FROM employees;

/* Ejemplo 03: COUNT
******************************************************
- COUNT(*) retorna el número de filas en una tabla
  
  SELECT COUNT(*)
  FROM employees
  WHERE department_id = 50;
  
- COUNT(expr) retorna el número de filas con valores no NULL para la expresión:

  SELECT COUNT(commission_pct)
  FROM employees
  WHERE department_id = 80;
*/

SELECT COUNT(*)
FROM employees
WHERE department_id = 50;

SELECT COUNT(commission_pct)
FROM employees
WHERE department_id = 80;

SELECT COUNT(*), COUNT(commission_pct)
FROM employees;

SELECT COUNT(*)
FROM employees
WHERE commission_pct is null;

/* Ejemplo 04: Funciones de grupo y valores NULL
******************************************************
Las funciones de grupo ignora los valores NULL en una columna:
  SELECT AVG(commission_pct)
  FROM employees;
  
La función NVL, fuerza a las funciones de grupo incluir valores NULL. Es decir,
la función NVL retorna una segunda expresión NO NULL si la primera expresión es NULL,
eso significa que la función AVG tomará en cuenta la expresión evaluada para poder
hacer el cálculo correspondiente:

  SELECT AVG(NVL(commission_pct, 0))
  FROM employees;
*/
SELECT AVG(commission_pct)
FROM employees;

SELECT AVG(NVL(commission_pct, 0))
FROM employees;


/* Ejemplo 05: Crear grupos de datos
******************************************************
Para crear grupos de datos y manipularlos, existen dos cláusulas.

  GROUP BY
  HAVING
  
  SELECT columna, group_function(columna)
  FROM table
  [WHERE condition]
  [GROUP BY group_by_expresion]
  [HAVING group_condition]
  [ORDER BY column];
  
La cláusula HAVING es la condición para la cláusula GROUP BY, así como el WHERE 
es la condición para el SELECT.

NOTA: Las funciones de grupo se pueden anidar hasta una profundidad de dos.
*/
SELECT department_id, SUM(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id;

SELECT department_id, job_id, SUM(commission_pct)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY department_id, job_id;

SELECT department_id, COUNT(*)
FROM job_history
WHERE department_id IN (50,60,80,110)
GROUP BY department_id;

SELECT department_id, COUNT(*)
FROM job_history
WHERE department_id IN (50,60,80,110)
GROUP BY department_id
HAVING COUNT(*) > 1;

SELECT job_id, SUM(salary) AS "sueldo"
FROM employees
WHERE job_id NOT LIKE '%REP%'
GROUP BY job_id
HAVING SUM(salary) > 13000
ORDER BY SUM(salary) DESC;

-- Muestra el salario máximo del promedio por department_id
SELECT MAX(AVG(salary))
FROM employees
GROUP BY department_id;

-- Muestra el salario promedio por departamento
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id;

-- Muestra el salario promedio máximo y a qué departamento le corresponde
SELECT department_id, AVG(salary)
FROM employees
GROUP BY department_id
HAVING AVG(SALARY) = (SELECT MAX(AVG(salary))
                      FROM employees
                      GROUP BY department_id);




