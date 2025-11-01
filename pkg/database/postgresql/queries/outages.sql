-- name: GetOutage :one
SELECT * FROM outages
WHERE id = $1 LIMIT 1;

-- name: GetOutageByPublicID :one
SELECT * FROM outages
WHERE public_id = $1 LIMIT 1;

-- name: ListOutages :many
SELECT * FROM outages
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListOutagesByStatus :many
SELECT * FROM outages
WHERE status = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListOutagesByType :many
SELECT * FROM outages
WHERE outage_type = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListActiveOutages :many
SELECT * FROM outages
WHERE status IN ('unverified', 'verified', 'being_resolved')
ORDER BY created_at DESC;

-- name: CreateOutage :one
INSERT INTO outages (
    outage_type,
    status,
    confidence_percentage,
    title,
    description,
    number_of_reports,
    estimated_affected_population,
    start_time,
    estimated_restoration_time,
    actual_restoration_time,
    confirmed_by,
    resolved_by
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12
)
RETURNING *;

-- name: UpdateOutage :one
UPDATE outages
SET 
    outage_type = $2,
    status = $3,
    confidence_percentage = $4,
    title = $5,
    description = $6,
    number_of_reports = $7,
    estimated_affected_population = $8,
    start_time = $9,
    estimated_restoration_time = $10,
    actual_restoration_time = $11,
    confirmed_by = $12,
    resolved_by = $13,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateOutageStatus :one
UPDATE outages
SET 
    status = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteOutage :exec
DELETE FROM outages
WHERE id = $1;

-- name: GetOutageSummary :one
SELECT * FROM outage_summary
WHERE id = $1;

-- name: ListOutageSummaries :many
SELECT * FROM outage_summary
ORDER BY id DESC
LIMIT $1 OFFSET $2;

-- name: CountOutagesByStatus :one
SELECT status, COUNT(*) AS count
FROM outages
GROUP BY status;

-- name: SearchOutages :many
SELECT * FROM outages
WHERE 
    (title ILIKE '%' || $1 || '%' OR description ILIKE '%' || $1 || '%')
    AND ($2::outage_status IS NULL OR status = $2)
    AND ($3::outage_type IS NULL OR outage_type = $3)
ORDER BY created_at DESC
LIMIT $4 OFFSET $5;

-- name: GetOutagesWithAffectedAreas :many
SELECT 
    o.*,
    COUNT(aa.barangay_id) AS affected_barangay_count,
    COALESCE(SUM(b.population), 0) AS total_population_affected
FROM outages o
LEFT JOIN affected_areas aa ON o.id = aa.outage_id
LEFT JOIN barangays b ON aa.barangay_id = b.id
GROUP BY o.id
ORDER BY o.created_at DESC
LIMIT $1 OFFSET $2;