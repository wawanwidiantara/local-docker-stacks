FROM ghcr.io/mlflow/mlflow:v2.16.2

# Install PostgreSQL driver and curl for health checks
RUN pip install psycopg2-binary && \
    apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /mlflow
