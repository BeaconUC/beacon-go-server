-- name: GetCrew :one
SELECT * FROM crews
WHERE id = $1 LIMIT 1;

-- name: GetCrewByPublicID :one
SELECT * FROM crews
WHERE public_id = $1 LIMIT 1;

-- name: ListCrews :many
SELECT * FROM crews
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListCrewsByType :many
SELECT * FROM crews
WHERE crew_type = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CreateCrew :one
INSERT INTO crews (
    name,
    crew_type,
    description
) VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: UpdateCrew :one
UPDATE crews
SET 
    name = $2,
    crew_type = $3,
    description = $4,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteCrew :exec
DELETE FROM crews
WHERE id = $1;

-- name: SearchCrews :many
SELECT * FROM crews
WHERE name ILIKE '%' || $1 || '%' OR description ILIKE '%' || $1 || '%'
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: GetCrewWithAssignments :one
SELECT 
    c.*,
    COUNT(a.id) AS active_assignments_count,
    COUNT(a.id) FILTER (WHERE a.status IN ('assigned', 'en_route', 'on_site')) AS current_assignments_count
FROM crews c
LEFT JOIN assignments a ON c.id = a.crew_id
WHERE c.id = $1
GROUP BY c.id;

-- name: GetCrewsWithAssignmentStats :many
SELECT 
    c.*,
    COUNT(a.id) AS total_assignments_count,
    COUNT(a.id) FILTER (WHERE a.status IN ('assigned', 'en_route', 'on_site')) AS current_assignments_count,
    COUNT(a.id) FILTER (WHERE a.status = 'completed') AS completed_assignments_count
FROM crews c
LEFT JOIN assignments a ON c.id = a.crew_id
GROUP BY c.id
ORDER BY c.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAvailableCrews :many
SELECT 
    c.*,
    COUNT(a.id) FILTER (WHERE a.status IN ('assigned', 'en_route', 'on_site')) AS current_assignments_count
FROM crews c
LEFT JOIN assignments a ON c.id = a.crew_id AND a.status IN ('assigned', 'en_route', 'on_site')
GROUP BY c.id
HAVING COUNT(a.id) FILTER (WHERE a.status IN ('assigned', 'en_route', 'on_site')) = 0
ORDER BY c.created_at DESC;

-- name: CountCrewsByType :one
SELECT crew_type, COUNT(*) AS count
FROM crews
GROUP BY crew_type;