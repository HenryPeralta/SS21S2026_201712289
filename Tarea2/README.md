# Tarea 2 – Análisis de Datos con Power BI

# Descripción del Dataset

El dataset utilizado corresponde a un catálogo de contenido disponible en Netflix. Este conjunto de datos contiene información sobre películas y series que se encuentran en la plataforma, incluyendo datos como el título, tipo de contenido, país de origen, año de lanzamiento, clasificación por edad, entre otros.

Este dataset permite realizar diferentes análisis para comprender la distribución del contenido disponible en Netflix, así como identificar tendencias relacionadas con la producción y clasificación del contenido.

Entre los principales campos del dataset se encuentran:

* **show_id:** identificador único del contenido
* **type:** tipo de contenido (Movie o TV Show)
* **title:** título del contenido
* **director:** director de la producción
* **country:** país de origen
* **release_year:** año de lanzamiento
* **rating:** clasificación por edad

---

# Transformaciones Realizadas

Antes de realizar el análisis en Power BI se realizaron algunas transformaciones para limpiar y preparar los datos. Estas transformaciones se llevaron a cabo utilizando **Power Query**.

Las principales transformaciones fueron:

* **Eliminación de columnas innecesarias:**
  Se eliminaron columnas que no eran relevantes para el análisis, como por ejemplo la columna de descripción del contenido.

* **Manejo de valores nulos:**
  Se identificaron valores vacíos en algunas columnas del dataset y se reemplazaron con el valor **"Unknown"** para evitar problemas durante el análisis.

* **Revisión de tipos de datos:**
  Se verificó que cada columna tuviera el tipo de dato adecuado (texto, número, etc.) para garantizar que las visualizaciones funcionaran correctamente.

Estas transformaciones permiten que el dataset sea más limpio, consistente y adecuado para su análisis en Power BI.

![Transformacion](images/transformacion2.jpg)

---

# Dashboard

Se desarrolló un dashboard en Power BI con diferentes visualizaciones que permiten analizar el contenido disponible en Netflix.

A continuación se muestra una captura del dashboard:

![Dashboard](images/dashboard5.jpg)

Las visualizaciones incluidas en el dashboard son:

1. **Total de títulos en Netflix**
   Indicador que muestra el número total de registros presentes en el dataset.

2. **Cantidad de contenido por tipo**
   Gráfico que compara la cantidad de películas y series disponibles.

3. **Top países con mayor cantidad de contenido**
   Visualización que muestra los países con mayor producción de contenido disponible en Netflix.

4. **Contenido por año de lanzamiento**
   Gráfico que permite observar cómo ha evolucionado la producción de contenido a lo largo del tiempo.

5. **Distribución de clasificaciones de contenido**
   Visualización que muestra la distribución del contenido según su clasificación por edad.

---

# Interpretación de KPIs

A partir del análisis realizado mediante el dashboard se pueden identificar algunos hallazgos importantes:

* El dataset contiene aproximadamente **8,809 títulos** disponibles en la plataforma.
* La mayor parte del contenido corresponde a **películas**, mientras que las series representan una menor proporción.
* **Estados Unidos** es el país con mayor cantidad de contenido dentro del dataset analizado.
* Se observa un crecimiento significativo en la producción de contenido a partir del año **2015**.
* La clasificación **TV-MA** es una de las más comunes, lo que indica una alta presencia de contenido dirigido a audiencias adultas.

Estos indicadores permiten comprender mejor la distribución del contenido disponible en Netflix y observar tendencias relacionadas con la producción de películas y series.

---

# Estructura del Proyecto

El repositorio contiene la siguiente estructura:

```
SS21S2026_201712289/
└── Tarea2/
    ├── tarea2_semi2.pbix
    ├── netflix_titles.csv
    ├── README.md
    └── images/
```

* **tarea2_semi2.pbix:** archivo del dashboard desarrollado en Power BI.
* **README.md:** documentación del análisis realizado.
* **netflix_titles.csv:** arcchivo csv con los datos obtenidos en Kaggle.

---

# Conclusión

El uso de Power BI permitió realizar un análisis visual del dataset de Netflix de manera clara y sencilla. Mediante la limpieza de datos y la creación de visualizaciones se pudieron identificar patrones en la producción y clasificación del contenido.

Este tipo de herramientas facilita la interpretación de grandes volúmenes de información y permite generar insights útiles para la toma de decisiones basada en datos.
