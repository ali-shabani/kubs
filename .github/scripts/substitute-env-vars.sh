#!/bin/bash

# Initialize variables
DIRECTORY=""
declare -a EXCLUDE_PATTERNS

# Usage message
usage() {
  echo "Usage: $0 -d <directory> [-e <exclude-patterns>]"
  echo "Exclude patterns should be separated by commas."
  exit 1
}

# Parse command line options
while getopts "d:e:" opt; do
  case $opt in
    d) DIRECTORY=$OPTARG ;;
    e) IFS=',' read -r -a EXCLUDE_PATTERNS <<< "$OPTARG" ;;
    *) usage ;;
  esac
done

# Check if a directory has been provided
if [ -z "$DIRECTORY" ]; then
  usage
fi

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
  echo "Directory does not exist: $DIRECTORY"
  exit 1
fi

# Function to check if a file matches any exclude patterns
matches_exclude_pattern() {
  local filename=$1
  for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    if [[ $filename == *$pattern* ]]; then
      return 0 # True, pattern matches
    fi
  done
  return 1 # False, no pattern matches
}

# Iterate over all files in the directory and its subdirectories
find "$DIRECTORY" -type f | while read -r file; do
  if matches_exclude_pattern "$file"; then
    echo "Excluding $file"
    continue
  fi
  echo "Processing $file"
  # Substitute environment variables and write to a temporary file
  envsubst < "$file" > "$file.tmp"
  # Move the temporary file to replace the original file
  mv "$file.tmp" "$file"
done