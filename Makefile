.PHONY: build up down restart logs clean help

# Default target
.DEFAULT_GOAL := help

# Docker compose files
DOCKER_COMPOSE = docker-compose

# Colors for help message
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)



# Help target
help:
	@echo '${GREEN}Available commands:${RESET}'
	@echo '${YELLOW}make build${RESET}      - Build Docker images'
	@echo '${YELLOW}make up${RESET}         - Start containers'
	@echo '${YELLOW}make down${RESET}       - Stop containers'
	@echo '${YELLOW}make restart${RESET}    - Restart containers'
	@echo '${YELLOW}make logs${RESET}       - View container logs'
	@echo '${YELLOW}make clean${RESET}      - Remove all containers and volumes'
	@echo ''
	@echo '${YELLOW}Environment variables:${RESET}'
	@echo '  NODE_ENV=development make up    - Start in development mode'
	@echo '  OJ_ENV=development make up      - Start in development mode'
	@echo '  Current NODE_ENV: ${NODE_ENV}'
	@echo '  Current OJ_ENV: ${OJ_ENV}'

build:
	@echo '${GREEN}Building Docker images...${RESET}'
	$(DOCKER_COMPOSE) build

up:
	@echo '${GREEN}Starting containers...${RESET}'
	$(DOCKER_COMPOSE) up -d

down:
	@echo '${GREEN}Stopping containers...${RESET}'
	$(DOCKER_COMPOSE) $(DOCKER_COMPOSE_FILE) down

restart: down up

logs:
	@echo '${GREEN}Showing container logs...${RESET}'
	$(DOCKER_COMPOSE) logs -f

clean:
	@echo '${GREEN}Cleaning up Docker resources...${RESET}'
	$(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
