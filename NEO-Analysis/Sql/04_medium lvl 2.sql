1. Which is the largest NEO (by max diameter) per year?
```sql
 WITH max_dia AS(
    SELECT
    neo_id, year, estimated_diameter_max,
    RANK () OVER (PARTITION BY year ORDER BY estimated_diameter_max DESC) rnk
    FROM neo2)
SELECT year, neo_id, ROUND(estimated_diameter_max, 2) 'estimated diameter max'
FROM max_dia
WHERE rnk = 1
ORDER BY estimated_diameter_max DESC;
```
2. How does miss distance change year-over-year for the fastest object per year?

 WITH fast_cte AS(
    SELECT neo_id, year, miss_distance,
    RANK () OVER (PARTITION BY year ORDER BY rel_velocity DESC) rnk
    FROM neo2
 )
 SELECT year, miss_distance, miss_distance - LAG(miss_distance) OVER (ORDER BY year) yoy_dif
FROM fast_cte
WHERE rnk = 1
ORDER BY year;

--3. Which objects had a smaller miss distance than the previous one in the same year?
WITH miss_cte AS(
SELECT year, neo_id, miss_distance, (ROUND(miss_distance - LAG(miss_distance) OVER (PARTITION BY year ORDER BY neo_id),2)) yoy
FROM neo2)
SELECT neo_id, yoy
FROM miss_cte 
WHERE yoy < 0
ORDER BY yoy 
LIMIT 10;

--4. Top 5 fastest objects per year?
 WITH speed_cte AS(
    SELECT
    neo_id, year, rel_velocity,
    RANK () OVER (PARTITION BY year ORDER BY rel_velocity DESC) rnk
    FROM neo2)
SELECT year, neo_id, rel_velocity
FROM speed_cte
WHERE rnk BETWEEN 1 AND 5
ORDER BY year, rel_velocity DESC;

--5. What is the average miss distance per year compared to the overall average miss distance?
SELECT year, AVG(miss_distance) OVER (PARTITION BY year) avg_miss_yr, 
AVG(miss_distance) OVER () avg_miss, 
(AVG(miss_distance) OVER (PARTITION BY year) -  AVG(miss_distance) OVER ()) compared
FROM neo2
ORDER BY compared DESC;

--6. Cumulative count of hazardous objects over time?
WITH hazard_cte AS(
    SELECT year, COUNT(*) cnt
    FROM neo2
    WHERE is_hazardous = 'True'
    GROUP BY year)
SELECT year, cnt, SUM(cnt) OVER (ORDER BY year)
FROM hazard_cte;

--7. Which object had the biggest increase in velocity compared to the previous object in the same year?
WITH vel_cte AS(
    SELECT 
        year, neo_id, rel_velocity, 
        (rel_velocity - LAG(rel_velocity, 1, rel_velocity) OVER (PARTITION BY year ORDER BY neo_id)) diff
    FROM neo2)
SELECT 
    year, neo_id, diff, 
    RANK () OVER (ORDER BY diff DESC) rnk
FROM vel_cte
LIMIT 1;

--8. Which year had the most NEOs ranked in the top 10 closest encounters of all time?
WITH close_cte AS(
    SELECT neo_id, year, miss_distance, 
    RANK() OVER (ORDER BY miss_distance) rnk
    FROM neo2
) SELECT year, COUNT(rnk) OVER (PARTITION BY year) cnt 
FROM close_cte
WHERE rnk <= 10
ORDER BY cnt DESC
LIMIT 1;

--9. Find the average speed of the top 3 brightest objects per year (lowe magnitude = brighter object).
WITH bright_cte AS(
    SELECT year, absolute_magnitude, RANK() OVER (PARTITION BY year ORDER BY absolute_magnitude) rnk
    FROM neo2
    )
SELECT year, ROUND(AVG(absolute_magnitude), 2)
FROM bright_cte
WHERE rnk BETWEEN 1 AND 3
GROUP BY year;

--10. Total number of Hazardous NEOs per distance categories
-- First we need to find out categories, we shall use bins
WITH bins AS (
  SELECT
    neo_id,
    miss_distance,
    NTILE(5) OVER (ORDER BY miss_distance) AS bin_id
  FROM neo2
)
SELECT
  bin_id, COUNT(*) n_rows, MIN(miss_distance) bin_min, MAX(miss_distance) bin_max
FROM bins
GROUP BY bin_id
ORDER BY bin_id;

/* result of the first query
bin_id  n_rows  bin_min           bin_max
------  ------  ----------------  ----------------
1       6701    6745.532515957    2899020.51613121
2       6701    2899165.28199001  7102051.37722062
3       6701    7102445.49280913  14457288.9065736
4       6700    14458093.3990391  29061455.7096346
5       6700    29063481.6986283  74788325.6237781
*/

SELECT 
    CASE 
        WHEN miss_distance <= 2900000 THEN 'Very Close'
        WHEN miss_distance <= 7100000 THEN 'Close'
        WHEN miss_distance <= 14400000 THEN 'Moderate'
        WHEN miss_distance <= 29000000 THEN 'Far'
        ELSE 'Very Far'
    END AS distance_category,
    COUNT(*) AS count_objects,
    is_hazardous
FROM neo2
GROUP BY distance_category, is_hazardous
ORDER BY COUNT(*) DESC;

-- 11. Top 10 Closest Approaches to Earth (1910–2024)
WITH close_cte AS (
    SELECT 
    neo_id, name, year, is_hazardous, rel_velocity, miss_distance, 
    RANK() OVER (ORDER BY miss_distance) rnk
    FROM neo2)
SELECT *
FROM close_cte
WHERE rnk BETWEEN 1 AND 10;
