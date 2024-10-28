#!/usr/bin/env bash

# analyst
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT USAGE ON SCHEMA patient TO analyst;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT SELECT ON ALL TABLES IN SCHEMA patient TO analyst;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER DEFAULT PRIVILEGES IN SCHEMA patient GRANT SELECT ON TABLES TO analyst;"

# importer
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT USAGE ON SCHEMA patient TO importer;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA patient TO importer;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA patient TO importer;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER DEFAULT PRIVILEGES IN SCHEMA patient GRANT INSERT, UPDATE, DELETE, SELECT ON TABLES TO importer;"
psql -h $DB_HOSTNAME -U postgres -d ms -c "ALTER DEFAULT PRIVILEGES IN SCHEMA patient GRANT USAGE, SELECT ON SEQUENCES TO importer;"