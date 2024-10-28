FROM liquibase/liquibase:latest

ARG DB_HOSTNAME
ARG MIGRATION_PASSWORD

USER root

RUN apt update
RUN apt install -y postgresql-client

COPY . /liquibase/migration

RUN chmod +x /liquibase/migration/migrate.sh
RUN chmod +x -R /liquibase/migration/init
USER liquibase

ENTRYPOINT ["/liquibase/migration/migrate.sh"]
