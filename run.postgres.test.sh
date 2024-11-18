#!/usr/bin/env bash

file="test/compose.yaml"
docker compose -f $file down -v && clear && docker compose -f $file up --build