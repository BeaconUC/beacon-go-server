package database

import (
	"beacon-go-server/pkg/models"
	"context"
)

type DB interface {
	Profiles() ProfilesRepository
	Outages() OutagesRepository
	Assignments() AssignmentsRepository
	Close() error
	PingContext(ctx context.Context) error
}

type ProfilesRepository interface {
	GetByID(ctx context.Context, id int64) (*models.Profile, error)
	Create(ctx context.Context, profile *models.Profile) error
	Update(ctx context.Context, profile *models.Profile) error
	Delete(ctx context.Context, id int64) error
}

type OutagesRepository interface {
	GetByID(ctx context.Context, id int64) (*models.Outage, error)
	List(ctx context.Context, limit, offset int) ([]*models.Outage, error)
	Create(ctx context.Context, outage *models.Outage) error
	Update(ctx context.Context, outage *models.Outage) error
	Delete(ctx context.Context, id int64) error
}

type AssignmentsRepository interface {
	GetByID(ctx context.Context, id int64) (*models.Assignment, error)
	Create(ctx context.Context, assignment *models.Assignment) error
	Update(ctx context.Context, assignment *models.Assignment) error
	Delete(ctx context.Context, id int64) error
}
