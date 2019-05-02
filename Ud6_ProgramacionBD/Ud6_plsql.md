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

[Tipos de datos](https://elbauldelcodigo.com/tipos-de-datos-en-plsql/41/0)

Cada constante y variable tiene un tipo de dato en el que se especifica el formato de almacenamiento, restricciones y rango de valores válidos. PL/SQL proporciona una variedad predefinida de tipos de datos. Casi todos los tipos de datos manejados por PL/SQL son similares a los soportados por SQL. A continuación se muestran los tipos de datos más comunes:

* NUMBER (numérico): Almacena números enteros o de punto flotante, virtualmente de cualquier longitud, aunque puede ser especificada la precisión (número de dígitos) y la escala, que es la que determina el número de decimales.

* CHAR (carácter): Almacena datos de tipo carácter con un tamaño máximo de 32.767 bytes y cuyo valor de longitud por defecto es 1.

* VARCHAR2 (carácter de longitud variable): Almacena datos de tipo carácter empleando sólo la cantidad necesaria aún cuando la longitud máxima sea mayor.

* BOOLEAN (lógico): Se emplea para almacenar valores TRUE o FALSE.

* DATE (fecha): Almacena datos de tipo fecha. Las fechas se almacenan internamente como datos numéricos, por lo que es posible realizar operaciones aritméticas con ellas.

Atributos de tipo. Un atributo de tipo PL/SQL es un modificador que puede ser usado para obtener información de un objeto de la base de datos. El atributo %TYPE permite conocer el tipo de una variable, constante o campo de la base de datos. El atributo %ROWTYPE permite obtener los tipos de todos los campos de una tabla de la base de datos, de una vista o de un cursor. Ejemplos a continuación.

#### Declaración de variables

A la hora de introducir variables, antes de utilizarlas hay que declararlas en el apartado ```DECLARE``` del bloque de código. [Declarar la variable](https://elbauldelprogramador.com/plsql-declaracion-de-variables/) supone reservarle un espacio en memoria en el que poder guardar su valor.

```sql
NombreIdentificador [CONSTANT] tipo_dato [NOT NULL] [:= | DEFAULT | Expresion];

fechaInicioCurso DATE;
numCurso NUMBER(2) NOT NULL := 1;
poblacionCentro VARCHAR2(15) := 'Zaragoza';
notaMinimaAprobado CONSTANT NUMBER := 5;
```

Existen dos atributos de tipo: %TYPE y %ROWTYPE.

* __%TYPE__ se usa para declarar una variable que tendrá el mismo tipo que una columna de una tabla.
* __%ROWTYPE__ se usa para declarar un registro con los mismos tipos de la tabla, vista o cursor de la base de datos.

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

* [Procedimientos y Funciones PL/SQL ES](https://elbauldelprogramador.com/plsql-procedimientos-y-funciones/)
* [Procedimientos almacenados PL/SQL ES](https://elbauldelcodigo.com/procedimientos-almacenados-en-plsql/60/0)

#### Parámetros formales y actuales

Todos los procedimientos y funciones pueden utilizar parámetros para pasar y recibir información. Dentro de los parámetros podemos distinguir dos tipos: 
* Parámetros _actuales_: son variables indicadas en la llamada a un procedimiento o función.
* Parámetros _formales_: son variables declaradas en la especificación del procedimiento o función.

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

END CASE;
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

### SQL en PL/SQL

La principal utilidad del lenguaje de programación es poder trabajar con la información almacenada en los DBMS, Oracle en el caso que nos ocupa. Resulta provechoso poder hacer uso de las herramientas de la programación conocidas para el tratamiento de la información almacenada.

#### Consultas _SELECT_ 

Una diferencia entre hacer las consultas en SQL puro y mediante PLSQL es la posibilidad de hacer uso de variables y que las consultas deben recuperar UNA SOLA FILA (Si devuelve más, se produce un error). Además, debe coincidir el número y tipo de las variables con las columnas que devuelve la consulta. Aquí es donde cobra relevancia el uso de _%ROWTYPE_.

```sql
DECLARE 
   numPedidos NUMBER;
   numCliente NUMBER;
BEGIN
    numCliente := 3;
    SELECT count(*) INTO numPedidos
    FROM pedidos 
    WHERE codigoCliente = numCliente;
    DBMS_OUTPUT.PUT_LINE('El cliente '|| numCliente || ' ha efectuado '|| numPedidos || ' en total.');
END;
/


DECLARE
RegPedido PEDIDOS%ROWTYPE;
BEGIN
    SELECT * INTO RegPedido
    FROM pedidos
    WHERE codigoPedido = 2;

    DBMS_OUTPUT.PUT_LINE('Cantidad Pedida: ' || RegPedido.cantidad);
END;
/
```


#### Inserciones _INSERT_

De forma similar a lo visto en las consultas, es posible efectuar inserciones en las tablas en código PL/SQL, situando variables cuyos valores sean insertados en la tabla.


#### Modificaciones _UPDATE_

Las modificaciones de los datos ya presentes en las tablas también pueden mejorarse mediante el uso de las herramientas de la programación. Por ejemplo, podría hacerse un procedimiento que aumentara el salario de los empleados del departamento pasado como parámetro. Nótese que mediante _%TYPE_ se establece que el tipo de la variable de entrada dpto debe coincidir con el que tenga asignado el código de Departamento de la tabla de Departamentos (y por tanto con el de la tabla de empleados).

```sql
CREATE OR REPLACE PROCEDURE SUBIRSALARIODPTO(aumento IN INT, dpto IN DEPARTAMENTOS.codigoDpto%TYPE)
AS
BEGIN
    UPDATE EMPLEADOS
    SET salario = salario + (salario * aumento/100);
    WHERE codigoDpto = dpto;
END;
/
```


### Eventos y disparadores.

### Excepciones. Tratamiento de excepciones.

### Cursores. Funciones de tratamiento de cursores.


#### Cursores implícitos.

Conviene saber que en los bloques de código PL/SQL es bastante práctico el uso de cursores. 
El resultado de una consulta no se muestra directamente en el terminal del usuario, sino que se guarda en un *área de memoria* a la que se accede mediante cursores.

Para realizar una consulta en PL/SQL tenemos que guardar el resultado en cursores. Esto es muy sencillo y basta con meter un INTO en las consultas. Un ejemplo seria este:

```sql
select columna INTO variable 
from tabla 
[where ...]

select count(*) INTO numPedidos 
from pedidos;
```
La variable a continuación de la palabra INTO recoge el valor de la columna. Es importante que el tipo de dato de la variable coincida con el tipo de dato de la columna.

#### Cursores explícitos

Si la consulta que se quiere almacenar en la variable devuelve más de una fila, se hace necesaria la utilización de cursores explícitos. 

Tenemos 4 operaciones básicas para trabajar con un cursor explícito. 

* Declaración del cursor: lo tenemos que declarar en la zona de declaraciones, con el siguiente formato: 
  ```sql 
  CURSOR nombrecursor IS sentencia SELECT ...;
  ```
* Apertura del cursor: Deberá colocarse en la zona de instrucciones, con el siguiente formato: 

  ```sql
   OPEN nombrecursor;
   ```
Una vez abierto, se ejecuta la consulta expresada en el SELECT y los resultados se almacenan en las estructuras internas de memoria gestionadas por el cursor.

* Recogida de información: Para recuperar la información anteriormente guardada en las estructuras de memoria interna tenemos que usar el siguiente formato: 
  ```sql
   FETCH nombrecursor INTO {variable | lista_variables}; -- Aquí toma valor el uso de %ROWTYPE. Si se usa una lista de variables.
   ```
Si tenemos una lista de variables, cada una de ellas recibirá la columna correspondiente de la sentencia select, por lo que serán del mismo tipo que las columnas.

*  Cierre del cursor: 

```sql
   CLOSE nombrecursor;
```

```sql
   DECLARE   
      CURSOR C1 IS SELECT nombre, apellido FROM empleado; -- No se utiliza el INTO al declarar, sino en el bucle posterior.
      Vnom    VARCHAR2(20);
      Vape    VARCHAR2(40);
   BEGIN
      OPEN C1;
      LOOP 
         FETCH C1 INTO Vnom, Vape;
         EXIT WHEN C1%NOTFOUND; -- Condición de salida del bucle para cuando no quedan más filas.
         DBMS_OUTPUT.PUT_LINE(Vnom || '' || Vape);
      END LOOP;
      CLOSE C1;
   END;
```

##### Atributos propios de cursores

* __%FOUND__: Devuelve *true* si el último FETCH ha recuperado algún valor, *false* en caso contrario. Si el cursor no está abierto da error.
* __%NOTFOUND__: Comportamiento inverso al anterior.
* __%ROWCOUNT__: Devuelve el número de filas recuperadas hasta el momento.
* __%ISOPEN__: Devuelve *true* si el cursor está abierto.


```sql
   CREATE OR REPLACE PROCEDURE ver_empleados_por_dpto(dpto_id VARCHAR2)
   IS
      dpto VARCHAR2(3); -- Variable de acoplamiento
      Vnom VARCHAR(15);
      CURSOR C1 IS SELECT nombre 
         FROM empleados 
         WHERE dpto_id=dpto;
      
   BEGIN
      dpto:=dpto_id; -- Antes de abrir se le da valor, que se sustituye en la consulta.
      OPEN C1;
      FETCH C1 INTO vnom;
      WHILE C1%FOUND LOOP
         DBMS_OUTPUT.PUT_LINE(Vnom);
         FETCH C1 INTO Vnom;
      END LOOP;
      CLOSE C1;
   END;
```

#### Parámetros en cursores

Otra característica ventajosa del uso de cursores está relacionada con el uso de las variables de acoplamiento. 

```sql
   CURSOR nombrecursor [(parámetros)] IS SELECT nombre, edad, puesto from empleados where ...
```
Los parámetros formales se indican después del nombre del cursor de la forma siguiente:

```sql
   nombreCursor [IN] tipodato [{:=|DEFAULT} valor]
   -- Todos los parámetros son de entrada y con scope local al cursor, así solo se referencian en la consulta.
```
```sql
   DECLARE
      ...
      CURSOR C1 (vdpto number, vsalario number DEFAULT 1500) IS SELECT nombre, edad FROM empleados WHERE departamento = vdpto AND salario > vsalario;

-- Para abrir un cursor con parámetros lo haremos de la siguiente forma:

   OPEN C1(1, 1300); -- empleados del departamento 1 y salario superior a 1300
      ...
```

##### Sintaxis FOR...LOOP

El proceso de uso de un cursor consiste en declararlo, declarar una variable que recibirá los datos del cursor, abrir el cursor, recuperar con fetch las filas extraídas introduciendo los datos en las variables, procesándolos y comprobando si se han recuperado datos o no.

Para llevar a cabo dicha tarea, mediante la instrucción FOR...LOOP se llevan a cabo todas las tareas citadas excepto la declaración del cursor.

```sql
   DECLARE
      CURSOR c2 IS SELECT nombre, edad, puesto FROM empleados WHERE salario>1500;
   BEGIN
      FOR vreg IN c2 LOOP
         DBMS_OUTPUT.PUT_LINE (vreg.nombre || ' ' ||vreg.edad || ' ' || vreg.puesto);
      END LOOP;
   END;
```

Mediante esta sintaxis:
* No hay que abrir ni cerrar el cursor.
* La variable (vreg) se declara de forma implícita en el bucle (y solo está en el ámbito del bucle).
* Cada iteración del bucle supone un fetch automático.
* El bucle finaliza de forma automática cuando se acaban las filas.






  
  

### APIS para lenguajes externos.

### Recursos

* [Mundo Oracle](http://www.mundoracle.com/pl-sql.html?Pg=sql_plsql_11.htm)
* [El baul del programador, cursores.](https://elbauldelprogramador.com/plsql-cursores/)