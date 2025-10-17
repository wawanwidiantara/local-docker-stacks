.PHONY: help up down restart logs ps clean shell exec init

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
	@echo "  make shell <service>   - Open shell in service container"
	@echo "  make exec <service>    - Execute command in service container"
	@echo "  make init              - Initialize all .env files from examples"
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
	@echo "  make shell postgresql"
	@echo "  make exec redis"

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

# Open interactive shell in service container
shell:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make shell <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Opening PostgreSQL shell..."; \
				cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -d $${POSTGRES_DB:-testdb}; \
				;; \
			mysql) \
				echo "Opening MySQL shell..."; \
				cd $$SERVICE && docker compose exec mysql-db mysql -u$${MYSQL_USER:-testuser} -p$${MYSQL_PASSWORD:-testpassword} $${MYSQL_DATABASE:-testdb}; \
				;; \
			mongodb) \
				echo "Opening MongoDB shell..."; \
				cd $$SERVICE && docker compose exec mongo-db mongosh -u $${MONGO_INITDB_ROOT_USERNAME:-admin} -p $${MONGO_INITDB_ROOT_PASSWORD:-password}; \
				;; \
			redis) \
				echo "Opening Redis CLI..."; \
				cd $$SERVICE && docker compose exec redis redis-cli -a $${REDIS_PASSWORD:-redispassword}; \
				;; \
			mssql-server) \
				echo "Opening MS SQL Server shell..."; \
				cd $$SERVICE && docker compose exec sql-server-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $${MSSQL_SA_PASSWORD}; \
				;; \
			minio) \
				echo "Opening MinIO container shell..."; \
				cd $$SERVICE && docker compose exec minio sh; \
				;; \
			*) \
				echo "Shell not configured for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Execute command in service container
exec:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make exec <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		echo "Opening bash shell in $$SERVICE..."; \
		cd $$SERVICE && docker compose exec $$(docker compose ps -q | head -1 | xargs docker inspect --format='{{.Name}}' | sed 's/\///') sh; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Initialize all .env files from .env.example
init:
	@echo "Initializing .env files from .env.example..."
	@for dir in mysql mssql-server postgresql redis mongodb minio; do \
		if [ -d "$$dir" ]; then \
			if [ -f "$$dir/.env.example" ] && [ ! -f "$$dir/.env" ]; then \
				cp "$$dir/.env.example" "$$dir/.env"; \
				echo "✓ Created $$dir/.env"; \
			elif [ -f "$$dir/.env" ]; then \
				echo "⊘ $$dir/.env already exists (skipped)"; \
			fi; \
		fi; \
	done
	@echo "Initialization complete!"

# Catch-all target to prevent make from complaining about unknown targets
%:
	@:
