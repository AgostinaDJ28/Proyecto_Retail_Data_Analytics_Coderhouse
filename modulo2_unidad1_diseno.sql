
--Crear Tabla de Clientes--
CREATE TABLE clientes (id_cliente INT, --INT porque el identificador del cliente será un número entero--
nombre VARCHAR(100), --VARCHAR(100) porque el nombre será un texto de hasta 100 caracteres--
perfil_bio TEXT, --TEXT porque permite guardar una biografía o notas más extensas--
fecha_registro DATE); --DATE porque solamente necesitamos guardar la fecha--


--Crear Tabla de Productos--
CREATE TABLE productos (id_producto INT, --INT porque el identificador del producto será un número entero--
descripcion VARCHAR(255), --VARCHAR(255) porque la descripción será texto de hasta 255 caracteres--
precio DECIMAL(10,2), --DECIMAL(10,2) porque permite almacenar precios de hasta 10 dígitos en total, de los cuales 2 serán decimales--
esta_activo SMALLINT); --SMALLINT porque podemos representar el estado con 1 para activo y 0 para inactivo--
