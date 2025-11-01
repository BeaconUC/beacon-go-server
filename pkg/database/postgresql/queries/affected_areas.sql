-- name: GetAffectedArea :one
SELECT * FROM affected_areas
WHERE id = $1 LIMIT 1;

-- name: GetAffectedAreaByOutageAndBarangay :one
SELECT * FROM affected_areas
WHERE outage_id = $1 AND barangay_id = $2 LIMIT 1;

-- name: ListAffectedAreas :many
SELECT * FROM affected_areas
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListAffectedAreasByOutage :many
SELECT * FROM affected_areas
WHERE outage_id = $1
ORDER BY created_at DESC;

-- name: ListAffectedAreasByBarangay :many
SELECT * FROM affected_areas
WHERE barangay_id = $1
ORDER BY created_at DESC;

-- name: CreateAffectedArea :one
INSERT INTO affected_areas (
    outage_id,
    barangay_id
) VALUES (
    $1, $2
)
RETURNING *;

-- name: CreateMultipleAffectedAreas :exec
INSERT INTO affected_areas (outage_id, barangay_id)
SELECT $1, unnest($2::bigint[])
ON CONFLICT (outage_id, barangay_id) DO NOTHING;

-- name: DeleteAffectedArea :exec
DELETE FROM affected_areas
WHERE id = $1;

-- name: DeleteAffectedAreaByOutageAndBarangay :exec
DELETE FROM affected_areas
WHERE outage_id = $1 AND barangay_id = $2;

-- name: DeleteAllAffectedAreasForOutage :exec
DELETE FROM affected_areas
WHERE outage_id = $1;

-- name: GetAffectedAreasWithDetails :many
SELECT 
    aa.*,
    o.public_id AS outage_public_id,
    o.title AS outage_title,
    o.status AS outage_status,
    b.public_id AS barangay_public_id,
    b.name AS barangay_name,
    b.population AS barangay_population,
    c.name AS city_name,
    p.name AS province_name
FROM affected_areas aa
JOIN outages o ON aa.outage_id = o.id
JOIN barangays b ON aa.barangay_id = b.id
JOIN cities c ON b.city_id = c.id
JOIN provinces p ON c.province_id = p.id
WHERE aa.outage_id = $1
ORDER BY b.name;

-- name: GetOutageAffectedBarangays :many
SELECT 
    b.*,
    c.name AS city_name,
    p.name AS province_name
FROM barangays b
JOIN affected_areas aa ON b.id = aa.barangay_id
JOIN cities c ON b.city_id = c.id
JOIN provinces p ON c.province_id = p.id
WHERE aa.outage_id = $1
ORDER BY b.name;

-- name: GetBarangayOutageHistory :many
SELECT 
    o.*,
    aa.created_at AS affected_at
FROM outages o
JOIN affected_areas aa ON o.id = aa.outage_id
WHERE aa.barangay_id = $1
ORDER BY aa.created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountAffectedBarangaysByOutage :one
SELECT COUNT(*) AS count
FROM affected_areas
WHERE outage_id = $1;

-- name: GetTotalPopulationAffectedByOutage :one
SELECT COALESCE(SUM(b.population), 0) AS total_population_affected
FROM affected_areas aa
JOIN barangays b ON aa.barangay_id = b.id
WHERE aa.outage_id = $1;

-- name: GetOutagesAffectingBarangay :many
SELECT 
    o.*,
    aa.created_at AS affected_at
FROM outages o
JOIN affected_areas aa ON o.id = aa.outage_id
WHERE aa.barangay_id = $1
AND o.status IN ('unverified', 'verified', 'being_resolved')
ORDER BY aa.created_at DESC;

-- name: CheckBarangayAffectedByOutage :one
SELECT EXISTS(
    SELECT 1 FROM affected_areas 
    WHERE outage_id = $1 AND barangay_id = $2
) AS is_affected;