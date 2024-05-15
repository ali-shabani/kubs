#!/bin/sh

docker volume create certs
docker volume create pg-vol
docker volume create redis-vol
docker volume create emqx_certs

docker network create blue-network || true
docker network create green-network || true