-- name: GetApiKey :one
SELECT * FROM api_keys
WHERE id = $1 LIMIT 1;

-- name: GetApiKeyByPublicID :one
SELECT * FROM api_keys
WHERE public_id = $1 LIMIT 1;

-- name: GetApiKeyByApiKey :one
SELECT * FROM api_keys
WHERE api_key = $1 LIMIT 1;

-- name: ListApiKeys :many
SELECT * FROM api_keys
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListApiKeysByCreator :many
SELECT * FROM api_keys
WHERE created_by = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: ListActiveApiKeys :many
SELECT * FROM api_keys
WHERE is_active = true
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: CreateApiKey :one
INSERT INTO api_keys (
    name,
    api_key,
    secret_key,
    service_name,
    is_active,
    rate_limit_per_minute,
    created_by,
    expires_at
) VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8
)
RETURNING *;

-- name: UpdateApiKey :one
UPDATE api_keys
SET 
    name = $2,
    api_key = $3,
    secret_key = $4,
    service_name = $5,
    is_active = $6,
    rate_limit_per_minute = $7,
    expires_at = $8
WHERE id = $1
RETURNING *;

-- name: ToggleApiKeyActive :one
UPDATE api_keys
SET 
    is_active = $2
WHERE id = $1
RETURNING *;

-- name: UpdateApiKeyRateLimit :one
UPDATE api_keys
SET 
    rate_limit_per_minute = $2
WHERE id = $1
RETURNING *;

-- name: DeleteApiKey :exec
DELETE FROM api_keys
WHERE id = $1;

-- name: DeleteExpiredApiKeys :exec
DELETE FROM api_keys
WHERE expires_at < NOW();

-- name: SearchApiKeys :many
SELECT * FROM api_keys
WHERE name ILIKE '%' || $1 || '%' OR service_name ILIKE '%' || $1 || '%'
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: GetApiKeyWithCreator :one
SELECT 
    ak.*,
    p.public_id AS creator_public_id,
    p.first_name AS creator_first_name,
    p.last_name AS creator_last_name
FROM api_keys ak
LEFT JOIN profiles p ON ak.created_by = p.id
WHERE ak.id = $1;

-- name: CountApiKeysByStatus :one
SELECT is_active, COUNT(*) AS count
FROM api_keys
GROUP BY is_active;

-- name: ValidateApiKey :one
SELECT 
    ak.*,
    p.role AS creator_role
FROM api_keys ak
LEFT JOIN profiles p ON ak.created_by = p.id
WHERE ak.api_key = $1 
AND ak.is_active = true
AND (ak.expires_at IS NULL OR ak.expires_at > NOW())
LIMIT 1;

-- name: GetApiKeyUsageStats :many
SELECT 
    ak.name,
    ak.service_name,
    ak.is_active,
    ak.rate_limit_per_minute,
    ak.created_at,
    p.first_name AS creator_first_name,
    p.last_name AS creator_last_name
FROM api_keys ak
LEFT JOIN profiles p ON ak.created_by = p.id
ORDER BY ak.created_at DESC
LIMIT $1 OFFSET $2;

-- name: RotateApiKey :one
UPDATE api_keys
SET 
    api_key = $2,
    secret_key = $3,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: BulkDeactivateApiKeys :exec
UPDATE api_keys
SET is_active = false
WHERE created_by = $1;

-- name: GetApiKeysExpiringSoon :many
SELECT * FROM api_keys
WHERE expires_at BETWEEN NOW() AND NOW() + INTERVAL '7 days'
AND is_active = true
ORDER BY expires_at ASC;