# Microsoft SQL Server Documentation

## 📦 Service Details

| Property      | Value                                      |
| ------------- | ------------------------------------------ |
| **Version**   | 2022-latest                                |
| **Port**      | 1433                                       |
| **Container** | mssql-container                            |
| **Image**     | mcr.microsoft.com/mssql/server:2022-latest |

---

## 🎯 What is Microsoft SQL Server?

Microsoft SQL Server is a relational database management system developed by Microsoft. It's widely used in enterprise applications and supports transaction processing, business intelligence, and analytics.

### Key Features:

- 🔒 **Enterprise-Grade** - Production-ready RDBMS
- 📊 **T-SQL** - Advanced Transact-SQL support
- 🔐 **Security** - Row-level security, encryption
- 🚀 **High Performance** - In-memory OLTP
- 📈 **Business Intelligence** - Integration Services, Analysis Services
- 🌐 **Cross-Platform** - Runs on Linux and containers

---

## 🚀 Quick Start

```bash
# Start SQL Server
make up mssql-server

# Check status
make ps mssql-server

# View logs
make logs mssql-server

# Access SQL Server shell
make shell mssql-server
```

---

## 🔧 Configuration

### Environment Variables (`.env`)

```bash
# SQL Server configuration
ACCEPT_EULA=Y
MSSQL_SA_PASSWORD=YourStrong@Passw0rd
MSSQL_PID=Developer
```

⚠️ **Password Requirements:**

- At least 8 characters
- Uppercase, lowercase, digits, and special characters

---

## 🔌 Connection Details

### From Host Machine

```bash
# Using sqlcmd
sqlcmd -S localhost,1433 -U sa -P 'YourStrong@Passw0rd'

# Connection string
Server=localhost,1433;Database=master;User Id=sa;Password=YourStrong@Passw0rd;
```

### From Docker Network

```bash
# Connection string (for other containers)
Server=mssql-container,1433;Database=mydb;User Id=sa;Password=YourStrong@Passw0rd;
```

### Programming Languages

**Python (pyodbc):**

```python
import pyodbc

conn = pyodbc.connect(
    'DRIVER={ODBC Driver 18 for SQL Server};'
    'SERVER=localhost,1433;'
    'DATABASE=master;'
    'UID=sa;'
    'PWD=YourStrong@Passw0rd;'
    'TrustServerCertificate=yes'
)

cursor = conn.cursor()
cursor.execute("SELECT @@VERSION")
print(cursor.fetchone())
```

**Node.js (mssql):**

```javascript
const sql = require("mssql");

const config = {
  server: "localhost",
  port: 1433,
  user: "sa",
  password: "YourStrong@Passw0rd",
  database: "master",
  options: {
    encrypt: true,
    trustServerCertificate: true,
  },
};

const pool = await sql.connect(config);
const result = await pool.request().query("SELECT @@VERSION");
```

**C# (.NET):**

```csharp
using Microsoft.Data.SqlClient;

var connectionString = "Server=localhost,1433;Database=master;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True";

using var connection = new SqlConnection(connectionString);
connection.Open();

using var command = new SqlCommand("SELECT @@VERSION", connection);
var version = command.ExecuteScalar();
```

---

## 💡 Common Operations

### Create Database

```sql
CREATE DATABASE MyApp;
GO

USE MyApp;
GO
```

### Create User

```sql
CREATE LOGIN appuser WITH PASSWORD = 'AppUser@Pass123';
GO

USE MyApp;
GO

CREATE USER appuser FOR LOGIN appuser;
GO

ALTER ROLE db_owner ADD MEMBER appuser;
GO
```

### Backup Database

```bash
# Using sqlcmd
docker exec mssql-container /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'YourStrong@Passw0rd' \
  -Q "BACKUP DATABASE [MyApp] TO DISK = N'/var/opt/mssql/data/MyApp.bak' WITH NOFORMAT, NOINIT"

# Copy backup from container
docker cp mssql-container:/var/opt/mssql/data/MyApp.bak ./MyApp.bak
```

### Restore Database

```bash
# Copy backup to container
docker cp ./MyApp.bak mssql-container:/var/opt/mssql/data/

# Restore
docker exec mssql-container /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'YourStrong@Passw0rd' \
  -Q "RESTORE DATABASE [MyApp] FROM DISK = N'/var/opt/mssql/data/MyApp.bak' WITH REPLACE"
```

### List Databases

```sql
SELECT name FROM sys.databases;
GO
```

### List Tables

```sql
USE MyApp;
GO

SELECT * FROM INFORMATION_SCHEMA.TABLES;
GO
```

---

## 💾 Data Persistence

SQL Server data is stored in a Docker volume:

- **Volume name:** `mssql-data`
- **Location:** `/var/opt/mssql`

### Clean All Data

```bash
make clean mssql-server
```

⚠️ **Warning:** This will delete all data permanently!

---

## 🐛 Troubleshooting

### Container Exits Immediately

Check that your password meets the complexity requirements and EULA is accepted.

### Connection Refused

```bash
# Check if container is running
docker ps | grep mssql

# Check logs
make logs mssql-server

# Test connection
docker exec mssql-container /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'YourStrong@Passw0rd' -Q "SELECT @@VERSION"
```

### Check Database Sizes

```sql
SELECT
    DB_NAME(database_id) AS DatabaseName,
    (size * 8.0 / 1024) AS SizeMB
FROM sys.master_files
WHERE type = 0
ORDER BY DatabaseName;
GO
```

---

## 📚 Resources

- **Official Docs:** https://learn.microsoft.com/en-us/sql/sql-server/
- **Docker Hub:** https://hub.docker.com/_/microsoft-mssql-server
- **T-SQL Reference:** https://learn.microsoft.com/en-us/sql/t-sql/
- **SSMS Download:** https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms

---

## 🎯 Best Practices

1. **Strong passwords** - Use complex passwords (8+ chars, mixed case, numbers, symbols)
2. **Regular backups** - Schedule automated backups
3. **Connection pooling** - Use connection pools in applications
4. **Indexes** - Create indexes on frequently queried columns
5. **Query optimization** - Use execution plans to analyze queries
6. **Monitor performance** - Track wait statistics and query performance

---

## 📈 Performance Tips

```sql
-- Create index
CREATE INDEX idx_users_email ON Users(Email);
GO

-- View execution plan
SET SHOWPLAN_TEXT ON;
GO
SELECT * FROM Users WHERE Email = 'john@example.com';
GO
SET SHOWPLAN_TEXT OFF;
GO

-- Check index usage
SELECT
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
ORDER BY s.user_seeks DESC;
GO

-- Update statistics
UPDATE STATISTICS Users;
GO
```

---

**Need help?** Check the [main README](../README.md) or [SQL Server official documentation](https://learn.microsoft.com/en-us/sql/sql-server/).
