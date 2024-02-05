/***************************************************************************************************
DML: Manipulando datos
****************************************************************************************************
*/

/* Ejemplo 01: Insert
******************************************************
*/
SELECT *
FROM departments;

INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES(300, 'DBA', 100, 1700);

INSERT INTO departments(department_id, department_name)
VALUES(301, 'DEP_IT');

INSERT INTO departments
VALUES(302, 'CRE_EMP', NULL, NULL);

INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES(500, 'Delimar', 'Reyes', 'delimareyes@gmail.com', '123-123-123', SYSDATE, 'AC_ACCOUNT', 6900, NULL, 205, 110);

INSERT INTO employees
VALUES(501, 'Luis', 'Pérez', 'luis@gmail.com','123456', TO_DATE('FEB 3, 1999', 'MON DD YYYY'), 'SA_REP', 11000, 0.2, 100, 60);

-- Insertar con la sustitución de variable (PROMPT), saldrá una ventana para ingresar los datos
INSERT INTO departments(department_id, department_name, location_id)
VALUES(&department_id, '&department_name', &location);


/* Ejemplo 2: Copiando filas a otra tabla
******************************************************
Antes de continuar debemos preparar el escenario, para ello crearemos una nueva tabla.
*/
CREATE TABLE SALES_REPS(
  id          NUMBER(6),
  name        VARCHAR2(25),
  salary      NUMBER(8,2),
  commission_pct NUMBER(2,2)
);

SELECT * 
FROM sales_reps;

-- Copiando filas de otra tabla
INSERT INTO sales_reps(id, name, salary, commission_pct)
SELECT employee_id, last_name, salary, commission_pct
FROM employees
WHERE job_id LIKE '%REP%';

/* Ejemplo 03: Creando copia de una tabla
******************************************************
*/
CREATE TABLE copy_employees
AS  
SELECT *
FROM employees;

SELECT *
FROM copy_employees;

/* Ejemplo 04: Update
******************************************************
*/
UPDATE employees
SET department_id = 50
WHERE employee_id = 113;

-- ¡ATENCIÓN! esto actualizará todas las filas ya que no estamos especificando el WHERE
-- Debemos tener mucho cuidado con este tipo instrucciones.
UPDATE copy_employees
SET department_id = 110; 

UPDATE employees
SET (job_id, salary) = (SELECT job_id, salary
                          FROM employees
                          WHERE employee_id = 205)
WHERE employee_id = 103;

SELECT employee_id, job_id, salary
FROM employees
WHERE employee_id IN (103, 205);

UPDATE copy_employees
SET department_id = (SELECT department_id
                      FROM employees
                      WHERE employee_id = 100)
WHERE job_id = (SELECT job_id
                  FROM employees
                  WHERE employee_id = 200);
                  
/* Ejemplo 05: Delete
******************************************************
Elimina fila por fila.
*/
DELETE FROM departments WHERE department_name = 'CRE_EMP';

DELETE FROM copy_employees
WHERE department_id IN (SELECT department_id 
                         FROM departments
                         WHERE department_name LIKE '%Public%');

/* Ejemplo 06: Truncate
******************************************************
- Elimina todas las filas de la tabla copy_employees, de un solo barrido. 
- Mantiene la estructura de la tabla
- NOTA: Con esta función ya no se puede hacer un ROLLBACK.
*/
TRUNCATE TABLE copy_employees;

SELECT * 
FROM copy_employees;