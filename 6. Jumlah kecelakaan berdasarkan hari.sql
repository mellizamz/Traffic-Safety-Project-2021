--Jumlah kecelakaan berdasarkan hari
--CTE untuk konversi waktu lokal AS
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