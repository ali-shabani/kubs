#!/bin/bash

# Use pg_dump to dump the database
PGPASSWORD=$POSTGRES_PASSWORD pg_dump -h postgres -U $POSTGRES_USER -d buynow -F t > /tmp/backup.tar

# Get the current timestamp
timestamp=$(date +%Y%m%d%H%M%S)

# Upload the dump to S3
aws s3 cp /tmp/backup.tar s3://$S3_BUCKET/backup_$timestamp.tar --endpoint-url $AWS_ENDPOINT_URL