SELECT
  tip_amount,
  predicted_tip_amount,
  trip_distance,
  fare_amount
FROM ML.PREDICT(
  MODEL `proyecto2-taxi-201712289.proyecto2_taxi.modelo_boosted`,
  (
    SELECT *
    FROM `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
    WHERE split_col='PREDICT'
  )
);