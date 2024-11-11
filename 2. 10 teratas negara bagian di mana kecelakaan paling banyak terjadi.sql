--10 teratas negara bagian di mana kecelakaan paling banyak terjadi
SELECT
State_name,
COUNT (consecutive_number) AS jumlah_kecelakaan
FROM new_crash
GROUP BY  1
ORDER BY 2 DESC
LIMIT 10