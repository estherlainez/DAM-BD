1. (1.5 Puntos) Insertar datos

	* Inserta una nueva oficina con sede en Tarazona, Avenida de la Paz, 25, CP 50500, código TRZ-ES. 
	* Inserta un empleado representante de ventas que pertenezca a la oficina anterior y cuyo nombre coincida con el tuyo.
	* Inserta 5 clientes en una sola instrucción y cuyo representante de ventas sea el insertado anteriormente. Se adjuntan a continuación datos para la instrucción.

```sql
(NombreCliente,NombreContacto,ApellidoContacto,Telefono,Fax,LineaDireccion1,Ciudad,Region,Pais,CodigoPostal,LimiteCredito)

('EcoZuia SL', 'Juan', 'Pérez López', 987654321, 987654654, 'Calle Aduana, 64', 'Zuia', 'Alava','España', 01130, 15000),

('EcoGarden SL', 'Julián', 'Arriba Rodríguez', 987654321, 987654654, 'Avda. Andalucía, 92', 'Clavijo', 'La Rioja','España', 26130, 15000),

('Altos Pinos SL', 'María', 'González Pérez', 987654321, 987654654, 'Ctra. Beas-Cortijos Nuevos, 27', 'Navajún', 'La Rioja','España', 26533, 15000),

('Hoja de Roble SL', 'Luis', 'Martínez Rodríguez', 987654321, 987654654, 'Puerto Lugar, 57', 'Viñuela', 'Málaga','España', 29712, 15000),

('Rosas blancas SL', 'Federico', 'Gutiérrez Marín', 987654321, 987654654, 'C/ Los Herrán, 19', 'Castuera', 'Badajoz','España', 06420, 15000)
```
	* Inserta en la tabla clientes_pagos los datos procedentes de una consulta que informe: 

		* Nombre del cliente.
		* Ciudad de la Oficina asociada al representante de ventas del cliente.
		* Importe total pagado hasta la fecha.

2. (1.5 Puntos) Crear Usuarios

	* Todos los usuarios deben tener el password '123456'.
	* Crea un usuario llamado *administrador* que tenga permisos en la base de datos e_jardineria.
	* Crea un usuario llamado *gerente* que pueda modificar y consultar las tablas clientes, pedidos, detallePedidos y pagos.
	* Crea un usuario llamado *jardinero* que pueda consultar todas las tablas.

3. (2 Puntos) Modificación de datos. Utilizando el usuario *gerente* creado anteriormente:
	* Aumenta un 20% el límite de crédito de todos los clientes que hayan hecho pagos en el año 2018.
	* Inserta un pedido que tenga 2 líneas de detalle de pedido mediante una transacción.
	* Elimina los clientes que no sean de la oficina de Tarazona y que no hayan hecho pedidos.

4. (2 Puntos) Consulta
	* Obtén el nombre del cliente que tenga el mayor límite de crédito, el nombre de su representante de ventas y el producto que más cantidad ha comprado.

5. (2 Puntos) Consulta
	* Obtener la facturación que ha tenido cada cliente, indicando el nombre del cliente, la base imponible (suma del precio del producto multiplicado por el número de unidades vendidas), el iva (21% de la base imponible), y el total (base imponible + iva).
	* Crea una vista llamada total_facturado_cliente a partir de esta consulta.

6. (1 Punto) Exportar el contenido de la base de datos.

	* Exporta el contenido actual de la base de datos (estructura y datos) en un fichero llamado dump_examen_jardin.sql

* Se entrega un fichero de texto con los comandos ejecutados para cada ejercicio así como el fichero obtenido en el ejercicio 6.
