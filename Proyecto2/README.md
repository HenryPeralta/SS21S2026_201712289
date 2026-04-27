# Proyecto 2 - Análisis y Modelado de NYC Taxi Trips 2022 en BigQuery ML

## Descripción del Proyecto
Este proyecto tiene como objetivo el análisis de datos de viajes de taxi en Nueva York durante el año 2022, utilizando **Google BigQuery** para procesamiento de datos y **BigQuery ML** para la creación de modelos predictivos.

Se desarrolló un flujo completo que incluye:
- Exploración de datos
- Optimización de tablas
- Consultas analíticas
- Feature Engineering
- Entrenamiento de modelos
- Evaluación y predicción

---

## Tecnologías Utilizadas
- Google Cloud Platform (GCP)
- BigQuery
- BigQuery ML
- SQL

---

## Estructura del Proyecto
```
SS21S2026_201712289/
└── Proyecto2/
    ├── images/
    ├── 00_create_dataset.sql
    ├── 01_exploracion_inicial.sql
    ├── 02_tabla_optimizada.sql
    ├── 03_consultas_analiticas.sql
    ├── 04_feature_engineering.sql
    ├── 05_modelo_regresion.sql
    ├── 06_evaluacion.sql
    ├── 07_predicciones.sql
    ├── 08_resultado_horario.sql
    └── 09_actual_vs_prediction_comparison.sql
```
---

## 1. Creación del Dataset

Se crea el esquema donde se almacenarán las tablas del proyecto.

**Script:**
`00_create_dataset.sql`

### Captura
- Dataset creado en BigQuery
![Creacion del Dataset](images/Query1.jpg)

---

## 2. Exploración Inicial de Datos

Se realizó un análisis exploratorio para comprender la estructura de los datos.

Incluye:
- Total de registros
- Rango de fechas
- Análisis por mes
- Análisis por tipo de pago

**Script:**
`01_exploracion_inicial.sql`

### Capturas

**Conteo y rango de fechas:**
![Conteo y rango de fechas](images/Query2_1.jpg)
**Análisis por mes:**
![Analisis por mes](images/Query2_2.jpg)
**Análisis por tipo de pago:**
![Analisis por tipo de pago](images/Query2_3.jpg)

---

## 3. Creación de Tabla Optimizada

Se creó una tabla optimizada utilizando:

- Particionamiento por `pickup_date`
- Clustering por:
  - vendor_id
  - pickup_location_id
  - dropoff_location_id
  - payment_type

También se limpiaron datos y se generaron nuevas columnas.

**Script:**
`02_tabla_optimizada.sql`

### Capturas

**Tabla creada:**
![Tabla creada](images/Query3_1.jpg)
**Datos con nuevas columnas:**
![Datos con nuevas columnas](images/Query3_2.jpg)
---

## 4. Consultas Analíticas

Se comparó el rendimiento entre consultas optimizadas y no optimizadas.

También se realizaron análisis adicionales:
- Viajes por fecha
- Análisis por hora
- Rutas más rentables

**Script:**
`03_consultas_analiticas.sql`

### Capturas

**Consultas Analíticas:**
![Consultas Analiticas](images/Query4_analisis_horario.jpg)
**Consulta Optimizada:**
![Consulta Optimizada](images/Query4_optimizado_resultado.jpg)
**Bytes Procesados:**
![Bytes Procesados](images/Query4_optimmizado.jpg)
**Consulta Sin Optimizacion:**
![Consulta Sin Optimizacion](images/Query4_sin_optimizar_resultado.jpg)
**Bytes Procesados Sin Optimizar:**
![Bytes Procesados Sin Optimizar](images/Query4_sin_optimizar.jpg)
**Top rutas:**
![Top rutas](images/Query4_top_rutas.jpg)
---

## 5. Feature Engineering

Se creó una tabla para Machine Learning con nuevas variables relevantes.

Incluye:
- Duración del viaje
- Hora
- Día
- Porcentaje de propina
- División de datos (TRAIN / EVAL / PREDICT)

**Script:**
`04_feature_engineering.sql`

### Capturas

**Bytes Procesados Tabla ml_features:**
![Bytes Procesados Tabla ml_features](images/Query5_1.jpg)
**Tabla ml_features:**
![Tabla ml_features](images/Query5_2.jpg)
---

## 6. Entrenamiento de Modelos

Se entrenaron dos modelos:

- Regresión Lineal
- Boosted Trees

**Script:**
`05_modelo_regresion.sql`

### 📸 Capturas

**Modelo 1 Regresión Lineal:**
![Modelo 1 Regresion Lineal bytes](images/Query6_1.jpg)
![Modelo 1 Regresion Lineal](images/Query6_2.jpg)

**Modelo 2 Regresión Boosted Trees:**
![Modelo 1 Regresion Boosted Trees bytes](images/Query6_3.jpg)
![Modelo 1 Regresion Boosted Trees](images/Query6_4.jpg)

---

## 7. Evaluación de Modelos

Se evaluaron los modelos utilizando métricas:

- MAE
- RMSE
- R²

**Script:**
`06_evaluacion.sql`

### Capturas

**Modelo Lineal:**
![Modelo Lineal](images/Query7_1.jpg)
**Modelo Boosted:**
![Modelo Boosted](images/Query7_2.jpg)
---

## 8. Predicciones

Se generaron predicciones utilizando el modelo Boosted Trees.

**Script:**
`07_predicciones.sql`

### Captura
![Predicciones](images/Query8_1.jpg)
---

## 9. Análisis de Resultados

### Resultado por Hora

**Script:**
`08_resultado_horario.sql`

### Captura
![Resultado por Hora](images/Query9.jpg)
---

### Comparación Real vs Predicción

Se calculó el error del modelo.

**Script:**
`09_actual_vs_prediction_comparison.sql`

### Captura
![Comparacion Real vs Prediccion](images/Query10.jpg)

---

## Visualización de Datos con Looker Studio

Para complementar el análisis exploratorio y los resultados del modelo, se desarrolló un dashboard interactivo utilizando Looker Studio, el cual permite interpretar de forma visual los patrones de los viajes y el comportamiento del modelo predictivo.

### 🔹 Gráficos generados

#### 1. Viajes por hora
Este gráfico muestra la cantidad de viajes agrupados por hora del día.  
Se observa que las horas pico se concentran en la tarde-noche, especialmente entre las 17:00 y 19:00 horas, lo cual coincide con horarios de mayor movilidad urbana.

#### 2. Promedio de tarifa por hora
Se presenta el valor promedio de las tarifas en función de la hora del día.  
Se identifican variaciones importantes, con picos en ciertas horas que pueden estar relacionados con la demanda o condiciones del servicio.

#### 3. Propina real vs predicción
Este gráfico compara los valores reales de propina (`tip_amount`) con los valores predichos por el modelo.  
Se observa que el modelo sigue la tendencia general de los datos reales, lo que indica un buen desempeño en términos generales.

#### 4. Error del modelo vs distancia
Se analiza la relación entre la distancia del viaje (`trip_distance`) y el error de predicción.  
Se observa que el error tiende a incrementarse en viajes más largos, lo que sugiere oportunidades de mejora en el modelo.

---

### Likl a Loocker Studio
```
https://datastudio.google.com/reporting/81a5c3da-322f-4ae7-85d3-2628b1c6bc69
```

---

### Graficas

![Graficos](images/Graficos.jpg)

---

## Comparación de Costos

| Tipo de Consulta | Bytes Procesados |
|------------------|----------------|
| Sin optimizar    | 829.85           |
| Optimizada       | 202.1           |

---

## Conclusiones

- La optimización reduce significativamente costos y tiempo de ejecución.
- El modelo Boosted Trees ofrece mejores resultados que la regresión lineal.
- Variables como distancia, tarifa y hora influyen en la propina.
- BigQuery ML facilita la implementación de modelos directamente en SQL.
- El uso de herramientas de visualización permitió identificar patrones clave en los datos y evaluar el desempeño del modelo de forma intuitiva, facilitando la interpretación de resultados y el análisis del comportamiento del sistema.
