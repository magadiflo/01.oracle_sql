/***************************************************************************************************
Múltiples tablas con JOIN
****************************************************************************************************/

/* Ejemplo 01
******************************************************
Una de las formas antiguas de unir tablas sin usar JOIN es colocando las tablas 
a unir en el FROM tabla1, tabla2 y luego usar en el WHERE la condición de unión.
*/
SELECT regions.region_name, countries.country_name
FROM regions, countries
WHERE regions.region_id = countries.region_id;

SELECT e.last_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id;

/*
Actualmente se prefiere el uso del JOIN sobre la forma antigua de listado de 
tablas, por muchas razones:

1. Claridad y legibilidad de códigos.
2. Facilidad de mantenimiento.
3. Precedencia de operadores.
4. Posibilidad de utilizar diferentes tipos de JOIN.

Los JOINS son usados para recuperar datos de múltiples tablas o cuando usamos 
datosde más de una tabla.

Para producir el informe, debe vincular dos o más tablas utilizando una columna 
de datos común.

Tipos de JOIN
-------------

1° Inner Join (equijoin)
--------------------------------------
- JOIN natural corresponde a la clausula NATURAL JOIN
- JOIN con la clausula USING
- JOIN con la clausula ON
- SELF JOIN

2° Non equijoin
--------------------------------------
Es una unión cuyas condiciones de unión utilizan operadores condicionales 
distintos de igual.

3° Outer Join
--------------------------------------
- LEFT OUTER JOIN
- RIGTH OUTER JOIN
- FULL OUTER JOIN

4° Cross (Cartesian) Join
---------------------------------------
- Cross JOINS


SINTAXIS
--------
SELECT table1.column, table2.column
FROM table1
[NATURAL JOIN table2] | [JOIN table2 USING(column_name)] | 
[JOIN table2 ON (table1.column_name = table2.column_name)] |
[LEFT | RIGHT | FULL OUTER JOIN table2 ON (table1.column_name = table2.column_name)] | 
[CROSS JOIN table2]

NATURAL JOIN
--------------
- El Natural Join utilizará "AUTOMÁTICAMENTE" todas las columnas que tengan lo 
  mismo en dos tablas para recuperar los datos. 
- Si usamos Natural Join, no podemos especificar las columnas por las que se 
  unirán las tablas, sino más bien dejamos a Oracle que detecte automáticamente 
  todas las columnas que tengan el mismo nombre por el cual serán unidos.
- Selecciona filas de ambas tablas que tienen valores iguales en todas las 
  columnas coincidentes (columnas con el mismo nombre).
- Si las columnas que tienen el mismo nombre tienen diferentes tipos de datos, 
  Oracle generará un error.
*/
SELECT * 
FROM locations 
    NATURAL JOIN countries;
    
-- Mostrar los datos de los empleados que pertenecen al país de ESTADOS UNIDOS (US)
SELECT *
FROM employees 
    NATURAL JOIN countries
WHERE country_id = 'US'
ORDER BY country_name ASC, department_id;

SELECT department_id, department_name, city
FROM departments d
	NATURAL JOIN locations l
ORDER BY department_id;

SELECT department_name, city, street_address, country_name 
FROM departments d
	NATURAL JOIN locations l
	NATURAL JOIN countries c;

SELECT last_name, department_id, job_id, job_title
FROM employees e 
	NATURAL JOIN jobs j
WHERE department_id IN (10, 90, 20);

/*
JOIN con la clausula USING
--------------------------
- Si las tablas unidas contienen más de una columna coincidente y desea hacer 
  coincidir solo una columna específica, use la cláusula USING en lugar de
  NATURAL JOIN.
- La columna utilizada en la cláusula USING debe tener el mismo nombre en ambas 
  tablas.
*/

SELECT department_id, department_name, city
FROM departments d
	JOIN locations l USING(location_id)
ORDER BY department_id;

SELECT last_name, salary, department_name
FROM employees e
	JOIN departments d USING(department_id)
ORDER BY department_id;

SELECT department_name, city, street_address, country_name
FROM departments d
	JOIN locations l USING(location_id)
	JOIN countries c USING(country_id);

SELECT last_name, department_id, job_id, job_title
FROM employees e
	JOIN departments d USING(department_id)
	JOIN jobs j USING(job_id)
WHERE department_id IN(10, 90, 20);

SELECT country_id, country_name, region_name
FROM countries c
	JOIN regions r USING(region_id);
    
/*
JOIN con cláusula ON
----------------------
- Básicamente la condición del NATURAL JOIN es un EQUIJOIN para todas las 
  columnas que tengan el mismo nombre entre las dos tablas. (EQUIJOIN es el 
  operador de igualdad = )
- La cláusula ON sirve para especificar arbitrariamente condiciones o para 
  especificar las columnas del JOIN.
- La cláusula ON hace que el código sea más fácil de entender.
- La cláusula de unión ON se puede utilizar para unir tablas usando columnas 
  que tienen nombres diferentes en las tablas unidas. 

Puede haber condiciones arbitrarias, condición de coincidencia que querramos
y no necesariamente las columnas deben tener el mismo nombre o estar 
relacionadas, como por ejepmlo, e.employee_id = d.department_id, aunque el 
ejemplo no tiene sentido ya que estamos relacionando id de empleados con id 
de departamentos, estamos mostrando que con la cláusula ON es posible.
*/
SELECT *
FROM employees e
    JOIN departments d ON(e.department_id = d.department_id);

SELECT employee_id, city, department_name
FROM employees e 
    JOIN departments d ON(e.department_id = d.department_id)
    JOIN locations l ON(d.location_id = l.location_id);

SELECT e.employee_id, e.last_name, e.department_id
FROM employees e 
    JOIN departments d ON(e.department_id = d.department_id) AND e.manager_id = 149;

SELECT e.employee_id, e.last_name, e.department_id
FROM employees e
    JOIN departments d ON(e.department_id = d.department_id)
WHERE e.manager_id = 149;

SELECT d.department_id, d.department_name, l.city
FROM departments d
	JOIN locations l ON(d.location_id = l.location_id)
ORDER BY d.department_id;

SELECT e.last_name, j.job_id, j.job_title
FROM employees e
	JOIN jobs j ON(e.job_id = j.job_id)
ORDER BY j.job_id;

SELECT e.last_name, j.job_id, j.job_title
FROM employees e
	JOIN jobs j ON(e.job_id = j.job_id) AND e.department_id = 90
ORDER BY j.job_id;

SELECT e.last_name, d.department_id, d.department_name, l.city
FROM employees e
	JOIN departments d ON (e.department_id = d.department_id)
	JOIN locations l ON (d.location_id = l.location_id)
WHERE lower(l.city) = 'london';

/*
SELF JOIN
----------------------
Es una unión en la que una tabla se une consigo misma.
*/
SELECT employee.employee_id AS "employee_id", 
        employee.first_name || ' ' || employee.last_name AS "employee",
        manager.employee_id "manager_id", 
        manager.first_name || ' ' || manager.last_name AS "manager"
FROM employees manager
	JOIN employees employee ON(manager.employee_id = employee.manager_id)
ORDER BY manager.employee_id;

/*
NO EQUIJOIN
----------------------
Es una unión cuyas condiciones de unión utilizan operadores condicionales 
distintos de igual.
*/
SELECT e.last_name, j.job_title, e.salary, j.min_salary, j.max_salary
FROM employees e
    JOIN jobs j ON(e.salary BETWEEN j.min_salary AND j.max_salary);
    
/*
LEFT OUTER JOIN
----------------------
*/
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
	LEFT OUTER JOIN departments d ON(e.department_id = d.department_id);
/*
RIGHT OUTER JOIN
----------------------
*/
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
	RIGHT OUTER JOIN departments d ON(e.department_id = d.department_id);

/* FULL OUTER JOIN */
SELECT e.first_name, d.department_id, d.department_name
FROM employees e
	FULL OUTER JOIN departments d ON(e.department_id = d.department_id);
    
/*
Cross JOINS
----------------------
Es una unión de cada fila de la primera tabla con cada fila de la segunda tabla.
*/
SELECT e.last_name, e.department_id, d.department_name
FROM employees e
	CROSS JOIN departments d
ORDER BY e.department_id;
