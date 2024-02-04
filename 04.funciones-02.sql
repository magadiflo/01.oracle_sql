/***************************************************************************************************
Funciones 02
****************************************************************************************************/

/* Ejemplo 01: Fechas
******************************************************
TO_CHAR(date, 'format_model');

fm(fill mode): Elimina los espacios en blanco de relleno o suprime ceros a la 
izquierda
*/
SELECT employee_id, hire_date, TO_CHAR(hire_date, 'MM/YY') AS "mes/año"
FROM employees
WHERE last_name = 'Higgins';

SELECT employee_id, 
        TO_CHAR(hire_date, 'DD "de" Month "de" YYYY') -- 07 de June      de 2002
FROM employees
WHERE last_name = 'Higgins';

-- En el resultado anterior se observa un espacio generado después del mes, para
-- evitar ese espacio no agradable a la vista, podemos usar el fm (fill mode)
SELECT employee_id, 
    TO_CHAR(hire_date, 'DD "de" fmMonth "de" YYYY') -- 7 de June de 2002
FROM employees
WHERE last_name = 'Higgins';

SELECT last_name, TO_CHAR(hire_date, 'YYYY-MM-DD')
FROM employees
WHERE hire_date < TO_DATE(sysdate, 'YYYY-MM-DD');

/* Ejemplo 02: Números
******************************************************
------------------------------------------------------
ELEMENTO      DESCRIPCIÓN
------------------------------------------------------
9             Representa un número
0             Fuerza a mostrar un cero
$             Muestra el símbolo de dólar de manera flotante
L             Utiliza de manera flotante el símbolo de la moneda local
.             Imprime el punto decimal
,             Imprime una coma como indicador de mil
*/
SELECT TO_CHAR(salary, '$99,999.00'), salary
FROM employees;

SELECT TO_CHAR(salary, 'L99,999.00'), salary
FROM employees;

SELECT TO_CHAR(salary, '9999999.00'), salary
FROM employees;/*Si se le antepone el 0 a los 9s se completa con 0 a la izq*/

/* Ejemplo 03: Funciones anidadas
******************************************************
*/
SELECT last_name, UPPER(CONCAT(SUBSTR(last_name, 1, 8), '_US'))
FROM employees
WHERE department_id = 60;

SELECT TO_CHAR(ROUND((salary/7), 2), '99G999D99') AS "Salario Formateado"
FROM employees;

/* Ejemplo 04: Funciones generales
******************************************************
- La siguiente función trabaja con cualquier tipo de dato y valores NULL

A) NVL(expr1, expr2): 
  - Convierte un valor NULL en un valor actual.
  - El tipo de dato puede ser: date, caracter, number.
  - El tipo de dato debe ser el mismo.
  - Si la expr1 es NULL entonces retorna la expr2.
  Ejmp: 
      NVL(commission_pct, 0)
      NVL(hire_date, '01-JAN-97')
      NVL(job_id, 'No Job Yet')
*/
SELECT last_name, salary, commission_pct, NVL(commission_pct, 0), 
        (salary*12) + (salary*12*NVL(commission_pct, 0)) SALARIO_ANUAL
FROM employees;

/*  
B) NVL2(expr1, expr2_si_expr1_no_es_null,  expr3_si_expr1_es_null)
  - La función evalúa la primera expresión, si esta no es NULL, la función
    retorna la segunda expresión.
  - Si la expresión es NULL, la tercera expresión es retornada.
  Ejemp:
      NVL2(expr1, expr2, expr3)
      NVL2(commission_pct, 'SAL+COMM', 'SAL')
      */
SELECT last_name, salary, commission_pct, 
        NVL2(commission_pct, 'SAL+COM', 'SALARIO') AS "Entrada"
FROM employees;
/*
C) NULLIF(expr1, expr2)
   - La función se encarga de evaluar 2 expresiones, si son iguales retorna NULL, 
     de lo contrario, mostrará la primera expresión:
    NULLIF(expr1, expr2)
    NULLIF(LENGTH(first_name), LENGTH(last_name))
*/
SELECT first_name, LENGTH(first_name) "EXPR1",
        last_name, LENGTH(last_name) "EXPR2",
        NULLIF(LENGTH(first_name), LENGTH(last_name)) "RESULTADO"
FROM employees;

/*
D) COALESCE (expr1, expr2, ...., exprn)
  - La ventaja de esta función con respecto a la NVL es que puede tomar
    múltiples valores.
  - La función devuelve el primer valor no NULL, que se encuentre en la lista.
    La expr1 es retornada si no es NULL; la expr2 es retornada si la expr1 es NULL
    y esta no lo es.
  - Todas las expresiones deben ser del mismo tipo de dato.
  Ejmp:
    COALESCE(expr1, expr2, ...., exprn);
    */
SELECT last_name, employee_id, commission_pct,manager_id, 
        COALESCE(TO_CHAR(commission_pct), TO_CHAR(manager_id), 
        'No tiene comisión ni manager') AS "Coalesce"
FROM employees;

/* Ejemplo 05: Expresiones condicionales
******************************************************
Expresión CASE:

CASE expresion 
    WHEN comparison_expr1 THEN return expr1
    WHEN comparison_expr2 THEN return expr2
    ELSE else_expr
END
*/

SELECT last_name, job_id, salary,
    CASE job_id 
        WHEN 'IT_PROG'  THEN 1.10 * salary
        WHEN 'ST_CLERK' THEN 1.15 * salary
        WHEN 'SA_REP'   THEN 1.20 * salary
        ELSE salary
    END AS "Salario Revisado"
FROM employees;

/* Expresión DECODE
------------------------
- Facilita las condiciones dentro de los querys, haciendo el trabajo del CASE
  o IF-THEN-ELSE. Veamos el esquema general:
  
    DECODE(col/expression, search1, result1, search2, result2, ....., default)

- Es similar al CASE
*/
SELECT last_name, job_id, salary,
DECODE(job_id, 
  'IT_PROG', 1.10*salary,
  'ST_CLERK',1.15*salary,
  'SA_REP', 1.20*salary, 
  salary) AS "Salario Revisado"
FROM employees;
