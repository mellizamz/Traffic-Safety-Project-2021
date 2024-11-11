SELECT round(a, 2) persentage_of_drunk_drivers, round(b, 2) persentage_of_not_drunk_drivers 
FROM 
(
SELECT
	--Menghitung persentase jumlah kecelakaan yang dipengaruhi oleh pengemudi yang mabuk
	(SUM(CASE WHEN number_of_drunk_drivers > 0 THEN 1 ELSE 0 END) * 100.0 / 
	 	(select count(*) FROM new_crash)) a,
	--Menghitung persentase jumlah kecelakaan yang tidak dipengaruhi oleh pengemudi yang mabuk 
	(SUM(CASE WHEN number_of_drunk_drivers <= 0 THEN 1 ELSE 0 END) *100.0 / 
	 	(select count(*) FROM new_crash)) b
FROM new_crash										
) foo


	
	




