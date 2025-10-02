--Which year had the most NEOs?
    --Checking table
SELECT *
FROM neo
LIMIT 10;

SELECT COUNT(neo_id) NEOs_per_year, year
FROM neo
GROUP BY year
ORDER BY NEOs_per_year DESC;

-- Average diameter of NEO per year.
SELECT year, ROUND(AVG(estimated_diameter_min+estimated_diameter_max)/2, 2) AS average_diameter
FROM neo
GROUP BY year;

-- Average miss_distance of NEOs per year.
SELECT CONCAT(ROUND(AVG(miss_distance), 2), ' km') AS average_miss_distance
FROM neo;

--Average speed of hazardous vs non-hazardous NEOs.
SELECT is_hazardous, ROUND(AVG(relative_velocity),2) AS average_speed
FROM neo
GROUP BY is_hazardous;

--Total number of NEOs whose magnitude is less than 20.
SELECT COUNT(neo_id) AS count
FROM neo
WHERE absolute_magnitude < 20;
