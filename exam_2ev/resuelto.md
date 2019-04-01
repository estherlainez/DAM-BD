1. (1.5 Puntos) Insertar datos

    * Inserta una nueva oficina con sede en Tarazona, Avenida de la Paz, 25, CP 50500, Teléfono 987654321, Fax 987123456 código 'TRZ-ES'. 
    * Inserta un empleado representante de ventas que pertenezca a la oficina anterior y cuyo nombre coincida con el tuyo.
    * Inserta 5 clientes en una sola instrucción y cuyo representante de ventas sea el insertado anteriormente. Se adjuntan a continuación datos para la instrucción.

    * Inserta en la tabla clientes_pagos los datos procedentes de una consulta que informe: 

        * Nombre del cliente.
        * Ciudad de la Oficina asociada al representante de ventas del cliente.
        * Importe total pagado hasta la fecha.

```sql 
insert into oficinas (CodigoOficina, Ciudad, Pais,Telefono, CodigoPostal, LineaDireccion1) values ('TRZ-ES', 'Tarazona', 'España','987654321','50500', 'Avenida de la paz 25');

insert into empleados (CodigoEmpleado, Nombre, apellido1, email, codigoOficina, CodigoJefe, puesto, extension) values (32, 'Antonio', 'Gómez', 'gomez@jardineria.es', 'TRZ-ES', 1, 'Representante Ventas', '9981');


insert into clientes (CodigoCliente, NombreCliente,NombreContacto,ApellidoContacto,Telefono,Fax,LineaDireccion1,Ciudad,Region,Pais,CodigoPostal,LimiteCredito, CodigoEmpleadoRepVentas) values

(39,'EcoZuia SL', 'Juan', 'Pérez López', 987654321, 987654654, 'Calle Aduana, 64', 'Zuia', 'Alava','España', 01130, 15000, 32),

(40, 'EcoGarden SL', 'Julián', 'Arriba Rodríguez', 987654321, 987654654, 'Avda. Andalucía, 92', 'Clavijo', 'La Rioja','España', 26130, 15000, 32),

(41, 'Altos Pinos SL', 'María', 'González Pérez', 987654321, 987654654, 'Ctra. Beas-Cortijos Nuevos, 27', 'Navajún', 'La Rioja','España', 26533, 15000, 32),

(42, 'Hoja de Roble SL', 'Luis', 'Martínez Rodríguez', 987654321, 987654654, 'Puerto Lugar, 57', 'Viñuela', 'Málaga','España', 29712, 15000, 32),

(43, 'Rosas blancas SL', 'Federico', 'Gutiérrez Marín', 987654321, 987654654, 'C/ Los Herrán, 19', 'Castuera', 'Badajoz','España', 06420, 15000, 32);


insert into clientes_pagos (razon_social, importe_total, ciudad) (select c.nombrecliente, sum(p.cantidad), o.ciudad
from clientes c inner join pagos p on p.codigocliente = c.codigoCliente
inner join empleados e on e.codigoempleado = c.codigoempleadorepventas
inner join oficinas o on e.codigoOficina = o.codigooficina
group by c.codigocliente);
```

2. (1.5 Puntos) Crear Usuarios

    * Crea un usuario llamado *administrador* que tenga todos permisos en la base de datos exam_jardineria desde el equipo local.
    * Crea un usuario llamado *jardinero* que pueda consultar todas las tablas de exam_jardineria desde el equipo local.
    * *Nota: Todos los usuarios deben tener el password '$Bd123456'.*

```sql 
-- Creación de los usuarios. A partir de MySQL 8 se han producido unos cambios en la sintaxis de GRANT
-- Por este motivo, he estructurado las órdenes así.

create user administrador identified by '123456';
grant all on exam_jardineria.* to 'administrador'@'localhost';

create user gerente identified by '123456';
update mysql.user set host = 'localhost' where user = 'gerente';

grant select on exam_jardineria.clientes to 'gerente'@'localhost';
grant update on exam_jardineria.clientes to 'gerente'@'localhost';
grant select on exam_jardineria.pedidos to 'gerente'@'localhost';
grant update on exam_jardineria.pedidos to 'gerente'@'localhost';
grant select on exam_jardineria.detallepedidos to 'gerente'@'localhost';
grant update on exam_jardineria.detallepedidos to 'gerente'@'localhost';
grant select on exam_jardineria.pagos to 'gerente'@'localhost';
grant update on exam_jardineria.pagos to 'gerente'@'localhost';

create user 'jardinero'@'localhost' identified by '123456';

grant select on exam_jardineria.* to 'jardinero'@'localhost'; 

select user,host from mysql.user;
```


3. (2 Puntos) Modificación de datos con *administrador*:
    * Aumenta un 20% el límite de crédito de todos los clientes que hayan hecho pagos en el año 2018.
    * Elimina los clientes que no sean de la oficina de Tarazona y que no hayan hecho pedidos ni pagos.

```sql 
update clientes set limitecredito = limitecredito * 1.2 where codigoCliente in (select distinct p.codigoCliente from pagos p where p.fechapago like '2018%') and codigoCliente > 0;

-- Insertar pedido mediante transacción
start transaction;
insert into pedidos() values();
insert into detallePedidos() values();
insert into detallePedidos() values();
commit;

create table backupclientes like clientes;

insert into backupclientes (select * from clientes);

-- Eliminar los clientes que no sean de Tarazona y que no hayan hecho pedidos (ni pagos)

DELETE FROM clientes 
WHERE
    codigoCliente NOT IN (SELECT 
        codigoCliente
    FROM
        pagos)
    AND codigoCliente NOT IN (SELECT 
        codigoCliente
    FROM
        Pedidos)
	and codigoEmpleadoRepVentas not in (select codigoempleado from empleados where codigoOficina <> 'TRZ-ES');

```

-- Recuperar los clientes borrados del backup    
--  insert into clientes (select * from backupclientes where codigocliente not in (select codigoCliente from clientes));
--  select * from clientes;


4. (2 Puntos) Consulta con el usuario *jardinero*
    * Obtén el nombre del cliente que tenga el mayor límite de crédito, el nombre de su representante de ventas y el producto que más cantidad ha comprado.

    
```sql 
SELECT 
    c.nombrecliente,
    c.limitecredito,
    CONCAT(e.nombre, ' ', e.apellido1),
    CONCAT(e2.nombre, ' ', e2.apellido1)
FROM
    clientes c
        INNER JOIN
    empleados e ON c.codigoempleadorepventas = e.codigoempleado
        INNER JOIN
    empleados e2 ON e.codigojefe = e2.codigoempleado
order by c.limitecredito desc
limit 1;
```

5. (2 Puntos) Consulta y vista
    * Obtener la facturación que ha tenido cada producto, indicando el nombre del producto, la descripción de la gama a la que pertenece, el precio del producto, unidades vendidas y el importe facturado.

    * Crea una vista llamada total_facturado_producto a partir de esta consulta.

    * Haz una consulta sobre la vista para mostrar los productos que han reportado más de 100€ de ingresos.

```sql 

-- Ejercicio 5
create view total_facturado_producto as SELECT 
    pr.nombre,
    g.descripciontexto,
    pr.precioventa,
    SUM(dp.cantidad) as cantidadtotal,
    SUM(dp.cantidad * pr.precioventa) as importetotal
FROM
    productos pr
        INNER JOIN
    gamasproductos g ON g.gama = pr.gama
        INNER JOIN
    detallepedidos dp ON dp.codigoproducto = pr.codigoproducto
GROUP BY pr.codigoproducto
HAVING SUM(pr.precioventa * cantidad) > 100
ORDER BY 5 DESC;

select * from total_facturado_producto where importetotal > 100;
```

6. (1 Punto) Exportar el contenido de la base de datos.

    * Exporta el contenido actual de la base de datos (estructura y datos) en un fichero llamado dump_ex2ev_jardin.sql

* Se entrega un fichero de texto con los comandos ejecutados para cada ejercicio así como el fichero obtenido en el ejercicio 6.






