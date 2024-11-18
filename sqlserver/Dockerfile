FROM mcr.microsoft.com/mssql/server:2019-latest

RUN mkdir -p /usr/config
WORKDIR /usr/config

COPY ./entrypoint.sh /usr/config/entrypoint.sh
COPY ./create-database.sh /usr/config/configure-db.sh

USER root
RUN chmod +x /usr/config/entrypoint.sh
RUN chmod +x /usr/config/configure-db.sh
USER mssql

ENTRYPOINT ["./entrypoint.sh"]