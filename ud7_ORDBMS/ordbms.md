## Bases de datos Objeto relacionales
### Introducción
*La Base de Datos Objeto-Relacional es una extensión de la base de datos relacional tradicional, a la cual se le proporcionan características de la programación orientada a objetos (POO).*[Fuente](https://es.wikipedia.org/wiki/Base_de_datos_objeto-relacional)

Buscan adaptar las herramientas proporcionadas por el paradigma de la orientación a objetos al diseño de las bases de datos relacionales existentes con el objetivo de poder aplicar la tecnología madura de bases de datos relacionales sobre la organización de los datos complejos, es decir, datos de texto e imagen, mapas (información geográfica), etc. 

Las bases de datos Objeto-relacional  son compatibles con estos objetos de datos y las operaciones de mayor complejidad.

En bases de datos orientadas a objetos, los usuarios pueden definir _operaciones_ sobre los datos como parte de la definición de la base de datos. Una operación (llamada función) se especifica en dos partes:

* La interfaz (o firma) de una operación incluye el nombre de la operación y los tipos de datos de sus argumentos (o parámetros). 
* La implementación (o método) de la operación se especifica separadamente y puede modificarse sin afectar la interfaz. 
  
Los programas de aplicación de los usuarios pueden operar sobre los datos invocando a dichas operaciones a través de sus nombres y argumentos, sea cual sea la forma en la que se han implementado. Esto podría denominarse independencia entre programas y operaciones.


### Atributos multivalor

Se dice del atributo tal que para una misma entidad puede tomar varios valores diferentes, es decir, varios valores del mismo dominio. Esto entra en confrontación con la denominación de la [1FN de las bases de datos](http://basesdedatosjc.blogspot.com/2012/04/primera-forma-normal-en-bases-de-datos.html). 

Oracle proporciona mecanismos para que el usuario pueda definir sus propios tipos de datos, cuya estructura puede ser compleja, y que se pueden aplicar para asignar un tipo a una columna de una tabla. También reconoce el concepto de objetos, de tal manera que un objeto tiene un tipo, se almacena en cierta fila de cierta tabla y tiene un identificador único (OID). Estos identificadores se pueden utilizar para referenciar a otros objetos y así representar relaciones de asociación y de agregación. Oracle también proporciona mecanismos para asociar métodos a tipos, y constructores para diseñar tipos de datos multivaluados (colecciones) y tablas anidadas. La mayor deficiencia de este sistema es la imposibilidad de definir jerarquías de especialización y herencia, lo cual es una importante desventaja con respecto a las bases de datos orientadas a objetos.

#### Tipos de datos colección

* La versión 8 de Oracle PL/SQL añadió dos tipos colección nuevos las tablas anidadas y los varrays. Cada uno de estos tipos de colecciones puede interpretarse como un tipo de objeto con atributos y métodos. Un tipo colección es aquel que maneja varias variables como una unidad. La versión 2 de PL/SQL sólo tenía un tipo de dato colección, las tablas PL/SQL vistas anteriormente. 

  * VARRAY 
    * Un varray se manipula de forma muy similar a las tablas indexadas o anidadas pero se implementa de forma diferente. Los elementos en el varray se almacenan comenzando en el índice 1 hasta la longitud máxima declarada en el tipo varray. (Ver documento sobre colecciones)
    
  * Tablas anidadas. (Ver documento sobre tablas anidadas)
    * Las tablas anidadas añaden funcionalidad a las indexadas al añadir métodos de colección adicionales y la capacidad de almacenar tablas anidadas en una tabla de la base de datos. Estas tablas también pueden manejarse directamente utilizando órdenes SQL.
    

  * Tipos de objeto.
    * La estructura de la definición o declaración de un tipo de objeto está dividida en una especificación y un cuerpo. La especificación define el interfaz de programación, donde se declaran los atributos así como las operaciones (métodos) para manipular los datos. En el cuerpo se implementa el código fuente de los métodos.
    * Toda la información que un programa necesita para usar los métodos lo encuentra en la especificación. Se puede modificar el cuerpo sin cambiar la especificación, sin que ello afecte a los programas cliente.
    * En la especificación de un tipo de objeto, todos los atributos debes declararlos antes que los métodos. Si la especificación de un tipo de objeto sólo declara atributos, no es necesario que declares el cuerpo. Debes tener en cuenta también que no puedes declarar atributos en el cuerpo. Además, todas las declaraciones realizadas en la especificación del tipo de objeto son públicas, es decir, visibles fuera del tipo de objeto.



### Identificadores de objeto (OID)

* Cada fila de una tabla tipada (OR) tendrá un identificador del objeto fila. Para guardar esos identificadores Oracle utiliza una *referencia*.

```sql
-- REF(e) devuelve el identificador OID de la fila.
SELECT REF(e) 
FROM empleado e
WHERE e.nombre = 'Martinez';
```

* Cada fila se puede referenciar mediante su OID

```sql
CREATE OR REPLACE TYPE tipo_persona AS OBJECT (
    Nombre VARCHAR2(30),
    Direccion Tipo_Direccion)
/

CREATE OR REPLACE TYPE sociedad_limitada AS OBJECT (
    Nombre VARCHAR2(30),
    Cif VARCHAR2(20),
    Gerente REF tipo_persona)
/
```

* Para obtener una referencia a un objeto utilizamos el operador ```REF```
* Una columna de tipo ```REF``` guarda un *puntero* a una fila de la tabla referenciada, almacena su OID.
* Para acceder a las referencias en PL/SQL hay que hacerlo mediante DEREF, ya que no se puede hacer directamente. Por el contrario en SQL sí son accesibles (el DEREF se hace de forma implícita).

### Programación de métodos

(ver documento sobre métodos)

### Conceptos de orientación a objetos. Herencia.

* El lenguaje PL/SQL admite la herencia simple de tipos de objetos, mediante la cual, se pueden definir subtipos de los tipos de objeto. Estos subtipos, o tipos heredados, contienen todos los atributos y métodos del tipo padre, pero además pueden contener atributos y métodos adicionales, o incluso sobreescribir métodos del tipo padre.

* Para indicar que un tipo de objeto es heredado de otro se utiliza la palabra reservada UNDER, y además hay que tener en cuenta que el tipo de objeto *padre* debe tener la propiedad NOT FINAL. Por defecto, los tipos de objeto se declaran como FINAL, es decir, que no se puede crear un tipo de objeto que herede de él.

* Si no se indica lo contrario, siempre se pueden crear objetos (instancias) de los tipos de objeto declarados. Indicando la opción NOT INSTANTIABLE es posible declarar tipos de objeto de los que no se pueden crear objetos. El objetivo de crear estos tipos es que sean *padres* de otros que sí se puedan instanciar.
  
En el siguiente ejemplo se ve la creación del tipo de objeto *Persona*, que se utilizará heredado en el tipo de objeto *UsuarioPersona*. De esta manera, este último tendrá los atributos de *Persona* junto a los atributos declarados en *UsuarioPersona*. Nótese que en la creación del objeto se deben asignar los valores para todos los atributos, propios y heredados.
 
```sql
CREATE TYPE Persona AS OBJECT (
   nombre VARCHAR2(20),
   apellidos VARCHAR2(30)
) NOT FINAL; 
/

CREATE TYPE UsuarioPersona UNDER Persona (
   login VARCHAR(30),
   fecha_inicio DATE,
   saldo NUMBER
); 
/

DECLARE
   u1 UsuarioPersona;
BEGIN
   u1 := NEW UsuarioPersona('nombre1', 'apellidos1', 'user1', '01/01/2019', 100);
   dbms_output.put_line(u1.nombre);
END; 
/
```


### Gestión de referencias.

Ver documento sobre referencias


### Recursos
* [Objetos PL/SQL PDF ES](http://www.v-espino.com/~chema/daw1/tutoriales/oracle/OracleObjetos.pdf)