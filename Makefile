COMPOSE_FILE = docker-compose.yml
SERVICE_NAME = angular-frontend
IMAGE_NAME = my-angular-nginx:latest

.PHONY: all build build-angular up down logs shell clean clean-angular clean-docker help

default: build

build: 
	@echo "Building Docker image ($(IMAGE_NAME))..."
	docker-compose -f $(COMPOSE_FILE) build

up:
	@echo "Starting services..."
	docker-compose -f $(COMPOSE_FILE) up -d

down: 
	@echo "Stopping and removing services..."
	docker-compose -f $(COMPOSE_FILE) down

logs:
	@echo "Following logs for $(SERVICE_NAME) container..."
	docker-compose -f $(COMPOSE_FILE) logs -f $(SERVICE_NAME)

shell:
	@echo "Opening shell into $(SERVICE_NAME) container..."
	docker-compose -f $(COMPOSE_FILE) exec $(SERVICE_NAME) sh

clean-angular:
	@echo "Cleaning Angular artifacts (dist, node_modules)..."
	rm -rf angular-app/dist
	rm -rf angular-app/node_modules

clean-docker: down
	@echo "Cleaning docker resources (volume, orphans)..."
	docker-compose -f $(COMPOSE_FILE) down --volumes --remove-orphans

build-angular:
	@echo "Building angular app for production..."
	(cd angular-app && npm install && npm run build -- --configuration production)

all: build up
	@echo "Image built and services started."

DEV_COMPOSE_FILE = docker-compose.dev.yml
DEV_SERVICE_NAME = angular-dev

dev-build:
	@echo "Building Development Docker image..."
	docker-compose -f $(DEV_COMPOSE_FILE) build

dev-up:
	@echo "Starting Development services..."
	docker-compose -f $(DEV_COMPOSE_FILE) up -d

dev-down:
	@echo "Stopping Development services..."
	docker-compose -f $(DEV_COMPOSE_FILE) down --volumes

dev-logs:
	@echo "Following Development logs for $(DEV_COMPOSE_FILE)... (Press Crtl+C to stop)"
	docker-compose -f $(DEV_COMPOSE_FILE) logs -f $(DEV_COMPOSE_FILE)

dev-shell:
	@echo "Opening shell into Development $(DEV_COMPOSE_FILE) container..."
	docker-compose -f $(DEV_COMPOSE_FILE) exec $(DEV_COMPOSE_FILE) sh

help:
	@echo "Available make targets:"
	@echo " build		: Build docker image"
	@echo " up		: Start services using Docker Compose (detached)"
	@echo " down 		: Stop and remove services"
	@echo " logs 		: Follow container logs"
	@echo " shell		: Open a shell inside the running container"
	@echo " clean 		: Remove Angular build artifacts"
	@echo " clean-angular	: Clean only Angular artifacts"
	@echo " clean-docker	: Clean only Docker resources (runs 'down' first)"
	@echo " build-angular	: Build only the Angular application locally"
	@echo " all 		: Build the image and start the services"
	@echo " help        : Show this help message"
	@echo ""
	@echo "Default target (if running 'make' alone) is 'build'"
	@echo ""
	@echo "Development Targets:"
	@echo " dev-build        : Build the development Docker image"
	@echo " dev-up           : Start development services (detached)"
	@echo " dev-down         : Stop development services"
	@echo " dev-logs         : Follow development container logs"
	@echo " dev-shell        : Open a shell inside the development container"
	
