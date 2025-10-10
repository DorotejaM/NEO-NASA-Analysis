--Which is the largest NEO (by max diameter) per year?
 WITH max_dia AS(
    SELECT
    neo_id, year, estimated_diameter_max,
    RANK () OVER (PARTITION BY year ORDER BY estimated_diameter_max DESC) rnk
    FROM neo2)
SELECT year, neo_id, estimated_diameter_max
FROM max_dia
WHERE rnk = 1
ORDER BY year DESC;

--How does miss distance change year-over-year for the fastest object per year?
 WITH fast_cte (
    SELECT neo_id, year, miss_distance,
    RANK () OVER (PARTITION BY year ORDER BY relative_velocity DESC) rnk
    FROM neo2
 )
 SELECT year, miss_distance, miss_distance - LAG(miss_distance) OVER (ORDER BY year) yoy_dif
FROM fast_cte
WHERE rnk = 1
ORDER BY year;

--Which objects had a smaller miss distance than the previous one in the same year?
WITH miss_cte AS (
    SELECT neo_id, year,
    LAG(miss_distance) OVER (PARTITION BY year ORDER BY miss_distance)
    FROM neo2
)

--Top 5 fastest objects per year?

--What is the average miss distance per year compared to the overall average miss distance?

--Cumulative count of hazardous objects over time?

--Which object had the biggest increase in velocity compared to the previous object in the same year?

--Which year had the most NEOs ranked in the top 10 closest encounters of all time?

--Find the average speed of the top 3 brightest objects per year.

--Which NEO had the smallest miss distance within each size category?