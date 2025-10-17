--1. Which is the largest NEO (by max diameter) per year?
 WITH max_dia AS(
    SELECT
    neo_id, year, estimated_diameter_max,
    RANK () OVER (PARTITION BY year ORDER BY estimated_diameter_max DESC) rnk
    FROM neo2)
SELECT year, neo_id, ROUND(estimated_diameter_max, 2) 'estimated diameter max'
FROM max_dia
WHERE rnk = 1
ORDER BY estimated_diameter_max DESC;

--2. How does miss distance change year-over-year for the fastest object per year?
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
SELECT DISTINCT year, AVG(miss_distance) OVER (PARTITION BY year) avg_miss_yr, 
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


    
