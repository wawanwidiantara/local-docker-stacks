FROM postgis/postgis:18-3.6

# Official prebuilt package via apt.postgresql.org (already configured in base image)
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql-18-pgvector \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
