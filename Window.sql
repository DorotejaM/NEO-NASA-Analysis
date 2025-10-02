--Napravi query koji prikazuje sve asteroide sa svojim name, year i estimated_diameter_max, 
--ali dodaj kolonu prosečan prečnik svih asteroida u toj godini.
SELECT name, year, estimated_diameter_max, AVG(estimated_diameter_max) OVER (PARTITION BY year) AS Average_Diameter_Per_Year 
FROM neo
GROUP BY name
ORDER BY AVG(estimated_diameter_max) OVER (PARTITION BY year) DESC
LIMIT 10;

SELECT
    year,
    name,
    estimated_diameter_max
FROM (
    SELECT
        year,
        name,
        estimated_diameter_max,
        RANK() OVER (
            PARTITION BY year
            ORDER BY estimated_diameter_max DESC
        ) AS diameter_rank
    FROM neo_clean
) ranked
WHERE diameter_rank = 1
ORDER BY year;