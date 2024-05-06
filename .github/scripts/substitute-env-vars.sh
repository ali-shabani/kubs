#!/bin/bash

# Check if a directory has been provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

DIRECTORY=$1

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory does not exist: $DIRECTORY"
  exit 1
fi

# Iterate over all files in the directory
for file in "$DIRECTORY"/*; do
  # Check if the current item is a file
  if [ -f "$file" ]; then
    echo "Processing $file"
    # Substitute environment variables and write to a temporary file
    envsubst < "$file" > "$file.tmp"
    # Move the temporary file to replace the original file
    mv "$file.tmp" "$file"
  fi
done