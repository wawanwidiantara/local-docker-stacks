# Local Docker Stacks

🚀 **Quick local development databases and services** - Keep your machine clean, no local installations needed.

---

## ⚡ Quick Start

```bash
# 1. Setup environment files
make init

# 2. Start services you need
make up postgresql redis mongodb

# 3. Access services
make shell postgresql    # Open psql
make logs redis          # View logs
make ps-all              # Check all services

# 4. Stop when done
make down postgresql redis
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

---

## 🚀 Setup

### Prerequisites

- Docker & Docker Compose installed
- Make (optional, but recommended)

### Basic Usage

```bash
# Initialize .env files
make init

# Start any service
make up postgresql redis

# Stop service
make down postgresql
```

### ML/AI Services Setup

MLflow, Metabase, and Label Studio require PostgreSQL + shared network:

```bash
# 1. Start PostgreSQL
make up postgresql

# 2. Create databases
docker exec -it postgres-container psql -U postgres << EOF
CREATE DATABASE mlflow;
CREATE DATABASE metabase;
CREATE DATABASE labelstudio;
EOF

# 3. Create shared network
docker network create local-dev-network

# 4. Start ML services
make up mlflow metabase labelstudio
```

📖 **For detailed setup:** Check individual service documentation links above.

---

## 📖 Common Commands

```bash
make help                    # Show all commands
make up <service>            # Start service
make down <service>          # Stop service
make restart <service>       # Restart service
make logs <service>          # View logs
make shell <service>         # Open database CLI
make ps-all                  # Check all services status
make up-all                  # Start ALL services
make down-all                # Stop ALL services
make clean <service>         # ⚠️ Delete service + data
```

**Service names:** `postgresql`, `mysql`, `mongodb`, `redis`, `mssql-server`, `minio`, `mailhog`, `mlflow`, `qdrant`, `chromadb`, `metabase`, `kafka`, `labelstudio`

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

💡 **Customize:** Edit `.env` files in each service directory before first start.

---

## 🌐 Connect Services Together

To connect services to each other (e.g., your app accessing databases):

**1. Create shared network:**

```bash
docker network create local-dev-network
```

**2. Add to your `docker-compose.yaml`:**

```yaml
networks:
  - local-dev

networks:
  local-dev:
    external: true
    name: local-dev-network
```

**3. Use container names as hostnames:**

- PostgreSQL: `postgres-container:5432`
- MySQL: `mysql-container:3306`
- Redis: `redis-container:6379`
- MongoDB: `mongo-container:27017`
- MinIO: `minio-container:9000`

---

## 🧹 Cleanup & Troubleshooting

### Cleanup Commands

```bash
# Remove service with data
make clean postgresql

# Remove all stopped containers and volumes
docker system prune -a --volumes

# Remove specific volume
docker volume rm postgres-data
```

### Troubleshooting

```bash
# Check logs
make logs <service>

# Check what's using a port
sudo lsof -i :5432

# Check container health
docker ps

# Restart service
make restart <service>

# Check Docker resources
docker system df
```

### Common Issues

**Port already in use:**

```bash
# Change port in service's compose.yaml
ports:
  - "5433:5432"  # Use 5433 instead of 5432
```

**Permission denied:**

```bash
docker volume rm <volume-name>
make up <service>
```

**Container unhealthy:**

```bash
make logs <service>  # Check what's wrong
make restart <service>
```

---

## 📝 Adding Your Own Services

1. Create service directory:

```bash
mkdir my-service
cd my-service
```

2. Create `compose.yaml` and `.env.example`

3. Add to Makefile (optional)

4. Run:

```bash
make init
make up my-service
```

See existing services for examples!

---

## ⚠️ Security Notice

**⚡ Local development only!**

These configurations are **NOT production-ready**:

- ✅ Good for: Local dev, testing, learning
- ❌ Missing for prod: SSL/TLS, proper auth, secrets management, monitoring, backups

**Default credentials are in `.env.example` for convenience** - real values go in `.env` (gitignored).

---

## 📚 Documentation

- **Databases:** [PostgreSQL](docs/POSTGRESQL.md) • [MySQL](docs/MYSQL.md) • [MongoDB](docs/MONGODB.md) • [Redis](docs/REDIS.md) • [MSSQL](docs/MSSQL.md)
- **Storage:** [MinIO](docs/MINIO.md)
- **ML/AI:** [Label Studio](docs/LABEL_STUDIO.md) • [Other Services](NEW_SERVICES.md)
- **All Services:** See table above for links

---

## 📄 License

MIT License - Use however you want!

---

**Made with 💙 to keep my machine clean and development simple.**
