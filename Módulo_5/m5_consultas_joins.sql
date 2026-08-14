
--============================================================--
-- M5 - PRE-ENTREGA: CONSULTAS CON JOINS
-- Proyecto RetailPro
--============================================================--

-- Usar la Base de Datos --
USE Ventas_Tech_DB;

--============================================================--
--CONSULTA 1 - VISTA BASE DEL PROYECTO
--Combina ventas, clientes, productos, categorias y territorios.
--============================================================--

SELECT
v.fecha_venta AS fecha,
c.nombre AS nombre_cliente,
c.segmento,
t.region,
p.nombre_producto,
cat.nombre_categoria AS categoria,
v.cantidad,
v.precio_unitario,
v.cantidad * v.precio_unitario AS total_venta,
v.canal
FROM ventas v
INNER JOIN clientes c
ON v.id_cliente = c.id_cliente
INNER JOIN productos p
ON v.id_producto = p.id_producto
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
INNER JOIN territorios t
ON v.id_territorio = t.id_territorio;


--============================================================--
--CONSULTA 2 - CLIENTES SIN VENTAS
--El LEFT JOIN conserva todos los clientes y WHERE IS NULL permite identificar los que todavia no realizaron compras.--
--============================================================--

SELECT
c.nombre,
c.email,
c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;


--============================================================--
--CONSULTA 3 - PRODUCTOS SIN VENTAS
--Se identifican los productos del catalogo que no registran ninguna venta.--
--============================================================--

SELECT
p.nombre_producto,
cat.nombre_categoria AS categoria,
p.precio
FROM productos p
INNER JOIN categorias cat
ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;


--============================================================--
--CONSULTA 4 - CONSOLIDADO POR CANAL
--UNION ALL combina las ventas Online y Presencial conservando todas las filas. Luego se calcula el total vendido por canal.--
--============================================================--

SELECT
canal,
SUM(total_venta) AS total_por_canal
FROM (
SELECT
'Online' AS canal,
cantidad * precio_unitario AS total_venta
FROM ventas
WHERE canal = 'Online'

UNION ALL

SELECT
'Presencial' AS canal,
cantidad * precio_unitario AS total_venta
FROM ventas
WHERE canal = 'Presencial'
) AS ventas_por_canal
GROUP BY canal;

