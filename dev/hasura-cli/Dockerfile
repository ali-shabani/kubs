# Start from a base image
FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl

# Install Hasura CLI
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | VERSION=v2.38.0 bash

# Set the default command
ENTRYPOINT ["hasura"]