# NEO-NASA-Analysis

**Exploratory analysis of NASA Near-Earth Objects (NEO) dataset using SQL and [Tableau](https://public.tableau.com/views/AnalyzingNASAsNear-EarthObjects19102024/Story1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link).**

All analysis and visualizations were completed without AI assistance, all analytical and coding work was done manually.


## Quick Summary

- **Dataset:** 338,199 NEO records (1910–2024)
- **Analysis:** 32 SQL queries spanning 4 complexity levels
- **Key Finding:** Hazardous NEOs travel 43% faster than non-hazardous (avg. 73.4K km/h vs 51.2K km/h)
- **Dashboard:** 5-slide interactive Tableau story with dynamic filters
- **Closest Approach:** 2020 VT4 at 6,746 km (2020)


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

**Exploratory Analysis:**
- Aggregated data by year, hazard status, velocity, and distance categories
- Identified temporal trends, distribution patterns, and statistical outliers

**Advanced SQL Techniques:**
- **CTEs (Common Table Expressions):** Multi-step queries for complex aggregations
- **Window Functions:** `RANK()`, `LAG()`, `SUM() OVER`, `NTILE()` for ranking, trending, and quantile analysis
- **Partitioning:** `PARTITION BY year` and `PARTITION BY is_hazardous` for comparative analysis
- **Performance Optimization:** Efficient quantile creation using `NTILE()` vs. manual binning

**Visualization:**
- Designed Tableau dashboards to illustrate key findings and long-term patterns with interactive storytelling

---

## SQL Analysis Highlights

**Query Complexity Breakdown:**

- **Easy (10 queries):** Basic aggregation, filtering, descriptive statistics (COUNT, AVG, MIN, MAX, GROUP BY)
- **Medium (12 queries):** CTEs, window functions (`RANK()`, `LAG()`), multi-year trend analysis, percentage calculations
- **Hard (8 queries):** Advanced window functions for ranking within partitions, cumulative sums, year-over-year comparisons, velocity/distance filtering
- **Advanced (2 queries):** Quantile-based binning with `NTILE()`, hazard rate calculations across distance categories, year-over-year percentage point changes

**Performance Optimizations:**
- Used `PARTITION BY year` to reduce data scanned for yearly aggregations
- Applied `NTILE(5)` for efficient quantile creation instead of manual binning
- Leveraged joins and CTEs to avoid redundant calculations

---

## Tools & Technologies

**SQL** – Data preprocessing, aggregation, and analytical querying
**Tableau** – Interactive dashboards and visual storytelling
**Database Engines** – SQLite / PostgreSQL for query execution and validation

---

## Key Insights

- **2,616 hazardous NEOs detected** (18.2% of total 14,335 objects)
- **Sharp rise in detection after 2000** – cumulative hazardous objects increased 400% due to improved telescope technology and expanded survey coverage
- **Velocity correlation:** Hazardous objects average 73,420 km/h vs. 51,240 km/h for non-hazardous (**43% faster**)
- **Largest NEO recorded:** 1866 Sisyphus (1972 XA) with estimated diameter of **13.48 km**
- **Closest approach:** 2020 VT4 passed within **6,746 km** of Earth (2020)
- **Year 1976 peak:** 117 close encounters (miss distance < 100,000 km) – highest in dataset
- **Non-hazardous dominance:** Only 5 years (1926–1929) had 100% non-hazardous objects due to limited detection capabilities

---

## Tableau Dashboard Features

**5-Slide Interactive Story:**

1. **Overview of NASA NEO Dataset** – KPI cards showing total objects, hazardous percentage, average velocity, and cumulative trend
2. **Top 10 Closest Encounters with Earth** – Bar chart with object names and miss distances; interactive filters by year and hazard status
3. **Hazardous Objects Over Time** – Stacked bar chart showing hazardous vs. non-hazardous count trend (1925–2024) with insight annotations
4. **Yearly Velocity Trends by Hazard Status** – Dual-line chart with trend lines showing hazardous objects consistently faster, includes confidence bands
5. **Distance Categories & Hazard Distribution** – Stacked histogram by miss distance bins (Very Close, Close, Moderate, Far, Very Far) with drill-down capability

**Interactive Features:**
- **Filters:** Year range (1925–2024), Hazard status (True/False/All), Miss distance categories
- **Drill-down:** Click from yearly aggregates to view individual object details
- **Calculated Fields:** Dynamic distance categories, velocity percentiles, hazard rate percentages
- **Annotations:** Key insights and anomalies highlighted directly on visualizations

---

## File Structure

```
NEO-NASA-Analysis/
├── SQL/
│ ├── 00_cleaning.sql # Data validation, NULL handling, deduplication
│ ├── 01_easy.sql # 10 basic aggregation queries
│ ├── 02_medium.sql # 12 CTE and window function queries
│ ├── 03_hard.sql # 8 advanced partition/ranking queries
│ └── 04_advanced.sql # 2 quantile binning and YoY analysis queries
├── Data/
│ └── neo_nasa.csv # Raw excel (338,199 records)
├── NEO.twbx # Tableau workbook (interactive dashboards)
└── README.md # Project documentation

```

---

## Recommendations for Stakeholders

1. **Increase monitoring** for Q3–Q4 periods when close encounter frequency peaks
2. **Focus tracking on** objects with diameter > 1 km and miss distance < 100,000 km
3. **International coordination** recommended for 2020 VT4-class near-Earth approaches
4. **Technology upgrade** – detection rate correlates directly with telescope technology advances; continued investment justified

---

## How to Use This Project

1. **Review SQL queries** in the `/SQL` folder to see data exploration techniques
2. **Access raw data** in `/Data/neo_dataset.csv`
3. **Explore dashboards** via [Tableau Public link](https://public.tableau.com/views/AnalyzingNASAsNear-EarthObjects19102024/Story1)
4. **Replicate analysis** by running SQL queries in SQLite or PostgreSQL against the dataset

---

## Links

- **[Tableau Interactive Dashboard](https://public.tableau.com/views/AnalyzingNASAsNear-EarthObjects19102024/Story1)** – Full 5-slide story with filters and drill-down
- **[GitHub Repository](https://github.com/DorotejaM/NEO-NASA-Analysis)** – All SQL queries and documentation
- **[NASA NEO Dataset (Kaggle)](https://www.kaggle.com/datasets/ivansher/nasa-nearest-earth-objects-1910-2024)** – Source data
