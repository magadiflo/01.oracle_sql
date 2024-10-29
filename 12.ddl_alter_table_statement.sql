/*
ALTER TABLE Statement
---------------------
https://www.techonthenet.com/oracle/tables/alter_table.php

En este tutorial de Oracle se explica cómo utilizar la instrucción 
ALTER TABLE de Oracle para:
- Agregar una columna
- Modificar una columna
- Eliminar una columna
- Cambiar el nombre de una columna
- Cambiar el nombre de una tabla

La instrucción ALTER TABLE de Oracle se utiliza para agregar, modificar o 
eliminar/eliminar columnas de una tabla. La instrucción ALTER TABLE de Oracle
también se utiliza para cambiar el nombre de una tabla.
*/

/* Crea tabla customers
*******************************************************************************
*/
CREATE TABLE customers(
    id NUMBER(6) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100), 
    phone VARCHAR2(15),
    CONSTRAINT pk_customers PRIMARY KEY(id)
);

/* SINTAXIS: agregar columna en la tabla customers
*******************************************************************************
ALTER TABLE table_name
  ADD column_name column_definition;
*/

/* Ejemplo 01
*******************************************************************************
En el siguiente ejemplo agregamos la columna create_at del tipo DATE a 
la tabla customers.
*/
ALTER TABLE customers
ADD create_at DATE;


/* Ejemplo 02
*******************************************************************************
Agregamos una nueva columna a la tabla customers con un valor por defecto
*/
ALTER TABLE customers
ADD status VARCHAR2(15) DEFAULT 'ACTIVO';

/* SINTAXIS: agregar múltiples columnas a una tabla existente
*******************************************************************************
Para agregar múltiples columnas a una tabla existente, la sintaxis de oracle
sería el siguiente.

ALTER TABLE table_name
  ADD (column_1 column_definition,
       column_2 column_definition,
       ...
       column_n column_definition);
*/

/* Ejemplo 03
*******************************************************************************
Para este ejemplo vamos a eliminar la tabla customers para y la volveremos a
crear sin las columnas create_at y status. Luego, usando la sintáxis para
agregar múltiples columnas las volveremos a agregar.
*/
DROP TABLE customers;

CREATE TABLE customers(
    id NUMBER(6) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100), 
    phone VARCHAR2(15),
    CONSTRAINT pk_customers PRIMARY KEY(id)
);

ALTER TABLE customers
ADD (create_at DATE,
    status VARCHAR2(15) DEFAULT 'ACTIVO');
    
SELECT *
FROM customers;
    
    
/* SINTAXIS: modificar columna en la tabla
*******************************************************************************
Para modificar una columna en tabla existente, la sintaxis de oracle
sería el siguiente.

ALTER TABLE table_name
  MODIFY column_name column_type;
*/

/* Ejemplo 04
*******************************************************************************
En el siguiente ejemplo estamos modificando la columna email para que sea
del tipo VARCHAR2(100), no acepte nulos y cuyo valor debe ser único.
*/
ALTER TABLE customers
MODIFY email VARCHAR2(100) NOT NULL CONSTRAINT uq_email UNIQUE;

/* SINTAXIS: modifica múltiples columnes de una tabla
*******************************************************************************
Para modificar múltiples columnas de una tabla, la sintaxis de oracle
sería el siguiente.

ALTER TABLE table_name
  MODIFY (column_1 column_type,
          column_2 column_type,
          ...
          column_n column_type);
*/

/* SINTAXIS: eliminar una columna de una tabla
*******************************************************************************
Para eliminar una columna de una tabla, la sintaxis de oracle sería el 
siguiente.

ALTER TABLE table_name
  DROP COLUMN column_name;
  
*/

/* Ejemplo 05
*******************************************************************************
En el siguiente ejemplo eliminaremos la columna status de nuestra tabla
customers
*/
ALTER TABLE customers
DROP COLUMN status;

SELECT * 
FROM customers;

/* SINTAXIS: cambiar el nombre de la columna en la tabla
(NUEVO en Oracle 9i versión 2)
*******************************************************************************
A partir de Oracle 9i Release 2, ahora puede cambiar el nombre de una columna.
Para RENOMBRAR UNA COLUMNA en una tabla existente, la sintaxis de ALTER TABLE 
de Oracle es:

ALTER TABLE table_name
  RENAME COLUMN old_name TO new_name;
  
*/

/* Ejemplo 06
*******************************************************************************
Cambia el nombre de la columna phone por phone_number de nuestra tabla 
customers.
*/
ALTER TABLE customers
RENAME COLUMN phone TO phone_number;

SELECT *
FROM customers;

/* SINTAXIS: cambia el nombre de la tabla
*******************************************************************************
Para cambiar el nombre de una tabla usamos la siguiente sintaxis en oracle.

ALTER TABLE table_name
  RENAME TO new_table_name;
*/

/* Ejemplo 07
*******************************************************************************
Cambia el nombre de una tabla en oracle de customers a contacts.
*/
ALTER TABLE customers
RENAME TO contacts;

SELECT *
FROM contacts;

DROP TABLE contacts;