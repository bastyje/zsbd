#!/usr/bin/env bash

SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
command="$SQLCMD -S tcp:$DB_HOSTNAME,1433 -U sa -P $DB_PASSWORD -d ms -C"

# analyst
$command -Q "GRANT SELECT ON SCHEMA::patient TO analyst"

# importer
$command -Q "GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::patient TO importer"
