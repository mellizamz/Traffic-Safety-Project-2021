SELECT  to_char(waktulokal,'HH24') jam, CAST(COUNT (consecutive_number)/365.0 AS NUMERIC(4,2)) rata_rata_kejadian
FROM new_crash
GROUP BY jam
ORDER BY jam
