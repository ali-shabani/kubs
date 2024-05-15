#!/bin/sh

echo "Starting  copy script..."

# Check if DOMAIN is set
if [ -z "${DOMAIN}" ]; then
  echo "Error: DOMAIN is not set"
  exit 1
fi

domain=${DOMAIN}

# Paths to the certificate and key files
cert_file="/caddy/certs/${domain}/${domain}.crt"
key_file="/caddy/certs/${domain}/${domain}.key"

# Path to the destination directory
dest_dir="/caddy/emqx_certs"

# Wait for the certificate and key files to exist
while [ ! -f "$cert_file" ] || [ ! -f "$key_file" ]; do
  echo "Waiting for certificate and key files..."
  sleep 5
done

# Copy the certificate and key files to the destination directory
cp "$cert_file" "$dest_dir/${domain}.crt"
cp "$key_file" "$dest_dir/${domain}.key"

# Change the ownership of the copied files to the emqx user
chown 1000:1000 "$dest_dir/${domain}.crt" "$dest_dir/${domain}.key"

echo "Certificate and key files have been copied to $dest_dir"