# Variables
NAME = inception
DOCKER_COMPOSE_FILE = ./srcs/docker-compose.yml

# Dynamic path to handle different users (berto, albealva, or evaluator)
USER_NAME = $(shell whoami)
DATA_PATH = /home/$(USER_NAME)/data

# Colors for terminal output
GREEN = \033[0;32m
RED = \033[0;31m
RESET = \033[0m

# Default rule
all: build up

# Create local directories and build Docker images
build:
	@echo "$(GREEN)Creating volume directories in $(DATA_PATH)...$(RESET)"
	@sudo mkdir -p $(DATA_PATH)/wordpress
	@sudo mkdir -p $(DATA_PATH)/mariadb
	@# Ensure the current user owns the data folders to avoid permission issues
	@sudo chown -R $(USER_NAME):$(USER_NAME) $(DATA_PATH)
	@echo "$(GREEN)Building Docker images...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE_FILE) build

# Start services in detached mode
up:
	@echo "$(GREEN)Starting services...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE_FILE) up -d

# Stop services
down:
	@echo "$(RED)Stopping services...$(RESET)"
	@docker compose -f $(DOCKER_COMPOSE_FILE) down

# Clean containers, networks and unused images
clean: down
	@echo "$(RED)Removing images and performing system prune...$(RESET)"
	@docker system prune -a -f

# Full clean: removes everything including volumes and physical data
fclean: clean
	@echo "$(RED)Removing Docker volumes and physical data folders...$(RESET)"
	@# Remove volumes only if they exist to prevent errors
	@if [ $$(docker volume ls -q | wc -l) -gt 0 ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi
	@sudo rm -rf $(DATA_PATH)
	@echo "$(GREEN)Full cleanup complete.$(RESET)"

# Rebuild everything from scratch
re: fclean all

.PHONY: all build up down clean fclean re