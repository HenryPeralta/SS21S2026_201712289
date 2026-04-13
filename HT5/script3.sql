SELECT 
    t.anio,
    c.segmento_cliente,
    SUM(f.total) AS total_ventas
FROM `usac-ht5-retencion.usac_ht5_retencion.fact_ventas` f
JOIN `usac-ht5-retencion.usac_ht5_retencion.dim_cliente` c
    ON f.cliente_id = c.cliente_id
JOIN `usac-ht5-retencion.usac_ht5_retencion.dim_tiempo` t
    ON DATE(f.fecha) = t.fecha
GROUP BY t.anio, c.segmento_cliente;