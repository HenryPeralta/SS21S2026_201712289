-- Evaluación modelo lineal
SELECT *
FROM ML.EVALUATE(
  MODEL `proyecto2-taxi-201712289.proyecto2_taxi.modelo_lineal`,
  (
    SELECT *
    FROM `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
    WHERE split_col='EVAL'
  )
);


-- Evaluación modelo boosted
SELECT *
FROM ML.EVALUATE(
  MODEL `proyecto2-taxi-201712289.proyecto2_taxi.modelo_boosted`,
  (
    SELECT *
    FROM `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
    WHERE split_col='EVAL'
  )
);