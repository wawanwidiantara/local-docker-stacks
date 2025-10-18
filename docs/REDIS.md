# Redis Documentation

> **Note:** Personal development setup. Not production-ready.

## 📦 Service Details

| Property      | Value           |
| ------------- | --------------- |
| **Version**   | 7-alpine        |
| **Port**      | 6379            |
| **Container** | redis-container |
| **Image**     | redis:7-alpine  |

---

## 🎯 What is Redis?

Redis (Remote Dictionary Server) is an open-source, in-memory data structure store used as a database, cache, message broker, and streaming engine.

### Features:

- ⚡ **Fast** - Fast response times
- 💾 **In-Memory** - All data stored in RAM for speed
- 🔄 **Persistence** - Optional disk persistence (RDB, AOF)
- 📊 **Data Structures** - Strings, hashes, lists, sets, sorted sets
- 🔔 **Pub/Sub** - Publish/subscribe messaging
- 🚀 **Atomic Operations** - All operations are atomic

---

## Quick Start

```bash
# Start Redis
make up redis

# Check status
make ps redis

# View logs
make logs redis

# Access Redis CLI
make shell redis
```

---

## Configuration

### Environment Variables (`.env`)

```bash
# Redis password (optional, recommended for production)
REDIS_PASSWORD=your_redis_password
```

---

## Connection

### From Host Machine

```bash
# Using redis-cli (no password)
redis-cli -h localhost -p 6379

# With password
redis-cli -h localhost -p 6379 -a your_password

# Connection URL
redis://localhost:6379
redis://:password@localhost:6379
```

### From Docker Network

```bash
# Connection URL (for other containers)
redis://redis-container:6379
```

### Programming Languages

**Python (redis-py):**

```python
import redis

r = redis.Redis(
    host='localhost',
    port=6379,
    password='your_password',  # if password is set
    decode_responses=True
)

r.set('key', 'value')
value = r.get('key')
```

**Node.js (ioredis):**

```javascript
const Redis = require("ioredis");

const redis = new Redis({
  host: "localhost",
  port: 6379,
  password: "your_password", // if password is set
});

await redis.set("key", "value");
const value = await redis.get("key");
```

**Go (go-redis):**

```go
import "github.com/go-redis/redis/v8"

client := redis.NewClient(&redis.Options{
    Addr:     "localhost:6379",
    Password: "your_password", // if password is set
    DB:       0,
})

client.Set(ctx, "key", "value", 0)
val, err := client.Get(ctx, "key").Result()
```

---

## Common Operations

### Basic Key-Value Operations

```bash
# Set a key
SET mykey "Hello World"

# Get a key
GET mykey

# Set with expiration (10 seconds)
SETEX mykey 10 "Hello"

# Check if key exists
EXISTS mykey

# Delete a key
DEL mykey

# Get all keys (use carefully in production)
KEYS *
```

### Data Structures

```bash
# Lists
LPUSH mylist "item1"
RPUSH mylist "item2"
LRANGE mylist 0 -1

# Sets
SADD myset "member1"
SADD myset "member2"
SMEMBERS myset

# Sorted Sets
ZADD myzset 1 "one"
ZADD myzset 2 "two"
ZRANGE myzset 0 -1 WITHSCORES

# Hashes
HSET user:1 name "John"
HSET user:1 email "john@example.com"
HGETALL user:1
```

### Pub/Sub

```bash
# Subscribe to channel
SUBSCRIBE mychannel

# Publish message (in another terminal)
PUBLISH mychannel "Hello subscribers"
```

### Caching Pattern

```python
import redis
import json

r = redis.Redis(host='localhost', port=6379)

def get_user(user_id):
    # Try cache first
    cache_key = f"user:{user_id}"
    cached = r.get(cache_key)

    if cached:
        return json.loads(cached)

    # Fetch from database
    user = fetch_from_database(user_id)

    # Store in cache for 1 hour
    r.setex(cache_key, 3600, json.dumps(user))

    return user
```

---

## Data Persistence

Redis data can be persisted in two ways:

1. **RDB (Redis Database)** - Point-in-time snapshots
2. **AOF (Append Only File)** - Logs every write operation

Volume location:

- **Volume name:** `redis-data`
- **Location:** `/data`

### Clean All Data

```bash
make clean redis
```

⚠️ **Warning:** This will delete all data permanently!

---

## Troubleshooting

### Connection Refused

```bash
# Check if container is running
docker ps | grep redis

# Check logs
make logs redis

# Restart service
make restart redis
```

### Check Memory Usage

```bash
docker exec redis-container redis-cli INFO memory
```

### Clear All Data

```bash
docker exec redis-container redis-cli FLUSHALL
```

---

## 📊 Monitoring

### Server Info

```bash
# General info
redis-cli INFO

# Memory info
redis-cli INFO memory

# Statistics
redis-cli INFO stats

# Clients
redis-cli CLIENT LIST
```

### Slow Log

```bash
# Get slow queries
redis-cli SLOWLOG GET 10
```

---

## 🎯 Common Use Cases

### 1. **Session Store**

```python
# Store user session
session_id = "sess_12345"
session_data = {"user_id": 123, "username": "john"}
r.setex(session_id, 3600, json.dumps(session_data))
```

### 2. **Rate Limiting**

```python
def is_rate_limited(user_id, limit=100, window=60):
    key = f"rate_limit:{user_id}"
    current = r.incr(key)

    if current == 1:
        r.expire(key, window)

    return current > limit
```

### 3. **Leaderboard**

```python
# Add score
r.zadd("leaderboard", {user_id: score})

# Get top 10
top_10 = r.zrevrange("leaderboard", 0, 9, withscores=True)

# Get user rank
rank = r.zrevrank("leaderboard", user_id)
```

### 4. **Distributed Lock**

```python
def acquire_lock(lock_name, timeout=10):
    return r.set(lock_name, "1", nx=True, ex=timeout)

def release_lock(lock_name):
    r.delete(lock_name)
```

---

## Resources

- **Docs:** https://redis.io/docs/
- **Docker Hub:** https://hub.docker.com/_/redis
- **Redis University:** https://university.redis.com/
- **Command Reference:** https://redis.io/commands/

---

## Best Practices

1. **Set expiration times** - Use TTL to prevent memory leaks
2. **Use appropriate data structures** - Choose the right structure for your use case
3. **Monitor memory** - Redis stores everything in RAM
4. **Use pipelining** - Batch multiple commands for better performance
5. **Connection pooling** - Reuse connections in applications
6. **Avoid KEYS command** - Use SCAN instead in production

---

## Performance Tips

```bash
# Use pipelining
MULTI
SET key1 "value1"
SET key2 "value2"
SET key3 "value3"
EXEC

# Scan instead of KEYS
SCAN 0 MATCH user:* COUNT 100

# Check command performance
redis-cli --latency
redis-cli --latency-history

# Benchmark
redis-benchmark -h localhost -p 6379 -t set,get -n 100000
```

---

**Need help?** Check the [main README](../README.md) or [Redis official documentation](https://redis.io/docs/).
