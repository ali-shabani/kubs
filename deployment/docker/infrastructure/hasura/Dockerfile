# Use Ubuntu as the base image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Hasura CLI using the provided command
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | VERSION=v2.38.0 bash

# Copy the Hasura metadata folder to the container
COPY hasura /hasura

# Set the Hasura GraphQL Engine endpoint as an environment variable
ENV HASURA_GRAPHQL_ENDPOINT=http://hasura:8080

# Use the entrypoint to apply metadata
ENTRYPOINT ["bash", "-c", "hasura metadata apply --endpoint $HASURA_GRAPHQL_ENDPOINT --admin-secret $HASURA_ADMIN_SECRET --project hasura"]