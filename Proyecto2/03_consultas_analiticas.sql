-- SIN OPTIMIZAR
SELECT
  DATE(pickup_datetime) AS pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;

-- OPTIMIZADA
SELECT
  pickup_date,
  COUNT(*) AS trips,
  ROUND(SUM(total_amount), 2) AS revenue
FROM `proyecto2-taxi-201712289.proyecto2_taxi.taxi_trips_2022_optimized`
WHERE pickup_date BETWEEN '2022-07-01' AND '2022-09-30'
GROUP BY pickup_date
ORDER BY pickup_date;

-- Análisis horario
SELECT
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  COUNT(*) AS viajes,
  ROUND(AVG(total_amount),2) AS promedio
FROM `proyecto2-taxi-201712289.proyecto2_taxi.taxi_trips_2022_optimized`
GROUP BY pickup_hour
ORDER BY viajes DESC;

-- Top rutas
SELECT
  pickup_location_id,
  dropoff_location_id,
  COUNT(*) AS viajes,
  SUM(total_amount) AS ingresos
FROM `proyecto2-taxi-201712289.proyecto2_taxi.taxi_trips_2022_optimized`
GROUP BY pickup_location_id, dropoff_location_id
ORDER BY ingresos DESC
LIMIT 20;