/***************************************************************************************************
Cláusula WHERE
****************************************************************************************************
*/
/* Ejemplo 01
******************************************************
Las dos fechas siguientes son iguales en oracle: 
'05-FEB-06';
'05/02/06';
*/
SELECT last_name, job_id, department_id
FROM employees
WHERE last_name = 'Whalen';

SELECT last_name, job_id, department_id
FROM employees
WHERE hire_date = '05-FEB-06';

SELECT last_name, job_id, department_id
FROM employees
WHERE hire_date = '06-02-05';

/* Ejemplo 02
******************************************************
Operadores de comparación:
=, >, <, >=, <=, <> OR !=
BETWEEN ...AND... (valores entre e inclusive)
IN(set)
*/
SELECT *
FROM employees
WHERE salary IN (6624, 3036, 5382)
ORDER BY salary DESC;

/* Ejemplo 03
******************************************************
Operador LIKE.

Símbolos clave: 
%: permite remplazar 'n' caracteres, al final, centro, o inicio
_: Perimte reemplazar 1 solo caracter
  
El LIKE nos pemite hacer una búsqueda de patrones usando los % o los _
sin embargo, si queremos buscar precisamente esos carateres, es decir, buscar
los caracteres % o _, entonces debemos usar la cláusula ESCAPE e indicar qué
caracter de escape se usará. Por ejemplo:
    
    SELECT * FROM tabla WHERE variable LIKE '\_%' ESCAPE '\'

La anterior consulta nos mostrará aquellas filas que contengan en la columna 
variable el caracter _, es decir, que empiece con guión bajo (underscore) seguido
de cualquier otro caracter o caracteres (%).
*/
SELECT *
FROM employees
WHERE first_name LIKE 'S%';

SELECT *
FROM employees
WHERE first_name LIKE '_a%';

SELECT first_name, last_name, job_id
FROM employees
WHERE job_id LIKE 'AC\_%' ESCAPE '\';

/* Ejemplo 04
******************************************************
Condición NULL o NOT NULL
*/
SELECT *
FROM employees
WHERE manager_id IS NULL;

SELECT *
FROM employees
WHERE manager_id IS NOT NULL;

/* Ejemplo 05
******************************************************
Operadores lógicos: AND, OR, NOT
*/
SELECT *
FROM employees
WHERE job_id NOT IN('IT_PROG', 'ST_CLERK', 'SA_REP');

SELECT * 
FROM employees
WHERE salary NOT BETWEEN 10000 AND 15000;

SELECT *
FROM employees
WHERE LOWER(first_name) NOT LIKE LOWER('%A%');

/* Ejemplo 06
******************************************************
Reglas de precedencia:

1. Operadores aritméticos
2. Operadores de concatenación
3. Condiciones de comparación
4. IS [NOT] NULL, LIKE [NOT] IN
5. [NOT] BETWEEN
6. Diferente a...
7. Condición lógica NOT
8. Condición lógica AND
9. Condición lógica OR
*/
SELECT *
FROM employees
WHERE job_id = 'SA_REP' OR job_id = 'AD_PRES' AND salary > 55000;

/* Ejemplo 07
******************************************************
Cláusula ORDER BY

ASC (default)
DESC

En el siguiente ejemplo, el department_id se ordena de forma ASC y luego en 
cada grupo que se forme lo ordenar de forma DESC por el atributo salary.

Recordar que como en el department_id no pusimos la cláusula de ordenamiento,
por defecto usará el ASC.
*/
SELECT employee_id, last_name, department_id, salary
FROM employees
ORDER BY department_id, salary DESC;