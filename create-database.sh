#!/usr/bin/env bash

psql -U postgres -c "CREATE DATABASE ms"
psql -U postgres -d ms -c "GRANT ALL PRIVILEGES ON DATABASE ms TO postgres"

psql -U postgres -d ms -c "CREATE SCHEMA liquibase"