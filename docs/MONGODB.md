# MongoDB Documentation

## 📦 Service Details

| Property      | Value             |
| ------------- | ----------------- |
| **Version**   | 7.0               |
| **Port**      | 27017             |
| **Container** | mongodb-container |
| **Image**     | mongo:7.0         |

---

## 🎯 What is MongoDB?

MongoDB is a source-available cross-platform document-oriented database program. As a NoSQL database, MongoDB uses JSON-like documents with optional schemas.

### Key Features:

- 📄 **Document-Oriented** - Stores data in flexible JSON documents
- 🚀 **High Performance** - Fast reads and writes
- 🔍 **Rich Queries** - Supports ad-hoc queries, indexing, aggregation
- 📊 **Horizontal Scalability** - Sharding for distributed data
- 🔄 **Replication** - Built-in replication and high availability
- 💪 **Schema Flexibility** - Dynamic schemas for unstructured data

---

## 🚀 Quick Start

```bash
# Start MongoDB
make up mongodb

# Check status
make ps mongodb

# View logs
make logs mongodb

# Access MongoDB shell
make shell mongodb
```

---

## 🔧 Configuration

### Environment Variables (`.env`)

```bash
# MongoDB credentials
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=adminpassword
MONGO_INITDB_DATABASE=myapp
```

---

## 🔌 Connection Details

### From Host Machine

```bash
# Using mongosh
mongosh mongodb://admin:adminpassword@localhost:27017/admin

# Connection URL
mongodb://admin:adminpassword@localhost:27017/myapp?authSource=admin
```

### From Docker Network

```bash
# Connection URL (for other containers)
mongodb://admin:adminpassword@mongodb-container:27017/myapp?authSource=admin
```

### Programming Languages

**Python (pymongo):**

```python
from pymongo import MongoClient

client = MongoClient(
    "mongodb://admin:adminpassword@localhost:27017/",
    authSource="admin"
)
db = client.myapp
```

**Node.js (mongodb):**

```javascript
const { MongoClient } = require("mongodb");

const client = new MongoClient(
  "mongodb://admin:adminpassword@localhost:27017",
  { authSource: "admin" }
);

await client.connect();
const db = client.db("myapp");
```

**Go (mongo-driver):**

```go
import "go.mongodb.org/mongo-driver/mongo"

client, err := mongo.Connect(ctx, options.Client().
    ApplyURI("mongodb://admin:adminpassword@localhost:27017").
    SetAuth(options.Credential{
        Username: "admin",
        Password: "adminpassword",
        AuthSource: "admin",
    }))
```

---

## 💡 Common Operations

### Create Database & Collection

```javascript
// Databases are created automatically when you insert data
use myapp;
db.users.insertOne({ name: "John", age: 30 });
```

### Create User for Database

```javascript
use myapp;
db.createUser({
  user: "appuser",
  pwd: "password",
  roles: [{ role: "readWrite", db: "myapp" }]
});
```

### Backup Database

```bash
# Backup to directory
docker exec mongodb-container mongodump \
  --username admin \
  --password adminpassword \
  --authenticationDatabase admin \
  --out /backup

# Copy backup from container
docker cp mongodb-container:/backup ./mongodb_backup
```

### Restore Database

```bash
# Copy backup to container
docker cp ./mongodb_backup mongodb-container:/backup

# Restore
docker exec mongodb-container mongorestore \
  --username admin \
  --password adminpassword \
  --authenticationDatabase admin \
  /backup
```

### List Databases

```javascript
show dbs;
```

### List Collections

```javascript
use myapp;
show collections;
```

---

## 💾 Data Persistence

MongoDB data is stored in a Docker volume:

- **Volume name:** `mongodb-data`
- **Location:** `/data/db`

### Clean All Data

```bash
make clean mongodb
```

⚠️ **Warning:** This will delete all data permanently!

---

## 🐛 Troubleshooting

### Connection Refused

```bash
# Check if container is running
docker ps | grep mongodb

# Check logs
make logs mongodb

# Restart service
make restart mongodb
```

### Authentication Failed

Make sure to specify `authSource=admin`:

```
mongodb://admin:adminpassword@localhost:27017/?authSource=admin
```

### Check Database Sizes

```javascript
use admin;
db.runCommand({ dbStats: 1 });
```

---

## 📚 Resources

- **Official Docs:** https://www.mongodb.com/docs/
- **Docker Hub:** https://hub.docker.com/_/mongo
- **MongoDB University:** https://university.mongodb.com/
- **Aggregation Pipeline:** https://www.mongodb.com/docs/manual/aggregation/

---

## 🎯 Best Practices

1. **Use indexes** - Create indexes on frequently queried fields
2. **Schema design** - Design schemas for your query patterns
3. **Connection pooling** - Reuse connections in applications
4. **Aggregation** - Use aggregation pipeline for complex queries
5. **Backup regularly** - Schedule automated backups
6. **Monitor performance** - Use MongoDB Cloud Manager or Ops Manager

---

## 📈 Performance Tips

```javascript
// Create index
db.users.createIndex({ email: 1 });

// Compound index
db.users.createIndex({ lastName: 1, firstName: 1 });

// Explain query
db.users.find({ email: "john@example.com" }).explain("executionStats");

// Check index usage
db.users.getIndexes();

// Collection stats
db.users.stats();
```

---

**Need help?** Check the [main README](../README.md) or [MongoDB official documentation](https://www.mongodb.com/docs/).
