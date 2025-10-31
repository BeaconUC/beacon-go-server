package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	_ "github.com/jackc/pgx/v5/stdlib"
)

func NewPostgresDatabase() *sql.DB {
	dbHostname := os.Getenv("POSTGRES_HOST")
	dbName := os.Getenv("POSTGRES_DB")
	dbUser := os.Getenv("POSTGRES_USER")
	dbPass := os.Getenv("POSTGRES_PASSWORD")
	dbPort := os.Getenv("POSTGRES_PORT")

	dsn := fmt.Sprintf("postgres://%s:%s@%s:%s/%s", dbUser, dbPass, dbHostname, dbPort, dbName)

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
				log.Println("Database connection established successfully.")
				return db
			}
			err = pingErr
		}

		log.Printf("Attempt %d: Failed to initialize db. Retrying...", i)
		time.Sleep(3 * time.Second)
	}

	if db == nil {
		log.Fatalf("Failed to connect to db after %d attempts: %v", attempts, err)
	}

	return db
}
