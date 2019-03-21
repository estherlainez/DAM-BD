# Programación de bases de datos.

##Introducción. Lenguaje de programación.


Las bases de datos han servido como repositorios de datos organizados según una serie de relaciones en tablas. Para acceder a los datos se han utilizado interfaces de lenguajes de programación, algunos de los cuales permiten la inclusión de sentencias SQL como parte de la aplicación. Son lo que se denomina lenguajes anfitriones, como C o Java.

Además, los propios DBMS incorporan lenguajes propios para facilitar el acceso a los datos. No hay un estándar que aglutine a todos los DBMS, sino que hay varios:

* Oracle: [PL/SQL](http://www.mundoracle.com/pl-sql.html?Pg=sql_plsql_11.htm) Permite programar objetos de la base de datos.

* MySQL: Lenguaje de programación de MySQL (no tiene un nombre específico). Permite definir triggers, rutinas, eventos y vistas.

* SQL Server: Se denomina T-SQL (la T es por transaccional) y permite la programación de rutinas, triggers y otros objetos.

* PostgreSQL: Mediante módulos permite la compilación de varios lenguajes, aunque el más común es el denominado PL/PGSQL. 

Cada vez hay una integración más profunda de los conceptos de la orientación a objetos en el manejo de las bases de datos relacionales, enfocado en el uso de tipos avanzados de datos (objetos, arrays, etc.), así como otros conceptos de la programación tales como la herencia.

## MySQL

* En MySQL el soporte a rutinas (procedimientos y funciones) comenzó en la versión 5.

### Procedimientos y funciones almacenados.

Un procedimiento almacenado es un conjunto de instrucciones en lenguaje SQL que realizan una tarea determinada. Algo similar a una función en cualquier otro lenguaje de programación.

Por lo general se usa un procedimiento almacenado cuando la tarea es laboriosa y se ha de llevar a cabo con cierta asiduidad o se tendría que hacer desde el sitio de destino de los datos.

La ventaja principal de utilizar procedimientos almacenados es que se libera cualquier tarea pesada que podría tener nuestra aplicación, aunque se debe tener en cuenta y hacerlo en circunstancias necesarias ya que crear de forma excesiva procedimientos almacenados, puede ser una mala práctica ya que se puede tener a futuro problemas en cuanto a la organización del código entre otras cosas.

```sql
CREATE PROCEDURE `nombre` ([parameter[,...]])
BEGIN
    //instrucciones
END
```

Los parámetros indican la entrada y salida de datos que podríamos usar para el procedimiento y la salida de datos que devolvería el procedimiento almacenado.

Vemos un ejemplo para contar los clientes que tiene asignados un representante de ventas:

```sql
CREATE PROCEDURE `contar_clientes_comercial` (IN codigo INT,
  OUT nclientes INT)
BEGIN
SELECT
  COUNT(*)
INTO
  nclientes
FROM
  from clientes
WHERE
  codigoEmpleadoRepVentas=codigo;
END
```


Para ejecutar el procedimiento hay que llamarlo, como a cualquier función en otro lenguaje:

```sql
-- 5,6,8,9,10,12... son representantes de ventas
CALL contar_clientes_comercial(5, @numClientesAsignados);
select  @numClientesAsignados;
```


## PL/SQL
### Conceptos básicos

Como introducción vamos a ver algunos elementos y conceptos básicos del lenguaje. PL/SQL es CASE-INSENSITIVE, es decir, no diferencia mayúsculas de minúsculas. Por el contrario, hay que tener en cuenta que Oracle es CASE-SENSITIVE en las búsquedas de texto.

Una línea en PL/SQL contiene grupos de caracteres, conocidos como UNIDADES LÉXICAS, que pueden ser clasificadas como: 

* DELIMITADOR: Es un símbolo, simple o compuesto, que tiene una función especial en PL/SQL:
	* Operadores Aritméticos
	* Operadores Lógicos
	* Operadores Relacionales

* IDENTIFICADOR: Son empleados para nombrar objetos de programas en PL/SQL, así como a unidades dentro del mismo: 
	* Constantes
	* Cursores
	* Variables
	* Subprogramas
	* Excepciones
	* Paquetes

* LITERAL: Es un valor de tipo numérico, carácter, cadena o lógico no representado por un identificador (es un valor explícito).

* COMENTARIO: Es una aclaración que el programador incluye en el código. Son soportados dos estilos de comentarios, el de línea simple y de multilínea, para lo cual son empleados ciertos caracteres especiales.


### Variables del sistema y variables de usuario.

Tipos de datos
Cada constante y variable tiene un tipo de dato en el que se especifica el formato de almacenamiento, restricciones y rango de valores válidos. PL/SQL proporciona una variedad predefinida de tipos de datos. Casi todos los tipos de datos manejados por PL/SQL son similares a los soportados por SQL. A continuación se muestran los tipos de datos más comunes:
NUMBER (numérico): Almacena números enteros o de punto flotante, virtualmente de cualquier longitud, aunque puede ser especificada la precisión (número de dígitos) y la escala, que es la que determina el número de decimales.

CHAR (carácter): Almacena datos de tipo carácter con un tamaño máximo de 32.767 bytes y cuyo valor de longitud por defecto es 1.

VARCHAR2 (carácter de longitud variable): Almacena datos de tipo carácter empleando sólo la cantidad necesaria aún cuando la longitud máxima sea mayor.

BOOLEAN (lógico): Se emplea para almacenar valores TRUE o FALSE.

DATE (fecha): Almacena datos de tipo fecha. Las fechas se almacenan internamente como datos numéricos, por lo que es posible realizar operaciones aritméticas con ellas.

Atributos de tipo. Un atributo de tipo PL/SQL es un modificador que puede ser usado para obtener información de un objeto de la base de datos. El atributo %TYPE permite conocer el tipo de una variable, constante o campo de la base de datos. El atributo %ROWTYPE permite obtener los tipos de todos los campos de una tabla de la base de datos, de una vista o de un cursor.

### Funciones.

### Estructuras de control de flujo. Alternativas. Bucles.

### Herramientas para creación de guiones; procedimientos de ejecución.

### Procedimientos almacenados. Funciones de usuario.

### Subrutinas. Variables locales y globales.

### Eventos y disparadores.

### Excepciones. Tratamiento de excepciones.

### Cursores. Funciones de tratamiento de cursores.

### APIS para lenguajes externos.
