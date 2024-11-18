#!/usr/bin/env bash

psql -U postgres -c "CREATE DATABASE ms"
psql -U postgres -d ms -c "GRANT ALL PRIVILEGES ON DATABASE ms TO postgres"

psql -U postgres -d ms -c "CREATE SCHEMA liquibase"

# create cron job that dumps the database every 15 seconds
echo "*/15 * * * * pg_dump -U postgres ms > /var/lib/postgresql/dumps/ms-$(date +\%Y-\%m-\%d-\%H-\%M-\%S).sql" | crontab -u postgres -
# start cron
service cron start