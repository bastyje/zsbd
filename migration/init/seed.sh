#!/usr/bin/env bash

for file in /liquibase/migration/seed/*.sql
do
  echo "Processing $file"
  psql -h $DB_HOSTNAME -U postgres -d ms -f $file > /dev/null 2>&1
done
