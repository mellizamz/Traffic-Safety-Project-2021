	
--Pada saat kondisi seperti apa terjadinya kecelakaan yang dipengaruhi oleh pengemudi mabuk
SELECT light_condition_name,
	SUM(CASE WHEN number_of_drunk_drivers > 0 THEN 1 ELSE 0 END) * 100.0 / 
 		(select count(*) FROM new_crash)  "%_incident_drunk_driver",
	 
	 SUM(CASE WHEN number_of_drunk_drivers = 0 THEN 1 ELSE 0 END) * 100.0 / 
 		(select count(*) FROM new_crash)  "%_incident_drunk_not_driver"
		
FROM new_crash
GROUP BY light_condition_name
ORDER BY "%_incident_drunk_driver" DESC