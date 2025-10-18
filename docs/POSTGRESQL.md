# PostgreSQL Documentation

## 📦 Service Details

| Property      | Value              |
| ------------- | ------------------ |
| **Version**   | 17-alpine          |
| **Port**      | 5432               |
| **Container** | postgres-container |
| **Image**     | postgres:17-alpine |

---

## 🎯 What is PostgreSQL?

PostgreSQL is a powerful, open-source object-relational database system with over 35 years of active development. Known for its reliability, feature robustness, and performance.

### Key Features:

- 🔒 **ACID Compliant** - Full transaction support
- 🔍 **Advanced Queries** - Complex queries, foreign keys, triggers, views
- 📊 **JSON Support** - Native JSON and JSONB data types
- 🔐 **Security** - SSL support, row-level security
- 🌐 **Extensions** - PostGIS, pg_trgm, uuid-ossp, and more
- 🚀 **Performance** - Advanced indexing, query optimization

---

## 🚀 Quick Start

```bash
# Start PostgreSQL
make up postgresql

# Check status
make ps postgresql

# View logs
make logs postgresql

# Access PostgreSQL shell
make shell postgresql

# Execute SQL command
make exec postgresql "SELECT version();"
```

---

## 🔧 Configuration

### Environment Variables (`.env`)

```bash
# Database credentials
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
```

### Customize Settings

Edit `postgresql/.env`:

```bash
POSTGRES_USER=myuser
POSTGRES_PASSWORD=securepassword
POSTGRES_DB=mydatabase
```

Then restart:

```bash
make restart postgresql
```

---

## 🔌 Connection Details

### From Host Machine

```bash
# Using psql
psql -h localhost -p 5432 -U postgres -d postgres

# Connection URL
postgresql://postgres:postgres@localhost:5432/postgres
```

### From Docker Network

```bash
# Connection URL (for other containers)
postgresql://postgres:postgres@postgres-container:5432/postgres
```

### Programming Languages

**Python (psycopg2):**

```python
import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="postgres",
    user="postgres",
    password="postgres"
)
```

**Node.js (pg):**

```javascript
const { Client } = require("pg");

const client = new Client({
  host: "localhost",
  port: 5432,
  database: "postgres",
  user: "postgres",
  password: "postgres",
});

await client.connect();
```

**Go (pgx):**

```go
import "github.com/jackc/pgx/v5"

conn, err := pgx.Connect(context.Background(),
    "postgres://postgres:postgres@localhost:5432/postgres")
```

---

## 💡 Common Operations

### Create Database

```bash
# Using make
make exec postgresql "CREATE DATABASE myapp;"

# Or using psql
docker exec -it postgres-container psql -U postgres -c "CREATE DATABASE myapp;"
```

### Create User

```bash
docker exec -it postgres-container psql -U postgres -c "
CREATE USER myuser WITH PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE myapp TO myuser;
"
```

### Backup Database

```bash
# Backup to file
docker exec postgres-container pg_dump -U postgres mydb > backup.sql

# Backup all databases
docker exec postgres-container pg_dumpall -U postgres > backup_all.sql
```

### Restore Database

```bash
# Restore from file
docker exec -i postgres-container psql -U postgres mydb < backup.sql
```

### List Databases

```bash
docker exec postgres-container psql -U postgres -c "\l"
```

### List Tables

```bash
docker exec postgres-container psql -U postgres -d mydb -c "\dt"
```

---

## 🔌 Integration with Other Services

### With MLflow

MLflow uses PostgreSQL to store experiment metadata:

```bash
# Start both services
make up postgresql mlflow

# MLflow automatically connects via local-dev-network
```

### With Metabase

Metabase uses PostgreSQL for application data and can query your databases:

```bash
# Start both services
make up postgresql metabase
```

### With Label Studio

Label Studio stores annotations and projects in PostgreSQL:

```bash
# Start both services
make up postgresql labelstudio
```

---

## 📊 Extensions

### Install Popular Extensions

```sql
-- PostGIS (geospatial)
CREATE EXTENSION postgis;

-- UUID generation
CREATE EXTENSION "uuid-ossp";

-- Full-text search
CREATE EXTENSION pg_trgm;

-- Fuzzy string matching
CREATE EXTENSION fuzzystrmatch;
```

---

## 💾 Data Persistence

PostgreSQL data is stored in a Docker volume:

- **Volume name:** `postgres-data`
- **Location:** `/var/lib/postgresql/data`

### Backup Volume

```bash
docker run --rm \
  -v postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres-volume.tar.gz /data
```

### Clean All Data

```bash
make clean postgresql
```

⚠️ **Warning:** This will delete all data permanently!

---

## 🐛 Troubleshooting

### Connection Refused

```bash
# Check if container is running
docker ps | grep postgres

# Check logs
make logs postgresql

# Restart service
make restart postgresql
```

### Permission Denied

```bash
# Reset permissions
docker exec postgres-container chown -R postgres:postgres /var/lib/postgresql/data
```

### Disk Space

```bash
# Check database sizes
docker exec postgres-container psql -U postgres -c "
SELECT pg_database.datname,
       pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM pg_database;
"
```

---

## 📚 Resources

- **Official Docs:** https://www.postgresql.org/docs/
- **Docker Hub:** https://hub.docker.com/_/postgres
- **SQL Tutorial:** https://www.postgresqltutorial.com/
- **Performance Tuning:** https://wiki.postgresql.org/wiki/Performance_Optimization

---

## 🎯 Best Practices

1. **Always use environment variables** for sensitive data
2. **Regular backups** - Use `pg_dump` or volume backups
3. **Connection pooling** - Use PgBouncer for production
4. **Monitoring** - Track query performance with `pg_stat_statements`
5. **Indexes** - Add indexes on frequently queried columns
6. **Vacuum** - PostgreSQL auto-vacuums, but monitor it

---

## 📈 Performance Tips

```sql
-- Enable query statistics
CREATE EXTENSION pg_stat_statements;

-- View slow queries
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Index usage
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
ORDER BY idx_scan;
```

---

**Need help?** Check the [main README](../README.md) or [PostgreSQL official documentation](https://www.postgresql.org/docs/).
