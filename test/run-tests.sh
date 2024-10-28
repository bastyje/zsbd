#!/usr/bin/env bash

liquibase_schema="liquibase"
public_schema="public"
schemas=("patient")

source /test/scripts/migration-permissions.sh
source /test/scripts/analyst-permissions.sh
source /test/scripts/importer-permissions.sh

echo "permissions tests passed"

echo "seeding for performance tests"
for file in /test/seed/*.sql
do
  echo "running $file"
  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -f $file > /dev/null 2>&1
done