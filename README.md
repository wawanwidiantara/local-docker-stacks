# Docker Stacks

A collection of production-ready Docker Compose configurations for common database and service stacks. Keep your local development environment clean and organized with isolated, easily manageable containers.

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

- Docker Engine 20.10+
- Docker Compose V2
- Make (optional, for using Makefile commands)

### Installation

1. Clone this repository:
```bash
git clone <your-repo-url>
cd stacks
```

2. Choose a service and update the `.env` file with your credentials:
```bash
cd mysql
nano .env  # or use your preferred editor
```

3. Start the service:
```bash
# Using Make
make up mysql

# Or using Docker Compose directly
cd mysql
docker compose up -d
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

## 🔐 Security Best Practices

⚠️ **IMPORTANT**: Before using in production or exposing services externally:

1. **Change all default passwords** in the `.env` files
2. **Never commit `.env` files** with real credentials to version control
3. **Use strong passwords** (minimum 16 characters, mixed case, numbers, symbols)
4. **Limit port exposure** - only expose ports you need
5. **Use Docker networks** to isolate services
6. **Regular updates** - keep images updated with security patches
7. **Enable SSL/TLS** for production deployments

### Recommended Password Generation

```bash
# Generate a secure random password
openssl rand -base64 32
```

## 📊 Health Checks

All services include health checks for monitoring:

```bash
# Check container health status
docker ps

# View health check logs
docker inspect <container-name> | grep -A 10 Health
```

## 🗂️ Data Persistence

All services use Docker volumes for data persistence:

```bash
# List all volumes
docker volume ls

# Inspect a volume
docker volume inspect <volume-name>

# Backup a volume
docker run --rm -v <volume-name>:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data

# Restore a volume
docker run --rm -v <volume-name>:/data -v $(pwd):/backup alpine tar xzf /backup/backup.tar.gz -C /
```

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

## 📝 Adding New Services

1. Create a new directory for your service:
```bash
mkdir my-new-service
cd my-new-service
```

2. Create `compose.yaml` and `.env` files following the existing patterns

3. Update the Makefile to include your new service in the loops:
```makefile
# Add to up-all, down-all, ps-all targets
@for dir in mysql mssql-server postgresql redis mongodb minio my-new-service; do
```

4. Test your service:
```bash
make up my-new-service
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Useful Links

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Hub](https://hub.docker.com/_/mysql)
- [PostgreSQL Docker Hub](https://hub.docker.com/_/postgres)
- [Redis Docker Hub](https://hub.docker.com/_/redis)
- [MongoDB Docker Hub](https://hub.docker.com/_/mongo)
- [MS SQL Server Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)
- [MinIO Documentation](https://min.io/docs/minio/container/index.html)

## ⚡ Tips & Tricks

### Connect services together
Create a custom Docker network to connect multiple services:
```bash
docker network create myapp-network
```

Then add to your compose.yaml:
```yaml
networks:
  default:
    external: true
    name: myapp-network
```

### Resource limits
Add resource constraints to prevent services from consuming all system resources:
```yaml
services:
  mysql-db:
    # ... other config
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          memory: 512M
```

### Environment-specific configs
Use multiple .env files for different environments:
```bash
# Development
docker compose --env-file .env.dev up -d

# Production
docker compose --env-file .env.prod up -d
```

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Search existing [Issues](https://github.com/your-username/stacks/issues)
3. Create a new issue with detailed information

---

**Made with ❤️ for developers who like clean environments**
