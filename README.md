# Local Docker Stacks

Quick local development databases and services. Keep your machine clean - no local installations needed.

## ⚡ Quick Reference

```bash
make init                  # Setup all .env files
make up postgresql redis   # Start services
make shell postgresql      # Open psql
make ps-all                # Check status
make clean postgresql      # Remove with data
```

**Default credentials:** `postgres/postgres`, `testuser/testpassword`, `admin/password`, `redispassword`  
**Ports:** PostgreSQL (5432), MySQL (3306), MongoDB (27017), Redis (6379), MSSQL (1433), MinIO (9000, 9001)

---

## 📦 Available Services

| Service           | Version        | Ports      | Container Name     |
| ----------------- | -------------- | ---------- | ------------------ |
| **PostgreSQL**    | 17-alpine      | 5432       | postgres-container |
| **MySQL**         | 8.4            | 3306       | mysql-container    |
| **MongoDB**       | 8.0            | 27017      | mongo-container    |
| **Redis**         | 7.4-alpine     | 6379       | redis-container    |
| **MS SQL Server** | 2022-CU14      | 1433       | mssql-container    |
| **MinIO**         | Latest Release | 9000, 9001 | minio-container    |

## 🚀 Setup

**Prerequisites:** Docker, Docker Compose, Make (optional)

### First Time Setup

1. Clone this repository:

```bash
git clone <your-repo-url>
cd local-docker-stacks
```

2. Initialize environment files:

```bash
make init
```

3. (Optional) Edit credentials in `<service>/.env` files

4. Start services:

```bash
make up postgresql redis
# or
make up-all
```

## 📖 Common Commands

```bash
# Service management
make up <service>         # Start a service
make down <service>       # Stop a service
make restart <service>    # Restart a service
make logs <service>       # View logs
make ps <service>         # Check status
make clean <service>      # Stop and remove data (⚠️ deletes volumes)

# Database CLI access
make shell postgresql     # Open psql
make shell mysql          # Open mysql
make shell mongodb        # Open mongosh
make shell redis          # Open redis-cli
make shell mssql-server   # Open sqlcmd

# Container shell
make exec <service>       # Open bash/sh in container

# All services
make up-all               # Start all services
make down-all             # Stop all services
make ps-all               # Status of all services

# Help
make help                 # Show all commands
```

## 🔑 Default Credentials & Connections

### PostgreSQL

```bash
User: postgres | Password: postgres | Database: testdb
make shell postgresql
postgresql://postgres:postgres@localhost:5432/testdb
```

### MySQL

```bash
User: testuser | Password: testpassword | Database: testdb
make shell mysql
mysql://testuser:testpassword@localhost:3306/testdb
```

### MongoDB

```bash
User: admin | Password: password | Database: testdb
make shell mongodb
mongodb://admin:password@localhost:27017/testdb?authSource=admin
```

### Redis

```bash
Password: redispassword
make shell redis
redis://:redispassword@localhost:6379
```

### MS SQL Server

```bash
User: sa | Password: YourStrong!Passw0rd
make shell mssql-server
Server=localhost,1433;User Id=sa;Password=YourStrong!Passw0rd;
```

### MinIO

```bash
User: minioadmin | Password: minioadmin
Console: http://localhost:9001 | API: http://localhost:9000
```

> 💡 **Tip:** Customize credentials by editing `.env` files in each service directory

## 🌐 Inter-Service Communication

Connect services to each other (e.g., your app needs database access):

1. **Create shared network:**

```bash
docker compose -f docker-compose.network.yaml up -d
```

2. **Add to your app's `compose.yaml`:**

```yaml
networks:
  - local-dev

networks:
  local-dev:
    external: true
    name: local-dev-network
```

3. **Connect using container names:**
   - `postgres-container:5432`
   - `mysql-container:3306`
   - `redis-container:6379`
   - `mongo-container:27017`

## 🧹 Cleanup & Troubleshooting

### Cleanup

```bash
make clean postgresql              # Remove service + data
docker system prune -a --volumes   # Nuclear option
```

### Troubleshooting

```bash
make logs <service>                # Check logs
sudo lsof -i :5432                 # Check port usage
docker ps                          # Check health status
make restart <service>             # Try restart
```

### Common Issues

- **Port in use:** Change port in `compose.yaml`: `"5433:5432"`
- **Permission issues:** `docker volume rm <volume>` then restart
- **Unhealthy:** Check logs with `make logs <service>`

## 📝 Adding Custom Services

1. Create directory: `mkdir my-service && cd my-service`
2. Add `compose.yaml` and `.env.example`
3. Run: `make init && make up my-service`

See existing services for examples.

## ⚠️ Security

**Local development only!** Not production-ready:

- ✅ Has: Health checks, volume persistence, `.env` isolation
- ❌ Missing: SSL/TLS, advanced auth, production secrets, monitoring

**Credentials:** All defaults in `.env.example`, actual values in `.env` (gitignored)

## 📄 License

MIT - do whatever you want with it.

---

_Simple repo to avoid cluttering my machine with databases._
