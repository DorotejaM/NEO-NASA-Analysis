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
