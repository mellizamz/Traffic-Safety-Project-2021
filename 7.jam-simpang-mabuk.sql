SELECT 
    to_char(waktulokal,'HH24') jam,
    CASE 
        WHEN type_of_intersection_name IN (
        'Other Intersection Type','Five Point, or More','Not Reported','L-Intersection','Traffic Circle','Roundabout','Reported as Unknown','Y-Intersection')
            THEN 'Simpang lain'
        ELSE type_of_intersection_name
    END Simpang,
    CASE 
        WHEN number_of_drunk_drivers > 0 THEN 'Mabuk' 
        ELSE 'Tidak Mabuk' 
    END mabukkah,
    COUNT(consecutive_number) jumlah_kecelakaan

FROM new_crash
GROUP BY jam,simpang,mabukkah