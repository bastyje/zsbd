#!/usr/bin/env bash

file="sqlserver/compose.yaml"
docker compose -f $file  down -v && clear && docker compose -f $file up --build