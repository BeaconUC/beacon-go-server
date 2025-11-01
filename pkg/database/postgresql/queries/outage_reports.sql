-- name: GetOutageReport :one
SELECT * FROM outage_reports
WHERE id = $1 LIMIT 1;

-- name: GetOutageReportByPublicID :one
SELECT * FROM outage_reports
WHERE public_id = $1 LIMIT 1;

-- name: ListOutageReports :many
SELECT * FROM outage_reports
ORDER BY reported_at DESC
LIMIT $1 OFFSET $2;

-- name: ListOutageReportsByStatus :many
SELECT * FROM outage_reports
WHERE status = $1
ORDER BY reported_at DESC
LIMIT $2 OFFSET $3;

-- name: ListOutageReportsByReporter :many
SELECT * FROM outage_reports
WHERE reported_by = $1
ORDER BY reported_at DESC
LIMIT $2 OFFSET $3;

-- name: ListUnprocessedReports :many
SELECT * FROM outage_reports
WHERE status = 'unprocessed'
ORDER BY reported_at DESC
LIMIT $1 OFFSET $2;

-- name: CreateOutageReport :one
INSERT INTO outage_reports (
    reported_by,
    linked_outage_id,
    description,
    image_url,
    location,
    status
) VALUES (
    $1, $2, $3, $4, $5, $6
)
RETURNING *;

-- name: UpdateOutageReport :one
UPDATE outage_reports
SET 
    reported_by = $2,
    linked_outage_id = $3,
    description = $4,
    image_url = $5,
    location = $6,
    status = $7,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateOutageReportStatus :one
UPDATE outage_reports
SET 
    status = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: LinkOutageReportToOutage :one
UPDATE outage_reports
SET 
    linked_outage_id = $2,
    status = 'processed_as_duplicate',
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteOutageReport :exec
DELETE FROM outage_reports
WHERE id = $1;

-- name: CountOutageReportsByStatus :one
SELECT status, COUNT(*) AS count
FROM outage_reports
GROUP BY status;

-- name: SearchOutageReportsNearLocation :many
SELECT * FROM outage_reports
WHERE ST_DWithin(location, $1, $2) -- $1 is point geometry, $2 is distance in meters
ORDER BY reported_at DESC
LIMIT $3 OFFSET $4;

-- name: GetReportsForOutage :many
SELECT * FROM outage_reports
WHERE linked_outage_id = $1
ORDER BY reported_at DESC;

-- name: GetRecentReportsInArea :many
SELECT * FROM outage_reports
WHERE ST_Within(location, $1) -- $1 is polygon geometry
AND reported_at >= NOW() - INTERVAL '24 hours'
ORDER BY reported_at DESC;

-- name: UpdateReportCountForOutage :exec
UPDATE outages 
SET number_of_reports = (
    SELECT COUNT(*) 
    FROM outage_reports 
    WHERE linked_outage_id = $1
)
WHERE id = $1;