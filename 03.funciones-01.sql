/***************************************************************************************************
Funciones 01
****************************************************************************************************/

/* Ejemplo 01
******************************************************
Funci�n INSTR

- Devuelve la posici�n de la en�sima aparicion de char2 en Char1 buscando a partir 
  de la posicion n.
- Si n es negativo, cuenta la posicion de arranque desde el final.
- Por defecto n y m valen 1.
- n, desde d�nde empezar� a buscar.
- m, represente el n�mero de coincidencia que se quiere obtener, es decir, si 
  mi m = 3 significa que el valor del �ncide a devolver ser� el de la tercera 
  coincidencia.

INSTR(char1, char2 [,n [,m]])
*/
SELECT INSTR('Mart�n D�az', 't�n')
FROM dual;

SELECT INSTR('uno dos uno', 'uno', 5) 
FROM dual;

SELECT INSTR('How_long_is_a_piece_of_string?','_',5,3) 
FROM dual; 

/* Ejemplo 02
******************************************************
Funciones de conversi�n:
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
Funciones de manipulaci�n:

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

SELECT SUBSTR('programaci�n', 2,5)
FROM dual;

SELECT SUBSTR('programaci�n', 3)
FROM dual;

SELECT LENGTH('programaci�n')
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
Funciones num�ricas:

ROUND(45.926, 2) = 45.93, redondea el valor a un decimal espec�fico
TRUNC(45.926, 2) = 45.92, trunca el valor a un decimal espec�fico
MOD(1600,300)    = 100,   retorna el residuo de una divisi�n
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

- Oracle almacena las fechas en un formato num�rico interno: siglo, a�o, mes, 
  d�a, horas, minutos y segundos.
- El formato por defecto es DD-MON-RR:
    * Permite almacenar fechas del siglo 21 en el siglo 20 solo especificando los 
      �ltimos d�gitos del a�o.
    * Permite almacenar fechas del siglo 20 en el siglo 21 de la misma manera.
    
Funci�n SYSDATE

Retorna fecha y hora actual del sistema.
*/
-- Fecha actual del sistema
SELECT SYSDATE 
FROM dual;

-- Suma 7 d�as a la fecha
SELECT SYSDATE + 7 
FROM dual;

-- Resta 4 d�as a la fecha
SELECT SYSDATE - 4
FROM dual; 

SELECT last_name, (SYSDATE - hire_date)/7 AS "SEMANAS"
FROM employees;

/* Ejemplo 06
******************************************************
Funciones de manipulaci�n de fechas

MONTHS_BETWEEN: Retorna el n�mero de meses entre las fechas enviadas como argumento.
ADD_MONTHS:     Suma or esta a una fecha, un n�mero de n meses.
NEXT_DAY:       Devuelve una fecha correspondiente al primer d�a espec�fico en "d�a"
                despu�s de la fecha especificada.
LAST_DAY:       Devuelve la fecha del �ltimo d�a del mes que contiene fecha.
ROUND:          Cuando no se especifica ning�n formato, devuelve la fecha del primer
                d�a del mes contenido en fecha. Si m�scara = YEAR, encuentra el primer
                d�a del a�o.
TRUNC:          Devuelve la fecha con la porci�n del d�a truncado en la unidad
                especificada por el modelo de formato fmt. Si se omite el formato, 
                la fecha se trunca en el d�a m�s pr�ximo.
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