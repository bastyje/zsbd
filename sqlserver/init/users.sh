#! /bin/env bash

SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
command="$SQLCMD -S tcp:$DB_HOSTNAME,1433 -U sa -P $DB_PASSWORD -d ms -C"

# migration
$command -Q "CREATE LOGIN migration WITH PASSWORD = '$MIGRATION_PASSWORD'"
$command -Q "CREATE USER migration FOR LOGIN migration"
$command -Q "GRANT CONTROL, SELECT, INSERT, UPDATE, DELETE TO migration"

# analyst
$command -Q "CREATE LOGIN analyst WITH PASSWORD = '$ANALYST_PASSWORD'"
$command -Q "CREATE USER analyst FOR LOGIN analyst"

# importer
$command -Q "CREATE LOGIN importer WITH PASSWORD = '$IMPORTER_PASSWORD'"
$command -Q "CREATE USER importer FOR LOGIN importer"
