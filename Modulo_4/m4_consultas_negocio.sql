--MODULO 4 - PRE-ENTREGA: CONSULTAS SQL DE NEGOCIO--
--Proyecto RetailPro--

--EXTRAYENDO METRICAS CLAVES CON SQL--
  
  USE Ventas_Tech_DB;

--CONSULTA 1 - RESUMEN EJECUTIVO MENSUAL--
 ---Total facturado, cantidad de pedidos y ticket promedio por mes---

SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--CONSULTA 2 - RANKING DE PRODUCTOS--
---Top 5 de productos según el total facturado---

SELECT TOP 5
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--CONSULTA 3 - CLIENTES RECURRENTES--
---Clientes con más de un pedido, cantidad de pedidos y total gastado---

SELECT
id_cliente,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1;

--CONSULTA 4 - MESES POR ENCIMA O POR DEBAJO DEL PROMEDIO--
---Primero se calcula el total facturado por mes y luego se compara cada mes con el promedio mensual general---

SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
CASE 
WHEN SUM(cantidad * precio_unitario) >
(
SELECT AVG(total_mensual)
FROM (
SELECT
SUM(cantidad * precio_unitario) AS total_mensual
FROM ventas
GROUP BY MONTH(fecha_venta)
) AS resumen_mensual
)
THEN 'Por encima'
WHEN SUM(cantidad * precio_unitario) <
(
SELECT AVG(total_mensual)
FROM (
SELECT
SUM(cantidad * precio_unitario) AS total_mensual
FROM ventas
GROUP BY MONTH(fecha_venta)
) AS resumen_mensual
)
THEN 'Por debajo'
ELSE 'Igual al promedio'
END AS comparacion_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

----HALLAZGOS ENCONTRADOS----
--Hallazgo 1: En marzo se registraron 10 pedidos, con una facturación total de 6444.00 y un ticket promedio de 644.40.
--Hallazgo 2: El producto con id_producto = 1 fue el que más facturación generó, con 3600.00 y 3 unidades vendidas.
--Hallazgo 3: Los cinco clientes realizaron más de un pedido. El cliente con id_cliente = 1 fue el de mayor gasto total, con 2640.00.
