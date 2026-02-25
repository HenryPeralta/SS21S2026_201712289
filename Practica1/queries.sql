USE DW_Vuelos;
GO

/* 1. TOTAL DE VUELOS */

SELECT COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos;
GO

/* 2. TOP 5 DESTINOS MÁS FRECUENTES */

SELECT TOP 5
    D.airport_code AS Destino,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Aeropuerto D 
    ON F.id_destino = D.id_aeropuerto
GROUP BY D.airport_code
ORDER BY Total_Vuelos DESC;
GO

/* 3. DISTRIBUCIÓN DE VUELOS POR GÉNERO */

SELECT 
    P.passenger_gender,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Pasajero P
    ON F.id_pasajero = P.id_pasajero
GROUP BY P.passenger_gender;
GO

/* 4. VUELOS POR AEROLÍNEA */

SELECT 
    A.airline_name,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Aerolinea A
    ON F.id_aerolinea = A.id_aerolinea
GROUP BY A.airline_name
ORDER BY Total_Vuelos DESC;
GO

/* 5. INGRESOS TOTALES POR AEROLÍNEA */

SELECT 
    A.airline_name,
    SUM(F.ticket_price_usd_est) AS Ingresos_Totales_USD
FROM Fact_Vuelos F
INNER JOIN Dim_Aerolinea A
    ON F.id_aerolinea = A.id_aerolinea
GROUP BY A.airline_name
ORDER BY Ingresos_Totales_USD DESC;
GO

/* 6. VUELOS POR MES Y AÑO */

SELECT 
    DF.anio,
    DF.mes,
    DF.nombre_mes,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Fecha DF
    ON F.id_fecha_salida = DF.id_fecha
GROUP BY DF.anio, DF.mes, DF.nombre_mes
ORDER BY DF.anio, DF.mes;
GO

/* 7. PROMEDIO DE DURACIÓN DE VUELO POR AEROLÍNEA */

SELECT 
    A.airline_name,
    AVG(F.duration_min) AS Duracion_Promedio_Minutos
FROM Fact_Vuelos F
INNER JOIN Dim_Aerolinea A
    ON F.id_aerolinea = A.id_aerolinea
GROUP BY A.airline_name
ORDER BY Duracion_Promedio_Minutos DESC;
GO

/* 8. PROMEDIO DE RETRASO POR ESTADO DEL VUELO */

SELECT 
    E.status,
    AVG(F.delay_min) AS Retraso_Promedio_Minutos
FROM Fact_Vuelos F
INNER JOIN Dim_EstadoVuelo E
    ON F.id_estado = E.id_estado
GROUP BY E.status
ORDER BY Retraso_Promedio_Minutos DESC;
GO

/* 9. VUELOS POR CANAL DE VENTA */

SELECT 
    V.sales_channel,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Venta V
    ON F.id_venta = V.id_venta
GROUP BY V.sales_channel
ORDER BY Total_Vuelos DESC;
GO

/* 10. TOP 5 PASAJEROS CON MÁS VUELOS */

SELECT TOP 5
    P.passenger_id,
    COUNT(*) AS Total_Vuelos
FROM Fact_Vuelos F
INNER JOIN Dim_Pasajero P
    ON F.id_pasajero = P.id_pasajero
GROUP BY P.passenger_id
ORDER BY Total_Vuelos DESC;
GO