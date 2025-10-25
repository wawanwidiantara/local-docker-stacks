# Local Docker Stacks

Quick access to development databases and services via Docker.

> **⚠️ Personal Use Disclaimer**  
> This repository is for my personal development workflow. Configurations prioritize convenience over best practices and are **not suitable for production use**. Use at your own discretion.

---

## ⚡ Quick Start

```bash
make init                           # Setup .env files
make up postgresql redis            # Start services
make shell postgresql               # Access database
make down postgresql redis          # Stop services
```

---

## 📦 Available Services

### 🗄️ Databases

| Service           | Port  | Quick Access              | Documentation                       |
| ----------------- | ----- | ------------------------- | ----------------------------------- |
| **PostgreSQL**    | 5432  | `make shell postgresql`   | [📖 Full Guide](docs/POSTGRESQL.md) |
| **MySQL**         | 3306  | `make shell mysql`        | [📖 Full Guide](docs/MYSQL.md)      |
| **MongoDB**       | 27017 | `make shell mongodb`      | [📖 Full Guide](docs/MONGODB.md)    |
| **Redis**         | 6379  | `make shell redis`        | [📖 Full Guide](docs/REDIS.md)      |
| **MS SQL Server** | 1433  | `make shell mssql-server` | [📖 Full Guide](docs/MSSQL.md)      |

### 🪣 Storage & Streaming

| Service   | Ports      | Web UI                | Documentation                  |
| --------- | ---------- | --------------------- | ------------------------------ |
| **MinIO** | 9000, 9001 | http://localhost:9001 | [📖 Full Guide](docs/MINIO.md) |
| **Kafka** | 9092, 8080 | http://localhost:8080 | [📖 Coming Soon]()             |

### 🤖 AI/ML & Vector DBs

| Service          | Port | Web UI                          | Documentation                         |
| ---------------- | ---- | ------------------------------- | ------------------------------------- |
| **Qdrant**       | 6333 | http://localhost:6333/dashboard | [📖 Full Guide](docs/QDRANT.md)       |
| **ChromaDB**     | 8000 | http://localhost:8000           | [📖 Coming Soon]()                    |
| **MLflow**       | 5000 | http://localhost:5000           | [📖 Full Guide](docs/MLFLOW.md)       |
| **Label Studio** | 8082 | http://localhost:8082           | [📖 Full Guide](docs/LABEL_STUDIO.md) |

### 🛠️ Tools

| Service      | Ports      | Web UI                | Documentation                    |
| ------------ | ---------- | --------------------- | -------------------------------- |
| **MailHog**  | 1025, 8025 | http://localhost:8025 | [📖 Full Guide](docs/MAILHOG.md) |
| **Metabase** | 3001       | http://localhost:3001 | [📖 Coming Soon]()               |
| **n8n**      | 5678       | http://localhost:5678 | [📖 Full Guide](docs/N8N.md)     |

---

## 🚀 Setup

### Prerequisites

- Docker & Docker Compose installed
- Make (optional, but recommended)

### Basic Usage

```bash
make init
make up postgresql redis
make down postgresql
```

### ML/AI Services Setup

MLflow, Metabase, and Label Studio need PostgreSQL + shared network:

```bash
make up postgresql
make db-create postgresql mlflow
make db-create postgresql metabase
make db-create postgresql labelstudio
docker network create local-dev-network
make up mlflow metabase labelstudio
```

---

## 📖 Common Commands

```bash
make help                           # Show all commands
make up <service>                   # Start service
make down <service>                 # Stop service
make restart <service>              # Restart service
make logs <service>                 # View logs
make shell <service>                # Access shell
make ps-all                         # Status of all services
make clean <service>                # Stop and remove volumes

# Database operations
make backup <service>               # Backup database
make restore <service> <file>       # Restore from backup
make db-list <service>              # List databases
make db-create <service> <db>       # Create database
make db-drop <service> <db>         # Drop database
make db-stats <service>             # Show statistics
make db-export <service> <db>       # Export to SQL file
make db-import <service> <file>     # Import SQL file
```

Services: `postgresql`, `mysql`, `mongodb`, `redis`, `mssql-server`, `minio`, `mailhog`, `mlflow`, `qdrant`, `chromadb`, `metabase`, `kafka`, `labelstudio`, `n8n`

---

## 🔑 Default Credentials

| Service      | URL/Port              | Credentials                   |
| ------------ | --------------------- | ----------------------------- |
| PostgreSQL   | `localhost:5432`      | `postgres` / `postgres`       |
| MySQL        | `localhost:3306`      | `testuser` / `testpassword`   |
| MongoDB      | `localhost:27017`     | `admin` / `password`          |
| Redis        | `localhost:6379`      | Password: `redispassword`     |
| MSSQL        | `localhost:1433`      | `sa` / `YourStrong!Passw0rd`  |
| MinIO        | http://localhost:9001 | `minioadmin` / `minioadmin`   |
| MailHog      | http://localhost:8025 | No auth                       |
| MLflow       | http://localhost:5000 | No auth                       |
| Metabase     | http://localhost:3001 | Setup on first login          |
| Label Studio | http://localhost:8082 | `admin@example.com` / `admin` |
| n8n          | http://localhost:5678 | `admin` / `admin`             |

Customize: Edit `.env` files in each service directory.

---

## 🌐 Connect Services

```bash
docker network create local-dev-network
```

Add to your `docker-compose.yaml`:

```yaml
networks:
  - local-dev

networks:
  local-dev:
    external: true
    name: local-dev-network
```

Container hostnames:

- PostgreSQL: `postgres-container:5432`
- MySQL: `mysql-container:3306`
- Redis: `redis-container:6379`
- MongoDB: `mongo-container:27017`
- MinIO: `minio-container:9000`

---

## 🧹 Cleanup & Troubleshooting

### Cleanup

```bash
make clean postgresql
docker system prune -a --volumes
docker volume rm postgres-data
```

### Troubleshooting

```bash
make logs <service>
sudo lsof -i :5432
docker ps
make restart <service>
```

---

## 📝 Adding Services

```bash
mkdir my-service
cd my-service
```

Create `compose.yaml` and `.env.example`, then:

```bash
make init
make up my-service
```

---

## ⚠️ Security Notice

Local development only. Not production-ready.

Missing: SSL/TLS, proper auth, secrets management, monitoring, backups.

Default credentials in `.env.example` - customize in `.env` (gitignored).

---

## 📚 Documentation

See service table above for documentation links.

---

## 📄 License

MIT License
