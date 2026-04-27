SELECT *
FROM ML.EVALUATE(
  MODEL `proyecto2_taxi.modelo_boosted_tuned`,
  (
    SELECT *
    FROM `proyecto2_taxi.ml_features`
    WHERE split_col = 'EVAL'
  )
);