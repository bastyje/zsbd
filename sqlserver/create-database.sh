#!/usr/bin/env bash

SQLCMD="/opt/mssql-tools18/bin/sqlcmd"
command="$SQLCMD -U sa -P $SA_PASSWORD -C"

result=1
err=1
i=0

while [[ $i -lt 60 ]] && [[ $err -ne 0 ]]; do
  echo "Waiting for SQL Server to start"
	i=$i+1
	$command -t 1 -Q "SET NOCOUNT ON; Select SUM(state) from sys.databases"
	err=$?
	sleep 1
done

if [ $err -ne 0 ]; then
	echo "SQL Server took more than 60 seconds to start up or one or more databases are not in an ONLINE state"
	exit 1
fi

command="$SQLCMD -U sa -P $SA_PASSWORD -C"

$command -Q "CREATE DATABASE ms"
echo "Database created: $?"

$command -d ms -Q "CREATE SCHEMA liquibase"
echo "Schema created: $?"

touch /tmp/db.initialized