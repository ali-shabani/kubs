# Use Ubuntu as the base image
FROM ubuntu:latest

# Install Hasura CLI using the provided command
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | VERSION=v2.38.0 bash

RUN which hasura || echo "Hasura CLI not found in PATH"

# Assuming Hasura CLI is installed in /usr/local/bin (adjust if it's installed elsewhere)
# Add Hasura CLI's installation directory to PATH explicitly (if necessary)
ENV PATH="/usr/local/bin:${PATH}"

# Copy the Hasura metadata folder to the container
COPY hasura /hasura

# Set the Hasura GraphQL Engine endpoint as an environment variable
ENV HASURA_GRAPHQL_ENDPOINT=http://hasura:8080

# Use the entrypoint to apply metadata
ENTRYPOINT ["bash", "-c", "hasura metadata apply --endpoint $HASURA_GRAPHQL_ENDPOINT --admin-secret $HASURA_ADMIN_SECRET --project hasura"]