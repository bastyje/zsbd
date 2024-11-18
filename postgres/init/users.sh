#! /bin/env bash

# migration
psql -h $DB_HOSTNAME -U postgres -d ms -c "CREATE USER migration WITH PASSWORD '$MIGRATION_PASSWORD'"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER USER migration WITH LOGIN"
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT ALL PRIVILEGES ON DATABASE ms TO migration"
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT ALL PRIVILEGES ON SCHEMA liquibase TO migration"

# analyst
psql -h $DB_HOSTNAME -U postgres -d ms -c "CREATE USER analyst WITH PASSWORD '$ANALYST_PASSWORD'"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER USER analyst WITH LOGIN"

# importer
psql -h $DB_HOSTNAME -U postgres -d ms -c "CREATE USER importer WITH PASSWORD '$IMPORTER_PASSWORD'"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER USER importer WITH LOGIN"
