CREATE OR REPLACE MODEL `proyecto2_taxi.modelo_boosted_tuned`
OPTIONS(
  model_type='BOOSTED_TREE_REGRESSOR',
  input_label_cols=['tip_amount'],
  max_iterations=50,
  max_tree_depth=8,
  subsample=0.8,
  learn_rate=0.1
) AS

SELECT
  tip_amount,
  trip_distance,
  fare_amount,
  pickup_hour,
  pickup_day,
  trip_duration_minutes
FROM `proyecto2_taxi.ml_features`
WHERE split_col = 'TRAIN';