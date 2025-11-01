-- name: GetSystemConfig :one
SELECT * FROM system_config
WHERE id = $1 LIMIT 1;

-- name: GetSystemConfigByPublicID :one
SELECT * FROM system_config
WHERE public_id = $1 LIMIT 1;

-- name: GetSystemConfigByKey :one
SELECT * FROM system_config
WHERE key = $1 LIMIT 1;

-- name: ListSystemConfig :many
SELECT * FROM system_config
ORDER BY key
LIMIT $1 OFFSET $2;

-- name: CreateSystemConfig :one
INSERT INTO system_config (
    key,
    value,
    description,
    updated_by
) VALUES (
    $1, $2, $3, $4
)
RETURNING *;

-- name: UpdateSystemConfig :one
UPDATE system_config
SET 
    key = $2,
    value = $3,
    description = $4,
    updated_by = $5,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateSystemConfigByKey :one
UPDATE system_config
SET 
    value = $2,
    description = $3,
    updated_by = $4,
    updated_at = NOW()
WHERE key = $1
RETURNING *;

-- name: DeleteSystemConfig :exec
DELETE FROM system_config
WHERE id = $1;

-- name: DeleteSystemConfigByKey :exec
DELETE FROM system_config
WHERE key = $1;

-- name: SearchSystemConfig :many
SELECT * FROM system_config
WHERE key ILIKE '%' || $1 || '%' OR description ILIKE '%' || $1 || '%'
ORDER BY key
LIMIT $2 OFFSET $3;

-- name: GetSystemConfigWithUpdater :one
SELECT 
    sc.*,
    p.public_id AS updater_public_id,
    p.first_name AS updater_first_name,
    p.last_name AS updater_last_name
FROM system_config sc
LEFT JOIN profiles p ON sc.updated_by = p.id
WHERE sc.id = $1;

-- name: BulkUpdateSystemConfig :exec
UPDATE system_config AS sc SET
    value = c.value,
    description = c.description,
    updated_by = c.updated_by,
    updated_at = NOW()
FROM (VALUES 
    ($1::varchar, $2::text, $3::text, $4::bigint),
    ($5::varchar, $6::text, $7::text, $8::bigint)
) AS c(key, value, description, updated_by)
WHERE sc.key = c.key;

-- name: GetConfigValueByKey :one
SELECT value FROM system_config
WHERE key = $1;

-- name: SetConfigValueByKey :one
INSERT INTO system_config (key, value, description, updated_by)
VALUES ($1, $2, $3, $4)
ON CONFLICT (key) 
DO UPDATE SET 
    value = EXCLUDED.value,
    description = EXCLUDED.description,
    updated_by = EXCLUDED.updated_by,
    updated_at = NOW()
RETURNING *;

-- name: GetSystemSettings :many
SELECT key, value, description 
FROM system_config
WHERE key LIKE 'system.%' OR key LIKE 'app.%'
ORDER BY key;

-- name: GetNotificationSettings :many
SELECT key, value, description 
FROM system_config
WHERE key LIKE 'notification.%'
ORDER BY key;

-- name: GetApiSettings :many
SELECT key, value, description 
FROM system_config
WHERE key LIKE 'api.%'
ORDER BY key;