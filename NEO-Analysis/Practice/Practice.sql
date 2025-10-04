--Provera duplikata

-- 1. treba proveriti da li ima potpuno istih vrednosti u redovima
SELECT
COUNT(*) 'Num of rows',
COUNT(DISTINCT neo_id||name||absolute_magnitude||estimated_diameter_min||estimated_diameter_max
||orbiting_body||relative_velocity||miss_distance||is_hazardous||year) 'Num of different rows',
COUNT(*) - COUNT(DISTINCT neo_id||name||absolute_magnitude||estimated_diameter_min||estimated_diameter_max
||orbiting_body||relative_velocity||miss_distance||is_hazardous||year) 'Num of copies'
FROM neo;
-- 2. treba proveriti da li postoji vise vrednosti sa 1 kljucem
SELECT neo_id, COUNT(*)
FROM neo
GROUP BY neo_id
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC
LIMIT 10;
-- 3. treba proveriti gde su razlike u kljucevima
SELECT 
neo_id, 
COUNT(DISTINCT absolute_magnitude) d_mag,
COUNT(DISTINCT estimated_diameter_min) d_dia_min,
COUNT(DISTINCT estimated_diameter_max) d_dia_max,
COUNT(DISTINCT orbiting_body) d_orb,
COUNT(DISTINCT relative_velocity) d_vel,
COUNT(DISTINCT miss_distance) d_miss,
COUNT(DISTINCT is_hazardous) d_haz
FROM NEO
GROUP BY neo_id
LIMIT 10;

-- 1. Which year had the most NEOs in the dataset?
SELECT
year,
COUNT(*) 'Total Nr of NEOs'
FROM neo2
GROUP BY year
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 2. What is the average diameter of NEOs per year?
SELECT 
year,
ROUND(AVG(estimated_diameter_min + estimated_diameter_max)/2,2) 'Avg Diameter per Year'
FROM neo2
GROUP BY year
ORDER BY AVG(estimated_diameter_min + estimated_diameter_max) DESC;

-- 3. What is the average miss_distance of all NEOs?
SELECT CONCAT(ROUND(AVG(miss_distance), 3), ' km') 'Avg Miss Distance'
FROM neo2;

-- 4. What is the average relative_velocity for hazardous vs non-hazardous NEOs?
SELECT is_hazardous, ROUND(AVG(relative_velocity),3) 'Avg Rel Velocity'
FROM neo2
GROUP BY is_hazardous;

-- 5. How many NEOs have absolute_magnitude less than 20?
SELECT COUNT(*)
FROM neo2
WHERE absolute_magnitude < 20;

-- 6. What is the smallest estimated_diameter_min in the dataset?
SELECT MIN(estimated_diameter_min) 'Min Estimated Diameter'
FROM neo2;

-- 7. What is the largest estimated_diameter_max in the dataset?
SELECT MAX(estimated_diameter_max) 'MAX Estimated Diameter'
FROM neo2;

-- 8. What is the average absolute_magnitude of all NEOs?
SELECT ROUND(AVG(absolute_magnitude), 3) 'Avg Magnitude'
FROM neo2;

-- 9. How many distinct orbiting_body values exist in the dataset?
SELECT COUNT(DISTINCT orbiting_body) 'Dist Orbit Bodies'
FROM neo2;

-- 10. How many total NEOs orbit around Earth?
SELECT COUNT(DISTINCT neo_id) 'Total Num of NEOs'
FROM neo2;


SELECT neo_id, COUNT(*)
FROM neo
GROUP BY neo_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 20;

SELECT 
COUNT(DISTINCT absolute_magnitude),  
COUNT(DISTINCT estimated_diameter_min),
COUNT(DISTINCT estimated_diameter_max),
COUNT(DISTINCT orbiting_body),
COUNT(DISTINCT relative_velocity),
COUNT(DISTINCT miss_distance)
FROM neo;

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
--WHERE ROUND(CAST(h.hazardous AS FLOAT)/CAST(t.total AS FLOAT)*100, 3) = 100.0
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
SELECT year
FROM closer_cte
GROUP BY year
ORDER BY rel 
LIMIT 1;

-- 4. Which 3 years had the lowest average miss distance among hazardous objects?


-- 5. What is the difference in average brightness (absolute_magnitude) between hazardous and non-hazardous objects?

-- 6. What are the typical velocity values for objects with extremely large diameters (e.g. over 1 km)?

-- 7. Is there any year in which all objects were classified as non-hazardous?

-- 8. Which years had more than 1,000 objects with relative_velocity over 100,000 km/h? (or more than 500 if 1,000 returns 0 results)

-- 9. How many years had more than 10 objects that passed closer than 100,000 km?

-- 10. Which year had the highest average diameter among hazardous objects?

-- 11. Which year had the lowest average brightness (i.e. highest absolute_magnitude value)?

-- 12. Which year had the most objects with a diameter between 1 and 3?
