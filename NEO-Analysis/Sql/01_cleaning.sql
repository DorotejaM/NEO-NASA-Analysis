--As database does not have a year column, we will create one from the name column, as in it was mentioned year of discovery.
UPDATE neo
SET year = SUBSTR(name, INSTR(name, '(') + 1, 4);

--Check if the year column was created correctly.
SELECT year
FROM neo
ORDER BY year DESC;

--Check if there are any rows that do not have a year.
SELECT COUNT(*) AS count
FROM neo
WHERE SUBSTR(year, 1,2) NOT IN ('19', '20');

--There is 56 of them, so we will delete them, as database contains more than 330.000 rows.
DELETE FROM neo
WHERE SUBSTR(year, 1,2) NOT IN ('19', '20');

--Check if there are any rows that have NULL values in either column. 
SELECT COUNT(*) AS count
FROM neo
WHERE absolute_magnitude IS NULL; --in order to not have too many queries, WHERE statement was changed to check all columns.

--28 NULL values were found, so we will delete them.
DELETE FROM NEO WHERE absolute_magnitude IS NULL; 

--Du