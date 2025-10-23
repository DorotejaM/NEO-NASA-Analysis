/*1. Hazard Rate by Distance Quantiles
Divide miss_distance into five equal-frequency quantiles. For each quantile, calculate:
total number of NEOs,
number of hazardous NEOs,
hazard rate (%),
minimum and maximum miss distance values.*/


/*2. Year-over-Year Change in Hazard Rate
For each year, calculate the hazard rate (hazard / total). Then, compute the year-over-year change in percentage points.
Expected output: year, hazard_rate, yoy_change_pp.*/

/*3. Spearman Rank Correlation of Velocity and Distance per Year
For each year, compute the Spearman correlation coefficient (ρ) between rel_velocity and miss_distance, using ranking and the standard Spearman formula.
Output: year, spearman_rho (ranging from -1 to 1).*/

/*4. Velocity Outliers per Year (±3σ)
For each year, calculate the mean (μ) and standard deviation (σ) of rel_velocity, then identify objects with |z| ≥ 3.
Output: top 50 outliers with year, neo_id, z-score.*/

/*5. Top-k with Ties
For each year, return the top 5 fastest NEOs based on rel_velocity, including any objects that share the 5th rank (ties).
Expected output: year, neo_id, rel_velocity.*/

/*6. Odds by Distance Quintile
Based on the quantiles of miss_distance from task #1, calculate the odds ratio of being hazardous (hazard / non-hazard) for each quintile.
Output: quantile, n_hazard, n_nonhazard, odds.*/

/*7. Median and IQR per Year (Robust Statistics)
Without using PERCENTILE_CONT, compute the median and interquartile range (IQR) of miss_distance for each year using ranking or NTILE techniques.
Output: year, median, q1, q3, iqr.*/

/*8. Nearest Neighbor Gap within the Same Year
Within each year, sort NEOs by miss_distance, and calculate the gap (difference in distance) to the next-closest object.
Output: year, neo_id, miss_distance, next_neo, gap_km.*/

/*9. Hazard Rate by Diameter Buckets
Create custom bins for average diameter ((estimated_diameter_min + estimated_diameter_max)/2), e.g. ≤0.2 km, 0.2–0.5 km, 0.5–1 km, 1–3 km, >3 km.
For each bin, calculate: total count, hazard rate, and average velocity.
Output: 5 bins with summary metrics.*/

/*10. Year with the Most NEOs in the Top-10 Closest Encounters
Rank all NEOs globally by miss_distance and find which year appears most often among the top 10 closest encounters.
Output: year, count, list of corresponding NEO IDs.*/

/*11. Rolling 3-Year Hazard Odds Trend
For each year, calculate the odds (hazard / non-hazard) and then compute a 3-year rolling average.
Output: year, odds, odds_rolling3.*/

/*12. Velocity–Distance Trade-off across Magnitude Quintiles
Divide absolute_magnitude into quintiles (Q1–Q5). For each quintile, calculate:

mean rel_velocity,

mean miss_distance,

correlation between the two.
Note: lower absolute_magnitude means higher brightness.*/