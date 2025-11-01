package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"beacon-go-server/pkg/database"

	_ "github.com/jackc/pgx/v5/stdlib"
)

type PostgresDatabase struct {
	*sql.DB
}

func (db *PostgresDatabase) QueryContext(ctx context.Context, query string, args ...interface{}) (*sql.Rows, error) {
	return db.DB.QueryContext(ctx, query, args...)
}

func (db *PostgresDatabase) QueryRowContext(ctx context.Context, query string, args ...interface{}) *sql.Row {
	return db.DB.QueryRowContext(ctx, query, args...)
}

func (db *PostgresDatabase) ExecContext(ctx context.Context, query string, args ...interface{}) (sql.Result, error) {
	return db.DB.ExecContext(ctx, query, args...)
}

func (db *PostgresDatabase) Close() error {
	return db.DB.Close()
}

func (db *PostgresDatabase) PingContext(ctx context.Context) error {
	return db.DB.PingContext(ctx)
}

func NewPostgresDatabase() database.DB {
	dbHostname := os.Getenv("POSTGRES_HOST")
	dbName := os.Getenv("POSTGRES_DB")
	dbUser := os.Getenv("POSTGRES_USER")
	dbPass := os.Getenv("POSTGRES_PASSWORD")
	dbPort := os.Getenv("POSTGRES_PORT")

	dsn := fmt.Sprintf("postgresql://%s:%s@%s:%s/%s", dbUser, dbPass, dbHostname, dbPort, dbName)

	var (
		db  *sql.DB
		err error
	)

	var attempts = 3
	for i := 1; i <= attempts; i++ {
		db, err = sql.Open("pgx", dsn)
		if err == nil {
			ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)

			var pingErr = db.PingContext(ctx)
			cancel()

			if pingErr == nil {
				log.Println("DB connection established successfully.")
				return &PostgresDatabase{DB: db}
			}
			err = pingErr
		}

		log.Printf("Attempt %d: Failed to initialize db. Retrying...", i)
		time.Sleep(3 * time.Second)
	}

	if db == nil {
		log.Fatalf("Failed to connect to db after %d attempts: %v", attempts, err)
	}

	return &PostgresDatabase{DB: db}
}
