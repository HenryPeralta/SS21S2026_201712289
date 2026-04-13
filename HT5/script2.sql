CREATE OR REPLACE TABLE `usac-ht5-retencion.usac_ht5_retencion.dim_cliente` AS
SELECT DISTINCT
    cliente_id,
    cliente_nombre,
    segmento_cliente
FROM `usac-ht5-retencion.usac_ht5_retencion.stage_ventas`;

CREATE OR REPLACE TABLE `usac-ht5-retencion.usac_ht5_retencion.dim_producto` AS
SELECT DISTINCT
    producto_nombre,
    marca,
    categoria,
    subcategoria
FROM `usac-ht5-retencion.usac_ht5_retencion.stage_ventas`;

CREATE OR REPLACE TABLE `usac-ht5-retencion.usac_ht5_retencion.dim_tiempo` AS
SELECT DISTINCT
    DATE(fecha) AS fecha,
    EXTRACT(YEAR FROM DATE(fecha)) AS anio,
    EXTRACT(MONTH FROM DATE(fecha)) AS mes,
    EXTRACT(DAY FROM DATE(fecha)) AS dia
FROM `usac-ht5-retencion.usac_ht5_retencion.stage_ventas`;

CREATE OR REPLACE TABLE `usac-ht5-retencion.usac_ht5_retencion.fact_ventas` AS
SELECT
    s.fecha,
    s.cliente_id,
    s.producto_nombre,
    s.precio_unitario,
    s.cantidad,
    s.total
FROM `usac-ht5-retencion.usac_ht5_retencion.stage_ventas` s;