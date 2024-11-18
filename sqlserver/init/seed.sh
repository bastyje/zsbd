#!/usr/bin/env bash

SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
command="$SQLCMD -S tcp:$DB_HOSTNAME,1433 -U sa -P $DB_PASSWORD -d ms -C"

for file in /liquibase/migration/seed/*.sql
do
  echo "Processing $file"
  $command -i $file > /dev/null 2>&1
done
