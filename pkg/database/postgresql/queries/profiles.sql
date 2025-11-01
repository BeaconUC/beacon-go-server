-- name: GetProfile :one
SELECT * FROM profiles
WHERE id = $1 LIMIT 1;

-- name: GetProfileByPublicID :one
SELECT * FROM profiles
WHERE public_id = $1 LIMIT 1;

-- name: GetProfileByUserID :one
SELECT * FROM profiles
WHERE user_id = $1 LIMIT 1;

-- name: ListProfiles :many
SELECT * FROM profiles
ORDER BY created_at DESC
LIMIT $1 OFFSET $2;

-- name: ListProfilesByRole :many
SELECT * FROM profiles
WHERE role = $1
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CreateProfile :one
INSERT INTO profiles (
    user_id,
    first_name,
    last_name,
    role,
    phone_number
) VALUES (
    $1, $2, $3, $4, $5
)
RETURNING *;

-- name: UpdateProfile :one
UPDATE profiles
SET 
    first_name = $2,
    last_name = $3,
    role = $4,
    phone_number = $5,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: UpdateProfileRole :one
UPDATE profiles
SET 
    role = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: DeleteProfile :exec
DELETE FROM profiles
WHERE id = $1;

-- name: SearchProfiles :many
SELECT * FROM profiles
WHERE first_name ILIKE '%' || $1 || '%' OR last_name ILIKE '%' || $1 || '%'
ORDER BY created_at DESC
LIMIT $2 OFFSET $3;

-- name: CountProfilesByRole :one
SELECT role, COUNT(*) AS count
FROM profiles
GROUP BY role;

-- name: GetProfileWithSettings :one
SELECT 
    p.*,
    ps.theme,
    ps.dynamic_color,
    ps.font_scale,
    ps.reduce_motion,
    ps.language,
    ps.extra_settings
FROM profiles p
LEFT JOIN profile_settings ps ON p.id = ps.profile_id
WHERE p.id = $1;

-- name: GetProfileSettings :one
SELECT * FROM profile_settings
WHERE profile_id = $1 LIMIT 1;

-- name: CreateProfileSettings :one
INSERT INTO profile_settings (
    profile_id,
    theme,
    dynamic_color,
    font_scale,
    reduce_motion,
    language,
    extra_settings
) VALUES (
    $1, $2, $3, $4, $5, $6, $7
)
RETURNING *;

-- name: UpdateProfileSettings :one
UPDATE profile_settings
SET 
    theme = $2,
    dynamic_color = $3,
    font_scale = $4,
    reduce_motion = $5,
    language = $6,
    extra_settings = $7,
    updated_at = NOW()
WHERE profile_id = $1
RETURNING *;

-- name: UpdateProfileTheme :one
UPDATE profile_settings
SET 
    theme = $2,
    updated_at = NOW()
WHERE profile_id = $1
RETURNING *;

-- name: DeleteProfileSettings :exec
DELETE FROM profile_settings
WHERE profile_id = $1;

-- name: GetCrewProfiles :many
SELECT p.* FROM profiles p
WHERE p.role = 'crew'
ORDER BY p.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetAdminProfiles :many
SELECT p.* FROM profiles p
WHERE p.role = 'admin'
ORDER BY p.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetUserProfiles :many
SELECT p.* FROM profiles p
WHERE p.role = 'user'
ORDER BY p.created_at DESC
LIMIT $1 OFFSET $2;

-- name: GetProfileActivityStats :one
SELECT 
    p.*,
    COUNT("or".id) AS reports_submitted,
    COUNT(ou.id) AS updates_made,
    COUNT(ak.id) AS api_keys_created
FROM profiles p
LEFT JOIN outage_reports "or" ON p.id = "or".reported_by
LEFT JOIN outage_updates ou ON p.id = ou.user_id
LEFT JOIN api_keys ak ON p.id = ak.created_by
WHERE p.id = $1
GROUP BY p.id;

-- name: GetProfileAssignments :many
SELECT 
    a.*,
    o.public_id AS outage_public_id,
    o.title AS outage_title,
    o.status AS outage_status,
    c.public_id AS crew_public_id,
    c.name AS crew_name
FROM assignments a
JOIN outages o ON a.outage_id = o.id
JOIN crews c ON a.crew_id = c.id
JOIN profiles p ON c.id = p.id
WHERE p.id = $1
ORDER BY a.assigned_at DESC
LIMIT $2 OFFSET $3;