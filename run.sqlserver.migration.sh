#!/usr/bin/env bash

file="sqlserver/compose.yaml"
docker compose -f $file up -d --no-deps --build migration