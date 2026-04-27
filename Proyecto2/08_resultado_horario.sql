CREATE OR REPLACE TABLE `proyecto2-taxi-201712289.proyecto2_taxi.resultado_horario` AS
SELECT
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  COUNT(*) AS viajes,
  ROUND(AVG(total_amount),2) AS promedio
FROM `proyecto2-taxi-201712289.proyecto2_taxi.taxi_trips_2022_optimized`
GROUP BY pickup_hour;