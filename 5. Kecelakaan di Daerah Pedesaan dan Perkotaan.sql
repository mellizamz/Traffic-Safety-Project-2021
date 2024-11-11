SELECT
Land_use_name,
COUNT(land_use_name) AS total_accidents,
CAST(COUNT(land_use_name) * 100.0 / SUM(COUNT(land_use_name)) OVER () as Numeric(4,2)) AS percentage
FROM
new_crash
WHERE land_use_name IN ('Rural' , 'Urban')
GROUP BY
Land_use_name
