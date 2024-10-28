#!/usr/bin/env bash

docker compose -f compose.test.yaml down -v && clear && docker compose -f compose.test.yaml up --build