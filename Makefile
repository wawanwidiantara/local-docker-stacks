.PHONY: help up down restart logs ps clean

# Default target
help:
	@echo "Docker Stack Management"
	@echo "======================"
	@echo ""
	@echo "Usage:"
	@echo "  make up <service>      - Start a service"
	@echo "  make down <service>    - Stop a service"
	@echo "  make restart <service> - Restart a service"
	@echo "  make logs <service>    - View logs of a service"
	@echo "  make ps <service>      - Show status of a service"
	@echo "  make clean <service>   - Stop and remove volumes"
	@echo "  make up-all            - Start all services"
	@echo "  make down-all          - Stop all services"
	@echo "  make ps-all            - Show status of all services"
	@echo ""
	@echo "Available services:"
	@echo "  - mysql"
	@echo "  - mssql-server"
	@echo "  - postgresql"
	@echo "  - redis"
	@echo "  - mongodb"
	@echo "  - minio"
	@echo ""
	@echo "Examples:"
	@echo "  make up mysql"
	@echo "  make down redis"
	@echo "  make logs mongodb"

# Start a specific service
up:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make up <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Starting $$SERVICE..."; \
		cd $$SERVICE && docker compose up -d; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Stop a specific service
down:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make down <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Stopping $$SERVICE..."; \
		cd $$SERVICE && docker compose down; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Restart a specific service
restart:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make restart <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Restarting $$SERVICE..."; \
		cd $$SERVICE && docker compose restart; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# View logs of a specific service
logs:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make logs <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Showing logs for $$SERVICE..."; \
		cd $$SERVICE && docker compose logs -f; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Show status of a specific service
ps:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make ps <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Status of $$SERVICE:"; \
		cd $$SERVICE && docker compose ps; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Stop and remove volumes for a specific service
clean:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make clean <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Cleaning $$SERVICE (removing volumes)..."; \
		cd $$SERVICE && docker compose down -v; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Start all services
up-all:
	@echo "Starting all services..."
	@for dir in mysql mssql-server postgresql redis mongodb minio; do \
		if [ -d "$$dir" ]; then \
			echo "Starting $$dir..."; \
			cd $$dir && docker compose up -d && cd ..; \
		fi; \
	done
	@echo "All services started!"

# Stop all services
down-all:
	@echo "Stopping all services..."
	@for dir in mysql mssql-server postgresql redis mongodb minio; do \
		if [ -d "$$dir" ]; then \
			echo "Stopping $$dir..."; \
			cd $$dir && docker compose down && cd ..; \
		fi; \
	done
	@echo "All services stopped!"

# Show status of all services
ps-all:
	@echo "Status of all services:"
	@echo "======================"
	@for dir in mysql mssql-server postgresql redis mongodb minio; do \
		if [ -d "$$dir" ]; then \
			echo ""; \
			echo "$$dir:"; \
			cd $$dir && docker compose ps && cd ..; \
		fi; \
	done

# Catch-all target to prevent make from complaining about unknown targets
%:
	@:
