# Use Alpine Linux as the base image
FROM alpine:latest

# Install curl, bash, and other dependencies
RUN apk add --no-cache curl bash

# Install Hasura CLI using the provided command
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | VERSION=v2.38.0 sh

# Copy the Hasura metadata folder to the container
COPY hasura /hasura

# Set the Hasura GraphQL Engine endpoint as an environment variable
ENV HASURA_GRAPHQL_ENDPOINT=http://hasura:8080

# Use the entrypoint to apply metadata
ENTRYPOINT ["sh", "-c", "hasura metadata apply --endpoint $HASURA_GRAPHQL_ENDPOINT --admin-secret $HASURA_ADMIN_SECRET --project hasura"]