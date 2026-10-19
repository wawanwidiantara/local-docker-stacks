#!/bin/sh
# Runs once on first init of an empty data volume.
# Named 20-* so it runs after the base image's own 10_postgis.sh.
# Installs extensions into template1 (so every new database inherits them)
# and into the default database.
set -e

for db in template1 "$POSTGRES_DB"; do
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$db" <<-'SQL'
    CREATE EXTENSION IF NOT EXISTS postgis;
    CREATE EXTENSION IF NOT EXISTS vector;
SQL
done
