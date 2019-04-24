# Programación de bases de datos.

## Introducción. Lenguaje de programación.


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

```sql
-- Lo habitual para separar una instrucción de otra, es finalizarlas con un “;” pero un Stored Procedure, al igual que un Trigger, estan formados por varias instrucciones, por lo tanto, antes de comenzar su definición, se debe especificar qué caracter delimita (o separa) un Stored Procedure o un Trigger del siguiente Stored Procedure o Trigger.
DELIMITER $$

-- Nombre rutina + parámetros (entrada, salida o e/s)
CREATE PROCEDURE nbProcedure([IN param1, OUT param2, INOUT param3])

-- Declaración e inicialización de variables

DECLARE nombreVariable tipoVariable;

BEGIN
	--Proceso de datos
	-- RETURN si hay que devolver algo (función)
END $$

DELIMITER;
```

Los parámetros indican la entrada y salida de datos que podríamos usar para el procedimiento y la salida de datos que devolvería el procedimiento almacenado.


Vemos un ejemplo para contar los clientes que tiene asignados un representante de ventas:

```sql
DELIMITER $$

CREATE PROCEDURE `contar_clientes_comercial` (IN codigo INT,
  OUT nclientes INT)
BEGIN
SELECT
  COUNT(*)
INTO
  nclientes
FROM
  clientes
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

```sql
DELIMITER $$
CREATE PROCEDURE hoy()
LANGUAGE SQL 
DETERMINISTIC ## El algoritmo siempre da el mismo resultado con una entrada determinada
COMMENT 'Un ejemplo de procedure'
SELECT CURRENT_DATE FROM t $$
```

Ejemplo de función que recibe un argumento de estado como entrada y devuelve una cadena en función del valor de entrada.
Es posible llamar a las funciones con su nombre y una lista de parámetros con el tipo de dato adecuado.

```sql
## Funciona en la BD test
DELIMITER $$ 
CREATE FUNCTION status_actual(in_status CHAR(1))
	RETURNS VARCHAR(20)
BEGIN
	DECLARE status VARCHAR(20);

	IF in_status = 'P' THEN 
		SET status = 'pasado';
	ELSEIF in_status = 'O' THEN
		SET status = 'presente';
	ELSEIF in_status = 'N' THEN
		SET status = 'futuro';
	END IF;
	RETURN(status);
	END $$
```

Ejemplos de llamadas a las funciones.

```sql
SET @cad = status_actual('P');

select status_actual('O');
```

Aún así, lo más frecuente es llamar a las funciones desde otras funciones o procedimientos tal como se ha hecho en las consultas cuando se han utilizado funciones de resumen, concatenación, etc. Así las cosas, es fácil comprender que el uso de funciones puede reducir la complejidad del código dividiéndolo en módulos y haciendo más sencillo el mantenimiento.

### Variables y parámetros

De forma similar a otros lenguajes, se utilizan variables y parámetros en el código.

* ```DECLARE``` crea una _variable_ con su nombre y [tipo de dato](https://www.anerbarrena.com/tipos-dato-mysql-5024/). Además, se puede incluir un valor por defecto en las variables, que será *NULL* si no se indica.
	* ```DECLARE x,y INT DEFAULT 3;```
* ```SET``` para asignar valores a las variables mediante el operador de asignación ```=```.
* ```ÌN``` es el modo de parámetro por defecto, el procedimiento puede modificar el valor, pero la modificación no es visible desde fuera cuando el procedimiento finaliza.
*  ```ÒUT``` Su valor inicial es NULL dentro del procedimiento, y su valor es visible desde fuera cuando la función acaba.
* ```INOUT``` Para pasar valores que serán modificados y devueltos. Es inicializado cuando se llama a la función, puede ser modificado dentro y cualquier cambio realizado en él es visible cuando el procedimiento finaliza.


El alcance de las variables está determinado por el bloque BEGIN-END en el que se encuentran. Por tanto, no se puede ver una variable que se encuentra fuera de un procedimiento salvo que se le asigne a un parámetro de salida (OUT) o a una variable de sesión (precedida de @). 


### Estructuras de control

#### IF-THEN-ELSE
Es posible incluir instrucciones condicionales mediante el uso de IF como por ejemplo en la función ```status_actual()``` vista anteriormente

```sql
IF expression THEN
   sentencias;
ELSEIF elseif-expression THEN
   elseif-sentencias;
...
ELSE
   else-sentencias;
END IF;
```

#### CASE
Cuando se dan varias condiciones, el if-else puede resultar tedioso. Para estas situaciones puede ser más útil emplear la estructura CASE, que se asemeja a un switch de otros lenguajes. Evalúa la expresión y procede según el valor que tome. Si no es ninguno de los expresados en los ```WHEN``` se toma el del ```ELSE```.

```sql
CASE  case_expression
   WHEN valor_1 THEN commands
   WHEN valor_2 THEN commands
   ...
   ELSE commands
END CASE;
```

### Bucles

De forma similar a otros lenguajes, permiten iterar un conjunto de instrucciones un número determinado de veces, mientras se cumpla una determinada condición.

#### LOOP

```sql
[etiqueta:] LOOP
	sentencias
END LOOP
[etiqueta]; -- la etiqueta permite designar un nombre para el bucle y referirse a él en el código
```

```sql
-- Crea una cadena de números pares mientras que x sea menor que 10
-- Observar la referencia a la etiqueta dentro del loop
etiqueta_loop:  LOOP
	 IF  x > 10 THEN 
	 	LEAVE  loop_label; #La palabra Leave indica que se ha cumplido la condición de salida del bucle.
	 END  IF;
	            
	 SET  x = x + 1;
	 IF  (x mod 2) THEN
	 	ITERATE  etiqueta_loop;
	 ELSE
	   SET  str = CONCAT(str,x,',');
	 END  IF;
 END LOOP;    
```

#### REPEAT UNTIL LOOP
Repite la condición hasta que se cumpla una determinada expresión, es similar al anterior.

```sql
[etiqueta:] REPEAT
 sentencias;
UNTIL expresion
END REPEAT
```

```sql
-- Construye una cadena con los números menores que 6
REPEAT
	 SET  str = CONCAT(str,x,',');
	 SET  x = x + 1; 
	        UNTIL x  > 5
END REPEAT;
```


#### WHILE DO
Igual que el anterior pero usando la palabra WHILE

```SQL
[etiqueta:] WHILE expresion DO
	instrucciones
END WHILE [etiqueta]
```


### Cursores

Lo habitual en la programación de bases de datos es manejar datos con origen o destino en dicha base de datos mediante sentencias SQL.

En el lenguaje SQL existen unos tipos de controles que son útiles para recorrer los registros que devuelve una consulta. Este tipo de estructuras sólo deben utilizarse cuando no haya otra forma de manipular conjuntos de datos en una sola instrucción.


Ejemplo de CURSOR

```sql
-- DECLARE nombre_cursor CURSOR FOR sentencia_select;

DECLARE cursor1 CURSOR FOR
SELECT nombreCliente, ciudad, telefono from clientes;


-- Si se usa en un procedimiento, hay que declararlo después de todas las variables que se usen.
```

Otro ejemplo de cursor que va modificando una tabla según las condiciones en cada fila

```sql
DELIMITER $$
DROP PROCEDURE IF EXISTS `micursor`$$
CREATE PROCEDURE `micursor`()
BEGIN
DECLARE finalizado BOOLEAN DEFAULT FALSE;
DECLARE identificador integer;
DECLARE cita integer;

DECLARE c1 cursor for SELECT id,timestamp from tabla_empleados ORDER BY id ASC;

-- Esta línea sirve para controlar lo que sucede al llegar a la última fila del cursor, 'sqlstate = 02000'
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET finalizado = TRUE;
-- También se suele poner HANDLER FOR NOT FOUND cuando se llega al final de los resultados.

open c1; -- OPEN INICIALIZA el conjunto de resultados asociados al cursor
	c1_loop: LOOP
	fetch c1 into identificador,cita; -- FETCH recupera la siguiente fila de valores del conjunto de resultados
	        IF `finalizado` THEN LEAVE c1_loop; END IF; 
	        UPDATE calendar SET timestamp = cita  WHERE id=identificador;
	END LOOP c1_loop;
CLOSE c1; -- CLOSE cierra el cursor, libera la memoria que está ocupando y desbloquea el acceso a los datos.

END $$
```

Este cursor se podría realizar con una única instrucción UPDATE, pero sirve para ver cómo se declara en la sintaxis de MySQL.

Básicamente se declaran dos variables identificador y cita que contendrán el valor de cada campo de la fila. Luego se define el cursor mediante una consulta SQL (es como si se creara una tabla temporal). Finalmente, se recorre el cursor y se aplica la operación adecuada según nuestro programa.

Para ejecutar el cursor se puede hacer mediante ```call nb_cursor()```

En el ejemplo anterior se ha implementado el cursor con un bucle ```LOOP``` pero puede hacerse con cualquiera de los vistos, de hecho lo más habitual es utilizar ```WHILE``` porque se evalúa la condición antes de ejecutar las sentencias (leer un registro del cursor).


### Gestión de errores

Cuando se da un error en un procedimiento almacenado, por defecto se detiene la ejecución del mismo y se devuelve un error. Sin embargo, puede ocurrir que se desee modificar este comportamiento y manejar el error de otra forma, como informar del error en el log y continuar la ejecución del programa. Para estos casos, hay una serie de manejadores de errores parecidos a la gestión de excepciones de Java.

[Ejemplo de gestión de errores](https://www.nosolocodigo.com/crear-handlers-para-manejar-errores-en-mysql-5)

Dentro del procedimiento es posible crear un manejador de errores para el tipo de error deseado para que cuando se produzca el error introduzca en una tabla que se indique un log de errores y no falle la aplicación. La palabra exit significa que cuando se acabe la ejecución del handler se sale del procedimiento almacenado, si se pone ```continue``` en lugar de ```exit```, la ejecución de procedimiento almacenado continúa.


```sql
DECLARE {CONTINUE | EXIT} HANDLER FOR
{SQLSTATE codigo | MySQL  codigo_error| condicion }
acciones_manejador -- Escribir en un log, etc.
```

Los errores pueden ser códigos definidos por el servidor (SQLSTATE), o creados por el usuario, mientras que la acciones del manejador son aquellas sentencias que se pueden ejecutar en caso de producirse un error.


### Triggers o disparadores

Son un tipo especial de rutina almacenada que se ejecuta cuando ocurre algún evento (operaciones DML que modifican; INSERT, UPDATE, DELETE) que modifica alguna determinada tabla.


```SQL

CREATE TABLE account (acct_num INT, amount DECIMAL(10,2));

CREATE TRIGGER ins_sum BEFORE INSERT ON account
   FOR EACH ROW SET @sum = @sum + NEW.amount;

```

En el ejemplo anterior, si se hacen inserciones en la tabla *account* se ejecuta el trigger y se guarda en la variable *@sum* la cantidad insertada.

* [Recurso Triggers](https://guiadev.com/disparadores-en-mysql/)

#### Creación de triggers

```sql
CREATE TRIGGER nombre_disp momento_disp evento_disp
    ON nombre_tabla FOR EACH ROW sentencia_disp
```

El trigger queda asociado a la tabla *nombre_tabla*, la cual no puede ser una tabla TEMPORARY ni una vista.

*momento_disp* es el momento en que el trigger entra en acción. Puede ser BEFORE (antes) o AFTER (despues), para indicar que el trigger se ejecute antes o después que la sentencia que lo activa.

*evento_disp* indica la clase de sentencia que activa al disparador. Puede ser INSERT, UPDATE, o DELETE. Por ejemplo, un trigger BEFORE para sentencias INSERT podría utilizarse para validar los valores a insertar.

No puede haber dos disparadores en una misma tabla que correspondan al mismo momento y sentencia. Por ejemplo, no se pueden tener dos disparadores BEFORE UPDATE. Pero sí es posible tener los disparadores BEFORE UPDATE y BEFORE INSERT o BEFORE UPDATE y AFTER UPDATE.

*sentencia_disp* es la sentencia que se ejecuta cuando se activa el disparador.


#### Eliminación de triggers

```sql
DROP TRIGGER [nombre_schema.]nombre_disp
```

#### Consulta de triggers

Para consultar los triggers presentes en una base de datos filtrando por nombre o un patrón es posible mediante la sentencia:

```sql
SHOW TRIGGERS [{FROM | IN} nombre_db]
	[LIKE `patron` | WHERE expr]
```


#### Uso de triggers

Hay diversos fines que puede darse al uso de triggers. Dependerá de la aplicación de la base de datos y de forma general se pueden enumerar categorías de usos:

* Control de sesiones
* Control de valores de entrada
* Mantenimiento de campos derivados de otros
* Estadísticas
* Registro y auditoría




### Gestión de rutinas almacenadas

Como ya se ha visto, mediante el DDL se pueden crear rutinas. Además, se definen instrucciones para eliminar y consultar rutinas.

#### Eliminación

```sql
DROP {PROCEDURE | FUNCTION} [IF EXISTS] `nombre`;
```

#### Consulta
```sql
SHOW CREATE {PROCEDURE | FUNCTION} `nombre`;

SHOW {PROCEDURE | FUNCTION} STATUS LIKE `nombre`;
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

* NUMBER (numérico): Almacena números enteros o de punto flotante, virtualmente de cualquier longitud, aunque puede ser especificada la precisión (número de dígitos) y la escala, que es la que determina el número de decimales.

* CHAR (carácter): Almacena datos de tipo carácter con un tamaño máximo de 32.767 bytes y cuyo valor de longitud por defecto es 1.

* VARCHAR2 (carácter de longitud variable): Almacena datos de tipo carácter empleando sólo la cantidad necesaria aún cuando la longitud máxima sea mayor.

* BOOLEAN (lógico): Se emplea para almacenar valores TRUE o FALSE.

* DATE (fecha): Almacena datos de tipo fecha. Las fechas se almacenan internamente como datos numéricos, por lo que es posible realizar operaciones aritméticas con ellas.

Atributos de tipo. Un atributo de tipo PL/SQL es un modificador que puede ser usado para obtener información de un objeto de la base de datos. El atributo %TYPE permite conocer el tipo de una variable, constante o campo de la base de datos. El atributo %ROWTYPE permite obtener los tipos de todos los campos de una tabla de la base de datos, de una vista o de un cursor.

#### Declaración de variables

A la hora de introducir variables, antes de utilizarlas hay que declararlas en el apartado ```DECLARE``` del bloque de código. Declarar la variable supone reservarle un espacio en memoria en el que poder guardar su valor.

```sql
NombreIdentificador [CONSTANT] tipo_dato [NOT NULL] [:= | DEFAULT | Expresion];

fechaInicioCurso DATE;
numCurso NUMBER(2) NOT NULL := 1;
poblacionCentro VARCHAR2(15) := 'Zaragoza';
notaMinimaAprobado CONSTANT NUMBER := 5;
```

Existen dos atributos de tipo: %TYPE y %ROWTYPE.

* %TYPE se usa para declarar una variable que tendrá el mismo tipo que una columna de una tabla.
* %ROWTYPE se usa para declarar un registro con los mismos tipos de la tabla, vista o cursor de la base de datos.

```sql
DECLARE
 v_EmpName emp.ename%TYPE;
 BEGIN
 SELECT ename INTO v_EmpName FROM emp WHERE ROWNUM = 1;
 DBMS_OUTPUT.PUT_LINE('Name = '|| v_EmpName);
 END;
 

DECLARE
 v_emp emp%ROWTYPE;
 BEGIN
 v_emp.empno :=10;
 v_emp.ename :='XXXXXXX';
 END; 
```



### Procedimientos y Funciones.

[Procedimientos y Funciones PL/SQL ES](https://elbauldelprogramador.com/plsql-procedimientos-y-funciones/)

#### Parámetros formales y actuales

Todos los procedimientos y funciones pueden utilizar parámetros para pasar y recibir información. Dentro de los parámetros podemos distinguir dos tipos: 
* Parámetros _actuales_: son variables indicadas en la llamada a un subprograma.
* Parámetros _formales_: son variables declaradas en la especificación del subprograma.

Además es posible hacer el paso de parámetros de un tipo a otro. Generalmente si los tipos son compatibles PL/SQL lo hace automáticamente. En cualquier caso, es posible hacerlo de forma manual utilizando las siguientes notaciones: 

* Nominal: el símbolo => después del parámetro actual y antes del nombre del formal, indica al compilador correspondencia.
* Posicional: el compilador asocia los parámetros actuales a los formales, basándose en su posición.
* Mixta: permite usar las dos notaciones anteriores.

Ejemplo de paso de parámetros y conversión de tipos.
Tenemos la especificación de un procedimiento como esta:

```sql
   PROCEDURE departamento(
      n_departamento INTEGER,
      poblacion VARCHAR2
   IS

## Desde el siguiente bloque se podrán realizar las llamadas indicadas:

   DECLARE
      num_departamento INTEGER;
      aula VARCHAR(30)
   BEGIN
 --  ...
    -- posicional 
    departamento(num_departamento, aula);
    -- nominal 
    departamento(num_departamento => n_departamento, aula =>poblacion);
--   ...
   END;

## Esto nos pasaría los parámetros num_departamento al mismo tipo que n_departamento y localidad al mismo tipo que aula.
```

### Estructuras de control de flujo. Alternativas. Bucles.

#### Selección. IF y CASE

Son muy similares a lo visto para MySQL.

```SQL
IF (expresión) THEN
        -- Instrucciones
    ELSIF (expresión) THEN
        -- Instrucciones
    ELSE
        -- Instrucciones
END IF;

CASE [ expresion ]

   WHEN condicion_1 THEN resultado_1
   WHEN condicion_2 THEN resultado_2
   ...
   WHEN condicion_n THEN resultado_n

   ELSE resultado

END
```


#### Iteración. LOOP, WHILE y FOR.

Son muy similares a lo visto para MySQL. El bucle for puede ejecutarse en sentido inverso si se indica REVERSE.

```sql
LOOP
        -- Instrucciones
        IF (expresión) THEN
        -- Instrucciones
        EXIT;
        END IF;
END LOOP;

WHILE (expresión) LOOP
   -- Instrucciones
END LOOP;

FOR contador IN [REVERSE] inicio..final LOOP
    -- Instrucciones
END LOOP;
```

### Herramientas para creación de guiones; procedimientos de ejecución.

Para ejecutar funciones o procedimientos definidos basta con escribir su nombre seguido de los argumentos (parámetros actuales) entre paréntesis, o los paréntesis vacíos si no los tiene. 

Si se desea ejecutar desde _sqlplus_ es posible hacerlo mediante los comandos *CALL* o *EXEC*

```SQL
CALL nb_proc();
EXEC nb_proc(arg1, arg2);
```

### Eventos y disparadores.

### Excepciones. Tratamiento de excepciones.

### Cursores. Funciones de tratamiento de cursores.

### APIS para lenguajes externos.
