-- Jumlah kecelakaan berdasarkan kondisi pencahayaan:
SELECT
light_condition_name,
COUNT(*) AS accident_count
FROM new_crash
GROUP BY light_condition_name
ORDER BY accident_count DESC;