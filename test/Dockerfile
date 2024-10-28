FROM alpine:latest

RUN apk update
RUN apk add postgresql-client bash

COPY . /test
RUN chmod +x -R /test

ENTRYPOINT ["/test/run-tests.sh"]
