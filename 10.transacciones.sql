/***************************************************************************************************
Transacciones de base de datos
****************************************************************************************************
Una transacción de base de datos consiste en lo siguiente:

- Las sentencias DML(Data Manipulation Languaje) consiste en un cambio sobre los 
  datos.
- Una sentencia DDL(Data Definition Languaje).
- Una sentencia DCL(Data Control Languaje).

Características de una transacción:

- ATÓMICA: Debe ser ejecutada completamente o no ejecutada.
- CONSISTENCIA: 
    * Si inserto un número, debe ir a un campo numérico. Si inserto un caracter 
      a un tipo de dato caracter, etc.
    * No puedo insertar datos donde me pidan una clave foránea y no exista dicha 
      clave como principal en otra tabla.
- AISLAMIENTO: Una transacción no tiene que ver con la otra.
- DURABLE: La transacción debe ser durable en el tiempo.

Inicio y fin de una transacción de BD:

- Comienza cuando la primera sentencia DML es ejecutada.
- Finaliza con uno de los siguientes eventos: 
  * Un COMMIT o ROLLBACK es usado.
  * Una sentencia DDL o DCL es ejecutado(un commit automático).
  * La desconexión de un usuario de SQL Developer o SQL Plus.
  * Una falla en el sistema.
  
Con el COMMIT y ROLLBACK se puede:

- Asegurar la consistencia de los datos.
- Preveer los cambios en los datos antes de hacerlos permanentes.
- Agrupar operaciones de forma lógica.
- COMMIT: Finaliza la transacción actual, haciendo permanente todos los cambios pendientes.
- SAVEPOINT nombre_del_point : Realiza una marca de salvado en la transacción actual.
- ROLLBACK: Termina la transacción actual descartando todos los cambios pendientes.
- ROLBACK TO SAVEPOINT: Devuelve los cambios en la transacción actual según el punto
  salvado especificado, el cual fue creado con sentencia SAVEPOINT.
  
Estado de los datos antes del COMMIT o ROLLBACK:

- El estado previo de los datos puede ser recuperado.
- El usuario actual puede revisar el resultado de una sentencia DML usando la 
  sentencia SELECT.
- Otros usuarios no pueden ver los resultados de la sentencia DML emitido por el
  usuario actual.
- Las filas afectadas están bloqueadas, otros usuarios no pueden cambiar los 
  datos en las filas afectadas.
  
Estado de los datos luego del COMMIT:

- Los cambios de los datos son guardados en la base de datos.
- El estado previo de los datos es sobre escrito.
- Todos los usuarios pueden ver los resultados.
- Las filas bloqueadas son liberadas, estas filas están disponibles para 
  que el resto de los usuarios puedan manipularlos.
- Todos los SAVEPOINT son borrados.

Estado de los datos luego del ROLLBACK:

- Descarta todos los cambios pendientes usando la sentencia ROLLBACK.
- Los cambios sobre los datos se descarta.
- El estado previo de los datos es restaurado.
- El bloqueo de las filas afectadas es liberado.
*/

/* Ejemplo 01
******************************************************
Eliminamos toda la tabla job_history, verificamos con el select que se han
eliminado y luego ejecutamos ROLLBACK para restaurar los datos.
*/
SELECT * FROM job_history;

DELETE FROM job_history;

ROLLBACK;

/* Ejemplo 02
******************************************************
Insertamos un valor al departamento, verificamos el valor insertado y luego 
podemos seleccionar una de las siguientes dos acciones:

ROLLBACK: deshacer la inserción.
COMMIT: confirmar la inserción.
*/
INSERT INTO departments
VALUES(700,'Almacen', 100, 1700);

SELECT * FROM departments;

ROLLBACK;

COMMIT;

/* Ejemplo 03
******************************************************
Cada vez que realizamos la ejecución de una transacción, usaremos a continuación
un SAVEPOINT para guardar la operación realizada hasta ese punto, en nuestro
caso guardaremos dos SAVEPOINT. A continuación, posterior al SAVEPOINT 2, realizamos
otra operación de inserción, pero ahí mismo decidimos que es mejor regresar al 
primer SAVEPOINT almacenado, así que hacemos un ROLLBACK TO trans_1.

El siguiente ejemplo muestra la secuencia:
*/
SELECT * FROM sales_reps;

INSERT INTO sales_reps
VALUES(1, 'A', 100,0);

SAVEPOINT trans_1;

INSERT INTO sales_reps
VALUES(2, 'B', 200,0.5);

SAVEPOINT trans_2;

INSERT INTO sales_reps
VALUES(3, 'B', 300, NULL);

ROLLBACK TO trans_1;

/* Ejemplo 04
******************************************************
*/
-- No se puede hacer un ROLLBACK a un TRUNCATE
TRUNCATE TABLE sales_reps; 

-- Sí se puede hacer un ROLLBACK a un DELETE
DELETE FROM sales_reps;
ROLLBACK;