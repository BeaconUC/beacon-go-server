-- name: GetWeatherData :one
SELECT * FROM weather_data
WHERE id = $1 LIMIT 1;

-- name: GetWeatherDataByPublicID :one
SELECT * FROM weather_data
WHERE public_id = $1 LIMIT 1;

-- name: ListWeatherData :many
SELECT * FROM weather_data
ORDER BY recorded_at DESC
LIMIT $1 OFFSET $2;

-- name: ListWeatherDataByCity :many
SELECT * FROM weather_data
WHERE city_id = $1
ORDER BY recorded_at DESC
LIMIT $2 OFFSET $3;

-- name: GetLatestWeatherDataByCity :one
SELECT * FROM weather_data
WHERE city_id = $1
ORDER BY recorded_at DESC
LIMIT 1;

-- name: GetWeatherDataByCityAndTime :one
SELECT * FROM weather_data
WHERE city_id = $1 AND recorded_at = $2
LIMIT 1;

-- name: CreateWeatherData :one
INSERT INTO weather_data (
    city_id,
    temperature,
    feels_like,
    humidity,
    atmospheric_pressure,
    wind_speed,
    precipitation,
    condition_main,
    condition_description,
    recorded_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10
)
RETURNING *;

-- name: UpdateWeatherData :one
UPDATE weather_data
SET 
    city_id = $2,
    temperature = $3,
    feels_like = $4,
    humidity = $5,
    atmospheric_pressure = $6,
    wind_speed = $7,
    precipitation = $8,
    condition_main = $9,
    condition_description = $10,
    recorded_at = $11
WHERE id = $1
RETURNING *;

-- name: DeleteWeatherData :exec
DELETE FROM weather_data
WHERE id = $1;

-- name: DeleteOldWeatherData :exec
DELETE FROM weather_data
WHERE recorded_at < NOW() - INTERVAL '30 days';

-- name: GetWeatherDataWithCityDetails :many
SELECT 
    wd.*,
    c.name AS city_name,
    c.public_id AS city_public_id,
    p.name AS province_name
FROM weather_data wd
JOIN cities c ON wd.city_id = c.id
JOIN provinces p ON c.province_id = p.id
ORDER BY wd.recorded_at DESC
LIMIT $1 OFFSET $2;

-- name: GetWeatherStatsByCity :many
SELECT 
    city_id,
    AVG(temperature) AS avg_temperature,
    MIN(temperature) AS min_temperature,
    MAX(temperature) AS max_temperature,
    AVG(humidity) AS avg_humidity,
    AVG(wind_speed) AS avg_wind_speed,
    SUM(precipitation) AS total_precipitation
FROM weather_data
WHERE city_id = $1
AND recorded_at >= NOW() - INTERVAL '7 days'
GROUP BY city_id;

-- name: GetWeatherDataInTimeRange :many
SELECT * FROM weather_data
WHERE city_id = $1
AND recorded_at BETWEEN $2 AND $3
ORDER BY recorded_at DESC;

-- name: GetLatestWeatherForMultipleCities :many
WITH latest_weather AS (
    SELECT DISTINCT ON (city_id) *
    FROM weather_data
    ORDER BY city_id, recorded_at DESC
)
SELECT 
    lw.*,
    c.name AS city_name,
    p.name AS province_name
FROM latest_weather lw
JOIN cities c ON lw.city_id = c.id
JOIN provinces p ON c.province_id = p.id
WHERE c.id = ANY($1::bigint[])
ORDER BY c.name;

-- name: GetWeatherTrends :many
SELECT 
    DATE(recorded_at) AS date,
    AVG(temperature) AS avg_temperature,
    AVG(humidity) AS avg_humidity,
    AVG(wind_speed) AS avg_wind_speed,
    SUM(precipitation) AS total_precipitation
FROM weather_data
WHERE city_id = $1
AND recorded_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(recorded_at)
ORDER BY date DESC;

-- name: CountWeatherRecordsByCity :one
SELECT city_id, COUNT(*) AS record_count
FROM weather_data
GROUP BY city_id;

-- name: SearchWeatherDataByCondition :many
SELECT 
    wd.*,
    c.name AS city_name
FROM weather_data wd
JOIN cities c ON wd.city_id = c.id
WHERE condition_main ILIKE '%' || $1 || '%' 
   OR condition_description ILIKE '%' || $1 || '%'
ORDER BY recorded_at DESC
LIMIT $2 OFFSET $3;

-- name: GetExtremeWeatherConditions :many
SELECT 
    wd.*,
    c.name AS city_name,
    p.name AS province_name
FROM weather_data wd
JOIN cities c ON wd.city_id = c.id
JOIN provinces p ON c.province_id = p.id
WHERE (temperature >= 35 OR temperature <= 10)
   OR wind_speed >= 50
   OR precipitation >= 50
   OR condition_main IN ('Thunderstorm', 'Heavy Rain', 'Storm')
ORDER BY recorded_at DESC
LIMIT $1 OFFSET $2;

-- name: BulkInsertWeatherData :exec
INSERT INTO weather_data (
    city_id,
    temperature,
    feels_like,
    humidity,
    atmospheric_pressure,
    wind_speed,
    precipitation,
    condition_main,
    condition_description,
    recorded_at
) VALUES 
    (UNNEST($1::bigint[]), 
     UNNEST($2::numeric[]), 
     UNNEST($3::numeric[]), 
     UNNEST($4::integer[]), 
     UNNEST($5::integer[]), 
     UNNEST($6::numeric[]), 
     UNNEST($7::numeric[]), 
     UNNEST($8::varchar[]), 
     UNNEST($9::text[]), 
     UNNEST($10::timestamptz[]));