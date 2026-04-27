-- Modelo 1: Regresión Lineal
CREATE OR REPLACE MODEL `proyecto2-taxi-201712289.proyecto2_taxi.modelo_lineal`
OPTIONS(
  model_type='LINEAR_REG',
  input_label_cols=['tip_amount']
) AS
SELECT *
FROM `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
WHERE split_col='TRAIN';


-- Modelo 2: Boosted Trees
CREATE OR REPLACE MODEL `proyecto2-taxi-201712289.proyecto2_taxi.modelo_boosted`
OPTIONS(
  model_type='BOOSTED_TREE_REGRESSOR',
  input_label_cols=['tip_amount']
) AS
SELECT *
FROM `proyecto2-taxi-201712289.proyecto2_taxi.ml_features`
WHERE split_col='TRAIN';