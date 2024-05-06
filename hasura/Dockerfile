# Use Alpine Linux as the base image
FROM alpine:latest

# Install curl and other dependencies
RUN apk add --no-cache curl bash

# Install Hasura CLI
RUN curl -L https://github.com/hasura/graphql-engine/releases/download/v2.38.1/cli-hasura-linux-amd64 -o /usr/local/bin/hasura && \
    chmod +x /usr/local/bin/hasura

# Copy the Hasura metadata folder to the container
COPY hasura /hasura

# Set the working directory to /hasura
# Set the Hasura GraphQL Engine endpoint and admin secret as environment variables
ENV HASURA_GRAPHQL_ENDPOINT=http://hasura:8080

# Use the entrypoint to apply metadata
ENTRYPOINT ["hasura", "metadata", "apply", "--endpoint", "$HASURA_GRAPHQL_ENDPOINT", "--admin-secret", "$HASURA_ADMIN_SECRET", "--project", "hasura"]