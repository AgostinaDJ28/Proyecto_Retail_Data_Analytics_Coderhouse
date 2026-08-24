# M6 - Pipeline ETL con Power Query y lenguaje M

## Fuente de datos
Para esta entrega se utilizó el archivo Pipeline_ETL_Dataset.xlsx provisto por el curso.

## Transformaciones realizadas

### Dim_Clientes
- Se eliminaron las filas vacías.
- Se eliminó el registro duplicado utilizando id_cliente como identificador.
- El email faltante se reemplazó por "Sin email".
- La ciudad faltante se reemplazó por "Sin datos".

Se conservaron estos clientes porque la ausencia de email o ciudad no invalida el registro del cliente y eliminarlos habría significado perder información válida.

### Dim_Productos
- Se eliminaron las filas vacías.
- Se eliminó el producto duplicado utilizando id_producto.
- El precio faltante del producto 109 se reemplazó por 130, ya que ese mismo producto registra de forma consistente un precio_unitario de 130 en las ventas.
- La categoría faltante de Laptop Gaming Pro se completó como "Computación", porque pertenece a la subcategoría Laptops y los productos equivalentes se encuentran dentro de esa categoría.

### Dim_Categorias
- Se eliminaron las filas vacías utilizando id_categoria como referencia.

### Dim_Territorios
- Se verificó que los 9 registros estuvieran completos y con tipos de datos correctos.

### Fact_Ventas
- Se conservaron las 50 transacciones.
- Se realizó un Merge mediante id_producto entre Fact_Ventas_Origen y Dim_Productos.
- Se incorporaron únicamente nombre_producto y categoria.

## Resultado final

- Dim_Clientes: 11 filas
- Dim_Productos: 12 filas
- Dim_Categorias: 4 filas
- Dim_Territorios: 9 filas
- Fact_Ventas_Origen: 50 filas
- Fact_Ventas: 50 filas

Las transformaciones fueron documentadas mediante comentarios técnicos en lenguaje M en Dim_Clientes, Dim_Productos, Dim_Categorias y Fact_Ventas.
