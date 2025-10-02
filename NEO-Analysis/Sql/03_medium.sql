--What is the percentage of hazardous objects relative to the total number per year?
WITH hazardous_cte AS (
    SELECT year, COUNT(n.neo_id) AS hazardous
    FROM neo n
    WHERE is_hazardous = 'True'
    GROUP BY n.year
    ),
group_cte AS (
    SELECT n.year, COUNT(neo_id) AS year_count
    FROM neo n
    GROUP BY n.year
)
SELECT h.year, 
ROUND(CAST(h.hazardous AS FLOAT)/CAST(g.year_count AS FLOAT),2) AS Per_year_hazard
FROM 
hazardous_cte h
JOIN group_cte g
    ON h.year = g.year
GROUP BY h.year
ORDER BY ROUND(CAST(h.hazardous AS FLOAT)/CAST(g.year_count AS FLOAT),2) DESC;

--Which year had the highest number of objects with a maximum diameter greater than 500 meters?
SELECT year
FROM neo
WHERE estimated_diameter_max > 0.5
GROUP BY year
ORDER BY COUNT(estimated_diameter_max) DESC
LIMIT 1;

--Which year had the highest average speed of objects that passed closer than 1,000,000 km?

SELECT year
FROM neo
WHERE miss_distance < 1000000
GROUP BY year
ORDER BY AVG(relative_velocity) DESC
LIMIT 1;

--Which 3 years had the lowest average miss distance among hazardous objects?
SELECT year
FROM neo
WHERE is_hazardous = 'True'
GROUP BY year
ORDER BY AVG(miss_distance)
LIMIT 3;

--What is the difference in average brightness (absolute_magnitude) between hazardous and non-hazardous objects?
SELECT is_hazardous, ROUND(AVG(absolute_magnitude),2) 'AVG Magnitude'
FROM neo
GROUP BY is_hazardous;

--What are the typical velocity values for objects with extremely large diameters (e.g. over 1 km)?
SELECT AVG(relative_velocity)
FROM neo
WHERE estimated_diameter_max > 1;

--Is there any year in which all objects were classified as non-hazardous?
SELECT year
FROM neo
GROUP BY year
HAVING COUNT(CASE WHEN is_hazardous IS 'True' THEN 1 END)=0;

--Which years had more than 1,000 objects with relative_velocity over 100,000 km/h? 0 So we lowered to 500
SELECT year
FROM neo
GROUP BY year
HAVING COUNT(CASE WHEN relative_velocity > 100000 THEN 1 END)>500;

--How many years had more than 10 objects that passed closer than 100,000 km?
SELECT year
FROM neo 
GROUP BY year
HAVING COUNT(CASE WHEN miss_distance < 100000 THEN 1 END) > 10;

--Which year had the highest average diameter among hazardous objects?
SELECT year
FROM neo
WHERE is_hazardous = 'True'
GROUP BY year
ORDER BY AVG(estimated_diameter_max) DESC
LIMIT 1; 

-- Which year had the lowest average brightness (i.e. highest absolute_magnitude value)?
SELECT year
FROM neo
GROUP BY year
ORDER BY AVG(absolute_magnitude) DESC
LIMIT 1;

--Which year had the most objects with a diameter between 1 and 3
SELECT year
FROM neo
WHERE estimated_diameter_max > 1 AND  estimated_diameter_max < 3
GROUP BY year
ORDER BY COUNT(CASE WHEN estimated_diameter_max > 1 AND  estimated_diameter_max < 3 THEN 1 END) DESC
LIMIT 1;