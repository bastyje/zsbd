#!/usr/bin/env bash

PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "CREATE TABLE $public_schema.test_importer (id serial PRIMARY KEY, name VARCHAR(50) NOT NULL);" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "PASSED: $IMPORTER_USER cannot create table in public schema"
else
  echo "FAIL: $IMPORTER_USER can create table in public schema"
  exit 1
fi

PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "CREATE TABLE $liquibase_schema.test_importer (id serial PRIMARY KEY, name VARCHAR(50) NOT NULL);" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "PASSED: $IMPORTER_USER cannot create table in liquibase schema"
else
  echo "FAIL: $IMPORTER_USER can create table in liquibase schema"
  exit 1
fi

for schema in "${schemas[@]}"
do
  PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOSTNAME -U postgres -d ms -c "CREATE TABLE $schema.test_importer_dml (id serial PRIMARY KEY, name VARCHAR(50) NOT NULL);" > /dev/null 2>&1

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "CREATE TABLE $schema.test_importer (id serial PRIMARY KEY, name VARCHAR(50) NOT NULL);" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "PASSED: $IMPORTER_USER cannot create table in $schema schema"
  else
    echo "FAIL: $IMPORTER_USER can create table in $schema schema"
    exit 1
  fi

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "DROP TABLE $schema.test_importer_dml;" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo "PASSED: $IMPORTER_USER cannot drop table in $schema schema"
  else
    echo "FAIL: $IMPORTER_USER can drop table in $schema schema"
    exit 1
  fi

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "INSERT INTO $schema.test_importer_dml (name) VALUES ('test');" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "PASSED: $IMPORTER_USER can insert into $schema schema"
  else
    echo "FAIL: $IMPORTER_USER cannot insert into $schema schema"
    exit 1
  fi

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "UPDATE $schema.test_importer_dml SET name = 'test2' WHERE name = 'test';" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "PASSED $IMPORTER_USER can update in $schema schema"
  else
    echo "FAIL: $IMPORTER_USER cannot update in $schema schema"
    exit 1
  fi

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "DELETE FROM $schema.test_importer_dml WHERE name = 'test2';" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "PASSED: $IMPORTER_USER cannot delete from $schema schema"
  else
    echo "FAIL: $IMPORTER_USER cannot delete from $schema schema"
    exit 1
  fi

  PGPASSWORD=$IMPORTER_PASSWORD psql -h $DB_HOSTNAME -U $IMPORTER_USER -d ms -c "SELECT * FROM $schema.test_importer_dml;" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "PASSED: $IMPORTER_USER can query from $schema schema"
  else
    echo "FAIL: $IMPORTER_USER cannot query from $schema schema"
    exit 1
  fi

  PGPASSWORD=$POSTGRES_PASSWORD psql -h $DB_HOSTNAME -U postgres -d ms -c "DROP TABLE $schema.test_importer_dml;" #> /dev/null 2>&1
done