# RustFS

S3-compatible object storage (Apache 2.0). Drop-in alternative to MinIO for local dev.

> Uses the same ports as MinIO (9000/9001). Stop one before starting the other.

## Quick start

```bash
cd rustfs && cp .env.example .env
make up rustfs
```

| Item | Value |
| --- | --- |
| S3 API | http://localhost:9000 |
| Console | http://localhost:9001 |
| Credentials | `rustfsadmin` / `rustfsadmin` (see `rustfs/.env`) |
| Container network name | `rustfs-container:9000` |

## Usage

```python
import boto3

s3 = boto3.client(
    "s3",
    endpoint_url="http://localhost:9000",
    aws_access_key_id="rustfsadmin",
    aws_secret_access_key="rustfsadmin",
    region_name="us-east-1",
)
s3.create_bucket(Bucket="demo")
```

```bash
aws --endpoint-url http://localhost:9000 s3 ls
```

## Notes

- Single-disk mode (`RUSTFS_VOLUMES=/data`). The `rustfs-init` container chowns volumes to uid 10001 then exits.
- Image is pinned to `rustfs/rustfs:1.0.3`.
- Existing MinIO data (`minio_minio-data` volume) is not migrated. Use `mc mirror` or `aws s3 sync` to copy buckets.
