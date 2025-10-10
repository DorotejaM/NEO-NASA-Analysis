-- 1. What is the percentage of hazardous objects relative to the total number per year?
WITH hazardous_cte AS (
SELECT year, COUNT(*) hazardous
FROM neo2
WHERE is_hazardous = 'True'
GROUP BY year),
total_num AS (
SELECT year, COUNT(*) total
FROM neo2
GROUP BY year)
SELECT h.year, CONCAT(ROUND(CAST(h.hazardous AS FLOAT)/CAST(t.total AS FLOAT)*100, 3), '%') '% of hazard objects'
FROM hazardous_cte h
JOIN total_num t ON h.year=t.year
-- WHERE ROUND(CAST(h.hazardous AS FLOAT)/CAST(t.total AS FLOAT)*100, 3) = 100.0
ORDER BY h.year DESC;

-- 2. Which year had the highest number of objects with a maximum diameter greater than 500 meters?
SELECT year, COUNT(*)
FROM neo2
WHERE estimated_diameter_max > 0.5
GROUP BY year
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 3. Which year had the highest average speed of objects that passed closer than 1,000,000 km?
WITH closer_cte AS(
SELECT year, AVG(rel_velocity) rel
FROM neo2
WHERE  miss_distance <  1000000
GROUP BY year)
SELECT year, ROUND(rel, 2) highest_average_speed
FROM closer_cte
ORDER BY rel DESC
LIMIT 1;

-- 4. Which 3 years had the lowest average miss distance among hazardous objects?
SELECT year, AVG(miss_distance) avg_miss
FROM neo2
WHERE is_hazardous = 'True'
GROUP BY year
ORDER BY avg_miss
LIMIT 3;

-- 5. What is the difference in average brightness (absolute_magnitude) between hazardous and non-hazardous objects?
WITH hazardous_cte AS (
SELECT AVG(absolute_magnitude) am
FROM neo2
WHERE is_hazardous = 'True'
), no_hazardous_cte AS (
SELECT AVG(absolute_magnitude) am
FROM neo2
WHERE is_hazardous = 'False'
) SELECT ROUND(ABS(h.am-n.am), 2) brightness_diff
FROM hazardous_cte h, no_hazardous_cte n;

-- 6. What are the typical velocity values for objects with extremely large diameters (e.g. over 1 km)?
SELECT ROUND(AVG(rel_velocity), 2) avg_velocity
FROM neo2
WHERE estimated_diameter_max > 1;

-- !!!! 7. Is there any year in which all objects were classified as non-hazardous? !!!!
SELECT year, SUM(is_hazardous = 'True') sum_haz
FROM neo2
GROUP BY year
HAVING sum_haz = 0;

-- 8. Which years had more than 10 objects with relative_velocity over 100,000 km/h? 
WITH vel_cte AS (
    SELECT year, COUNT(*) count
    FROM neo2
    WHERE rel_velocity > 100000
    GROUP BY year
) SELECT year, count
FROM vel_cte
WHERE count > 10
ORDER BY count DESC;

-- 9. How many years had more than 10 objects that passed closer than 100,000 km?
WITH closer_cte AS (
    SELECT year, COUNT(*) count
    FROM neo2
    WHERE miss_distance < 100000
    GROUP BY year
) 
SELECT COUNT(*)
FROM closer_cte
WHERE count > 10;

-- 10. Which year had the highest average diameter among hazardous objects?
WITH haz_cte AS (
    SELECT year, AVG((estimated_diameter_min+estimated_diameter_max)/2) avg_dia
    FROM neo2
    WHERE is_hazardous = 'True'
    GROUP BY year
)
SELECT year, avg_dia
FROM haz_cte
ORDER BY avg_dia DESC
LIMIT 1;

-- 11. Which year had the lowest average brightness (i.e. highest absolute_magnitude value)?
WITH avg_brigh_cte AS (
    SELECT year, AVG(absolute_magnitude) am
    FROM neo2
    GROUP BY year
) SELECT year
FROM avg_brigh_cte
ORDER BY am DESC
LIMIT 1;

-- 12. Which year had the most objects with a diameter between 1 and 3?
WITH dia_cte AS (
    SELECT year, COUNT (*) diacou
    FROM neo2
    WHERE (estimated_diameter_min+estimated_diameter_max)/2 BETWEEN 1 AND 3
    GROUP BY year
    )
SELECT year, diacou
FROM dia_cte
ORDER BY diacou DESC
LIMIT 1;