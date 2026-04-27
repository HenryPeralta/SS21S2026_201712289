CREATE OR REPLACE TABLE `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
PARTITION BY pickup_date
CLUSTER BY split_col, payment_type, vendor_id
AS
SELECT
  pickup_date,
  vendor_id,
  passenger_count,
  trip_distance,
  pickup_location_id,
  dropoff_location_id,
  payment_type,
  fare_amount,
  tip_amount,

  -- NUEVAS FEATURES
  TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) AS trip_duration_minutes,
  EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,
  EXTRACT(DAYOFWEEK FROM pickup_datetime) AS pickup_day,

  SAFE_DIVIDE(tip_amount, fare_amount) AS tip_pct,

  -- SPLIT DATASET
  CASE
    WHEN pickup_date < '2022-03-01' THEN 'TRAIN'
    WHEN pickup_date < '2022-03-15' THEN 'EVAL'
    ELSE 'PREDICT'
  END AS split_col

FROM `proyecto2-taxi-201712289.proyecto2_taxi.taxi_trips_2022_optimized`;