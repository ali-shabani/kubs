#!/bin/bash

## create external resources if doesn't exist
bash "$(dirname "$0")/create-external-resources.sh"

BLUE_COMPOSE_FILE="deployment/docker/infrastructure/docker-compose.yml"
GREEN_COMPOSE_FILE="deployment/docker/infrastructure/docker-compose.green.yml"
PROXY_COMPOSE_FILE="deployment/docker/proxy/docker-compose.yml"

## make a copy of the latest docker-compose as green deployment
cp $BLUE_COMPOSE_FILE $GREEN_COMPOSE_FILE
sed -i 's/blue-network/green-network/g' $GREEN_COMPOSE_FILE

## start the green deployment
BLUE_COMPOSE="docker compose --env-file .env -f $BLUE_COMPOSE_FILE -p blue"
GREEN_COMPOSE="docker compose --env-file .env -f $GREEN_COMPOSE_FILE -p green"
PROXY_COMPOSE="docker compose --env-file .env -f $PROXY_COMPOSE_FILE"

$PROXY_COMPOSE up -d
$GREEN_COMPOSE up -d

check_health() {
  COMPOSE_CMD=$1
  end=$((SECONDS+600))
  while [ $SECONDS -lt $end ]; do
    if [ $($COMPOSE_CMD ps | grep "(healthy)" | wc -l) -eq $($COMPOSE_CMD ps | grep "Up" | wc -l) ]; then
      echo "All services are healthy."
      # Run your other command here
      return 0
    else
      echo "Not all services are healthy yet."
    fi
    sleep 15
  done
  return 1
}

## wait for the green deployment to be healthy
echo "Checking health of services..."
if check_health "$GREEN_COMPOSE"; then
  docker network disconnect blue-network proxy-caddy-1
  docker network connect green-network proxy-caddy-1
else
  echo "Not all services became healthy within the time limit. for green deployment"
  exit 1
fi

$BLUE_COMPOSE up -d

if check_health "$BLUE_COMPOSE"; then
  docker network disconnect green-network proxy-caddy-1
  docker network connect blue-network proxy-caddy-1
  $GREEN_COMPOSE down
else
  echo "Not all services became healthy within the time limit. for blue deployment"
  exit 1
fi


docker compose --env-file .env -f deployment/docker/services/docker-compose.yml up -d