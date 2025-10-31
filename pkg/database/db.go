package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type Database interface {
	Offset(offset int) *gorm.DB
	Limit(limit int) *gorm.DB
	Find(interface{}, ...interface{}) *gorm.DB
	Create(value interface{}) *gorm.DB
	Where(query interface{}, args ...interface{}) Database
	Delete(interface{}, ...interface{}) *gorm.DB
	Model(model interface{}) *gorm.DB
	First(dest interface{}, conds ...interface{}) Database
	Updates(interface{}) *gorm.DB
	Order(value interface{}) *gorm.DB
	Error() error
}

type GormDatabase struct {
	*gorm.DB
}

func (db *GormDatabase) Where(query interface{}, args ...interface{}) Database {
	return &GormDatabase{db.DB.Where(query, args...)}
}

func (db *GormDatabase) First(dest interface{}, conds ...interface{}) Database {
	return &GormDatabase{db.DB.First(dest, conds...)}
}

func (db *GormDatabase) Error() error {
	return db.DB.Error
}

func NewDatabase() *sql.DB {
	var database *sql.DB
	var err error

	dbHostname := os.Getenv("POSTGRES_HOST")
	dbName := os.Getenv("POSTGRES_DB")
	dbUser := os.Getenv("POSTGRES_USER")
	dbPass := os.Getenv("POSTGRES_PASSWORD")
	dbPort := os.Getenv("POSTGRES_PORT")

	dbURl := fmt.Sprintf("postgres://%s:%s@%s:%s/%s", dbUser, dbPass, dbHostname, dbPort, dbName)

	var attempts = 3
	for i := 1; i <= attempts; i++ {
		database, err = gorm.Open(postgres.Open(dbURl), &gorm.Config{})
		if err == nil {
			log.Println("Database connection established successfully.")
			break
		} else {
			log.Printf("Attempt %d: Failed to initialize database. Retrying...", i)
			time.Sleep(3 * time.Second)
		}
	}

	if database == nil {
		log.Fatalf("Failed to connect to database after %d attempts.", attempts)
	}

	//database.AutoMigrate(&models.Book{})
	//database.AutoMigrate(&models.User{})

	return database
}
