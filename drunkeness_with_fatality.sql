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
