#!/bin/bash

# Script to execute a command with retries

# Initialize default values
max_attempts=3
sleep_seconds=3

# Usage information
usage() {
  echo "Usage: $0 \"command_to_execute\" [-a attempts] [-s sleep_seconds]"
  exit 1
}

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
  usage
fi

# The first argument is the command to execute
command_to_execute="$1"
shift

# Parse remaining command line options
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -a|--attempt) max_attempts="$2"; shift ;;
    -s|--sleep) sleep_seconds="$2"; shift ;;
    *) usage ;;
  esac
  shift
done

attempt=1
while ! eval "$command_to_execute"; do
  if [ "$attempt" -ge "$max_attempts" ]; then
    echo "Attempt $attempt failed! No more attempts left."
    exit 1
  else
    echo "Attempt $attempt failed! Retrying in $sleep_seconds seconds..."
    sleep "$sleep_seconds"
  fi
  attempt=$((attempt + 1))
done

echo "Command executed successfully."