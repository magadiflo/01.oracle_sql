/***************************************************************************************************
Funciones 01
****************************************************************************************************/

/* Ejemplo 01
******************************************************
Función INSTR

- Devuelve la posición de la enésima aparicion de char2 en Char1 buscando a partir 
  de la posicion n.
- Si n es negativo, cuenta la posicion de arranque desde el final.
- Por defecto n y m valen 1.
- n, desde dónde empezará a buscar.
- m, represente el número de coincidencia que se quiere obtener, es decir, si 
  mi m = 3 significa que el valor del íncide a devolver será el de la tercera 
  coincidencia.

INSTR(char1, char2 [,n [,m]])
*/
SELECT INSTR('Martín Díaz', 'tín')
FROM dual;

SELECT INSTR('uno dos uno', 'uno', 5) 
FROM dual;

SELECT INSTR('How_long_is_a_piece_of_string?','_',5,3) 
FROM dual; 

/* Ejemplo 02
******************************************************
Funciones de conversión:
LOWER
UPPER
INITCAP
*/

SELECT LOWER('Curso SQL') FROM DUAL;
SELECT UPPER('Curso SQL') FROM DUAL;
SELECT INITCAP('Curso SQL') FROM DUAL;

SELECT * 
FROM employees
WHERE LOWER(last_name) = LOWER('HIGGINS');

SELECT *
FROM employees
WHERE last_name = INITCAP('higgins');

/* Ejemplo 03
******************************************************
Funciones de manipulación:

CONCAT 
SUBSTR
LENGTH
INSTR
LPAD | RPAD
TRIM
REPLACE
*/
SELECT CONCAT('Bienvenidos', ' Oracle')
FROM dual;

SELECT 'Bienvenidos' || ' Oracle'
FROM dual;

SELECT SUBSTR('programación', 2,5)
FROM dual;

SELECT SUBSTR('programación', 3)
FROM dual;

SELECT LENGTH('programación')
FROM dual;

SELECT LPAD(salary, 10, '.')
FROM employees;

SELECT RPAD(salary, 10, '*')
FROM employees;

SELECT REPLACE('jack and jue', 'j', 'bl')
FROM dual;

SELECT TRIM(' ORACLE ')
FROM dual;

SELECT employee_id, CONCAT(first_name, ' ' || last_name) name, job_id, INSTR(last_name, 'a')
FROM employees
WHERE SUBSTR(job_id, 4) = 'REP';

/* Ejemplo 04
******************************************************
Funciones numéricas:

ROUND(45.926, 2) = 45.93, redondea el valor a un decimal específico
TRUNC(45.926, 2) = 45.92, trunca el valor a un decimal específico
MOD(1600,300)    = 100,   retorna el residuo de una división
*/
SELECT ROUND(45.923,2), ROUND(45.993,0), ROUND (45.923, -1) 
FROM dual;

SELECT TRUNC(45.923, 2), TRUNC(45.993, 0), TRUNC(45.923, -1) 
FROM dual;

SELECT last_name, salary, MOD(salary, 5000)
FROM employees;

/* Ejemplo 05
******************************************************
Fechas:

- Oracle almacena las fechas en un formato numérico interno: siglo, año, mes, 
  día, horas, minutos y segundos.
- El formato por defecto es DD-MON-RR:
    * Permite almacenar fechas del siglo 21 en el siglo 20 solo especificando los 
      últimos dígitos del año.
    * Permite almacenar fechas del siglo 20 en el siglo 21 de la misma manera.
    
Función SYSDATE

Retorna fecha y hora actual del sistema.
*/
-- Fecha actual del sistema
SELECT SYSDATE 
FROM dual;

-- Suma 7 días a la fecha
SELECT SYSDATE + 7 
FROM dual;

-- Resta 4 días a la fecha
SELECT SYSDATE - 4
FROM dual; 

SELECT last_name, (SYSDATE - hire_date)/7 AS "SEMANAS"
FROM employees;

/* Ejemplo 06
******************************************************
Funciones de manipulación de fechas

MONTHS_BETWEEN: Retorna el número de meses entre las fechas enviadas como argumento.
ADD_MONTHS:     Suma or esta a una fecha, un número de n meses.
NEXT_DAY:       Devuelve una fecha correspondiente al primer día específico en "día"
                después de la fecha especificada.
LAST_DAY:       Devuelve la fecha del último día del mes que contiene fecha.
ROUND:          Cuando no se especifica ningún formato, devuelve la fecha del primer
                día del mes contenido en fecha. Si máscara = YEAR, encuentra el primer
                día del año.
TRUNC:          Devuelve la fecha con la porción del día truncado en la unidad
                especificada por el modelo de formato fmt. Si se omite el formato, 
                la fecha se trunca en el día más próximo.
*/

SELECT MONTHS_BETWEEN(SYSDATE, hire_date)
FROM employees;

SELECT ADD_MONTHS(SYSDATE, 3)
FROM dual;

SELECT NEXT_DAY('2024-02-05', 'MONDAY')
FROM dual;

SELECT LAST_DAY('2024-02-05')
FROM dual;

SELECT employee_id, hire_date, ROUND(hire_date, 'MONTH'), TRUNC(hire_date, 'MONTH')
FROM employees
WHERE hire_date LIKE '%07';