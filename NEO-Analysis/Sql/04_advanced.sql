1. Hazard Rate by Distance Quantiles
Divide miss_distance into five equal-frequency quantiles. For each quantile, calculate:
total number of NEOs,
number of hazardous NEOs,
hazard rate (%),
minimum and maximum miss distance values.

WITH bin_cte AS(
SELECT neo_id, miss_distance, NTILE(5) OVER (ORDER BY miss_distance) bins, is_hazardous
FROM neo2),
hazard_cte AS(
SELECT neo_id
FROM neo2
WHERE is_hazardous = 'True')
SELECT b.bins, COUNT(b.neo_id) cnt_per_bin, MIN(b.miss_distance), MAX(b.miss_distance), 
COUNT(h.neo_id), 
CONCAT(100*COUNT(h.neo_id)/SUM(CASE WHEN b.is_hazardous ='False' THEN 1 ELSE 0 END), '%') diff
FROM bin_cte b LEFT JOIN hazard_cte h 
ON b.neo_id=h.neo_id
GROUP BY bins;

/*
--Just testing
WITH hazard_cte AS(
SELECT neo_id, COUNT(neo_id) cnt1
FROM neo2
WHERE is_hazardous = 'True'),
not_hazard_cte AS(
SELECT neo_id, COUNT(neo_id) cnt2
FROM neo2
WHERE is_hazardous = 'False')
SELECT CONCAT(100*cnt1/cnt2, '%')
FROM hazard_cte h  
CROSS JOIN not_hazard_cte n;
*/

2. Year-over-Year Change in Hazard Rate
For each year, calculate the hazard rate (hazard / total). Then, compute the year-over-year 
change in percentage points.
Expected output: year, hazard_rate, yoy_change_pp
WITH hazard_cte AS(
SELECT neo_id, year, is_hazardous
FROM neo2
WHERE is_hazardous = 'True')
SELECT n.year, COUNT(h.neo_id), ROUND((100.0 * COUNT(h.neo_id) / COUNT(n.neo_id)) 
- LAG(100.0 * COUNT(h.neo_id) / COUNT(n.neo_id)) OVER (ORDER BY h.year),2) yoy_change_pp,
CONCAT(100*COUNT(h.neo_id)/COUNT(n.neo_id),'%') hazard_rate
FROM neo2 n LEFT JOIN hazard_cte h 
ON n.neo_id=h.neo_id
GROUP BY n.year;
