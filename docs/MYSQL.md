# MySQL Documentation

## 📦 Service Details

| Property      | Value           |
| ------------- | --------------- |
| **Version**   | 8.0             |
| **Port**      | 3306            |
| **Container** | mysql-container |
| **Image**     | mysql:8.0       |

---

## 🎯 What is MySQL?

MySQL is the world's most popular open-source relational database. Known for its speed, reliability, and ease of use.

### Key Features:

- ⚡ **Fast Performance** - Optimized for speed
- 🔒 **ACID Compliance** - Full transaction support
- 📊 **Replication** - Master-slave and group replication
- 🔐 **Security** - SSL support, user management
- 🌐 **Cross-Platform** - Works on all major platforms
- 🚀 **Scalability** - Handles large-scale applications

---

## 🚀 Quick Start

```bash
# Start MySQL
make up mysql

# Check status
make ps mysql

# View logs
make logs mysql

# Access MySQL shell
make shell mysql

# Execute SQL command
make exec mysql "SELECT version();"
```

---

## 🔧 Configuration

### Environment Variables (`.env`)

```bash
# Database credentials
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=myapp
MYSQL_USER=myuser
MYSQL_PASSWORD=mypassword
```

### Customize Settings

Edit `mysql/.env` before first startup:

```bash
MYSQL_ROOT_PASSWORD=your_secure_password
MYSQL_DATABASE=your_database
MYSQL_USER=your_username
MYSQL_PASSWORD=your_password
```

---

## 🔌 Connection Details

### From Host Machine

```bash
# Using mysql client
mysql -h 127.0.0.1 -P 3306 -u root -p

# Connection URL
mysql://root:rootpassword@localhost:3306/myapp
```

### From Docker Network

```bash
# Connection URL (for other containers)
mysql://root:rootpassword@mysql-container:3306/myapp
```

### Programming Languages

**Python (mysql-connector):**

```python
import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    port=3306,
    database="myapp",
    user="root",
    password="rootpassword"
)
```

**Node.js (mysql2):**

```javascript
const mysql = require("mysql2/promise");

const connection = await mysql.createConnection({
  host: "localhost",
  port: 3306,
  user: "root",
  password: "rootpassword",
  database: "myapp",
});
```

**PHP:**

```php
$conn = new mysqli("localhost", "root", "rootpassword", "myapp", 3306);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
```

---

## 💡 Common Operations

### Create Database

```bash
docker exec -it mysql-container mysql -uroot -p -e "CREATE DATABASE myapp;"
```

### Create User

```bash
docker exec -it mysql-container mysql -uroot -p -e "
CREATE USER 'newuser'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON myapp.* TO 'newuser'@'%';
FLUSH PRIVILEGES;
"
```

### Backup Database

```bash
# Backup to file
docker exec mysql-container mysqldump -uroot -prootpassword myapp > backup.sql

# Backup all databases
docker exec mysql-container mysqldump -uroot -prootpassword --all-databases > backup_all.sql
```

### Restore Database

```bash
# Restore from file
docker exec -i mysql-container mysql -uroot -prootpassword myapp < backup.sql
```

### List Databases

```bash
docker exec mysql-container mysql -uroot -prootpassword -e "SHOW DATABASES;"
```

### List Tables

```bash
docker exec mysql-container mysql -uroot -prootpassword myapp -e "SHOW TABLES;"
```

---

## 💾 Data Persistence

MySQL data is stored in a Docker volume:

- **Volume name:** `mysql-data`
- **Location:** `/var/lib/mysql`

### Clean All Data

```bash
make clean mysql
```

⚠️ **Warning:** This will delete all data permanently!

---

## 🐛 Troubleshooting

### Connection Refused

```bash
# Check if container is running
docker ps | grep mysql

# Check logs
make logs mysql

# Restart service
make restart mysql
```

### Authentication Issues

MySQL 8.0 uses `caching_sha2_password` by default. For compatibility with older clients:

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
FLUSH PRIVILEGES;
```

### Check Database Sizes

```bash
docker exec mysql-container mysql -uroot -prootpassword -e "
SELECT table_schema AS 'Database',
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS 'Size (MB)'
FROM information_schema.tables
GROUP BY table_schema;
"
```

---

## 📚 Resources

- **Official Docs:** https://dev.mysql.com/doc/
- **Docker Hub:** https://hub.docker.com/_/mysql
- **MySQL Tutorial:** https://www.mysqltutorial.org/
- **Performance Schema:** https://dev.mysql.com/doc/refman/8.0/en/performance-schema.html

---

## 🎯 Best Practices

1. **Use strong passwords** for root and application users
2. **Regular backups** - Schedule automated backups
3. **Connection pooling** - Use connection pools in applications
4. **Indexes** - Add indexes for frequently queried columns
5. **Query optimization** - Use EXPLAIN to analyze queries
6. **Monitor slow queries** - Enable slow query log

---

## 📈 Performance Tips

```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- Check table status
SHOW TABLE STATUS;

-- Optimize table
OPTIMIZE TABLE your_table;

-- Analyze table for better query plans
ANALYZE TABLE your_table;
```

---

**Need help?** Check the [main README](../README.md) or [MySQL official documentation](https://dev.mysql.com/doc/).
