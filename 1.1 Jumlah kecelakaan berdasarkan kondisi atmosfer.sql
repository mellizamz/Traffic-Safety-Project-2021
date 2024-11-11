-- Kondisi yang meningkatkan risiko kecelakaan
--Jumlah kecelakaan berdasarkan kondisi atmosfer:
SELECT
atmospheric_conditions_1_name,
COUNT(*) AS total_crash
FROM new_crash
GROUP BY atmospheric_conditions_1_name
ORDER BY total_crash DESC;


