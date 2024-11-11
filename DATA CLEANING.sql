CREATE TABLE IF NOT EXISTS new_crash as (
  WITH
  -- awal dari cleansing
    cek_data_kosong as (
      SELECT
        *,
        CASE
          -- data kosong
          WHEN number_of_parked_working_vehicles IS NULL THEN 'data kendaraan parkir kosong'
          WHEN number_of_forms_submitted_for_persons_not_in_motor_vehicles IS NULL THEN 'jumlah kendaraan kosong'
          WHEN number_of_persons_in_motor_vehicles_in_transport_mvit IS NULL THEN 'jumlah orang dalam kendaraan kosong'
          WHEN number_of_persons_not_in_motor_vehicles_in_transport_mvit IS NULL THEN 'jumlah orang di luar kendaraan kosong'
          WHEN milepoint IS NULL THEN 'milstone kosong'
          WHEN number_of_fatalities IS NULL THEN 'jumlah yang fatal kosong'
          WHEN number_of_drunk_drivers IS NULL THEN 'jumlah yang mabuk kosong'
          WHEN timestamp_of_crash IS NULL THEN 'waktu kosong'
          WHEN number_of_vehicle_forms_submitted_all IS NULL THEN 'kendaraan kosong'
          WHEN number_of_motor_vehicles_in_transport_mvit IS NULL THEN 'data kendaraan tabrakan kosong'
          WHEN state_name IS NULL THEN 'nama negara bagian kosong'
          WHEN land_use_name IS NULL THEN 'nama kategori daerah kosong'
          WHEN functional_system_name IS NULL THEN 'jenis jalan kosong'
          WHEN atmospheric_conditions_1_name IS NULL THEN 'kondisi cuaca kosong'
          WHEN manner_of_collision_name IS NULL THEN 'jenis tabrakan kosong'
          WHEN type_of_intersection_name IS NULL THEN 'jenis simpang kosong'
          WHEN light_condition_name IS NULL THEN 'kondisi cahaya kosong'
          WHEN city_name IS NULL THEN 'nama kota kosong'
          -- data kendaraan yang terlibat 0
          WHEN number_of_vehicle_forms_submitted_all < 1 THEN 'kendaraan yang terlibat kecelakaan 0'
          -- data tidak sesuai
          WHEN number_of_vehicle_forms_submitted_all< number_of_motor_vehicles_in_transport_mvit + number_of_parked_working_vehicles THEN 'data kendaraan yang terlibat tidak sesuai'            
        END validasi
      FROM crash
    ),
      -- akhir dari data cleansing
      -- awal dari konversi waktu
      ZonaWaktu AS (
          SELECT
              *,
              CASE
                  -- +interval '-5 hours'
                  WHEN state_name IN ('Connecticut','District of Columbia','Delaware','Florida','Georgia','Indiana','Kentucky','Maine','Maryland','Massachusetts',
                      'Michigan','New Hampshire','New Jersey','New York','North Carolina','Ohio','Pennsylvania','Rhode Island','South Carolina','Tennessee',
                      'Vermont','Virginia','West Virginia')
                  THEN timestamp_of_crash AT TIME ZONE 'EST'
                      -- + interval '-6 Hours'
                  WHEN state_name IN ( 'Alabama','Arkansas','Florida','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Michigan',
                      'Minnesota','Mississippi','Missouri','Nebraska','N.Dakota', 'Oklahoma','South Dakota','Tennessee','Texas','Wisconsin')
                  THEN timestamp_of_crash AT TIME ZONE 'CST'
                      --+ interval '-7 Hours'
                  WHEN state_name IN ('Arizona','Arizona','Colorado','Idaho','Kansas','Montana','Nebraska','New Mexico',
                      'North Dakota','Oregon','South Dakota','Texas','Utah','Wyoming')
                  THEN timestamp_of_crash AT TIME ZONE 'MST'
                      -- + interval '-8 Hours' '
                  WHEN state_name IN ('California','Idaho','Nevada','Oregon','Washington')
                      THEN timestamp_of_crash AT TIME ZONE 'PST'
                  --+ interval '-9 Hours'
                  WHEN state_name IN ('Alaska')
                      THEN timestamp_of_crash AT TIME ZONE 'AKST'
                  -- + interval '-10 Hours'
                  WHEN state_name IN ('Hawaii')
                      THEN timestamp_of_crash AT TIME ZONE 'HST'
              END waktulokal
          FROM cek_data_kosong
      )
      -- akhir dari konverfsi waktu
  SELECT * FROM ZonaWaktu
  WHERE validasi IS NULL
);
ALTER TABLE new_crash DROP validasi;

