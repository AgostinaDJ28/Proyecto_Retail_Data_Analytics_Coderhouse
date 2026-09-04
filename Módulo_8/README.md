# M8 - Modelo de datos con relaciones activas y medidas DAX

## Archivo entregado

`Diaz_Jalaf_Alejandra_Agostina_Checkpoint2.pbix`

Este archivo continúa el trabajo realizado en el Módulo 6, donde se construyó el pipeline ETL de RetailPro en Power BI. En este checkpoint se configuró el modelo de relaciones, se creó una tabla calendario, una tabla exclusiva de medidas DAX y una matriz de validación para comprobar el funcionamiento de las medidas de inteligencia temporal.

## Modelo de relaciones

Se configuraron manualmente las cuatro relaciones solicitadas en la consigna. Todas se encuentran activas, con cardinalidad 1:N y dirección de filtro única desde la dimensión hacia la tabla correspondiente.

- `Dim_Clientes[id_cliente]` → `Fact_Ventas[id_cliente]`
- `Dim_Productos[id_producto]` → `Fact_Ventas[id_producto]`
- `Dim_Categorias[id_categoria]` → `Dim_Productos[id_categoria]`
- `Dim_Fechas[Date]` → `Fact_Ventas[fecha_venta]`

No se utilizaron relaciones bidireccionales.

## Tabla calendario

Se creó la tabla `Dim_Fechas` utilizando DAX y tomando como rango la fecha mínima y máxima disponible en `Fact_Ventas`.

```DAX
Dim_Fechas =
CALENDAR(
MIN(Fact_Ventas[fecha_venta]),
MAX(Fact_Ventas[fecha_venta])
)
```

Dentro de `Dim_Fechas` se crearon las siguientes columnas calculadas:

```DAX
Año =
YEAR(Dim_Fechas[Date])
```

```DAX
Mes Número =
MONTH(Dim_Fechas[Date])
```

```DAX
Mes Nombre =
FORMAT(Dim_Fechas[Date], "MMMM")
```

```DAX
Trimestre =
"T" & QUARTER(Dim_Fechas[Date])
```

```DAX
Semana =
WEEKNUM(Dim_Fechas[Date])
```

La columna `Mes Nombre` fue ordenada utilizando `Mes Número` para que los meses se visualicen cronológicamente de enero a diciembre.

Además, `Dim_Fechas` fue marcada como tabla de fechas utilizando la columna `Date`.

## Tabla de medidas

Se creó una tabla exclusiva denominada `_Medidas`, sin columnas de datos, destinada únicamente a contener las medidas DAX del modelo.

Se crearon las cinco medidas solicitadas:

### 1. Total Ventas

Medida base que calcula el total facturado a partir de la columna `total_venta` de la tabla de hechos.

```DAX
Total Ventas =
SUM(Fact_Ventas[total_venta])
```

### 2. Ventas Online

Medida que utiliza `CALCULATE` para obtener únicamente las ventas correspondientes al canal Online.

```DAX
Ventas Online =
CALCULATE(
[Total Ventas],
Fact_Ventas[canal] = "Online"
)
```

### 3. Ventas YTD

Medida de inteligencia temporal que calcula el acumulado de ventas desde el inicio del año hasta el período seleccionado.

```DAX
Ventas YTD =
TOTALYTD(
[Total Ventas],
Dim_Fechas[Date]
)
```

### 4. Ventas LY

Medida que permite comparar las ventas del período actual con el mismo período del año anterior.

```DAX
Ventas LY =
CALCULATE(
[Total Ventas],
SAMEPERIODLASTYEAR(Dim_Fechas[Date])
)
```

### 5. % Crecimiento Anual

Medida optimizada mediante variables `VAR` y la función `DIVIDE`, evitando la división directa y posibles errores por división por cero.

```DAX
% Crecimiento Anual =
VAR VentasActual = [Total Ventas]
VAR VentasAnterior = [Ventas LY]
RETURN
DIVIDE(
VentasActual - VentasAnterior,
VentasAnterior
)
```

La medida `% Crecimiento Anual` fue formateada como porcentaje con dos decimales.

## Validación con matriz

Se creó una página de reporte llamada `Validación`.

La matriz fue configurada de la siguiente manera:

- Filas: `Dim_Fechas[Mes Nombre]`
- Columnas: `Dim_Fechas[Año]`
- Valores:
- `Total Ventas`
- `Ventas YTD`
- `Ventas LY`
- `% Crecimiento Anual`

Los meses fueron ordenados cronológicamente utilizando la columna `Mes Número`.

## Resultados verificados

Se realizaron controles sobre los valores obtenidos en la matriz para comprobar el correcto funcionamiento de las medidas.

### Enero 2023

- Total Ventas: **2.967,50**
- Ventas YTD: **2.967,50**

El resultado es correcto porque enero es el primer mes del año y, por lo tanto, el acumulado YTD coincide con las ventas del mes.

### Febrero 2023

- Total Ventas: **2.017,00**
- Ventas YTD: **4.984,50**

El resultado es correcto porque:

`2.967,50 + 2.017,00 = 4.984,50`

Por lo tanto, `Ventas YTD` acumula correctamente enero y febrero.

### Enero 2024

- Total Ventas: **3.018,00**
- Ventas YTD: **3.018,00**
- Ventas LY: **2.967,50**
- % Crecimiento Anual: **1,70 %**

`Ventas LY` recupera correctamente las ventas correspondientes a enero de 2023.

El porcentaje de crecimiento también resulta coherente con la comparación entre ambos períodos.

### Año 2023

`Ventas LY` permanece en `BLANK` porque el modelo no contiene datos correspondientes al año 2022.

Este comportamiento es el esperado para la primera anualidad disponible en el dataset.

## Conclusión

El modelo quedó configurado con relaciones activas 1:N y dirección de filtro única, una tabla calendario correctamente relacionada y marcada como tabla de fechas, una tabla exclusiva `_Medidas` con las cinco medidas DAX requeridas y una página de validación que permite comprobar el correcto funcionamiento de los cálculos de inteligencia temporal.
