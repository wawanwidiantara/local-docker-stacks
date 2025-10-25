# n8n - Workflow Automation

n8n is a free and open workflow automation tool that allows you to connect different services and automate tasks.

---

## 🚀 Quick Start

```bash
make init                    # Create .env file
make up n8n                  # Start n8n
```

Access n8n at: **http://localhost:5678**

---

## 📋 Configuration

### Environment Variables

Edit `.env` file in the `n8n/` directory:

```bash
# Port configuration
N8N_PORT=5678

# Protocol and host configuration
N8N_PROTOCOL=http
N8N_HOST=localhost

# Webhook URL
WEBHOOK_URL=http://localhost:5678/

# Timezone
GENERIC_TIMEZONE=UTC

# Basic authentication
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=admin

# Encryption key
N8N_ENCRYPTION_KEY=n8n-encryption-key-change-me
```

---

## 🔐 Default Credentials

- **URL**: http://localhost:5678
- **Username**: `admin` (configured in .env)
- **Password**: `admin` (configured in .env)

> ⚠️ **Security Warning**: Change the default username, password, and encryption key in production!

---

## 🛠️ Common Operations

### Start n8n

```bash
make up n8n
```

### Stop n8n

```bash
make down n8n
```

### View Logs

```bash
make logs n8n
```

### Restart n8n

```bash
make restart n8n
```

### Check Status

```bash
make ps n8n
```

### Clean (Remove All Data)

```bash
make clean n8n
```

---

## 🌐 Connecting with Other Services

n8n is configured to use the `local-dev-network`, allowing it to communicate with other services.

### Examples

Connect to PostgreSQL:

- Host: `postgres-container`
- Port: `5432`
- User: `postgres`
- Password: `postgres`

Connect to MySQL:

- Host: `mysql-container`
- Port: `3306`
- User: `testuser`
- Password: `testpassword`

Connect to MongoDB:

- Connection String: `mongodb://admin:password@mongo-container:27017`

Connect to Redis:

- Host: `redis-container`
- Port: `6379`
- Password: `redispassword`

---

## 📊 Features

- **Visual Workflow Builder**: Create workflows with a drag-and-drop interface
- **400+ Integrations**: Connect with popular services and APIs
- **Self-Hosted**: Full control over your data
- **Webhook Support**: Trigger workflows via webhooks
- **Scheduling**: Run workflows on a schedule
- **Error Handling**: Built-in error workflows
- **Credential Management**: Secure credential storage

---

## 🔧 Advanced Configuration

### Custom Port

To use a different port, edit the `N8N_PORT` in `.env`:

```bash
N8N_PORT=8080
```

Then restart:

```bash
make restart n8n
```

### Timezone Configuration

Change the timezone in `.env`:

```bash
GENERIC_TIMEZONE=America/New_York
```

### Webhook Configuration

For external webhooks, update the `WEBHOOK_URL`:

```bash
WEBHOOK_URL=https://your-domain.com/
```

### Disable Basic Authentication

To disable basic authentication (not recommended):

```bash
N8N_BASIC_AUTH_ACTIVE=false
```

---

## 🔍 Troubleshooting

### Check Logs

```bash
make logs n8n
```

### Port Already in Use

Check what's using port 5678:

```bash
sudo lsof -i :5678
```

Change the port in `.env` if needed.

### Permission Issues

Ensure Docker has proper permissions:

```bash
make down n8n
make clean n8n
make up n8n
```

### Network Issues

Ensure the shared network exists:

```bash
docker network create local-dev-network
```

---

## 📚 Resources

- **Official Documentation**: https://docs.n8n.io/
- **Community Forum**: https://community.n8n.io/
- **Workflow Templates**: https://n8n.io/workflows/
- **GitHub Repository**: https://github.com/n8n-io/n8n

---

## ⚠️ Important Notes

1. **Encryption Key**: Always change `N8N_ENCRYPTION_KEY` to a secure random string
2. **Credentials**: Change default username and password before exposing to network
3. **Data Persistence**: Workflow data is stored in `n8n-data` volume
4. **Backup**: Use `docker volume` commands to backup n8n data
5. **Updates**: Pull latest image with `docker compose pull` before starting

---

## 💾 Data Management

### Backup n8n Data

```bash
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/n8n-backup-$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

### Restore n8n Data

```bash
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd)/backups:/backup \
  alpine sh -c "cd /data && tar xzf /backup/your-backup-file.tar.gz"
```

---

## 🔒 Security Best Practices

1. Change default credentials immediately
2. Use a strong encryption key (minimum 32 characters)
3. Keep n8n updated to the latest version
4. Use HTTPS in production (configure reverse proxy)
5. Limit network exposure
6. Regularly backup workflow data
7. Use environment-specific credentials

---

Back to [Main README](../README.md)
