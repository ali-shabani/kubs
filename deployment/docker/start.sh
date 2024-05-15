#!/bin/sh

## create external resources if doesn't exist
sh ./create-external-resources.sh

## make a copy of the latest docker-compose as green deployment
cp deployment/docker/infrastructure/docker-compose.yml deployment/docker/infrastructure/docker-compose.green.yml
sed -i 's/blue-network/green-network/g' deployment/docker/infrastructure/docker-compose.green.yml

## start the green deployment
BLUE_COMPOSE="docker compose --env-file .env -f deployment/docker/infrastructure/docker-compose.yml"
GREEN_COMPOSE="docker compose --env-file .env -f deployment/docker/infrastructure/docker-compose.green.yml"
$GREEN_COMPOSE up -d
# docker compose --env-file .env -f deployment/docker/proxy/docker-compose.yml up -d

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
  sed -i 's/blue-network/green-network/g' deployment/docker/proxy/docker-compose.yml
  docker compose --env-file .env -f deployment/docker/proxy/docker-compose.yml
else
  echo "Not all services became healthy within the time limit. for green deployment"
  exit 1
fi

$BLUE_COMPOSE up -d

if check_health "$BLUE_COMPOSE"; then
  sed -i 's/green-network/blue-network/g' deployment/docker/proxy/docker-compose.yml
  docker compose --env-file .env -f deployment/docker/proxy/docker-compose.yml
  $GREEN_COMPOSE down
else
  echo "Not all services became healthy within the time limit. for blue deployment"
  exit 1
fi