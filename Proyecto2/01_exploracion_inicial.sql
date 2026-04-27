-- Exploración inicial
SELECT
  COUNT(*) AS total_rows,
  MIN(pickup_datetime) AS min_pickup,
  MAX(pickup_datetime) AS max_pickup
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`;

-- Por mes
SELECT
  EXTRACT(MONTH FROM pickup_datetime) AS month,
  COUNT(*) AS trips,
  ROUND(AVG(total_amount),2) AS avg_amount
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) BETWEEN '2022-01-01' AND '2022-03-31'
GROUP BY month
ORDER BY month;

-- Por tipo de pago
SELECT
  payment_type,
  COUNT(*) AS trips,
  ROUND(AVG(tip_amount),2) AS avg_tip
FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`
WHERE DATE(pickup_datetime) BETWEEN '2022-01-01' AND '2022-03-31'
GROUP BY payment_type;