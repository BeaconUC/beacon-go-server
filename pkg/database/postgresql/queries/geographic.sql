-- name: GetBarangay :one
SELECT * FROM barangays
WHERE id = $1 LIMIT 1;

-- name: GetBarangayByPublicID :one
SELECT * FROM barangays
WHERE public_id = $1 LIMIT 1;

-- name: ListBarangays :many
SELECT * FROM barangays
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: ListBarangaysByCity :many
SELECT * FROM barangays
WHERE city_id = $1
ORDER BY name;

-- name: ListBarangaysByFeeder :many
SELECT * FROM barangays
WHERE feeder_id = $1
ORDER BY name;

-- name: SearchBarangays :many
SELECT * FROM barangays
WHERE name ILIKE '%' || $1 || '%'
ORDER BY name
LIMIT $2 OFFSET $3;

-- name: GetBarangaysWithinBoundary :many
SELECT * FROM barangays
WHERE ST_Within($1, boundary) -- $1 is point geometry
ORDER BY name;

-- name: GetBarangayWithDetails :one
SELECT 
    b.*,
    c.name AS city_name,
    c.public_id AS city_public_id,
    p.name AS province_name,
    p.public_id AS province_public_id,
    f.feeder_number
FROM barangays b
JOIN cities c ON b.city_id = c.id
JOIN provinces p ON c.province_id = p.id
LEFT JOIN feeders f ON b.feeder_id = f.id
WHERE b.id = $1;

-- name: CreateBarangay :one
INSERT INTO barangays (
    name,
    city_id,
    feeder_id,
    boundary,
    population,
    population_year
) VALUES (
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: UpdateBarangay :one
UPDATE barangays
SET 
    name = $2,
    city_id = $3,
    feeder_id = $4,
    boundary = $5,
    population = $6,
    population_year = $7,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteBarangay :exec
DELETE FROM barangays
WHERE id = $1;

-- name: GetCity :one
SELECT * FROM cities
WHERE id = $1 LIMIT 1;

-- name: GetCityByPublicID :one
SELECT * FROM cities
WHERE public_id = $1 LIMIT 1;

-- name: GetCityByName :one
SELECT * FROM cities
WHERE name = $1 LIMIT 1;

-- name: ListCities :many
SELECT * FROM cities
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: ListCitiesByProvince :many
SELECT * FROM cities
WHERE province_id = $1
ORDER BY name;

-- name: SearchCities :many
SELECT * FROM cities
WHERE name ILIKE '%' || $1 || '%'
ORDER BY name
LIMIT $2 OFFSET $3;

-- name: GetCityWithDetails :one
SELECT 
    c.*,
    p.name AS province_name,
    p.public_id AS province_public_id,
    COUNT(b.id) AS barangay_count,
    COALESCE(SUM(b.population), 0) AS total_population
FROM cities c
JOIN provinces p ON c.province_id = p.id
LEFT JOIN barangays b ON c.id = b.city_id
WHERE c.id = $1
GROUP BY c.id, p.id;

-- name: CreateCity :one
INSERT INTO cities (
    name,
    province_id,
    boundary,
    population,
    population_year
) VALUES (
    $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateCity :one
UPDATE cities
SET 
    name = $2,
    province_id = $3,
    boundary = $4,
    population = $5,
    population_year = $6,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteCity :exec
DELETE FROM cities
WHERE id = $1;

-- name: GetProvince :one
SELECT * FROM provinces
WHERE id = $1 LIMIT 1;

-- name: GetProvinceByPublicID :one
SELECT * FROM provinces
WHERE public_id = $1 LIMIT 1;

-- name: GetProvinceByName :one
SELECT * FROM provinces
WHERE name = $1 LIMIT 1;

-- name: ListProvinces :many
SELECT * FROM provinces
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: SearchProvinces :many
SELECT * FROM provinces
WHERE name ILIKE '%' || $1 || '%'
ORDER BY name
LIMIT $2 OFFSET $3;

-- name: GetProvinceWithDetails :one
SELECT 
    p.*,
    COUNT(c.id) AS city_count,
    COUNT(b.id) AS barangay_count,
    COALESCE(SUM(b.population), 0) AS total_population
FROM provinces p
LEFT JOIN cities c ON p.id = c.province_id
LEFT JOIN barangays b ON c.id = b.city_id
WHERE p.id = $1
GROUP BY p.id;

-- name: CreateProvince :one
INSERT INTO provinces (
    name,
    boundary,
    population,
    population_year
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateProvince :one
UPDATE provinces
SET 
    name = $2,
    boundary = $3,
    population = $4,
    population_year = $5,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteProvince :exec
DELETE FROM provinces
WHERE id = $1;

-- name: GetFeeder :one
SELECT * FROM feeders
WHERE id = $1 LIMIT 1;

-- name: GetFeederByPublicID :one
SELECT * FROM feeders
WHERE public_id = $1 LIMIT 1;

-- name: GetFeederByNumber :one
SELECT * FROM feeders
WHERE feeder_number = $1 LIMIT 1;

-- name: ListFeeders :many
SELECT * FROM feeders
ORDER BY feeder_number
LIMIT $1 OFFSET $2;

-- name: GetFeedersWithBarangayCount :many
SELECT 
    f.*,
    COUNT(b.id) AS barangay_count,
    COALESCE(SUM(b.population), 0) AS total_population
FROM feeders f
LEFT JOIN barangays b ON f.id = b.feeder_id
GROUP BY f.id
ORDER BY f.feeder_number;

-- name: CreateFeeder :one
INSERT INTO feeders (
    feeder_number,
    boundary
) VALUES (
    $1, $2
)
RETURNING *;

-- name: UpdateFeeder :one
UPDATE feeders
SET 
    feeder_number = $2,
    boundary = $3,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteFeeder :exec
DELETE FROM feeders
WHERE id = $1;

-- name: GetGeographicHierarchy :many
SELECT 
    p.name AS province_name,
    c.name AS city_name,
    b.name AS barangay_name,
    b.population AS barangay_population,
    f.feeder_number
FROM provinces p
JOIN cities c ON p.id = c.province_id
JOIN barangays b ON c.id = b.city_id
LEFT JOIN feeders f ON b.feeder_id = f.id
ORDER BY p.name, c.name, b.name;

-- name: GetLocationByCoordinates :one
SELECT 
    b.id AS barangay_id,
    b.name AS barangay_name,
    c.id AS city_id,
    c.name AS city_name,
    p.id AS province_id,
    p.name AS province_name,
    f.id AS feeder_id,
    f.feeder_number
FROM barangays b
JOIN cities c ON b.city_id = c.id
JOIN provinces p ON c.province_id = p.id
LEFT JOIN feeders f ON b.feeder_id = f.id
WHERE ST_Within($1, b.boundary) -- $1 is point geometry
LIMIT 1;