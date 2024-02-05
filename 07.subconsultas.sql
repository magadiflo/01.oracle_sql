/***************************************************************************************************
Sub-consultas
****************************************************************************************************
La subconsulta (consulta interna) se ejecuta primero, luego la consulta principal 
(consulta externa) utiliza el resultado devuelto de la subconsulta para devolver 
el resultado final. 

Reglas
------
- Los subquerys deben estar entre paréntesis.
- Normalmente los subquerys se escriben del lado derecho de la comparación para 
  que sea más fácil de leer (sin embargo puede aparecer en cualquier lado del 
  operador de comparación).
- Usar funciones de filas únicas con subquerys que arrojen como resultado una 
  sola fila y operadores de múltiples filas con subquerys que den como resultado
  mútiples filas.
  
Tipos de SubQueries
-------------------
Subquery de fila única:
- Retorna una sola fila.
- Se utiliza esa única fila en el proceso de comparación: =, >, >=, <, =<
    
Subquery de múltiples filas:
- Retorna más de una fila.
- Se utiliza operadores de comparación para múltiples filas.
    a) IN: Igual a algún miembro de la lista.
    b) ANY: Debe ser precedido por: =, !=, >, <, <=, >=. Retorna verdadero
       si al menos existe un elemento del conjunto retornado por el 
       subquery para que la relación sea cumplida.
    c) ALL: Debe ser precedido por: =, !=, >, <, <=, >=. Retorna si la relación 
       es cierta para todos los elementos del conjutno resultante del subquery.
*/

/* Ejemplo 01
******************************************************
Consulta principal: 
-------------------
¿Qué empleados tienen el sueldo más alto que Abel?
  
Consulta interna (subconsulta)
------------------------------
Primero necesitamos saber ¿cuánto es el salario de Abel?

SINTAXIS
---------
SELECT select_list
FROM table
WHERE expr operator (SELECT select list
                    FROM table);


- El subquery (consulta interna) se ejecuta primero que el query principal 
  (consulta externa).
- El resultado del subquery es usado por el query principal.
*/
SELECT last_name, salary, job_id
FROM employees
WHERE salary > (SELECT salary
                FROM employees
                WHERE last_name = 'Abel');
                
                
/* Ejemplo 02: Subquery de fila única
******************************************************
*/
SELECT last_name, manager_id, department_id
FROM employees e
WHERE manager_id > (SELECT manager_id
				FROM employees e2
				WHERE last_name = 'Matos');
			
SELECT last_name, hire_date, department_id
FROM employees e
WHERE hire_date > (SELECT hire_date
				   FROM employees e2
				   WHERE last_name = 'Lee');
				  
SELECT e.last_name, e.salary, d.department_name
FROM employees e 
	INNER JOIN departments d ON(e.department_id = d.department_id)
WHERE salary >= (SELECT avg(salary)
				FROM employees e2);
                
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (SELECT MIN(salary)
                FROM employees);

SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (SELECT MIN(salary)
                      FROM employees
                      WHERE department_id = 50);

/* Ejemplo 02: Subquery de múltiples filas
******************************************************
*/
SELECT employee_id, last_name, salary, department_id
FROM employees e
WHERE salary IN (SELECT MIN(salary)
				FROM employees e2
				GROUP BY department_id);
			
SELECT e.employee_id, e.last_name, e.salary, e.department_id
FROM employees e
WHERE department_id IN(SELECT e2.department_id
						FROM employees e2
						WHERE e2.last_name LIKE 'J%');

SELECT e.employee_id, e.last_name, e.salary
FROM employees e
WHERE salary > ANY (SELECT e2.salary
					FROM employees e2
					WHERE department_id = 110);
                    
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary < ALL (SELECT salary
                    FROM employees
                    WHERE job_id = 'IT_PROG')
AND job_id <> 'IT_PROG';
