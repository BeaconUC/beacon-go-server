include .env
export $(shell sed 's/=.*//' .env)

setup:
	go get -u github.com/swaggo/swag/cmd/swag
	go install github.com/swaggo/swag/cmd/swag@latest
	swag init -g ./cmd/server/main.go -o ./docs
	go get -u github.com/swaggo/gin-swagger
	go get -u github.com/swaggo/files

build-docker:
	docker compose build --no-cache

run-local:
	docker start dockerPostgres
	docker start dockerRedis
	docker start dockerMongo
	go run cmd/server/main.go

up:
	docker compose up

down:
	docker compose down

restart:
	docker compose restart

build:
	go build -v ./...

test:
	go test -v ./... -race -cover

clean:
	docker stop beacon-go-server
	docker stop dockerPostgres
	docker rm beacon-go-server
	docker rm dockerPostgres
	docker rm dockerRedis
	docker image rm beacon-go-server-backend
	rm -rf .dbdata
