Naravno — evo profesionalne, GitHub-standard verzije **README.md** (spremne za direktno postavljanje na repozitorijum):

---

# NEO-NASA-Analysis

**Exploratory analysis of NASA Near-Earth Objects (NEO) dataset using SQL and Tableau**

## Overview

This project analyzes NASA’s **Near-Earth Objects (1910–2024)** dataset containing over **330,000 asteroid records**. The objective was to clean, structure, and explore the data to identify temporal and physical patterns in NEO velocity, size, and hazard classification. Analytical insights were visualized through interactive Tableau dashboards.

---

## Dataset

* **Source:** [NASA Nearest Earth Objects (1910–2024)](https://www.kaggle.com/datasets/ivansher/nasa-nearest-earth-objects-1910-2024)
* **Total Entries:** 338,199

| Feature                                            | Description                                                    |
| -------------------------------------------------- | -------------------------------------------------------------- |
| `neo_id`                                           | Unique identifier for each asteroid                            |
| `name`                                             | Official name assigned by NASA                                 |
| `absolute_magnitude`                               | Intrinsic brightness (lower value indicates higher luminosity) |
| `estimated_diameter_min`, `estimated_diameter_max` | Minimum and maximum estimated diameter (km)                    |
| `orbiting_body`                                    | Celestial body orbited by the object                           |
| `relative_velocity`                                | Velocity relative to Earth (km/h)                              |
| `miss_distance`                                    | Minimum approach distance from Earth (km)                      |
| `is_hazardous`                                     | Boolean indicator of potential hazard                          |

---

## Methodology

* **Data Cleaning:** Removed nulls and duplicates, standardized fields, and created a `year` column extracted from object names (`SUBSTR`, `INSTR`).
* **Exploratory Analysis:** Aggregated data to assess yearly object counts, diameter trends, and hazard ratios.
* **Advanced SQL:** Applied `CTE`, `RANK()`, `LAG()`, and `SUM() OVER` for temporal and comparative analysis.
* **Visualization:** Designed Tableau dashboards to illustrate key findings and long-term patterns.

---

## Tools & Technologies

**SQL** – Data preprocessing, aggregation, and analytical querying
**Tableau** – Interactive dashboards and visual storytelling
**SQLite / PostgreSQL** – Query execution and performance testing

---

## Key Insights

* Identified yearly variations in NEO velocity and size distribution.
* Measured frequency and proportion of hazardous objects over time.
* Highlighted top 10 closest Earth encounters and high-risk years.
