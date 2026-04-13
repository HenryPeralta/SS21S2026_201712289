CREATE OR REPLACE TABLE `usac-ht5-retencion.usac_ht5_retencion.stage_ventas` AS
SELECT * FROM UNNEST([
  STRUCT('2024-01-01' AS fecha, 'C001' AS cliente_id, 'Juan Perez' AS cliente_nombre, 'Retail' AS segmento_cliente,
         'Laptop' AS producto_nombre, 'Dell' AS marca, 'Tecnologia' AS categoria, 'Computadoras' AS subcategoria,
         1 AS cantidad, 800 AS precio_unitario, 800 AS total, 'Guatemala' AS pais, 'Guatemala' AS ciudad),

  STRUCT('2024-01-02', 'C002', 'Maria Lopez', 'Corporativo',
         'Mouse', 'Logitech', 'Tecnologia', 'Accesorios',
         2, 20, 40, 'Guatemala', 'Mixco'),

  STRUCT('2024-01-03', 'C001', 'Juan Perez', 'Retail',
         'Teclado', 'HP', 'Tecnologia', 'Accesorios',
         1, 30, 30, 'Guatemala', 'Guatemala'),

  STRUCT('2024-01-04', 'C003', 'Carlos Ruiz', 'PYME',
         'Monitor', 'Samsung', 'Tecnologia', 'Pantallas',
         1, 200, 200, 'Guatemala', 'Villa Nueva'),

  STRUCT('2024-01-05', 'C004', 'Ana Gomez', 'Retail',
         'Impresora', 'Canon', 'Tecnologia', 'Impresion',
         1, 150, 150, 'Guatemala', 'Antigua')
]);