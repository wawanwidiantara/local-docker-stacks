# Docker Stacks

A simple collection of Docker Compose configurations for quickly spinning up databases and services when you want to test features locally. Keep your local development environment clean without installing databases directly on your machine.

## 📦 Available Services

| Service | Version | Ports | Description |
|---------|---------|-------|-------------|
| **MySQL** | 8.4 | 3306 | Popular open-source relational database |
| **MS SQL Server** | 2022-CU14 | 1433 | Microsoft SQL Server for enterprise applications |
| **PostgreSQL** | 17-alpine | 5432 | Advanced open-source relational database |
| **Redis** | 7.4-alpine | 6379 | In-memory data structure store and cache |
| **MongoDB** | 8.0 | 27017 | NoSQL document database |
| **MinIO** | Latest Release | 9000, 9001 | S3-compatible object storage |

## 🚀 Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Make (optional, but makes things easier)

### Usage

1. Clone this repository:
```bash
git clone <your-repo-url>
cd stacks
```

2. Copy `.env.example` to each service directory as `.env` (or just use defaults):
```bash
cp .env.example mysql/.env
cp .env.example postgresql/.env
# ... etc
```

3. Start whatever you need:
```bash
make up mysql
# or
cd mysql && docker compose up -d
```

## 📖 Usage

### Using Makefile (Recommended)

The repository includes a convenient Makefile for managing all services:

```bash
# View all available commands
make help

# Start a service
make up <service-name>

# Stop a service
make down <service-name>

# Restart a service
make restart <service-name>

# View logs (follow mode)
make logs <service-name>

# Check service status
make ps <service-name>

# Stop and remove volumes (WARNING: deletes data)
make clean <service-name>

# Manage all services
make up-all      # Start all services
make down-all    # Stop all services
make ps-all      # Check status of all services
```

**Examples:**
```bash
make up mysql
make down redis
make logs mongodb
make ps postgresql
```

### Using Docker Compose Directly

Navigate to the service directory and use standard Docker Compose commands:

```bash
cd postgresql
docker compose up -d          # Start in detached mode
docker compose down           # Stop the service
docker compose logs -f        # View logs
docker compose ps             # Check status
docker compose restart        # Restart service
docker compose down -v        # Stop and remove volumes
```

## 🔧 Configuration

Each service has its own directory with:
- `compose.yaml` - Docker Compose configuration
- `.env` - Environment variables (credentials, settings)

### Service Details

#### MySQL
```bash
cd mysql
# Default credentials in .env:
# - Root Password: super_secret_root_password
# - Database: myapp_db
# - User: myapp_user
# - Password: password

# Connection string example:
mysql -h localhost -P 3306 -u myapp_user -p
```

#### MS SQL Server
```bash
cd mssql-server
# Default credentials in .env:
# - SA Password: your_Strong_P@ssw0rd!

# Connection string example:
sqlcmd -S localhost,1433 -U sa -P 'your_Strong_P@ssw0rd!'
```

#### PostgreSQL
```bash
cd postgresql
# Default credentials in .env:
# - User: postgres
# - Password: postgres_secure_password
# - Database: myapp_db

# Connection string example:
psql -h localhost -p 5432 -U postgres -d myapp_db
```

#### Redis
```bash
cd redis
# Default credentials in .env:
# - Password: redis_secure_password

# Connection example:
redis-cli -h localhost -p 6379 -a redis_secure_password
```

#### MongoDB
```bash
cd mongodb
# Default credentials in .env:
# - Root Username: admin
# - Root Password: mongo_secure_password
# - Database: myapp_db

# Connection string example:
mongodb://admin:mongo_secure_password@localhost:27017/myapp_db?authSource=admin
```

#### MinIO
```bash
cd minio
# Default credentials in .env:
# - Root User: minioadmin
# - Root Password: minioadmin_secure_password

# Access the web console:
# http://localhost:9001

# API endpoint:
# http://localhost:9000
```

## ⚠️ Security Notes

**This is for local testing only!** Don't use these configs in production without proper hardening:

- Default passwords are intentionally simple for quick local setup
- Services are exposed on localhost (be careful if you open ports publicly)
- No SSL/TLS configured
- No backup strategies included

If you need production configs, you'll want to:
- Use proper secrets management
- Add SSL/TLS certificates
- Configure firewalls and network isolation
- Set up monitoring and backups
- Use strong, unique passwords

## 📊 Health Checks

All services include health checks for monitoring:

```bash
# Check container health status
docker ps

# View health check logs
docker inspect <container-name> | grep -A 10 Health
```

## 🗂️ Data Persistence

Services use Docker volumes, so your data persists between restarts. If you want a clean slate, use `make clean <service>` to wipe everything.

## 🧹 Cleanup

### Remove a specific service and its data:
```bash
make clean <service-name>
```

### Remove all stopped containers and unused volumes:
```bash
docker system prune -a --volumes
```

## 🛠️ Troubleshooting

### Container won't start
```bash
# Check logs
make logs <service-name>

# Or
cd <service-name>
docker compose logs
```

### Port already in use
```bash
# Check what's using the port
sudo lsof -i :<port-number>

# Or modify the port in compose.yaml:
ports:
  - "3307:3306"  # Use 3307 instead of 3306
```

### Permission issues with volumes
```bash
# Check volume permissions
docker volume inspect <volume-name>

# Recreate volume (WARNING: deletes data)
docker volume rm <volume-name>
docker compose up -d
```

### Service unhealthy
```bash
# Check health status
docker ps

# View health check logs
docker inspect <container-name> --format='{{json .State.Health}}'

# Restart the service
make restart <service-name>
```

## 📝 Adding Your Own Services

Feel free to add more services following the same pattern - just create a directory with a `compose.yaml` and `.env` file.

## 📄 License

MIT License - do whatever you want with it.

---

**Just a simple repo to avoid cluttering my machine with databases I only need occasionally.**
