# MinIO Documentation

> **Note:** Personal development setup. Not production-ready.

## 📦 Service Details

| Property         | Value              |
| ---------------- | ------------------ |
| **Version**      | latest             |
| **API Port**     | 9000               |
| **Console Port** | 9001               |
| **Container**    | minio-container    |
| **Image**        | minio/minio:latest |

---

## 🎯 What is MinIO?

MinIO is a High-Performance Object Storage system released under GNU AGPLv3. It is API compatible with Amazon S3 cloud storage service.

### Features:

- 🪣 **S3 Compatible** - Drop-in replacement for Amazon S3
- ⚡ **High Performance** - High performance
- 🌐 **Distributed** - Scale across multiple servers
- 🔐 **Secure** - Encryption at rest and in transit
- 🎨 **Web Console** - Built-in browser-based UI
- 🔄 **Versioning** - Object versioning support

---

## Quick Start

```bash
# Start MinIO
make up minio

# Check status
make ps minio

# View logs
make logs minio

# Access Web Console
# http://localhost:9001
```

---

## Configuration

### Environment Variables (`.env`)

```bash
# MinIO credentials
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
```

### Access Details

- **Web Console:** http://localhost:9001
- **API Endpoint:** http://localhost:9000
- **Username:** minioadmin
- **Password:** minioadmin

---

## Connection

### S3-Compatible Endpoint

```
http://localhost:9000
```

### Programming Languages

**Python (boto3):**

```python
import boto3

s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin',
    region_name='us-east-1'
)

# Create bucket
s3.create_bucket(Bucket='my-bucket')

# Upload file
s3.upload_file('file.txt', 'my-bucket', 'file.txt')

# Download file
s3.download_file('my-bucket', 'file.txt', 'downloaded.txt')
```

**Node.js (aws-sdk):**

```javascript
const AWS = require("aws-sdk");

const s3 = new AWS.S3({
  endpoint: "http://localhost:9000",
  accessKeyId: "minioadmin",
  secretAccessKey: "minioadmin",
  s3ForcePathStyle: true,
  signatureVersion: "v4",
});

// Create bucket
await s3.createBucket({ Bucket: "my-bucket" }).promise();

// Upload file
await s3
  .putObject({
    Bucket: "my-bucket",
    Key: "file.txt",
    Body: "Hello World",
  })
  .promise();
```

**MinIO Client (mc):**

```bash
# Install mc
brew install minio/stable/mc  # macOS
# or download from https://min.io/download

# Configure
mc alias set myminio http://localhost:9000 minioadmin minioadmin

# Create bucket
mc mb myminio/my-bucket

# Upload file
mc cp file.txt myminio/my-bucket/

# List files
mc ls myminio/my-bucket/
```

---

## Common Operations

### Using Web Console

1. Open http://localhost:9001
2. Login with minioadmin/minioadmin
3. Create buckets, upload/download files via UI

### Using MinIO Client (mc)

```bash
# List buckets
mc ls myminio

# Create bucket
mc mb myminio/images

# Upload directory
mc cp --recursive ./photos/ myminio/images/

# Download file
mc cp myminio/images/photo.jpg ./

# Remove file
mc rm myminio/images/photo.jpg

# Set bucket policy (public read)
mc anonymous set download myminio/images
```

### Using Python (boto3)

```python
import boto3
from botocore.client import Config

s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin',
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)

# List buckets
response = s3.list_buckets()
for bucket in response['Buckets']:
    print(bucket['Name'])

# List objects in bucket
response = s3.list_objects_v2(Bucket='my-bucket')
for obj in response.get('Contents', []):
    print(obj['Key'])

# Generate presigned URL (valid for 1 hour)
url = s3.generate_presigned_url(
    'get_object',
    Params={'Bucket': 'my-bucket', 'Key': 'file.txt'},
    ExpiresIn=3600
)
```

---

## Integration

### With Label Studio (Cloud Storage)

Store annotation data and media files:

```bash
# Start both services
make up minio labelstudio

# In Label Studio UI:
# Settings → Cloud Storage → Add S3
# Endpoint: http://minio-container:9000
# Bucket: label-studio-data
# Access Key: minioadmin
# Secret Key: minioadmin
```

### With MLflow (Artifact Store)

Store ML model artifacts:

```python
import mlflow

mlflow.set_tracking_uri("http://localhost:5000")

# Configure S3 for artifacts
import os
os.environ['MLFLOW_S3_ENDPOINT_URL'] = 'http://localhost:9000'
os.environ['AWS_ACCESS_KEY_ID'] = 'minioadmin'
os.environ['AWS_SECRET_ACCESS_KEY'] = 'minioadmin'

# Log artifacts
with mlflow.start_run():
    mlflow.log_artifact("model.pkl")
```

### As Static File Server

Host static assets for web applications:

```python
# Upload files
s3.upload_file('index.html', 'website', 'index.html')

# Make bucket public
s3.put_bucket_policy(
    Bucket='website',
    Policy=json.dumps({
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::website/*"
        }]
    })
)

# Access at: http://localhost:9000/website/index.html
```

---

## Data Persistence

MinIO data is stored in a Docker volume:

- **Volume name:** `minio-data`
- **Location:** `/data`

### Backup Data

```bash
# Using mc client
mc mirror myminio/my-bucket ./backup/

# Or docker volume backup
docker run --rm \
  -v minio-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/minio-volume.tar.gz /data
```

### Clean All Data

```bash
make clean minio
```

⚠️ **Warning:** This will delete all buckets and objects permanently!

---

## Troubleshooting

### Cannot Access Web Console

```bash
# Check if container is running
docker ps | grep minio

# Check logs
make logs minio

# Verify ports
curl http://localhost:9001
```

### S3 Client Connection Issues

Make sure to set `s3ForcePathStyle: true` or equivalent in your client configuration.

### Permission Denied

Check bucket policies and IAM policies in the web console.

---

## 🎯 Common Use Cases

### 1. **Backup Storage**

```python
# Automated backup script
def backup_to_minio(local_path, bucket, s3_path):
    s3.upload_file(local_path, bucket, s3_path)
    print(f"Backed up {local_path} to s3://{bucket}/{s3_path}")
```

### 2. **Image Storage for Web Apps**

```python
# Upload user avatar
def upload_avatar(user_id, file_path):
    key = f"avatars/{user_id}.jpg"
    s3.upload_file(file_path, 'user-uploads', key)

    # Generate public URL
    url = f"http://localhost:9000/user-uploads/{key}"
    return url
```

### 3. **Data Lake**

```python
# Store analytics data
def store_analytics(date, data):
    key = f"analytics/{date}/data.parquet"
    s3.put_object(
        Bucket='data-lake',
        Key=key,
        Body=data
    )
```

### 4. **Video/Media Hosting**

```python
# Upload video with metadata
s3.upload_file(
    'video.mp4',
    'media-bucket',
    'videos/video.mp4',
    ExtraArgs={
        'ContentType': 'video/mp4',
        'Metadata': {
            'title': 'My Video',
            'duration': '120'
        }
    }
)
```

---

## Resources

- **Docs:** https://min.io/docs/minio/linux/index.html
- **Docker Hub:** https://hub.docker.com/r/minio/minio
- **S3 API Reference:** https://docs.aws.amazon.com/AmazonS3/latest/API/
- **MinIO Client:** https://min.io/docs/minio/linux/reference/minio-mc.html

---

## Best Practices

1. **Use strong credentials** - Change default minioadmin password
2. **Bucket policies** - Set appropriate access policies
3. **Versioning** - Enable versioning for critical data
4. **Monitoring** - Use MinIO's built-in Prometheus metrics
5. **Lifecycle policies** - Auto-delete old objects
6. **Encryption** - Enable server-side encryption for sensitive data

---

## 📈 Advanced Features

### Bucket Versioning

```bash
# Enable versioning
mc version enable myminio/my-bucket

# List versions
mc version list myminio/my-bucket/file.txt
```

### Bucket Notifications

```bash
# Configure webhook notification
mc admin config set myminio notify_webhook:mywebhook \
  endpoint="http://example.com/webhook"

# Enable for bucket
mc event add myminio/my-bucket arn:minio:sqs::mywebhook:webhook \
  --event put
```

### Object Lifecycle

```bash
# Delete objects older than 30 days
mc ilm add --expiry-days 30 myminio/my-bucket
```

---

**Need help?** Check the [main README](../README.md) or [MinIO official documentation](https://min.io/docs/).
