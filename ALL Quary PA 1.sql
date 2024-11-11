
-- 01. Kondisi yang meningkatkan risiko kecelakaan
--Jumlah kecelakaan berdasarkan kondisi atmosfer:
SELECT
atmospheric_conditions_1_name,
COUNT(*) AS total_crash
FROM new_crash
GROUP BY atmospheric_conditions_1_name
ORDER BY total_crash DESC;

-- Jumlah kecelakaan berdasarkan kondisi pencahayaan:
SELECT
light_condition_name,
COUNT(*) AS accident_count
FROM new_crash
GROUP BY light_condition_name
ORDER BY accident_count DESC;


---- No 2.10 Negara 10 teratas negara bagian di mana kecelakaan paling banyak terjadi
SELECT
state_name,
COUNT (consecutive_number) AS jumlah_kecelakaan
FROM new_crash
GROUP BY  1
ORDER BY 2 DESC
LIMIT 10

--- No. 3 Jumlah rerata kecelakaan yang terjadi setiap jam
SELECT  to_char(waktulokal,'HH24') jam, CAST(COUNT (consecutive_number)/365.0 AS NUMERIC(4,2)) rata_rata_kejadian
FROM new_crash
GROUP BY jam
ORDER BY jam

-- 04. Persentase kecelakaan yang disebabkan oleh pengemudi yang mabuk
WITH accident_by_driver AS (
    SELECT
        CASE
            WHEN number_of_drunk_drivers = 0 THEN 'No Drunk'
            ELSE 'Drunk'
        END AS Type_of_driver,
        COUNT(consecutive_number) AS Total_accidents,
        COUNT(consecutive_number) * 1.00 / (SELECT COUNT(consecutive_number) FROM new_crash) * 100 AS drunk_driver_level,
        SUM(number_of_fatalities) AS total_fatalities
    FROM
        new_crash
    GROUP BY
        Type_of_driver
    ORDER BY
        Total_accidents DESC
)
SELECT
    *,
    (total_fatalities * 1.00 / Total_accidents) * 100 AS fatalities_rate
FROM
    accident_by_driver;

-- The number of accident fatalities in 2021 based on the category of drunk or not drunk drivers
WITH is_drunk AS
(
	SELECT consecutive_number,number_of_drunk_drivers, number_of_fatalities,
		CASE WHEN number_of_drunk_drivers > 0 THEN 'crash_by_drunk_driver' ELSE 'crash_not_drunk_driver' 
		END AS crash_by_drunk 
	FROM new_crash 
),
jumlah_drunks AS
(
	SELECT consecutive_number,
		crash_by_drunk,
		number_of_fatalities,
		number_of_drunk_drivers,
		SUM(CASE WHEN crash_by_drunk = 'crash_by_drunk_driver' THEN 1 
			WHEN crash_by_drunk = 'crash_not_drunk_driver' THEN 1
		END) as jumlah_drunk 
	FROM is_drunk
	GROUP BY consecutive_number,
		crash_by_drunk,number_of_fatalities,number_of_drunk_drivers
),
fatalities AS
(
	SELECT consecutive_number,
		SUM(CASE WHEN number_of_fatalities >0 THEN number_of_fatalities
			WHEN number_of_fatalities =0 THEN number_of_fatalities
		END) as fatalities_caused_by_drunk
	FROM jumlah_drunks 
	GROUP BY consecutive_number 
)
	SELECT j.crash_by_drunk,
		COUNT(jumlah_drunk) AS total_kecelakaan,
		SUM(fatalities_caused_by_drunk) jumlah_fatality
	FROM fatalities f 
	JOIN jumlah_drunks j 
		ON f.consecutive_number = j.consecutive_number
	JOIN is_drunk i 
		ON j.consecutive_number = i.consecutive_number
	GROUP BY j.crash_by_drunk

-- 05. Persentasi kecelakaan di daerah pedesaan dan perkotaan
SELECT
Land_use_name,
COUNT(land_use_name) AS total_accidents,
CAST(COUNT(land_use_name) * 100.0 / SUM(COUNT(land_use_name)) OVER () as Numeric(4,2)) AS percentage
FROM
new_crash
WHERE land_use_name IN ('Rural' , 'Urban')
GROUP BY
Land_use_name

-- 06. Jumlah kecelakaan berdasarkan hari
with cte_1 as
(SELECT
timestamp_of_crash AT TIME ZONE
CASE
WHEN state_name IN ('Connecticut', 'Delaware', 'District of Columbia', 'Florida',
'Georgia', 'Maine', 'Maryland', 'Massachusetts', 'New Hampshire',
'New Jersey', 'New York', 'North Carolina', 'Ohio', 'Pennsylvania','Indiana'
'Kentucky','Michigan','Tennessee',
'Rhode Island', 'South Carolina', 'Vermont', 'Virginia', 'West Virginia') THEN 'EST'
WHEN state_name IN ('Alabama', 'Arkansas', 'Illinois', 'Iowa', 'Kansas',
'Louisiana', 'Minnesota', 'Mississippi','Missouri', 'Nebraska', 'North Dakota', 'Oklahoma', 'South Dakota',
'Texas', 'Wisconsin') THEN 'CST'
WHEN state_name IN ('Arizona', 'Colorado', 'Idaho', 'Montana', 'New Mexico', 'Utah', 'Wyoming') THEN 'MST'
WHEN state_name IN ('California', 'Nevada', 'Oregon', 'Washington') THEN 'PST'
ELSE 'UTC'
END as local_timestamp_of_crash,consecutive_number,number_of_fatalities
from new_crash
group by local_timestamp_of_crash,consecutive_number,number_of_fatalities)
--menampilkan jumlah kecelakaan berdasarkan hari
Select distinct to_char(cte_1.local_timestamp_of_crash,'Day') as crash_day,
count(case
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'monday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'tuesday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'wednesday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'thursday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'friday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'saturday' then cte_1.consecutive_number
when to_char(cte_1.local_timestamp_of_crash,'Day')= 'sunday' then cte_1.consecutive_number else 0 end) as total_accident_by_day
From cte_1
Group by crash_day
order by total_accident_by_day desc