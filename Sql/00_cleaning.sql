--As database does not have a year column, we will create one from the name column, as in it was mentioned year of discovery.
UPDATE neo
SET year = SUBSTR(name, INSTR(name, '(') + 1, 4);
/* Practicing SUBSTR and INSTR
SELECT
SUBSTR(name, INSTR(name, '(') + 6, INSTR(name, ')') - (INSTR(name, '(') + 6) ) Name_clean
FROM neo
LIMIT 20;
*/

--Check if the year column was created correctly.
SELECT year
FROM neo
GROUP BY year
ORDER BY year DESC
LIMIT 20;

--Check if there are any rows that do not have a year.
SELECT COUNT(*) AS count
FROM neo
WHERE SUBSTR(year, 1,2) NOT IN ('19', '20'); --in case that we didn't get some random characters instead of years

--There is 56 of them, so we will delete them, as database contains more than 330.000 rows.
DELETE FROM neo
WHERE SUBSTR(year, 1,2) NOT IN ('19', '20');

--Check if there are any rows that have NULL values in either column. 
SELECT COUNT(*) AS count
FROM neo
WHERE absolute_magnitude IS NULL OR estimated_diameter_min IS NULL OR estimated_diameter_max IS NULL OR
orbiting_body IS NULL OR relative_velocity IS NULL OR miss_distance IS NULL OR is_hazardous IS NULL OR year IS NULL;

-- 28 NULL values were found, so we will delete them.
DELETE FROM NEO WHERE absolute_magnitude IS NULL OR estimated_diameter_min IS NULL OR estimated_diameter_max IS NULL OR
orbiting_body IS NULL OR relative_velocity IS NULL OR miss_distance IS NULL OR is_hazardous IS NULL OR year IS NULL;

--Duplicate checking:
    --how many repeated measurings there are
SELECT 
    COUNT (*) No_rows,
    COUNT (DISTINCT neo_id||name||absolute_magnitude||estimated_diameter_min||estimated_diameter_max||orbiting_body||
                    relative_velocity||miss_distance||is_hazardous||year) No_distinct,
    COUNT (*) - 
    COUNT (DISTINCT neo_id||name||absolute_magnitude||estimated_diameter_min||estimated_diameter_max||orbiting_body||
                    relative_velocity||miss_distance||is_hazardous||year) No_dupliates
FROM neo; 
        --there is 0 duplicates

    --whether there are multiple measurings of a single neo
SELECT
    neo_id,
    COUNT(*) number_of_rows
FROM neo
GROUP BY neo_id
ORDER BY COUNT(*) 
LIMIT 20;
HAVING COUNT (*) > 1

        -- we do have the multiple measurings of single neo

    --we can now check in which columns there are different values
SELECT
    neo_id,
    name,
    year,
    COUNT(*) number_of_rows,
    COUNT(DISTINCT absolute_magnitude) d_magn,
    COUNT(DISTINCT estimated_diameter_min) d_diam_min,
    COUNT(DISTINCT estimated_diameter_max) d_diam_max,
    COUNT (DISTINCT relative_velocity) d_vel,
    COUNT (DISTINCT miss_distance) d_miss
FROM neo
GROUP BY neo_id
HAVING COUNT(*) > 1 
ORDER BY COUNT(*) DESC
LIMIT 20; 

--Now we need to create table with no duplicates
CREATE TABLE neo2 AS
SELECT
neo_id,
name,
absolute_magnitude,
estimated_diameter_min,
estimated_diameter_max,
AVG(relative_velocity) rel_velocity,
MIN(miss_distance) miss_distance,
is_hazardous,
year
FROM neo
GROUP BY neo_id;



