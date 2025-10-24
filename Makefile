.PHONY: help up down restart logs ps clean shell exec init backup restore db-stats db-create db-list db-drop db-export db-import

# Default target
help:
	@echo "Docker Stack Management"
	@echo "======================"
	@echo ""
	@echo "General Commands:"
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
	@echo "Database Commands:"
	@echo "  make backup <service>          - Backup database"
	@echo "  make restore <service> <file>  - Restore database from backup"
	@echo "  make db-stats <service>        - Show database statistics"
	@echo "  make db-create <service> <db>  - Create a new database"
	@echo "  make db-list <service>         - List all databases"
	@echo "  make db-drop <service> <db>    - Drop a database"
	@echo "  make db-export <service> <db>  - Export database to SQL file"
	@echo "  make db-import <service> <file> - Import SQL file to database"
	@echo ""
	@echo "Available services:"
	@echo "  - mysql"
	@echo "  - mssql-server"
	@echo "  - postgresql"
	@echo "  - redis"
	@echo "  - mongodb"
	@echo "  - minio"
	@echo "  - mailhog"
	@echo "  - mlflow"
	@echo "  - qdrant"
	@echo "  - chromadb"
	@echo "  - metabase"
	@echo "  - kafka"
	@echo "  - labelstudio"
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
	@for dir in mysql mssql-server postgresql redis mongodb minio mailhog mlflow qdrant chromadb metabase kafka labelstudio; do \
		if [ -d "$$dir" ]; then \
			echo "Starting $$dir..."; \
			cd $$dir && docker compose up -d && cd ..; \
		fi; \
	done
	@echo "All services started!"

# Stop all services
down-all:
	@echo "Stopping all services..."
	@for dir in mysql mssql-server postgresql redis mongodb minio mailhog mlflow qdrant chromadb metabase kafka labelstudio; do \
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
	@for dir in mysql mssql-server postgresql redis mongodb minio mailhog mlflow qdrant chromadb metabase kafka labelstudio; do \
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
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C; \
				;; \
			minio) \
				echo "Opening MinIO container shell..."; \
				cd $$SERVICE && docker compose exec minio sh; \
				;; \
			mailhog) \
				echo "MailHog has no interactive shell. Access Web UI at http://localhost:8025"; \
				;; \
			mlflow) \
				echo "MLflow has no interactive shell. Access Web UI at http://localhost:5000"; \
				;; \
			qdrant) \
				echo "Qdrant has no interactive shell. Access Web UI at http://localhost:6333/dashboard"; \
				;; \
			chromadb) \
				echo "ChromaDB has no interactive shell. Access API at http://localhost:8000"; \
				;; \
			metabase) \
				echo "Metabase has no interactive shell. Access Web UI at http://localhost:3001"; \
				;; \
			kafka) \
				echo "Opening Kafka container shell..."; \
				cd $$SERVICE && docker compose exec kafka bash; \
				;; \
			labelstudio) \
				echo "Label Studio has no interactive shell. Access Web UI at http://localhost:8082"; \
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
	@for dir in mysql mssql-server postgresql redis mongodb minio mailhog mlflow qdrant chromadb metabase kafka labelstudio; do \
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

# Backup database
backup:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make backup <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	mkdir -p backups/$$SERVICE; \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Backing up PostgreSQL database..."; \
				cd $$SERVICE && docker compose exec -T postgres-db pg_dumpall -U $${POSTGRES_USER:-postgres} > ../backups/$$SERVICE/backup_$$TIMESTAMP.sql; \
				echo "✓ Backup saved to backups/$$SERVICE/backup_$$TIMESTAMP.sql"; \
				;; \
			mysql) \
				echo "Backing up MySQL database..."; \
				cd $$SERVICE && docker compose exec -T mysql-db mysqldump -u$${MYSQL_USER:-testuser} -p$${MYSQL_PASSWORD:-testpassword} --all-databases > ../backups/$$SERVICE/backup_$$TIMESTAMP.sql; \
				echo "✓ Backup saved to backups/$$SERVICE/backup_$$TIMESTAMP.sql"; \
				;; \
			mongodb) \
				echo "Backing up MongoDB database..."; \
				cd $$SERVICE && docker compose exec -T mongodb mongodump --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --archive > ../backups/$$SERVICE/backup_$$TIMESTAMP.archive; \
				echo "✓ Backup saved to backups/$$SERVICE/backup_$$TIMESTAMP.archive"; \
				;; \
			mssql-server) \
				echo "Backing up MS SQL Server database..."; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec -T sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "BACKUP DATABASE [master] TO DISK = '/var/opt/mssql/backup_$$TIMESTAMP.bak'" && \
				docker compose cp sql-server-db:/var/opt/mssql/backup_$$TIMESTAMP.bak ../backups/$$SERVICE/backup_$$TIMESTAMP.bak; \
				echo "✓ Backup saved to backups/$$SERVICE/backup_$$TIMESTAMP.bak"; \
				;; \
			*) \
				echo "Backup not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Restore database from backup
restore:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name and backup file"; \
		echo "Usage: make restore <service> <backup-file>"; \
		exit 1; \
	fi
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	SERVICE=$$(echo $$ARGS | awk '{print $$1}'); \
	BACKUP_FILE=$$(echo $$ARGS | awk '{print $$2}'); \
	if [ -z "$$BACKUP_FILE" ]; then \
		echo "Error: Please specify a backup file"; \
		echo "Usage: make restore <service> <backup-file>"; \
		exit 1; \
	fi; \
	if [ ! -f "$$BACKUP_FILE" ]; then \
		echo "Error: Backup file '$$BACKUP_FILE' not found"; \
		exit 1; \
	fi; \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Restoring PostgreSQL database from $$BACKUP_FILE..."; \
				cd $$SERVICE && cat ../$$BACKUP_FILE | docker compose exec -T postgres-db psql -U $${POSTGRES_USER:-postgres}; \
				echo "✓ Database restored successfully"; \
				;; \
			mysql) \
				echo "Restoring MySQL database from $$BACKUP_FILE..."; \
				cd $$SERVICE && cat ../$$BACKUP_FILE | docker compose exec -T mysql-db mysql -u$${MYSQL_USER:-testuser} -p$${MYSQL_PASSWORD:-testpassword}; \
				echo "✓ Database restored successfully"; \
				;; \
			mongodb) \
				echo "Restoring MongoDB database from $$BACKUP_FILE..."; \
				cd $$SERVICE && cat ../$$BACKUP_FILE | docker compose exec -T mongodb mongorestore --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --archive; \
				echo "✓ Database restored successfully"; \
				;; \
			mssql-server) \
				echo "Restoring MS SQL Server database from $$BACKUP_FILE..."; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose cp ../$$BACKUP_FILE sql-server-db:/var/opt/mssql/restore.bak && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "RESTORE DATABASE [master] FROM DISK = '/var/opt/mssql/restore.bak'"; \
				echo "✓ Database restored successfully"; \
				;; \
			*) \
				echo "Restore not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Show database statistics
db-stats:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make db-stats <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "PostgreSQL Database Statistics:"; \
				cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -d $${POSTGRES_DB:-testdb} -c "\l+"; \
				echo ""; \
				echo "Table Sizes:"; \
				cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -d $${POSTGRES_DB:-testdb} -c "SELECT schemaname, tablename, pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size FROM pg_tables WHERE schemaname NOT IN ('pg_catalog', 'information_schema') ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC LIMIT 10;"; \
				;; \
			mysql) \
				echo "MySQL Database Statistics:"; \
				cd $$SERVICE && MYSQL_ROOT_PASSWORD=$$(grep "^MYSQL_ROOT_PASSWORD=" .env | cut -d "=" -f2) && docker compose exec mysql-db mysql -uroot -p"$$MYSQL_ROOT_PASSWORD" -e "SELECT table_schema AS 'Database', ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)' FROM information_schema.tables GROUP BY table_schema;"; \
				;; \
			mongodb) \
				echo "MongoDB Database Statistics:"; \
				cd $$SERVICE && docker compose exec mongodb mongosh --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --eval "db.adminCommand('listDatabases')"; \
				;; \
			redis) \
				echo "Redis Statistics:"; \
				cd $$SERVICE && docker compose exec redis redis-cli -a $${REDIS_PASSWORD:-redispassword} INFO stats; \
				echo ""; \
				echo "Memory Info:"; \
				cd $$SERVICE && docker compose exec redis redis-cli -a $${REDIS_PASSWORD:-redispassword} INFO memory; \
				;; \
			mssql-server) \
				echo "MS SQL Server Database Statistics:"; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "SELECT name, state_desc, recovery_model_desc, (size * 8.0 / 1024) AS Size_MB FROM sys.databases;"; \
				;; \
			*) \
				echo "Statistics not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Create a new database
db-create:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name and database name"; \
		echo "Usage: make db-create <service> <database-name>"; \
		exit 1; \
	fi
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	SERVICE=$$(echo $$ARGS | awk '{print $$1}'); \
	DBNAME=$$(echo $$ARGS | awk '{print $$2}'); \
	if [ -z "$$DBNAME" ]; then \
		echo "Error: Please specify a database name"; \
		echo "Usage: make db-create <service> <database-name>"; \
		exit 1; \
	fi; \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Creating PostgreSQL database '$$DBNAME'..."; \
				cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -c "CREATE DATABASE $$DBNAME;"; \
				echo "✓ Database '$$DBNAME' created successfully"; \
				;; \
			mysql) \
				echo "Creating MySQL database '$$DBNAME'..."; \
				cd $$SERVICE && MYSQL_ROOT_PASSWORD=$$(grep "^MYSQL_ROOT_PASSWORD=" .env | cut -d "=" -f2) && docker compose exec mysql-db mysql -uroot -p"$$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE \`$$DBNAME\`;"; \
				echo "✓ Database '$$DBNAME' created successfully"; \
				;; \
			mongodb) \
				echo "Creating MongoDB database '$$DBNAME'..."; \
				cd $$SERVICE && docker compose exec mongodb mongosh --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --eval "use $$DBNAME; db.createCollection('init');"; \
				echo "✓ Database '$$DBNAME' created successfully"; \
				;; \
			mssql-server) \
				echo "Creating MS SQL Server database '$$DBNAME'..."; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "CREATE DATABASE [$$DBNAME];"; \
				echo "✓ Database '$$DBNAME' created successfully"; \
				;; \
			*) \
				echo "Database creation not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# List all databases
db-list:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name"; \
		echo "Usage: make db-list <service>"; \
		exit 1; \
	fi
	@SERVICE=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "PostgreSQL Databases:"; \
				cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -c "\l"; \
				;; \
			mysql) \
				echo "MySQL Databases:"; \
				cd $$SERVICE && MYSQL_ROOT_PASSWORD=$$(grep "^MYSQL_ROOT_PASSWORD=" .env | cut -d "=" -f2) && docker compose exec mysql-db mysql -uroot -p"$$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"; \
				;; \
			mongodb) \
				echo "MongoDB Databases:"; \
				cd $$SERVICE && docker compose exec mongodb mongosh --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --eval "show dbs"; \
				;; \
			redis) \
				echo "Redis Databases (showing key counts):"; \
				cd $$SERVICE && docker compose exec redis redis-cli -a $${REDIS_PASSWORD:-redispassword} INFO keyspace; \
				;; \
			mssql-server) \
				echo "MS SQL Server Databases:"; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "SELECT name, database_id, create_date FROM sys.databases;"; \
				;; \
			*) \
				echo "Database listing not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Drop a database
db-drop:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name and database name"; \
		echo "Usage: make db-drop <service> <database-name>"; \
		exit 1; \
	fi
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	SERVICE=$$(echo $$ARGS | awk '{print $$1}'); \
	DBNAME=$$(echo $$ARGS | awk '{print $$2}'); \
	if [ -z "$$DBNAME" ]; then \
		echo "Error: Please specify a database name"; \
		echo "Usage: make db-drop <service> <database-name>"; \
		exit 1; \
	fi; \
	if [ -d "$$SERVICE" ]; then \
		printf "Are you sure you want to drop database '$$DBNAME'? This cannot be undone! [y/N] "; \
		read REPLY; \
		case "$$REPLY" in \
			[Yy]|[Yy][Ee][Ss]) \
				case "$$SERVICE" in \
					postgresql) \
						echo "Dropping PostgreSQL database '$$DBNAME'..."; \
						cd $$SERVICE && docker compose exec postgres-db psql -U $${POSTGRES_USER:-postgres} -c "DROP DATABASE $$DBNAME;"; \
						echo "✓ Database '$$DBNAME' dropped successfully"; \
						;; \
					mysql) \
						echo "Dropping MySQL database '$$DBNAME'..."; \
						cd $$SERVICE && MYSQL_ROOT_PASSWORD=$$(grep "^MYSQL_ROOT_PASSWORD=" .env | cut -d "=" -f2) && docker compose exec mysql-db mysql -uroot -p"$$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE \`$$DBNAME\`;"; \
						echo "✓ Database '$$DBNAME' dropped successfully"; \
						;; \
					mongodb) \
						echo "Dropping MongoDB database '$$DBNAME'..."; \
						cd $$SERVICE && docker compose exec mongodb mongosh --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --eval "use $$DBNAME; db.dropDatabase();"; \
						echo "✓ Database '$$DBNAME' dropped successfully"; \
						;; \
					mssql-server) \
						echo "Dropping MS SQL Server database '$$DBNAME'..."; \
						cd $$SERVICE && \
						SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
						docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "DROP DATABASE [$$DBNAME];"; \
						echo "✓ Database '$$DBNAME' dropped successfully"; \
						;; \
					*) \
						echo "Database drop not supported for $$SERVICE"; \
						exit 1; \
						;; \
				esac; \
				;; \
			*) \
				echo "Operation cancelled."; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Export specific database to SQL file
db-export:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name and database name"; \
		echo "Usage: make db-export <service> <database-name>"; \
		exit 1; \
	fi
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	SERVICE=$$(echo $$ARGS | awk '{print $$1}'); \
	DBNAME=$$(echo $$ARGS | awk '{print $$2}'); \
	TIMESTAMP=$$(date +%Y%m%d_%H%M%S); \
	if [ -z "$$DBNAME" ]; then \
		echo "Error: Please specify a database name"; \
		echo "Usage: make db-export <service> <database-name>"; \
		exit 1; \
	fi; \
	mkdir -p exports/$$SERVICE; \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Exporting PostgreSQL database '$$DBNAME'..."; \
				cd $$SERVICE && docker compose exec -T postgres-db pg_dump -U $${POSTGRES_USER:-postgres} $$DBNAME > ../exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.sql; \
				echo "✓ Database exported to exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.sql"; \
				;; \
			mysql) \
				echo "Exporting MySQL database '$$DBNAME'..."; \
				cd $$SERVICE && docker compose exec -T mysql-db mysqldump -u$${MYSQL_USER:-testuser} -p$${MYSQL_PASSWORD:-testpassword} $$DBNAME > ../exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.sql; \
				echo "✓ Database exported to exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.sql"; \
				;; \
			mongodb) \
				echo "Exporting MongoDB database '$$DBNAME'..."; \
				cd $$SERVICE && docker compose exec -T mongodb mongodump --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --db=$$DBNAME --archive > ../exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.archive; \
				echo "✓ Database exported to exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.archive"; \
				;; \
			mssql-server) \
				echo "Exporting MS SQL Server database '$$DBNAME'..."; \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -Q "BACKUP DATABASE [$$DBNAME] TO DISK = '/var/opt/mssql/$${DBNAME}_$$TIMESTAMP.bak'" && \
				docker compose cp sql-server-db:/var/opt/mssql/$${DBNAME}_$$TIMESTAMP.bak ../exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.bak; \
				echo "✓ Database exported to exports/$$SERVICE/$${DBNAME}_$$TIMESTAMP.bak"; \
				;; \
			*) \
				echo "Database export not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Import SQL file to database
db-import:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "Error: Please specify a service name and SQL file"; \
		echo "Usage: make db-import <service> <sql-file>"; \
		exit 1; \
	fi
	@ARGS="$(filter-out $@,$(MAKECMDGOALS))"; \
	SERVICE=$$(echo $$ARGS | awk '{print $$1}'); \
	SQL_FILE=$$(echo $$ARGS | awk '{print $$2}'); \
	if [ -z "$$SQL_FILE" ]; then \
		echo "Error: Please specify a SQL file"; \
		echo "Usage: make db-import <service> <sql-file>"; \
		exit 1; \
	fi; \
	if [ ! -f "$$SQL_FILE" ]; then \
		echo "Error: SQL file '$$SQL_FILE' not found"; \
		exit 1; \
	fi; \
	if [ -d "$$SERVICE" ]; then \
		case "$$SERVICE" in \
			postgresql) \
				echo "Importing to PostgreSQL from $$SQL_FILE..."; \
				cd $$SERVICE && cat ../$$SQL_FILE | docker compose exec -T postgres-db psql -U $${POSTGRES_USER:-postgres} -d $${POSTGRES_DB:-testdb}; \
				echo "✓ SQL file imported successfully"; \
				;; \
			mysql) \
				echo "Importing to MySQL from $$SQL_FILE..."; \
				cd $$SERVICE && cat ../$$SQL_FILE | docker compose exec -T mysql-db mysql -u$${MYSQL_USER:-testuser} -p$${MYSQL_PASSWORD:-testpassword} $${MYSQL_DATABASE:-testdb}; \
				echo "✓ SQL file imported successfully"; \
				;; \
			mongodb) \
				echo "Importing to MongoDB from $$SQL_FILE..."; \
				cd $$SERVICE && cat ../$$SQL_FILE | docker compose exec -T mongodb mongorestore --username=$${MONGO_ROOT_USERNAME:-admin} --password=$${MONGO_ROOT_PASSWORD:-password} --authenticationDatabase=admin --archive; \
				echo "✓ Archive file imported successfully"; \
				;; \
			mssql-server) \
				echo "Importing to MS SQL Server from $$SQL_FILE..."; \
				BASENAME=$$(basename $$SQL_FILE); \
				cd $$SERVICE && \
				SA_PASSWORD=$$(grep MSSQL_SA_PASSWORD .env | cut -d '=' -f2) && \
				docker compose cp ../$$SQL_FILE sql-server-db:/var/opt/mssql/$$BASENAME && \
				docker compose exec sql-server-db /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$$SA_PASSWORD" -No -C -i /var/opt/mssql/$$BASENAME; \
				echo "✓ SQL file imported successfully"; \
				;; \
			*) \
				echo "Database import not supported for $$SERVICE"; \
				exit 1; \
				;; \
		esac; \
	else \
		echo "Error: Service '$$SERVICE' not found"; \
		exit 1; \
	fi

# Catch-all target to prevent make from complaining about unknown targets
%:
	@:
