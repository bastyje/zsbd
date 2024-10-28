#! /bin/env bash

/liquibase/migration/init/users.sh
/liquibase/docker-entrypoint.sh update --password=$MIGRATION_PASSWORD --defaults-file=/liquibase/migration/liquibase.properties
/liquibase/migration/init/permissions.sh
#/liquibase/migration/init/seed.sh