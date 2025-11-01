-- name: GetAssignment :one
SELECT * FROM assignments
WHERE id = $1 LIMIT 1;

-- name: GetAssignmentByPublicID :one
SELECT * FROM assignments
WHERE public_id = $1 LIMIT 1;

-- name: GetAssignmentByOutageAndCrew :one
SELECT * FROM assignments
WHERE outage_id = $1 AND crew_id = $2 LIMIT 1;

-- name: ListAssignments :many
SELECT * FROM assignments
ORDER BY assigned_at DESC
LIMIT $1 OFFSET $2;

-- name: ListAssignmentsByOutage :many
SELECT * FROM assignments
WHERE outage_id = $1
ORDER BY assigned_at DESC;

-- name: ListAssignmentsByCrew :many
SELECT * FROM assignments
WHERE crew_id = $1
ORDER BY assigned_at DESC;

-- name: ListAssignmentsByStatus :many
SELECT * FROM assignments
WHERE status = $1
ORDER BY assigned_at DESC
LIMIT $2 OFFSET $3;

-- name: ListActiveAssignments :many
SELECT * FROM assignments
WHERE status IN ('assigned', 'en_route', 'on_site', 'paused')
ORDER BY assigned_at DESC;

-- name: CreateAssignment :one
INSERT INTO assignments (
    outage_id,
    crew_id,
    status,
    notes
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateAssignment :one
UPDATE assignments
SET 
    outage_id = $2,
    crew_id = $3,
    status = $4,
    notes = $5,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateAssignmentStatus :one
UPDATE assignments
SET 
    status = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteAssignment :exec
DELETE FROM assignments
WHERE id = $1;

-- name: DeleteAssignmentByOutageAndCrew :exec
DELETE FROM assignments
WHERE outage_id = $1 AND crew_id = $2;

-- name: CountAssignmentsByStatus :one
SELECT status, COUNT(*) AS count
FROM assignments
GROUP BY status;

-- name: GetAssignmentsWithDetails :many
SELECT 
    a.*,
    o.public_id AS outage_public_id,
    o.title AS outage_title,
    o.status AS outage_status,
    c.public_id AS crew_public_id,
    c.name AS crew_name,
    c.crew_type AS crew_type
FROM assignments a
JOIN outages o ON a.outage_id = o.id
JOIN crews c ON a.crew_id = c.id
ORDER BY a.assigned_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAssignmentWithDetails :one
SELECT 
    a.*,
    o.public_id AS outage_public_id,
    o.title AS outage_title,
    o.status AS outage_status,
    o.description AS outage_description,
    c.public_id AS crew_public_id,
    c.name AS crew_name,
    c.crew_type AS crew_type,
    c.description AS crew_description
FROM assignments a
JOIN outages o ON a.outage_id = o.id
JOIN crews c ON a.crew_id = c.id
WHERE a.id = $1;

-- name: GetCrewAssignmentsWithOutageDetails :many
SELECT 
    a.*,
    o.public_id AS outage_public_id,
    o.title AS outage_title,
    o.status AS outage_status,
    o.outage_type,
    o.start_time,
    o.estimated_restoration_time
FROM assignments a
JOIN outages o ON a.outage_id = o.id
WHERE a.crew_id = $1
ORDER BY a.assigned_at DESC;

-- name: UpdateAssignmentProgress :one
UPDATE assignments
SET 
    status = $2,
    notes = COALESCE($3, notes),
    updated_at = NOW()
WHERE id = $1
RETURNING *;